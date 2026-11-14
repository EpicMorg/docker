#!/bin/bash
# Bitbucket Mesh refuses to start with a git it does not support
# ("git.version.unsupported-from" / "git.versions.unsupported" in its mesh-core jar).
# The image takes epicmorg/git pinned per release (bin/ansible/roles/atlassian.mesh/vars/main.yml:
# mesh_git); this asserts at build time that the release accepts the git on PATH.
set -euo pipefail

: "${MESH_INSTALL_DIR:?}"

read -r UNSUPPORTED_FROM UNSUPPORTED_LIST < <(python3 - "${MESH_INSTALL_DIR}/bin/mesh-app.jar" <<'PY'
import io, re, sys, zipfile
app = zipfile.ZipFile(sys.argv[1])
props = {}
for name in app.namelist():
    if re.match(r'BOOT-INF/lib/mesh-core-[^/]*\.jar$', name):
        core = zipfile.ZipFile(io.BytesIO(app.read(name)))
        for p in core.namelist():
            if p.endswith('.properties'):
                for line in core.read(p).decode('utf-8', 'replace').splitlines():
                    m = re.match(r'\s*(git\.versions?\.unsupported(?:-from)?)\s*=\s*(\S*)', line)
                    if m:
                        props[m.group(1)] = m.group(2)
print(props.get('git.version.unsupported-from') or '-', props.get('git.versions.unsupported') or '-')
PY
)
test -n "${UNSUPPORTED_FROM:-}"   # the jar scan above must have produced a line

GIT=$(git --version | awk '{print $3}')
SERIES=$(echo "${GIT}" | cut -d. -f1-2)
echo "Mesh: git unsupported from ${UNSUPPORTED_FROM}, unsupported series ${UNSUPPORTED_LIST}; git on PATH ${GIT}"
if [ "${UNSUPPORTED_FROM}" != "-" ] && ! dpkg --compare-versions "${SERIES}" lt "${UNSUPPORTED_FROM}"; then
    echo "FATAL: this Mesh release does not support git ${SERIES} (unsupported from ${UNSUPPORTED_FROM}) - fix mesh_git" >&2
    exit 1
fi
if [[ ",${UNSUPPORTED_LIST}," == *",${SERIES},"* ]]; then
    echo "FATAL: this Mesh release lists git ${SERIES} as unsupported (${UNSUPPORTED_LIST}) - fix mesh_git" >&2
    exit 1
fi
echo "git ${GIT} is supported by this Mesh release"
