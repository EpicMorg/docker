FROM zabbix/zabbix-java-gateway:7.2-ubuntu-latest
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

USER root

##################################################################
#                  editing sources list
##################################################################
COPY sources.list /etc/apt/sources.list
COPY locale.gen /etc/locale.gen

##################################################################
#                   installing utils
##################################################################
RUN apt-get update -y && \
    apt-get install -y --allow-unauthenticated --no-install-recommends --no-install-suggests \
        acl \
        apt-transport-https \
        apt-utils \
        aptitude  \
        ca-certificates \
        console-cyrillic \
        curl \
        dos2unix \
        fontconfig \
        gnupg \
        htop \
        iftop \
        iotop \
        iperf \
        iperf3 \
        iputils-ping \
        jq \
        locales \
        logrotate \
        lsb-release \
        lsof \
        lynx \
        mc \
        nano \
        nmap \
        openssl \
        pev \
        php-cli \
        php-curl \
        procps \
        smbclient \
        sudo \
        telnet \
        tmux \
        util-linux \
        uuid-runtime \
        wget

RUN echo "zabbix ALL=(ALL) NOPASSWD: /usr/bin/nmap" > /etc/sudoers.d/zabbix

COPY usr/local/share/ca-certificates /usr/local/share/ca-certificates
RUN update-ca-certificates --fresh

COPY usr/local/share/ca-certificates /usr/local/share/ca-certificates
RUN update-ca-certificates --fresh
USER zabbix
