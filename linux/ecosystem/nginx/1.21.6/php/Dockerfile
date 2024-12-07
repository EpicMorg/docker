##################################################################
#                   Set Global ARG to build process
##################################################################
ARG NGINX_VERSION

##################################################################
#                   Start build process
##################################################################
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
ARG MAKE_DIR=${SRC_DIR}/p4php-7.4

ARG P4API_VER=r20.1
ARG P4API_URL=http://filehost.perforce.com/perforce/${P4API_VER}/bin.linux26x86_64/p4api.tgz

ARG P4PHP_VER=r20.1
ARG P4PHP_URL=http://filehost.perforce.com/perforce/${P4PHP_VER}/bin.tools/p4php-php7.tgz

ENV PHP_MODULE_PATH=/usr/lib/php/20190902

##################################################################
#                   Files and folders
##################################################################
RUN mkdir -p ${BUILDS_DIR} ${SRC_DIR} ${EXPORT_DIR} ${MAKE_DIR} ${P4API_DIR} ${P4PHP_DIR}

##################################################################
#                   Installing  PHP7
##################################################################
#installing php repo

#Install base packages
RUN apt-get update && \
    apt-get install -y  --allow-unauthenticated \
      libmemcached-dev \
      smbclient libsmbclient libsmbclient-dev \
      php7.4 \
      php7.4-dev \
      php7.4-fpm \
      php7.4-cli \
      php7.4-cgi

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
    cp ${PHP_MODULE_PATH}/perforce.so ${EXPORT_DIR}


##################################################################
#                   compilling smbclient
##################################################################
RUN pecl install smbclient && \
    cp ${PHP_MODULE_PATH}/smbclient.so ${EXPORT_DIR}

##################################################################
##################################################################
##################################################################

FROM epicmorg/nginx:${NGINX_VERSION}
LABEL maintainer="EpicMorg DevTeam, developer@epicm.org"
ARG DEBIAN_FRONTEND=noninteractive

##################################################################
#                   Installing php fpm for nginx from deb
##################################################################
ENV PHP_MODULE_PATH=/usr/lib/php/20190902
ENV PHP_VER=7.4
ENV PHP_DIR=/etc/php/${PHP_VER}
ARG P4_PHP_INI=${PHP_DIR}/mods-available/perfroce.ini
ARG SMB_PHP_INI=${PHP_DIR}/mods-available/smbclient.ini

##################################################################
#                   Installing  PHP7
##################################################################
#Install base packages
RUN apt-get update && \
    apt-get install -y  --allow-unauthenticated \
      php7.4 \
      php7.4-dev \
      php7.4-fpm \
      php7.4-cli \
      php7.4-cgi \
      php-pear \
      php7.4-gmp \
      php7.4-snmp \
      php7.4-ldap \
      php7.4-mail  \
      php7.4-soap \
      php7.4-mysql \
      php7.4-memcached \
      php7.4-memcache \
      php7.4-igbinary \
      php7.4-interbase \
      php7.4-curl \
      php7.4-gd \
      php7.4-intl \
      php7.4-zip \
      php7.4-bcmath \
      php7.4-imap \
      php7.4-pspell \
      php7.4-sqlite3 \
      php7.4-tidy \
      php7.4-xmlrpc \
      php7.4-xml \
      php7.4-mbstring \
      php7.4-apcu \
      php7.4-common \
      php7.4-json \
      php7.4-readline \
      php7.4-enchant \
      php7.4-ssh2 \
      php7.4-oauth \
      php7.4-gmagick \
      php7.4-gnupg \
      php7.4-redis \
      smbclient libsmbclient \
#      php-smbclient \
      php7.4-yaml \
      php7.4-geoip \
      sendmail && \
    update-alternatives --set php /usr/bin/php7.4 && \
    phpenmod \
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
    ln -sf /etc/ssl/dhparam.pem /etc/php/dhparam.pem && \
    php -v

##################################################################
#                   Installing IOnCube addon
##################################################################
ADD https://downloads.ioncube.com/loader_downloads/ioncube_loaders_lin_x86-64.tar.gz /tmp/ioncube.tar.gz
RUN tar -C /tmp -xvf /tmp/ioncube.tar.gz && \
    cp /tmp/ioncube/ioncube_loader_lin_7.4.so ${PHP_MODULE_PATH} && \
#    echo "zend_extension = ${PHP_MODULE_PATH}/ioncube_loader_lin_7.4.so" >> ${PHP_DIR}/apache2/php.ini && \
    echo "zend_extension = ${PHP_MODULE_PATH}/ioncube_loader_lin_7.4.so" >> ${PHP_DIR}/cgi/php.ini && \
    echo "zend_extension = ${PHP_MODULE_PATH}/ioncube_loader_lin_7.4.so" >> ${PHP_DIR}/cli/php.ini && \
    echo "zend_extension = ${PHP_MODULE_PATH}/ioncube_loader_lin_7.4.so" >> ${PHP_DIR}/fpm/php.ini && \
    php -m && \
    php -v

##################################################################
#                   Installing P4 addon
##################################################################
COPY --from=builder /builds/export/perforce.so ${PHP_MODULE_PATH}
RUN echo "extension=perforce.so" > ${P4_PHP_INI} && \
    ln -sf ${P4_PHP_INI} ${PHP_DIR}/cgi/conf.d/perforce.ini && \
    ln -sf ${P4_PHP_INI} ${PHP_DIR}/cli/conf.d/perforce.ini && \
    ln -sf ${P4_PHP_INI} ${PHP_DIR}/fpm/conf.d/perforce.ini && \
    php -m && \
    php -v

##################################################################
#                   Installing smbclient addon
##################################################################
COPY --from=builder /builds/export/smbclient.so ${PHP_MODULE_PATH}
RUN echo "extension=smbclient.so" > ${SMB_PHP_INI} && \
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

#Final config
VOLUME ["/var/cache/nginx"]
EXPOSE 80 443

CMD ["nginx", "-g", "daemon off;"]
