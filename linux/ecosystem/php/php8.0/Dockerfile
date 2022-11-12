FROM epicmorg/debian:bullseye-develop AS builder
LABEL maintainer="EpicMorg DevTeam, developer@epicm.org"
ARG DEBIAN_FRONTEND=noninteractive

##################################################################
#                   ARGuments
##################################################################
ENV BuildDocker true

ARG BUILDS_DIR=/builds
ARG SRC_DIR=${BUILDS_DIR}/src
ARG EXPORT_DIR=${BUILDS_DIR}/export
ARG P4API_DIR=${SRC_DIR}/p4api
ARG P4PHP_DIR=${SRC_DIR}/p4php
ARG MAKE_DIR=${SRC_DIR}/p4php-${PHP_VER}

ARG P4API_VER=r21.1
ARG P4API_URL=http://filehost.perforce.com/perforce/${P4API_VER}/bin.linux26x86_64/p4api.tgz

ARG P4PHP_VER=r20.2
ARG P4PHP_URL=http://filehost.perforce.com/perforce/${P4PHP_VER}/bin.tools/p4php.tgz

ARG PHP_VER=8.0
ARG PHP_MODULE_VER=20200930
ARG PHP_MODULE_PATH=/usr/lib/php/${PHP_MODULE_VER}

##################################################################
#                   Files and folders
##################################################################
RUN mkdir -p ${BUILDS_DIR} ${SRC_DIR} ${EXPORT_DIR} ${MAKE_DIR} ${P4API_DIR} ${P4PHP_DIR}

##################################################################
#                   Installing  PHP8
##################################################################
RUN wget -O /etc/apt/trusted.gpg.d/php.gpg https://packages.sury.org/php/apt.gpg && \
    sh -c 'echo "deb https://packages.sury.org/php/ $(lsb_release -sc) main" > /etc/apt/sources.list.d/php.list'

#Install base packages
RUN apt-get update && \
    apt-get install -y  --allow-unauthenticated \
      libmemcached-dev \
      smbclient libsmbclient libsmbclient-dev \
      php8.0 \
      php8.0-dev \
      php8.0-fpm \
      php8.0-cli \
      php8.0-cgi

##################################################################
#                   preparing p4src
##################################################################
#RUN wget -qO - ${P4API_URL} | tar -zxv --strip-components=1 -C ${P4API_DIR} && \
#    wget -qO - ${P4API_URL} | tar -zxv --strip-components=1 -C ${MAKE_DIR} && \
#    wget -qO - ${P4PHP_URL} | tar -zxv --strip-components=1 -C ${P4PHP_DIR} && \
#    wget -qO - ${P4PHP_URL} | tar -zxv --strip-components=1 -C ${MAKE_DIR} && \
#    cd ${P4API_DIR} && \
#    ls -las && \
#    cd ${P4PHP_DIR} && \
#    ls -las && \
#    cd ${MAKE_DIR} && \
#    ls -las && \
#    cd ${SRC_DIR} && \
#    ls -las

##################################################################
#                   compilling p4src
##################################################################
#RUN cd ${MAKE_DIR} && \
#    ls -las && \
#    phpize && \
#    ./configure --with-perforce=${P4API_DIR} && \
#    make && \
#    make test && \
#    make install && \
#    cp ${PHP_MODULE_PATH}/perforce.so ${EXPORT_DIR}

##################################################################
#                   compilling smbclient
##################################################################
RUN pecl install smbclient && \
    cp ${PHP_MODULE_PATH}/smbclient.so ${EXPORT_DIR}

##################################################################
##################################################################
##################################################################

FROM epicmorg/debian:bullseye
LABEL maintainer="EpicMorg DevTeam, developer@epicm.org"
ARG DEBIAN_FRONTEND=noninteractive

ARG PHP_MODULE_VER=20200930
ARG PHP_MODULE_PATH=/usr/lib/php/${PHP_MODULE_VER}
ARG PHP_VER=8.0
ARG PHP_DIR=/etc/php/${PHP_VER}
ARG P4_PHP_INI=${PHP_DIR}/mods-available/perfroce.ini
ARG SMB_PHP_INI=${PHP_DIR}/mods-available/smbclient.ini

