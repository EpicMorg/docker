FROM epicmorg/debian:bullseye
LABEL maintainer="EpicMorg DevTeam, developer@epicm.org"
ARG DEBIAN_FRONTEND=noninteractive

ARG PHP_MODULE_VER=20210902
ARG PHP_MODULE_PATH=/usr/lib/php/${PHP_MODULE_VER}
ARG PHP_VER=8.1
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
      php8.1 \
      php8.1-dev \
      php8.1-fpm \
      php8.1-cli \
      php8.1-cgi \
      php-pear \
      php8.1-gmp \
      php8.1-snmp \
      php8.1-ldap \
      php8.1-mail  \
      php8.1-soap \
      php8.1-mysql \
      php8.1-memcached \
      php8.1-memcache \
      php8.1-igbinary \
      php8.1-interbase \
      php8.1-curl \
      php8.1-gd \
      php8.1-intl \
      php8.1-zip \
      php8.1-bcmath \
      php8.1-imap \
      php8.1-pspell \
      php8.1-sqlite3 \
      php8.1-pgsql \
      php8.1-tidy \
      php8.1-xmlrpc \
      php8.1-xml \
      php8.1-mbstring \
      php8.1-apcu \
      php8.1-common \
#      php8.1-json \
      php8.1-readline \
      php8.1-enchant \
      php8.1-ssh2 \
      php8.1-oauth \
      php8.1-gmagick \
      php8.1-gnupg \
      php8.1-redis \
      php8.1-smbclient \
      smbclient libsmbclient \
      php8.1-yaml \
#      php8.1-geoip \
      sendmail && \
    ln -sf /etc/ssl/dhparam.pem /etc/php/dhparam.pem && \
    update-alternatives --set php /usr/bin/php8.1 && \
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
