##################################################################
##################################################################
#                          Builder
##################################################################
##################################################################
# All git leaves share this file; they differ only in the EMG_GIT_* block
# below (version + upstream sha256, bumped by bin/python/git-versions-sync.py) and in
# the OpenSSL / curl branch.
FROM ghcr.io/epicmorg/gcc:14 AS builder

# NB: never name these GIT_*: git reads GIT_DIR, GIT_PREFIX ... at runtime and
# its Makefile takes GIT_VERSION from the environment.
ENV EMG_GIT_VERSION=2.32
ENV EMG_GIT_FULL_VERSION=2.32.7
ENV EMG_GIT_DIR=${EMG_LOCAL_BASE_DIR}/git/${EMG_GIT_VERSION}
# https://mirrors.edge.kernel.org/pub/software/scm/git/sha256sums.asc
ARG EMG_GIT_SHA256=1ea175f21b766c1cbc05b8391e9aaf6a18b0bbbf7c2382449b635dc66bf1c4d0
ARG EMG_GIT_URL=https://mirrors.edge.kernel.org/pub/software/scm/git/git-${EMG_GIT_FULL_VERSION}.tar.xz
ARG EMG_GIT_SRC_DIR=/usr/local/src/git/${EMG_GIT_FULL_VERSION}

# Baked deps from trixie-develop (via gcc:14): OpenSSL / curl branch for this git.
ENV EMG_GIT_SSL_DIR=${OPENSSL_35_DIR}
ENV EMG_GIT_SSL_LIB_DIR=${OPENSSL_35_LIB_DIR}
ENV EMG_GIT_CURL_DIR=${CURL_821_35_DIR}


RUN set -eux; \
    test -n "${EMG_GIT_SSL_DIR}" -a -d "${EMG_GIT_SSL_DIR}"; \
    test -n "${EMG_GIT_CURL_DIR}" -a -x "${EMG_GIT_CURL_DIR}/bin/curl-config"; \
    test -d "${ZLIB_DIR}" -a -d "${PCRE_DIR}" -a -d "${ZSTD_DIR}"; \
    # build deps (expat headers, gettext, asciidoc/xmlto/docbook for the man pages)
    # come from trixie-develop-light
    command -v msgfmt asciidoc xmlto; \
    test -f /usr/include/expat.h

##################################################################
#                    git from source
##################################################################
# System cc (gcc 14) like php: it links system libs (expat). Every baked dep
# gets a real RPATH (--disable-new-dtags), nothing goes to ld.so.conf. The explicit
# -L dirs matter for old Makefiles that look for -lcrypto in $(OPENSSLDIR)/lib only
# (ours is lib64) and would otherwise pick Debian's libcrypto next to our libssl.
# The -Wno-error=... set lets old git trees build under gcc 14 defaults.
# sysconfdir=/etc: system config is /etc/gitconfig (+ /etc/gitattributes) like
# Debian's git, whatever version is installed - not <prefix>/etc.
RUN set -eux; \
    mkdir -p "${EMG_GIT_SRC_DIR}"; \
    cd "${EMG_GIT_SRC_DIR}"; \
    wget -q -O git.tar.xz "${EMG_GIT_URL}"; \
    echo "${EMG_GIT_SHA256}  git.tar.xz" | sha256sum -c -; \
    tar -xJf git.tar.xz --strip-components=1; \
    rm -f git.tar.xz; \
    # Old trees (< 2.34): http.h re-maps CURLUSESSL_TRY when CURLOPT_USE_SSL is not
    # a macro - in modern curl it is an enum, so the "compat" define becomes circular.
    sed -i 's|^#if !defined(CURLOPT_USE_SSL) \&\& defined(CURLOPT_FTP_SSL)$|#if 0 /* epicmorg: CURLOPT_USE_SSL is an enum in modern curl */|' http.h; \
    # Very old trees keep HMAC_CTX on the stack in imap-send (opaque since OpenSSL 1.1):
    # build them NO_OPENSSL - only imap-send loses its own TLS, https stays on the baked curl.
    noossl=""; grep -q 'HMAC_CTX hmac;' imap-send.c && noossl="NO_OPENSSL = YesPlease"; \
    rpath="${EMG_GIT_SSL_LIB_DIR}:${EMG_GIT_CURL_DIR}/lib:${ZLIB_LIB_DIR}:${PCRE_DIR}/lib:${ZSTD_LIB_DIR}"; \
    printf '%s\n' \
      "prefix = ${EMG_GIT_DIR}" \
      "sysconfdir = /etc" \
      "CC = cc" \
      "CFLAGS = -O2 -g0 -fstack-protector-strong -Wno-error -Wno-error=implicit-function-declaration -Wno-error=implicit-int -Wno-error=int-conversion -Wno-error=incompatible-pointer-types" \
      "LDFLAGS = -L${EMG_GIT_SSL_LIB_DIR} -L${EMG_GIT_CURL_DIR}/lib -L${ZLIB_LIB_DIR} -L${PCRE_DIR}/lib -Wl,-rpath,${rpath} -Wl,--disable-new-dtags" \
      "CC_LD_DYNPATH = -Wl,-rpath," \
      "OPENSSLDIR = ${EMG_GIT_SSL_DIR}" \
      "CURL_CONFIG = ${EMG_GIT_CURL_DIR}/bin/curl-config" \
      "CURLDIR = ${EMG_GIT_CURL_DIR}" \
      "ZLIB_PATH = ${ZLIB_DIR}" \
      "USE_LIBPCRE2 = YesPlease" \
      "LIBPCREDIR = ${PCRE_DIR}" \
      "NO_TCLTK = YesPlease" \
      "NO_INSTALL_HARDLINKS = YesPlease" \
      "PERL_PATH = /usr/bin/perl" \
      "PYTHON_PATH = /usr/bin/python3" \
      "SHELL_PATH = /bin/sh" \
      "${noossl}" \
      > config.mak; \
    cat config.mak; \
    make -j"$(nproc)" all man; \
    make install install-man; \
    test -f "${EMG_GIT_DIR}/share/man/man1/git.1"; \
    cd /; \
    rm -rf "${EMG_GIT_SRC_DIR}"

