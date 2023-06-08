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
ARG MAKE_DIR=${SRC_DIR}/p4php-7.2

ARG P4API_VER=r20.1
ARG P4API_URL=http://filehost.perforce.com/perforce/${P4API_VER}/bin.linux26x86_64/p4api.tgz

ARG P4PHP_VER=r20.1
ARG P4PHP_URL=http://filehost.perforce.com/perforce/${P4PHP_VER}/bin.tools/p4php-php7.tgz

ARG P4MODULE_PATH=/usr/lib/php/20170718

##################################################################
#                   Files and folders
##################################################################
RUN mkdir -p ${BUILDS_DIR} ${SRC_DIR} ${EXPORT_DIR} ${MAKE_DIR} ${P4API_DIR} ${P4PHP_DIR}

##################################################################
#                   Installing  PHP7
##################################################################
#installing php repo
RUN wget -O /etc/apt/trusted.gpg.d/php.gpg https://packages.sury.org/php/apt.gpg
RUN sh -c 'echo "deb https://packages.sury.org/php/ buster main" > /etc/apt/sources.list.d/php.list'

#Install base packages
RUN apt-get update && \
    apt-get install -y  --allow-unauthenticated \
      libmemcached-dev \
      php7.2 \
      php7.2-dev \
      php7.2-fpm \
      php7.2-cli \
      php7.2-cgi

##################################################################
#                   preparing p4src
##################################################################
RUN wget -qO - ${P4API_URL} | tar -zxv --strip-components=1 -C ${P4API_DIR} && \
    wget -qO - ${P4API_URL} | tar -zxv --strip-components=1 -C ${MAKE_DIR} && \
    wget -qO - ${P4PHP_URL} | tar -zxv --strip-components=1 -C ${P4PHP_DIR} && \
    wget -qO - ${P4PHP_URL} | tar -zxv --strip-components=1 -C ${MAKE_DIR} && \
    cd ${P4API_DIR} && \
    ls -las && \
    cd ${P4PHP_DIR} && \
    ls -las && \
    cd ${MAKE_DIR} && \
    ls -las && \
    cd ${SRC_DIR} && \
    ls -las

##################################################################
#                   compilling p4src
##################################################################
RUN cd ${MAKE_DIR} && \
    ls -las && \
    phpize && \
    ./configure --with-perforce=${P4API_DIR} && \
    make && \
    make test && \
    make install && \
    cp ${P4MODULE_PATH}/perforce.so ${EXPORT_DIR}


##################################################################
##################################################################
##################################################################

FROM epicmorg/debian:bullseye
LABEL maintainer="EpicMorg DevTeam, developer@epicm.org"
ARG DEBIAN_FRONTEND=noninteractive

ARG PHP_MODULE_PATH=/usr/lib/php/20170718
ARG PHP_VER=7.2
ARG PHP_DIR=/etc/php/${PHP_VER}
ARG P4_PHP_INI=${PHP_DIR}/mods-available/perfroce.ini

##################################################################
#                   Installing  PHP7
##################################################################
RUN wget -O /etc/apt/trusted.gpg.d/php.gpg https://packages.sury.org/php/apt.gpg
RUN sh -c 'echo "deb https://packages.sury.org/php/ buster main" > /etc/apt/sources.list.d/php.list'
RUN apt-get update && \
    apt-get install -y  --allow-unauthenticated \
      libmemcached-dev \
      php7.2-ldap \
      php7.2-dev \
      php7.2 \
      php7.2-mail \
      php7.2-mailparse \
      php7.2-soap \
      php7.2-mysql \
      php7.2-curl \
      php7.2-gd \
      php7.2-intl \
      php7.2-zip \
      php7.2-bcmath \
      php7.2-fpm \
      php7.2-imap \
      php7.2-pspell \
      php7.2-recode \
      php7.2-sqlite3 \
      php7.2-pgsql \
      php7.2-tidy \
      php7.2-xmlrpc \
      php7.2-xml \
      php7.2-mbstring \
      php7.2-gettext \
      php7.2-apcu \
      php7.2-cli \
      php7.2-common \
      php7.2-cgi \
      php7.2-json \
      php7.2-readline \
      php7.2-enchant \
      php7.2-ssh2 \
      php7.2-oauth \
      php7.2-gmagick \
      php7.2-redis \
      php7.2-smbclient \
      php7.2-yaml \
      php7.2-geoip \
      sendmail && \
    ln -sf /etc/ssl/dhparam.pem /etc/php/dhparam.pem && \
    update-alternatives --set php /usr/bin/php7.2 && \
    pecl channel-update pecl.php.net && \
    php -m && \
    php -v

