FROM hub.epicm.org/epicmorg/debian:bookworm-develop AS builder
LABEL maintainer="EpicMorg DevTeam, developer@epicm.org"
ARG DEBIAN_FRONTEND=noninteractive

##################################################################
#                   ARGuments
##################################################################


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
###################################################################installing PHP repo
RUN wget -O /etc/apt/trusted.gpg.d/php.gpg https://packages.sury.su/php/apt.gpg
RUN sh -c 'echo "deb [trusted=yes] https://packages.sury.su/php/ $(lsb_release -sc) main" > /etc/apt/sources.list.d/php.list'

RUN apt-get update && \
    apt-get install -y  --allow-unauthenticated \
      libmemcached-dev \
      smbclient libsmbclient libsmbclient-dev \
#      php-pear \
      php7.4 \
      php7.4-common \
      php7.4-dev \
      php7.4-fpm \
      php7.4-cli \
      php7.4-xml \
      php7.4-cgi && \
    update-alternatives --set php /usr/bin/php7.4 && \
#    pear clear-cache && \
    pear update-channels && \
#    pear upgrade && \
    pecl channel-update pecl.php.net

RUN echo "=============================================" && \
    echo php -m $(php -m) && \
    echo php -v $(php -v) && \
    echo pear version $(pear version) && \
    echo pear list $(pear list) && \
    echo "============================================="

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
#RUN pecl install smbclient && \
#   cp ${PHP_MODULE_PATH}/smbclient.so ${EXPORT_DIR}

##################################################################
##################################################################
##################################################################

FROM hub.epicm.org/epicmorg/gitlab-runner:minimal
LABEL maintainer="EpicMorg DevTeam, developer@epicm.org"
ARG DEBIAN_FRONTEND=noninteractive

ENV PHP_MODULE_PATH=/usr/lib/php/20190902
ENV PHP_VER=7.4
ENV PHP_DIR=/etc/php/${PHP_VER}
ARG P4_PHP_INI=${PHP_DIR}/mods-available/perfroce.ini
ARG SMB_PHP_INI=${PHP_DIR}/mods-available/smbclient.ini
ARG CAS_PHP_INI=${PHP_DIR}/mods-available/cassandra.ini

##################################################################
#                   Installing  PHP7
##################################################################
RUN wget -O /etc/apt/trusted.gpg.d/php.gpg https://packages.sury.su/php/apt.gpg
RUN sh -c 'echo "deb [trusted=yes] https://packages.sury.su/php/ $(lsb_release -sc) main" > /etc/apt/sources.list.d/php.list'

RUN apt-get update && \
    apt-get install -y  --allow-unauthenticated \
      libmemcached-dev \
      libgmp-dev \
#      php-pear \
      php7.4 \
      php7.4-cli \
      php7.4-common \
      php7.4-dev \
      php7.4-amqp \
      php7.4-apcu-bc \
      php7.4-apcu \
      php7.4-ast \
      php7.4-bcmath \
      php7.4-bz2 \
      php7.4-cgi \
      php7.4-curl \
      php7.4-dba \
      php7.4-decimal \
      php7.4-dio \
      php7.4-ds \
      php7.4-enchant \
      php7.4-excimer \
      php7.4-fpm \
      php7.4-gd \
      php7.4-gearman \
      php7.4-geoip \
#      php7.4-gmagick \
      php7.4-gmp \
      php7.4-gnupg \
      php7.4-grpc \
      php7.4-http \
      php7.4-igbinary \
      php7.4-imagick \
      php7.4-imap \
      php7.4-inotify \
      php7.4-interbase \
      php7.4-intl \
      php7.4-json \
      php7.4-ldap \
      php7.4-libvirt-php \
      php7.4-lua \
      php7.4-lz4 \
      php7.4-mailparse \
      php7.4-maxminddb \
      php7.4-mbstring \
      php7.4-mcrypt \
      php7.4-memcache \
      php7.4-memcached \
      php7.4-mongodb \
      php7.4-msgpack \
      php7.4-mysql \
      php7.4-oauth \
      php7.4-odbc \
      php7.4-opcache \
      php7.4-pcov \
      php7.4-pgsql \
      php7.4-phalcon4 \
