FROM docker.io/nextcloud:19
ENV DEBIAN_FRONTEND noninteractive
LABEL maintainer="EpicMorg DevTeam, developer@epicm.org"
LABEL org.opencontainers.image.vendor="EpicMorg DevTeam, developer@epicm.org"
LABEL org.opencontainers.image.authors="STAM, kasthack, Aleks-Z"
LABEL org.opencontainers.image.source="https://github.com/EpicMorg/docker"
LABEL org.opencontainers.image.title="EpicMorg Debian (Light)"
LABEL org.opencontainers.image.description="Debian Trixie base by EpicMorg"
LABEL org.opencontainers.image.licenses="MIT"
LABEL org.opencontainers.image.documentation="https://github.com/EpicMorg/docker"
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
#                   prepare system
##################################################################
RUN for i in $(seq 1 8); do mkdir -p "/usr/share/man/man${i}"; done
RUN mkdir -p /etc/apt/keyrings

##################################################################
#                   sources list
##################################################################
RUN rm -rfv /etc/apt/sources.list
RUN rm -rfv /etc/apt/sources.list.d/*
RUN rm -rfv /etc/locale.gen

COPY etc/apt /etc/apt
COPY etc/locale.gen /etc/locale.gen
COPY usr/local/share/ca-certificates /usr/local/share/ca-certificates
RUN update-ca-certificates --fresh

##################################################################
#                  adding some utils
##################################################################
RUN apt-get update -y && \
    apt-get dist-upgrade -y && \
    apt-get install -y --allow-unauthenticated --no-install-recommends --no-install-suggests \
        apt-transport-https \
        apt-utils \
        curl \
        ca-certificates \
        ghostscript \
        nload \
        htop \
        mc \
        ffmpeg \
        nano \
        sudo \
        imagemagick \
        imagemagick-common \
        sqlite3 \
        smbclient \
        libsmbclient \
        wget \
        net-tools \
        iputils-ping \
        aria2 \
        libsmbclient-dev \
        libmagickwand-dev \
        libmagickcore-dev \
        libc-client-dev \
        libkrb5-dev \
        libsqlite3-dev \
        libssl-dev && \
    pecl channel-update pecl.php.net && \
    pecl install inotify smbclient && \
    docker-php-ext-configure imap --with-kerberos --with-imap-ssl && \
    docker-php-ext-install imap fileinfo bz2 intl ftp pdo_sqlite && \
    docker-php-ext-enable inotify smbclient imap fileinfo bz2 intl ftp pdo_sqlite && \
    apt-get remove -y \
        libsmbclient-dev \
        libmagickwand-dev \
        libmagickcore-dev \
        libc-client-dev \
        libkrb5-dev \
        libsqlite3-dev \
        libssl-dev && \
    apt-get clean -y && \
    apt-get autoclean -y && \
    rm -rfv /var/lib/apt/lists/* && \
    rm -rfv /tmp/* && \
    rm -rfv /var/cache/apt/archives/*.deb && \
    php -m && \
    php -v

##################################################################
#                  smb fix
##################################################################
RUN rm -frv /etc/samba/smb.conf /usr/share/samba/smb.conf
ADD smb.conf /etc/samba/
ADD smb.conf /usr/share/samba/
