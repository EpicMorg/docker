FROM epicmorg/debian:bookworm-develop AS builder
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
ARG MAKE_DIR=${SRC_DIR}/p4php-7.3

ARG P4API_VER=r20.1
ARG P4API_URL=http://filehost.perforce.com/perforce/${P4API_VER}/bin.linux26x86_64/p4api.tgz

ARG P4PHP_VER=r20.1
ARG P4PHP_URL=http://filehost.perforce.com/perforce/${P4PHP_VER}/bin.tools/p4php-php7.tgz

ARG P4MODULE_PATH=/usr/lib/php/20180731

##################################################################
#                   Files and folders
##################################################################
RUN mkdir -p ${BUILDS_DIR} ${SRC_DIR} ${EXPORT_DIR} ${MAKE_DIR} ${P4API_DIR} ${P4PHP_DIR}

##################################################################
#                   Installing  PHP7
##################################################################
RUN wget -O /etc/apt/trusted.gpg.d/php.gpg https://vault.center/mirror/apt/packages.sury.org/php/apt.gpg
RUN sh -c 'echo "deb https://vault.center/mirror/apt/packages.sury.org/php/ $(lsb_release -sc) main" > /etc/apt/sources.list.d/php.list'

#Install base packages
RUN apt-get update && \
    apt-get install -y  --allow-unauthenticated \
      libmemcached-dev \
#      php-pear \
      php7.3 \
      php7.3-common \
      php7.3-dev \
      php7.3-fpm \
      php7.3-cli \
      php7.3-xml \
      php7.3-cgi && \
    update-alternatives --set php /usr/bin/php7.3 && \
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

FROM epicmorg/debian:bookworm
LABEL maintainer="EpicMorg DevTeam, developer@epicm.org"
ARG DEBIAN_FRONTEND=noninteractive

ENV PHP_MODULE_PATH=/usr/lib/php/20180731
ENV PHP_VER=7.3
ENV PHP_DIR=/etc/php/${PHP_VER}
ARG P4_PHP_INI=${PHP_DIR}/mods-available/perfroce.ini
ARG CAS_PHP_INI=${PHP_DIR}/mods-available/cassandra.ini

##################################################################
#                   Installing  PHP7
##################################################################
RUN wget -O /etc/apt/trusted.gpg.d/php.gpg https://vault.center/mirror/apt/packages.sury.org/php/apt.gpg
RUN sh -c 'echo "deb https://vault.center/mirror/apt/packages.sury.org/php/ $(lsb_release -sc) main" > /etc/apt/sources.list.d/php.list'

RUN apt-get update && \
    apt-get install -y  --allow-unauthenticated \
      libmemcached-dev \
      libgmp-dev \
#      php-pear \
      php7.3 \
      php7.3-cli \
      php7.3-common \
      php7.3-dev \
      php7.3-amqp \
      php7.3-apcu-bc \
      php7.3-apcu \
      php7.3-ast \
      php7.3-bcmath \
      php7.3-bz2 \
      php7.3-cgi \
      php7.3-curl \
      php7.3-dba \
      php7.3-decimal \
      php7.3-dio \
      php7.3-ds \
      php7.3-enchant \
      php7.3-excimer \
      php7.3-fpm \
      php7.3-gd \
      php7.3-gearman \
      php7.3-geoip \
