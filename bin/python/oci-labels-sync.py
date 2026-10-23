#!/usr/bin/env python3
"""Static OCI labels of every image leaf: own title and description, no legacy maintainer.

Labels are inherited, so a leaf that sets none shows its parent's title ("EpicMorg Debian")
in the registries. Every leaf (Dockerfile + docker-compose.yml) under linux/ must set
org.opencontainers.image.title and .description in its final stage:

  * a leaf that already has them keeps them, unless they are a copy of the Debian base
    labels in an image that is not epicmorg/debian (zabbix, webtlo, vscode-server, sentry);
  * otherwise title = TITLES[<repo>] (repo = the compose `image:`), description = the repo's
    `<!-- hub-description: ... -->` (bin/python/readme-sync.py --map) or DESCRIPTIONS[<repo>];
    both go right below the final FROM.

`LABEL maintainer=...` is dropped everywhere (ADR-008: vendor + authors); a third-party author
named in it moves to org.opencontainers.image.authors. vendor / authors / url / source /
licenses come from the base image (base light sets them) - a leaf FROM a foreign image
carries the full set itself. Dynamic labels (created, revision, version, base.*) are the
wrapper's, never written here.

Atlassian leaves are generated from bin/ansible templates (which carry the labels) and are
only checked. linux/obsolete and mattermost are never touched.

Usage: bin/python/oci-labels-sync.py [--check] [FOLDER ...]
"""
import os
import re
import subprocess
import sys

ROOT = os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
SKIP = ('linux/obsolete', 'linux/ecosystem/apps/mattermost')
GENERATED = ('linux/ecosystem/apps/atlassian/',)
HAND_KEPT = ('linux/ecosystem/apps/atlassian/sdk/',)
DEB_TITLES = {'EpicMorg Debian', 'EpicMorg Debian (Light)'}
DEB_DESCRIPTIONS = {'Debian base by EpicMorg', 'Debian Trixie base by EpicMorg'}

TITLES = {
    'epicmorg/ansible': 'EpicMorg Ansible',
    'epicmorg/atlassian-sdk': 'EpicMorg Atlassian SDK',
    'epicmorg/cassandra': 'EpicMorg Cassandra',
    'epicmorg/debian': 'EpicMorg Debian',
    'epicmorg/electron-release-server': 'EpicMorg Electron Release Server',
    'epicmorg/enodia': 'EpicMorg Enodia',
    'epicmorg/github-runner': 'EpicMorg GitHub Actions runner',
    'epicmorg/gitlab-runner': 'EpicMorg GitLab Runner',
    'epicmorg/go': 'EpicMorg Go',
    'epicmorg/monero': 'EpicMorg Monero',
    'epicmorg/nextcloud': 'EpicMorg Nextcloud',
    'epicmorg/nginx': 'EpicMorg nginx',
    'epicmorg/ninjam': 'EpicMorg NINJAM',
    'epicmorg/opentracker': 'EpicMorg opentracker',
    'epicmorg/p4p': 'EpicMorg p4p',
    'epicmorg/perforce': 'EpicMorg Perforce',
    'epicmorg/pg-upgrade-tool': 'EpicMorg pg-upgrade-tool',
    'epicmorg/postgres': 'EpicMorg PostgreSQL',
    'epicmorg/postgres-patroni': 'EpicMorg PostgreSQL + Patroni',
    'epicmorg/qbittorrent': 'EpicMorg qBittorrent',
    'epicmorg/sentry': 'EpicMorg Sentry',
    'epicmorg/steam': 'EpicMorg SteamCMD',
    'epicmorg/supermicro-management-plugin': 'EpicMorg Supermicro management plugin',
    'epicmorg/teamcity-agent': 'EpicMorg TeamCity Agent',
    'epicmorg/telegram': 'EpicMorg Telegram bots',
    'epicmorg/torrserver': 'EpicMorg TorrServer',
    'epicmorg/vk2discord': 'EpicMorg vk2discord',
    'epicmorg/vscode-server': 'EpicMorg VS Code Server',
    'epicmorg/webtlo': 'EpicMorg webtlo',
    'epicmorg/zabbix-agent': 'EpicMorg Zabbix agent',
    'epicmorg/zabbix-agent2': 'EpicMorg Zabbix agent 2',
    'epicmorg/zabbix-java-gateway': 'EpicMorg Zabbix Java gateway',
    'epicmorg/zabbix-proxy-mysql': 'EpicMorg Zabbix proxy (MySQL)',
    'epicmorg/zabbix-proxy-sqlite3': 'EpicMorg Zabbix proxy (SQLite3)',
    'epicmorg/zabbix-server-mysql': 'EpicMorg Zabbix server (MySQL)',
    'epicmorg/zabbix-server-pgsql': 'EpicMorg Zabbix server (PostgreSQL)',
    'epicmorg/zabbix-snmptraps': 'EpicMorg Zabbix SNMP traps',
    'epicmorg/zabbix-web-apache-mysql': 'EpicMorg Zabbix web (Apache, MySQL)',
    'epicmorg/zabbix-web-apache-pgsql': 'EpicMorg Zabbix web (Apache, PostgreSQL)',
}
# repos without a root README of their own
DESCRIPTIONS = {
    'epicmorg/atlassian-sdk': 'Atlassian Plugin SDK on epicmorg/jdk with Maven, by EpicMorg',
    'epicmorg/sentry': 'Sentry (experimental) by EpicMorg',
}
# leaves whose title / description are not the repo's
LEAF_TITLES = {
    'linux/ecosystem/games/7d2d': ('EpicMorg 7 Days to Die server', '7 Days to Die dedicated server (SteamCMD) by EpicMorg'),
    'linux/ecosystem/games/cs2': ('EpicMorg Counter-Strike 2 server', 'Counter-Strike 2 dedicated server (SteamCMD) by EpicMorg'),
}
EPICMORG_MAINTAINER = 'EpicMorg DevTeam, developer@epicm.org'
AUTHORS = 'STAM, kasthack, Aleks-Z'