##################################################################
#                   Installing  PHP8
##################################################################
RUN wget -O /etc/apt/trusted.gpg.d/php.gpg https://packages.sury.org/php/apt.gpg && \
    sh -c 'echo "deb https://packages.sury.org/php/ $(lsb_release -sc) main" > /etc/apt/sources.list.d/php.list'

RUN apt-get update && \
    apt-get install -y  --allow-unauthenticated \
      libmemcached-dev \
      php8.0 \
      php8.0-dev \
      php8.0-fpm \
      php8.0-cli \
      php8.0-cgi \
      php-pear \
      php8.0-gmp \
      php8.0-snmp \
      php8.0-ldap \
      php8.0-mail  \
      php8.0-soap \
      php8.0-mysql \
      php8.0-memcached \
      php8.0-memcache \
      php8.0-igbinary \
      php8.0-interbase \
      php8.0-curl \
      php8.0-gd \
      php8.0-intl \
      php8.0-zip \
      php8.0-bcmath \
      php8.0-imap \
      php8.0-pspell \
      php8.0-sqlite3 \
      php8.0-pgsql \
      php8.0-tidy \
      php8.0-xmlrpc \
      php8.0-xml \
      php8.0-mbstring \
      php8.0-apcu \
      php8.0-common \
#      php8.0-json \
      php8.0-readline \
      php8.0-enchant \
      php8.0-ssh2 \
      php8.0-oauth \
      php8.0-gmagick \
      php8.0-gnupg \
      php8.0-redis \
      smbclient libsmbclient \
      php8.0-yaml \
#      php8.0-geoip \
      sendmail && \
    ln -sf /etc/ssl/dhparam.pem /etc/php/dhparam.pem && \
    update-alternatives --set php /usr/bin/php8.0 && \
    pecl channel-update pecl.php.net && \
    php -m && \
    php -v

##################################################################
#                   Enabling extensions
##################################################################
RUN phpenmod \
      snmp \
      gmp \
      calendar \
      ldap \
      curl \
      exif \
      ftp \
      fileinfo \
      gd \
      geoip \
      gnupg \
      iconv \
      imap \
      json \
      mbstring \
      memcached \
      mysqli \
      mysqlnd \
      oauth \
      pdo_mysql \
      pdo_sqlite \
      phar \
      posix \
      readline \
      redis \
      simplexml \
      sockets \
      sqlite3 \
      ssh2 \
      tokenizer \
      xml \
      xmlreader \
      xmlrpc \
      xmlwriter \
      xsl \
      yaml && \
    php -m && \
    php -v

##################################################################
#                   Installing timezonedb addon
##################################################################
RUN pecl install timezonedb && \
#    echo "extension = ${PHP_MODULE_PATH}/timezonedb.so" >> ${PHP_DIR}/apache2/php.ini && \
    echo "extension = ${PHP_MODULE_PATH}/timezonedb.so" >> ${PHP_DIR}/cgi/php.ini && \
    echo "extension = ${PHP_MODULE_PATH}/timezonedb.so" >> ${PHP_DIR}/cli/php.ini && \
    echo "extension = ${PHP_MODULE_PATH}/timezonedb.so" >> ${PHP_DIR}/fpm/php.ini && \
    php -m && \
    php -v

##################################################################
#                   Installing imagic addon
##################################################################
RUN apt-get update && \
    apt-get install -y  --allow-unauthenticated \
      libmagickwand-dev \
      imagemagick && \
    pecl install imagick && \
#    echo "extension = ${PHP_MODULE_PATH}/imagick.so" >> ${PHP_DIR}/apache2/php.ini && \
    echo "extension = ${PHP_MODULE_PATH}/imagick.so" >> ${PHP_DIR}/cgi/php.ini && \
    echo "extension = ${PHP_MODULE_PATH}/imagick.so" >> ${PHP_DIR}/cli/php.ini && \
    echo "extension = ${PHP_MODULE_PATH}/imagick.so" >> ${PHP_DIR}/fpm/php.ini && \
    php -m && \
    php -v

