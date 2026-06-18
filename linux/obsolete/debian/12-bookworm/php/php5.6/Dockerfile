FROM docker.io/epicmorg/debian:bookworm
LABEL maintainer="EpicMorg DevTeam, developer@epicm.org"
ARG DEBIAN_FRONTEND=noninteractive

ENV PHP_VER=5.6
ENV PHP_MODULE_PATH=/usr/lib/php/20131226
ENV PHP_DIR=/etc/php/${PHP_VER}
ARG P4_PHP_INI=${PHP_DIR}/mods-available/perfroce.ini
ARG CAS_PHP_INI=${PHP_DIR}/mods-available/cassandra.ini

##################################################################
#                   Installing  PHP5.6
##################################################################
RUN wget -O /etc/apt/trusted.gpg.d/php.gpg https://packages.sury.org/php/apt.gpg
RUN sh -c 'echo "deb [trusted=yes] https://packages.sury.org/php/ $(lsb_release -sc) main" > /etc/apt/sources.list.d/php.list'

RUN apt-get update && \
    apt-get install -y  --allow-unauthenticated \
#      php-pear \
      php5.6 \
      php5.6-cli \
      php5.6-common \
      php5.6-dev \
      php5.6-amqp \
      php5.6-apcu \
      php5.6-bcmath \
      php5.6-bz2 \
      php5.6-cgi \
      php5.6-curl \
      php5.6-dba \
      php5.6-dio \
      php5.6-enchant \
      php5.6-fpm \
      php5.6-gd \
      php5.6-gearman \
      php5.6-geoip \
#      php5.6-gmagick \
      php5.6-gmp \
      php5.6-gnupg \
      php5.6-grpc \
      php5.6-http \
      php5.6-igbinary \
      php5.6-imagick \
      php5.6-imap \
      php5.6-inotify \
      php5.6-interbase \
      php5.6-intl \
      php5.6-json \
      php5.6-ldap \
      php5.6-libvirt-php \
      php5.6-lua \
      php5.6-lz4 \
      php5.6-mailparse \
      php5.6-mbstring \
      php5.6-mcrypt \
      php5.6-memcache \
      php5.6-memcached \
      php5.6-mongo \
      php5.6-mongodb \
      php5.6-msgpack \
      php5.6-mysql \
      php5.6-mysqlnd-ms \
      php5.6-oauth \
      php5.6-odbc \
      php5.6-opcache \
      php5.6-pgsql \
      php5.6-phpdbg \
      php5.6-propro \
      php5.6-protobuf \
      php5.6-ps \
      php5.6-pspell \
      php5.6-radius \
      php5.6-raphf \
      php5.6-readline \
      php5.6-recode \
      php5.6-redis \
      php5.6-rrd \
      php5.6-smbclient \
      php5.6-snmp \
      php5.6-soap \
      php5.6-solr \
      php5.6-sqlite3 \
      php5.6-ssh2 \
      php5.6-stomp \
      php5.6-sybase \
      php5.6-tidy \
      php5.6-uploadprogress \
#      php5.6-xcache \
      php5.6-xdebug \
      php5.6-xhprof \
      php5.6-xml \
      php5.6-xmlrpc \
      php5.6-xsl \
#      php5.6-yac \
      php5.6-yaml \
      php5.6-zip \
      php5.6-zmq \
      smbclient \
      libsmbclient \
      sendmail && \
    ln -sfv /etc/ssl/dhparam.pem /etc/php/dhparam.pem && \
    apt-get remove -y \
#      php5.6* \
      php7.0*  \
      php7.1*  \
      php7.2*  \
      php7.3*  \
      php7.4*  \
      php8.0*  \
      php8.1*  \
      php8.2*  \
      php8.3*  \
      php8.4*  && \
    rm -rfv /etc/php/{7.0,7.1,7.2,7.3,7.4,8.0,8.1,8.2,8.3,8.4} && \
    update-alternatives --set php /usr/bin/php5.6 && \
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

##################################################################
#                   Enabling extensions
##################################################################
#RUN pear update-channels && \
#    pecl channel-update pecl.php.net && \
#    pear upgrade

