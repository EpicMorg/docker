FROM epicmorg/edge
LABEL maintainer="EpicMorg DevTeam, developer@epicm.org"
ARG DEBIAN_FRONTEND=noninteractive

##################################################################
#                   Installing Apache2 + PHP7
##################################################################
#installing php repo
RUN wget -O /etc/apt/trusted.gpg.d/php.gpg https://packages.sury.org/php/apt.gpg
RUN sh -c 'echo "deb https://packages.sury.org/php/ buster main" > /etc/apt/sources.list.d/php.list'

#installing apache2 repo
RUN wget -O /etc/apt/trusted.gpg.d/apache2.gpg https://packages.sury.org/apache2/apt.gpg
RUN sh -c 'echo "deb https://packages.sury.org/apache2/ buster main" > /etc/apt/sources.list.d/apache2.list'

#Install base packages
RUN apt-get update && \
    apt-get install -y  --allow-unauthenticated \
      apache2 \
      apache2-utils \
      libapache2-mod-php7.4 \
      libapache2-mod-webauth \
      libapache2-mod-xforward \
      libapache2-mod-security2 \
      libmemcached-dev \
      php7.4 \
      php7.4-dev \
      php7.4-fpm \
      php7.4-cli \
      php7.4-cgi \
      php-pear \
      php-gmp \
      php-snmp \
      php-ldap \
      php-mail  \
#     php-mailparse \
      php-soap \
      php-mysql \
      php-memcached \
      php-memcache \
      php-igbinary \
      php-curl \
      php-gd \
      php-intl \
      php-zip \
      php-bcmath \
      php-imap \
      php-pspell \
      php-sqlite3 \
      php-tidy \
      php-xmlrpc \
      php-xml \
      php-mbstring \
#     php-gettext \
      php-apcu \
      php-common \
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
      php-geoip \
      sendmail && \
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
#     gettext \
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
    a2enmod \
      php7.4 \
      rewrite \
      ldap \
      heartmonitor \
      auth_basic \
      authnz_ldap \
      headers \
      heartbeat \
      lua \
      mime \
      status \
      xml2enc \
      xforward \
      remoteip \
      filter \
      dav \
      dav_fs \
      alias && \
    ln -sf /etc/ssl/dhparam.pem /etc/apache2/dhparam.pem && \
    php -v

##################################################################
#                   Installing IOnCube addon
##################################################################
ADD https://www.ioncube.com/php-7.4.0-beta-loaders/ioncube_loaders_lin_x86-64_7.4_BETA2.tar.gz /tmp/ioncube.tar.gz
RUN tar -C /tmp -xvf /tmp/ioncube.tar.gz && \
    cp /tmp/ioncube_loader_lin_7.4_10.4.0_beta2.so /usr/lib/php/20170718/ && \
    echo "zend_extension = /usr/lib/php/20170718/ioncube_loader_lin_7.4_10.4.0_beta2.so" >> /etc/php/7.4/apache2/php.ini && \
    echo "zend_extension = /usr/lib/php/20170718/ioncube_loader_lin_7.4_10.4.0_beta2.so" >> /etc/php/7.4/cgi/php.ini && \
    echo "zend_extension = /usr/lib/php/20170718/ioncube_loader_lin_7.4_10.4.0_beta2.so" >> /etc/php/7.4/cli/php.ini && \
    echo "zend_extension = /usr/lib/php/20170718/ioncube_loader_lin_7.4_10.4.0_beta2.so" >> /etc/php/7.4/fpm/php.ini && \
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
    rm -rfv /tmp/composer-setup.php && \
    rm -rfv /tmp/ioncube_loader_lin_7.4_10.4.0_beta2.so && \
    rm -rfv /tmp/ioncube.tar.gz

#volumes
VOLUME ["/var/www"]

# Add image configuration and scripts
COPY run.sh /run.sh
RUN chmod 755 /*.sh

# Configure application
EXPOSE 80
WORKDIR /var/www/
CMD ["/run.sh"]
