FROM ubuntu:bionic
MAINTAINER Konstantin Safonov <kasthack@epicm.org>
MAINTAINER Anatoliy Zimovskiy <stam@epicm.org>
ENV DEBIAN_FRONTEND noninteractive

# fix errors
RUN echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections
RUN apt-get update && apt-get install -y --no-install-recommends apt-utils  gnupg

# Install base packages

RUN echo "deb http://ppa.launchpad.net/ondrej/php/ubuntu bionic main" >> /etc/apt/sources.list && \
    echo "deb http://ppa.launchpad.net/ondrej/apache2/ubuntu bionic main" >> /etc/apt/sources.list && \
    echo "deb http://ppa.launchpad.net/git-core/candidate/ubuntu bionic main" >> /etc/apt/sources.list && \
    gpg --keyserver keyserver.ubuntu.com --recv 4F4EA0AAE5267A6C && \
    gpg --export --armor 4F4EA0AAE5267A6C >> temp.key && \
    apt-key add temp.key && \
    rm temp.key && \
    gpg --keyserver keyserver.ubuntu.com --recv A1715D88E1DF1F24 && \
    gpg --export --armor A1715D88E1DF1F24 >> temp.key && \
    apt-key add temp.key && \
    rm temp.key && \
    apt-get update && \
    echo "=====================================================" && \
    echo "=====================================================" && \
    echo "=====================================================" && \
    apt-get dist-upgrade -y && \
    echo "=====================================================" && \
    echo "=====================================================" && \
    echo "=====================================================" && \
    apt-get install -y --no-install-recommends --allow-unauthenticated htop mc tmux cmatrix wget sudo && \
    echo "=====================================================" && \
    echo "=====================================================" && \
    echo "=====================================================" && \
    apt-get install -y --no-install-recommends --allow-unauthenticated ca-certificates php7.2-dev php7.2 git php-mail sendmail php-mailparse php-soap php7.2-mysql php-memcached php-memcache php-gmagick php-igbinary libmemcached-dev php7.2-curl php-gd php7.2-intl php7.2-zip php7.2-bcmath php7.2-fpm php-pear php-imap  php-memcached php-pspell php-recode php-sqlite3 php-tidy php-xmlrpc php-xml php7.2-mbstring php-gettext php-apcu php7.2-cli php7.2-common php-cgi php-json php-readline php-enchant php-ssh2 php-oauth php-gettext php-gmagick php-gnupg php-redis php-smbclient php-yaml php-geoip apache2 libapache2-mod-php apache2-utils libapache2-mod-webauth libapache2-mod-xforward libapache2-mod-webauth libapache2-mod-webauth && \
    rm -rf /var/lib/apt/lists/* && \
    phpenmod calendar curl exif ftp fileinfo gd geoip gettext gnupg iconv imap json mbstring  memcached  mysqli mysqlnd oauth pdo_mysql pdo_sqlite phar posix readline redis simplexml sockets sqlite3 ssh2 tokenizer xml xmlreader xmlrpc xmlwriter xsl yaml && \
    a2enmod rewrite heartmonitor auth_basic authnz_ldap headers heartbeat ldap lua mime status xml2enc xforward remoteip filter dav dav_fs alias

#volumes

VOLUME ["/var/www"]


# Add image configuration and scripts
ADD run.sh /run.sh
RUN chmod 755 /*.sh

# Configure /app folder with sample app

EXPOSE 80
WORKDIR /var/www/
CMD ["/run.sh"]
