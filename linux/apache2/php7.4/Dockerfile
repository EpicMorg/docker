FROM epicmorg/php:latest
LABEL maintainer="EpicMorg DevTeam, developer@epicm.org"
ARG DEBIAN_FRONTEND=noninteractive

ARG PHP_MODULE_PATH=/usr/lib/php/20190902
ARG PHP_VER=7.4
ARG PHP_DIR=/etc/php/${PHP_VER}
ARG P4_PHP_INI=${PHP_DIR}/mods-available/perfroce.ini
ARG SMB_PHP_INI=${PHP_DIR}/mods-available/smbclient.ini

##################################################################
#                   Installing Apache2
##################################################################
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
      libapache2-mod-security2 && \
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
    php -m && \
    php -v

##################################################################
#                   LDAP Fix
##################################################################
RUN echo "TLS_REQCERT never" >> /etc/ldap/ldap.conf

##################################################################
#                   Installing IOnCube addon
##################################################################
RUN echo "zend_extension = ${PHP_MODULE_PATH}/ioncube_loader_lin_7.4.so" >> ${PHP_DIR}/apache2/php.ini && \
    php -m && \
    php -v

##################################################################
#                   Installing imagic addon
##################################################################
RUN echo "extension = imagick.so" >> ${PHP_DIR}/apache2/php.ini && \
    php -m && \
    php -v

##################################################################
#                   Installing P4 addon
##################################################################
RUN ln -sf ${P4_PHP_INI} ${PHP_DIR}/apache2/conf.d/perforce.ini && \
    php -m && \
    php -v

##################################################################
#                   Installing smbclient addon
##################################################################
RUN ln -sf ${SMB_PHP_INI} ${PHP_DIR}/apache2/conf.d/smbclient.ini  && \
    php -m && \
    php -v

##################################################################
#                   cleaninig up
##################################################################
RUN apt clean -y && \
    apt autoclean -y && \
    rm -rfv /var/lib/apt/lists/* && \
    rm -rfv /var/cache/apt/archives/*.deb && \
    rm -rfv /tmp/deb/* && \
    rm -rfv /tmp/ioncube/* && \
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
