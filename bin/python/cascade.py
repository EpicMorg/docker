#!/usr/bin/env python3
"""Build (and publish) every image leaf under the given folders, in order.

A leaf is a directory holding both Dockerfile and docker-compose.yml. Each leaf
is built with its own Makefile (`make build`, then `make deploy`), i.e. through
buildah-wrapper / kaniko-wrapper exactly as CI does. Leaves run one by one in
the order the folders are given; inside a folder they are sorted by version.

Several invocations can run in parallel as "lanes" and wait for each other
through marker files (--wait-for / --done-file), e.g.

  # lane A: base, then compilers; marks gcc as done
  bin/python/cascade.py linux/ecosystem/base/debian/13-trixie/main \\
      linux/ecosystem/apps/gcc --done-file /tmp/cascade/gcc.done --stop-on-fail
  # lane B: starts when lane A has finished gcc
  bin/python/cascade.py linux/ecosystem/apps/python linux/ecosystem/apps/java/jdk \\
      --wait-for /tmp/cascade/gcc.done

Status lines (START / OK / FAIL / SKIP / DONE) go to --status, one log per leaf
to --logs. `--retry FILE` rebuilds only the leaves that FAILed in a previous
status file. After every leaf its local images are removed and dangling layers
older than --prune-after are pruned, so a long run does not fill the disk.

Usage: bin/python/cascade.py FOLDER [FOLDER ...] [options]
  --order asc|desc      version order inside a folder (default asc)
  --exclude REGEX       skip leaves whose path matches (repeatable)
  --no-deploy           build only
  --stop-on-fail        stop the lane at the first failure (default: keep going)
  --wait-for FILE       wait until FILE exists before starting (repeatable)
  --done-file FILE      touch FILE when the lane finishes without a stop
  --status FILE         status file (default: cascade-status.txt in the cwd)
  --logs DIR            per-leaf logs (default: cascade-logs/ in the cwd)
  --retry FILE          only leaves that failed (last result) in that status file
  --prune-after DUR     podman image prune --filter until=DUR (default 3h)
  --dry-run             list the leaves and exit
"""
import argparse
import datetime
import os
import re
import subprocess
import sys
import time

ROOT = os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))


def vkey(s):
    return [(0, int(p), '') if p.isdigit() else (1, 0, p) for p in re.split(r'(\d+)', s)]


def leaves(folder, order):
    base = os.path.join(ROOT, folder)
    if not os.path.isdir(base):
        sys.exit('no such folder: %s' % folder)
    found = []
    for d, dirs, files in os.walk(base):
        if 'Dockerfile' in files and 'docker-compose.yml' in files:
            found.append(os.path.relpath(d, ROOT))
    return sorted(found, key=vkey, reverse=(order == 'desc'))


def images(leaf):
    text = open(os.path.join(ROOT, leaf, 'docker-compose.yml')).read()
    refs = re.findall(r'^\s*image:\s*"?([^"\s]+?)"?\s*$', text, re.M)
    refs += [re.sub(r'^\s*-\s*', '', m) for m in re.findall(r'^\s*-\s*"?[a-z0-9.-]+\.[a-z]+/[^"\s]+', text, re.M)]
    return sorted(set(refs))


def failed(status_file):
    last = {}
    for line in open(status_file):
        m = re.match(r'^\S+ \S+ (OK|FAIL)\s+(\S+)', line)
        if m:
            last[m.group(2)] = m.group(1)
    return [leaf for leaf, res in last.items() if res == 'FAIL']


def main():
    ap = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    ap.add_argument('folders', nargs='*')
    ap.add_argument('--order', choices=('asc', 'desc'), default='asc')
    ap.add_argument('--exclude', action='append', default=[])
    ap.add_argument('--no-deploy', action='store_true')
    ap.add_argument('--stop-on-fail', action='store_true')
    ap.add_argument('--wait-for', action='append', default=[])
    ap.add_argument('--done-file')
    ap.add_argument('--status', default='cascade-status.txt')
    ap.add_argument('--logs', default='cascade-logs')
    ap.add_argument('--retry')
    ap.add_argument('--prune-after', default='3h')
    ap.add_argument('--dry-run', action='store_true')
    a = ap.parse_args()

    if a.retry:
        todo = failed(a.retry)
    else:
        if not a.folders:
            ap.error('give at least one folder (or --retry FILE)')
        todo = []
        for f in a.folders:
            for leaf in leaves(f.rstrip('/'), a.order):
                if leaf not in todo:
                    todo.append(leaf)
    excl = [re.compile(x) for x in a.exclude]
    todo = [leaf for leaf in todo if not any(x.search(leaf) for x in excl)]

    if a.dry_run:
        print('\n'.join(todo))
        print('%d leaves' % len(todo), file=sys.stderr)
        return

    os.makedirs(a.logs, exist_ok=True)

    def log(msg):
        with open(a.status, 'a') as fh:
            fh.write('%s %s\n' % (datetime.datetime.now().strftime('%F %T'), msg))
            fh.flush()

    for w in a.wait_for:
        while not os.path.exists(w):
            time.sleep(30)

    head = subprocess.run(['git', '-C', ROOT, 'log', '--oneline', '-1'], capture_output=True, text=True).stdout.strip()
    log('BEGIN %d leaves @ %s' % (len(todo), head))
    stopped = False
    for leaf in todo:
        lg = os.path.join(a.logs, leaf.replace('/', '_') + '.log')
        log('START %s' % leaf)
        steps = 'make build' + ('' if a.no_deploy else ' && make deploy')
        with open(lg, 'w') as out:
            rc = subprocess.run(steps, shell=True, cwd=os.path.join(ROOT, leaf),
                                stdout=out, stderr=subprocess.STDOUT).returncode
        if rc == 0:
            log('OK    %s' % leaf)
        else:
            hint = ''
            for line in open(lg, errors='ignore'):
                if re.search(r' error:|FATAL|E: |Error: building', line):
                    hint = re.sub(r'\x1b\[[0-9;]*m', '', line).strip()[:160]
                    break
            log('FAIL  %s (%s; log %s)' % (leaf, hint or 'rc=%d' % rc, lg))
        # free the disk: this leaf's local images + old dangling layers
        for ref in images(leaf):
            for n in (ref, 'localhost/' + ref, 'docker.io/' + ref):
                subprocess.run(['buildah', 'rmi', '-f', n], capture_output=True)
        subprocess.run(['podman', 'image', 'prune', '-f', '--filter', 'until=' + a.prune_after], capture_output=True)
        if rc != 0 and a.stop_on_fail:
            log('STOP  after %s' % leaf)
            stopped = True
            break
    log('DONE')
    if a.done_file and not stopped:
        open(a.done_file, 'a').close()
    sys.exit(1 if stopped else 0)


if __name__ == '__main__':
    main()
