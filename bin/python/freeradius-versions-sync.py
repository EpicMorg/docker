#!/usr/bin/env python3
"""Create / refresh linux/ecosystem/apps/freeradius/<major.minor> leaves.

One leaf per FreeRADIUS line in LINES at its newest patch (release_X_Y_Z tags
of FreeRADIUS/freeradius-server; tarballs from freeradius.org, checked against
their .sig - FreeRADIUS package signing key KEY_FPR - and pinned as sha256).
A new leaf is a copy of the reference leaf (REFERENCE); existing leaves only
get the version block bumped and the compose tags. Tags: <mm>, <full>; the
newest line also 3 and latest.

Usage: GITHUB_TOKEN=$(gh auth token) bin/python/freeradius-versions-sync.py [--dry-run] [--refresh]   (needs gpg)
"""
import hashlib
import json
import os
import re
import shutil
import subprocess
import sys
import tempfile
import urllib.request

ROOT = os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
BASE = os.path.join(ROOT, 'linux', 'ecosystem', 'apps', 'freeradius')
REFERENCE = '3.2'
# 3.2: current; 3.0: legacy, still gets security releases
LINES = ('3.0', '3.2')
TAGS = 'https://api.github.com/repos/FreeRADIUS/freeradius-server/tags?per_page=100&page=%d'
DIST = 'https://freeradius.org/ftp/pub/freeradius/freeradius-server-%s.tar.gz'
KEY_FPR = 'BF2384EC6938B9744B03E2A620E37C25995B4F85'
KEYSERVER = 'https://keyserver.ubuntu.com/pks/lookup?op=get&search=0x%s'
COPY = ('Dockerfile', 'Makefile', 'usr/local/bin/docker-entrypoint.sh')


def vkey(v):
    return [int(x) for x in v.split('.')]


def get(url, binary=False):
    req = urllib.request.Request(url, headers={'User-Agent': 'curl/8.14.1'})
    tok = os.environ.get('GITHUB_TOKEN')
    if tok and 'api.github.com' in url:
        req.add_header('Authorization', 'Bearer ' + tok)
    data = urllib.request.urlopen(req, timeout=300).read()
    return data if binary else data.decode()


def newest():
    out, page = {}, 1
    while page < 20:
        tags = json.loads(get(TAGS % page))
        if not tags:
            break
        for t in tags:
            m = re.fullmatch(r'release_(\d+)_(\d+)_(\d+)', t['name'])
            if not m:
                continue
            full = '.'.join(m.groups())
            mm = '.'.join(m.groups()[:2])
            if mm in LINES and (mm not in out or vkey(full) > vkey(out[mm])):
                out[mm] = full
        page += 1
    return out


def sha256_checked(full, gnupg):
    data = get(DIST % full, binary=True)
    sig = get(DIST % full + '.sig', binary=True)
    with tempfile.TemporaryDirectory() as tmp:
        open(os.path.join(tmp, 't'), 'wb').write(data)
        open(os.path.join(tmp, 't.sig'), 'wb').write(sig)
        r = subprocess.run(['gpg', '--homedir', gnupg, '--status-fd', '1', '--verify',
                            os.path.join(tmp, 't.sig'), os.path.join(tmp, 't')], capture_output=True, text=True)
    if ('VALIDSIG ' + KEY_FPR) not in r.stdout:
        sys.exit('FATAL: freeradius-server-%s.tar.gz: bad or foreign signature\n%s' % (full, r.stdout + r.stderr))
    return hashlib.sha256(data).hexdigest()


def bump(text, mm, full, sha):
    text = re.sub(r'^(ENV EMG_FREERADIUS_VERSION=).*$', r'\g<1>' + mm, text, flags=re.M)
    text = re.sub(r'^(ENV EMG_FREERADIUS_FULL_VERSION=).*$', r'\g<1>' + full, text, flags=re.M)
    return re.sub(r'^(ARG EMG_FREERADIUS_SHA256=).*$', r'\g<1>' + sha, text, flags=re.M)


def compose(mm, full, extra):
    tags = [mm, full] + extra
    out = ['services:', '  app:', '    image: "epicmorg/freeradius:%s"' % mm, '    build:', '      context: .',
           '    x-squash: false', '    x-mirrors:']
    for t in tags:
        out += ['      - %s/epicmorg/freeradius:%s' % (reg, t) for reg in ('quay.io', 'ghcr.io', 'docker.io')]
    return '\n'.join(out) + '\n'


def main():
    dry = '--dry-run' in sys.argv
    refresh = '--refresh' in sys.argv
    ref = os.path.join(BASE, REFERENCE)
    found = newest()
    top = max(found, key=vkey)
    gnupg = tempfile.mkdtemp()
    try:
        if not dry:
            subprocess.run(['gpg', '--homedir', gnupg, '--batch', '--import'], input=get(KEYSERVER % KEY_FPR, binary=True),
                           check=True, capture_output=True)
        for mm, full in sorted(found.items(), key=lambda x: vkey(x[0])):
            extra = ['3', 'latest'] if mm == top else []
            leaf = os.path.join(BASE, mm)
            new = not os.path.isdir(leaf)
            print('%-4s %-7s %-4s %s' % (mm, full, 'new' if new else 'bump', ' '.join(extra)))
            if dry:
                continue
            sha = sha256_checked(full, gnupg)
            if new or (refresh and mm != REFERENCE):
                for f in COPY:
                    os.makedirs(os.path.dirname(os.path.join(leaf, f)), exist_ok=True)
                    shutil.copy2(os.path.join(ref, f), os.path.join(leaf, f))
            df = os.path.join(leaf, 'Dockerfile')
            text = bump(open(df).read(), mm, full, sha)          # read fully before 'w' truncates
            open(df, 'w').write(text)
            open(os.path.join(leaf, 'docker-compose.yml'), 'w').write(compose(mm, full, extra))
    finally:
        shutil.rmtree(gnupg, ignore_errors=True)


if __name__ == '__main__':
    main()
