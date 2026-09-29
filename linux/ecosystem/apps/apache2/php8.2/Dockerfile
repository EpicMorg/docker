FROM docker.io/epicmorg/php:8.2
LABEL org.opencontainers.image.title="EpicMorg Apache2 + PHP (fpm)"
LABEL org.opencontainers.image.description="Apache2 + PHP 8.2 (fpm) by EpicMorg"
LABEL maintainer="EpicMorg DevTeam, developer@epicm.org"
ARG DEBIAN_FRONTEND=noninteractive

##################################################################
#                   Installing Apache2
##################################################################
# No mod_php: PHP runs as php-fpm (unix socket), Apache talks to it through
# mod_proxy_fcgi, supervisor runs both. Debian php* stays apt-pinned out by
# the php base image (/etc/apt/preferences.d/, "Package: php*" at -1).
RUN apt-get update && \
    apt-get install -y \
      apache2 \
      apache2-utils \
      libapache2-mod-security2 \
      libapache2-mod-removeip \
      libapache2-mod-mime-xattr \
      libapache2-mod-fcgid \
      libapache2-mod-encoding \
      libapache2-mod-xsendfile \
      supervisor && \
    a2dismod \
      mpm_prefork \
      mpm_worker && \
    a2enmod \
      mpm_event \
      proxy \
      proxy_fcgi \
      ssl  \
      rewrite \
      ldap \
      heartmonitor \
      auth_basic \
      authnz_ldap \
      headers \
      heartbeat \
      slotmem_shm \
      lua \
      mime \
      status \
      xml2enc \
#      xforward \
      remoteip \
      filter \
      dav \
      dav_fs \
      alias && \
    ln -sf /etc/ssl/dhparam.pem /etc/apache2/dhparam.pem && \
    php-dismod \
      xdebug \
      xcache \
      xhprof \
      tideways \
      pcov \
      swoole \
      grpc \
      uopz && \
    php -m && \
    php -v && \
    apt-get clean -y && \
    apt-get autoclean -y && \
    rm -rfv /var/lib/apt/lists/* && \
    rm -rfv /var/cache/apt/archives/*.deb && \
    rm -rfv /root/tmp/* && \
    rm -rfv /tmp/*

##################################################################
#                   Apache2 Fixes
##################################################################
RUN rm -fv /etc/apache2/sites-enabled/000-default.conf
RUN rm -fv /etc/apache2/apache2.conf
COPY etc/supervisor/ /etc/supervisor/
COPY etc/apache2/    /etc/apache2/
COPY etc/php-fpm.d/zz-apache.conf ${PHP_INI_DIR}/php-fpm.d/zz-apache.conf
COPY usr/bin/docker-entrypoint.sh /usr/bin/docker-entrypoint.sh

##################################################################
#                   LDAP Fix
##################################################################
RUN mkdir -p /etc/ldap && \
    touch /etc/ldap/ldap.conf && \
    echo "TLS_REQCERT never" >> /etc/ldap/ldap.conf

# Add image configuration and scripts
RUN set -eux; \
    mkdir -p /run/php /var/log/supervisor /var/www/html; \
    chown -Rf www-data:www-data /run/php /var/www; \
    chmod 755 /run/php; \
    chmod +x /usr/bin/docker-entrypoint.sh; \
    a2enconf php-fpm ; \
    a2ensite localhost; \
    apachectl configtest

##################################################################
#                   Assertions
##################################################################
RUN set -eu; \
    echo "--- no mod_php ---"; \
    if dpkg-query -W -f='${Package} ${Status}\n' 'libapache2-mod-php*' 2>/dev/null | grep -q ' installed$'; then \
      echo "FATAL: libapache2-mod-php* is installed" >&2; exit 1; fi; \
    if ls /etc/apache2/mods-enabled/ | grep -qi '^php'; then \
      echo "FATAL: a mod_php module is enabled" >&2; ls -l /etc/apache2/mods-enabled/ >&2; exit 1; fi; \
    grep -rqsE "^Package: *php\*" /etc/apt/preferences.d/ \
      || { echo "FATAL: apt pin for Debian php* is missing" >&2; exit 1; }; \
    echo "--- php-fpm pool ---"; \
    php-fpm -tt 2>&1 | grep -E "listen = /run/php/php-fpm.sock" \
      || { echo "FATAL: php-fpm does not listen on /run/php/php-fpm.sock" >&2; php-fpm -tt >&2; exit 1; }; \
    php-fpm -tt 2>&1 | grep -E "ping.path = /php-fpm-ping" \
      || { echo "FATAL: php-fpm ping.path is not /php-fpm-ping (HEALTHCHECK needs it)" >&2; exit 1; }; \
    php-fpm -t; \
    echo "--- apache2 ---"; \
    apachectl -M 2>/dev/null | grep -q 'proxy_fcgi_module' \
      || { echo "FATAL: proxy_fcgi is not enabled" >&2; exit 1; }; \
    apachectl -v; \
    supervisord -v; \
    echo "OK: Apache2 + PHP ${PHP_FULL_VERSION} (fpm)"

##################################################################
#                   Runtime
##################################################################
# /php-fpm-ping is answered by php-fpm through Apache (conf-enabled/php-fpm.conf,
# local only), so one probe covers both.
HEALTHCHECK --interval=30s --timeout=3s --start-period=10s \
        CMD curl -fsS http://127.0.0.1/php-fpm-ping || exit 1

#Final config
#VOLUME ["/var/www", "/var/log/apache2", "/var/run/apache2", "/var/log/supervisor"]
WORKDIR /var/www/
EXPOSE 80 443

CMD ["/usr/bin/supervisord", "-n", "-c", "/etc/supervisor/supervisord.conf"]
