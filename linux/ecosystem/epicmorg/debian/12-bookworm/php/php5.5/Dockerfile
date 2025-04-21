FROM quay.io/epicmorg/debian:bookworm
LABEL maintainer="EpicMorg DevTeam, developer@epicm.org"
ARG DEBIAN_FRONTEND=noninteractive

ENV PHP_VER=5.5
ENV PHP_MODULE_PATH=/usr/local/lib/php/extensions/no-debug-non-zts-20121212
ENV PHP_DIR=/etc/php/${PHP_VER}
ARG P4_PHP_INI=${PHP_DIR}/mods-available/perfroce.ini
ARG CAS_PHP_INI=${PHP_DIR}/mods-available/cassandra.ini

ENV PHP_INI_DIR=/usr/local/etc/php
ENV PHP_FILENAME=php-5.5.38.tar.xz
ENV PHPIZE_DEPS=autoconf  
ENV PHP_SHA256=cb527c44b48343c8557fe2446464ff1d4695155a95601083e5d1f175df95580f
ENV PHP_VERSION=5.5.38

#Install base packages
RUN apt-get update && \
    apt-get install -y  --allow-unauthenticated \
      libmagickwand-dev \
      libmemcached-dev \
      imagemagick \
      libncurses5 \
      autoconf

##################################################################
#                   Installing  PHP5.5
##################################################################
COPY --from=php:5.5 /usr/local/bin /usr/local/bin
COPY --from=php:5.5 /usr/local/etc/php /usr/local/etc/php
COPY --from=php:5.5 /usr/local/etc/pear.conf /usr/local/etc/pear.conf
COPY --from=php:5.5 /usr/local/include/php /usr/local/include/php
COPY --from=php:5.5 /usr/local/lib/php /usr/local/lib/php
COPY --from=php:5.5 /usr/lib/x86_64-linux-gnu/libssl.so.1.0.0 /usr/lib/x86_64-linux-gnu/libssl.so.1.0.0
COPY --from=php:5.5 /usr/lib/x86_64-linux-gnu/openssl-1.0.0 /usr/lib/x86_64-linux-gnu/openssl-1.0.0
COPY --from=php:5.5 /usr/lib/x86_64-linux-gnu/libcrypto.so.1.0.0 /usr/lib/x86_64-linux-gnu/libcrypto.so.1.0.0
COPY --from=php:5.5 /usr/lib/x86_64-linux-gnu/libcurl.so.4 /usr/lib/x86_64-linux-gnu/libcurl.so.4
COPY --from=php:5.5 /usr/local/php /usr/local/php
COPY --from=php:5.5 /usr/src/php.tar.xz /usr/src/php.tar.xz
COPY --from=php:5.5 /usr/src/php.tar.xz.asc /usr/src/php.tar.xz.asc

##################################################################
#                   Enabling extensions
##################################################################
RUN pear update-channels && \
    pecl channel-update pecl.php.net && \
    pear upgrade

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
#    echo "extension = ${PHP_MODULE_PATH}/timezonedb.so" >> ${PHP_DIR}/cgi/php.ini && \
#    echo "extension = ${PHP_MODULE_PATH}/timezonedb.so" >> ${PHP_DIR}/cli/php.ini && \
#    echo "extension = ${PHP_MODULE_PATH}/timezonedb.so" >> ${PHP_DIR}/fpm/php.ini && \
    php -m && \
    php -v

##################################################################
#                   Installing imagic addon
##################################################################
RUN  pecl install imagick && \
##    echo "extension = ${PHP_MODULE_PATH}/imagick.so" >> ${PHP_DIR}/apache2/php.ini && \
#    echo "extension = ${PHP_MODULE_PATH}/imagick.so" >> ${PHP_DIR}/cgi/php.ini && \
#    echo "extension = ${PHP_MODULE_PATH}/imagick.so" >> ${PHP_DIR}/cli/php.ini && \
#    echo "extension = ${PHP_MODULE_PATH}/imagick.so" >> ${PHP_DIR}/fpm/php.ini && \
    php -m && \
    php -v

##################################################################
#                   Installing IOnCube addon
##################################################################
ADD https://downloads.ioncube.com/loader_downloads/ioncube_loaders_lin_x86-64.tar.gz /tmp/ioncube.tar.gz
RUN tar -C /tmp -xvf /tmp/ioncube.tar.gz && \
    cp /tmp/ioncube/ioncube_loader_lin_5.5.so ${PHP_MODULE_PATH} && \
#    echo "zend_extension = ${PHP_MODULE_PATH}/ioncube_loader_lin_5.5.so" >> ${PHP_DIR}/apache2/php.ini && \
    echo "zend_extension = ${PHP_MODULE_PATH}/ioncube_loader_lin_5.5.so" >> ${PHP_DIR}/cgi/php.ini && \
    echo "zend_extension = ${PHP_MODULE_PATH}/ioncube_loader_lin_5.5.so" >> ${PHP_DIR}/cli/php.ini && \
    echo "zend_extension = ${PHP_MODULE_PATH}/ioncube_loader_lin_5.5.so" >> ${PHP_DIR}/fpm/php.ini && \
    echo "zend_extension = ${PHP_MODULE_PATH}/ioncube_loader_lin_5.5.so" >> /usr/local/etc/php/conf.d/php.ini && \
    php -m && \
    php -v

##################################################################
#                   Installing IOnCube addon
##################################################################
ADD https://downloads.ioncube.com/loader_downloads/ioncube_loaders_lin_x86-64.tar.gz /tmp/ioncube.tar.gz
RUN tar -C /tmp -xvf /tmp/ioncube.tar.gz && \
    cp /tmp/ioncube/ioncube_loader_lin_5.6.so ${PHP_MODULE_PATH} && \
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
