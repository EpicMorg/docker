FROM docker.io/epicmorg/php:8.5
LABEL org.opencontainers.image.title="EpicMorg Apache2 + PHP (fpm)"
LABEL org.opencontainers.image.description="Apache2 + PHP (fpm) by EpicMorg"
LABEL maintainer="EpicMorg DevTeam, developer@epicm.org"
ARG DEBIAN_FRONTEND=noninteractive

##################################################################
#                   Installing Apache2
##################################################################
#Install base packages
RUN apt-get update && \
    apt-get install -y  --allow-unauthenticated \
      locate \
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
    apt-get remove -y \
      php* && \
    rm -rfv /etc/php/{5.3,5.4,5.5,5.6,7.0,7.1,7.2,7.3,7.4,8.0,8.1,8.2,8.3,8.4} && \
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
COPY etc/php/        /etc/php/
COPY usr/bin/docker-entrypoint.sh /usr/bin/docker-entrypoint.sh

##################################################################
#                   LDAP Fix
##################################################################
RUN mkdir -p /etc/ldap && \
    touch /etc/ldap/ldap.conf && \
    echo "TLS_REQCERT never" >> /etc/ldap/ldap.conf

##############################################################################
# Cassandra PHP Drivers Install
##############################################################################
#RUN ln -sf ${CAS_PHP_INI} ${PHP_DIR}/apache2/conf.d/cassandra.ini  && \
#    php -m && \
#    php -v

#healthcheck. good practice
HEALTHCHECK --interval=2m --timeout=3s CMD curl -f http://localhost:80/ || exit 1

# Add image configuration and scripts
RUN set -eux; \
    mkdir -p /run/php /var/log/supervisor /var/www/html; \
    chown -Rf www-data:www-data /run/php /var/www; \
    chmod 755 /run/php; \
    chmod +x /usr/bin/docker-entrypoint.sh; \
    rm -rfv /etc/php/${PHP_VERSION}/php-fpm.d/www.conf; \
    a2enconf php-fpm ; \
    a2ensite localhost; \
    apachectl configtest

#Final config
VOLUME ["/var/www", "/var/log/apache2", "/var/run/apache2", "/var/log/supervisor"]
WORKDIR /var/www/
EXPOSE 80 443

CMD ["/usr/bin/supervisord", "-n", "-c", "/etc/supervisor/supervisord.conf"]
