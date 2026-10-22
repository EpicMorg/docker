##################################################################
##################################################################
#                          Builder
##################################################################
##################################################################
# All mariadb leaves share this file; they differ only in the EMG_MARIADB_*
# block below (written by bin/python/mariadb-versions-sync.py). MariaDB itself
# is the project's bintar tarball (GPG-checked by the sync script, sha256
# pinned here; glibc_214 builds up to 10.4, systemd builds from 10.5) - not
# built from source. TLS is linked in statically. What trixie lacks is baked
# here: libaio.so.1 (trixie renamed it libaio.so.1t64) and, for the clients up
# to 10.5, libncurses.so.5 / libtinfo.so.5 (ABI 5, gone from Debian).
FROM ghcr.io/epicmorg/gcc:14 AS builder

ENV EMG_MARIADB_VERSION=10.3
ENV EMG_MARIADB_FULL_VERSION=10.3.39
ARG EMG_MARIADB_TARBALL=mariadb-10.3.39-linux-glibc_214-x86_64.tar.gz
ARG EMG_MARIADB_URL=https://archive.mariadb.org/mariadb-10.3.39/bintar-linux-glibc_214-x86_64
# GPG signature (MariaDB signing keys) checked by the sync script, pinned here
ARG EMG_MARIADB_SHA256=761af85e2f289ba7d89230c6c49d71d39f6d8ad2b2fc8a524c5d5b1d9ce780ab
ENV EMG_MARIADB_DIR=${EMG_LOCAL_BASE_DIR}/mariadb/${EMG_MARIADB_VERSION}

# libaio: Debian's orig tarball (sha256 from libaio_0.3.113-10.dsc)
ENV EMG_LIBAIO_VERSION=0.3.113
ENV EMG_LIBAIO_DIR=${EMG_LOCAL_BASE_DIR}/libaio/${EMG_LIBAIO_VERSION}
ARG EMG_LIBAIO_URL=http://deb.debian.org/debian/pool/main/liba/libaio/libaio_0.3.113.orig.tar.gz
ARG EMG_LIBAIO_SHA256=2c44d1c5fd0d43752287c9ae1eb9c023f04ef848ea8d4aafa46e9aedb678200b
# ncurses ABI 5 (only the clients up to 10.5 link it); GNU tarball, signature by T. Dickey checked once
ENV EMG_NCURSES5_DIR=${EMG_LOCAL_BASE_DIR}/ncurses/6.6/abi5
ARG EMG_NCURSES_URL=https://ftp.gnu.org/gnu/ncurses/ncurses-6.6.tar.gz
ARG EMG_NCURSES_SHA256=355b4cbbed880b0381a04c46617b7656e362585d52e9cf84a67e2009b749ff11

