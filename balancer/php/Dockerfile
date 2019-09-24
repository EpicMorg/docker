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
    php7.3-gmp \
    php7.3-snmp \
    php7.3-ldap \
    php7.3-dev \
    php7.3 \
    php7.3-mail \
    php7.3-mailparse \
    php7.3-soap \
    php7.3-mysql \
    php7.3-memcached \
    php7.3-memcache \
    php7.3-igbinary \
    php7.3-curl \
    php7.3-gd \
    php7.3-intl \
    php7.3-zip \
    php7.3-bcmath \
    php7.3-fpm \
    php-pear \
    php7.3-imap \
    php7.3-pspell \
    php7.3-recode \
    php7.3-sqlite3 \
    php7.3-tidy \
    php7.3-xmlrpc \
    php7.3-xml \
    php7.3-mbstring \
    php7.3-gettext \
    php7.3-apcu \
    php7.3-cli \
    php7.3-common \
    php7.3-cgi \
    php7.3-json \
    php7.3-readline \
    php7.3-enchant \
    php7.3-ssh2 \
    php7.3-oauth \
    php7.3-gmagick \
    php7.3-gnupg \
    php7.3-redis \
    php7.3-smbclient \
    php7.3-yaml \
    php7.3-geoip

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
    gettext \
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
ADD https://downloads.ioncube.com/loader_downloads/ioncube_loaders_lin_x86-64.tar.gz /tmp/ioncube.tar.gz
RUN tar -C /tmp -xvf /tmp/ioncube.tar.gz && \
    cp /tmp/ioncube/ioncube_loader_lin_7.3.so /usr/lib/php/20170718/ && \
    echo "zend_extension = /usr/lib/php/20170718/ioncube_loader_lin_7.3.so" >> /etc/php/7.3/cgi/php.ini && \
    echo "zend_extension = /usr/lib/php/20170718/ioncube_loader_lin_7.3.so" >> /etc/php/7.3/cli/php.ini && \
    echo "zend_extension = /usr/lib/php/20170718/ioncube_loader_lin_7.3.so" >> /etc/php/7.3/fpm/php.ini && \
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
    rm -rfv /tmp/ioncube.tar.gz

#Final config
VOLUME ["/var/cache/nginx"]
EXPOSE 80 443

CMD ["nginx", "-g", "daemon off;"]