#      php7.4-phalcon5 \
      php7.4-phpdbg \
      php7.4-pinba \
      php7.4-pq \
      php7.4-propro \
      php7.4-protobuf \
      php7.4-ps \
      php7.4-pspell \
      php7.4-psr \
      php7.4-radius \
      php7.4-raphf \
      php7.4-rdkafka \
      php7.4-readline \
      php7.4-redis \
      php7.4-rrd \
      php7.4-smbclient \
      php7.4-snmp \
      php7.4-soap \
      php7.4-solr \
      php7.4-sqlite3 \
      php7.4-ssh2 \
      php7.4-stomp \
      php7.4-sybase \
      php7.4-tideways \
      php7.4-tidy \
      php7.4-uopz \
      php7.4-uploadprogress \
      php7.4-uuid \
      php7.4-vips \
      php7.4-xdebug \
      php7.4-xhprof \
      php7.4-xml \
      php7.4-xmlrpc \
      php7.4-xsl \
#      php7.4-yac \
      php7.4-yaml \
      php7.4-zip \
      php7.4-zmq \
      php7.4-zstd \
      smbclient \
      libsmbclient \
      sendmail && \
    ln -sfv /etc/ssl/dhparam.pem /etc/php/dhparam.pem && \
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
    update-alternatives --set php /usr/bin/php7.4 && \
#    pear clear-cache && \
    pear update-channels && \
#    pear upgrade && \
    pecl channel-update pecl.php.net

RUN echo "=============================================" && \
    echo php -m $(php -m) && \
    echo php -v $(php -v) && \
    echo pear version $(pear version) && \
    echo pear list $(pear list) && \
    echo "============================================="

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
    phpdismod \
      xdebug \
      xcache \
      xhprof \
      tideways \
      pcov \
      swoole \
      grpc \
      uopz && \
    php -m && \
    php -v

##############################################################################
# Cassandra CPP Support Install
##############################################################################
COPY addons/multiarch-support_2.28_amd64.deb /tmp/cassandra-php-driver/multiarch-support_2.28_amd64.deb
COPY addons/libssl1.1_1.1.1_amd64.deb /tmp/cassandra-php-driver/libssl1.1_1.1.1_amd64.deb
RUN wget -c --random-wait --user-agent="Mozilla/5.0 (Windows NT 6.1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/41.0.2228.0 Safari/537.36" --directory-prefix=/tmp/cassandra-php-driver \ 
    https://downloads.datastax.com/cpp-driver/ubuntu/18.04/dependencies/libuv/v1.35.0/libuv1_1.35.0-1_amd64.deb \
    https://downloads.datastax.com/cpp-driver/ubuntu/18.04/dependencies/libuv/v1.35.0/libuv1-dev_1.35.0-1_amd64.deb \
    https://downloads.datastax.com/cpp-driver/ubuntu/18.04/dependencies/libuv/v1.35.0/libuv1-dbg_1.35.0-1_amd64.deb \
    https://downloads.datastax.com/cpp-driver/ubuntu/18.04/cassandra/v2.16.0/cassandra-cpp-driver-dbg_2.16.0-1_amd64.deb \
    https://downloads.datastax.com/cpp-driver/ubuntu/18.04/cassandra/v2.16.0/cassandra-cpp-driver-dev_2.16.0-1_amd64.deb \
    https://downloads.datastax.com/cpp-driver/ubuntu/18.04/cassandra/v2.16.0/cassandra-cpp-driver_2.16.0-1_amd64.deb

RUN cd /tmp/cassandra-php-driver && \
    dpkg -i ./libssl1.1_1.1.1_amd64.deb && \
    dpkg -i ./multiarch-support_2.28_amd64.deb && \
    dpkg -i ./libuv1_1.35.0-1_amd64.deb && \
    dpkg -i ./libuv1-dev_1.35.0-1_amd64.deb && \
    dpkg -i ./libuv1-dbg_1.35.0-1_amd64.deb && \
    dpkg -i ./cassandra-cpp-driver_2.16.0-1_amd64.deb && \
    dpkg -i ./cassandra-cpp-driver-dev_2.16.0-1_amd64.deb && \
    dpkg -i ./cassandra-cpp-driver-dbg_2.16.0-1_amd64.deb

