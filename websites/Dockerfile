FROM debian:buster
MAINTAINER Anatoliy Zimovskiy <stam@epicm.org>

ENV DEBIAN_FRONTEND noninteractive

#editing sources list
RUN rm /etc/apt/sources.list
COPY sources.list /etc/apt/sources.list
COPY locale.gen /etc/locale.gen

# fix errors
RUN echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections
RUN apt-get update && apt-get install -y --allow-unauthenticated  ca-certificates gnupg sudo apt-transport-https lsb-release apt-utils locales console-cyrillic


#installing php repo
RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys AC0E47584A7A714D
RUN sh -c 'echo "deb https://packages.sury.org/php/ $(lsb_release -sc) main" > /etc/apt/sources.list.d/php.list'

#installing utils
RUN apt-get update && apt-get install -y --allow-unauthenticated htop mc tmux iftop cmatrix  wget iputils-ping


# Install base packages
RUN apt-get install -y  --allow-unauthenticated  php-ldap php7.3-dev php7.3 git php-mail sendmail php-mailparse php-soap php7.3-mysql php-memcached php-memcache php-igbinary libmemcached-dev php7.3-curl php-gd php7.3-intl php7.3-zip php7.3-bcmath php7.3-fpm php-pear php-imap   php-pspell php-recode php-sqlite3 php-tidy php-xmlrpc php-xml php7.3-mbstring php-gettext php-apcu php7.3-cli php7.3-common php-cgi php-json php-readline php-enchant php-ssh2 php-oauth php-gettext php-gmagick php-gnupg php-redis php-smbclient php-yaml php-geoip apache2 libapache2-mod-php apache2-utils libapache2-mod-webauth libapache2-mod-xforward libapache2-mod-webauth libapache2-mod-webauth && \
    rm -rf /var/lib/apt/lists/* && \
    phpenmod calendar ldap curl exif ftp fileinfo gd geoip gettext gnupg iconv imap json mbstring  memcached  mysqli mysqlnd oauth pdo_mysql pdo_sqlite phar posix readline redis simplexml sockets sqlite3 ssh2 tokenizer xml xmlreader xmlrpc xmlwriter xsl yaml && \
    a2enmod rewrite ldap heartmonitor auth_basic authnz_ldap headers heartbeat lua mime status xml2enc xforward remoteip filter dav dav_fs alias

#After install fixes
RUN apt-get dist-upgrade -y
RUN sudo locale-gen
RUN localedef en_US.UTF-8 -i en_US -f UTF-8
RUN update-locale LC_ALL=en_US.UTF-8 LANG=en_US.UTF-8


#volumes
VOLUME ["/var/www"]


# Add image configuration and scripts
COPY run.sh /run.sh
RUN chmod 755 /*.sh

# Configure /app folder with sample app

EXPOSE 80
WORKDIR /var/www/
CMD ["/run.sh"]