RUN set -eux; \
    apt-get update; \
    apt-get install -y --no-install-recommends patchelf xz-utils; \
    rm -rf /var/lib/apt/lists/*

RUN set -eux; \
    mkdir -p /usr/local/src/libaio; cd /usr/local/src/libaio; \
    wget -q -O aio.tgz "${EMG_LIBAIO_URL}"; \
    echo "${EMG_LIBAIO_SHA256}  aio.tgz" | sha256sum -c -; \
    tar -xzf aio.tgz --strip-components=1 --no-same-owner; \
    make -j"$(nproc)" prefix="${EMG_LIBAIO_DIR}" CC=cc; \
    make prefix="${EMG_LIBAIO_DIR}" install; \
    find "${EMG_LIBAIO_DIR}" -name '*.a' -delete; \
    test -e "${EMG_LIBAIO_DIR}/lib/libaio.so.1"; \
    cd /; rm -rf /usr/local/src/libaio

RUN set -eux; \
    case "${EMG_MARIADB_VERSION}" in 5.*|10.[0-5]) ;; *) exit 0 ;; esac; \
    mkdir -p /usr/local/src/ncurses; cd /usr/local/src/ncurses; \
    wget -q -O nc.tgz "${EMG_NCURSES_URL}"; \
    echo "${EMG_NCURSES_SHA256}  nc.tgz" | sha256sum -c -; \
    tar -xzf nc.tgz --strip-components=1 --no-same-owner; \
    LDFLAGS="-Wl,-rpath,${EMG_NCURSES5_DIR}/lib -Wl,--disable-new-dtags" \
    ./configure --prefix="${EMG_NCURSES5_DIR}" --with-abi-version=5 --with-shared --without-normal \
      --without-debug --without-cxx --without-cxx-binding --without-ada --without-tests --without-manpages \
      --without-progs --with-termlib --disable-widec --with-default-terminfo-dir=/usr/share/terminfo \
      --with-terminfo-dirs=/etc/terminfo:/lib/terminfo:/usr/share/terminfo; \
    make -j"$(nproc)"; \
    make install; \
    test -e "${EMG_NCURSES5_DIR}/lib/libncurses.so.5" && test -e "${EMG_NCURSES5_DIR}/lib/libtinfo.so.5"; \
    rm -rf "${EMG_NCURSES5_DIR}/share" "${EMG_NCURSES5_DIR}/include"; \
    cd /; rm -rf /usr/local/src/ncurses

##################################################################
#                MariaDB (bintar tarball)
##################################################################
# Pruned: the test suite, *-debug / embedded / test binaries, static libraries,
# Galera (below).
# Wired: every ELF that misses libaio / ncurses 5 gets our prefixes appended to
# its own search path with patchelf --force-rpath (DT_RPATH; the vendor's
# own search path stays first).
RUN set -eux; \
    mkdir -p "${EMG_MARIADB_DIR}"; \
    cd /tmp; \
    wget -q -O "${EMG_MARIADB_TARBALL}" "${EMG_MARIADB_URL}/${EMG_MARIADB_TARBALL}"; \
    echo "${EMG_MARIADB_SHA256}  ${EMG_MARIADB_TARBALL}" | sha256sum -c -; \
    tar -xf "${EMG_MARIADB_TARBALL}" -C "${EMG_MARIADB_DIR}" --strip-components=1 --no-same-owner; \
    rm -f "${EMG_MARIADB_TARBALL}"; \
    cd "${EMG_MARIADB_DIR}"; \
    rm -rf mysql-test sql-bench lib/plugin/debug bin/*-debug bin/*_embedded bin/*client_test* bin/*mysqltest* bin/mariadb-test* docs/*.info; \
    # Galera (wsrep provider + arbitrator) links OpenSSL 1.1 / Boost 1.66 - a second
    # OpenSSL next to the server's own; clustering is a separate image (as bitnami's)
    rm -rf bin/garbd lib/galera lib/libgalera_smm.so share/galera; \
    find . -name '*.a' -delete; \
    extra=""; [ -d "${EMG_NCURSES5_DIR}/lib" ] && extra=":${EMG_NCURSES5_DIR}/lib"; \
    for f in $(find bin lib -type f \( -perm -u+x -o -name '*.so*' \) -exec sh -c 'file -b "$1" | grep -q ELF && echo "$1"' _ {} \;); do \
      ldd "$f" 2>/dev/null | grep -qE 'lib(aio|ncurses|tinfo)\.so\.[0-9t]+ => not found' || continue; \
      cur="$(readelf -d "$f" | sed -n 's/.*(R\(UN\)\{0,1\}PATH).*\[\(.*\)\]/\2/p' | head -1)"; \
      new="${cur:+$cur:}${EMG_LIBAIO_DIR}/lib$extra"; \
      echo "rpath $f: [${cur}] -> [$new]"; \
      patchelf --force-rpath --set-rpath "$new" "$f"; \
    done; \
    du -sh "${EMG_MARIADB_DIR}"

##################################################################
#        Export: mariadb + the prefixes baked for it
##################################################################
RUN set -eu; \
    out=/emg-export; \
    mkdir -p "$out"; \
    for p in "${EMG_MARIADB_DIR}" "${EMG_LIBAIO_DIR}" "${EMG_NCURSES5_DIR}"; do \
      [ -d "$p" ] && cp -a --parents "$p" "$out/"; \
    done; \
    du -sh "$out${EMG_LOCAL_BASE_DIR}"/*

##################################################################
##################################################################
#                       Final image
##################################################################
##################################################################
FROM ghcr.io/epicmorg/debian:trixie
ARG DEBIAN_FRONTEND=noninteractive

ENV EMG_MARIADB_VERSION=10.3
ENV EMG_MARIADB_FULL_VERSION=10.3.39
ENV EMG_MARIADB_DIR=${EMG_LOCAL_BASE_DIR}/mariadb/${EMG_MARIADB_VERSION}

LABEL org.opencontainers.image.title="EpicMorg MariaDB"
LABEL org.opencontainers.image.description="MariaDB (project binaries) on Debian trixie, library/mariadb and bitnami/mariadb compatible entrypoint, by EpicMorg"
LABEL org.opencontainers.image.source="https://github.com/EpicMorg/docker"
LABEL org.opencontainers.image.licenses="MIT"

# mariadb + libaio (+ ncurses 5) kept as a self-contained tree in /emg-export:
#   COPY --from=ghcr.io/epicmorg/mariadb:<ver> /emg-export/ /
COPY --from=builder /emg-export/ /
COPY --from=builder /emg-export/ /emg-export/

ENV PATH="${EMG_MARIADB_DIR}/bin:${PATH}"

# libnuma, perl (mysqldumpslow & co.), tzdata, and every Debian library the
# server / tools / plugins link - listed explicitly, not left to the base image
# (RocksDB: snappy, lzo, lz4; CONNECT: libodbc2, libxml2; S3: libcurl; cracklib,
# OQGraph: Judy; PAM, GSSAPI, LDAP auth plugins)
# (tz tables on the first start), compressors for initdb.d dumps.
# mysql = uid 999 as in library/mariadb (gid 999 is systemd-journal on our base,
# so the group gets a free system gid); /opt/bitnami/mariadb/conf is where
# bitnami's my_custom.cnf is mounted.
RUN set -eux; \
    apt-get update; \
    apt-get install -y --no-install-recommends libnuma1 perl tzdata xz-utils bzip2 zstd libcrack2 libodbc2 libjudydebian1 \
      libsnappy1v5 liblzo2-2 liblz4-1 libzstd1 liblzma5 libbz2-1.0 zlib1g libcurl4t64 libxml2 libssl3t64 libgnutls30t64 \
      libldap2 libsasl2-2 libgssapi-krb5-2 libpam0g libltdl7 libsystemd0 libaudit1 libcap2 libstdc++6 libatomic1; \
    rm -rf /var/lib/apt/lists/*; \
    groupadd -r mysql; \
    useradd -r -u 999 -g mysql -d /var/lib/mysql -s /usr/sbin/nologin mysql; \
    mkdir -p /var/lib/mysql /var/lib/mysql-files /var/run/mysqld /etc/mysql/conf.d /docker-entrypoint-initdb.d /opt/bitnami/mariadb/conf; \
    chown mysql:mysql /var/lib/mysql /var/lib/mysql-files /var/run/mysqld; \
    chmod 1777 /var/run/mysqld /etc/mysql/conf.d; \
    ln -s "${EMG_MARIADB_DIR}" /usr/local/mysql; ln -s "${EMG_MARIADB_DIR}" /usr/local/mariadb

# Optional pieces whose libraries have no trixie counterpart are dropped, by
# name, in the log and in ${EMG_MARIADB_DIR}/.dropped: storage-engine / auth
# plugins (CONNECT of <= 10.4 wants unixODBC 2.2's libodbc.so.1, S3 of 10.5 a
# libcurl built against OpenSSL 1.0 - CURL_OPENSSL_3) and the S3 tools. The
# server, clients and every other binary stay under the fatal check below.
RUN set -eu; \
    cd "${EMG_MARIADB_DIR}"; \
    : > .dropped; \
    for f in lib/plugin/*.so bin/aria_s3_copy; do \
      [ -f "$f" ] || continue; \
      miss="$(ldd "$f" 2>&1 | grep -E 'not found|version .* not found' | sed -E 's/^\s+//' | tr '\n' ' ')"; \
      [ -n "$miss" ] || continue; \
      echo "dropped $f: $miss" | tee -a .dropped; \
      rm -f "$f" "/emg-export${EMG_MARIADB_DIR}/$f"; \
    done; \
    cp .dropped "/emg-export${EMG_MARIADB_DIR}/.dropped"

COPY etc/mysql/my.cnf /etc/mysql/my.cnf
COPY usr/local/bin/docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh
RUN set -eux; \
    sed -i "s#@BASEDIR@#${EMG_MARIADB_DIR}#" /etc/mysql/my.cnf; \
    ! grep -q '@BASEDIR@' /etc/mysql/my.cnf; \
    chmod 0755 /usr/local/bin/docker-entrypoint.sh

##################################################################
#                       Assertions (fatal)
##################################################################
RUN set -eu; \
    srv="$(command -v mariadbd || command -v mysqld)"; cli="$(command -v mariadb || command -v mysql)"; adm="$(command -v mariadb-admin || command -v mysqladmin)"; \
    case "$srv" in "${EMG_MARIADB_DIR}"/bin/*) ;; *) echo "FATAL: server on PATH is $srv" >&2; exit 1 ;; esac; \
    "$srv" --version | grep -q "Ver ${EMG_MARIADB_FULL_VERSION}-MariaDB" || { echo "FATAL: not MariaDB ${EMG_MARIADB_FULL_VERSION}" >&2; "$srv" --version >&2; exit 1; }; \
    "$cli" --version 2>&1 | grep -q "${EMG_MARIADB_FULL_VERSION}-MariaDB" || { echo "FATAL: client is not ${EMG_MARIADB_FULL_VERSION}" >&2; "$cli" --version >&2; exit 1; }; \
    test -x "/emg-export$srv" || { echo "FATAL: /emg-export has no server" >&2; exit 1; }; \
    for b in $(find "${EMG_MARIADB_DIR}/bin" "${EMG_MARIADB_DIR}/lib" -type f \( -perm -u+x -o -name '*.so*' \) -exec sh -c 'file -b "$1" | grep -q ELF && echo "$1"' _ {} \;); do \
      if ldd "$b" 2>/dev/null | grep -q 'not found'; then echo "FATAL: $b has unresolved deps" >&2; ldd "$b" | grep 'not found' >&2; exit 1; fi; \
      [ "$(ldd "$b" 2>/dev/null | grep -c 'libssl\.so' || true)" -le 1 ] || { echo "FATAL: more than one libssl in $b" >&2; exit 1; }; \
    done; \
    if ldd "$srv" | grep -q 'libaio'; then \
      ldd "$srv" | grep -q "${EMG_LOCAL_BASE_DIR}/libaio/.*/libaio\.so\.1" || { echo "FATAL: the server does not use the baked libaio" >&2; exit 1; }; \
    fi; \
    echo "--- smoke test: library mode (root, database, user, tz tables), restart, bitnami variables ---"; \
    vnum="$(echo "${EMG_MARIADB_VERSION}" | awk -F. '{ printf "%d%03d", $1, $2 }')"; \
    port_free() { ! grep -qi "^ *[0-9]*: [0-9A-F]*:$(printf %04X "$1") " /proc/net/tcp /proc/net/tcp6 2>/dev/null; }; \
    pick() { q=0; while [ "$q" = 0 ] || ! port_free "$q"; do q="$(shuf -i 20000-59999 -n 1)"; done; echo "$q"; }; \
    t="$(mktemp -d)"; chmod 0777 "$t"; \
    start() { n="$1"; u="$2"; pw="$3"; shift 3; p="$(pick)"; \
      env "$@" docker-entrypoint.sh mariadbd --datadir="$t/$n" --socket="$t/$n.sock" --pid-file="$t/$n.pid" \
        --port="$p" --bind-address=127.0.0.1 > "$t/$n.log" 2>&1 & \
      for i in $(seq 1 300); do \
        grep -q 'mariadb-entrypoint .* starting ' "$t/$n.log" && "$cli" --protocol=tcp -h127.0.0.1 -P"$p" -u"$u" -p"$pw" -e 'SELECT 1' >/dev/null 2>&1 && return 0; \
        sleep 1; \
      done; cat "$t/$n.log" >&2; return 1; }; \
    stop() { "$adm" --protocol=tcp -h127.0.0.1 -P"$p" -u"$u" -p"$pw" shutdown >/dev/null 2>&1 || true; \
      for i in $(seq 1 90); do [ -e "$t/$n.pid" ] || return 0; sleep 1; done; }; \
    q() { "$cli" --protocol=tcp -h127.0.0.1 -P"$p" -N -B "$@" 2>/dev/null; }; \
    start lib root smoke MARIADB_ROOT_PASSWORD=smoke MARIADB_DATABASE=app MARIADB_USER=app MARIADB_PASSWORD=apppw \
      || { echo "FATAL: library mode: the server does not answer" >&2; exit 1; }; \
    [ "$(q -uapp -papppw app -e 'SELECT 41+1')" = 42 ] || { echo "FATAL: MARIADB_USER cannot use MARIADB_DATABASE" >&2; exit 1; }; \
    [ "$(q -uroot -psmoke -e 'SELECT COUNT(*) > 0 FROM mysql.time_zone_name')" = 1 ] || { echo "FATAL: time zone tables not loaded" >&2; exit 1; }; \
    [ "$(q -uroot -psmoke -e 'SELECT VERSION()' | cut -d- -f1)" = "${EMG_MARIADB_FULL_VERSION}" ] || { echo "FATAL: server reports another version" >&2; exit 1; }; \
    [ "$(q -uroot -psmoke -e "SELECT COUNT(*) FROM mysql.user WHERE user = ''")" = 0 ] || { echo "FATAL: anonymous accounts left" >&2; exit 1; }; \
    if [ "$vnum" -ge 11004 ]; then \
      q -uapp -papppw --ssl -e "SHOW SESSION STATUS LIKE 'Ssl_cipher'" | awk '{print $2}' | grep -q . \
        || { echo "FATAL: no TLS connection (zero-configuration TLS of 11.4+)" >&2; exit 1; }; \
    fi; \
    [ "$(stat -c %U "/proc/$(cat "$t/lib.pid")")" = mysql ] || { echo "FATAL: the server does not run as mysql" >&2; exit 1; }; \
    stop; \
    start lib app apppw || { echo "FATAL: restart on the persisted datadir failed" >&2; exit 1; }; \
    ! grep -q 'initializing database files' "$t/lib.log" || { echo "FATAL: second start re-initialised" >&2; exit 1; }; \
    u=root; pw=smoke; stop; \
    start bn admin apw MARIADB_ROOT_USER=admin MARIADB_ROOT_PASSWORD=apw MARIADB_CHARACTER_SET=utf8mb4 MARIADB_COLLATE=utf8mb4_unicode_ci MARIADB_DATABASE=bdb \
      || { echo "FATAL: bitnami variables: the server does not answer" >&2; exit 1; }; \
    [ "$(q -uadmin -papw -e 'SELECT @@character_set_server')" = utf8mb4 ] || { echo "FATAL: MARIADB_CHARACTER_SET ignored" >&2; exit 1; }; \
    [ "$(q -uadmin -papw -e "SELECT DEFAULT_COLLATION_NAME FROM information_schema.SCHEMATA WHERE SCHEMA_NAME='bdb'")" = utf8mb4_unicode_ci ] \
      || { echo "FATAL: MARIADB_COLLATE not applied to MARIADB_DATABASE" >&2; exit 1; }; \
    q -uadmin -papw -e 'CREATE DATABASE smoke_admin' || { echo "FATAL: MARIADB_ROOT_USER has no global privileges" >&2; exit 1; }; \
    stop; \
    if timeout 120 docker-entrypoint.sh mariadbd --datadir="$t/none" --socket="$t/none.sock" >/dev/null 2>&1; then \
      echo "FATAL: started on an empty datadir without any password option" >&2; exit 1; fi; \
    rm -rf "$t"; \
    "$srv" --version

VOLUME ["/var/lib/mysql"]
EXPOSE 3306

HEALTHCHECK --interval=30s --timeout=5s --start-period=60s \
        CMD { mariadb-admin --protocol=socket ping || mysqladmin --protocol=socket ping; } >/dev/null 2>&1 || exit 1

STOPSIGNAL SIGTERM
ENTRYPOINT ["tini", "--", "docker-entrypoint.sh"]
CMD ["mariadbd"]
