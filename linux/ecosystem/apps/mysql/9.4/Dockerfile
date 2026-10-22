##################################################################
##################################################################
#                          Builder
##################################################################
##################################################################
# All mysql leaves share this file; they differ only in the EMG_MYSQL_* block
# below (written by bin/python/mysql-versions-sync.py). MySQL itself is
# Oracle's generic Linux tarball (GPG-checked by the sync script, sha256
# pinned here) - not built from source (CMake + Boost, hours per line).
# 8.0+ ship their own OpenSSL / Kerberos / LDAP / SASL / protobuf in
# lib/private (RUNPATH $ORIGIN/../lib/private) - kept as shipped, one OpenSSL
# per process; 5.6 / 5.7 link TLS statically. What trixie lacks is baked here:
# libaio.so.1 (trixie renamed it libaio.so.1t64) and, for the 5.x clients,
# libncurses.so.5 / libtinfo.so.5 (ABI 5, gone from Debian).
FROM ghcr.io/epicmorg/gcc:14 AS builder

ENV EMG_MYSQL_VERSION=9.4
ENV EMG_MYSQL_FULL_VERSION=9.4.0
ARG EMG_MYSQL_TARBALL=mysql-9.4.0-linux-glibc2.28-x86_64-minimal.tar.xz
ARG EMG_MYSQL_URL=https://cdn.mysql.com/archives/mysql-9.4
# GPG signature (MySQL Release Engineering) checked by the sync script, pinned here
ARG EMG_MYSQL_SHA256=5e58d40d25c9e627308404e59a9c653d1cbdbf8dd868ccac4ae493cc9b624a09
ENV EMG_MYSQL_DIR=${EMG_LOCAL_BASE_DIR}/mysql/${EMG_MYSQL_VERSION}

# libaio: Debian's orig tarball (sha256 from libaio_0.3.113-10.dsc)
ENV EMG_LIBAIO_VERSION=0.3.113
ENV EMG_LIBAIO_DIR=${EMG_LOCAL_BASE_DIR}/libaio/${EMG_LIBAIO_VERSION}
ARG EMG_LIBAIO_URL=http://deb.debian.org/debian/pool/main/liba/libaio/libaio_0.3.113.orig.tar.gz
ARG EMG_LIBAIO_SHA256=2c44d1c5fd0d43752287c9ae1eb9c023f04ef848ea8d4aafa46e9aedb678200b
# ncurses ABI 5 (only the 5.x clients link it); GNU tarball, signature by T. Dickey checked once
ENV EMG_NCURSES5_DIR=${EMG_LOCAL_BASE_DIR}/ncurses/6.6/abi5
ARG EMG_NCURSES_URL=https://ftp.gnu.org/gnu/ncurses/ncurses-6.6.tar.gz
ARG EMG_NCURSES_SHA256=355b4cbbed880b0381a04c46617b7656e362585d52e9cf84a67e2009b749ff11

