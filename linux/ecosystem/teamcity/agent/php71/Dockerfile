FROM docker.io/epicmorg/debian:bookworm-develop AS builder
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
ARG MAKE_DIR=${SRC_DIR}/p4php-7.1

ARG P4API_VER=r20.1
ARG P4API_URL=http://filehost.perforce.com/perforce/${P4API_VER}/bin.linux26x86_64/p4api.tgz

ARG P4PHP_VER=r20.1
ARG P4PHP_URL=http://filehost.perforce.com/perforce/${P4PHP_VER}/bin.tools/p4php-php7.tgz

ARG P4MODULE_PATH=/usr/lib/php/20160303

##################################################################
#                   Files and folders
##################################################################
RUN mkdir -p ${BUILDS_DIR} ${SRC_DIR} ${EXPORT_DIR} ${MAKE_DIR} ${P4API_DIR} ${P4PHP_DIR}

##################################################################
#                   Installing  PHP7
##################################################################
#installing PHP repo
RUN wget -O /etc/apt/trusted.gpg.d/php.gpg https://packages.sury.org/php/apt.gpg
RUN sh -c 'echo "deb [trusted=yes] https://packages.sury.org/php/ $(lsb_release -sc) main" > /etc/apt/sources.list.d/php.list'

#Install base packages
RUN apt-get update && \
    apt-get install -y  --allow-unauthenticated \
      libmemcached-dev \
#      php-pear \
      php7.1 \
      php7.1-common \
      php7.1-dev \
      php7.1-fpm \
      php7.1-cli \
      php7.1-xml \
      php7.1-cgi && \
    update-alternatives --set php /usr/bin/php7.1 && \
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
    cp ${P4MODULE_PATH}/perforce.so ${EXPORT_DIR}

##################################################################
##################################################################
##################################################################

FROM docker.io/epicmorg/teamcity-agent:minimal
LABEL maintainer="EpicMorg DevTeam, developer@epicm.org"
ARG DEBIAN_FRONTEND=noninteractive

ENV PHP_VER=7.1
ENV PHP_MODULE_PATH=/usr/lib/php/20160303
ENV PHP_DIR=/etc/php/${PHP_VER}
ARG P4_PHP_INI=${PHP_DIR}/mods-available/perfroce.ini
ARG CAS_PHP_INI=${PHP_DIR}/mods-available/cassandra.ini

##################################################################
#                   Installing  PHP7
##################################################################
RUN wget -O /etc/apt/trusted.gpg.d/php.gpg https://packages.sury.org/php/apt.gpg
RUN sh -c 'echo "deb [trusted=yes] https://packages.sury.org/php/ $(lsb_release -sc) main" > /etc/apt/sources.list.d/php.list'

RUN apt-get update && \
    apt-get install -y  --allow-unauthenticated \
      libmemcached-dev \
      libgmp-dev \
#      php-pear \
      php7.1 \
      php7.1-cli \
      php7.1-common \
      php7.1-dev \
      php7.1-amqp \
      php7.1-apcu-bc \
      php7.1-apcu \
      php7.1-bcmath \
      php7.1-bz2 \
      php7.1-cgi \
      php7.1-curl \
      php7.1-dba \
      php7.1-decimal \
      php7.1-dio \
      php7.1-ds \
      php7.1-enchant \
      php7.1-excimer \
      php7.1-fpm \
      php7.1-gd \
      php7.1-gearman \
      php7.1-geoip \
#      php7.1-gmagick \
      php7.1-gmp \
      php7.1-gnupg \
      php7.1-grpc \
      php7.1-http \
      php7.1-igbinary \
      php7.1-imagick \
      php7.1-imap \
      php7.1-inotify \
      php7.1-interbase \
      php7.1-intl \
      php7.1-json \
      php7.1-ldap \
      php7.1-libvirt-php \
      php7.1-lua \
      php7.1-lz4 \
      php7.1-mailparse \
      php7.1-mbstring \
      php7.1-mcrypt \
      php7.1-memcache \
      php7.1-memcached \
      php7.1-mongodb \
      php7.1-msgpack \
      php7.1-mysql \
      php7.1-oauth \
      php7.1-odbc \
      php7.1-opcache \
      php7.1-pcov \
      php7.1-pgsql \
      php7.1-phpdbg \
      php7.1-pinba \