##################################################################
#                   Enabling extensions
##################################################################
RUN phpenmod \
      calendar \
      ldap \
      curl \
      exif \
      ftp \
      fileinfo \
      gd \
      geoip \
      iconv \
      imap \
      json \
      mbstring \
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
##################################################################
ADD https://downloads.ioncube.com/loader_downloads/ioncube_loaders_lin_x86-64.tar.gz /tmp/ioncube.tar.gz
RUN tar -C /tmp -xvf /tmp/ioncube.tar.gz && \
    cp /tmp/ioncube/ioncube_loader_lin_7.2.so ${PHP_MODULE_PATH} && \
#    echo "zend_extension = ${PHP_MODULE_PATH}/ioncube_loader_lin_7.2.so" >> ${PHP_DIR}/apache2/php.ini && \
    echo "zend_extension = ${PHP_MODULE_PATH}/ioncube_loader_lin_7.2.so" >> ${PHP_DIR}/cgi/php.ini && \
    echo "zend_extension = ${PHP_MODULE_PATH}/ioncube_loader_lin_7.2.so" >> ${PHP_DIR}/cli/php.ini && \
    echo "zend_extension = ${PHP_MODULE_PATH}/ioncube_loader_lin_7.2.so" >> ${PHP_DIR}/fpm/php.ini && \
    php -m && \
    php -v

##################################################################
#                   Installing Bolt addon
##################################################################
#ADD https://phpbolt.com/wp-content/uploads/2023/03/phpBolt-extension-1.0.4.zip /tmp/phpBolt.zip
COPY usr/lib/php/20170718/phpBolt-extension-1.0.4-php72.so ${PHP_MODULE_PATH}/phpBolt-extension-1.0.4-php72.so
#RUN echo "extension = ${PHP_MODULE_PATH}/phpBolt-extension-1.0.4-php72.so" >> ${PHP_DIR}/apache2/php.ini && \
RUN echo "extension = ${PHP_MODULE_PATH}/phpBolt-extension-1.0.4-php72.so" >> ${PHP_DIR}/cgi/php.ini && \
    echo "extension = ${PHP_MODULE_PATH}/phpBolt-extension-1.0.4-php72.so" >> ${PHP_DIR}/cli/php.ini && \
    echo "extension = ${PHP_MODULE_PATH}/phpBolt-extension-1.0.4-php72.so" >> ${PHP_DIR}/fpm/php.ini && \
    php -m && \
    php -v

##################################################################
#                   Installing P4 addon
##################################################################
COPY --from=builder /builds/export/perforce.so ${PHP_MODULE_PATH}
RUN echo "extensio n= ${PHP_MODULE_PATH}/perforce.so" > ${P4_PHP_INI} && \
#    ln -sf ${P4_PHP_INI} ${PHP_DIR}/apache2/conf.d/perforce.ini && \
    ln -sf ${P4_PHP_INI} ${PHP_DIR}/cgi/conf.d/perforce.ini && \
    ln -sf ${P4_PHP_INI} ${PHP_DIR}/cli/conf.d/perforce.ini && \
    ln -sf ${P4_PHP_INI} ${PHP_DIR}/fpm/conf.d/perforce.ini && \
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

