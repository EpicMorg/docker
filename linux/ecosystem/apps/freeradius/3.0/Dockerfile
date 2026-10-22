##################################################################
##################################################################
#                          Builder
##################################################################
##################################################################
# All freeradius leaves share this file; they differ only in the
# EMG_FREERADIUS_* block below (bin/python/freeradius-versions-sync.py).
#
# OpenSSL is Debian's (trixie ships the 3.5 LTS branch): the modules' own
# libraries - libmariadb, libpq, libldap, libcurl, freetds, librdkafka ... -
# all link the system libssl, a baked one in radiusd would mean two OpenSSL
# in one process (same reasoning as mongo 6.0+).
FROM ghcr.io/epicmorg/gcc:14 AS builder

ENV EMG_FREERADIUS_VERSION=3.0
ENV EMG_FREERADIUS_FULL_VERSION=3.0.28
ENV EMG_FREERADIUS_DIR=${EMG_LOCAL_BASE_DIR}/freeradius/${EMG_FREERADIUS_VERSION}
# GPG signature (FreeRADIUS package signing key) checked by the sync script, pinned here
ARG EMG_FREERADIUS_SHA256=1bb496773f7d696c81c5c8b1b589bd8f645d2b967898a8b77a46066dc82ea326
ARG EMG_FREERADIUS_URL=https://freeradius.org/ftp/pub/freeradius/freeradius-server-${EMG_FREERADIUS_FULL_VERSION}.tar.gz