def hub_descriptions():
    out = subprocess.run([os.path.join(ROOT, 'bin', 'python', 'readme-sync.py'), '--map'],
                         capture_output=True, text=True, check=True).stdout
    return {r.split('\t')[0]: r.split('\t')[2] for r in out.splitlines() if r.count('\t') >= 2}


def leaves(folders):
    for folder in folders:
        for d, dirs, files in os.walk(os.path.join(ROOT, folder)):
            rel = os.path.relpath(d, ROOT)
            if rel.startswith(SKIP):
                dirs[:] = []
                continue
            dirs.sort()
            if 'Dockerfile' in files and 'docker-compose.yml' in files:
                yield rel


def repo_of(leaf):
    m = re.search(r'^\s*image:\s*"?(?:[a-z0-9.-]+\.[a-z]+/)?([^":\s]+)', open(os.path.join(ROOT, leaf, 'docker-compose.yml')).read(), re.M)
    return m.group(1) if m else None


def label(key, value):
    return 'LABEL org.opencontainers.image.%s="%s"\n' % (key, value.replace('"', '\\"'))


def fix(text, leaf, repo, hub):
    """Return (new text, [problems]) for one Dockerfile."""
    problems = []
    # maintainer: drop, keep a third-party author as authors
    def drop(m):
        who = [w.strip() for w in m.group(1).split(';') if w.strip() and w.strip() != EPICMORG_MAINTAINER]
        who = [w for w in who if not w.startswith('Atlassian ')]
        if who:
            author = re.sub(r'^original by\s+', '', who[0])
            return label('authors', '%s; %s' % (author, AUTHORS))
        return ''
    text = re.sub(r'^LABEL maintainer="([^"]*)"\n', drop, text, flags=re.M)

    starts = [m.start() for m in re.finditer(r'^FROM\s', text, re.M)]
    if not starts:
        return text, ['no FROM']
    head, final = text[:starts[-1]], text[starts[-1]:]
    from_line = final.split('\n', 1)[0]
    is_debian = repo == 'epicmorg/debian' or repo == 'epicmorg/astralinux'
    want_title, want_desc = LEAF_TITLES.get(leaf, (TITLES.get(repo), hub.get(repo) or DESCRIPTIONS.get(repo)))
    if repo == 'epicmorg/astralinux' and leaf not in LEAF_TITLES:
        # one title per release, as its light image has it
        light = os.path.join(ROOT, os.path.dirname(leaf), 'light', 'Dockerfile')
        m = re.search(r'^LABEL org\.opencontainers\.image\.title="([^"]*)"', open(light).read(), re.M)
        want_title = m and m.group(1)

    for key, want, inherited in (('title', want_title, DEB_TITLES), ('description', want_desc, DEB_DESCRIPTIONS)):
        m = re.search(r'^LABEL org\.opencontainers\.image\.%s="([^"]*)"\n' % key, final, re.M)
        if m and (is_debian or m.group(1) not in inherited):
            continue
        if not want:
            problems.append('no %s for %s' % (key, repo))
            continue
        if m:
            final = final[:m.start()] + label(key, want) + final[m.end():]
        else:
            # right below FROM (after the title if that was just added)
            at = len(from_line) + 1
            t = re.match(r'(?:LABEL org\.opencontainers\.image\.title="[^"]*"\n)', final[at:])
            if t and key == 'description':
                at += t.end()
            final = final[:at] + label(key, want) + final[at:]
    return head + final, problems


def check_only(text):
    starts = [m.start() for m in re.finditer(r'^FROM\s', text, re.M)]
    final = text[starts[-1]:] if starts else ''
    bad = []
    for key in ('title', 'description'):
        if not re.search(r'^LABEL org\.opencontainers\.image\.%s=' % key, final, re.M):
            bad.append('no %s' % key)
    if re.search(r'^LABEL maintainer=', text, re.M):
        bad.append('maintainer label')
    return bad


def main(argv):
    check = '--check' in argv
    folders = [a.rstrip('/') for a in argv if not a.startswith('--')] or ['linux']
    hub = hub_descriptions()
    changed, failed = 0, []
    for leaf in leaves(folders):
        path = os.path.join(ROOT, leaf, 'Dockerfile')
        text = open(path).read()
        if leaf.startswith(GENERATED) and not leaf.startswith(HAND_KEPT):
            failed += ['%s: %s' % (leaf, p) for p in check_only(text)]
            continue
        new, problems = fix(text, leaf, repo_of(leaf), hub)
        failed += ['%s: %s' % (leaf, p) for p in problems]
        if new != text:
            changed += 1
            if check:
                failed.append('%s: labels out of date' % leaf)
            else:
                open(path, 'w').write(new)
    for f in failed:
        print(f, file=sys.stderr)
    print('%s %d Dockerfiles, %d problems' % ('would change' if check else 'changed', changed, len(failed)))
    return 1 if failed else 0


if __name__ == '__main__':
    sys.exit(main(sys.argv[1:]))
