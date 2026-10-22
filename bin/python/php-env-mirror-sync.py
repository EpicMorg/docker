#!/usr/bin/env python3
"""Keep the mirrored php ENV blocks of the php consumers in step with apps/php.

teamcity/agent/php*, github/runner/php* and gitlab/runner/php* copy
epicmorg/php:<ver>'s /emg-export and repeat its ENV in a block that starts
with "# Mirrored from the epicmorg/php:<ver> image config" and ends at
"ENV PATH="; their build asserts every ENV of the php image (ENV parity), so a
php bump that changes or adds an ENV breaks them until the block follows.

For each consumer: take the ENV / ARG lines of the final stage of
linux/ecosystem/apps/php/<ver>/Dockerfile, resolve ${VAR} references from the
php file's own earlier values, the block's current (already resolved) values
and EMG_LOCAL_BASE_DIR; every key that resolves completely is updated in the
block, or added before ENV PATH when it is new - only the php image's own
variables (OWN prefixes); keys that do not resolve are left as they are and
listed.

Usage: bin/python/php-env-mirror-sync.py [--dry-run]
"""
import glob
import os
import re
import sys

ROOT = os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
APPS = os.path.join(ROOT, 'linux', 'ecosystem', 'apps')
CONSUMERS = ('teamcity/agent/php*', 'github/runner/php*', 'gitlab/runner/php*')
KNOWN = {'EMG_LOCAL_BASE_DIR': '/usr/local/share/epicmorg'}
# only the php image's own variables are mirrored; the rest (zlib, icu, openssl,
# PKG_CONFIG_PATH ...) come from the consumer's base the same way
OWN = ('PHP_', 'PEAR_', 'PECL_', 'P4PHP_', 'PIE_', 'COMPOSER_', 'EMG_PHP_')
SKIP = {'PATH'}
REF = re.compile(r'\$\{([A-Za-z0-9_]+)\}|\$([A-Za-z_][A-Za-z0-9_]*)')
LINE = re.compile(r'^(ENV|ARG) ([A-Za-z_][A-Za-z0-9_]*)=(.*)$')


def unquote(v):
    v = v.strip()
    if len(v) >= 2 and v[0] == v[-1] == '"':
        return v[1:-1]
    return v


def php_final_vars(ver):
    """[(kind, key, raw value)] of the php image's final stage, in order."""
    text = open(os.path.join(APPS, 'php', ver, 'Dockerfile')).read().splitlines()
    starts = [i for i, l in enumerate(text) if l.startswith('FROM ')]
    out = []
    for line in text[starts[-1]:]:
        m = LINE.match(line)
        if m:
            out.append((m.group(1), m.group(2), unquote(m.group(3))))
    return out


def resolve(raw, scope):
    missing = []

    def sub(m):
        k = m.group(1) or m.group(2)
        if k in scope:
            return scope[k]
        missing.append(k)
        return m.group(0)
    val = REF.sub(sub, raw)
    return (None if missing else val), missing


def main():
    dry = '--dry-run' in sys.argv
    changed = 0
    for pattern in CONSUMERS:
        for df in sorted(glob.glob(os.path.join(APPS, pattern, 'Dockerfile'))):
            text = open(df).read()
            m = re.search(r'^FROM ghcr\.io/epicmorg/php:([0-9.]+) AS php$', text, re.M)
            if not m:
                continue
            ver = m.group(1)
            lines = text.splitlines(True)
            try:
                b0 = next(i for i, l in enumerate(lines) if l.startswith('# Mirrored from the epicmorg/php:'))
                b1 = next(i for i in range(b0, len(lines)) if lines[i].startswith('ENV PATH='))
            except StopIteration:
                sys.exit('FATAL: no mirrored ENV block in %s' % df)
            block = {}
            for i in range(b0, b1):
                lm = LINE.match(lines[i].rstrip('\n'))
                if lm and lm.group(1) == 'ENV':
                    block[lm.group(2)] = (i, unquote(lm.group(3)))
            scope = dict(KNOWN)
            scope.update({k: v for k, (_, v) in block.items()})
            want, unresolved = {}, []
            php_env = set()
            for kind, key, raw in php_final_vars(ver):
                val, miss = resolve(raw, scope)
                own = key.startswith(OWN) and key not in SKIP
                if val is None:
                    if kind == 'ENV' and own:
                        unresolved.append('%s (%s)' % (key, ','.join(miss)))
                    continue
                scope[key] = val
                if kind == 'ENV' and own:
                    want[key] = val
                    php_env.add(key)
            rel = os.path.relpath(df, ROOT)
            edits = []
            for key, val in want.items():
                new = 'ENV %s="%s"\n' % (key, val)
                if key in block:
                    i, cur = block[key]
                    if cur != val:
                        edits.append(('set', i, new, '%s: %r -> %r' % (key, cur, val)))
                else:
                    edits.append(('add', b1, new, '%s: new %r' % (key, val)))
            if not edits:
                continue
            changed += 1
            print('%s (php %s)' % (rel, ver))
            for _, _, _, msg in edits:
                print('  ' + msg)
            if unresolved:
                print('  (left as is, unresolved: %s)' % ', '.join(unresolved))
            if dry:
                continue
            adds = [e[2] for e in edits if e[0] == 'add']
            for kind, i, new, _ in edits:
                if kind == 'set':
                    lines[i] = new
            lines[b1:b1] = adds
            open(df, 'w').write(''.join(lines))
    print('%d file(s) %s' % (changed, 'would change' if dry else 'written'))


if __name__ == '__main__':
    main()
