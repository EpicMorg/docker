FROM epicmorg/balancer:latest
LABEL maintainer="EpicMorg DevTeam, developer@epicm.org"
ARG DEBIAN_FRONTEND=noninteractive

##################################################################
#                   Installing php fpn for nginx from deb
##################################################################
RUN wget -O /etc/apt/trusted.gpg.d/php.gpg https://packages.sury.org/php/apt.gpg && \
    sh -c 'echo "deb https://packages.sury.org/php/ buster main" > /etc/apt/sources.list.d/php.list' && \
    apt-get update && \
    apt-get install -y --allow-unauthenticated \
    apache2-utils \
    libmemcached-dev \
    sendmail \
    php-gmp \
    php-snmp \
    php-ldap \
    php7.4-dev \
    php7.4 \
    php-mail \
    php-soap \
    php-mysql \
    php-mailparse \
    php-memcache \
    php-memcached \
    php-curl \
    php-gd \
    php-intl \
    php-zip \
    php-bcmath \
    php-fpm \
    php-imap \
    php-pspell \
    php-sqlite3 \
    php-tidy \
    php-xmlrpc \
    php-xml \
    php-mbstring \
#   php-gettext \
    php7.4-cli \
    php-common \
    php-cgi \
    php-json \
    php-readline \
    php-enchant \
    php-ssh2 \
    php-oauth \
    php-gmagick \
    php-gnupg \
    php-redis \
    php-smbclient \
    php-yaml \
    php-geoip

##################################################################
#                   Enabling php modules
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
#   gettext \
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
    yaml

##################################################################
#                   ioncube support
##################################################################
ADD https://www.ioncube.com/php-7.4.0-beta-loaders/ioncube_loaders_lin_x86-64_7.4_BETA2.tar.gz /tmp/ioncube.tar.gz
RUN tar -C /tmp -xvf /tmp/ioncube.tar.gz && \
    cp /tmp/ioncube_loader_lin_7.4_10.4.0_beta2.so /usr/lib/php/20170718/ && \
    echo "zend_extension = /usr/lib/php/20170718/ioncube_loader_lin_7.4_10.4.0_beta2.so" >> /etc/php/7.4/cgi/php.ini && \
    echo "zend_extension = /usr/lib/php/20170718/ioncube_loader_lin_7.4_10.4.0_beta2.so" >> /etc/php/7.4/cli/php.ini && \
    echo "zend_extension = /usr/lib/php/20170718/ioncube_loader_lin_7.4_10.4.0_beta2.so" >> /etc/php/7.4/fpm/php.ini && \
    php -v

##################################################################
#                   composer support
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
    rm -rfv /tmp/composer-setup.php && \
    rm -rfv /tmp/ioncube_loader_lin_7.4_10.4.0_beta2.so && \
    rm -rfv /tmp/ioncube.tar.gz

#Final config
VOLUME ["/var/cache/nginx"]
EXPOSE 80 443

CMD ["nginx", "-g", "daemon off;"]
