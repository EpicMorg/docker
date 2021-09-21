FROM nextcloud:latest
ENV DEBIAN_FRONTEND noninteractive

##################################################################
#                  adding normal sources list
##################################################################
RUN rm /etc/apt/sources.list
COPY sources.list /etc/apt/sources.list

##################################################################
#                  adding some utils
##################################################################
RUN apt update -y && \
    apt dist-upgrade -y && \
    apt install -y --allow-unauthenticated \
        apt-transport-https \
        curl \
        ca-certificates \
        ghostscript \
        nload \
        htop \
        mc \
        nano \
        sudo \
        imagemagick \
        imagemagick-common \
        sqlite3 \
        smbclient \
        libsmbclient \
        wget

##################################################################
#                  installing php repo + smbclient
##################################################################
RUN wget -O /etc/apt/trusted.gpg.d/php.gpg https://packages.sury.org/php/apt.gpg
RUN sh -c 'echo "deb https://packages.sury.org/php/ buster main" > /etc/apt/sources.list.d/php.list'
RUN apt update -y &&  \
    apt install -y --allow-unauthenticated \
        libsmbclient-dev \
        libmagickwand-dev \
        libmagickcore-dev \
        libc-client-dev \
        libkrb5-dev \
        libsqlite3-dev \
        libssl-dev

RUN pecl install inotify && \
    docker-php-ext-enable inotify

RUN pecl install smbclient && \
    docker-php-ext-enable smbclient

RUN docker-php-ext-configure imap --with-kerberos --with-imap-ssl && \
    docker-php-ext-install imap  && \
    docker-php-ext-enable imap

RUN docker-php-ext-install fileinfo bz2 intl ftp pdo_sqlite && \
    docker-php-ext-enable fileinfo bz2 intl ftp pdo_sqlite

##################################################################
#      thank u, mac users. rolling back normal ZipStreammer
##################################################################
RUN rm -frv /usr/src/nextcloud/lib/private/Streamer.php
ADD Streamer.php /usr/src/nextcloud/lib/private/
RUN chown nobody:nogroup /usr/src/nextcloud/lib/private/Streamer.php

##################################################################
#                  smb fix
##################################################################
RUN rm -frv /etc/samba/smb.conf /usr/share/samba/smb.conf
ADD smb.conf /etc/samba/
ADD smb.conf /usr/share/samba/
