#!/usr/bin/env python3
"""Create / refresh linux/ecosystem/apps/erlang/<otp major> leaves.

One leaf per OTP major in LINES, always the newest patch of that major from
the erlang/otp GitHub releases, sha256 from the release's SHA256.txt. A new
leaf is a copy of the reference leaf (REFERENCE below); existing leaves only
get their version lines bumped (EMG_ERLANG_VERSION / _FULL_VERSION /
_OPENSSL / _SHA256) and the compose tags. Tags: <major>, <full>; the newest
major also latest.

The majors are the ones a shipped consumer needs: RabbitMQ 3.9 / 3.10 run on
OTP 24 / 25, 4.3+ on 27-29 (see bin/python/rabbitmq-versions-sync.py).

Usage: GITHUB_TOKEN=$(gh auth token) bin/python/erlang-versions-sync.py [--dry-run] [--refresh] [--only 27,28]
  --refresh   re-copy the reference Dockerfile into existing leaves too
"""
import json
import os
import re
import shutil
import sys
import urllib.request

ROOT = os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
BASE = os.path.join(ROOT, 'linux', 'ecosystem', 'apps', 'erlang')
REFERENCE = '27'
LINES = ('24', '25', '26', '27', '28', '29')
# OTP 24 predates full OpenSSL 3 support (its configure: "not yet recommended
# for production") - the baked 1.1.1; everything newer: 3.5 (LTS)
OPENSSL = {'24': '1.1.1'}
RELEASES = 'https://api.github.com/repos/erlang/otp/releases?per_page=100&page=%d'
COPY = ('Dockerfile', 'Makefile')


def vkey(v):
    return [int(x) for x in v.split('.')]


def get(url):
    req = urllib.request.Request(url, headers={'User-Agent': 'epicmorg-erlang-versions-sync'})
    tok = os.environ.get('GITHUB_TOKEN')
    if tok and 'api.github.com' in url:
        req.add_header('Authorization', 'Bearer ' + tok)
    return urllib.request.urlopen(req, timeout=60).read().decode()


def newest():
    """{major: (full, sha256 url)} for LINES."""
    out, page = {}, 1
    while True:
        rel = json.loads(get(RELEASES % page))
        if not rel:
            break
        for r in rel:
            m = re.fullmatch(r'OTP-(\d+)\.(\d+(?:\.\d+)*)', r['tag_name'])
            if r['prerelease'] or not m or m.group(1) not in LINES:
                continue
            full = '%s.%s' % (m.group(1), m.group(2))
            if m.group(1) not in out or vkey(full) > vkey(out[m.group(1)]):
                out[m.group(1)] = full
        page += 1
    return out


def sha256(full):
    txt = get('https://github.com/erlang/otp/releases/download/OTP-%s/SHA256.txt' % full)
    m = re.search(r'^([0-9a-f]{64})\s+\*?otp_src_%s\.tar\.gz$' % re.escape(full), txt, re.M)
    if not m:
        sys.exit('FATAL: no sha256 for otp_src_%s.tar.gz' % full)
    return m.group(1)


def bump(text, major, full, sha):
    ssl = OPENSSL.get(major, '3.5')
    text = re.sub(r'^(ENV EMG_ERLANG_VERSION=).*$', r'\g<1>' + major, text, flags=re.M)
    text = re.sub(r'^(ENV EMG_ERLANG_FULL_VERSION=).*$', r'\g<1>' + full, text, flags=re.M)
    text = re.sub(r'^(ENV EMG_ERLANG_OPENSSL=).*$', r'\g<1>' + ssl, text, flags=re.M)
    return re.sub(r'^(ARG EMG_ERLANG_SHA256=).*$', r'\g<1>' + sha, text, flags=re.M)


def compose(major, full, extra):
    tags = [major, full] + extra
    out = ['services:', '  app:', '    image: "epicmorg/erlang:%s"' % major, '    build:', '      context: .',
           '    x-squash: false', '    x-mirrors:']
    for t in tags:
        out += ['      - %s/epicmorg/erlang:%s' % (reg, t) for reg in ('quay.io', 'ghcr.io', 'docker.io')]
    return '\n'.join(out) + '\n'


def main():
    dry = '--dry-run' in sys.argv
    refresh = '--refresh' in sys.argv
    argv = [a for a in sys.argv if a not in ('--dry-run', '--refresh')]
    args = dict(zip(argv[1::2], argv[2::2]))
    only = set(filter(None, args.get('--only', '').split(',')))
    ref = os.path.join(BASE, REFERENCE)
    found = newest()
    top = max(found, key=int)
    for major, full in sorted(found.items(), key=lambda x: int(x[0]), reverse=True):
        if only and major not in only:
            continue
        extra = ['latest'] if major == top else []
        leaf = os.path.join(BASE, major)
        new = not os.path.isdir(leaf)
        print('%-3s %-11s %-5s %-4s %s' % (major, full, OPENSSL.get(major, '3.5'), 'new' if new else 'bump', ' '.join(extra)))
        if dry:
            continue
        sha = sha256(full)
        if new or (refresh and major != REFERENCE):
            os.makedirs(leaf, exist_ok=True)
            for f in COPY:
                shutil.copy2(os.path.join(ref, f), os.path.join(leaf, f))
        df = os.path.join(leaf, 'Dockerfile')
        text = bump(open(df).read(), major, full, sha)          # read fully before 'w' truncates
        open(df, 'w').write(text)
        open(os.path.join(leaf, 'docker-compose.yml'), 'w').write(compose(major, full, extra))


if __name__ == '__main__':
    main()