RUN set -eux; \
    apt-get update; \
    apt-get install -y --no-install-recommends patchelf xz-utils; \
    rm -rf /var/lib/apt/lists/*

RUN set -eux; \
    mkdir -p /usr/local/src/libaio; cd /usr/local/src/libaio; \
    aria2c --conf-path=/usr/local/share/epicmorg/aria2/config/aria2.conf \
        --user-agent="$(shuf -n 1 /usr/local/share/epicmorg/user-agents/user-agents.txt)" \
        -o aio.tgz "${EMG_LIBAIO_URL}"; \
    echo "${EMG_LIBAIO_SHA256}  aio.tgz" | sha256sum -c -; \
    tar -xzf aio.tgz --strip-components=1 --no-same-owner; \
    make -j"$(nproc)" prefix="${EMG_LIBAIO_DIR}" CC=cc; \
    make prefix="${EMG_LIBAIO_DIR}" install; \
    find "${EMG_LIBAIO_DIR}" -name '*.a' -delete; \
    test -e "${EMG_LIBAIO_DIR}/lib/libaio.so.1"; \
    cd /; rm -rf /usr/local/src/libaio

RUN set -eux; \
    case "${EMG_MYSQL_VERSION}" in 5.*) ;; *) exit 0 ;; esac; \
    mkdir -p /usr/local/src/ncurses; cd /usr/local/src/ncurses; \
    aria2c --conf-path=/usr/local/share/epicmorg/aria2/config/aria2.conf \
        --user-agent="$(shuf -n 1 /usr/local/share/epicmorg/user-agents/user-agents.txt)" \
        -o nc.tgz "${EMG_NCURSES_URL}"; \
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
#                MySQL (Oracle generic tarball)
##################################################################
# Pruned: the test suite, *-debug / embedded binaries, static libraries.
# Wired: every ELF that misses libaio / ncurses 5 gets our prefixes appended to
# its own search path with patchelf --force-rpath (DT_RPATH; the vendor's
# $ORIGIN/../lib/private stays first).
RUN set -eux; \
    mkdir -p "${EMG_MYSQL_DIR}"; \
    cd /tmp; \
    aria2c --conf-path=/usr/local/share/epicmorg/aria2/config/aria2.conf \
        --user-agent="$(shuf -n 1 /usr/local/share/epicmorg/user-agents/user-agents.txt)" \
        -o "${EMG_MYSQL_TARBALL}" "${EMG_MYSQL_URL}/${EMG_MYSQL_TARBALL}"; \
    echo "${EMG_MYSQL_SHA256}  ${EMG_MYSQL_TARBALL}" | sha256sum -c -; \
    tar -xf "${EMG_MYSQL_TARBALL}" -C "${EMG_MYSQL_DIR}" --strip-components=1 --no-same-owner; \
    rm -f "${EMG_MYSQL_TARBALL}"; \
    cd "${EMG_MYSQL_DIR}"; \
    rm -rf mysql-test sql-bench lib/plugin/debug bin/*-debug bin/*_embedded bin/mysql_client_test* bin/mysqltest* docs/*.info; \
    find . -name '*.a' -delete; \
    extra=""; [ -d "${EMG_NCURSES5_DIR}/lib" ] && extra=":${EMG_NCURSES5_DIR}/lib"; \
    for f in $(find bin lib -type f \( -perm -u+x -o -name '*.so*' \) -exec sh -c 'file -b "$1" | grep -q ELF && echo "$1"' _ {} \;); do \
      ldd "$f" 2>/dev/null | grep -qE 'lib(aio|ncurses|tinfo)\.so\.[0-9t]+ => not found' || continue; \
      cur="$(readelf -d "$f" | sed -n 's/.*(R\(UN\)\{0,1\}PATH).*\[\(.*\)\]/\2/p' | head -1)"; \
      new="${cur:+$cur:}${EMG_LIBAIO_DIR}/lib$extra"; \
      echo "rpath $f: [${cur}] -> [$new]"; \
      patchelf --force-rpath --set-rpath "$new" "$f"; \
    done; \
    du -sh "${EMG_MYSQL_DIR}"

##################################################################
#        Export: mysql + the prefixes baked for it
##################################################################
RUN set -eu; \
    out=/emg-export; \
    mkdir -p "$out"; \
    for p in "${EMG_MYSQL_DIR}" "${EMG_LIBAIO_DIR}" "${EMG_NCURSES5_DIR}"; do \
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

ENV EMG_MYSQL_VERSION=9.4
ENV EMG_MYSQL_FULL_VERSION=9.4.0
ENV EMG_MYSQL_DIR=${EMG_LOCAL_BASE_DIR}/mysql/${EMG_MYSQL_VERSION}

LABEL org.opencontainers.image.title="EpicMorg MySQL"
LABEL org.opencontainers.image.description="MySQL (Oracle generic binaries) on Debian trixie, library/mysql and bitnami/mysql compatible entrypoint, by EpicMorg"
LABEL org.opencontainers.image.source="https://github.com/EpicMorg/docker"
LABEL org.opencontainers.image.licenses="MIT"

# mysql + libaio (+ ncurses 5) kept as a self-contained tree in /emg-export:
#   COPY --from=ghcr.io/epicmorg/mysql:<ver> /emg-export/ /
COPY --from=builder /emg-export/ /
COPY --from=builder /emg-export/ /emg-export/

ENV PATH="${EMG_MYSQL_DIR}/bin:${PATH}"

# libnuma (mysqld) and the other Debian libraries the binaries link (explicit, not
# left to the base image), perl (5.6 mysql_install_db, mysqldumpslow), tzdata
# (tz tables on the first start), compressors for initdb.d dumps.
# mysql = uid 999 as in library/mysql (gid 999 is systemd-journal on our base,
# so the group gets a free system gid); /opt/bitnami/mysql/conf is where
# bitnami's my_custom.cnf is mounted.
RUN set -eux; \
    apt-get update; \
    apt-get install -y --no-install-recommends libnuma1 perl tzdata xz-utils bzip2 zstd \
      libncurses6 libtinfo6 libudev1 libcap2 libkeyutils1 libstdc++6; \
    rm -rf /var/lib/apt/lists/*; \
    groupadd -r mysql; \
    useradd -r -u 999 -g mysql -d /var/lib/mysql -s /usr/sbin/nologin mysql; \
    mkdir -p /var/lib/mysql /var/lib/mysql-files /var/run/mysqld /etc/mysql/conf.d /docker-entrypoint-initdb.d /opt/bitnami/mysql/conf; \
    chown mysql:mysql /var/lib/mysql /var/lib/mysql-files /var/run/mysqld; \
    chmod 1777 /var/run/mysqld /etc/mysql/conf.d; \
    ln -s "${EMG_MYSQL_DIR}" /usr/local/mysql

COPY etc/mysql/my.cnf /etc/mysql/my.cnf
COPY usr/local/bin/docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh
RUN set -eux; \
    sed -i "s#@BASEDIR@#${EMG_MYSQL_DIR}#" /etc/mysql/my.cnf; \
    ! grep -q '@BASEDIR@' /etc/mysql/my.cnf; \
    chmod 0755 /usr/local/bin/docker-entrypoint.sh

##################################################################
#                       Assertions (fatal)
##################################################################
RUN set -eu; \
    [ "$(command -v mysqld)" = "${EMG_MYSQL_DIR}/bin/mysqld" ] || { echo "FATAL: mysqld on PATH is $(command -v mysqld)" >&2; exit 1; }; \
    mysqld --version | grep -q "Ver ${EMG_MYSQL_FULL_VERSION}[ -]" || { echo "FATAL: not MySQL ${EMG_MYSQL_FULL_VERSION}" >&2; mysqld --version >&2; exit 1; }; \
    mysql --version | grep -qE "(Distrib |Ver )${EMG_MYSQL_FULL_VERSION}" || { echo "FATAL: mysql client is not ${EMG_MYSQL_FULL_VERSION}" >&2; mysql --version >&2; exit 1; }; \
    test -x "/emg-export${EMG_MYSQL_DIR}/bin/mysqld" || { echo "FATAL: /emg-export has no mysqld" >&2; exit 1; }; \
    for b in $(find "${EMG_MYSQL_DIR}/bin" "${EMG_MYSQL_DIR}/lib" -type f \( -perm -u+x -o -name '*.so*' \) -exec sh -c 'file -b "$1" | grep -q ELF && echo "$1"' _ {} \;); do \
      if ldd "$b" 2>/dev/null | grep -q 'not found'; then echo "FATAL: $b has unresolved deps" >&2; ldd "$b" | grep 'not found' >&2; exit 1; fi; \
      [ "$(ldd "$b" 2>/dev/null | grep -c 'libssl\.so' || true)" -le 1 ] || { echo "FATAL: more than one libssl in $b" >&2; exit 1; }; \
      if ldd "$b" 2>/dev/null | grep -q 'libssl\.so'; then \
        readlink -f "$(ldd "$b" | awk '$1 ~ /^libssl\.so/ {print $3}')" | grep -q "^${EMG_MYSQL_DIR}/lib/private/" \
          || { echo "FATAL: $b: libssl is not MySQL's own (lib/private)" >&2; ldd "$b" >&2; exit 1; }; \
      fi; \
    done; \
    ldd "${EMG_MYSQL_DIR}/bin/mysqld" | grep -q "${EMG_LOCAL_BASE_DIR}/libaio/.*/libaio\.so\.1" || { echo "FATAL: mysqld does not use the baked libaio" >&2; exit 1; }; \
    echo "--- smoke test: library mode (root, database, user, tz tables, TLS), restart, bitnami variables ---"; \
    vnum="$(echo "${EMG_MYSQL_VERSION}" | awk -F. '{ printf "%d%03d", $1, $2 }')"; \
    port_free() { ! grep -qi "^ *[0-9]*: [0-9A-F]*:$(printf %04X "$1") " /proc/net/tcp /proc/net/tcp6 2>/dev/null; }; \
    pick() { q=0; while [ "$q" = 0 ] || ! port_free "$q"; do q="$(shuf -i 20000-59999 -n 1)"; done; echo "$q"; }; \
    t="$(mktemp -d)"; chmod 0777 "$t"; \
    # start <name> <user> <password> [VAR=value ...]: entrypoint on a random port, waits for the final mysqld
    start() { n="$1"; u="$2"; pw="$3"; shift 3; p="$(pick)"; xa=""; \
      [ "$vnum" -ge 8000 ] && xa="--mysqlx-port=$(pick) --mysqlx-socket=$t/$n.xsock"; \
      env "$@" docker-entrypoint.sh mysqld --datadir="$t/$n" --socket="$t/$n.sock" --pid-file="$t/$n.pid" \
        --port="$p" --bind-address=127.0.0.1 $xa > "$t/$n.log" 2>&1 & \
      for i in $(seq 1 300); do \
        grep -q 'starting mysqld' "$t/$n.log" && mysql --protocol=tcp -h127.0.0.1 -P"$p" -u"$u" -p"$pw" -e 'SELECT 1' >/dev/null 2>&1 && return 0; \
        sleep 1; \
      done; cat "$t/$n.log" >&2; return 1; }; \
    stop() { mysqladmin --protocol=tcp -h127.0.0.1 -P"$p" -u"$u" -p"$pw" shutdown >/dev/null 2>&1 || true; \
      for i in $(seq 1 90); do [ -e "$t/$n.pid" ] || return 0; sleep 1; done; }; \
    q() { mysql --protocol=tcp -h127.0.0.1 -P"$p" -N -B "$@" 2>/dev/null; }; \
    start lib root smoke MYSQL_ROOT_PASSWORD=smoke MYSQL_DATABASE=app MYSQL_USER=app MYSQL_PASSWORD=apppw \
      || { echo "FATAL: library mode: mysqld does not answer" >&2; exit 1; }; \
    [ "$(q -uapp -papppw app -e 'SELECT 41+1')" = 42 ] || { echo "FATAL: MYSQL_USER cannot use MYSQL_DATABASE" >&2; exit 1; }; \
    [ "$(q -uroot -psmoke -e 'SELECT COUNT(*) > 0 FROM mysql.time_zone_name')" = 1 ] || { echo "FATAL: time zone tables not loaded" >&2; exit 1; }; \
    [ "$(q -uroot -psmoke -e 'SELECT VERSION()' | cut -d- -f1)" = "${EMG_MYSQL_FULL_VERSION}" ] || { echo "FATAL: server reports another version" >&2; exit 1; }; \
    if [ "$vnum" -ge 5007 ]; then \
      q -uapp -papppw --ssl-mode=REQUIRED -e "SHOW SESSION STATUS LIKE 'Ssl_cipher'" | awk '{print $2}' | grep -q . \
        || { echo "FATAL: no TLS connection" >&2; exit 1; }; \
    fi; \
    [ "$(stat -c %U "/proc/$(cat "$t/lib.pid")")" = mysql ] || { echo "FATAL: mysqld does not run as mysql" >&2; exit 1; }; \
    stop; \
    start lib app apppw || { echo "FATAL: restart on the persisted datadir failed" >&2; exit 1; }; \
    ! grep -q 'initializing database files' "$t/lib.log" || { echo "FATAL: second start re-initialised" >&2; exit 1; }; \
    u=root; pw=smoke; stop; \
    start bn admin apw MYSQL_ROOT_USER=admin MYSQL_ROOT_PASSWORD=apw MYSQL_CHARACTER_SET=utf8mb4 MYSQL_COLLATE=utf8mb4_unicode_ci MYSQL_DATABASE=bdb \
      || { echo "FATAL: bitnami variables: mysqld does not answer" >&2; exit 1; }; \
    [ "$(q -uadmin -papw -e 'SELECT @@character_set_server')" = utf8mb4 ] || { echo "FATAL: MYSQL_CHARACTER_SET ignored" >&2; exit 1; }; \
    [ "$(q -uadmin -papw -e "SELECT DEFAULT_COLLATION_NAME FROM information_schema.SCHEMATA WHERE SCHEMA_NAME='bdb'")" = utf8mb4_unicode_ci ] \
      || { echo "FATAL: MYSQL_COLLATE not applied to MYSQL_DATABASE" >&2; exit 1; }; \
    q -uadmin -papw -e 'CREATE DATABASE smoke_admin' || { echo "FATAL: MYSQL_ROOT_USER has no global privileges" >&2; exit 1; }; \
    stop; \
    if timeout 120 docker-entrypoint.sh mysqld --datadir="$t/none" --socket="$t/none.sock" >/dev/null 2>&1; then \
      echo "FATAL: started on an empty datadir without any password option" >&2; exit 1; fi; \
    rm -rf "$t"; \
    mysqld --version

VOLUME ["/var/lib/mysql"]
EXPOSE 3306 33060

HEALTHCHECK --interval=30s --timeout=5s --start-period=60s \
        CMD mysqladmin --protocol=socket ping >/dev/null 2>&1 || exit 1

STOPSIGNAL SIGTERM
ENTRYPOINT ["tini", "--", "docker-entrypoint.sh"]
CMD ["mysqld"]