#      php7.1-pq \
      php7.1-propro \
      php7.1-protobuf \
      php7.1-ps \
      php7.1-pspell \
      php7.1-radius \
      php7.1-raphf \
      php7.1-rdkafka \
      php7.1-readline \
      php7.1-recode \
      php7.1-redis \
      php7.1-rrd \
      php7.1-smbclient \
      php7.1-snmp \
      php7.1-soap \
      php7.1-sodium \
      php7.1-solr \
      php7.1-sqlite3 \
      php7.1-ssh2 \
      php7.1-stomp \
      php7.1-sybase \
      php7.1-tideways \
      php7.1-tidy \
      php7.1-uopz \
      php7.1-uploadprogress \
      php7.1-uuid \
      php7.1-vips \
      php7.1-xdebug \
      php7.1-xhprof \
      php7.1-xml \
      php7.1-xmlrpc \
      php7.1-xsl \
#      php7.1-yac \
      php7.1-yaml \
      php7.1-zip \
      php7.1-zmq \
      php7.1-zstd \
      smbclient \
      libsmbclient \
      sendmail && \
    ln -sfv /etc/ssl/dhparam.pem /etc/php/dhparam.pem && \
    apt-get remove -y \
      php5.6* \
      php7.0*  \
#      php7.1*  \
      php7.2*  \
      php7.3*  \
      php7.4*  \
      php8.0*  \
      php8.1*  \
      php8.2*  \
      php8.3*  \
      php8.4*  && \
    rm -rfv /etc/php/{5.6,7.0,7.2,7.3,7.4,8.0,8.1,8.2,8.3,8.4} && \
    update-alternatives --set php /usr/bin/php7.1 && \
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
RUN pecl install cassandra && \
    echo "extension = ${PHP_MODULE_PATH}/cassandra.so" > ${CAS_PHP_INI} && \
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
COPY usr/lib/php/20160303/phpBolt-extension-1.0.5-php71.so ${PHP_MODULE_PATH}/phpBolt-extension-1.0.5-php71.so
#RUN echo "extension = ${PHP_MODULE_PATH}/phpBolt-extension-1.0.5-php71.so" >> ${PHP_DIR}/apache2/php.ini && \
RUN echo "extension = ${PHP_MODULE_PATH}/phpBolt-extension-1.0.5-php71.so" >> ${PHP_DIR}/cgi/php.ini && \
    echo "extension = ${PHP_MODULE_PATH}/phpBolt-extension-1.0.5-php71.so" >> ${PHP_DIR}/cli/php.ini && \
    echo "extension = ${PHP_MODULE_PATH}/phpBolt-extension-1.0.5-php71.so" >> ${PHP_DIR}/fpm/php.ini && \
    php -m && \
    php -v

##################################################################
#                   Installing IOnCube addon
##################################################################
ADD https://downloads.ioncube.com/loader_downloads/ioncube_loaders_lin_x86-64.tar.gz /tmp/ioncube.tar.gz
RUN tar -C /tmp -xvf /tmp/ioncube.tar.gz && \
    cp /tmp/ioncube/ioncube_loader_lin_7.1.so ${PHP_MODULE_PATH} && \
#    echo "zend_extension = ${PHP_MODULE_PATH}/ioncube_loader_lin_7.1.so" >> ${PHP_DIR}/apache2/php.ini && \
    echo "zend_extension = ${PHP_MODULE_PATH}/ioncube_loader_lin_7.1.so" >> ${PHP_DIR}/cgi/php.ini && \
    echo "zend_extension = ${PHP_MODULE_PATH}/ioncube_loader_lin_7.1.so" >> ${PHP_DIR}/cli/php.ini && \
    echo "zend_extension = ${PHP_MODULE_PATH}/ioncube_loader_lin_7.1.so" >> ${PHP_DIR}/fpm/php.ini && \
    php -m && \
    php -v

##################################################################
#                   Installing P4 addon
##################################################################
COPY --from=builder /builds/export/perforce.so ${PHP_MODULE_PATH}
RUN echo "extension= ${PHP_MODULE_PATH}/perforce.so" > ${P4_PHP_INI} && \
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
WORKDIR ${AGENT_DIST}

RUN updatedb
