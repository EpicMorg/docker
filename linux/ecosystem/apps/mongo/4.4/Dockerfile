##################################################################
##################################################################
#                          Builder
##################################################################
##################################################################
# All mongo leaves are written by bin/python/mongo-versions-sync.py (flavour
# "openssl111"); edit the generator, not this file.
FROM ghcr.io/epicmorg/gcc:14 AS builder
ARG DEBIAN_FRONTEND=noninteractive

ENV EMG_MONGO_VERSION=4.4
ENV EMG_MONGO_FULL_VERSION=4.4.31
ENV EMG_MONGO_DIR=${EMG_LOCAL_BASE_DIR}/mongo/${EMG_MONGO_VERSION}
ARG EMG_MONGO_URL=https://fastdl.mongodb.org/linux/mongodb-linux-x86_64-debian10-4.4.31.tgz
ARG EMG_MONGO_SHA256=39f20490f430f4689c7b029e49fd5da9ee09b27aec4928bdeb2f652a2c82db70

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

##################################################################
#    OpenSSL 1.1.1 stack: baked OpenSSL + curl, openldap / cyrus-sasl
##################################################################
# The 1.1-era builds link libssl.so.1.1, libcurl (CURL_OPENSSL_4), libldap and
# libsasl2. Debian trixie's libldap / libsasl2 / libcurl use OpenSSL 3 - two
# OpenSSLs in mongod. So: trixie-develop's OpenSSL 1.1.1 + curl 8.17 built on it,
# and openldap (client libs) + cyrus-sasl built here against the same OpenSSL,
# each with a real RPATH (named consumer: mongo 4.x / 5.0).
ENV EMG_MONGO_SSL_DIR=${OPENSSL_111_DIR}
ENV EMG_MONGO_CURL_DIR=${CURL_817_111_DIR}
ENV EMG_MONGO_SASL_DIR=${EMG_LOCAL_BASE_DIR}/cyrus-sasl/2.1.28/openssl111
ENV EMG_MONGO_LDAP_DIR=${EMG_LOCAL_BASE_DIR}/openldap/2.6.15/openssl111
ARG SASL_URL=https://github.com/cyrusimap/cyrus-sasl/releases/download/cyrus-sasl-2.1.28/cyrus-sasl-2.1.28.tar.gz
ARG SASL_SHA256=7ccfc6abd01ed67c1a0924b353e526f1b766b21f42d4562ee635a8ebfc5bb38c
ARG LDAP_URL=https://www.openldap.org/software/download/OpenLDAP/openldap-release/openldap-2.6.15.tgz
ARG LDAP_SHA256=bc91225dbfc50354033b1303bc91d1a7f6ddd1dc32fac950d79c28fe66d6bca8
RUN set -eux; \
    test -f "${EMG_MONGO_SSL_DIR}/include/openssl/ssl.h"; test -x "${EMG_MONGO_CURL_DIR}/bin/curl-config"; \
    mkdir -p /usr/local/src/sasl; cd /usr/local/src/sasl; \
    wget -q -O sasl.tgz "${SASL_URL}"; echo "${SASL_SHA256}  sasl.tgz" | sha256sum -c -; \
    tar -xzf sasl.tgz --strip-components=1 --no-same-owner; \
    # 2.1.28 misses <time.h> in saslutil.c: an error by gcc 14's defaults
    CFLAGS="-O2 -g0 -Wno-error=implicit-function-declaration" \
    CPPFLAGS="-I${EMG_MONGO_SSL_DIR}/include" \
    LDFLAGS="-L${OPENSSL_111_LIB_DIR} -Wl,-rpath,${OPENSSL_111_LIB_DIR}:${EMG_MONGO_SASL_DIR}/lib -Wl,--disable-new-dtags" \
    ./configure --prefix="${EMG_MONGO_SASL_DIR}" --with-openssl="${EMG_MONGO_SSL_DIR}" \
      --disable-gssapi --disable-otp --disable-krb4 --disable-sql --disable-ldapdb --without-saslauthd \
      --without-authdaemond --without-pwcheck --disable-sample --disable-static \
      --with-plugindir="${EMG_MONGO_SASL_DIR}/lib/sasl2" --with-configdir="${EMG_MONGO_SASL_DIR}/lib/sasl2:/etc/sasl2"; \
    make -j"$(nproc)"; make install; \
    mkdir -p /usr/local/src/ldap; cd /usr/local/src/ldap; \
    wget -q -O ldap.tgz "${LDAP_URL}"; echo "${LDAP_SHA256}  ldap.tgz" | sha256sum -c -; \
    tar -xzf ldap.tgz --strip-components=1 --no-same-owner; \
    CPPFLAGS="-I${EMG_MONGO_SSL_DIR}/include -I${EMG_MONGO_SASL_DIR}/include" \
    LDFLAGS="-L${OPENSSL_111_LIB_DIR} -L${EMG_MONGO_SASL_DIR}/lib -Wl,-rpath,${OPENSSL_111_LIB_DIR}:${EMG_MONGO_SASL_DIR}/lib:${EMG_MONGO_LDAP_DIR}/lib -Wl,--disable-new-dtags" \
    ./configure --prefix="${EMG_MONGO_LDAP_DIR}" --disable-slapd --disable-static --with-tls=openssl --with-cyrus-sasl \
      --sysconfdir=/etc; \
    make -j"$(nproc)" depend; make -j"$(nproc)"; make install; \
    cd /; rm -rf /usr/local/src/sasl /usr/local/src/ldap

