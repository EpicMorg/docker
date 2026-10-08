#!/usr/bin/env python3
"""Create / refresh the ansible runtime leaves and their TeamCity agents.

  linux/ecosystem/apps/ansible/<major.minor>                -> epicmorg/ansible:<mm>, :<full> (+ :latest)
  linux/ecosystem/apps/teamcity/agent/ansible/<major.minor> -> epicmorg/teamcity-agent:ansible-<mm>,
                                                               ansible-<full> (+ :ansible)

One folder per ansible-core line (major.minor), always the newest patch of that
line on PyPI. Every file of both leaves is generated here:

* Python: the newest Python the line supports as a controller (PYTHON below):
  a venv on our own epicmorg/python:<ver> (FROM that image).
* requirements.txt: the toolset of the newest line's requirements.txt (the
  reference), each package at its newest release that installs on that Python;
  ansible-lint at its newest release that accepts this ansible-core, directly
  and through ansible-compat (pinned too); pins of the reference are the ceiling.
* collections.yml: the collections of the newest line's collections.yml, each
  at its newest Galaxy release whose requires_ansible accepts the line
  (dropped when none does).
* The runtime exports venv + collections (+ the Python and the baked libraries
  it links) under /emg-export; the agent takes it with COPY --from.

The newest line carries the floating tags (`latest` / `ansible`).

Usage: bin/python/ansible-versions-sync.py [--dry-run] [--add 2.11,2.12] [--only 2.16]
"""
import json
import os
import re
import sys
import urllib.request

from packaging.specifiers import SpecifierSet
from packaging.version import InvalidVersion, Version

ROOT = os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
RUNTIME = os.path.join(ROOT, 'linux', 'ecosystem', 'apps', 'ansible')
AGENT = os.path.join(ROOT, 'linux', 'ecosystem', 'apps', 'teamcity', 'agent', 'ansible')
GALAXY = 'https://galaxy.ansible.com/api/v3/plugin/ansible/content/published/collections/index/%s/%s/versions/?limit=100'
SYSTEM_PYTHON = None              # every line runs on epicmorg/python (owner, 2026-10-08)
# newest controller Python per ansible-core line (ansible-core support matrix; our python
# images pin Debian's python3* out of apt, so those lines take nothing python from apt);
# ansible-galaxy before 2.13.9 cannot talk to today's galaxy.ansible.com: such lines install
# their collections with a throw-away ansible-core GALAXY_HELPER venv.
GALAXY_HELPER = '2.15.13'
# lines not listed run on SYSTEM_PYTHON
PYTHON = {'2.11': '3.9', '2.12': '3.10', '2.13': '3.10', '2.14': '3.11', '2.15': '3.11',
          '2.16': '3.12', '2.17': '3.12', '2.18': '3.13', '2.19': '3.13', '2.20': '3.14', '2.21': '3.14'}

_cache = {}


def get(url):
    if url not in _cache:
        _cache[url] = json.load(urllib.request.urlopen(url, timeout=60))
    return _cache[url]


def vkey(v):
    return [int(x) for x in v.split('.')]


def releases(pkg):
    """[(Version, info)] newest first, final releases with files only."""
    rel = get('https://pypi.org/pypi/%s/json' % pkg)['releases']
    out = []
    for v, files in rel.items():
        try:
            pv = Version(v)
        except InvalidVersion:
            continue
        if files and not pv.is_prerelease and not any(f.get('yanked') for f in files):
            out.append((pv, files))
    return sorted(out, key=lambda x: x[0], reverse=True)


def requires_python(files):
    spec = next((f.get('requires_python') for f in files if f.get('requires_python')), None)
    return SpecifierSet(spec or '')


def core_lines():
    """{major.minor: newest major.minor.patch} for every final ansible-core release."""
    out = {}
    for v, _ in releases('ansible-core'):
        if len(v.release) == 3:
            mm = '%d.%d' % v.release[:2]
            out.setdefault(mm, str(v))
    return out


def dep_spec(meta, name):
    """SpecifierSet of `name` in a PyPI release's requires_dist (None: not required)."""
    for r in meta.get('requires_dist') or []:
        m = re.match(r'%s\b\s*\(?([^);]*)\)?\s*(;.*)?$' % re.escape(name), r)
        if m and 'extra ==' not in (m.group(2) or ''):
            return SpecifierSet(m.group(1).strip())
    return None


