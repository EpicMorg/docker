#!/usr/bin/env python3
"""Create / refresh linux/ecosystem/apps/mysql/<line> leaves.

MySQL from Oracle's generic Linux tarballs (vendor binaries, like mongo):
  5.6, 5.7      final releases, glibc2.12 .tar.gz from the archives
  8.0           glibc2.28 .tar.xz (full; pruned in the image)
  8.4, 9.7      LTS lines, glibc2.28 -minimal .tar.xz
  <yy.mm>       the current Innovation release (calendar versions since 2026),
                found on the downloads page; an older Innovation leaf is reported
                for removal (Innovation releases are supported until the next one)
Newest patch per line from dev.mysql.com/downloads/mysql/<line>.html; every
tarball is checked against its .asc signature (MySQL Release Engineering keys
KEYS; the 5.x ones have expired since, the signatures are valid) and pinned as
sha256. A new leaf is a copy of the reference leaf (REFERENCE); existing leaves
only get their version block bumped and the compose tags.

Tags: <line>, <full>; 5.7 also 5, 8.4 also 8, 9.7 also 9 + lts, the Innovation
line also <yy> + innovation + latest.

Usage: bin/python/mysql-versions-sync.py [--dry-run] [--refresh] [--only 8.4,9.7]   (needs gpg)
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
BASE = os.path.join(ROOT, 'linux', 'ecosystem', 'apps', 'mysql')
REFERENCE = '8.4'
CDN = 'https://cdn.mysql.com'
PAGE = 'https://dev.mysql.com/downloads/mysql/%s?os=2'
# line -> (url dir, tarball pattern (%s = full version), fixed full version or None)
LINES = {
    '5.6': ('archives/mysql-5.6', 'mysql-%s-linux-glibc2.12-x86_64.tar.gz', '5.6.51'),
    '5.7': ('archives/mysql-5.7', 'mysql-%s-linux-glibc2.12-x86_64.tar.gz', '5.7.44'),
    '8.0': ('Downloads/MySQL-8.0', 'mysql-%s-linux-glibc2.28-x86_64.tar.xz', None),
    '8.4': ('Downloads/MySQL-8.4', 'mysql-%s-linux-glibc2.28-x86_64-minimal.tar.xz', None),
    '9.7': ('Downloads/MySQL-9.7', 'mysql-%s-linux-glibc2.28-x86_64-minimal.tar.xz', None),
}
INNOVATION = ('Downloads/MySQL-%s', 'mysql-%s-linux-glibc2.28-x86_64-minimal.tar.xz')
EXTRA = {'5.7': ['5'], '8.4': ['8'], '9.7': ['9', 'lts']}
KEYS = ('BCA43417C3B485DD128EC6D4B7B3B788A8D3785C',   # 2023-
        '859BE8D7C586F538430B19C2467B942D3A79BD29',   # 2022-2023 (expired)
        'A4A9406876FCBD3C456770C88C718D3B5072E1F5')   # -2021 (expired)
KEYSERVER = 'https://keyserver.ubuntu.com/pks/lookup?op=get&search=0x%s'
COPY = ('Dockerfile', 'Makefile', 'usr/local/bin/docker-entrypoint.sh', 'etc/mysql/my.cnf')


def vkey(v):
    return [int(x) for x in v.split('.')]


def get(url, binary=False):
    # dev.mysql.com answers 403 to unknown user agents
    req = urllib.request.Request(url, headers={'User-Agent': 'curl/8.14.1'})
    data = urllib.request.urlopen(req, timeout=600).read()
    return data if binary else data.decode('utf-8', 'replace')


def newest():
    """{line: (full, url dir, tarball)}"""
    out = {}
    for line, (d, pat, fixed) in LINES.items():
        full = fixed
        if not full:
            vers = re.findall(r'mysql-(%s\.\d+)-linux-glibc2\.28' % re.escape(line), get(PAGE % (line + '.html')))
            if not vers:
                sys.exit('FATAL: no %s release on the downloads page' % line)
            full = max(set(vers), key=vkey)
        out[line] = (full, d, pat % full)
    page = get(PAGE % '')
    inn = [v for v in set(re.findall(r'mysql-(\d{2}\.\d+\.\d+)-linux-glibc2\.28', page)) if int(v.split('.')[0]) >= 26]
    if inn:
        full = max(inn, key=vkey)
        line = '.'.join(full.split('.')[:2])
        out[line] = (full, INNOVATION[0] % line, INNOVATION[1] % full)
    return out


def sha256_checked(d, tarball, gnupg):
    url = '%s/%s/%s' % (CDN, d, tarball)
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
    text = re.sub(r'^(ENV EMG_MYSQL_VERSION=).*$', r'\g<1>' + line, text, flags=re.M)
    text = re.sub(r'^(ENV EMG_MYSQL_FULL_VERSION=).*$', r'\g<1>' + full, text, flags=re.M)
    text = re.sub(r'^(ARG EMG_MYSQL_TARBALL=).*$', r'\g<1>' + tarball, text, flags=re.M)
    text = re.sub(r'^(ARG EMG_MYSQL_URL=).*$', r'\g<1>' + CDN + '/' + d, text, flags=re.M)
    return re.sub(r'^(ARG EMG_MYSQL_SHA256=).*$', r'\g<1>' + sha, text, flags=re.M)


def compose(line, full, extra):
    tags = [line, full] + extra
    out = ['services:', '  app:', '    image: "epicmorg/mysql:%s"' % line, '    build:', '      context: .',
           '    x-squash: false', '    x-mirrors:']
    for t in tags:
        out += ['      - %s/epicmorg/mysql:%s' % (reg, t) for reg in ('quay.io', 'ghcr.io', 'docker.io')]
    return '\n'.join(out) + '\n'


def main():
    dry = '--dry-run' in sys.argv
    refresh = '--refresh' in sys.argv
    argv = [a for a in sys.argv if a not in ('--dry-run', '--refresh')]
    args = dict(zip(argv[1::2], argv[2::2]))
    only = set(filter(None, args.get('--only', '').split(',')))
    ref = os.path.join(BASE, REFERENCE)
    found = newest()
    inn = [l for l in found if l not in LINES]
    for old in sorted(d for d in os.listdir(BASE) if os.path.isdir(os.path.join(BASE, d))):
        if old not in found:
            print('NOTE: %s is not a current line any more (older Innovation release?) - remove the folder' % old)
    gnupg = tempfile.mkdtemp()
    try:
        if not dry:
            for fp in KEYS:
                subprocess.run(['gpg', '--homedir', gnupg, '--batch', '--import'], input=get(KEYSERVER % fp, binary=True),
                               check=True, capture_output=True)
        for line, (full, d, tarball) in sorted(found.items(), key=lambda x: vkey(x[0])):
            if only and line not in only:
                continue
            extra = list(EXTRA.get(line, []))
            if line in inn:
                extra += [line.split('.')[0], 'innovation', 'latest']
            leaf = os.path.join(BASE, line)
            new = not os.path.isdir(leaf)
            print('%-6s %-8s %-4s %-58s %s' % (line, full, 'new' if new else 'bump', tarball, ' '.join(extra)))
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