RUN set -eux; \
    apt-get update; \
    apt-get install -y --no-install-recommends \
      libtalloc-dev libssl-dev libpcap-dev libcap-dev libgdbm-dev libreadline-dev \
      libmariadb-dev libpq-dev libsqlite3-dev unixodbc-dev freetds-dev \
      libldap-dev libsasl2-dev libkrb5-dev libpam0g-dev libwbclient-dev \
      libhiredis-dev libmemcached-dev libcurl4-openssl-dev libjson-c-dev librdkafka-dev \
      libperl-dev python3-dev libunbound-dev libykclient-dev libyubikey-dev; \
    rm -rf /var/lib/apt/lists/*

##################################################################
#                    FreeRADIUS from source
##################################################################
# System cc (gcc 14), Debian OpenSSL / libs, RPATH to our lib dir only.
# Layout: binaries / modules / dictionaries in ${EMG_FREERADIUS_DIR}; the
# configuration in /etc/freeradius (= freeradius/freeradius-server, Debian),
# /etc/raddb links to it (the upstream / alpine name); radiusd also as
# `freeradius`. Not built: EAP-IKEv2 / TNC, Oracle / DB2 / Firebird / iODBC,
# Couchbase (no trixie libraries), the docs.
RUN set -eux; \
    mkdir -p /usr/local/src/freeradius; \
    cd /usr/local/src/freeradius; \
    wget -q -O fr.tgz "${EMG_FREERADIUS_URL}"; \
    echo "${EMG_FREERADIUS_SHA256}  fr.tgz" | sha256sum -c -; \
    tar -xzf fr.tgz --strip-components=1 --no-same-owner; \
    rm -f fr.tgz; \
    PKG_CONFIG_PATH=/usr/lib/x86_64-linux-gnu/pkgconfig:/usr/share/pkgconfig \
    CFLAGS="-O2 -g0" \
    LDFLAGS="-Wl,-rpath,${EMG_FREERADIUS_DIR}/lib -Wl,--disable-new-dtags" \
    ./configure --prefix="${EMG_FREERADIUS_DIR}" --sysconfdir=/etc --localstatedir=/var \
      --with-raddbdir=/etc/freeradius --with-logdir=/var/log/freeradius --with-runstatedir=/var/run \
      --with-openssl-include-dir=/usr/include --with-openssl-lib-dir=/usr/lib/x86_64-linux-gnu \
      --without-rlm_eap_ikev2 --without-rlm_eap_tnc --without-rlm_sql_oracle --without-rlm_sql_db2 \
      --without-rlm_sql_firebird --without-rlm_sql_iodbc --without-rlm_couchbase --without-rlm_python \
      > /tmp/configure.log 2>&1 || { tail -30 /tmp/configure.log; exit 1; }; \
    grep -E 'silently not building' /tmp/configure.log | sort -u || true; \
    make -j"$(nproc)"; \
    make install; \
    ln -s radiusd "${EMG_FREERADIUS_DIR}/sbin/freeradius"; \
    find "${EMG_FREERADIUS_DIR}" -name '*.a' -delete; find "${EMG_FREERADIUS_DIR}" -name '*.la' -delete; \
    rm -rf "${EMG_FREERADIUS_DIR}/share/doc"; \
    cp COPYRIGHT LICENSE README.rst "${EMG_FREERADIUS_DIR}/" 2>/dev/null || true; \
    cd /; rm -rf /usr/local/src/freeradius

# Test certificates as the Debian package generates them on install (shared by
# every container of the image - replace them for production: mount
# /etc/freeradius/certs or point mods-available/eap elsewhere).
RUN set -eux; \
    cd /etc/freeradius/certs; \
    ./bootstrap >/tmp/bootstrap.log 2>&1 || { cat /tmp/bootstrap.log; exit 1; }; \
    test -s server.pem && test -s ca.pem

##################################################################
#        Export + the Debian runtime packages the ELF files need
##################################################################
RUN set -eu; \
    out=/emg-export; \
    mkdir -p "$out"; \
    cp -a --parents "${EMG_FREERADIUS_DIR}" /etc/freeradius "$out/"; \
    elfs="$(find "${EMG_FREERADIUS_DIR}" -type f \( -perm -u+x -o -name '*.so' \) -exec sh -c 'file -b "$1" | grep -q ELF && echo "$1"' _ {} \;)"; \
    if for b in $elfs; do ldd "$b"; done | grep -q 'not found'; then echo "FATAL: unresolved deps in the builder" >&2; exit 1; fi; \
    for b in $elfs; do ldd "$b" | awk '$3 ~ /^\// {print $3}'; done | sort -u | grep -v "^${EMG_FREERADIUS_DIR}/" \
    | while read -r l; do \
        pkg=""; \
        for c in "$l" "$(readlink -f "$l")" "/usr$l" "${l#/usr}"; do \
          pkg="$(dpkg -S "$c" 2>/dev/null | grep -v '^diversion' | head -n1 | cut -d: -f1)"; \
          if [ -n "$pkg" ]; then echo "$pkg"; break; fi; \
        done; \
        [ -n "$pkg" ] || echo "MISSING $l"; \
      done | sort -u > /tmp/apt-packages; \
    if grep '^MISSING ' /tmp/apt-packages >&2; then echo "FATAL: no Debian package owns the libs above" >&2; exit 1; fi; \
    cp /tmp/apt-packages "$out${EMG_FREERADIUS_DIR}/.apt-packages"; \
    echo "--- runtime packages ---"; cat /tmp/apt-packages

##################################################################
##################################################################
#                       Final image
##################################################################
##################################################################
FROM ghcr.io/epicmorg/debian:trixie
ARG DEBIAN_FRONTEND=noninteractive

ENV EMG_FREERADIUS_VERSION=3.0
ENV EMG_FREERADIUS_FULL_VERSION=3.0.28
ENV EMG_FREERADIUS_DIR=${EMG_LOCAL_BASE_DIR}/freeradius/${EMG_FREERADIUS_VERSION}

LABEL org.opencontainers.image.title="EpicMorg FreeRADIUS"
LABEL org.opencontainers.image.description="FreeRADIUS server built from source on Debian trixie (SQL, LDAP, REST, Redis, Perl, Python modules), drop-in for freeradius/freeradius-server, by EpicMorg"
LABEL org.opencontainers.image.source="https://github.com/EpicMorg/docker"
LABEL org.opencontainers.image.licenses="MIT"

COPY --from=builder /emg-export/ /

ENV PATH="${EMG_FREERADIUS_DIR}/sbin:${EMG_FREERADIUS_DIR}/bin:${PATH}"

# freerad = the Debian / freeradius-server account; radiusd starts as root
# (ports 1812/1813) and drops to it (radiusd.conf user / group).
RUN set -eux; \
    apt-get update; \
    xargs -a "${EMG_FREERADIUS_DIR}/.apt-packages" apt-get install -y --no-install-recommends; \
    rm -rf /var/lib/apt/lists/*; \
    groupadd -r freerad; \
    useradd -r -g freerad -d /etc/freeradius -s /usr/sbin/nologin freerad; \
    sed -i -E 's/^#?[[:space:]]*user = .*/\tuser = freerad/; s/^#?[[:space:]]*group = .*/\tgroup = freerad/' /etc/freeradius/radiusd.conf; \
    grep -qE '^\s+user = freerad$' /etc/freeradius/radiusd.conf && grep -qE '^\s+group = freerad$' /etc/freeradius/radiusd.conf; \
    mkdir -p /var/log/freeradius /var/run/radiusd; \
    chown -R freerad:freerad /var/log/freeradius /var/run/radiusd; \
    chown -R root:freerad /etc/freeradius; chmod -R g+rX,o-rwx /etc/freeradius; \
    ln -s /etc/freeradius /etc/raddb