def compat_for(spec, core, py):
    """Newest ansible-compat within spec that installs on py and accepts ansible-core==core."""
    for v, files in releases('ansible-compat'):
        if v not in spec or py not in requires_python(files):
            continue
        cs = dep_spec(get('https://pypi.org/pypi/ansible-compat/%s/json' % v)['info'], 'ansible-core')
        if cs is None or core in cs:
            return str(v)
    return None


def lint_for(core, py, cap):
    """(ansible-lint, ansible-compat or None): newest ansible-lint (<= cap) that installs on py
    and accepts ansible-core==core - directly and through its ansible-compat dependency."""
    for v, files in releases('ansible-lint'):
        if v > Version(cap) or py not in requires_python(files):
            continue
        meta = get('https://pypi.org/pypi/ansible-lint/%s/json' % v)['info']
        spec = dep_spec(meta, 'ansible-core')
        if spec is not None and core not in spec:
            continue
        cspec = dep_spec(meta, 'ansible-compat')
        if cspec is None:
            return str(v), None
        compat = compat_for(cspec, core, py)
        if compat:
            return str(v), compat
    sys.exit('no ansible-lint for ansible-core %s / python %s' % (core, py))


def newest_for_python(pkg, py, cap=None):
    for v, files in releases(pkg):
        if (cap is None or v <= Version(cap)) and py in requires_python(files):
            return str(v)
    sys.exit('no %s for python %s' % (pkg, py))


def requirements(ref_text, core, py):
    out = ['# ansible-core %s (newest patch of its line) on Python %s; the rest is the lint / deploy toolset,' % (core, py),
           '# each at its newest release for this Python / ansible-core (bin/python/ansible-versions-sync.py).']
    for line in ref_text.splitlines():
        m = re.match(r'^([A-Za-z0-9_.-]+)==(\S+)$', line.strip())
        if not m:
            if line.strip() and not line.startswith('#'):
                out.append(line)
            continue
        pkg, pin = m.groups()
        if pkg == 'ansible-core':
            out.append('ansible-core==' + core)
        elif pkg == 'ansible-lint':
            lint, compat = lint_for(core, py, pin)
            out.append('ansible-lint==' + lint)
            if compat:
                out.append('ansible-compat==' + compat)
        elif pkg == 'ansible-compat':
            continue
        else:
            out.append('%s==%s' % (pkg, newest_for_python(pkg, py, cap=pin)))
    return '\n'.join(out) + '\n'


def collection_for(name, line):
    ns, col = name.split('.')
    url = GALAXY % (ns, col)
    target = Version(line + '.99')
    while url:
        page = get(url)
        for d in page['data']:
            v = Version(d['version'])
            if v.is_prerelease:
                continue
            spec = SpecifierSet(d.get('requires_ansible') or '')
            if Version(line + '.0') in spec or target in spec:
                return d['version']
        nxt = page.get('links', {}).get('next')
        url = ('https://galaxy.ansible.com' + nxt) if nxt and nxt.startswith('/') else nxt
    return None


def collections(ref_text, line):
    names = re.findall(r'(?m)^\s*-\s*name:\s*(\S+)', ref_text)
    out = ['# Collections installed into the runtime: newest Galaxy release whose requires_ansible accepts %s' % line,
           '# (bin/python/ansible-versions-sync.py).', 'collections:']
    for n in names:
        v = collection_for(n, line)
        if v:
            out += ['  - name: %s' % n, '    version: %s' % v]
        else:
            out.append('  # %s: no release supports ansible-core %s' % (n, line))
    return '\n'.join(out) + '\n'


