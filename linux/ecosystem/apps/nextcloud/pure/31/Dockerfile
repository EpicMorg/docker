##################################################################
#   Nextcloud 31: the official image's Nextcloud, our PHP + Apache
##################################################################
# All nextcloud leaves share this file (bin/python/nextcloud-sync.py); they
# differ only in the upstream tag, the PHP line and the upstream ENV block.
# Drop-in for docker.io/nextcloud:31 (apache): same /entrypoint.sh, /cron.sh,
# volume, user (www-data, 33), environment variables, hooks, CMD and STOPSIGNAL.
# PHP runs as php-fpm behind Apache (mpm_event, proxy_fcgi) - no mod_php.
FROM docker.io/nextcloud:31 AS upstream

##################################################################
#    smbclient / inotify / imap on the line's own OpenSSL
##################################################################
FROM ghcr.io/epicmorg/php:8.3 AS ext
ARG DEBIAN_FRONTEND=noninteractive
ARG UW_ORIG_URL=http://deb.debian.org/debian/pool/main/u/uw-imap/uw-imap_2007f~dfsg.orig.tar.gz
ARG UW_ORIG_SHA256=4fdec0b5a085a7269db87214276e14ce79afdf7efec2ca8d431ab176b9062a8a
ARG UW_DEB_URL=http://deb.debian.org/debian/pool/main/u/uw-imap/uw-imap_2007f~dfsg-7.debian.tar.xz
ARG UW_DEB_SHA256=9d778c6de093abf9d07164d6ad074bfe4c2ab38934283741b006f9537f6e896c
ARG PECL_PACKAGES="inotify-3.0.1:fbb7240abae502ea8f4b3c68264c6425fb46647402a8f93916482845394ad124 smbclient-1.2.0dev:b9dd55c0334f5393ae97dfc6248e09380ff38425f865a9ee580577ca645a2575"
ARG IMAP_FROM=php-src
ARG PHP_SRC_SHA256=dd54693aa334c5c4d72e9aee96b082c2473750a18a6c1d105789c93a3b1692fd
ENV EMG_NC_CCLIENT_DIR=${EMG_LOCAL_BASE_DIR}/c-client/2007f

