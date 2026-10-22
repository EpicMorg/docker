#!/usr/bin/env python3
"""Create / refresh linux/ecosystem/apps/mariadb/<line> leaves.

MariaDB from the project's bintar tarballs on archive.mariadb.org (vendor
binaries): glibc_214 builds up to 10.4, systemd builds from 10.5 (the only
ones published there). One leaf per line in LINES at its newest patch; every
tarball is checked against its .asc signature (MariaDB signing keys KEYS) and
pinned as sha256. A new leaf is a copy of the reference leaf (REFERENCE);
existing leaves only get their version block bumped and the compose tags.

Lines (owner: "ещё и 5.5"): the supported LTS 10.11 / 11.4 / 11.8 / 12.3 and the
rolling stable 13.0, plus the ended series 5.5 and 10.0 - 10.6 for data that has
to be read or migrated; the short-term releases in between are left out.

Tags: <line>, <full>; MAJOR picks the line behind <major>; LTS -> lts, ROLLING -> latest.

Usage: bin/python/mariadb-versions-sync.py [--dry-run] [--refresh] [--only 11.8]   (needs gpg)
"""
import hashlib
import os
import re
import shutil
import subprocess
import sys
import tempfile
import urllib.request

ROOT = os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
BASE = os.path.join(ROOT, 'linux', 'ecosystem', 'apps', 'mariadb')
REFERENCE = '11.8'
ARCHIVE = 'https://archive.mariadb.org'
LINES = ('5.5', '10.0', '10.1', '10.2', '10.3', '10.4', '10.5', '10.6', '10.11', '11.4', '11.8', '12.3', '13.0')
MAJOR = {'5': '5.5', '10': '10.11', '11': '11.8', '12': '12.3', '13': '13.0'}
LTS = '12.3'
ROLLING = '13.0'
KEYS = ('177F4010FE56CA3336300305F1656F24C74CD1D8',   # MariaDB Signing Key
        '199369E5404BD5FC7D2FE43BCBCB082A1BB943DB')   # MariaDB Package Signing Key (5.5)
KEYSERVER = 'https://keyserver.ubuntu.com/pks/lookup?op=get&search=0x%s'
COPY = ('Dockerfile', 'Makefile', 'usr/local/bin/docker-entrypoint.sh', 'etc/mysql/my.cnf')


def vkey(v):
    return [int(x) for x in v.split('.')]


def get(url, binary=False):
    req = urllib.request.Request(url, headers={'User-Agent': 'curl/8.14.1'})
    data = urllib.request.urlopen(req, timeout=900).read()
    return data if binary else data.decode('utf-8', 'replace')


def flavour(line):
    return 'systemd' if vkey(line) >= [10, 5] else 'glibc_214'


def newest():
    """{line: (full, url dir, tarball)}"""
    index = get(ARCHIVE + '/')
    out = {}
    for full in set(re.findall(r'mariadb-(\d+\.\d+\.\d+)/', index)):
        line = '.'.join(full.split('.')[:2])
        if line in LINES and (line not in out or vkey(full) > vkey(out[line])):
            out[line] = full
    res = {}
    for line, full in out.items():
        fl = flavour(line)
        d = 'mariadb-%s/bintar-linux-%s-x86_64' % (full, fl)
        res[line] = (full, d, 'mariadb-%s-linux-%s-x86_64.tar.gz' % (full, fl))
    missing = set(LINES) - set(res)
    if missing:
        sys.exit('FATAL: no release for %s on %s' % (', '.join(sorted(missing)), ARCHIVE))
    return res


def sha256_checked(d, tarball, gnupg):
    url = '%s/%s/%s' % (ARCHIVE, d, tarball)
    data = get(url, binary=True)
    sig = get(url + '.asc', binary=True)
    with tempfile.TemporaryDirectory() as tmp:
        open(os.path.join(tmp, 't'), 'wb').write(data)
        open(os.path.join(tmp, 't.asc'), 'wb').write(sig)
        r = subprocess.run(['gpg', '--homedir', gnupg, '--status-fd', '1', '--verify',
                            os.path.join(tmp, 't.asc'), os.path.join(tmp, 't')], capture_output=True, text=True)
    m = re.search(r'VALIDSIG ([0-9A-F]{40})', r.stdout)
    if not m or m.group(1) not in KEYS or 'BADSIG' in r.stdout:
        sys.exit('FATAL: %s: bad or foreign signature\n%s' % (tarball, r.stdout + r.stderr))
    return hashlib.sha256(data).hexdigest()


def bump(text, line, full, d, tarball, sha):
    text = re.sub(r'^(ENV EMG_MARIADB_VERSION=).*$', r'\g<1>' + line, text, flags=re.M)
    text = re.sub(r'^(ENV EMG_MARIADB_FULL_VERSION=).*$', r'\g<1>' + full, text, flags=re.M)
    text = re.sub(r'^(ARG EMG_MARIADB_TARBALL=).*$', r'\g<1>' + tarball, text, flags=re.M)
    text = re.sub(r'^(ARG EMG_MARIADB_URL=).*$', r'\g<1>' + ARCHIVE + '/' + d, text, flags=re.M)
    return re.sub(r'^(ARG EMG_MARIADB_SHA256=).*$', r'\g<1>' + sha, text, flags=re.M)


def compose(line, full, extra):
    tags = [line, full] + extra
    out = ['services:', '  app:', '    image: "epicmorg/mariadb:%s"' % line, '    build:', '      context: .',
           '    x-squash: false', '    x-mirrors:']
    for t in tags:
        out += ['      - %s/epicmorg/mariadb:%s' % (reg, t) for reg in ('quay.io', 'ghcr.io', 'docker.io')]
    return '\n'.join(out) + '\n'


def main():
    dry = '--dry-run' in sys.argv
    refresh = '--refresh' in sys.argv
    argv = [a for a in sys.argv if a not in ('--dry-run', '--refresh')]
    args = dict(zip(argv[1::2], argv[2::2]))
    only = set(filter(None, args.get('--only', '').split(',')))
    ref = os.path.join(BASE, REFERENCE)
    found = newest()
    gnupg = tempfile.mkdtemp()
    try:
        if not dry:
            for fp in KEYS:
                subprocess.run(['gpg', '--homedir', gnupg, '--batch', '--import'], input=get(KEYSERVER % fp, binary=True),
                               check=True, capture_output=True)
        for line, (full, d, tarball) in sorted(found.items(), key=lambda x: vkey(x[0])):
            if only and line not in only:
                continue
            extra = [mj for mj, l in MAJOR.items() if l == line]
            if line == LTS:
                extra.append('lts')
            if line == ROLLING:
                extra.append('latest')
            leaf = os.path.join(BASE, line)
            new = not os.path.isdir(leaf)
            print('%-6s %-8s %-4s %-48s %s' % (line, full, 'new' if new else 'bump', tarball, ' '.join(extra)))
            if dry:
                continue
            sha = sha256_checked(d, tarball, gnupg)
            if new or (refresh and line != REFERENCE):
                for f in COPY:
                    os.makedirs(os.path.dirname(os.path.join(leaf, f)), exist_ok=True)
                    shutil.copy2(os.path.join(ref, f), os.path.join(leaf, f))
            df = os.path.join(leaf, 'Dockerfile')
            text = bump(open(df).read(), line, full, d, tarball, sha)          # read fully before 'w' truncates
            open(df, 'w').write(text)
            open(os.path.join(leaf, 'docker-compose.yml'), 'w').write(compose(line, full, extra))
    finally:
        shutil.rmtree(gnupg, ignore_errors=True)


if __name__ == '__main__':
    main()
