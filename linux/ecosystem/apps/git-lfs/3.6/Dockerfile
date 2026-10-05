##################################################################
#                 git-lfs (upstream release binary)
##################################################################
# All git-lfs leaves share this file; they differ only in the EMG_GIT_LFS_*
# block below (bumped by bin/python/git-lfs-versions-sync.py). git-lfs is a static Go
# binary: the upstream release archive is the artifact, nothing is compiled.
# Consumers (incl. the base image): COPY --from=docker.io/epicmorg/git-lfs:<ver> /emg-export/ /
FROM docker.io/epicmorg/debian:trixie
ARG DEBIAN_FRONTEND=noninteractive

ENV EMG_GIT_LFS_VERSION=3.6
ENV EMG_GIT_LFS_FULL_VERSION=3.6.1
ENV EMG_GIT_LFS_DIR=${EMG_LOCAL_BASE_DIR}/git-lfs/${EMG_GIT_LFS_VERSION}
# GitHub asset digest / sha256sums.asc of the release (computed once for old
# releases that publish neither)
ARG EMG_GIT_LFS_SHA256=2138d2e405a12f1a088272e06790b76699b79cb90d0317b77aafaf35de908d76
ARG EMG_GIT_LFS_URL=https://github.com/git-lfs/git-lfs/releases/download/v3.6.1/git-lfs-linux-amd64-v3.6.1.tar.gz

LABEL org.opencontainers.image.title="EpicMorg git-lfs"
LABEL org.opencontainers.image.description="git-lfs release binary for COPY --from into other images by EpicMorg"
LABEL org.opencontainers.image.source="https://github.com/EpicMorg/docker"
LABEL org.opencontainers.image.licenses="MIT"

# The archive layout changed over the years (git-lfs-<ver>/git-lfs, bare
# git-lfs, ...): take the single executable named git-lfs wherever it is.
RUN set -eux; \
    t="$(mktemp -d)"; \
    wget -q -O "$t/lfs.tar.gz" "${EMG_GIT_LFS_URL}"; \
    echo "${EMG_GIT_LFS_SHA256}  $t/lfs.tar.gz" | sha256sum -c -; \
    tar -xzf "$t/lfs.tar.gz" -C "$t"; \
    bin="$(find "$t" -type f -name git-lfs -perm -u+x | head -n1)"; \
    test -n "$bin"; \
    install -D -m 0755 "$bin" "${EMG_GIT_LFS_DIR}/bin/git-lfs"; \
    find "$t" -type f -path '*man*' \( -name '*.1' -o -name '*.5' \) | while read -r m; do \
      install -D -m 0644 "$m" "${EMG_GIT_LFS_DIR}/share/man/man${m##*.}/${m##*/}"; \
    done; \
    rm -rf "$t"; \
    mkdir -p /emg-export; \
    cp -a --parents "${EMG_GIT_LFS_DIR}" /emg-export/

ENV PATH="${EMG_GIT_LFS_DIR}/bin:${PATH}"

##################################################################
#                       Assertions (fatal)
##################################################################
RUN set -eu; \
    [ "$(command -v git-lfs)" = "${EMG_GIT_LFS_DIR}/bin/git-lfs" ] || { echo "FATAL: git-lfs on PATH is $(command -v git-lfs)" >&2; exit 1; }; \
    git-lfs version | grep -q "git-lfs/${EMG_GIT_LFS_FULL_VERSION} " || { echo "FATAL: not git-lfs ${EMG_GIT_LFS_FULL_VERSION}" >&2; git-lfs version >&2; exit 1; }; \
    if ldd "${EMG_GIT_LFS_DIR}/bin/git-lfs" 2>&1 | grep -q 'not found'; then echo "FATAL: unresolved deps" >&2; exit 1; fi; \
    # isolated from the base image's git/lfs config (written by the newest lfs,
    # e.g. filter-process, which old releases do not know)
    t="$(mktemp -d)"; cd "$t"; \
    export HOME="$t" GIT_CONFIG_NOSYSTEM=1; \
    # 1.0 only knows `init` (and exits 0 on unknown commands, so check the output)
    if git lfs install 2>&1 | grep -q 'unknown command'; then git lfs init >/dev/null; fi; \
    git init -q repo; cd repo; \
    git lfs track '*.bin' >/dev/null; \
    head -c 1024 /dev/urandom > a.bin; \
    git add .gitattributes a.bin; \
    git -c user.name=ci -c user.email=ci@example.invalid commit -q -m lfs; \
    git lfs ls-files | grep -q 'a.bin' || { echo "FATAL: git-lfs did not track a.bin" >&2; exit 1; }; \
    cd /; rm -rf "$t"; \
    git --version; git-lfs version

WORKDIR /
