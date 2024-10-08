FROM epicmorg/php:php8.0
LABEL maintainer="EpicMorg DevTeam, developer@epicm.org"
ARG DEBIAN_FRONTEND=noninteractive

ARG PHP_MODULE_VER=20200930
ARG PHP_MODULE_PATH=/usr/lib/php/${PHP_MODULE_VER}
ARG PHP_VER=8.0
ARG PHP_DIR=/etc/php/${PHP_VER}
ARG P4_PHP_INI=${PHP_DIR}/mods-available/perfroce.ini
ARG SMB_PHP_INI=${PHP_DIR}/mods-available/smbclient.ini
ARG CAS_PHP_INI=${PHP_DIR}/mods-available/cassandra.ini

##################################################################
#                   Installing Apache2
##################################################################
#installing apache2 repo
RUN wget -O /etc/apt/trusted.gpg.d/apache2.gpg https://packages.sury.org/apache2/apt.gpg
RUN sh -c 'echo "deb https://packages.sury.org/apache2/ $(lsb_release -sc) main" > /etc/apt/sources.list.d/apache2.list'

#Install base packages
RUN apt-get update && \
    apt-get install -y  --allow-unauthenticated \
      apache2 \
      apache2-utils \
      libapache2-mod-php8.0 \
#      libapache2-mod-webauth \
      libapache2-mod-xforward \
      libapache2-mod-security2 && \
    a2enmod \
      php8.0 \
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
RUN echo "TLS_REQCERT never" >> /etc/ldap/ldap.conf

##############################################################################
# Cassandra PHP Drivers Install
##############################################################################
RUN ln -sf ${CAS_PHP_INI} ${PHP_DIR}/apache2/conf.d/cassandra.ini  && \
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
#                   Installing Bolt addon
##################################################################
RUN echo "extension = ${PHP_MODULE_PATH}/phpBolt-extension-1.0.4-php80.so" >> ${PHP_DIR}/apache2/php.ini

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
RUN apt clean -y && \
    apt autoclean -y && \
    rm -rfv /var/lib/apt/lists/* && \
    rm -rfv /var/cache/apt/archives/*.deb && \
    rm -rfv /tmp/*

#healthcheck. good practice
HEALTHCHECK --interval=2m --timeout=3s CMD curl -f http://localhost:80/ || exit 1

# Add image configuration and scripts
COPY docker-entrypoint.sh /usr/bin/docker-entrypoint.sh
RUN chmod 755 /usr/bin/docker-entrypoint.sh

RUN updatedb
RUN chown -Rf www-data:www-data /var/www

#Final config
VOLUME ["/var/www"]
WORKDIR /var/www/
EXPOSE 80 443

ENTRYPOINT ["tini", "-s", "--", "docker-entrypoint.sh"]
CMD ["docker-entrypoint.sh"]