##################################################################
#        Export: git + exactly the baked prefixes it links
##################################################################
# Prefix = lib dir minus /lib, /lib64 for every ${EMG_LOCAL_BASE_DIR} lib that
# ldd resolves for git's ELF files - nothing hardcoded per version. Only shared
# libs (+ OpenSSL's ssl/ config and modules) are exported, no headers / .a / docs.
RUN set -eu; \
    out=/emg-export; \
    elfs="$(find "${EMG_GIT_DIR}/bin" "${EMG_GIT_DIR}/libexec/git-core" -type f -perm -u+x -exec sh -c 'file -b "$1" | grep -q ELF && echo "$1"' _ {} \;)"; \
    if for b in $elfs; do ldd "$b"; done | grep -q 'not found'; then echo "FATAL: unresolved deps in the builder" >&2; exit 1; fi; \
    prefixes="$(for b in $elfs; do ldd "$b" | awk '$3 ~ /^\// {print $3}'; done | sort -u \
                | grep "^${EMG_LOCAL_BASE_DIR}/" | xargs -r -n1 dirname \
                | sed -E 's#/lib(64)?(/x86_64-linux-gnu)?$##' | grep -v "^${EMG_GIT_DIR}\$" | sort -u)"; \
    echo "baked prefixes:"; echo "$prefixes"; \
    mkdir -p "$out"; \
    cp -a --parents "${EMG_GIT_DIR}" "$out/"; \
    for p in $prefixes; do \
      for d in "$p"/lib "$p"/lib64 "$p"/ssl; do \
        [ -d "$d" ] || continue; \
        mkdir -p "$out$d"; \
        if [ "${d##*/}" = ssl ]; then cp -a "$d/." "$out$d/"; \
        else find "$d" -maxdepth 1 \( -name '*.so' -o -name '*.so.*' \) -exec cp -a {} "$out$d/" \; ; \
          [ -d "$d/ossl-modules" ] && cp -a "$d/ossl-modules" "$out$d/" || true; \
        fi; \
      done; \
    done; \
    du -sh "$out${EMG_LOCAL_BASE_DIR}"/*

##################################################################
##################################################################
#                       Final image
##################################################################
##################################################################
FROM ghcr.io/epicmorg/debian:trixie
ARG DEBIAN_FRONTEND=noninteractive

ENV EMG_GIT_VERSION=2.32
ENV EMG_GIT_FULL_VERSION=2.32.7
ENV EMG_GIT_DIR=${EMG_LOCAL_BASE_DIR}/git/${EMG_GIT_VERSION}

LABEL org.opencontainers.image.title="EpicMorg git"
LABEL org.opencontainers.image.description="git built from source on Debian trixie with baked OpenSSL/curl, for COPY --from into other images by EpicMorg"
LABEL org.opencontainers.image.source="https://github.com/EpicMorg/docker"
LABEL org.opencontainers.image.licenses="MIT"

# git + exactly the baked prefixes it links, installed here and kept as a
# self-contained tree in /emg-export for consumers (incl. the base image):
#   COPY --from=ghcr.io/epicmorg/git:<ver> /emg-export/ /
# git-lfs is the base image's (latest epicmorg/git-lfs), not part of the export.
COPY --from=builder /emg-export/ /
COPY --from=builder /emg-export/ /emg-export/

ENV PATH="${EMG_GIT_DIR}/bin:${PATH}"

##################################################################
#                       Assertions (fatal)
##################################################################
RUN set -eu; \
    apt-get update; \
    apt-get install -y --no-install-recommends libexpat1 perl; \
    rm -rf /var/lib/apt/lists/*; \
    git="${EMG_GIT_DIR}/bin/git"; \
    [ "$(command -v git)" = "$git" ] || { echo "FATAL: git on PATH is $(command -v git), expected $git" >&2; exit 1; }; \
    git --version | grep -qx "git version ${EMG_GIT_FULL_VERSION}" || { echo "FATAL: not git ${EMG_GIT_FULL_VERSION}" >&2; git --version >&2; exit 1; }; \
    test -x "/emg-export${EMG_GIT_DIR}/bin/git" || { echo "FATAL: /emg-export has no git" >&2; exit 1; }; \
    elfs="$(find "${EMG_GIT_DIR}/bin" "${EMG_GIT_DIR}/libexec/git-core" -type f -perm -u+x -exec sh -c 'file -b "$1" | grep -q ELF && echo "$1"' _ {} \;)"; \
    for b in $elfs; do \
      if ldd "$b" | grep -q 'not found'; then echo "FATAL: $b has unresolved deps" >&2; ldd "$b" >&2; exit 1; fi; \
      ! readelf -d "$b" | grep -q '(RUNPATH)' || { echo "FATAL: RUNPATH in $b" >&2; exit 1; }; \
    done; \
    for l in libssl libcrypto libcurl libz libpcre2-8; do \
      n="$(for b in $elfs; do ldd "$b" | awk '{print $1" "$3}' | grep "^${l}\.so" || true; done | sort -u | wc -l)"; \
      [ "$n" -le 1 ] || { echo "FATAL: ${n} different ${l} across git binaries" >&2; exit 1; }; \
    done; \
    remote="${EMG_GIT_DIR}/libexec/git-core/git-remote-https"; \
    ldd "$remote" | grep -q "${EMG_LOCAL_BASE_DIR}/curl/.*/libcurl" || { echo "FATAL: git-remote-https not on the baked libcurl" >&2; ldd "$remote" >&2; exit 1; }; \
    ldd "$remote" | awk '$1 ~ /^libssl\.so/ {print $3}' | grep -q "^${EMG_LOCAL_BASE_DIR}/openssl/" || { echo "FATAL: libssl not from the baked OpenSSL" >&2; ldd "$remote" >&2; exit 1; }; \
    echo "--- smoke test ---"; \
    t="$(mktemp -d)"; cd "$t"; \
    git init -q repo; cd repo; \
    git -c user.name=ci -c user.email=ci@example.invalid commit -q --allow-empty -m init; \
    git log --oneline | grep -q init; \
    git config --system --list --show-origin >/dev/null 2>&1 || true; \
    git -c core.pager=cat config --system --get-all safe.directory >/dev/null 2>&1 || true; \
    [ "$(git version --build-options | grep -c .)" -gt 0 ]; \
    strings "$git" | grep -qx '/etc/gitconfig' || { echo "FATAL: system config is not /etc/gitconfig" >&2; exit 1; }; \
    cd /; rm -rf "$t"; \
    git --version; git lfs version || true; \
    ldd "$remote" | grep -E 'libcurl|libssl|libcrypto|libz\.|libzstd'

WORKDIR /