RUN set -eux; \
    apt-get update; \
    apt-get install -y --no-install-recommends libsmbclient-dev libkrb5-dev patch; \
    rm -rf /var/lib/apt/lists/*; \
    test -n "${EMG_PHP_LDAP_DIR:-}" -a -e "${EMG_PHP_LDAP_DIR}/lib/libldap.so.2"

# UW-IMAP c-client 2007f (Debian's source + patches), static, -fPIC, on the
# line's OpenSSL; only the library is built (no bundled servers / tools)
RUN set -eux; \
    mkdir -p /usr/local/src/uw-imap; \
    cd /usr/local/src/uw-imap; \
    aria2c --conf-path=/usr/local/share/epicmorg/aria2/config/aria2.conf \
        --user-agent="$(shuf -n 1 /usr/local/share/epicmorg/user-agents/user-agents.txt)" \
        -o orig.tgz "${UW_ORIG_URL}"; \
    echo "${UW_ORIG_SHA256}  orig.tgz" | sha256sum -c -; \
    aria2c --conf-path=/usr/local/share/epicmorg/aria2/config/aria2.conf \
        --user-agent="$(shuf -n 1 /usr/local/share/epicmorg/user-agents/user-agents.txt)" \
        -o debian.txz "${UW_DEB_URL}"; \
    echo "${UW_DEB_SHA256}  debian.txz" | sha256sum -c -; \
    tar -xzf orig.tgz --strip-components=1; \
    tar -xJf debian.txz; \
    for p in $(grep -v '^#' debian/patches/series); do patch -p1 --forward < "debian/patches/$p"; done; \
    sed -i 's/^build:\tOSTYPE rebuild rebuildclean bundled$/build:\tOSTYPE rebuild rebuildclean/' Makefile; \
    grep -q '^build:	OSTYPE rebuild rebuildclean$' Makefile; \
    touch ip6; \
    make slx IP=6 SSLTYPE=unix.nopwd SSLDIR="${PHP_SSL_DIR}" SSLINCLUDE="${PHP_SSL_DIR}/include" \
        SSLLIB="${PHP_SSL_LIB_DIR}" SSLCERTS=/etc/ssl/certs SSLKEYS=/etc/ssl/private EXTRAAUTHENTICATORS=gss \
        EXTRACFLAGS="-fPIC -O2 -std=gnu17 -Wno-error=implicit-function-declaration -Wno-error=incompatible-pointer-types -Wno-error=int-conversion -Wno-error=implicit-int" \
        > /tmp/c-client.log 2>&1 || { tail -60 /tmp/c-client.log >&2; exit 1; }; \
    mkdir -p "${EMG_NC_CCLIENT_DIR}/include" "${EMG_NC_CCLIENT_DIR}/lib"; \
    cp c-client/*.h "${EMG_NC_CCLIENT_DIR}/include/"; \
    cp c-client/c-client.a "${EMG_NC_CCLIENT_DIR}/lib/libc-client.a"; \
    cd /; rm -rf /usr/local/src/uw-imap

# PECL packages from pinned tarballs; imap from PECL (8.4+) or from the line's
# php-src (ext/imap, up to 8.3). smbclient links the php image's libldap first,
# so libsmbclient's libldap.so.2 resolves to it (one OpenSSL in the process).
# imap: LIBS puts OpenSSL after the static c-client (old ext/imap link tests).
RUN set -eux; \
    extdir="$(php -r 'echo ini_get("extension_dir");')"; \
    mkdir -p /emg-export/ext /usr/local/src/pecl; \
    cd /usr/local/src/pecl; \
    for p in ${PECL_PACKAGES}; do \
        n="${p%%:*}"; \
        aria2c --conf-path=/usr/local/share/epicmorg/aria2/config/aria2.conf \
            --user-agent="$(shuf -n 1 /usr/local/share/epicmorg/user-agents/user-agents.txt)" \
            -o "$n.tgz" "https://pecl.php.net/get/$n.tgz"; \
        echo "${p#*:}  $n.tgz" | sha256sum -c -; \
        mkdir "$n"; tar -xzf "$n.tgz" -C "$n" --strip-components=1; \
    done; \
    if [ "${IMAP_FROM}" = php-src ]; then \
        aria2c --conf-path=/usr/local/share/epicmorg/aria2/config/aria2.conf \
            --user-agent="$(shuf -n 1 /usr/local/share/epicmorg/user-agents/user-agents.txt)" \
            -o php.tar.xz "https://www.php.net/distributions/php-${PHP_FULL_VERSION}.tar.xz" \
                "https://github.com/php/web-php-distributions/raw/master/php-${PHP_FULL_VERSION}.tar.xz"; \
        echo "${PHP_SRC_SHA256}  php.tar.xz" | sha256sum -c -; \
        mkdir imap; tar -xJf php.tar.xz -C imap --strip-components=3 "php-${PHP_FULL_VERSION}/ext/imap"; \
    fi; \
    rpath="${PHP_SSL_LIB_DIR}:${EMG_PHP_LDAP_DIR}/lib"; \
    for d in inotify-* smbclient-* imap*; do \
        [ -d "$d" ] || continue; \
        ( cd "$d"; phpize > /dev/null; \
          case "$d" in \
            smbclient-*) cfg="--with-libsmbclient"; libs="-L${EMG_PHP_LDAP_DIR}/lib -Wl,--no-as-needed -lldap -Wl,--as-needed"; extra="" ;; \
            imap*)       cfg="--with-imap=${EMG_NC_CCLIENT_DIR} --with-kerberos --with-imap-ssl=${PHP_SSL_DIR}"; libs=""; extra="-lssl -lcrypto" ;; \
            *)           cfg=""; libs=""; extra="" ;; \
          esac; \
          LIBS="$extra" LDFLAGS="-L${PHP_SSL_LIB_DIR} -Wl,-rpath,${rpath} -Wl,--disable-new-dtags ${libs}" ./configure $cfg > /tmp/cfg.log 2>&1 \
            || { tail -40 /tmp/cfg.log >&2; grep -B2 -A12 'error:' config.log | tail -60 >&2; exit 1; }; \
          make -j"$(nproc)" > /tmp/make.log 2>&1 || { tail -40 /tmp/make.log >&2; exit 1; }; \
          cp modules/*.so /emg-export/ext/ ); \
    done; \
    ls -l /emg-export/ext; \
    for so in /emg-export/ext/*.so; do \
        ! ldd "$so" | grep -q 'not found' || { echo "FATAL: $so: unresolved libraries" >&2; ldd "$so" >&2; exit 1; }; \
        ! readelf -d "$so" | grep -q RUNPATH || { echo "FATAL: $so has RUNPATH" >&2; exit 1; }; \
    done; \
    test -f /emg-export/ext/inotify.so -a -f /emg-export/ext/smbclient.so -a -f /emg-export/ext/imap.so

##################################################################
##################################################################
#                       Final image
##################################################################
##################################################################
FROM ghcr.io/epicmorg/apache2:php8.3
ARG DEBIAN_FRONTEND=noninteractive

LABEL org.opencontainers.image.title="EpicMorg Nextcloud"
LABEL org.opencontainers.image.description="Nextcloud 31 on Debian trixie (Apache + php-fpm 8.3), drop-in for the official nextcloud image, by EpicMorg"
LABEL org.opencontainers.image.source="https://github.com/EpicMorg/docker"
LABEL org.opencontainers.image.licenses="MIT"

# = the official image's ENV (its php.ini / apache config read them)
ENV APACHE_BODY_LIMIT=1073741824
ENV PHP_MEMORY_LIMIT=512M
ENV PHP_OPCACHE_MEMORY_CONSUMPTION=128
ENV PHP_UPLOAD_LIMIT=512M
# php-fpm pool size; the official image is mod_php under mpm_prefork (150 workers)
ENV PHP_FPM_PM=dynamic
ENV PHP_FPM_PM_MAX_CHILDREN=150
ENV PHP_FPM_PM_START_SERVERS=5
ENV PHP_FPM_PM_MIN_SPARE_SERVERS=5
ENV PHP_FPM_PM_MAX_SPARE_SERVERS=10

# entrypoint / cron dependencies of the official image + the tools and
# libraries of our previous nextcloud images (SMB storage, previews, mail)
RUN set -eux; \
    apt-get update; \
    apt-get install -y --no-install-recommends \
        busybox-static \
        bzip2 \
        rsync \
        util-linux \
        libsmbclient0 \
        smbclient \
        ffmpeg \
        imagemagick \
        ghostscript \
        sqlite3 \
        nload \
        nano \
        net-tools \
        iputils-ping; \
    rm -rf /var/lib/apt/lists/*

# Nextcloud, entrypoint, cron, crontab: from the official image
COPY --from=upstream --chown=65534:65534 /usr/src/nextcloud /usr/src/nextcloud
COPY --from=upstream /entrypoint.sh /cron.sh /upgrade.exclude /
COPY --from=upstream /var/spool/cron/crontabs /var/spool/cron/crontabs
COPY --from=upstream /usr/local/etc/php/conf.d /tmp/upstream/php-conf.d
COPY --from=upstream /etc/apache2/conf-available /tmp/upstream/apache-conf
COPY --from=upstream /usr/local/include/php/main/php_version.h /tmp/upstream/php_version.h

# our extensions
COPY --from=ext /emg-export/ext/ /tmp/ext/

COPY usr/local/bin/apache2-foreground /usr/local/bin/apache2-foreground
COPY etc/apache2/conf-available/nextcloud.conf /etc/apache2/conf-available/nextcloud.conf
COPY etc/php-fpm.d/zz-nextcloud.conf /tmp/zz-nextcloud.conf
COPY smb.conf /etc/samba/smb.conf
COPY smb.conf /usr/share/samba/smb.conf

# PHP: the official image's php.ini settings (opcache, apcu, igbinary sessions,
# memory / upload limits), its extensions + ours; the paths it writes to
# (/usr/local/etc/php/conf.d/redis-session.ini) are our one conf.d
RUN set -eux; \
    want="$(sed -n 's/^#define PHP_VERSION "\([0-9]*\.[0-9]*\)\..*/\1/p' /tmp/upstream/php_version.h)"; \
    [ "$want" = "${PHP_VERSION}" ] || { echo "FATAL: docker.io/nextcloud:31 ships PHP $want, this leaf is on ${PHP_VERSION} - rerun bin/python/nextcloud-sync.py" >&2; exit 1; }; \
    extdir="$(php -r 'echo ini_get("extension_dir");')"; \
    cp /tmp/ext/*.so "$extdir/"; \
    php-enmod ldap; \
    php-ext-enable inotify; \
    php-ext-enable smbclient; \
    php-ext-enable imap; \
    for m in ioncube_loader bolt perforce; do \
        ! ls "${PHP_INI_SCAN_DIR}"/*-"$m".ini > /dev/null 2>&1 || php-dismod "$m"; \
    done; \
    for f in /tmp/upstream/php-conf.d/*.ini; do \
        b="$(basename "$f")"; \
        grep -vE '^[[:space:]]*(zend_)?extension[[:space:]]*=' "$f" > "/tmp/$b" || true; \
        if grep -q '[^[:space:]]' "/tmp/$b"; then cp "/tmp/$b" "${PHP_INI_SCAN_DIR}/$b"; fi; \
        rm -f "/tmp/$b"; \
    done; \
    mods="$(php -m | tr 'A-Z' 'a-z')"; \
    for f in /tmp/upstream/php-conf.d/docker-php-ext-*.ini; do \
        m="$(basename "$f" .ini)"; m="${m#docker-php-ext-}"; \
        [ "$m" = opcache ] && continue; \
        echo "$mods" | grep -qx "$m" || { echo "FATAL: the official image loads $m, ours does not" >&2; exit 1; }; \
    done; \
    mkdir -p /usr/local/etc; \
    ln -sfn "${PHP_INI_DIR}" /usr/local/etc/php; \
    test "$(readlink -f /usr/local/etc/php/conf.d)" = "$(readlink -f "${PHP_INI_SCAN_DIR}")"; \
    cp /tmp/zz-nextcloud.conf "${PHP_INI_DIR}/php-fpm.d/zz-nextcloud.conf"; \
    rm -rf /tmp/ext /tmp/zz-nextcloud.conf

