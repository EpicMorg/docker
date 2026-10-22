#!/usr/bin/env python3
"""Create / refresh linux/ecosystem/apps/vault/<major.minor> leaves.

One leaf per Vault line from FIRST on, at the newest Community Edition release
of the line (api.releases.hashicorp.com: license_class oss, no prereleases, no
+ent builds). The linux_amd64 zip's sha256 comes from the release's SHA256SUMS,
which is checked against its .sig (HashiCorp Security key KEY_FPR, from
hashicorp.com/.well-known/pgp-key.txt). 1.13 is the last MPL release, newer ones
are BUSL (accepted by the owner). A new leaf is a copy of the reference leaf
(REFERENCE); existing leaves only get the version block bumped and the compose
tags. Tags: <mm>, <full>; the newest line of each major also <major>; the newest
overall also latest.

Usage: bin/python/vault-versions-sync.py [--dry-run] [--refresh]   (needs gpg)
"""
import json
import os
import re
import shutil
import subprocess
import sys
import tempfile
import urllib.request

ROOT = os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
BASE = os.path.join(ROOT, 'linux', 'ecosystem', 'apps', 'vault')
REFERENCE = '2.2'
FIRST = (1, 13)
API = 'https://api.releases.hashicorp.com/v1/releases/vault?limit=20'
DL = 'https://releases.hashicorp.com/vault/%s/vault_%s_SHA256SUMS'
KEY_URL = 'https://www.hashicorp.com/.well-known/pgp-key.txt'
KEY_FPR = 'C874011F0AB405110D02105534365D9472D7468F'
COPY = ('Dockerfile', 'Makefile', 'usr/local/bin/docker-entrypoint.sh')


def vkey(v):
    return [int(x) for x in v.split('.')]


def get(url, binary=False):
    req = urllib.request.Request(url, headers={'User-Agent': 'curl/8.14.1'})
    data = urllib.request.urlopen(req, timeout=120).read()
    return data if binary else data.decode()


def newest():
    out, after = {}, None
    while True:
        rel = json.loads(get(API + ('&after=' + after if after else '')))
        if not rel:
            break
        for r in rel:
            v = r['version']
            if r.get('is_prerelease') or r.get('license_class') != 'oss' or not re.fullmatch(r'\d+\.\d+\.\d+', v):
                continue
            mm = '.'.join(v.split('.')[:2])
            if tuple(vkey(mm)) < FIRST:
                continue
            if mm not in out or vkey(v) > vkey(out[mm]):
                out[mm] = v
        after = rel[-1]['timestamp_created']
        if tuple(vkey('.'.join(rel[-1]['version'].split('+')[0].split('-')[0].split('.')[:2]))) < FIRST:
            break
    return out


def sha256_checked(full, gnupg):
    sums = get(DL % (full, full), binary=True)
    sig = get(DL % (full, full) + '.sig', binary=True)
    with tempfile.TemporaryDirectory() as tmp:
        open(os.path.join(tmp, 's'), 'wb').write(sums)
        open(os.path.join(tmp, 's.sig'), 'wb').write(sig)
        r = subprocess.run(['gpg', '--homedir', gnupg, '--status-fd', '1', '--verify',
                            os.path.join(tmp, 's.sig'), os.path.join(tmp, 's')], capture_output=True, text=True)
    if not re.search(r'VALIDSIG [0-9A-F]{40} .* %s$' % KEY_FPR, r.stdout, re.M):
        sys.exit('FATAL: vault %s SHA256SUMS: bad or foreign signature\n%s' % (full, r.stdout + r.stderr))
    m = re.search(r'^([0-9a-f]{64})\s+vault_%s_linux_amd64\.zip$' % re.escape(full), sums.decode(), re.M)
    if not m:
        sys.exit('FATAL: no linux_amd64 zip in vault %s SHA256SUMS' % full)
    return m.group(1)


def bump(text, mm, full, sha):
    text = re.sub(r'^(ENV EMG_VAULT_VERSION=).*$', r'\g<1>' + mm, text, flags=re.M)
    text = re.sub(r'^(ENV EMG_VAULT_FULL_VERSION=).*$', r'\g<1>' + full, text, flags=re.M)
    return re.sub(r'^(ARG EMG_VAULT_SHA256=).*$', r'\g<1>' + sha, text, flags=re.M)


def compose(mm, full, extra):
    tags = [mm, full] + extra
    out = ['services:', '  app:', '    image: "epicmorg/vault:%s"' % mm, '    build:', '      context: .',
           '    x-squash: false', '    x-mirrors:']
    for t in tags:
        out += ['      - %s/epicmorg/vault:%s' % (reg, t) for reg in ('quay.io', 'ghcr.io', 'docker.io')]
    return '\n'.join(out) + '\n'


def main():
    dry = '--dry-run' in sys.argv
    refresh = '--refresh' in sys.argv
    ref = os.path.join(BASE, REFERENCE)
    found = newest()
    top = max(found, key=vkey)
    top_of_major = {}
    for mm in found:
        mj = mm.split('.')[0]
        if mj not in top_of_major or vkey(mm) > vkey(top_of_major[mj]):
            top_of_major[mj] = mm
    gnupg = tempfile.mkdtemp()
    try:
        if not dry:
            subprocess.run(['gpg', '--homedir', gnupg, '--batch', '--import'], input=get(KEY_URL, binary=True),
                           check=True, capture_output=True)
        for mm, full in sorted(found.items(), key=lambda x: vkey(x[0])):
            mj = mm.split('.')[0]
            extra = ([mj] if top_of_major[mj] == mm else []) + (['latest'] if mm == top else [])
            leaf = os.path.join(BASE, mm)
            new = not os.path.isdir(leaf)
            print('%-5s %-7s %-4s %s' % (mm, full, 'new' if new else 'bump', ' '.join(extra)))
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
