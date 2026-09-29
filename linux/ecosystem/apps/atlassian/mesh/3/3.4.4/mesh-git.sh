#!/bin/bash
# Bitbucket Mesh refuses to start with a git it does not support
# ("git.version.unsupported-from" / "git.versions.unsupported" in its mesh-core jar).
# Keep Debian's git when this Mesh release accepts it, otherwise build the newest
# patch of the newest accepted git series into ${GIT_PREFIX} (put first on PATH).
set -euo pipefail

: "${MESH_INSTALL_DIR:?}"
: "${GIT_PREFIX:?}"

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
echo "Mesh: git unsupported from ${UNSUPPORTED_FROM}, unsupported series ${UNSUPPORTED_LIST}"

series() { echo "$1" | cut -d. -f1-2; }
accepted() {
    local s=$1
    if [ "${UNSUPPORTED_FROM}" != "-" ] && ! dpkg --compare-versions "${s}" lt "${UNSUPPORTED_FROM}"; then
        return 1
    fi
    [[ ",${UNSUPPORTED_LIST}," != *",${s},"* ]]
}

DEBIAN_GIT=$(git --version | awk '{print $3}')
if accepted "$(series "${DEBIAN_GIT}")"; then
    echo "Debian git ${DEBIAN_GIT} is supported, keeping it"
    exit 0
fi

MAJOR=$(echo "${UNSUPPORTED_FROM}" | cut -d. -f1)
MINOR=$(echo "${UNSUPPORTED_FROM}" | cut -d. -f2)
MINOR=$((MINOR - 1))
while ! accepted "${MAJOR}.${MINOR}"; do
    MINOR=$((MINOR - 1))
done
GIT_SERIES="${MAJOR}.${MINOR}"
GIT_TARBALL=$(curl -fsSL https://mirrors.edge.kernel.org/pub/software/scm/git/ \
    | grep -oE "git-${GIT_SERIES//./\\.}\.[0-9]+\.tar\.xz" | sort -uV | tail -n 1)
test -n "${GIT_TARBALL}"
echo "Debian git ${DEBIAN_GIT} is not supported, building ${GIT_TARBALL%.tar.xz}"

SAVED_APT_MARK=$(apt-mark showmanual)
apt-get update
apt-get install -y --no-install-recommends --no-install-suggests \
    gcc make libc6-dev libcurl4-gnutls-dev libexpat1-dev libssl-dev zlib1g-dev

mkdir -p /tmp/git-src
curl -fsSL "https://mirrors.edge.kernel.org/pub/software/scm/git/${GIT_TARBALL}" \
    | tar -xJf - --strip-components=1 -C /tmp/git-src
make -C /tmp/git-src -j"$(nproc)" prefix="${GIT_PREFIX}" NO_TCLTK=1 NO_GETTEXT=1 NO_PYTHON=1 all
make -C /tmp/git-src prefix="${GIT_PREFIX}" NO_TCLTK=1 NO_GETTEXT=1 NO_PYTHON=1 install
rm -rf /tmp/git-src

apt-mark auto '.*' > /dev/null
[ -z "${SAVED_APT_MARK}" ] || apt-mark manual ${SAVED_APT_MARK} > /dev/null
apt-get purge -y --auto-remove -o APT::AutoRemove::RecommendsImportant=false

BUILT_GIT=$("${GIT_PREFIX}/bin/git" --version | awk '{print $3}')
echo "git ${BUILT_GIT} installed into ${GIT_PREFIX}"
accepted "$(series "${BUILT_GIT}")"
