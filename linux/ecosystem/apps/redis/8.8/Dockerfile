##################################################################
##################################################################
#                          Builder
##################################################################
##################################################################
# All redis leaves share this file; they differ only in the EMG_REDIS_* block
# below (version + upstream sha256, bumped by bin/python/redis-versions-sync.py).
FROM ghcr.io/epicmorg/gcc:14 AS builder

ENV EMG_REDIS_VERSION=8.8
ENV EMG_REDIS_FULL_VERSION=8.8.3
ENV EMG_REDIS_DIR=${EMG_LOCAL_BASE_DIR}/redis/${EMG_REDIS_VERSION}
# https://github.com/redis/redis-hashes/blob/master/README
ARG EMG_REDIS_SHA256=13dbcfc6107ab8b6ab2a4f4582678143d5b2fd03ba38611b810359564cfe8a3c
ARG EMG_REDIS_URL=https://download.redis.io/releases/redis-${EMG_REDIS_FULL_VERSION}.tar.gz
ARG EMG_REDIS_SRC_DIR=/usr/local/src/redis/${EMG_REDIS_FULL_VERSION}

# Baked OpenSSL 3.5 (LTS) from trixie-develop (via gcc:14) for TLS.
ENV EMG_REDIS_SSL_DIR=${OPENSSL_35_DIR}
ENV EMG_REDIS_SSL_LIB_DIR=${OPENSSL_35_LIB_DIR}

RUN set -eux; \
    test -n "${EMG_REDIS_SSL_DIR}" -a -f "${EMG_REDIS_SSL_DIR}/include/openssl/ssl.h"; \
    test -d "${EMG_REDIS_SSL_LIB_DIR}"

##################################################################
#                    redis from source
##################################################################
# System cc (gcc 14), bundled jemalloc / lua / hiredis, TLS built in against the
# baked OpenSSL with a real RPATH (--disable-new-dtags), nothing in ld.so.conf.
# No systemd (supervised by the container). Only src/ is built: since 8.x the
# top-level make also builds every module tree shipped in the tarball (search,
# json, timeseries, bloom - rust/cmake toolchains); those are out of scope here.
RUN set -eux; \
    mkdir -p "${EMG_REDIS_SRC_DIR}"; \
    cd "${EMG_REDIS_SRC_DIR}"; \
    wget -q -O redis.tar.gz "${EMG_REDIS_URL}"; \
    echo "${EMG_REDIS_SHA256}  redis.tar.gz" | sha256sum -c -; \
    tar -xzf redis.tar.gz --strip-components=1 --no-same-owner; \
    rm -f redis.tar.gz; \
    # the same variables for build and install: src/Makefile rebuilds deps
    # (hiredis without TLS) when they differ from .make-settings
    set -- CC=cc MALLOC=jemalloc BUILD_TLS=yes USE_SYSTEMD=no \
      OPENSSL_PREFIX="${EMG_REDIS_SSL_DIR}" \
      LDFLAGS="-L${EMG_REDIS_SSL_LIB_DIR} -Wl,-rpath,${EMG_REDIS_SSL_LIB_DIR} -Wl,--disable-new-dtags"; \
    make -C src -j"$(nproc)" "$@"; \
    make -C src install PREFIX="${EMG_REDIS_DIR}" "$@"; \
    mkdir -p "${EMG_REDIS_DIR}/etc"; \
    install -m 0644 redis.conf sentinel.conf "${EMG_REDIS_DIR}/etc/"; \
    # 8.x redis.conf loads the module trees (./modules/*.so) that are not built here
    sed -i -E 's/^(loadmodule .*)$/# \1  # epicmorg: modules are not built/' "${EMG_REDIS_DIR}/etc/redis.conf"; \
    ! grep -q '^loadmodule' "${EMG_REDIS_DIR}/etc/redis.conf"; \
    cp COPYING* LICENSE* README* "${EMG_REDIS_DIR}/" 2>/dev/null || true; \
    cd /; \
    rm -rf "${EMG_REDIS_SRC_DIR}"