# Apache: the official image's remoteip / body limit, AllowOverride All for
# Nextcloud's .htaccess, the modules it uses; APACHE_RUN_USER / _GROUP from
# the environment win (as in the official image); logs to stdout / stderr
RUN set -eux; \
    for c in remoteip apache-limits; do \
        if [ -f "/tmp/upstream/apache-conf/$c.conf" ]; then \
            cp "/tmp/upstream/apache-conf/$c.conf" "/etc/apache2/conf-available/$c.conf"; a2enconf "$c"; \
        fi; \
    done; \
    a2enmod headers rewrite remoteip env dir mime setenvif; \
    a2enconf nextcloud; \
    sed -i -e 's/^export APACHE_RUN_USER=www-data$/: "${APACHE_RUN_USER:=www-data}"; export APACHE_RUN_USER/' \
           -e 's/^export APACHE_RUN_GROUP=www-data$/: "${APACHE_RUN_GROUP:=www-data}"; export APACHE_RUN_GROUP/' /etc/apache2/envvars; \
    grep -q 'APACHE_RUN_USER:=www-data' /etc/apache2/envvars; \
    grep -q 'APACHE_RUN_GROUP:=www-data' /etc/apache2/envvars; \
    for l in access error other_vhosts_access; do \
        [ "$l" = error ] && t=/dev/stderr || t=/dev/stdout; \
        ln -sfT "$t" "/var/log/apache2/$l.log"; \
    done; \
    chmod 0755 /usr/local/bin/apache2-foreground; \
    rm -rf /tmp/upstream