COPY usr/local/bin/docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh
RUN chmod 0755 /usr/local/bin/docker-entrypoint.sh

##################################################################
#                       Assertions (fatal)
##################################################################
RUN set -eu; \
    r="${EMG_FREERADIUS_DIR}/sbin/radiusd"; \
    [ "$(command -v radiusd)" = "$r" ] && [ "$(readlink -f "$(command -v freeradius)")" = "$r" ] || { echo "FATAL: radiusd / freeradius not on PATH" >&2; exit 1; }; \
    radiusd -v | head -1 | grep -q "Version ${EMG_FREERADIUS_FULL_VERSION}," || { echo "FATAL: not FreeRADIUS ${EMG_FREERADIUS_FULL_VERSION}" >&2; radiusd -v | head -1 >&2; exit 1; }; \
    for b in $(find "${EMG_FREERADIUS_DIR}" -type f \( -perm -u+x -o -name '*.so' \) -exec sh -c 'file -b "$1" | grep -q ELF && echo "$1"' _ {} \;); do \
      if ldd "$b" | grep -q 'not found'; then echo "FATAL: $b has unresolved deps" >&2; ldd "$b" | grep 'not found' >&2; exit 1; fi; \
      ! readelf -d "$b" | grep -q '(RUNPATH)' || { echo "FATAL: RUNPATH in $b" >&2; exit 1; }; \
      [ "$(ldd "$b" | grep -c 'libssl\.so' || true)" -le 1 ] || { echo "FATAL: more than one libssl in $b" >&2; exit 1; }; \
      ! ldd "$b" | grep -q "${EMG_LOCAL_BASE_DIR}/openssl/" || { echo "FATAL: $b links a baked OpenSSL (the modules use Debian's)" >&2; exit 1; }; \
    done; \
    # 3.0 has no rlm_json / rlm_kafka, and its rlm_python is Python 2 only (not built)
    mods="rlm_sql_mysql rlm_sql_postgresql rlm_sql_sqlite rlm_sql_unixodbc rlm_ldap rlm_rest rlm_redis rlm_perl rlm_krb5 rlm_pam rlm_eap_tls rlm_eap_peap rlm_eap_ttls rlm_eap_mschapv2"; \
    case "${EMG_FREERADIUS_VERSION}" in 3.0) ;; *) mods="$mods rlm_python3 rlm_json rlm_kafka" ;; esac; \
    for m in $mods; do \
      test -e "${EMG_FREERADIUS_DIR}/lib/$m.so" || { echo "FATAL: module $m missing" >&2; exit 1; }; \
    done; \
    echo "--- configuration check ---"; \
    radiusd -C -lstdout >/tmp/c.log 2>&1 || { tail -30 /tmp/c.log >&2; echo "FATAL: radiusd -C failed on the default configuration" >&2; exit 1; }; \
    echo "--- smoke test: Access-Request PAP, wrong password, Accounting, runs as freerad ---"; \
    port_free() { ! grep -qi "^ *[0-9]*: [0-9A-F]*:$(printf %04X "$1") " /proc/net/udp /proc/net/udp6 2>/dev/null; }; \
    p=0; while [ "$p" = 0 ] || ! port_free "$p" || ! port_free $((p + 1)) || ! port_free $((p + 2)); do p="$(shuf -i 20000-59997 -n 1)"; done; \
    t="$(mktemp -d)"; cp -a /etc/freeradius/. "$t/"; \
    printf 'smoke Cleartext-Password := "smokepw"\n' | cat - "$t/mods-config/files/authorize" > "$t/a" && mv "$t/a" "$t/mods-config/files/authorize"; \
    # the copy listens on random ports: auth p, acct p+1 (default site), inner-tunnel p+2
    awk -v a="$p" -v c="$((p + 1))" ' \
      function flush(   k, pt) { pt = (ty == "auth") ? a : (ty == "acct") ? c : ""; \
        for (k = 1; k <= nb; k++) { l = buf[k]; if (pt != "" && l ~ /^[[:space:]]*port[[:space:]]*=/) sub(/=.*/, "= " pt, l); print l }; nb = 0 } \
      !inb && /^[[:space:]]*listen[[:space:]]*\{/ { inb = 1; depth = 0; ty = ""; nb = 0 } \
      inb { buf[++nb] = $0; if ($1 == "type" && $2 == "=") ty = $3; \
            depth += gsub(/\{/, "{"); depth -= gsub(/\}/, "}"); if (depth == 0) { inb = 0; flush() }; next } \
      { print }' "$t/sites-available/default" > "$t/d" && mv "$t/d" "$t/sites-available/default"; \
    sed -i "s/port = 18120/port = $((p + 2))/" "$t/sites-available/inner-tunnel"; \
    grep -q "port = $p\$" "$t/sites-available/default" && grep -q "port = $((p + 1))\$" "$t/sites-available/default" || { echo "FATAL: smoke ports not set in the config copy" >&2; exit 1; }; \
    chgrp -R freerad "$t"; chmod -R g+rX "$t"; \
    docker-entrypoint.sh freeradius -d "$t" -l "$t/radius.log" > "$t/out" 2>&1 & \
    for i in $(seq 1 60); do grep -q 'Ready to process requests' "$t/radius.log" 2>/dev/null && break; sleep 0.5; done; \
    radtest smoke smokepw "127.0.0.1:$p" 0 testing123 2>&1 | grep -q 'Received Access-Accept' || { echo "FATAL: no Access-Accept" >&2; cat "$t/radius.log" "$t/out" >&2; exit 1; }; \
    radtest smoke wrong "127.0.0.1:$p" 0 testing123 2>&1 | grep -q 'Received Access-Reject' || { echo "FATAL: wrong password not rejected" >&2; exit 1; }; \
    printf 'User-Name = smoke\nAcct-Status-Type = Start\nAcct-Session-Id = s1\nNAS-IP-Address = 127.0.0.1\n' \
      | radclient -x "127.0.0.1:$((p + 1))" acct testing123 2>&1 | grep -q 'Received Accounting-Response' || { echo "FATAL: no Accounting-Response" >&2; cat "$t/radius.log" >&2; exit 1; }; \
    pid="$(pgrep -x radiusd | head -1)"; [ "$(stat -c %U "/proc/$pid")" = freerad ] || { echo "FATAL: radiusd does not run as freerad" >&2; exit 1; }; \
    kill "$pid"; for i in $(seq 1 20); do [ -e "/proc/$pid" ] || break; sleep 0.5; done; \
    rm -rf "$t"; \
    radiusd -v | head -1

EXPOSE 1812/udp 1813/udp

STOPSIGNAL SIGTERM
ENTRYPOINT ["tini", "--", "docker-entrypoint.sh"]
CMD ["freeradius"]
