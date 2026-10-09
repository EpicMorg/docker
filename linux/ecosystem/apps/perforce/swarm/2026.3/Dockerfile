##################################################################
#        p4 CLI of the matching Helix release
##################################################################
FROM ghcr.io/epicmorg/perforce:r26.1 AS p4

##################################################################
#        Support files from Perforce's Ubuntu package
##################################################################
# The filehost tarball (used below, like the p4 binaries) is the Swarm app only.
# The Apache vhost, cron job, logrotate rules, the WebSocket gateway wrapper and
# the extension config template ship only in the helix-swarm deb of the same
# build: unpacked here (not installed - its Ubuntu PHP dependencies are not
# wanted), only those files are taken.
FROM ghcr.io/epicmorg/debian:trixie AS deb
ARG SWARM_DEB_URL=http://package.perforce.com/apt/ubuntu/pool/release/h/helix-swarm/helix-swarm_2026.3-3030911~noble_amd64.deb
# SHA256 of that file in http://package.perforce.com/apt/ubuntu/dists/noble/release/binary-amd64/Packages.gz
ARG SWARM_DEB_SHA256=95934322c08865aced74c868060e3b628d21a42694a78a6357ed93176588311d
RUN set -eux; \
    wget -q -O /tmp/swarm.deb "${SWARM_DEB_URL}"; \
    echo "${SWARM_DEB_SHA256}  /tmp/swarm.deb" | sha256sum -c -; \
    dpkg-deb -x /tmp/swarm.deb /tmp/deb; \
    mkdir -p /out/etc/cron.d /out/etc/logrotate.d /out/opt/perforce/etc /out/opt/perforce/swarm/sbin; \
    cp /tmp/deb/etc/cron.d/helix-swarm /out/etc/cron.d/; \
    cp /tmp/deb/etc/logrotate.d/helix-swarm /out/etc/logrotate.d/; \
    cp /tmp/deb/opt/perforce/etc/perforce-swarm-site.conf /tmp/deb/opt/perforce/etc/helix-swarm.global.config /out/opt/perforce/etc/; \
    cp /tmp/deb/opt/perforce/swarm/sbin/start-websocket.sh /tmp/deb/opt/perforce/swarm/sbin/swarm-extctl.sh /out/opt/perforce/swarm/sbin/; \
    rm -rf /tmp/swarm.deb /tmp/deb

##################################################################
##################################################################
#                       Final image
##################################################################
##################################################################
FROM ghcr.io/epicmorg/apache2:php8.4
ARG DEBIAN_FRONTEND=noninteractive

LABEL org.opencontainers.image.title="EpicMorg Swarm"
LABEL org.opencontainers.image.description="Perforce Helix Swarm (P4 Code Review) on Apache2 + PHP-FPM, Debian trixie, drop-in for perforce/helix-swarm, by EpicMorg"
LABEL org.opencontainers.image.source="https://github.com/EpicMorg/docker"
LABEL org.opencontainers.image.licenses="MIT"

ENV SWARM_VERSION=2026.3
ENV SWARM_BUILD=3030911
ENV SWARM_RELEASE=r26.3
ARG SWARM_TGZ_URL=https://filehost.perforce.com/perforce/${SWARM_RELEASE}/bin.multiarch/swarm.tgz
# https://filehost.perforce.com/perforce/r26.3/bin.multiarch/SHA256SUMS
ARG SWARM_TGZ_SHA256=01875873e5a6846e8e06d4048cba7fd0dada6c162141491f78d950bff4cb1d29

# Same variables and defaults as perforce/helix-swarm (see README)
ENV P4D_PORT=ssl:perforce:1666
ENV P4D_SUPER=super
ENV P4D_SUPER_PASSWD=
ENV P4D_GRACE=30
ENV SWARM_USER=swarm
ENV SWARM_PASSWD=
ENV SWARM_MAILHOST=localhost
ENV SWARM_HOST=helix-swarm
ENV SWARM_REDIS=helix-redis
ENV SWARM_REDIS_PORT=7379
ENV SWARM_REDIS_PASSWD=
ENV SWARM_REDIS_NAMESPACE=
ENV SWARM_FORCE_EXT=n
ENV SWARM_WS_ENABLED=n
ENV SWARM_WS_ALLOWED_ORIGINS=