RUNTIME_DF = '''##################################################################
#        ansible runtime (venv + collections) for COPY --from
##################################################################
# Generated by bin/python/ansible-versions-sync.py - edit the generator, not this file.
# Folder = ansible-core major.minor, image = newest patch of that line, on the
# newest Python that line supports as a controller ({PYDESC}).
# Consumers (e.g. teamcity-agent:ansible-<ver>), Debian 13 based:
#   COPY --from=ghcr.io/epicmorg/ansible:<ver> /emg-export/ /
FROM {BASE}
ARG DEBIAN_FRONTEND=noninteractive

ENV EMG_ANSIBLE_VERSION={MM}
ENV EMG_ANSIBLE_CORE_VERSION={FULL}
ENV EMG_ANSIBLE_PYTHON={PYBIN}
ENV EMG_ANSIBLE_DIR=${{EMG_LOCAL_BASE_DIR}}/ansible/${{EMG_ANSIBLE_VERSION}}
ENV ANSIBLE_COLLECTIONS_PATH=${{EMG_ANSIBLE_DIR}}/collections
ENV ANSIBLE_FORCE_COLOR=0
ENV PATH=${{EMG_ANSIBLE_DIR}}/venv/bin:${{PATH}}

COPY requirements.txt collections.yml ${{EMG_ANSIBLE_DIR}}/

RUN set -eux; \\
    apt-get update; \\
    apt-get install -y --no-install-recommends --no-install-suggests \\
{APT_PY}        sshpass \\
        openssh-client \\
        rsync; \\
    ${{EMG_ANSIBLE_PYTHON}} -m venv ${{EMG_ANSIBLE_DIR}}/venv; \\
    ${{EMG_ANSIBLE_DIR}}/venv/bin/pip install --no-cache-dir --upgrade pip; \\
    ${{EMG_ANSIBLE_DIR}}/venv/bin/pip install --no-cache-dir -r ${{EMG_ANSIBLE_DIR}}/requirements.txt; \\
{GALAXY}    for b in ${{EMG_ANSIBLE_DIR}}/venv/bin/ansible* ${{EMG_ANSIBLE_DIR}}/venv/bin/yamllint; do ln -sfn "$b" /usr/local/bin/; done; \\
    apt-get clean; \\
    rm -rf /var/lib/apt/lists/* /var/cache/apt/archives/*.deb /root/.cache /tmp/*

# /emg-export: the venv + collections and, for a Python of our own, that Python
# with every epicmorg-prefixed library it links (openssl, zlib, ...); debian-deps.txt lists the
# Debian packages of the system libraries it links (the consumer installs them).
RUN set -eux; \\
    mkdir -p /emg-export; \\
    cp -a --parents ${{EMG_ANSIBLE_DIR}} /emg-export/; \\
    py="$(readlink -f ${{EMG_ANSIBLE_PYTHON}})"; \\
    case "$py" in \\
      ${{EMG_LOCAL_BASE_DIR}}/*) \\
        pydir="$(dirname "$(dirname "$py")")"; \\
        cp -a --parents "$pydir" /emg-export/; \\
        find "$pydir" -type f \\( -name '*.so*' -o -perm -u+x \\) -exec ldd {{}} \\; 2>/dev/null \\
          | sed -n "s#.*=> \\(${{EMG_LOCAL_BASE_DIR}}/[^/]*/[^/]*\\)/.*#\\1#p" | sort -u \\
          | while read -r d; do cp -a --parents "$d" /emg-export/; done; \\
        find "$pydir" -type f \\( -name '*.so*' -o -perm -u+x \\) -exec ldd {{}} \\; 2>/dev/null \\
          | sed -n 's#.*=> \\(/[^ ]*\\) .*#\\1#p' | grep -v "^${{EMG_LOCAL_BASE_DIR}}/" | sort -u \\
          | while read -r l; do dpkg -S "$(readlink -f "$l")" 2>/dev/null || dpkg -S "$l"; done \\
          | cut -d: -f1 | sort -u > /emg-export${{EMG_ANSIBLE_DIR}}/debian-deps.txt ;; \\
    esac; \\
    touch /emg-export${{EMG_ANSIBLE_DIR}}/debian-deps.txt; \\
    cat /emg-export${{EMG_ANSIBLE_DIR}}/debian-deps.txt; \\
    du -sh /emg-export

{ASSERTS}
'''

