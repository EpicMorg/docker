FROM hub.epicm.org/epicmorg/debian:bookworm
LABEL maintainer="EpicMorg DevTeam, developer@epicm.org"
ARG DEBIAN_FRONTEND=noninteractive

ENV PHP_MODULE_VER=20200930
ENV PHP_MODULE_PATH=/usr/lib/php/${PHP_MODULE_VER}
ENV PHP_VER=8.0
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
      php8.0 \
      php8.0-cli \
      php8.0-common \
      php8.0-dev \
      php8.0-amqp \
      php8.0-apcu \
      php8.0-ast \
      php8.0-bcmath \
      php8.0-bz2 \
      php8.0-cgi \
      php8.0-curl \
      php8.0-dba \
      php8.0-decimal \
      php8.0-dio \
      php8.0-ds \
      php8.0-enchant \
      php8.0-excimer \
      php8.0-fpm \
      php8.0-gd \
      php8.0-gearman \
#      php8.0-gmagick \
      php8.0-gmp \
      php8.0-gnupg \
      php8.0-grpc \
      php8.0-http \
      php8.0-igbinary \
      php8.0-imagick \
      php8.0-imap \
      php8.0-inotify \
      php8.0-interbase \
      php8.0-intl \
      php8.0-ldap \
      php8.0-libvirt-php \
      php8.0-lz4 \
      php8.0-mailparse \
      php8.0-maxminddb \
      php8.0-mbstring \
      php8.0-mcrypt \
      php8.0-memcache \
      php8.0-memcached \
      php8.0-mongodb \
      php8.0-msgpack \
      php8.0-mysql \
      php8.0-oauth \
      php8.0-odbc \
      php8.0-opcache \
      php8.0-pcov \
      php8.0-pgsql \
      php8.0-phalcon5 \
      php8.0-phpdbg \
      php8.0-pinba \
#      php8.0-pq \
#      php8.0-propro \
      php8.0-protobuf \
      php8.0-ps \
      php8.0-pspell \
#      php8.0-psr \
      php8.0-raphf \
      php8.0-rdkafka \
      php8.0-readline \
      php8.0-redis \
      php8.0-rrd \
      php8.0-smbclient \
      php8.0-snmp \
      php8.0-soap \
      php8.0-solr \
      php8.0-sqlite3 \
      php8.0-ssh2 \
      php8.0-stomp \
      php8.0-swoole \
      php8.0-sybase \
      php8.0-tideways \
      php8.0-tidy \
      php8.0-uopz \
      php8.0-uploadprogress \
      php8.0-uuid \
      php8.0-vips \
      php8.0-xdebug \
      php8.0-xhprof \
      php8.0-xml \
      php8.0-xmlrpc \
      php8.0-xsl \
#      php8.0-yac \
      php8.0-yaml \
      php8.0-zip \
      php8.0-zmq \
      php8.0-zstd \
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
      php7.4*  \
#      php8.0*  \
      php8.1*  \
      php8.2*  \
      php8.3*  \
      php8.4*  && \
    rm -rfv /etc/php/{5.6,7.0,7.1,7.2,7.3,7.4,8.1,8.2,8.3,8.4} && \
    update-alternatives --set php /usr/bin/php8.0 && \
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
COPY usr/lib/php/20200930/cassandra.so ${PHP_MODULE_PATH}/cassandra.so
RUN echo "extension = ${PHP_MODULE_PATH}/cassandra.so" > ${CAS_PHP_INI} && \
    ln -sf ${CAS_PHP_INI} ${PHP_DIR}/cgi/conf.d/cassandra.ini && \
    ln -sf ${CAS_PHP_INI} ${PHP_DIR}/cli/conf.d/cassandra.ini && \
    ln -sf ${CAS_PHP_INI} ${PHP_DIR}/fpm/conf.d/cassandra.ini && \
#    ln -sf ${CAS_PHP_INI} ${PHP_DIR}/apache2/conf.d/cassandra.ini  && \
    php -m && \
    php -v