##############################################################################
# Cassandra CPP Support Install
##############################################################################
#OPY addons/multiarch-support_2.28_amd64.deb /tmp/cassandra-php-driver/multiarch-support_2.28_amd64.deb
#RUN wget -c --random-wait --user-agent="Mozilla/5.0 (Windows NT 6.1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/41.0.2228.0 Safari/537.36" --directory-prefix=/tmp/cassandra-php-driver \ 
#    https://downloads.datastax.com/cpp-driver/ubuntu/18.04/dependencies/libuv/v1.35.0/libuv1_1.35.0-1_amd64.deb \
#    https://downloads.datastax.com/cpp-driver/ubuntu/18.04/dependencies/libuv/v1.35.0/libuv1-dev_1.35.0-1_amd64.deb \
#    https://downloads.datastax.com/cpp-driver/ubuntu/18.04/dependencies/libuv/v1.35.0/libuv1-dbg_1.35.0-1_amd64.deb \
#    https://downloads.datastax.com/cpp-driver/ubuntu/18.04/cassandra/v2.16.0/cassandra-cpp-driver-dbg_2.16.0-1_amd64.deb \
#    https://downloads.datastax.com/cpp-driver/ubuntu/18.04/cassandra/v2.16.0/cassandra-cpp-driver-dev_2.16.0-1_amd64.deb \
#    https://downloads.datastax.com/cpp-driver/ubuntu/18.04/cassandra/v2.16.0/cassandra-cpp-driver_2.16.0-1_amd64.deb

#RUN cd /tmp/cassandra-php-driver && \
#    dpkg -i ./multiarch-support_2.28_amd64.deb && \
#    dpkg -i ./libuv1_1.35.0-1_amd64.deb && \
#    dpkg -i ./libuv1-dev_1.35.0-1_amd64.deb && \
#    dpkg -i ./libuv1-dbg_1.35.0-1_amd64.deb && \
#    dpkg -i ./cassandra-cpp-driver_2.16.0-1_amd64.deb && \
#    dpkg -i ./cassandra-cpp-driver-dev_2.16.0-1_amd64.deb && \
#    dpkg -i ./cassandra-cpp-driver-dbg_2.16.0-1_amd64.deb

##############################################################################
# Cassandra PHP Drivers Install
##############################################################################
#RUN pecl install cassandra && \
#    echo "extension = ${PHP_MODULE_PATH}/cassandra.so" > /usr/local/etc/php/conf.d/cassandra.ini && \
#    php -m && \
#    php -v

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
#RUN  pecl install imagick && \
##    echo "extension = ${PHP_MODULE_PATH}/imagick.so" >> ${PHP_DIR}/apache2/php.ini && \
#    echo "extension = ${PHP_MODULE_PATH}/imagick.so" >> ${PHP_DIR}/cgi/php.ini && \
#    echo "extension = ${PHP_MODULE_PATH}/imagick.so" >> ${PHP_DIR}/cli/php.ini && \
#    echo "extension = ${PHP_MODULE_PATH}/imagick.so" >> ${PHP_DIR}/fpm/php.ini && \
#    php -m && \
#    php -v

##################################################################
#                   Installing IOnCube addon
##################################################################
ADD https://downloads.ioncube.com/loader_downloads/ioncube_loaders_lin_x86-64.tar.gz /tmp/ioncube.tar.gz
RUN tar -C /tmp -xvf /tmp/ioncube.tar.gz && \
    cp /tmp/ioncube/ioncube_loader_lin_5.6.so ${PHP_MODULE_PATH} && \
    #    echo "zend_extension = ${PHP_MODULE_PATH}/ioncube_loader_lin_7.0.so" >> ${PHP_DIR}/apache2/php.ini && \
    echo "zend_extension = ${PHP_MODULE_PATH}/ioncube_loader_lin_5.6.so" >> ${PHP_DIR}/cgi/php.ini && \
    echo "zend_extension = ${PHP_MODULE_PATH}/ioncube_loader_lin_5.6.so" >> ${PHP_DIR}/cli/php.ini && \
    echo "zend_extension = ${PHP_MODULE_PATH}/ioncube_loader_lin_5.6.so" >> ${PHP_DIR}/fpm/php.ini && \
    php -m && \
    php -v

##################################################################
#                   Installing P4 addon
##################################################################
#COPY --from=builder /builds/export/perforce.so ${PHP_MODULE_PATH}
#RUN echo "extension= ${PHP_MODULE_PATH}/perforce.so" > ${P4_PHP_INI} && \
##    ln -sf ${P4_PHP_INI} ${PHP_DIR}/apache2/conf.d/perforce.ini && \
#    ln -sf ${P4_PHP_INI} ${PHP_DIR}/cgi/conf.d/perforce.ini && \
#    ln -sf ${P4_PHP_INI} ${PHP_DIR}/cli/conf.d/perforce.ini && \
#    ln -sf ${P4_PHP_INI} ${PHP_DIR}/fpm/conf.d/perforce.ini && \
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