##################################################################
#                   Installing IOnCube addon
#################################################################
ADD https://downloads.ioncube.com/loader_downloads/ioncube_loaders_lin_x86-64.tar.gz /tmp/ioncube.tar.gz
RUN tar -C /tmp -xvf /tmp/ioncube.tar.gz && \
    cp /tmp/ioncube/ioncube_loader_lin_8.1.so ${PHP_MODULE_PATH} && \
##    echo "zend_extension = ${PHP_MODULE_PATH}/ioncube_loader_lin_8.1.so" >> ${PHP_DIR}/apache2/php.ini && \
    echo "zend_extension = ${PHP_MODULE_PATH}/ioncube_loader_lin_8.1.so" >> ${PHP_DIR}/cgi/php.ini && \
    echo "zend_extension = ${PHP_MODULE_PATH}/ioncube_loader_lin_8.1.so" >> ${PHP_DIR}/cli/php.ini && \
    echo "zend_extension = ${PHP_MODULE_PATH}/ioncube_loader_lin_8.1.so" >> ${PHP_DIR}/fpm/php.ini && \
    php -m && \
    php -v

##################################################################
#                   Installing P4 addon
##################################################################
RUN wget --no-check-certificate -c http://ftp.perforce.com/perforce/r20.2/bin.linux26x86_64/perforce_php80.so --random-wait -P ${PHP_MODULE_PATH}/perforce_php80.so && \
	wget --no-check-certificate -c http://ftp.perforce.com/perforce/r20.2/bin.linux26x86_64/perforce_php80-ssl1.0.2.so --random-wait -P ${PHP_MODULE_PATH}/perforce_php80-ssl1.0.2.so && \
    wget --no-check-certificate -c http://ftp.perforce.com/perforce/r20.2/bin.linux26x86_64/perforce_php80-ssl1.1.1.so --random-wait -P ${PHP_MODULE_PATH}/perforce_php80-ssl1.1.1.so

#COPY --from=builder /builds/export/perforce.so ${PHP_MODULE_PATH}

RUN echo "extension = ${PHP_MODULE_PATH}/perforce_php80-ssl1.1.1.so" > ${P4_PHP_INI} && \
    ln -sf ${P4_PHP_INI} ${PHP_DIR}/cgi/conf.d/perforce.ini && \
    ln -sf ${P4_PHP_INI} ${PHP_DIR}/cli/conf.d/perforce.ini && \
    ln -sf ${P4_PHP_INI} ${PHP_DIR}/fpm/conf.d/perforce.ini && \
    php -m && \
    php -v

##################################################################
#                   Installing smbclient addon
##################################################################
COPY --from=builder /builds/export/smbclient.so ${PHP_MODULE_PATH}
RUN echo "extension = ${PHP_MODULE_PATH}/smbclient.so" > ${SMB_PHP_INI} && \
    ln -sf ${SMB_PHP_INI} ${PHP_DIR}/cgi/conf.d/smbclient.ini && \
    ln -sf ${SMB_PHP_INI} ${PHP_DIR}/cli/conf.d/smbclient.ini && \
    ln -sf ${SMB_PHP_INI} ${PHP_DIR}/fpm/conf.d/smbclient.ini && \
    php -m && \
    php -v

##################################################################
#                   Installing Composer addon
##################################################################
RUN cd /tmp && \
     php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" && \
     php composer-setup.php  --install-dir=/usr/local/bin --filename=composer && \
     rm /tmp/composer-setup.php

##################################################################
#                   cleaninig up
##################################################################
RUN apt clean -y && \
    apt autoclean -y && \
    rm -rfv /var/lib/apt/lists/* && \
    rm -rfv /var/cache/apt/archives/*.deb && \
    rm -rfv /tmp/deb/* && \
    rm -rfv /tmp/ioncube/* && \
    rm -rfv /tmp/composer-setup.php && \
    rm -rfv /tmp/ioncube.tar.gz