ASSERTS = '''##################################################################
#                       Assertions (fatal)
##################################################################
RUN set -eu; \\
    [ "$(readlink -f "$(command -v ansible)")" = "$(readlink -f ${{EMG_ANSIBLE_DIR}}/venv/bin/ansible)" ] \\
      || {{ echo "FATAL: ansible on PATH is $(command -v ansible)" >&2; exit 1; }}; \\
    ansible --version | head -n1 | grep -q "core ${{EMG_ANSIBLE_CORE_VERSION}}\\]" \\
      || {{ echo "FATAL: not ansible-core ${{EMG_ANSIBLE_CORE_VERSION}}" >&2; ansible --version >&2; exit 1; }}; \\
    ${{EMG_ANSIBLE_DIR}}/venv/bin/python -c 'import sys; v = "%d.%d" % sys.version_info[:2]; assert v == "{PY}", v'; \\
    py="$(readlink -f ${{EMG_ANSIBLE_DIR}}/venv/bin/python)"; \\
    if ldd "$py" 2>&1 | grep -q 'not found'; then echo "FATAL: $py has unresolved deps" >&2; ldd "$py" >&2; exit 1; fi; \\
    for so in $(dirname "$(dirname "$py")")/lib/python{PY}/lib-dynload/*.so; do \\
      ldd "$so" 2>/dev/null | grep -q 'not found' && {{ echo "FATAL: $so has unresolved deps" >&2; ldd "$so" >&2; exit 1; }}; \\
    done; \\
    ${{EMG_ANSIBLE_DIR}}/venv/bin/python -c 'import ssl, hashlib, ctypes, sqlite3, lzma, bz2, zlib'; \\
    ansible --version; \\
    ansible-lint --version; \\
    ansible-galaxy collection list -p ${{ANSIBLE_COLLECTIONS_PATH}}; \\
    ansible localhost -c local -m ansible.builtin.ping'''

AGENT_DF = '''##################################################################
#        TeamCity agent + ansible runtime (ghcr.io/epicmorg/ansible:{MM})
##################################################################
# Generated by bin/python/ansible-versions-sync.py - edit the generator, not this file.
# The runtime (venv + collections + its Python) is taken as-is from the ansible image.
FROM ghcr.io/epicmorg/ansible:{MM} AS ansible

FROM ghcr.io/epicmorg/teamcity-agent:minimal
ARG DEBIAN_FRONTEND=noninteractive

ENV EMG_ANSIBLE_VERSION={MM}
ENV EMG_ANSIBLE_CORE_VERSION={FULL}
ENV EMG_ANSIBLE_PYTHON={PYBIN}
ENV EMG_ANSIBLE_DIR=${{EMG_LOCAL_BASE_DIR}}/ansible/${{EMG_ANSIBLE_VERSION}}
ENV ANSIBLE_COLLECTIONS_PATH=${{EMG_ANSIBLE_DIR}}/collections
ENV ANSIBLE_FORCE_COLOR=0
ENV PATH=${{EMG_ANSIBLE_DIR}}/venv/bin:${{PATH}}

COPY --from=ansible /emg-export/ /

RUN set -eux; \\
    apt-get update; \\
    apt-get install -y --no-install-recommends --no-install-suggests \\
        $(cat ${{EMG_ANSIBLE_DIR}}/debian-deps.txt) \\
        python3 \\
        sshpass \\
        openssh-client \\
        rsync; \\
    for b in ${{EMG_ANSIBLE_DIR}}/venv/bin/ansible* ${{EMG_ANSIBLE_DIR}}/venv/bin/yamllint; do ln -sfn "$b" /usr/local/bin/; done; \\
    apt-get clean; \\
    rm -rf /var/lib/apt/lists/* /var/cache/apt/archives/*.deb /tmp/*

{ASSERTS}

LABEL dockerImage.teamcity.version="latest" \\
      dockerImage.teamcity.buildNumber="latest"

WORKDIR ${{AGENT_DIST}}
'''


def galaxy(mm):
    install = 'collection install -r ${EMG_ANSIBLE_DIR}/collections.yml -p ${ANSIBLE_COLLECTIONS_PATH}; \\\n'
    if vkey(mm) >= [2, 13]:
        return '    ansible-galaxy ' + install
    return ('    ${EMG_ANSIBLE_PYTHON} -m venv /tmp/galaxy; \\\n'
            '    /tmp/galaxy/bin/pip install --no-cache-dir ansible-core==%s; \\\n'
            '    /tmp/galaxy/bin/ansible-galaxy ' % GALAXY_HELPER + install)


