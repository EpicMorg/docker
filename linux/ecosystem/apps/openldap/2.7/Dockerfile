##################################################################
##################################################################
#                          Builder
##################################################################
##################################################################
# All openldap leaves share this file; they differ only in the EMG_OPENLDAP_*
# block below (bumped by bin/python/openldap-versions-sync.py). Branch-specific
# switches (2.4: bdb/hdb, no argon2, old autoconf) are keyed on the version.
FROM ghcr.io/epicmorg/gcc:14 AS builder

ENV EMG_OPENLDAP_VERSION=2.7
ENV EMG_OPENLDAP_FULL_VERSION=2.7.1
ENV EMG_OPENLDAP_DIR=${EMG_LOCAL_BASE_DIR}/openldap/${EMG_OPENLDAP_VERSION}
# openldap.org publishes sha3-512 (2.5+) / sha1 (2.4); checked by the sync script, pinned here as sha256
ARG EMG_OPENLDAP_SHA256=253db80f301258ea69cda1184766d57395b836aaabf41157eb0316eb0fac1341
ARG EMG_OPENLDAP_URL=https://www.openldap.org/software/download/OpenLDAP/openldap-release/openldap-${EMG_OPENLDAP_FULL_VERSION}.tgz

# Cyrus SASL built here against the same OpenSSL: Debian's libsasl2 and its
# digest-md5 / scram / ntlm plugins link the system libcrypto.so.3 (a second
# OpenSSL in slapd). GSSAPI comes from Debian's MIT krb5 (builtin crypto, no libssl).
ENV EMG_SASL_VERSION=2.1.28
ENV EMG_SASL_DIR=${EMG_LOCAL_BASE_DIR}/cyrus-sasl/${EMG_SASL_VERSION}/openssl35
ARG EMG_SASL_SHA256=7ccfc6abd01ed67c1a0924b353e526f1b766b21f42d4562ee635a8ebfc5bb38c
ARG EMG_SASL_URL=https://github.com/cyrusimap/cyrus-sasl/releases/download/cyrus-sasl-${EMG_SASL_VERSION}/cyrus-sasl-${EMG_SASL_VERSION}.tar.gz

# Baked OpenSSL 3.5 (LTS) from trixie-develop (via gcc:14).
ENV EMG_OPENLDAP_SSL_DIR=${OPENSSL_35_DIR}
ENV EMG_OPENLDAP_SSL_LIB_DIR=${OPENSSL_35_LIB_DIR}