##################################################################
#        Export: redis + exactly the baked prefixes it links
##################################################################
# Prefix = lib dir minus /lib, /lib64 for every ${EMG_LOCAL_BASE_DIR} lib that
# ldd resolves for redis-server - nothing hardcoded per version. Only shared
# libs (+ OpenSSL's ssl/ config and modules) are exported.
RUN set -eu; \
    out=/emg-export; \
    elfs="$(find "${EMG_REDIS_DIR}/bin" -type f -perm -u+x -exec sh -c 'file -b "$1" | grep -q ELF && echo "$1"' _ {} \;)"; \
    if for b in $elfs; do ldd "$b"; done | grep -q 'not found'; then echo "FATAL: unresolved deps in the builder" >&2; exit 1; fi; \
    prefixes="$(for b in $elfs; do ldd "$b" | awk '$3 ~ /^\// {print $3}'; done | sort -u \
                | grep "^${EMG_LOCAL_BASE_DIR}/" | xargs -r -n1 dirname \
                | sed -E 's#/lib(64)?(/x86_64-linux-gnu)?$##' | grep -v "^${EMG_REDIS_DIR}\$" | sort -u)"; \
    echo "baked prefixes:"; echo "$prefixes"; \
    mkdir -p "$out"; \
    cp -a --parents "${EMG_REDIS_DIR}" "$out/"; \
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

ENV EMG_REDIS_VERSION=8.8
ENV EMG_REDIS_FULL_VERSION=8.8.3
ENV EMG_REDIS_DIR=${EMG_LOCAL_BASE_DIR}/redis/${EMG_REDIS_VERSION}

LABEL org.opencontainers.image.title="EpicMorg redis"
LABEL org.opencontainers.image.description="Redis built from source on Debian trixie with baked OpenSSL (TLS), bitnami/redis-compatible entrypoint, by EpicMorg"
LABEL org.opencontainers.image.source="https://github.com/EpicMorg/docker"
LABEL org.opencontainers.image.licenses="MIT"

# redis + the baked OpenSSL, installed here and kept as a self-contained tree
# in /emg-export for consumers:
#   COPY --from=ghcr.io/epicmorg/redis:<ver> /emg-export/ /
COPY --from=builder /emg-export/ /
COPY --from=builder /emg-export/ /emg-export/

ENV PATH="${EMG_REDIS_DIR}/bin:${PATH}"