ENV EMG_MONGO_RPATH=${OPENSSL_111_LIB_DIR}:${CURL_817_111_LIB_DIR}:${EMG_MONGO_LDAP_DIR}/lib:${EMG_MONGO_SASL_DIR}/lib:${ZLIB_LIB_DIR}:${ZSTD_LIB_DIR}

##################################################################
#     Wire the baked stack into the vendor binaries (DT_RPATH)
##################################################################
# --force-rpath = DT_RPATH (not RUNPATH; it replaces the vendor's RUNPATH): it also applies to the libraries the
# binary loads (libldap -> libsasl2 -> libssl), so nothing falls back to Debian's.
RUN set -eux; \
    for b in "${EMG_MONGO_DIR}"/bin/*; do \
      file -b "$b" | grep -q ELF || continue; \
      ldd "$b" | grep -qE 'lib(ssl|crypto|curl|ldap|lber|sasl2)\.so' || continue; \
      patchelf --force-rpath --set-rpath "${EMG_MONGO_RPATH}" "$b"; \
    done

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

ENV EMG_MONGO_VERSION=4.4
ENV EMG_MONGO_FULL_VERSION=4.4.31
ENV EMG_MONGO_DIR=${EMG_LOCAL_BASE_DIR}/mongo/${EMG_MONGO_VERSION}
ENV EMG_MONGO_TLS=openssl-1.1.1

LABEL org.opencontainers.image.title="EpicMorg MongoDB"
LABEL org.opencontainers.image.description="MongoDB 4.4.31 (vendor binaries, TLS on a baked OpenSSL 1.1.1) on Debian trixie, library/mongo + bitnami compatible entrypoint, by EpicMorg"
LABEL org.opencontainers.image.source="https://github.com/EpicMorg/docker"
LABEL org.opencontainers.image.licenses="MIT"

COPY --from=builder /emg-export/ /
COPY --from=builder /emg-export/ /emg-export/

ENV PATH="${EMG_MONGO_DIR}/bin:${EMG_LOCAL_BASE_DIR}/mongo-tools/100.19.1/bin:${PATH}"

# runtime libraries the vendor build expects from the OS (none of them links OpenSSL
# on the baked flavours - checked below); mongodb = uid 999 as in library/mongo
# (gid 999 is systemd-journal on our base, so the group gets a free system gid;
# the entrypoint only looks at the uid of existing data)
RUN set -eux; \
    apt-get update; \
    apt-get install -y --no-install-recommends gosu numactl procps libgssapi-krb5-2 liblzma5 libnghttp2-14 libbrotli1; \
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