RUN set -eux; \
    test -n "${EMG_OPENLDAP_SSL_DIR}" -a -f "${EMG_OPENLDAP_SSL_DIR}/include/openssl/ssl.h"; \
    test -d "${EMG_OPENLDAP_SSL_LIB_DIR}"; \
    apt-get update; \
    apt-get install -y --no-install-recommends groff-base libargon2-dev libdb5.3-dev libkrb5-dev libltdl-dev; \
    rm -rf /var/lib/apt/lists/*

##################################################################
#                 cyrus-sasl on the baked OpenSSL
##################################################################
RUN set -eux; \
    mkdir -p /usr/local/src/sasl; \
    cd /usr/local/src/sasl; \
    aria2c --conf-path=/usr/local/share/epicmorg/aria2/config/aria2.conf \
        --user-agent="$(shuf -n 1 /usr/local/share/epicmorg/user-agents/user-agents.txt)" \
        -o sasl.tgz "${EMG_SASL_URL}"; \
    echo "${EMG_SASL_SHA256}  sasl.tgz" | sha256sum -c -; \
    tar -xzf sasl.tgz --strip-components=1 --no-same-owner; \
    # 2.1.28 misses <time.h> in saslutil.c: an error by gcc 14's defaults
    CFLAGS="-O2 -g0 -Wno-error=implicit-function-declaration" \
    CPPFLAGS="-I${EMG_OPENLDAP_SSL_DIR}/include" \
    LDFLAGS="-L${EMG_OPENLDAP_SSL_LIB_DIR} -Wl,-rpath,${EMG_OPENLDAP_SSL_LIB_DIR}:${EMG_SASL_DIR}/lib -Wl,--disable-new-dtags" \
    ./configure --prefix="${EMG_SASL_DIR}" --with-openssl="${EMG_OPENLDAP_SSL_DIR}" \
      --enable-gssapi --with-gss_impl=mit --disable-otp --disable-krb4 --disable-sql --disable-ldapdb \
      --without-saslauthd --without-authdaemond --without-pwcheck --disable-sample --disable-static \
      --with-plugindir="${EMG_SASL_DIR}/lib/sasl2" --with-configdir="${EMG_SASL_DIR}/lib/sasl2:/etc/sasl2"; \
    make -j"$(nproc)"; \
    make install; \
    cd /; \
    rm -rf /usr/local/src/sasl

##################################################################
#                    openldap from source
##################################################################
# System cc (gcc 14). slapd with mdb built in, everything else (proxy
# backends, all overlays, argon2) as modules; contrib password modules
# pw-sha2 and pw-pbkdf2 (bitnami hashes the admin passwords with PBKDF2-SHA512).
# Runtime state (ldapi socket, pid) in /var/lib/openldap/run = the compiled-in
# default, so `ldapsearch -Y EXTERNAL -H ldapi:///` works in `docker exec`.
RUN set -eux; \
    mkdir -p /usr/local/src/openldap; \
    cd /usr/local/src/openldap; \
    aria2c --conf-path=/usr/local/share/epicmorg/aria2/config/aria2.conf \
        --user-agent="$(shuf -n 1 /usr/local/share/epicmorg/user-agents/user-agents.txt)" \
        -o openldap.tgz "${EMG_OPENLDAP_URL}"; \
    echo "${EMG_OPENLDAP_SHA256}  openldap.tgz" | sha256sum -c -; \
    tar -xzf openldap.tgz --strip-components=1 --no-same-owner; \
    rm -f openldap.tgz; \
    cflags="-O2 -g0"; extra="--enable-argon2"; \
    case "${EMG_OPENLDAP_VERSION}" in \
      # 2.4: autoconf 2.6x tests fail under gcc 14 ("broken POSIX regex"); its
      # contrib Makefiles link with $(OPT) only, hence the linker flags there; the
      # legacy Berkeley DB backends stay available for reading old databases
      2.4) cflags="$cflags -Wno-error=implicit-function-declaration -Wno-error=implicit-int -Wno-error=incompatible-pointer-types -Wno-error=int-conversion"; \
           extra="--enable-bdb=mod --enable-hdb=mod" ;; \
    esac; \
    rpath="${EMG_OPENLDAP_SSL_LIB_DIR}:${EMG_SASL_DIR}/lib:${EMG_OPENLDAP_DIR}/lib"; \
    CFLAGS="$cflags" \
    CPPFLAGS="-I${EMG_OPENLDAP_SSL_DIR}/include -I${EMG_SASL_DIR}/include" \
    LDFLAGS="-L${EMG_OPENLDAP_SSL_LIB_DIR} -L${EMG_SASL_DIR}/lib -Wl,-rpath,$rpath -Wl,--disable-new-dtags" \
    ./configure --prefix="${EMG_OPENLDAP_DIR}" --sysconfdir="${EMG_OPENLDAP_DIR}/etc" --localstatedir=/var/lib/openldap \
      --enable-slapd --enable-modules --enable-dynamic --enable-crypt --enable-spasswd \
      --enable-mdb=yes --enable-monitor=yes --enable-ldap=mod --enable-meta=mod --enable-null=mod \
      --enable-relay=mod --enable-dnssrv=mod --enable-overlays=mod \
      --with-tls=openssl --with-cyrus-sasl --disable-static $extra; \
    make -j"$(nproc)" depend; \
    make -j"$(nproc)"; \
    make install; \
    for m in sha2 pbkdf2; do \
      [ -d "contrib/slapd-modules/passwd/$m" ] || { echo "FATAL: contrib passwd/$m missing" >&2; exit 1; }; \
      make -C "contrib/slapd-modules/passwd/$m" prefix="${EMG_OPENLDAP_DIR}" \
        moduledir="${EMG_OPENLDAP_DIR}/libexec/openldap" CC=cc \
        OPT="$cflags -Wl,-rpath,$rpath -Wl,--disable-new-dtags" \
        LDFLAGS="-L${EMG_OPENLDAP_SSL_LIB_DIR} -Wl,-rpath,${EMG_OPENLDAP_SSL_LIB_DIR} -Wl,--disable-new-dtags" \
        SSL_INC="-I${EMG_OPENLDAP_SSL_DIR}/include" SSL_LIB="-L${EMG_OPENLDAP_SSL_LIB_DIR} -lcrypto"; \
      make -C "contrib/slapd-modules/passwd/$m" prefix="${EMG_OPENLDAP_DIR}" \
        moduledir="${EMG_OPENLDAP_DIR}/libexec/openldap" install; \
    done; \
    find "${EMG_OPENLDAP_DIR}" -name '*.la' -delete; \
    cp ANNOUNCEMENT COPYRIGHT LICENSE README "${EMG_OPENLDAP_DIR}/" 2>/dev/null || true; \
    cd /; \
    rm -rf /usr/local/src/openldap

##################################################################
#        Export: openldap + exactly the baked prefixes it links
##################################################################
# Prefix = lib dir minus /lib, /lib64 for every ${EMG_LOCAL_BASE_DIR} lib that
# ldd resolves for the openldap ELF files (binaries + modules); cyrus-sasl is
# added explicitly (its plugins are dlopen()ed, ldd does not see them).
RUN set -eu; \
    out=/emg-export; \
    elfs="$(find "${EMG_OPENLDAP_DIR}/bin" "${EMG_OPENLDAP_DIR}/sbin" "${EMG_OPENLDAP_DIR}/libexec" "${EMG_OPENLDAP_DIR}/lib" -type f \
            -exec sh -c 'file -b "$1" | grep -q ELF && echo "$1"' _ {} \;)"; \
    if for b in $elfs; do ldd "$b"; done | grep -q 'not found'; then echo "FATAL: unresolved deps in the builder" >&2; for b in $elfs; do ldd "$b" | grep 'not found' && echo "  in $b"; done >&2; exit 1; fi; \
    prefixes="$( { for b in $elfs; do ldd "$b" | awk '$3 ~ /^\// {print $3}'; done | sort -u \
                | grep "^${EMG_LOCAL_BASE_DIR}/" | xargs -r -n1 dirname \
                | sed -E 's#/lib(64)?(/x86_64-linux-gnu)?$##'; echo "${EMG_SASL_DIR}"; } | grep -v "^${EMG_OPENLDAP_DIR}\$" | sort -u)"; \
    echo "baked prefixes:"; echo "$prefixes"; \
    mkdir -p "$out"; \
    cp -a --parents "${EMG_OPENLDAP_DIR}" "$out/"; \
    for p in $prefixes; do \
      for d in "$p"/lib "$p"/lib64 "$p"/ssl; do \
        [ -d "$d" ] || continue; \
        mkdir -p "$out$d"; \
        if [ "${d##*/}" = ssl ]; then cp -a "$d/." "$out$d/"; \
        else find "$d" -maxdepth 1 \( -name '*.so' -o -name '*.so.*' \) -exec cp -a {} "$out$d/" \; ; \
          for sub in sasl2 ossl-modules; do [ -d "$d/$sub" ] && cp -a "$d/$sub" "$out$d/"; done; true; \
        fi; \
      done; \
    done; \
    find "$out" -name '*.la' -delete; \
    du -sh "$out${EMG_LOCAL_BASE_DIR}"/*

