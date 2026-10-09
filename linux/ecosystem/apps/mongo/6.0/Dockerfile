##################################################################
##################################################################
#                          Builder
##################################################################
##################################################################
# All mongo leaves are written by bin/python/mongo-versions-sync.py (flavour
# "openssl3"); edit the generator, not this file.
FROM ghcr.io/epicmorg/gcc:14 AS builder
ARG DEBIAN_FRONTEND=noninteractive

ENV EMG_MONGO_VERSION=6.0
ENV EMG_MONGO_FULL_VERSION=6.0.29
ENV EMG_MONGO_DIR=${EMG_LOCAL_BASE_DIR}/mongo/${EMG_MONGO_VERSION}
ARG EMG_MONGO_URL=https://fastdl.mongodb.org/linux/mongodb-linux-x86_64-ubuntu2204-6.0.29.tgz
ARG EMG_MONGO_SHA256=46de5a28be8066e0c44b60e9919e5edd00c28f55fc187f8e0c60ab38dedc9054

RUN set -eux; \
    apt-get update; \
    apt-get install -y --no-install-recommends patchelf; \
    rm -rf /var/lib/apt/lists/*; \
    mkdir -p "${EMG_MONGO_DIR}" /tmp/mongo; \
    wget -q -O /tmp/mongo.tgz "${EMG_MONGO_URL}"; \
    echo "${EMG_MONGO_SHA256}  /tmp/mongo.tgz" | sha256sum -c -; \
    tar -xzf /tmp/mongo.tgz -C /tmp/mongo --strip-components=1 --no-same-owner; \
    cp -a /tmp/mongo/bin "${EMG_MONGO_DIR}/"; \
    # install_compass: a GUI installer; mongosniff (1.x-2.4): wants libpcap.so.0.9 from 2010
    rm -f "${EMG_MONGO_DIR}/bin/install_compass" "${EMG_MONGO_DIR}/bin/mongosniff"; \
    cp -a /tmp/mongo/[A-Z]* "${EMG_MONGO_DIR}/" 2>/dev/null || true; \
    rm -rf /tmp/mongo /tmp/mongo.tgz

# database tools (mongodump, mongorestore, ...) ship separately since 4.4
ARG EMG_MONGO_TOOLS_URL=https://fastdl.mongodb.org/tools/db/mongodb-database-tools-debian12-x86_64-100.19.1.tgz
ARG EMG_MONGO_TOOLS_SHA256=9ba637b2fee9cd5afd83ea93b688a0f6bf3e0e4a614d3b0c55f63fa66ae62e2f
RUN set -eux; \
    wget -q -O /tmp/tools.tgz "${EMG_MONGO_TOOLS_URL}"; \
    echo "${EMG_MONGO_TOOLS_SHA256}  /tmp/tools.tgz" | sha256sum -c -; \
    mkdir -p /tmp/tools "${EMG_LOCAL_BASE_DIR}/mongo-tools/100.19.1"; \
    tar -xzf /tmp/tools.tgz -C /tmp/tools --strip-components=1 --no-same-owner; \
    cp -a /tmp/tools/bin "${EMG_LOCAL_BASE_DIR}/mongo-tools/100.19.1/"; \
    rm -rf /tmp/tools /tmp/tools.tgz

# mongosh (the legacy `mongo` shell is gone since 6.0)
ARG EMG_MONGOSH_URL=https://github.com/mongodb-js/mongosh/releases/download/v2.13.0/mongosh-2.13.0-linux-x64.tgz
ARG EMG_MONGOSH_SHA256=b2089e67641a28aa621476c4d62c69f66b9a41484baba24d8a8b1f5f96e92d0b
RUN set -eux; \
    wget -q -O /tmp/mongosh.tgz "${EMG_MONGOSH_URL}"; \
    echo "${EMG_MONGOSH_SHA256}  /tmp/mongosh.tgz" | sha256sum -c -; \
    mkdir -p /tmp/mongosh "${EMG_LOCAL_BASE_DIR}/mongosh/2.13.0"; \
    tar -xzf /tmp/mongosh.tgz -C /tmp/mongosh --strip-components=1 --no-same-owner; \
    cp -a /tmp/mongosh/bin "${EMG_LOCAL_BASE_DIR}/mongosh/2.13.0/"; \
    rm -rf /tmp/mongosh /tmp/mongosh.tgz

##################################################################
#        Export: mongo + exactly the baked prefixes it links
##################################################################
RUN set -eu; \
    out=/emg-export; \
    trees="${EMG_MONGO_DIR} $(ls -d "${EMG_LOCAL_BASE_DIR}"/mongo-tools/* "${EMG_LOCAL_BASE_DIR}"/mongosh/* 2>/dev/null || true)"; \
    elfs="$(for t in $trees; do find "$t" -type f -perm -u+x -exec sh -c 'file -b "$1" | grep -q ELF && echo "$1"' _ {} \; ; done)"; \
    prefixes="$(for b in $elfs; do ldd "$b" 2>/dev/null | awk '$3 ~ /^\// {print $3}'; done | sort -u \
                | grep "^${EMG_LOCAL_BASE_DIR}/" | xargs -r -n1 dirname \
                | sed -E 's#/lib(64)?(/x86_64-linux-gnu)?$##' | sort -u)"; \
    echo "baked prefixes:"; echo "$prefixes"; \
    mkdir -p "$out"; \
    for t in $trees; do cp -a --parents "$t" "$out/"; done; \
    for p in $prefixes; do \
      case " $trees " in *" $p "*) continue ;; esac; \
      for d in "$p"/lib "$p"/lib64 "$p"/ssl "$p"/etc; do \
        [ -e "$d" ] || continue; \
        mkdir -p "$out$(dirname "$d")"; \
        if [ "${d##*/}" = lib ] || [ "${d##*/}" = lib64 ]; then \
          mkdir -p "$out$d"; \
          find "$d" -maxdepth 1 \( -name '*.so' -o -name '*.so.*' \) -exec cp -a {} "$out$d/" \; ; \
          for sub in sasl2 ossl-modules engines; do [ -d "$d/$sub" ] && cp -a "$d/$sub" "$out$d/"; done; true; \
        else cp -a "$d" "$out$(dirname "$d")/"; fi; \
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

ENV EMG_MONGO_VERSION=6.0
ENV EMG_MONGO_FULL_VERSION=6.0.29
ENV EMG_MONGO_DIR=${EMG_LOCAL_BASE_DIR}/mongo/${EMG_MONGO_VERSION}
ENV EMG_MONGO_TLS=openssl3

LABEL org.opencontainers.image.title="EpicMorg MongoDB"
LABEL org.opencontainers.image.description="MongoDB 6.0.29 (vendor binaries, TLS on Debian OpenSSL 3) on Debian trixie, library/mongo + bitnami compatible entrypoint, by EpicMorg"
LABEL org.opencontainers.image.source="https://github.com/EpicMorg/docker"
LABEL org.opencontainers.image.licenses="MIT"

COPY --from=builder /emg-export/ /
COPY --from=builder /emg-export/ /emg-export/

ENV PATH="${EMG_MONGO_DIR}/bin:${EMG_LOCAL_BASE_DIR}/mongo-tools/100.19.1/bin:${EMG_LOCAL_BASE_DIR}/mongosh/2.13.0/bin:${PATH}"

# runtime libraries the vendor build expects from the OS (none of them links OpenSSL
# on the baked flavours - checked below); mongodb = uid 999 as in library/mongo
# (gid 999 is systemd-journal on our base, so the group gets a free system gid;
# the entrypoint only looks at the uid of existing data)
RUN set -eux; \
    apt-get update; \
    apt-get install -y --no-install-recommends gosu numactl procps libcurl4t64 libgssapi-krb5-2 libldap2 libsasl2-2 liblzma5 libssl3t64; \
    rm -rf /var/lib/apt/lists/*; \
    groupadd -r mongodb; \
    useradd -r -u 999 -g mongodb -d /data/db -s /usr/sbin/nologin mongodb; \
    mkdir -p /data/db /data/configdb /docker-entrypoint-initdb.d; \
    chown mongodb:mongodb /data/db /data/configdb

COPY usr/local/bin/docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh
RUN chmod 0755 /usr/local/bin/docker-entrypoint.sh

##################################################################
#                       Assertions (fatal)
##################################################################
RUN set -eu; \
    [ "$(command -v mongod)" = "${EMG_MONGO_DIR}/bin/mongod" ] || { echo "FATAL: mongod on PATH is $(command -v mongod)" >&2; exit 1; }; \
    # 1.0 has no --version: its shell reports the release
    mongod --version 2>&1 | grep -q "${EMG_MONGO_FULL_VERSION}" \
      || mongo --version 2>&1 | grep -q "${EMG_MONGO_FULL_VERSION}" \
      || { echo "FATAL: not mongod ${EMG_MONGO_FULL_VERSION}" >&2; mongod --version >&2 || true; exit 1; }; \
    for d in "${EMG_MONGO_DIR}/bin" $(ls -d "${EMG_LOCAL_BASE_DIR}"/mongo-tools/*/bin "${EMG_LOCAL_BASE_DIR}"/mongosh/*/bin 2>/dev/null || true); do \
      for b in "$d"/*; do \
        file -b "$b" | grep -q ELF || continue; \
        if ldd "$b" | grep -q 'not found'; then echo "FATAL: $b has unresolved deps" >&2; ldd "$b" >&2; exit 1; fi; \
        case "${EMG_MONGO_TLS}" in openssl-*) ! readelf -d "$b" | grep -q '(RUNPATH)' || { echo "FATAL: RUNPATH in $b" >&2; exit 1; } ;; esac; \
        n="$(ldd "$b" | awk '$1 ~ /^libssl\.so/ {print $3}' | sort -u | wc -l)"; \
        [ "$n" -le 1 ] || { echo "FATAL: $n libssl in $b" >&2; ldd "$b" >&2; exit 1; }; \
      done; \
    done; \
    ssl="$(ldd "${EMG_MONGO_DIR}/bin/mongod" | awk '$1 ~ /^libssl\.so/ {print $3}')"; \
    case "${EMG_MONGO_TLS}" in \
      none) [ -z "$ssl" ] || { echo "FATAL: legacy mongod links $ssl" >&2; exit 1; } ;; \
      openssl3) echo "$ssl" | grep -q '^/lib/x86_64-linux-gnu/libssl.so.3$\|^/usr/lib/x86_64-linux-gnu/libssl.so.3$' || { echo "FATAL: mongod libssl is '$ssl'" >&2; exit 1; } ;; \
      *) echo "$ssl" | grep -q "^${EMG_LOCAL_BASE_DIR}/openssl/" || { echo "FATAL: mongod libssl is '$ssl', not the baked one" >&2; exit 1; }; \
         ! ldd "${EMG_MONGO_DIR}/bin/mongod" | grep -q 'libssl.so.3' || { echo "FATAL: OpenSSL 3 in the 1.x mongod" >&2; exit 1; } ;; \
    esac; \
    echo "--- smoke test: entrypoint, root user, auth, TLS ---"; \
    vnum="$(echo "${EMG_MONGO_VERSION}" | awk -F. '{ printf "%d%03d", $1, $2 }')"; \
    q=--quiet; [ "$vnum" -ge 1004 ] || q=; \
    auth="-u root -p smoke --authenticationDatabase admin"; [ "$vnum" -ge 2004 ] || auth="-u root -p smoke"; \
    probe='print("PROBE_" + db.runCommand({listDatabases: 1}).ok)'; \
    t="$(mktemp -d)"; chown mongodb:mongodb "$t"; \
    MONGO_INITDB_ROOT_USERNAME=root MONGO_INITDB_ROOT_PASSWORD=smoke \
      docker-entrypoint.sh mongod --dbpath "$t" --port 27999 > "$t.log" 2>&1 & \
    shell="$(command -v mongosh || command -v mongo)"; \
    ok=no; for i in $(seq 1 90); do \
      "$shell" $q --port 27999 $auth --eval "$probe" admin 2>/dev/null | grep -q PROBE_1 && { ok=yes; break; }; \
      sleep 1; \
    done; \
    [ "$ok" = yes ] || { echo "FATAL: no authenticated listDatabases" >&2; cat "$t.log" >&2; exit 1; }; \
    ! "$shell" $q --port 27999 --eval "$probe" admin 2>&1 | grep -q PROBE_1 \
      || { echo "FATAL: unauthenticated listDatabases allowed" >&2; exit 1; }; \
    "$shell" $q --port 27999 $auth --eval 'db.shutdownServer()' admin >/dev/null 2>&1 || true; \
    sleep 3; \
    echo "--- TLS listener ---"; \
    openssl req -x509 -newkey rsa:2048 -nodes -days 1 -subj /CN=localhost -keyout "$t/k.pem" -out "$t/c.pem" 2>/dev/null; \
    cat "$t/k.pem" "$t/c.pem" > "$t/pem"; chown -R mongodb:mongodb "$t"; \
    mkdir -p "$t/tls"; chown mongodb:mongodb "$t/tls"; \
    gosu mongodb mongod --dbpath "$t/tls" --port 27998 --bind_ip 127.0.0.1 --tlsMode requireTLS --tlsCertificateKeyFile "$t/pem" --tlsCAFile "$t/c.pem" --tlsAllowConnectionsWithoutCertificates > "$t.tls.log" 2>&1 & \
    ok=no; for i in $(seq 1 60); do \
      "$shell" $q --port 27998 --tls --tlsAllowInvalidCertificates --eval "$probe" admin 2>/dev/null | grep -q PROBE_1 && { ok=yes; break; }; \
      sleep 1; \
    done; \
    [ "$ok" = yes ] || { echo "FATAL: no ping over TLS" >&2; cat "$t.tls.log" >&2; exit 1; }; \
    "$shell" $q --port 27998 --tls --tlsAllowInvalidCertificates --eval 'db.shutdownServer()' admin >/dev/null 2>&1 || true; \
    sleep 3; rm -f "$t.tls.log"; \
    rm -rf "$t" "$t.log"; \
    mongod --version 2>&1 | head -3 || true; \
    ldd "${EMG_MONGO_DIR}/bin/mongod" | grep -E 'ssl|crypto|curl|ldap|sasl' || true

VOLUME ["/data/db", "/data/configdb"]
WORKDIR /data
EXPOSE 27017

STOPSIGNAL SIGTERM
ENTRYPOINT ["tini", "--", "docker-entrypoint.sh"]
CMD ["mongod"]
