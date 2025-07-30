FROM docker.io/nextcloud:24
ENV DEBIAN_FRONTEND noninteractive
LABEL maintainer="EpicMorg DevTeam, developer@epicm.org"
LABEL org.opencontainers.image.vendor="EpicMorg DevTeam, developer@epicm.org"
LABEL org.opencontainers.image.authors="STAM, kasthack, Aleks-Z"
LABEL org.opencontainers.image.source="https://github.com/EpicMorg/docker"
LABEL org.opencontainers.image.url="https://github.com/EpicMorg/docker"
LABEL donate.crypto.TON="EQDvHXRK-K1ZieJhgTD9JZQk7xCnWzRbctYnUkWq1lZq1bUg"
LABEL donate.crypto.ETH="0x26a8443a694f08cdfec966aa6fd72c45068753ec"
LABEL donate.crypto.BTC="bc1querz8ug9asjmsuy6yn4a94a2athgprnu7e5zq2"
LABEL donate.crypto.LTC="ltc1qtwwacq8f0n76fer2y83wxu540hddnmf8cdrlvg"
LABEL donate.crypto.NVC="4SbMynYETyhmKdggu8f38ULU6yQKiJPuo6"
LABEL donate.crypto.DOGE="DHyfE1CZzWtyaQiaMmv6g4KvXVQRUgrYE6"
LABEL donate.crypto.PPC="pQWArPzYoLppNe7ew3QPfto1k1eq66BYUB"
LABEL donate.crypto.RVN="R9t2LKeLhDSZBKNgUzSDZAossA3UqNvbV3"
LABEL donate.crypto.ZEC="t1KRMMmwMSZth8vJcd2ZHtPEFKTQ74yVixE"
LABEL donate.crypto.XMR="884PqZ1gDjWW7fKxtbaeRoBeSh9EGZbkqUyLriWmuKbwLZrAJdYUs4wQxoVfEJoW7LBhdQMP9cFhZQpJr6xvg7esHLdCbb1"
##################################################################
#                  adding normal sources list
##################################################################
RUN rm -rfv /etc/apt/sources.list
COPY sources.list /etc/apt/sources.list

COPY usr/local/share/ca-certificates /usr/local/share/ca-certificates
RUN update-ca-certificates --fresh

##################################################################
#                  adding some utils
##################################################################
RUN apt-get update -y && \
    apt-get dist-upgrade -y && \
    apt-get install -y --allow-unauthenticated --no-install-recommends --no-install-suggests \
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
        wget \
        net-tools \
        iputils-ping


##################################################################
#                  installing php repo + smbclient
##################################################################
RUN apt-get update -y &&  \
    apt-get install -y --allow-unauthenticated --no-install-recommends --no-install-suggests \
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
#                  smb fix
##################################################################
RUN rm -frv /etc/samba/smb.conf /usr/share/samba/smb.conf
ADD smb.conf /etc/samba/
ADD smb.conf /usr/share/samba/