##################################################################
##################################################################
#                       Final image
##################################################################
##################################################################
FROM ghcr.io/epicmorg/debian:trixie
ARG DEBIAN_FRONTEND=noninteractive

ENV EMG_OPENLDAP_VERSION=2.7
ENV EMG_OPENLDAP_FULL_VERSION=2.7.1
ENV EMG_OPENLDAP_DIR=${EMG_LOCAL_BASE_DIR}/openldap/${EMG_OPENLDAP_VERSION}
ENV EMG_SASL_DIR=${EMG_LOCAL_BASE_DIR}/cyrus-sasl/2.1.28/openssl35

LABEL org.opencontainers.image.title="EpicMorg OpenLDAP"
LABEL org.opencontainers.image.description="OpenLDAP slapd built from source on Debian trixie with baked OpenSSL and Cyrus SASL, bitnami/openldap-compatible entrypoint, by EpicMorg"
LABEL org.opencontainers.image.source="https://github.com/EpicMorg/docker"
LABEL org.opencontainers.image.licenses="MIT"

# openldap + the baked OpenSSL / cyrus-sasl, installed here and kept as a
# self-contained tree in /emg-export for consumers:
#   COPY --from=ghcr.io/epicmorg/openldap:<ver> /emg-export/ /
COPY --from=builder /emg-export/ /
COPY --from=builder /emg-export/ /emg-export/

