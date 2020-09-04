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
      libapache2-mod-php7.2 \
      libapache2-mod-webauth \
      libapache2-mod-xforward \
      libapache2-mod-security2 \
      libmemcached-dev \
      php7.2-ldap \
      php7.2-dev \
      php7.2 \
      php7.2-mail \
      php7.2-mailparse \
      php7.2-soap \
      php7.2-mysql \
      php7.2-curl \
      php7.2-gd \
      php7.2-intl \
      php7.2-zip \
      php7.2-bcmath \
      php7.2-fpm \
      php-pear \
      php7.2-imap \
      php7.2-pspell \
      php7.2-recode \
      php7.2-sqlite3 \
      php7.2-tidy \
      php7.2-xmlrpc \
      php7.2-xml \
      php7.2-mbstring \
      php7.2-gettext \
      php7.2-apcu \
      php7.2-cli \
      php7.2-common \
      php7.2-cgi \
      php7.2-json \
      php7.2-readline \
      php7.2-enchant \
      php7.2-ssh2 \
      php7.2-oauth \
      php7.2-gmagick \
      php7.2-redis \
      php7.2-smbclient \
      php7.2-yaml \
      php7.2-geoip \
      sendmail && \
    a2enmod \
      php7.2 \
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
#                   LDAP Fix
##################################################################
RUN echo "TLS_REQCERT never" >> /etc/ldap/ldap.conf

##################################################################
#                   Installing IOnCube addon
##################################################################
ADD https://downloads.ioncube.com/loader_downloads/ioncube_loaders_lin_x86-64.tar.gz /tmp/ioncube.tar.gz
RUN tar -C /tmp -xvf /tmp/ioncube.tar.gz && \
    cp /tmp/ioncube/ioncube_loader_lin_7.2.so /usr/lib/php/20170718/ && \
    echo "zend_extension = /usr/lib/php/20170718/ioncube_loader_lin_7.2.so" >> /etc/php/7.2/apache2/php.ini && \
    echo "zend_extension = /usr/lib/php/20170718/ioncube_loader_lin_7.2.so" >> /etc/php/7.2/cgi/php.ini && \
    echo "zend_extension = /usr/lib/php/20170718/ioncube_loader_lin_7.2.so" >> /etc/php/7.2/cli/php.ini && \
    echo "zend_extension = /usr/lib/php/20170718/ioncube_loader_lin_7.2.so" >> /etc/php/7.2/fpm/php.ini && \
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
