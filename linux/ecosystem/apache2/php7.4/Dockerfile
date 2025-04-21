FROM quay.io/epicmorg/debian:bookworm-php7.4
LABEL maintainer="EpicMorg DevTeam, developer@epicm.org"
ARG DEBIAN_FRONTEND=noninteractive

ENV PHP_MODULE_PATH=/usr/lib/php/20190902
ENV PHP_VER=7.4
ENV PHP_DIR=/etc/php/${PHP_VER}
ARG P4_PHP_INI=${PHP_DIR}/mods-available/perfroce.ini
ARG SMB_PHP_INI=${PHP_DIR}/mods-available/smbclient.ini
ARG CAS_PHP_INI=${PHP_DIR}/mods-available/cassandra.ini

##################################################################
#                   Installing Apache2
##################################################################
#installing apache2 repo
RUN wget -O /etc/apt/trusted.gpg.d/apache2.gpg https://packages.sury.su/apache2/apt.gpg
RUN sh -c 'echo "deb [trusted=yes] https://packages.sury.su/apache2/ $(lsb_release -sc) main" > /etc/apt/sources.list.d/apache2.list'

#Install base packages
RUN apt-get update && \
    apt-get install -y  --allow-unauthenticated \
      locate \
      apache2 \
      apache2-utils \
      libapache2-mod-php7.4 \
#      libapache2-mod-webauth \
      libapache2-mod-xforward \
      libapache2-mod-security2 && \
    a2enmod \
      php7.4 \
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
      xforward \
      remoteip \
      filter \
      dav \
      dav_fs \
      alias && \
    ln -sf /etc/ssl/dhparam.pem /etc/apache2/dhparam.pem && \
    phpdismod \
      xdebug \
      xcache \
      xhprof \
      tideways \
      pcov \
      swoole \
      grpc \
      uopz && \
    apt-get remove -y \
      php5.6* \
      php7.0*  \
      php7.1*  \
      php7.2*  \
      php7.3*  \
#      php7.4*  \
      php8.0*  \
      php8.1*  \
      php8.2*  \
      php8.3*  \
      php8.4*  && \
    rm -rfv /etc/php/{5.6,7.0,7.1,7.2,7.3,8.0,8.1,8.2,8.3,8.4} && \
    php -m && \
    php -v

##################################################################
#                   Apache2 Fixes
##################################################################
RUN rm -fv /etc/apache2/sites-enabled/000-default.conf
RUN rm -fv /etc/apache2/apache2.conf
COPY etc/apache2/sites-enabled/localhost.conf /etc/apache2/sites-enabled/localhost.conf
COPY etc/apache2/apache2.conf /etc/apache2/apache2.conf

##################################################################
#                   LDAP Fix
##################################################################
RUN mkdir -p /etc/ldap && \
    touch /etc/ldap/ldap.conf && \
    echo "TLS_REQCERT never" >> /etc/ldap/ldap.conf

##############################################################################
# Cassandra PHP Drivers Install
##############################################################################
RUN ln -sf ${CAS_PHP_INI} ${PHP_DIR}/apache2/conf.d/cassandra.ini  && \
    php -m && \
    php -v

##################################################################
#                   Installing Bolt addon
##################################################################
RUN echo "extension = ${PHP_MODULE_PATH}/phpBolt-extension-1.0.5-php74.so" >> ${PHP_DIR}/apache2/php.ini

##################################################################
#                   Installing IOnCube addon
##################################################################
RUN echo "zend_extension = ${PHP_MODULE_PATH}/ioncube_loader_lin_7.4.so" >> ${PHP_DIR}/apache2/php.ini && \
    php -m && \
    php -v

##################################################################
#                   Installing timezonedb addon
##################################################################
RUN echo "extension = ${PHP_MODULE_PATH}/timezonedb.so" >> ${PHP_DIR}/apache2/php.ini && \
    php -m && \
    php -v

##################################################################
#                   Installing imagic addon
##################################################################
RUN echo "extension = ${PHP_MODULE_PATH}/imagick.so" >> ${PHP_DIR}/apache2/php.ini && \
    php -m && \
    php -v

##################################################################
#                   Installing P4 addon
##################################################################
RUN ln -sf ${P4_PHP_INI} ${PHP_DIR}/apache2/conf.d/perforce.ini && \
    php -m && \
    php -v

##################################################################
#                   Installing smbclient addon
##################################################################
RUN ln -sf ${SMB_PHP_INI} ${PHP_DIR}/apache2/conf.d/smbclient.ini  && \
    php -m && \
    php -v

##################################################################
#                   cleaninig up
##################################################################
RUN apt-get clean -y && \
    apt-get autoclean -y && \
    rm -rfv /var/lib/apt/lists/* && \
    rm -rfv /var/cache/apt/archives/*.deb && \
    rm -rfv /root/tmp/* && \
    rm -rfv /tmp/*

#healthcheck. good practice
HEALTHCHECK --interval=2m --timeout=3s CMD curl -f http://localhost:80/ || exit 1

# Add image configuration and scripts
COPY docker-entrypoint.sh /usr/bin/docker-entrypoint.sh
RUN chmod 755 /usr/bin/docker-entrypoint.sh

RUN updatedb
RUN chown -Rf www-data:www-data /var/www

#Final config
VOLUME ["/var/www", "/var/log/apache2", "/var/run/apache2"]
WORKDIR /var/www/
EXPOSE 80 443

ENTRYPOINT ["tini", "-s", "--", "docker-entrypoint.sh"]
CMD ["docker-entrypoint.sh"]
