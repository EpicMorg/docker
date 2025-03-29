FROM epicmorg/debian:bookworm
LABEL maintainer="EpicMorg DevTeam, developer@epicm.org"
ARG DEBIAN_FRONTEND=noninteractive

ENV PHP_VER=8.2
ENV PHP_MODULE_VER=20220829
ENV PHP_MODULE_PATH=/usr/lib/php/${PHP_MODULE_VER}
ENV PHP_DIR=/etc/php/${PHP_VER}
ARG P4_PHP_INI=${PHP_DIR}/mods-available/perfroce.ini
ARG SMB_PHP_INI=${PHP_DIR}/mods-available/smbclient.ini
ARG CAS_PHP_INI=${PHP_DIR}/mods-available/cassandra.ini

##################################################################
#                   Installing  PHP8
##################################################################
RUN wget -O /etc/apt/trusted.gpg.d/php.gpg https://packages.sury.su/php/apt.gpg
RUN sh -c 'echo "deb [trusted=yes] https://packages.sury.su/php/ $(lsb_release -sc) main" > /etc/apt/sources.list.d/php.list'

RUN apt-get update && \
    apt-get install -y  --allow-unauthenticated \
      libmemcached-dev \
      libgmp-dev \
#      php-pear \
      php8.2 \
      php8.2-cli \
      php8.2-common \
      php8.2-dev \
      php8.2-amqp \
      php8.2-apcu \
      php8.2-ast \
      php8.2-bcmath \
      php8.2-bz2 \
      php8.2-cgi \
      php8.2-curl \
      php8.2-dba \
      php8.2-decimal \
      php8.2-dio \
      php8.2-ds \
      php8.2-enchant \
      php8.2-excimer \
      php8.2-fpm \
      php8.2-gd \
      php8.2-gearman \
#      php8.2-gmagick \
      php8.2-gmp \
      php8.2-gnupg \
      php8.2-grpc \
      php8.2-http \
      php8.2-igbinary \
      php8.2-imagick \
      php8.2-imap \
      php8.2-inotify \
      php8.2-interbase \
      php8.2-intl \
      php8.2-ldap \
      php8.2-libvirt-php \
      php8.2-lz4 \
      php8.2-mailparse \
      php8.2-maxminddb \
      php8.2-mbstring \
      php8.2-mcrypt \
      php8.2-memcache \
      php8.2-memcached \
      php8.2-mongodb \
      php8.2-msgpack \
      php8.2-mysql \
      php8.2-oauth \
      php8.2-odbc \
#      php8.2-opcache \
      php8.2-pcov \
      php8.2-pgsql \
#      php8.2-phalcon5 \
      php8.2-phpdbg \
      php8.2-pinba \
#      php8.2-pq \
#      php8.2-propro \
      php8.2-protobuf \
      php8.2-ps \
      php8.2-pspell \
      php8.2-psr \
      php8.2-raphf \
      php8.2-rdkafka \
      php8.2-readline \
      php8.2-redis \
      php8.2-rrd \
      php8.2-smbclient \
      php8.2-snmp \
      php8.2-soap \
      php8.2-solr \
      php8.2-sqlite3 \
      php8.2-ssh2 \
      php8.2-stomp \
      php8.2-swoole \
      php8.2-sybase \
      php8.2-tideways \
      php8.2-tidy \
#      php8.2-uopz \
      php8.2-uploadprogress \
      php8.2-uuid \
      php8.2-vips \
#      php8.2-xdebug \
      php8.2-xhprof \
      php8.2-xml \
      php8.2-xmlrpc \
      php8.2-xsl \
#      php8.2-yac \
      php8.2-yaml \
      php8.2-zip \
      php8.2-zmq \
      php8.2-zstd \
      smbclient libsmbclient \
      sendmail && \
    ln -sfv /etc/ssl/dhparam.pem /etc/php/dhparam.pem && \
    update-alternatives --set php /usr/bin/php8.2 && \
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
COPY usr/lib/php/20220829/cassandra.so ${PHP_MODULE_PATH}/cassandra.so
RUN echo "extension = ${PHP_MODULE_PATH}/cassandra.so" > ${CAS_PHP_INI} && \
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
COPY usr/lib/php/20220829/phpBolt-extension-1.0.5-php82.so ${PHP_MODULE_PATH}/phpBolt-extension-1.0.5-php82.so
#RUN echo "extension = ${PHP_MODULE_PATH}/phpBolt-extension-1.0.5-php82.so" >> ${PHP_DIR}/apache2/php.ini && \
RUN echo "extension = ${PHP_MODULE_PATH}/phpBolt-extension-1.0.5-php82.so" >> ${PHP_DIR}/cgi/php.ini && \
    echo "extension = ${PHP_MODULE_PATH}/phpBolt-extension-1.0.5-php82.so" >> ${PHP_DIR}/cli/php.ini && \
    echo "extension = ${PHP_MODULE_PATH}/phpBolt-extension-1.0.5-php82.so" >> ${PHP_DIR}/fpm/php.ini && \
    php -m && \
    php -v

##################################################################
#                   Installing IOnCube addon
#################################################################
ADD https://downloads.ioncube.com/loader_downloads/ioncube_loaders_lin_x86-64.tar.gz /tmp/ioncube.tar.gz
RUN tar -C /tmp -xvf /tmp/ioncube.tar.gz && \
    cp /tmp/ioncube/ioncube_loader_lin_8.2.so ${PHP_MODULE_PATH} && \
##    echo "zend_extension = ${PHP_MODULE_PATH}/ioncube_loader_lin_8.2.so" >> ${PHP_DIR}/apache2/php.ini && \
    echo "zend_extension = ${PHP_MODULE_PATH}/ioncube_loader_lin_8.2.so" >> ${PHP_DIR}/cgi/php.ini && \
    echo "zend_extension = ${PHP_MODULE_PATH}/ioncube_loader_lin_8.2.so" >> ${PHP_DIR}/cli/php.ini && \
    echo "zend_extension = ${PHP_MODULE_PATH}/ioncube_loader_lin_8.2.so" >> ${PHP_DIR}/fpm/php.ini && \
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
    rm -rfv /root/tmp/* && \
    rm -rfv /tmp/*

RUN updatedb