def compose(name, tags):
    s = 'services:\n  app:\n    image: "epicmorg/%s:%s"\n    build:\n      context: .\n    x-squash: false\n    x-mirrors:\n' % (name, tags[0])
    for t in tags:
        s += ''.join('      - %s/epicmorg/%s:%s\n' % (r, name, t) for r in ('quay.io', 'ghcr.io', 'docker.io'))
    return s


def write(path, text):
    os.makedirs(os.path.dirname(path), exist_ok=True)
    open(path, 'w').write(text)


def main():
    dry = '--dry-run' in sys.argv
    argv = [a for a in sys.argv if a != '--dry-run']
    args = dict(zip(argv[1::2], argv[2::2]))
    add = set(filter(None, args.get('--add', '').split(',')))
    only = set(filter(None, args.get('--only', '').split(',')))
    have = sorted((d for d in os.listdir(RUNTIME) if re.fullmatch(r'\d+\.\d+', d)), key=vkey)
    lines = sorted(set(have) | add, key=vkey)
    full = core_lines()
    missing = [mm for mm in lines if mm not in full]
    if missing:
        sys.exit('no ansible-core release on PyPI for: %s' % ', '.join(missing))
    newest = lines[-1]
    ref = os.path.join(RUNTIME, have[-1])
    ref_req = open(os.path.join(ref, 'requirements.txt')).read()
    ref_col = open(os.path.join(ref, 'collections.yml')).read()
    makefile = open(os.path.join(ref, 'Makefile')).read()
    for mm in reversed(lines):
        if only and mm not in only:
            continue
        f = full[mm]
        py = PYTHON.get(mm, SYSTEM_PYTHON)
        if py is None:
            sys.exit('ansible-core %s: add its controller Python to PYTHON' % mm)
        own = py != SYSTEM_PYTHON
        pybin = '${EMG_LOCAL_BASE_DIR}/python/%s/bin/python%s' % (py, py) if own else '/usr/bin/python3'
        base = 'ghcr.io/epicmorg/python:%s' % py if own else 'ghcr.io/epicmorg/debian:trixie'
        pydesc = 'epicmorg/python:%s' % py if own else "trixie's python3 %s" % py
        req = requirements(ref_req, f, py)
        col = collections(ref_col, mm)
        lint = re.search(r'(?m)^ansible-lint==(\S+)', req).group(1)
        print('%-5s %-8s python %-5s ansible-lint %-8s %s' % (mm, f, py, lint, 'new' if mm not in have else 'refresh'))
        if dry:
            continue
        asserts = ASSERTS.format(PY=py)
        rt, ag = os.path.join(RUNTIME, mm), os.path.join(AGENT, mm)
        write(os.path.join(rt, 'Dockerfile'), RUNTIME_DF.format(BASE=base, MM=mm, FULL=f, PYBIN=pybin, PYDESC=pydesc, ASSERTS=asserts,
                                 GALAXY=galaxy(mm),
                                 APT_PY='' if own else '        python3 \\\n        python3-venv \\\n'))
        write(os.path.join(rt, 'requirements.txt'), req)
        write(os.path.join(rt, 'collections.yml'), col)
        write(os.path.join(ag, 'Dockerfile'), AGENT_DF.format(MM=mm, FULL=f, PYBIN=pybin, ASSERTS=asserts))
        for d in (rt, ag):
            write(os.path.join(d, 'Makefile'), makefile)
        write(os.path.join(rt, 'docker-compose.yml'),
              compose('ansible', [mm, f] + (['latest'] if mm == newest else [])))
        write(os.path.join(ag, 'docker-compose.yml'),
              compose('teamcity-agent', ['ansible-' + mm, 'ansible-' + f] + (['ansible'] if mm == newest else [])))
    if not dry:
        print('next: bin/python/readme-sync.py linux/ecosystem/apps/ansible linux/ecosystem/apps/teamcity/agent')


if __name__ == '__main__':
    main()