##############################################################################
# Cassandra PHP Drivers Install
##############################################################################
#RUN pecl install cassandra && \
COPY usr/lib/php/20190902/cassandra.so ${PHP_MODULE_PATH}/cassandra.so
RUN     echo "extension = ${PHP_MODULE_PATH}/cassandra.so" > ${CAS_PHP_INI} && \
    ln -sf ${CAS_PHP_INI} ${PHP_DIR}/cgi/conf.d/cassandra.ini && \
    ln -sf ${CAS_PHP_INI} ${PHP_DIR}/cli/conf.d/cassandra.ini && \
    ln -sf ${CAS_PHP_INI} ${PHP_DIR}/fpm/conf.d/cassandra.ini && \
#    ln -sf ${CAS_PHP_INI} ${PHP_DIR}/apache2/conf.d/cassandra.ini  && \
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
#                   Installing Bolt addon
##################################################################
#ADD https://phpbolt.com/wp-content/uploads/2023/03/phpBolt-extension-1.0.5.zip /tmp/phpBolt.zip
COPY usr/lib/php/20190902/phpBolt-extension-1.0.5-php74.so ${PHP_MODULE_PATH}/phpBolt-extension-1.0.5-php74.so
#RUN echo "extension = ${PHP_MODULE_PATH}/phpBolt-extension-1.0.5-php74.so" >> ${PHP_DIR}/apache2/php.ini && \
RUN echo "extension = ${PHP_MODULE_PATH}/phpBolt-extension-1.0.5-php74.so" >> ${PHP_DIR}/cgi/php.ini && \
    echo "extension = ${PHP_MODULE_PATH}/phpBolt-extension-1.0.5-php74.so" >> ${PHP_DIR}/cli/php.ini && \
    echo "extension = ${PHP_MODULE_PATH}/phpBolt-extension-1.0.5-php74.so" >> ${PHP_DIR}/fpm/php.ini && \
    php -m && \
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
RUN echo "extension = ${PHP_MODULE_PATH}/perforce.so" > ${P4_PHP_INI} && \
    ln -sf ${P4_PHP_INI} ${PHP_DIR}/cgi/conf.d/perforce.ini && \
    ln -sf ${P4_PHP_INI} ${PHP_DIR}/cli/conf.d/perforce.ini && \
    ln -sf ${P4_PHP_INI} ${PHP_DIR}/fpm/conf.d/perforce.ini && \
    php -m && \
    php -v

##################################################################
#                   Installing smbclient addon
##################################################################
#COPY --from=builder /builds/export/smbclient.so ${PHP_MODULE_PATH}
#RUN echo "extension = ${PHP_MODULE_PATH}/smbclient.so" > ${SMB_PHP_INI} && \
#    ln -sf ${SMB_PHP_INI} ${PHP_DIR}/cgi/conf.d/smbclient.ini && \
#    ln -sf ${SMB_PHP_INI} ${PHP_DIR}/cli/conf.d/smbclient.ini && \
#    ln -sf ${SMB_PHP_INI} ${PHP_DIR}/fpm/conf.d/smbclient.ini && \
#    php -m && \
#    php -v

##################################################################
#                   Installing Composer addon
##################################################################
RUN cd /tmp && \
     php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" && \
     php composer-setup.php  --install-dir=/usr/local/bin --filename=composer && \
     rm /tmp/composer-setup.php

##################################################################
#                  Cleanup
##################################################################
RUN echo "clean up" && \
    apt-get clean -y && \
    apt-get autoclean -y && \
    rm -rfv /var/lib/apt/lists/* && \
    rm -rfv /var/cache/apt/archives/*.deb && \
    rm -rfv /tmp/*

##################################################################
#                   final config
##################################################################
RUN updatedb
