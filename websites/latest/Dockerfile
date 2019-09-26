FROM epicmorg/prod
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
      libapache2-mod-php7.3 \
      libapache2-mod-webauth \
      libapache2-mod-xforward \
      libapache2-mod-security2 \
      libmemcached-dev \
      php7.3-gmp \
      php7.3-snmp \
      php7.3-ldap \
      php7.3-dev \
      php7.3 \
      php7.3-mail  \
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
      php7.3-geoip \
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
      yaml && \
    a2enmod \
      php7.3 \
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
    openssl dhparam -out /etc/apache2/dhparam.pem 4096 && \
    php -v

##################################################################
#                   Installing IOnCube addon
##################################################################
ADD https://downloads.ioncube.com/loader_downloads/ioncube_loaders_lin_x86-64.tar.gz /tmp/ioncube.tar.gz
RUN tar -C /tmp -xvf /tmp/ioncube.tar.gz && \
    cp /tmp/ioncube/ioncube_loader_lin_7.3.so /usr/lib/php/20170718/ && \
    echo "zend_extension = /usr/lib/php/20170718/ioncube_loader_lin_7.3.so" >> /etc/php/7.3/apache2/php.ini && \
    echo "zend_extension = /usr/lib/php/20170718/ioncube_loader_lin_7.3.so" >> /etc/php/7.3/cgi/php.ini && \
    echo "zend_extension = /usr/lib/php/20170718/ioncube_loader_lin_7.3.so" >> /etc/php/7.3/cli/php.ini && \
    echo "zend_extension = /usr/lib/php/20170718/ioncube_loader_lin_7.3.so" >> /etc/php/7.3/fpm/php.ini && \
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
