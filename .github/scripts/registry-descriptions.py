#!/usr/bin/env python3
"""Push root READMEs as repository descriptions to Docker Hub and Quay.

The repo -> README map comes from `bin/python/readme-sync.py --map`. For each repository:
  * relative Markdown links are rewritten to absolute GitHub URLs (registries
    render the README out of the repo context);
  * Docker Hub: full_description (max 25 000 bytes, cut with a link to GitHub
    when longer) + description (the `hub-description` line, max 100 chars);
  * Quay: description (needs an OAuth token of a Quay application with the
    "Administer Repositories" scope - robot credentials can't use the API).

Env (same names as the org secrets): DOCKER_SERVER_LOGIN, DOCKER_API_TOKEN (Docker Hub PAT with
     read/write/delete), QUAY_API_TOKEN (Quay OAuth token, "Administer Repositories");
     GITHUB_REF_NAME (branch for links, default master).
Usage: registry-descriptions.py [--dry-run] [repo ...]
"""
import json
import os
import re
import subprocess
import sys
import urllib.error
import urllib.request

ROOT = os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
GH = 'https://github.com/EpicMorg/docker'
HUB_MAX = 25000
SKIP = {'epicmorg/sentry'}
LINK = re.compile(r'(\]\()(?!https?://|#|mailto:)([^)\s]+)(\))')


def request(method, url, data=None, headers=None):
    body = json.dumps(data).encode() if data is not None else None
    req = urllib.request.Request(url, data=body, method=method,
                                 headers={'Content-Type': 'application/json', **(headers or {})})
    with urllib.request.urlopen(req, timeout=60) as r:
        return json.loads(r.read() or b'{}')


def absolutize(text, readme, ref):
    base = os.path.dirname(readme)

    def fix(m):
        target = os.path.normpath(os.path.join(base, m.group(2)))
        kind = 'blob' if os.path.isfile(os.path.join(ROOT, target)) else 'tree'
        return '%s%s/%s/%s/%s%s' % (m.group(1), GH, kind, ref, target, m.group(3))
    return LINK.sub(fix, text)


def clip(text, readme, ref):
    if len(text.encode()) <= HUB_MAX:
        return text
    tail = '\n\n---\n*Truncated - full README: %s/blob/%s/%s*\n' % (GH, ref, readme)
    cut = text.encode()[:HUB_MAX - len(tail.encode()) - 200].decode(errors='ignore')
    return cut[:cut.rfind('\n')] + tail


def main():
    dry = '--dry-run' in sys.argv
    only = [a for a in sys.argv[1:] if not a.startswith('--')]
    ref = os.environ.get('GITHUB_REF_NAME') or 'master'
    rows = subprocess.run([os.path.join(ROOT, 'bin', 'python', 'readme-sync.py'), '--map'],
                          capture_output=True, text=True, check=True).stdout.splitlines()

    hub_auth = None
    user, secret = os.environ.get('DOCKER_SERVER_LOGIN'), os.environ.get('DOCKER_API_TOKEN')
    if not user or not secret:
        print('::warning::DOCKER_SERVER_LOGIN / DOCKER_API_TOKEN not set - Docker Hub descriptions skipped')
    elif not dry:
        try:   # current API: PAT -> bearer access token
            hub_auth = 'Bearer ' + request('POST', 'https://hub.docker.com/v2/auth/token',
                                           {'identifier': user, 'secret': secret})['access_token']
        except urllib.error.HTTPError as e:
            print('::warning::hub /v2/auth/token: HTTP %s, trying /v2/users/login' % e.code)
            hub_auth = 'JWT ' + request('POST', 'https://hub.docker.com/v2/users/login/',
                                        {'username': user, 'password': secret})['token']
    quay_token = os.environ.get('QUAY_API_TOKEN')
    if not quay_token:
        print('::warning::QUAY_API_TOKEN not set - Quay descriptions skipped')

    failed = 0
    for row in rows:
        repo, readme, short = (row.split('\t') + ['', ''])[:3]
        if (only and repo not in only) or repo in SKIP:
            continue
        ns, name = repo.split('/', 1)
        text = absolutize(open(os.path.join(ROOT, readme)).read(), readme, ref)
        full = clip(text, readme, ref)
        short = short[:100]
        print('%-45s %6d bytes%s  %s' % (repo, len(full.encode()),
                                          ' (cut)' if full != text else '', short))
        if dry:
            continue
        try:
            if hub_auth:
                request('PATCH', 'https://hub.docker.com/v2/repositories/%s/%s/' % (ns, name),
                        {'full_description': full, 'description': short},
                        {'Authorization': hub_auth})
                print('  docker.io: ok')
        except urllib.error.HTTPError as e:
            failed += 1
            print('::error::%s docker.io: HTTP %s %s' % (repo, e.code, e.read()[:300].decode(errors='ignore')))
        try:
            if quay_token:
                request('PUT', 'https://quay.io/api/v1/repository/%s/%s' % (ns, name),
                        {'description': text}, {'Authorization': 'Bearer ' + quay_token})
                print('  quay.io: ok')
        except urllib.error.HTTPError as e:
            failed += 1
            print('::error::%s quay.io: HTTP %s %s' % (repo, e.code, e.read()[:300].decode(errors='ignore')))
    sys.exit(1 if failed else 0)


if __name__ == '__main__':
    main()
