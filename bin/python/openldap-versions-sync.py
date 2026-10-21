#!/usr/bin/env python3
"""Create / refresh linux/ecosystem/apps/openldap/<major.minor> leaves.

One leaf per release line in LINES, always the newest patch of that line from
openldap.org's release directory. The tarball is checked against openldap.org's
own checksum file (sha3-512 for 2.5+, sha1 for 2.4) and pinned as sha256.
A new leaf is a copy of the reference leaf (REFERENCE below); existing leaves
only get their version lines bumped (EMG_OPENLDAP_VERSION / _FULL_VERSION /
_SHA256) and the compose tags. Tags: <mm>, <full>; LTS gets latest and 2.

Usage: bin/python/openldap-versions-sync.py [--dry-run] [--refresh] [--only 2.6,2.7]
  --refresh   re-copy the reference Dockerfile + entrypoint into existing leaves too
"""
import hashlib
import os
import re
import shutil
import sys
import urllib.request

ROOT = os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
BASE = os.path.join(ROOT, 'linux', 'ecosystem', 'apps', 'openldap')
REFERENCE = '2.6'
# 2.4: legacy (bdb/hdb, for reading / migrating old databases); 2.5: previous LTS;
# 2.6: LTS (latest); 2.7: feature release
LINES = ('2.4', '2.5', '2.6', '2.7')
LTS = '2.6'
DIST = 'https://www.openldap.org/software/download/OpenLDAP/openldap-release/'
COPY = ('Dockerfile', 'Makefile', 'usr/local/bin/docker-entrypoint.sh')


def vkey(v):
    return [int(x) for x in v.split('.')]


def get(url, binary=False):
    req = urllib.request.Request(url, headers={'User-Agent': 'epicmorg-openldap-versions-sync'})
    data = urllib.request.urlopen(req, timeout=120).read()
    return data if binary else data.decode()


def newest():
    """{major.minor: full version} for LINES."""
    out = {}
    for full in set(re.findall(r'openldap-(\d+\.\d+\.\d+)\.tgz', get(DIST))):
        mm = '.'.join(full.split('.')[:2])
        if mm in LINES and (mm not in out or vkey(full) > vkey(out[mm])):
            out[mm] = full
    return out


def sha256_checked(full):
    """Download the tarball, verify openldap.org's checksum file, return sha256."""
    tgz = get(DIST + 'openldap-%s.tgz' % full, binary=True)
    try:
        want, algo = get(DIST + 'openldap-%s.sha3-512' % full), 'sha3_512'
    except Exception:
        want, algo = get(DIST + 'openldap-%s.sha1' % full), 'sha1'
    digest = hashlib.new(algo, tgz).hexdigest()
    if digest not in want.lower():
        sys.exit('FATAL: openldap-%s.tgz %s mismatch' % (full, algo))
    return hashlib.sha256(tgz).hexdigest()


def bump(text, mm, full, sha):
    text = re.sub(r'^(ENV EMG_OPENLDAP_VERSION=).*$', r'\g<1>' + mm, text, flags=re.M)
    text = re.sub(r'^(ENV EMG_OPENLDAP_FULL_VERSION=).*$', r'\g<1>' + full, text, flags=re.M)
    return re.sub(r'^(ARG EMG_OPENLDAP_SHA256=).*$', r'\g<1>' + sha, text, flags=re.M)


def compose(mm, full, extra):
    tags = [mm, full] + extra
    out = ['services:', '  app:', '    image: "epicmorg/openldap:%s"' % mm, '    build:', '      context: .',
           '    x-squash: false', '    x-mirrors:']
    for t in tags:
        out += ['      - %s/epicmorg/openldap:%s' % (reg, t) for reg in ('quay.io', 'ghcr.io', 'docker.io')]
    return '\n'.join(out) + '\n'


def main():
    dry = '--dry-run' in sys.argv
    refresh = '--refresh' in sys.argv
    argv = [a for a in sys.argv if a not in ('--dry-run', '--refresh')]
    args = dict(zip(argv[1::2], argv[2::2]))
    only = set(filter(None, args.get('--only', '').split(',')))
    ref = os.path.join(BASE, REFERENCE)
    for mm, full in sorted(newest().items(), key=lambda x: vkey(x[0]), reverse=True):
        if only and mm not in only:
            continue
        extra = ['2', 'latest'] if mm == LTS else []
        leaf = os.path.join(BASE, mm)
        new = not os.path.isdir(leaf)
        print('%-4s %-7s %-4s %s' % (mm, full, 'new' if new else 'bump', ' '.join(extra)))
        if dry:
            continue
        sha = sha256_checked(full)
        if new or (refresh and mm != REFERENCE):
            for f in COPY:
                os.makedirs(os.path.dirname(os.path.join(leaf, f)), exist_ok=True)
                shutil.copy2(os.path.join(ref, f), os.path.join(leaf, f))
        df = os.path.join(leaf, 'Dockerfile')
        text = bump(open(df).read(), mm, full, sha)          # read fully before 'w' truncates
        open(df, 'w').write(text)
        open(os.path.join(leaf, 'docker-compose.yml'), 'w').write(compose(mm, full, extra))


if __name__ == '__main__':
    main()