# redis = uid 1001, primary group root (bitnami's uid: existing volumes keep
# working); the dirs are group-0 writable for arbitrary-uid runs (OpenShift style)
RUN set -eux; \
    apt-get update; \
    apt-get install -y --no-install-recommends gosu; \
    rm -rf /var/lib/apt/lists/*; \
    useradd --system --uid 1001 --gid 0 --home-dir /data --no-create-home --shell /usr/sbin/nologin redis; \
    mkdir -p /data /etc/redis /run/redis; \
    chown redis:root /data /run/redis; \
    chmod 0770 /data /run/redis

COPY usr/local/bin/docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh
RUN chmod 0755 /usr/local/bin/docker-entrypoint.sh

##################################################################
#                       Assertions (fatal)
##################################################################
RUN set -eu; \
    srv="${EMG_REDIS_DIR}/bin/redis-server"; \
    [ "$(command -v redis-server)" = "$srv" ] || { echo "FATAL: redis-server on PATH is $(command -v redis-server), expected $srv" >&2; exit 1; }; \
    redis-server --version | grep -q "v=${EMG_REDIS_FULL_VERSION} " || { echo "FATAL: not redis ${EMG_REDIS_FULL_VERSION}" >&2; redis-server --version >&2; exit 1; }; \
    redis-cli --version | grep -q "${EMG_REDIS_FULL_VERSION}" || { echo "FATAL: redis-cli is not ${EMG_REDIS_FULL_VERSION}" >&2; exit 1; }; \
    test -x "/emg-export${srv}" || { echo "FATAL: /emg-export has no redis-server" >&2; exit 1; }; \
    for b in "$srv" "${EMG_REDIS_DIR}/bin/redis-cli" "${EMG_REDIS_DIR}/bin/redis-benchmark"; do \
      if ldd "$b" | grep -q 'not found'; then echo "FATAL: $b has unresolved deps" >&2; ldd "$b" >&2; exit 1; fi; \
      ! readelf -d "$b" | grep -q '(RUNPATH)' || { echo "FATAL: RUNPATH in $b" >&2; exit 1; }; \
      [ "$(ldd "$b" | grep -c libssl)" = 1 ] || { echo "FATAL: not exactly one libssl in $b" >&2; ldd "$b" >&2; exit 1; }; \
      ldd "$b" | awk '$1 ~ /^libssl\.so/ {print $3}' | grep -q "^${EMG_LOCAL_BASE_DIR}/openssl/" || { echo "FATAL: $b: libssl not from the baked OpenSSL" >&2; ldd "$b" >&2; exit 1; }; \
    done; \
    redis-server --version | grep -q 'malloc=jemalloc' || { echo "FATAL: not built with jemalloc" >&2; exit 1; }; \
    echo "--- smoke test: entrypoint, AUTH, AOF, TLS listener ---"; \
    t="$(mktemp -d)"; \
    openssl req -x509 -newkey rsa:2048 -nodes -days 1 -subj /CN=localhost -keyout "$t/k.pem" -out "$t/c.pem" 2>/dev/null; \
    chown -R redis:root "$t"; \
    REDIS_DATA_DIR="$t/data" REDIS_PASSWORD=smoke REDIS_PORT_NUMBER=16379 \
      REDIS_TLS_ENABLED=yes REDIS_TLS_PORT_NUMBER=16380 REDIS_TLS_CERT_FILE="$t/c.pem" REDIS_TLS_KEY_FILE="$t/k.pem" REDIS_TLS_CA_FILE="$t/c.pem" \
      REDIS_TLS_AUTH_CLIENTS=no REDIS_DISABLE_COMMANDS=FLUSHALL \
      docker-entrypoint.sh > "$t/log" 2>&1 & \
    pid=$!; \
    for i in $(seq 1 50); do REDISCLI_AUTH=smoke redis-cli -p 16379 ping 2>/dev/null | grep -q PONG && break; sleep 0.2; done; \
    export REDISCLI_AUTH=smoke; \
    redis-cli -p 16379 ping | grep -qx PONG || { echo "FATAL: no PONG" >&2; cat "$t/log" >&2; exit 1; }; \
    redis-cli -p 16379 set k v | grep -qx OK; \
    redis-cli -p 16380 --tls --cacert "$t/c.pem" get k | grep -qx v || { echo "FATAL: TLS port does not answer" >&2; cat "$t/log" >&2; exit 1; }; \
    redis-cli -p 16379 config get appendonly | tail -1 | grep -qx yes || { echo "FATAL: AOF is off" >&2; exit 1; }; \
    redis-cli -p 16379 flushall 2>&1 | grep -qi 'unknown command' || { echo "FATAL: REDIS_DISABLE_COMMANDS ignored" >&2; exit 1; }; \
    env -u REDISCLI_AUTH redis-cli -p 16379 get k 2>&1 | grep -q NOAUTH || { echo "FATAL: no password required" >&2; exit 1; }; \
    [ "$(stat -c %U "$t/data")" = redis ] || { echo "FATAL: data dir not owned by redis" >&2; exit 1; }; \
    [ "$(stat -c %U /proc/$pid)" = redis ] && grep -q redis-server /proc/$pid/cmdline || { echo "FATAL: redis-server does not run as redis" >&2; exit 1; }; \
    redis-cli -p 16379 shutdown nosave >/dev/null 2>&1 || true; \
    sleep 1; \
    unset REDISCLI_AUTH; \
    if docker-entrypoint.sh >/dev/null 2>&1; then echo "FATAL: started without a password and ALLOW_EMPTY_PASSWORD" >&2; exit 1; fi; \
    rm -rf "$t" /run/redis/*; \
    redis-server --version; \
    ldd "$srv" | grep -E 'libssl|libcrypto'

VOLUME ["/data"]
WORKDIR /data
EXPOSE 6379

HEALTHCHECK --interval=30s --timeout=5s --start-period=10s \
        CMD REDISCLI_AUTH="${REDIS_PASSWORD:-}" redis-cli -p "${REDIS_PORT_NUMBER:-6379}" ping | grep -q PONG || exit 1

STOPSIGNAL SIGTERM
ENTRYPOINT ["tini", "--", "docker-entrypoint.sh"]
CMD ["redis-server"]