##################################################################
#                   Installing Bolt addon
##################################################################
#ADD https://phpbolt.com/wp-content/uploads/2023/03/phpBolt-extension-1.0.5.zip /tmp/phpBolt.zip
COPY usr/lib/php/20200930/phpBolt-extension-1.0.5-php80.so ${PHP_MODULE_PATH}/phpBolt-extension-1.0.5-php80.so
#RUN echo "extension = ${PHP_MODULE_PATH}/phpBolt-extension-1.0.5-php80.so" >> ${PHP_DIR}/apache2/php.ini && \
RUN echo "extension = ${PHP_MODULE_PATH}/phpBolt-extension-1.0.5-php80.so" >> ${PHP_DIR}/cgi/php.ini && \
    echo "extension = ${PHP_MODULE_PATH}/phpBolt-extension-1.0.5-php80.so" >> ${PHP_DIR}/cli/php.ini && \
    echo "extension = ${PHP_MODULE_PATH}/phpBolt-extension-1.0.5-php80.so" >> ${PHP_DIR}/fpm/php.ini && \
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
#                   Installing P4 addon
##################################################################
RUN wget -q --no-check-certificate -c http://ftp.perforce.com/perforce/r20.2/bin.linux26x86_64/perforce_php80.so --random-wait -O ${PHP_MODULE_PATH}/perforce_php80.so && \
    wget -q --no-check-certificate -c http://ftp.perforce.com/perforce/r20.2/bin.linux26x86_64/perforce_php80-ssl1.0.2.so --random-wait -O ${PHP_MODULE_PATH}/perforce_php80-ssl1.0.2.so && \
    wget -q --no-check-certificate -c http://ftp.perforce.com/perforce/r20.2/bin.linux26x86_64/perforce_php80-ssl1.1.1.so --random-wait -O ${PHP_MODULE_PATH}/perforce_php80-ssl1.1.1.so

#COPY --from=builder /builds/export/perforce.so ${PHP_MODULE_PATH}

RUN echo "extension = ${PHP_MODULE_PATH}/perforce_php80-ssl1.1.1.so" > ${P4_PHP_INI} && \
    ln -sf ${P4_PHP_INI} ${PHP_DIR}/cgi/conf.d/perforce.ini && \
    ln -sf ${P4_PHP_INI} ${PHP_DIR}/cli/conf.d/perforce.ini && \
    ln -sf ${P4_PHP_INI} ${PHP_DIR}/fpm/conf.d/perforce.ini && \
    php -m && \
    php -v
    
##################################################################
#                   Installing IOnCube addon
#################################################################
# NOT OFFICIALLY SUPPORTED
#
#ADD https://downloads.ioncube.com/loader_downloads/ioncube_loaders_lin_x86-64.tar.gz /tmp/ioncube.tar.gz
#RUN tar -C /tmp -xvf /tmp/ioncube.tar.gz && \
#    cp /tmp/ioncube/ioncube_loader_lin_8.0.so ${PHP_MODULE_PATH} && \
##    echo "zend_extension = ${PHP_MODULE_PATH}/ioncube_loader_lin_8.0.so" >> ${PHP_DIR}/apache2/php.ini && \
#    echo "zend_extension = ${PHP_MODULE_PATH}/ioncube_loader_lin_8.0.so" >> ${PHP_DIR}/cgi/php.ini && \
#    echo "zend_extension = ${PHP_MODULE_PATH}/ioncube_loader_lin_8.0.so" >> ${PHP_DIR}/cli/php.ini && \
#    echo "zend_extension = ${PHP_MODULE_PATH}/ioncube_loader_lin_8.0.so" >> ${PHP_DIR}/fpm/php.ini && \
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
#                   cleaninig up
##################################################################
RUN apt-get clean -y && \
    apt-get autoclean -y && \
    rm -rfv /var/lib/apt/lists/* && \
    rm -rfv /var/cache/apt/archives/*.deb && \
    rm -rfv /root/tmp/* && \
    rm -rfv /tmp/*

RUN updatedb