# = the official image: data dir, hook folders, /var/www owned by www-data:root
RUN set -eux; \
    mkdir -p /var/www/html /var/www/data \
             /docker-entrypoint-hooks.d/pre-installation \
             /docker-entrypoint-hooks.d/post-installation \
             /docker-entrypoint-hooks.d/pre-upgrade \
             /docker-entrypoint-hooks.d/post-upgrade \
             /docker-entrypoint-hooks.d/before-starting; \
    chown -R www-data:root /var/www; \
    chmod -R g=u /var/www; \
    test "$(id -u www-data):$(id -g www-data)" = 33:33

##################################################################
#                       Assertions (fatal)
##################################################################
RUN set -eu; \
    echo "--- extensions of ours (the official image's are checked above) ---"; \
    mods="$(php -m | tr 'A-Z' 'a-z')"; \
    for m in smbclient inotify imap ldap fileinfo bz2 intl ftp pdo_sqlite; do \
        echo "$mods" | grep -qx "$m" || { echo "FATAL: php extension $m is not loaded" >&2; exit 1; }; \
    done; \
    echo "$mods" | grep -qx 'zend opcache' || { echo "FATAL: opcache is not loaded" >&2; exit 1; }; \
    ! echo "$mods" | grep -qE '^(ioncube loader|bolt|perforce)$' || { echo "FATAL: ionCube / bolt / perforce still loaded" >&2; exit 1; }; \
    echo "--- one OpenSSL, our libldap in the process ---"; \
    php -r 'smbclient_version(); imap_8bit("x"); ldap_err2str(0); $m = file_get_contents("/proc/self/maps"); preg_match_all("~\S*/lib(ssl|crypto|ldap)\.so[.0-9]*~", $m, $x); echo implode("\n", array_unique($x[0])), "\n";' > /tmp/maps; \
    cat /tmp/maps; \
    [ "$(grep -c 'libssl\.so' /tmp/maps)" = 1 ] || { echo "FATAL: more than one libssl in php" >&2; exit 1; }; \
    grep 'libssl\.so' /tmp/maps | grep -q "^${PHP_SSL_LIB_DIR}/" || { echo "FATAL: libssl is not the line's OpenSSL" >&2; exit 1; }; \
    [ "$(grep -c 'libldap' /tmp/maps)" = 1 ] && grep 'libldap' /tmp/maps | grep -q "^${EMG_PHP_LDAP_DIR}/" \
      || { echo "FATAL: libldap is not (only) the php image's own" >&2; exit 1; }; \
    rm -f /tmp/maps; \
    echo "--- php-fpm pool, apache ---"; \
    php-fpm -tt 2>&1 | grep -qE 'clear_env = no' || { echo "FATAL: php-fpm clears the environment (getenv() in config/*.config.php)" >&2; exit 1; }; \
    php-fpm -t; \
    apachectl configtest; \
    for m in rewrite_module headers_module remoteip_module env_module setenvif_module proxy_fcgi_module; do \
        apachectl -M 2>/dev/null | grep -q "$m" || { echo "FATAL: apache module $m is not enabled" >&2; exit 1; }; \
    done; \
    [ "$(php -r 'require "/usr/src/nextcloud/version.php"; echo $OC_Version[0];')" = "31" ] || { echo "FATAL: not Nextcloud 31" >&2; exit 1; }; \
    for f in /entrypoint.sh /cron.sh /upgrade.exclude /var/spool/cron/crontabs/www-data; do test -e "$f"; done; \
    echo "--- smoke test: install (SQLite), status.php, WebDAV with basic auth, cron ---"; \
    port_free() { ! grep -qi "^ *[0-9]*: [0-9A-F]*:$(printf %04X "$1") " /proc/net/tcp /proc/net/tcp6 2>/dev/null; }; \
    p=0; while [ "$p" = 0 ] || ! port_free "$p"; do p="$(shuf -i 20000-59999 -n 1)"; done; \
    cp /etc/apache2/ports.conf /tmp/ports.conf; \
    printf 'Listen 127.0.0.1:%s\n' "$p" > /etc/apache2/ports.conf; \
    sed -i "s/<VirtualHost \*:80>/<VirtualHost *:$p>/" /etc/apache2/sites-available/localhost.conf; \
    NEXTCLOUD_ADMIN_USER=smoke NEXTCLOUD_ADMIN_PASSWORD=Smoke-Test-Passw0rd SQLITE_DATABASE=smoke \
      /entrypoint.sh apache2 -v > /tmp/install.log 2>&1 || { cat /tmp/install.log >&2; exit 1; }; \
    grep -q 'New nextcloud instance' /tmp/install.log || { echo "FATAL: entrypoint did not initialise" >&2; cat /tmp/install.log >&2; exit 1; }; \
    su -p www-data -s /bin/sh -c 'php /var/www/html/occ status' | grep -q 'installed: true' \
      || { echo "FATAL: Nextcloud is not installed" >&2; cat /tmp/install.log >&2; exit 1; }; \
    su -p www-data -s /bin/sh -c "php /var/www/html/occ config:system:set trusted_domains 1 --value=127.0.0.1:$p" > /dev/null; \
    /usr/bin/supervisord -c /etc/supervisor/supervisord.conf > /tmp/sv.log 2>&1 & \
    for i in $(seq 1 60); do curl -fsS "http://127.0.0.1:$p/status.php" > /tmp/status.json 2>/dev/null && break; sleep 1; done; \
    grep -q '"installed":true' /tmp/status.json || { echo "FATAL: status.php" >&2; cat /tmp/status.json /tmp/sv.log >&2; exit 1; }; \
    code="$(curl -s -o /dev/null -w '%{http_code}' -u smoke:Smoke-Test-Passw0rd -X PROPFIND -H 'Depth: 1' "http://127.0.0.1:$p/remote.php/dav/files/smoke/")"; \
    [ "$code" = 207 ] || { echo "FATAL: WebDAV PROPFIND with basic auth: HTTP $code" >&2; tail -50 /tmp/sv.log >&2; exit 1; }; \
    su -p www-data -s /bin/sh -c 'php -f /var/www/html/cron.php' || { echo "FATAL: cron.php" >&2; exit 1; }; \
    kill "$(cat /run/supervisord.pid)"; for i in $(seq 1 30); do [ -e /run/supervisord.pid ] || break; sleep 1; done; \
    cp /tmp/ports.conf /etc/apache2/ports.conf; \
    sed -i "s/<VirtualHost \*:$p>/<VirtualHost *:80>/" /etc/apache2/sites-available/localhost.conf; \
    grep -q '<VirtualHost \*:80>' /etc/apache2/sites-available/localhost.conf; \
    rm -rf /var/www/html /var/www/data /tmp/*.log /tmp/*.json /tmp/ports.conf /run/php/*; \
    mkdir -p /var/www/html /var/www/data; chown -R www-data:root /var/www; chmod -R g=u /var/www; \
    echo "OK: Nextcloud $(php -r 'require "/usr/src/nextcloud/version.php"; echo $OC_VersionString;') on PHP ${PHP_FULL_VERSION} (fpm)"

HEALTHCHECK NONE
WORKDIR /var/www/html
VOLUME /var/www/html
EXPOSE 80
STOPSIGNAL SIGWINCH
ENTRYPOINT ["/entrypoint.sh"]
CMD ["apache2-foreground"]