ENV PATH="${EMG_OPENLDAP_DIR}/bin:${EMG_OPENLDAP_DIR}/sbin:${EMG_OPENLDAP_DIR}/libexec:${PATH}"
ENV SASL_PATH=${EMG_SASL_DIR}/lib/sasl2

# Debian runtime libraries of the build (none of them links libssl / libcrypto; gosu / tini come with the base):
# libltdl (modules), libargon2 (pw-argon2), libdb5.3 (2.4 bdb/hdb), MIT krb5 (GSSAPI).
# slapd = uid 1001, primary group root (bitnami's uid: existing volumes keep
# working); the dirs are group-0 writable for arbitrary-uid runs (OpenShift style).
# /opt/bitnami/openldap/... links: a persisted bitnami cn=config names its module
# dir and pid file there - the same volume starts here unchanged.
RUN set -eux; \
    apt-get update; \
    apt-get install -y --no-install-recommends libargon2-1 libgssapi-krb5-2 libltdl7; \
    case "${EMG_OPENLDAP_VERSION}" in 2.4) apt-get install -y --no-install-recommends libdb5.3t64 ;; esac; \
    rm -rf /var/lib/apt/lists/*; \
    useradd --system --uid 1001 --gid 0 --home-dir /data --no-create-home --shell /usr/sbin/nologin slapd; \
    mkdir -p /data /var/lib/openldap/run /docker-entrypoint-initdb.d /ldifs /schemas \
      /opt/bitnami/openldap/lib /opt/bitnami/openldap/var; \
    ln -s "${EMG_OPENLDAP_DIR}/libexec" /opt/bitnami/openldap/libexec; \
    ln -s "${EMG_OPENLDAP_DIR}/libexec/openldap" /opt/bitnami/openldap/lib/openldap; \
    ln -s "${EMG_OPENLDAP_DIR}/etc" /opt/bitnami/openldap/etc; \
    ln -s /var/lib/openldap/run /opt/bitnami/openldap/var/run; \
    chown slapd:root /data /var/lib/openldap /var/lib/openldap/run; \
    chmod 0770 /data /var/lib/openldap /var/lib/openldap/run

COPY usr/local/bin/docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh
RUN chmod 0755 /usr/local/bin/docker-entrypoint.sh

##################################################################
#                       Assertions (fatal)
##################################################################
RUN set -eu; \
    slapd="${EMG_OPENLDAP_DIR}/libexec/slapd"; \
    [ "$(command -v slapd)" = "$slapd" ] || { echo "FATAL: slapd on PATH is $(command -v slapd), expected $slapd" >&2; exit 1; }; \
    slapd -VV 2>&1 | grep -q "slapd ${EMG_OPENLDAP_FULL_VERSION} " || { echo "FATAL: not slapd ${EMG_OPENLDAP_FULL_VERSION}" >&2; slapd -VV >&2; exit 1; }; \
    ldapsearch -VV 2>&1 | grep -q "ldapsearch ${EMG_OPENLDAP_FULL_VERSION} " || { echo "FATAL: ldapsearch is not ${EMG_OPENLDAP_FULL_VERSION}" >&2; exit 1; }; \
    test -x "/emg-export${slapd}" || { echo "FATAL: /emg-export has no slapd" >&2; exit 1; }; \
    for b in $(find "${EMG_OPENLDAP_DIR}" "${EMG_SASL_DIR}" -type f \( -perm -u+x -o -name '*.so*' \) -exec sh -c 'file -b "$1" | grep -q ELF && echo "$1"' _ {} \;); do \
      if ldd "$b" | grep -q 'not found'; then echo "FATAL: $b has unresolved deps" >&2; ldd "$b" >&2; exit 1; fi; \
      ! readelf -d "$b" | grep -q '(RUNPATH)' || { echo "FATAL: RUNPATH in $b" >&2; exit 1; }; \
      n="$(ldd "$b" | grep -c 'libssl\.so' || true)"; \
      [ "$n" -le 1 ] || { echo "FATAL: more than one libssl in $b" >&2; ldd "$b" >&2; exit 1; }; \
      if ldd "$b" | grep -qE 'lib(ssl|crypto)\.so'; then \
        ! ldd "$b" | awk '$1 ~ /^lib(ssl|crypto)\.so/ {print $3}' | grep -vq "^${EMG_LOCAL_BASE_DIR}/openssl/" \
          || { echo "FATAL: $b: libssl/libcrypto not from the baked OpenSSL" >&2; ldd "$b" >&2; exit 1; }; \
      fi; \
      ! ldd "$b" | awk '$1 ~ /^libsasl2\.so/ {print $3}' | grep -vq "^${EMG_SASL_DIR}/" \
        || { echo "FATAL: $b: libsasl2 not the baked one" >&2; exit 1; }; \
    done; \
    ldd "$slapd" | grep -q "${EMG_LOCAL_BASE_DIR}/openssl/.*/libssl\.so" || { echo "FATAL: slapd without the baked libssl" >&2; exit 1; }; \
    for m in back_ldap ppolicy syncprov accesslog memberof refint pw-sha2 pw-pbkdf2; do \
      test -e "${EMG_OPENLDAP_DIR}/libexec/openldap/$m.so" || { echo "FATAL: module $m missing" >&2; exit 1; }; \
    done; \
    case "${EMG_OPENLDAP_VERSION}" in \
      2.4) for m in back_bdb back_hdb; do test -e "${EMG_OPENLDAP_DIR}/libexec/openldap/$m.so" || { echo "FATAL: $m missing" >&2; exit 1; }; done ;; \
      *) test -e "${EMG_OPENLDAP_DIR}/libexec/openldap/argon2.so" || { echo "FATAL: argon2 missing" >&2; exit 1; } ;; \
    esac; \
    for p in gssapiv2 gs2 scram digestmd5 plain; do \
      test -e "${EMG_SASL_DIR}/lib/sasl2/lib$p.so" || { echo "FATAL: SASL plugin $p missing" >&2; exit 1; }; \
    done; \
    printf 'x' | slappasswd -n -T /dev/stdin -h '{PBKDF2-SHA512}' -o module-load=pw-pbkdf2 -o "module-path=${EMG_OPENLDAP_DIR}/libexec/openldap" \
      | grep -q '^{PBKDF2-SHA512}' || { echo "FATAL: pw-pbkdf2 does not hash" >&2; exit 1; }; \
    echo "--- smoke test: first start, admin bind, default tree, ldaps, persisted restart ---"; \
    t="$(mktemp -d)"; \
    port_free() { ! grep -qi "^ *[0-9]*: [0-9A-F]*:$(printf %04X "$1") " /proc/net/tcp /proc/net/tcp6 2>/dev/null; }; \
    p=0; while [ "$p" = 0 ] || ! port_free "$p"; do p="$(shuf -i 20000-59999 -n 1)"; done; \
    tp="$p"; while [ "$tp" = "$p" ] || ! port_free "$tp"; do tp="$(shuf -i 20000-59999 -n 1)"; done; \
    echo "smoke ports: $p, TLS $tp"; \
    openssl req -x509 -newkey rsa:2048 -nodes -days 1 -subj /CN=localhost -addext subjectAltName=DNS:localhost,IP:127.0.0.1 -keyout "$t/k.pem" -out "$t/c.pem" 2>/dev/null; \
    chown -R slapd:root "$t"; \
    run() { LDAP_VOLUME_DIR="$t/vol" LDAP_ADMIN_PASSWORD=smoke LDAP_ROOT=dc=smoke,dc=test LDAP_PORT_NUMBER="$p" \
      LDAP_ENABLE_TLS=yes LDAP_LDAPS_PORT_NUMBER="$tp" LDAP_TLS_CERT_FILE="$t/c.pem" LDAP_TLS_KEY_FILE="$t/k.pem" LDAP_TLS_CA_FILE="$t/c.pem" \
      LDAP_CONFIGURE_PPOLICY=yes LDAP_ENABLE_SYNCPROV=yes \
      docker-entrypoint.sh > "$t/log" 2>&1 & }; \
    up() { for i in $(seq 1 60); do ldapsearch -x -H "ldap://127.0.0.1:$p" -D cn=admin,dc=smoke,dc=test -w smoke -b dc=smoke,dc=test -s base dn >/dev/null 2>&1 && return 0; sleep 0.5; done; return 1; }; \
    run; \
    up || { echo "FATAL: slapd does not answer" >&2; cat "$t/log" >&2; exit 1; }; \
    ldapsearch -x -LLL -H "ldap://127.0.0.1:$p" -D cn=admin,dc=smoke,dc=test -w smoke -b ou=users,dc=smoke,dc=test '(uid=user01)' uid | grep -q '^uid: user01' \
      || { echo "FATAL: default tree (user01) missing" >&2; cat "$t/log" >&2; exit 1; }; \
    ldapwhoami -x -H "ldap://127.0.0.1:$p" -D cn=user01,ou=users,dc=smoke,dc=test -w bitnami1 >/dev/null \
      || { echo "FATAL: user01 cannot bind with its PBKDF2 password" >&2; exit 1; }; \
    LDAPTLS_CACERT="$t/c.pem" ldapsearch -x -H "ldaps://127.0.0.1:$tp" -D cn=admin,dc=smoke,dc=test -w smoke -b dc=smoke,dc=test -s base dn >/dev/null \
      || { echo "FATAL: ldaps does not answer" >&2; cat "$t/log" >&2; exit 1; }; \
    ! ldapsearch -x -H "ldap://127.0.0.1:$p" -b dc=smoke,dc=test -s base dn >/dev/null 2>&1 || { echo "FATAL: anonymous bind allowed" >&2; exit 1; }; \
    [ "$(stat -c %U "$t/vol/data")" = slapd ] || { echo "FATAL: data dir not owned by slapd" >&2; exit 1; }; \
    pid="$(cat /var/lib/openldap/run/slapd.pid)"; [ "$(stat -c %U /proc/$pid)" = slapd ] || { echo "FATAL: slapd does not run as slapd" >&2; exit 1; }; \
    ldapsearch -Q -LLL -Y EXTERNAL -H ldapi:/// -b cn=config '(olcOverlay=*)' olcOverlay 2>/dev/null | grep -q ppolicy \
      || gosu slapd ldapsearch -Q -LLL -Y EXTERNAL -H ldapi:/// -b cn=config '(olcOverlay=*)' olcOverlay | grep -q ppolicy \
      || { echo "FATAL: ppolicy overlay not configured" >&2; exit 1; }; \
    kill "$pid"; for i in $(seq 1 30); do [ -e "/proc/$pid" ] || break; sleep 0.5; done; \
    run; \
    up || { echo "FATAL: restart on persisted data failed" >&2; cat "$t/log" >&2; exit 1; }; \
    grep -q 'Using persisted data' "$t/log" || { echo "FATAL: second start re-initialised" >&2; cat "$t/log" >&2; exit 1; }; \
    pid="$(cat /var/lib/openldap/run/slapd.pid)"; kill "$pid"; for i in $(seq 1 30); do [ -e "/proc/$pid" ] || break; sleep 0.5; done; \
    if LDAP_VOLUME_DIR="$t/vol2" docker-entrypoint.sh >/dev/null 2>&1; then echo "FATAL: started without LDAP_ADMIN_PASSWORD" >&2; exit 1; fi; \
    echo "--- first start as root on the image's own empty /data ---"; \
    LDAP_ADMIN_PASSWORD=smoke LDAP_ROOT=dc=smoke,dc=test LDAP_PORT_NUMBER="$p" LDAP_ENABLE_TLS=no \
      docker-entrypoint.sh > "$t/data.log" 2>&1 & \
    up || { echo "FATAL: first start on /data failed" >&2; cat "$t/data.log" >&2; exit 1; }; \
    [ "$(stat -c %U /data/slapd.d)" = slapd ] && [ "$(stat -c %U /data/data)" = slapd ] || { echo "FATAL: /data subdirectories not owned by slapd" >&2; exit 1; }; \
    pid="$(cat /var/lib/openldap/run/slapd.pid)"; kill "$pid"; for i in $(seq 1 30); do [ -e "/proc/$pid" ] || break; sleep 0.5; done; \
    rm -rf /data/data /data/slapd.d; \
    rm -rf "$t" /var/lib/openldap/run/*; \
    slapd -VV 2>&1 | head -1; \
    ldd "$slapd" | grep -E 'libssl|libcrypto|libsasl2'

VOLUME ["/data"]
WORKDIR /data
EXPOSE 1389 1636

HEALTHCHECK --interval=30s --timeout=5s --start-period=20s \
        CMD ldapsearch -Q -Y EXTERNAL -H ldapi:/// -b "" -s base namingContexts >/dev/null 2>&1 \
            || ldapsearch -x -H "ldap://127.0.0.1:${LDAP_PORT_NUMBER:-1389}" -b "" -s base namingContexts >/dev/null 2>&1 \
            || exit 1

STOPSIGNAL SIGTERM
ENTRYPOINT ["tini", "--", "docker-entrypoint.sh"]
CMD ["slapd"]
