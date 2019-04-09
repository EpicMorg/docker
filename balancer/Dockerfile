FROM debian:buster
MAINTAINER Anatoliy Zimovskiy <stam@epicm.org>

ENV DEBIAN_FRONTEND noninteractive

#editing sources list
RUN rm /etc/apt/sources.list
COPY sources.list /etc/apt/sources.list
COPY locale.gen /etc/locale.gen

# fix errors
RUN echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections

#installing utils
RUN apt-get update && apt-get install -y --allow-unauthenticated  ca-certificates gnupg sudo apt-transport-https lsb-release apt-utils locales console-cyrillic wget curl htop mc tmux iftop cmatrix iputils-ping  cmatrix-xfont  lsof lynx fontconfig

#installing nginx repo
RUN wget -O /etc/apt/trusted.gpg.d/nginx-mainline.gpg https://packages.sury.org/nginx-mainline/apt.gpg
RUN sh -c 'echo "deb https://packages.sury.org/nginx-mainline/ buster main" > /etc/apt/sources.list.d/nginx-mainline.list'

#installing php repo
RUN wget -O /etc/apt/trusted.gpg.d/php.gpg https://packages.sury.org/php/apt.gpg
RUN sh -c 'echo "deb https://packages.sury.org/php/ buster main" > /etc/apt/sources.list.d/php.list'

#installing packages
RUN apt-get update && apt-get install -y  --allow-unauthenticated  libgd-tools geoip-bin nginx-doc ssl-cert  nginx-extras openssl libnginx-mod-http-cache-purge libnginx-mod-http-dav-ext libnginx-mod-http-geoip libnginx-mod-http-headers-more-filter  libnginx-mod-http-lua libnginx-mod-http-uploadprogress libnginx-mod-mail libnginx-mod-stream libnginx-mod-http-xslt-filter && \
    php7.3-ldap php7.3-dev php7.3 git php7.3-mail sendmail php7.3-mailparse php7.3-soap php7.3-mysql php7.3-memcached php7.3-memcache php7.3-igbinary libmemcached-dev php7.3-curl php7.3-gd php7.3-intl php7.3-zip php7.3-bcmath php7.3-fpm php-pear php7.3-imap   php7.3-pspell php7.3-recode php7.3-sqlite3 php7.3-tidy php7.3-xmlrpc php7.3-xml php7.3-mbstring php7.3-gettext php7.3-apcu php7.3-cli php7.3-common php7.3-cgi php7.3-json php7.3-readline php7.3-enchant php7.3-ssh2 php7.3-oauth php7.3-gettext php7.3-gmagick php7.3-gnupg php7.3-redis php7.3-smbclient php7.3-yaml php7.3-geoip  && \
    phpenmod calendar ldap curl exif ftp fileinfo gd geoip gettext gnupg iconv imap json mbstring  memcached  mysqli mysqlnd oauth pdo_mysql pdo_sqlite phar posix readline redis simplexml sockets sqlite3 ssh2 tokenizer xml xmlreader xmlrpc xmlwriter xsl yaml

#ioncube support
ADD https://downloads.ioncube.com/loader_downloads/ioncube_loaders_lin_x86-64.tar.gz /tmp/ioncube.tar.gz
RUN tar -C /tmp -xvf /tmp/ioncube.tar.gz && \
    cp /tmp/ioncube/ioncube_loader_lin_7.3.so /usr/lib/php/20170718/ && \
    echo "zend_extension = /usr/lib/php/20170718/ioncube_loader_lin_7.3.so" >> /etc/php/7.3/cgi/php.ini && \
    echo "zend_extension = /usr/lib/php/20170718/ioncube_loader_lin_7.3.so" >> /etc/php/7.3/cli/php.ini && \
    echo "zend_extension = /usr/lib/php/20170718/ioncube_loader_lin_7.3.so" >> /etc/php/7.3/fpm/php.ini && \
    php -v

#composer support
RUN cd /tmp && \
     php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" && \
     php composer-setup.php  --install-dir=/usr/local/bin --filename=composer && \
     rm /tmp/composer-setup.php

RUN ln -sf /dev/stdout /var/log/nginx/access.log && \
    ln -sf /dev/stderr /var/log/nginx/error.log

#After install fixes
RUN localedef en_US.UTF-8 -i en_US -f UTF-8
RUN update-locale LC_ALL=en_US.UTF-8 LANG=en_US.UTF-8
RUN apt update
RUN apt upgrade -y
RUN apt dist-upgrade -y
RUN apt-get clean autoclean
RUN apt-get autoremove -y
RUN rm -rf /var/lib/apt/lists/*

#final config
VOLUME ["/var/cache/nginx"]
EXPOSE 80 443

CMD ["service", "php7.3-fpm", "start"]
CMD ["nginx", "-g", "daemon off;"]
