#!/usr/bin/env python3
"""Create / refresh linux/ecosystem/apps/rabbitmq/<major.minor> leaves.

One leaf per RabbitMQ line in OTP (below), always the newest patch of that line
from the rabbitmq-server GitHub releases. The generic-unix tarball is checked
against its GPG signature (RabbitMQ release key KEY_FPR, fetched from
rabbitmq/signing-keys) and pinned as sha256. Each line runs on the Erlang/OTP
major in OTP: the newest one RabbitMQ's compatibility matrix fully supports for
that line (4.x: the one library/rabbitmq ships). A new leaf is a copy of the
reference leaf (REFERENCE below); existing leaves only get the version lines
and the erlang FROM bumped, plus the compose tags.

Tags: <mm>, <full>, <mm>-management, <full>-management (management is always
on - the library -management variant); the newest line of each major also
<major>; the newest line overall also latest / management.

Usage: GITHUB_TOKEN=$(gh auth token) bin/python/rabbitmq-versions-sync.py [--dry-run] [--refresh] [--only 4.3]
  --refresh   re-copy the reference Dockerfile + entrypoint + conf.d into existing leaves too
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
BASE = os.path.join(ROOT, 'linux', 'ecosystem', 'apps', 'rabbitmq')
REFERENCE = '4.3'
# line -> OTP major (https://www.rabbitmq.com/docs/which-erlang)
OTP = {'3.9': '24', '3.10': '25', '3.11': '25', '3.12': '26', '3.13': '26',
       '4.0': '27', '4.1': '27', '4.2': '27', '4.3': '27', '4.4': '29'}
KEY_URL = 'https://github.com/rabbitmq/signing-keys/releases/download/3.0/rabbitmq-release-signing-key.asc'
KEY_FPR = '0A9AF2115F4687BD29803A206B73A36E6026DFCA'
RELEASES = 'https://api.github.com/repos/rabbitmq/rabbitmq-server/releases?per_page=100&page=%d'
DL = 'https://github.com/rabbitmq/rabbitmq-server/releases/download/v%s/rabbitmq-server-generic-unix-%s.tar.xz'
COPY = ('Dockerfile', 'Makefile', 'usr/local/bin/docker-entrypoint.sh', 'etc/rabbitmq/conf.d/10-defaults.conf')


def vkey(v):
    return [int(x) for x in v.split('.')]


def get(url, binary=False):
    req = urllib.request.Request(url, headers={'User-Agent': 'epicmorg-rabbitmq-versions-sync'})
    tok = os.environ.get('GITHUB_TOKEN')
    if tok and 'api.github.com' in url:
        req.add_header('Authorization', 'Bearer ' + tok)
    data = urllib.request.urlopen(req, timeout=300).read()
    return data if binary else data.decode()


def newest():
    out, page = {}, 1
    while True:
        rel = json.loads(get(RELEASES % page))
        if not rel:
            break
        for r in rel:
            full = r['tag_name'].lstrip('v')
            if r['prerelease'] or r['draft'] or not re.fullmatch(r'\d+\.\d+\.\d+', full):
                continue
            mm = '.'.join(full.split('.')[:2])
            if mm in OTP and (mm not in out or vkey(full) > vkey(out[mm])):
                out[mm] = full
        page += 1
    return out


def sha256_checked(full, gnupg):
    tar = get(DL % (full, full), binary=True)
    sig = get(DL % (full, full) + '.asc', binary=True)
    with tempfile.TemporaryDirectory() as d:
        open(os.path.join(d, 't'), 'wb').write(tar)
        open(os.path.join(d, 't.asc'), 'wb').write(sig)
        r = subprocess.run(['gpg', '--homedir', gnupg, '--status-fd', '1', '--verify',
                            os.path.join(d, 't.asc'), os.path.join(d, 't')], capture_output=True, text=True)
    if r.returncode or ('VALIDSIG ' + KEY_FPR) not in r.stdout:
        sys.exit('FATAL: rabbitmq-server-generic-unix-%s.tar.xz: bad or foreign signature\n%s' % (full, r.stdout + r.stderr))
    return hashlib.sha256(tar).hexdigest()


def bump(text, mm, full, sha):
    otp = OTP[mm]
    text = re.sub(r'^(FROM ghcr\.io/epicmorg/erlang:)\S+( AS erlang)$', r'\g<1>' + otp + r'\2', text, flags=re.M)
    text = re.sub(r'^(ENV EMG_RABBITMQ_VERSION=).*$', r'\g<1>' + mm, text, flags=re.M)
    text = re.sub(r'^(ENV EMG_RABBITMQ_FULL_VERSION=).*$', r'\g<1>' + full, text, flags=re.M)
    text = re.sub(r'^(ENV EMG_RABBITMQ_OTP=).*$', r'\g<1>' + otp, text, flags=re.M)
    return re.sub(r'^(ARG EMG_RABBITMQ_SHA256=).*$', r'\g<1>' + sha, text, flags=re.M)


def compose(mm, full, extra):
    tags = [mm, full, mm + '-management', full + '-management'] + extra
    out = ['services:', '  app:', '    image: "epicmorg/rabbitmq:%s"' % mm, '    build:', '      context: .',
           '    x-squash: false', '    x-mirrors:']
    for t in tags:
        out += ['      - %s/epicmorg/rabbitmq:%s' % (reg, t) for reg in ('quay.io', 'ghcr.io', 'docker.io')]
    return '\n'.join(out) + '\n'


def main():
    dry = '--dry-run' in sys.argv
    refresh = '--refresh' in sys.argv
    argv = [a for a in sys.argv if a not in ('--dry-run', '--refresh')]
    args = dict(zip(argv[1::2], argv[2::2]))
    only = set(filter(None, args.get('--only', '').split(',')))
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
            key = os.path.join(gnupg, 'key.asc')
            open(key, 'wb').write(get(KEY_URL, binary=True))
            subprocess.run(['gpg', '--homedir', gnupg, '--batch', '--import', key], check=True, capture_output=True)
        for mm, full in sorted(found.items(), key=lambda x: vkey(x[0]), reverse=True):
            if only and mm not in only:
                continue
            mj = mm.split('.')[0]
            extra = ([mj, mj + '-management'] if top_of_major[mj] == mm else []) + (['latest', 'management'] if mm == top else [])
            leaf = os.path.join(BASE, mm)
            new = not os.path.isdir(leaf)
            print('%-5s %-7s otp %-3s %-4s %s' % (mm, full, OTP[mm], 'new' if new else 'bump', ' '.join(extra)))
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
