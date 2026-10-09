#!/usr/bin/env python3
"""Create / refresh linux/ecosystem/apps/redis/<major.minor> leaves.

One leaf per maintained redis release line (major.minor), always the newest
patch of that line, sha256 from github.com/redis/redis-hashes. "Maintained" =
a line with a release in the last MAINTAINED_DAYS days (old lines that still
get security patches, e.g. 6.2 / 7.2, stay; dead ones such as 7.0 drop out).
A new leaf is a copy of the reference leaf (REFERENCE below); existing leaves
only get their version lines bumped (EMG_REDIS_VERSION / EMG_REDIS_FULL_VERSION
/ EMG_REDIS_SHA256) and the compose tags. Tags: <mm>, <full>, the newest line
of each major also <major>, the newest line overall also latest.

Usage: bin/python/redis-versions-sync.py [--dry-run] [--refresh] [--only 8.10,7.4]
  --refresh   re-copy the reference Dockerfile + entrypoint into existing leaves too
"""
import datetime
import json
import os
import re
import shutil
import sys
import urllib.request

ROOT = os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
BASE = os.path.join(ROOT, 'linux', 'ecosystem', 'apps', 'redis')
REFERENCE = '8.10'
HASHES = 'https://raw.githubusercontent.com/redis/redis-hashes/master/README'
RELEASES = 'https://api.github.com/repos/redis/redis/releases?per_page=100&page=%d'
MAINTAINED_DAYS = 400
COPY = ('Dockerfile', 'Makefile', 'usr/local/bin/docker-entrypoint.sh')


def vkey(v):
    return [int(x) for x in v.split('.')]


def get(url):
    req = urllib.request.Request(url, headers={'User-Agent': 'epicmorg-redis-versions-sync'})
    tok = os.environ.get('GITHUB_TOKEN')
    if tok and 'api.github.com' in url:
        req.add_header('Authorization', 'Bearer ' + tok)
    return urllib.request.urlopen(req, timeout=60).read().decode()


def lines():
    """{major.minor: (full version, sha256)} for maintained release lines."""
    sums = {}
    for line in get(HASHES).splitlines():
        m = re.match(r'^hash redis-(\d+\.\d+\.\d+)\.tar\.gz sha256 ([0-9a-f]{64}) ', line)
        if m:
            sums[m.group(1)] = m.group(2)
    cutoff = datetime.datetime.now(datetime.timezone.utc) - datetime.timedelta(days=MAINTAINED_DAYS)
    out, page = {}, 1
    while True:
        rel = json.loads(get(RELEASES % page))
        if not rel:
            break
        for r in rel:
            full = r['tag_name']
            if r['prerelease'] or not re.fullmatch(r'\d+\.\d+\.\d+', full) or full not in sums:
                continue
            when = datetime.datetime.fromisoformat(r['published_at'].replace('Z', '+00:00'))
            mm = '.'.join(full.split('.')[:2])
            cur = out.get(mm)
            if cur is None or vkey(full) > vkey(cur[0]):
                out[mm] = (full, sums[full], max(when, cur[2]) if cur else when)
            elif when > cur[2]:
                out[mm] = (cur[0], cur[1], when)
        page += 1
    return {mm: (full, sha) for mm, (full, sha, when) in out.items() if when >= cutoff}


def bump(text, mm, full, sha):
    text = re.sub(r'^(ENV EMG_REDIS_VERSION=).*$', r'\g<1>' + mm, text, flags=re.M)
    text = re.sub(r'^(ENV EMG_REDIS_FULL_VERSION=).*$', r'\g<1>' + full, text, flags=re.M)
    return re.sub(r'^(ARG EMG_REDIS_SHA256=).*$', r'\g<1>' + sha, text, flags=re.M)


def compose(mm, full, extra):
    tags = [mm, full] + extra
    out = ['services:', '  app:', '    image: "epicmorg/redis:%s"' % mm, '    build:', '      context: .',
           '    x-squash: false', '    x-mirrors:']
    for t in tags:
        out += ['      - %s/epicmorg/redis:%s' % (reg, t) for reg in ('quay.io', 'ghcr.io', 'docker.io')]
    return '\n'.join(out) + '\n'


def main():
    dry = '--dry-run' in sys.argv
    refresh = '--refresh' in sys.argv
    argv = [a for a in sys.argv if a not in ('--dry-run', '--refresh')]
    args = dict(zip(argv[1::2], argv[2::2]))
    only = set(filter(None, args.get('--only', '').split(',')))
    ref = os.path.join(BASE, REFERENCE)
    found = lines()
    newest = max(found, key=vkey)
    top_of_major = {}
    for mm in found:
        major = mm.split('.')[0]
        if major not in top_of_major or vkey(mm) > vkey(top_of_major[major]):
            top_of_major[major] = mm
    for mm, (full, sha) in sorted(found.items(), key=lambda x: vkey(x[0]), reverse=True):
        if only and mm not in only:
            continue
        extra = ([mm.split('.')[0]] if top_of_major[mm.split('.')[0]] == mm else []) + (['latest'] if mm == newest else [])
        leaf = os.path.join(BASE, mm)
        new = not os.path.isdir(leaf)
        print('%-5s %-8s %-4s %s' % (mm, full, 'new' if new else 'bump', ' '.join(extra)))
        if dry:
            continue
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