#      php7.3-gmagick \
      php7.3-gmp \
      php7.3-gnupg \
      php7.3-grpc \
      php7.3-http \
      php7.3-igbinary \
      php7.3-imagick \
      php7.3-imap \
      php7.3-inotify \
      php7.3-interbase \
      php7.3-intl \
      php7.3-json \
      php7.3-ldap \
      php7.3-libvirt-php \
      php7.3-lua \
      php7.3-lz4 \
      php7.3-mailparse \
      php7.3-maxminddb \
      php7.3-mbstring \
      php7.3-mcrypt \
      php7.3-memcache \
      php7.3-memcached \
      php7.3-mongodb \
      php7.3-msgpack \
      php7.3-mysql \
      php7.3-oauth \
      php7.3-odbc \
      php7.3-opcache \
      php7.3-pcov \
      php7.3-pgsql \
      php7.3-phalcon4 \
      php7.3-phpdbg \
      php7.3-pinba \
      php7.3-pq \
      php7.3-propro \
      php7.3-protobuf \
      php7.3-ps \
      php7.3-pspell \
      php7.3-psr \
      php7.3-radius \
      php7.3-raphf \
      php7.3-rdkafka \
      php7.3-readline \
      php7.3-recode \
      php7.3-redis \
      php7.3-rrd \
      php7.3-smbclient \
      php7.3-snmp \
      php7.3-soap \
      php7.3-solr \
      php7.3-sqlite3 \
      php7.3-ssh2 \
      php7.3-stomp \
      php7.3-sybase \
      php7.3-tideways \
      php7.3-tidy \
      php7.3-uopz \
      php7.3-uploadprogress \
      php7.3-uuid \
      php7.3-vips \
      php7.3-xdebug \
      php7.3-xhprof \
      php7.3-xml \
      php7.3-xmlrpc \
      php7.3-xsl \
#      php7.3-yac \
      php7.3-yaml \
      php7.3-zip \
      php7.3-zmq \
      php7.3-zstd \
      smbclient libsmbclient \
      sendmail && \
    ln -sf /etc/ssl/dhparam.pem /etc/php/dhparam.pem && \
    update-alternatives --set php /usr/bin/php7.3 && \
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
      gettext \
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
COPY usr/lib/php/20180731/cassandra.so ${PHP_MODULE_PATH}/cassandra.so
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
#                   Installing IOnCube addon
##################################################################
ADD https://downloads.ioncube.com/loader_downloads/ioncube_loaders_lin_x86-64.tar.gz /tmp/ioncube.tar.gz
RUN tar -C /tmp -xvf /tmp/ioncube.tar.gz && \
    cp /tmp/ioncube/ioncube_loader_lin_7.3.so ${PHP_MODULE_PATH} && \
#    echo "zend_extension =  ${PHP_MODULE_PATH}/ioncube_loader_lin_7.3.so" >> ${PHP_DIR}/apache2/php.ini && \
    echo "zend_extension =  ${PHP_MODULE_PATH}/ioncube_loader_lin_7.3.so" >> ${PHP_DIR}/cgi/php.ini && \
    echo "zend_extension =  ${PHP_MODULE_PATH}/ioncube_loader_lin_7.3.so" >> ${PHP_DIR}/cli/php.ini && \
    echo "zend_extension =  ${PHP_MODULE_PATH}/ioncube_loader_lin_7.3.so" >> ${PHP_DIR}/fpm/php.ini && \
    php -m && \
    php -v

##################################################################
#                   Installing Bolt addon
##################################################################
#ADD https://phpbolt.com/wp-content/uploads/2023/03/phpBolt-extension-1.0.4.zip /tmp/phpBolt.zip
COPY usr/lib/php/20180731/phpBolt-extension-1.0.4-php73.so ${PHP_MODULE_PATH}/phpBolt-extension-1.0.4-php73.so
#RUN echo "extension = ${PHP_MODULE_PATH}/phpBolt-extension-1.0.4-php73.so" >> ${PHP_DIR}/apache2/php.ini && \
RUN echo "extension = ${PHP_MODULE_PATH}/phpBolt-extension-1.0.4-php73.so" >> ${PHP_DIR}/cgi/php.ini && \
    echo "extension = ${PHP_MODULE_PATH}/phpBolt-extension-1.0.4-php73.so" >> ${PHP_DIR}/cli/php.ini && \
    echo "extension = ${PHP_MODULE_PATH}/phpBolt-extension-1.0.4-php73.so" >> ${PHP_DIR}/fpm/php.ini && \
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
    rm -rfv /tmp/*

RUN updatedb