##################################################################
#                   Runtime dependencies
##################################################################
# = the helix-swarm deb's Depends (minus the Ubuntu PHP / mod_php ones: PHP is
# this image's own, with gd, mbstring, xml, xsl, redis, imagick, igbinary built
# in) + helix-swarm-optional (LibreOffice for office document previews).
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
      at \
      cron \
      jq \
      libio-socket-ssl-perl \
      libjson-perl \
      libxslt1.1 \
      logrotate \
      perl \
      procps \
      unzip \
      uuid \
      wget \
      libreoffice-calc \
      libreoffice-draw \
      libreoffice-impress \
      libreoffice-writer && \
    apt-get clean -y && \
    rm -rf /var/lib/apt/lists/* /var/cache/apt/archives/*.deb /tmp/*

##################################################################
#                   Swarm (filehost tarball)
##################################################################
# Users as the deb's preinst creates them: perforce (owner of /opt/perforce),
# swarm-cron (runs p4-bin/scripts/swarm-cron.sh from /etc/cron.d/helix-swarm).
# The bundled Node for the WebSocket gateway sits under p4-bin/bin.multiarch/
# ws-staging in the tarball; the deb moves it to websocket-server/node-binaries,
# where start-websocket.sh looks - linked the same way here.
COPY --from=p4 /usr/bin/p4 /opt/perforce/bin/p4
RUN set -eux; \
    addgroup --system perforce; \
    adduser --system --ingroup perforce --home /opt/perforce --no-create-home --shell /bin/bash --gecos "Perforce Admin" perforce; \
    addgroup --system swarm-cron; \
    adduser --system --ingroup swarm-cron --home /opt/perforce --no-create-home --shell /bin/bash --gecos "Swarm Cron" swarm-cron; \
    ln -sf /opt/perforce/bin/p4 /usr/bin/p4; \
    mkdir -p /opt/perforce/swarm /opt/perforce/etc; \
    wget -q -O /tmp/swarm.tgz "${SWARM_TGZ_URL}"; \
    echo "${SWARM_TGZ_SHA256}  /tmp/swarm.tgz" | sha256sum -c -; \
    tar -xzf /tmp/swarm.tgz -C /opt/perforce/swarm --strip-components=1 --no-same-owner; \
    rm -f /tmp/swarm.tgz; \
    ws=/opt/perforce/swarm/websocket-server/node-binaries/linux-x64; \
    if [ ! -x "$ws/bin/node" ]; then \
      mkdir -p "$ws"; \
      ln -sfn /opt/perforce/swarm/p4-bin/bin.multiarch/ws-staging/node-binaries/linux-x64/bin "$ws/bin"; \
      ln -sfn /opt/perforce/swarm/p4-bin/bin.multiarch/ws-staging/node-binaries/linux-x64/lib "$ws/lib"; \
    fi; \
    ln -sf /opt/perforce/swarm/p4-bin/bin.linux26x86_64/redis-cli-swarm /usr/bin/redis-cli-swarm; \
    printf 'SWARM_VERSION=%s\nSWARM_BUILD=%s\nIMAGE=epicmorg/swarm\n' "${SWARM_VERSION}" "${SWARM_BUILD}" > /opt/perforce/etc/Docker-Version; \
    mkdir -p /opt/perforce/swarm/data; \
    chown perforce:perforce /opt/perforce; \
    chown -R www-data:www-data /opt/perforce/swarm/data

COPY --from=deb /out/ /
# cron's PAM stack requires pam_loginuid, which fails in a container (no audit
# loginuid): every job is then dropped silently - Swarm's workers never start.
RUN set -eux; \
    ln -sf /opt/perforce/swarm/sbin/swarm-extctl.sh /usr/bin/swarm-extctl; \
    sed -i -E 's/^session[[:space:]]+required[[:space:]]+pam_loginuid\.so/session    optional     pam_loginuid.so/' /etc/pam.d/cron; \
    ! grep -qE '^session[[:space:]]+required[[:space:]]+pam_loginuid' /etc/pam.d/cron

##################################################################
#                   PHP: Swarm's own P4PHP build
##################################################################
# Swarm ships P4PHP builds of its own release (p4-bin/bin.linux26x86_64); the
# deb's postinst points perforce.ini at the one matching PHP and OpenSSL - same
# here, instead of the php image's (older) P4PHP. -ssl3: this PHP links the
# baked OpenSSL 3.5, the extension then shares that libssl (one SONAME).
# memory_limit: as Perforce's image sets it for Apache's PHP.
RUN set -eux; \
    api="$(php -r 'echo PHP_MAJOR_VERSION . PHP_MINOR_VERSION;')"; \
    so="/opt/perforce/swarm/p4-bin/bin.linux26x86_64/perforce-php${api}-ssl3.so"; \
    test -s "$so"; \
    # conf.d/20-perforce.ini is a link to mods-available/perforce.ini (php-ext-enable)
    printf '; P4PHP Extension (for Helix Swarm)\nextension=%s\n' "$so" > "${PHP_INI_DIR}/mods-available/perforce.ini"; \
    test -L "${PHP_INI_DIR}/conf.d/20-perforce.ini"; \
    printf '%s\n' \
      '; Helix Swarm (epicmorg/swarm): memory_limit as Perforce image sets it for' \
      '; Apache, the rest = the php_value lines of public/.htaccess (see below)' \
      'memory_limit = 2048M' \
      'session.auto_start = 0' \
      'upload_max_filesize = 8M' \
      'post_max_size = 16M' \
      > "${PHP_INI_DIR}/conf.d/30-swarm.ini"; \
    # public/.htaccess routes to index.php only inside <IfModule mod_php.c> and
    # sends everything to nophp.html otherwise; php_value is mod_php-only (a 500
    # without it). PHP here is php-fpm via mod_proxy_fcgi: switch the guards,
    # the php_value settings went to 30-swarm.ini above.
    ht=/opt/perforce/swarm/public/.htaccess; \
    sed -i -e 's/<IfModule \(!\?\)mod_php\.c>/<IfModule \1mod_proxy_fcgi.c>/' -e '/^[[:space:]]*php_value[[:space:]]/d' "$ht"; \
    ! grep -qE 'mod_php\.c|php_value' "$ht"; \
    grep -q '<IfModule mod_proxy_fcgi.c>' "$ht"

##################################################################
#                   Apache: the Swarm vhost
##################################################################
# The deb's vhost with ServerName from ${SWARM_HOST} (Apache reads it from the
# environment at start). Bind-mount your own perforce-swarm-site.conf over it
# (e.g. with an SSL vhost) or keep vhosts in data/docker/sites-available, as
# Perforce's image does. The parent's default `localhost` site is disabled:
# Swarm is the only (default) vhost.
COPY etc/supervisor/ /etc/supervisor/
COPY etc/apache2/ /etc/apache2/
COPY usr/local/bin/swarm-docker-setup.sh /usr/local/bin/swarm-docker-setup.sh
RUN set -eux; \
    sed -e 's#APACHE_LOG_DIR#/var/log/apache2#g' -e 's#REPLACE_WITH_SERVER_NAME#${SWARM_HOST}#' \
        /opt/perforce/etc/perforce-swarm-site.conf > /etc/apache2/sites-available/perforce-swarm-site.conf; \
    a2dissite localhost; \
    a2enmod rewrite headers expires proxy proxy_http proxy_wstunnel remoteip ssl; \
    a2ensite perforce-swarm-site; \
    a2enconf swarm-php-fpm; \
    mkdir -p /opt/perforce/swarm/data/docker; \
    chmod 0755 /usr/local/bin/swarm-docker-setup.sh /opt/perforce/swarm/sbin/*.sh; \
    apachectl configtest

##################################################################
#                       Assertions (fatal)
##################################################################
RUN set -eu; \
    grep -q "^RELEASE = $(echo "${SWARM_VERSION}" | tr . ' ') ;" /opt/perforce/swarm/Version \
      || { echo "FATAL: Swarm is not ${SWARM_VERSION}" >&2; cat /opt/perforce/swarm/Version >&2; exit 1; }; \
    grep -q "^PATCHLEVEL = ${SWARM_BUILD} ;" /opt/perforce/swarm/Version \
      || { echo "FATAL: Swarm build is not ${SWARM_BUILD}" >&2; exit 1; }; \
    p4 -V | grep -q '^Rev. P4/' || { echo "FATAL: no p4" >&2; exit 1; }; \
    echo "--- P4PHP: Swarm's, one OpenSSL ---"; \
    php -m | grep -qx perforce || { echo "FATAL: perforce extension not loaded" >&2; exit 1; }; \
    [ "$(grep -Rhs '^extension *= *.*perforce' "${PHP_INI_DIR}/conf.d" | wc -l)" = 1 ] || { echo "FATAL: perforce extension enabled more than once" >&2; exit 1; }; \
    php -r 'echo file_get_contents("/proc/self/maps");' | grep -q '/opt/perforce/swarm/p4-bin/bin.linux26x86_64/perforce-php' \
      || { echo "FATAL: the loaded P4PHP is not Swarm's" >&2; exit 1; }; \
    n="$(php -r '$m = file_get_contents("/proc/self/maps"); preg_match_all("#\S*/libssl\.so[^\s]*#", $m, $r); echo count(array_unique($r[0]));')"; \
    [ "$n" = 1 ] || { echo "FATAL: ${n} libssl in a PHP process with P4PHP" >&2; exit 1; }; \
    php -r '$m = file_get_contents("/proc/self/maps"); preg_match("#\S*/libssl\.so\S*#", $m, $r); echo $r[0], PHP_EOL;' | grep -q "^${EMG_LOCAL_BASE_DIR}/openssl/" \
      || { echo "FATAL: PHP + P4PHP do not use the baked OpenSSL" >&2; exit 1; }; \
    for e in redis gd mbstring xml xsl imagick igbinary; do php -m | grep -qix "$e" || { echo "FATAL: php extension $e missing" >&2; exit 1; }; done; \
    php -r 'echo ini_get("memory_limit"), PHP_EOL;' | grep -qx 2048M || { echo "FATAL: memory_limit" >&2; exit 1; }; \
    echo "--- no mod_php, Swarm vhost is the only site ---"; \
    ! ls /etc/apache2/mods-enabled/ | grep -qi '^php' || { echo "FATAL: mod_php enabled" >&2; exit 1; }; \
    [ "$(ls /etc/apache2/sites-enabled/)" = "perforce-swarm-site.conf" ] || { echo "FATAL: unexpected sites" >&2; ls -l /etc/apache2/sites-enabled/ >&2; exit 1; }; \
    apachectl -M 2>/dev/null | grep -q rewrite_module || { echo "FATAL: mod_rewrite" >&2; exit 1; }; \
    echo "--- Swarm boots in PHP ---"; \
    test -x /opt/perforce/swarm/websocket-server/node-binaries/linux-x64/bin/node || { echo "FATAL: bundled node missing" >&2; exit 1; }; \
    /opt/perforce/swarm/websocket-server/node-binaries/linux-x64/bin/node --version; \
    test -s /etc/cron.d/helix-swarm && test -s /etc/logrotate.d/helix-swarm; \
    id swarm-cron >/dev/null && id perforce >/dev/null; \
    php -l /opt/perforce/swarm/public/index.php >/dev/null; \
    bash -n /usr/local/bin/swarm-docker-setup.sh; \
    php -r 'echo P4::identify(), PHP_EOL;'; \
    echo "OK: Swarm ${SWARM_VERSION}.${SWARM_BUILD}"

VOLUME ["/opt/perforce/swarm/data"]
WORKDIR /opt/perforce/swarm
EXPOSE 80 443

# Healthcheck: the parent's php-fpm ping through Apache (conf-enabled/php-fpm.conf, local only)
ENTRYPOINT ["tini", "--", "/usr/local/bin/swarm-docker-setup.sh"]
CMD ["/usr/bin/supervisord", "-n", "-c", "/etc/supervisor/supervisord.conf"]
