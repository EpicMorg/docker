FROM docker.io/debian:bullseye-slim
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
ARG DEBIAN_FRONTEND=noninteractive

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

RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get dist-upgrade -y

##################################################################
#                   installing utils
##################################################################
RUN echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections && \
    apt-get install -y --allow-unauthenticated --no-install-recommends --no-install-suggests \
    apt-transport-https \
    apt-utils \
    aptitude \
    bash \
    binutils \
    ca-certificates \
    coreutils \
    curl \
    dirmngr \
    file \
    gnupg \
    gnupg1 \
    gnupg2 \
    locales \
    locate \
    rar \
    software-properties-common \
    sudo \
    unrar \
    unrar-free \
    unzip \
    wget \
    zip

RUN apt-key adv --keyserver keyserver.ubuntu.com --refresh-keys
RUN apt-key list  | grep "expired: " | sed -ne 's|pub .*/\([^ ]*\) .*|\1|gp' | xargs -n1  apt-key adv --keyserver keyserver.ubuntu.com --recv-keys

RUN update-ca-certificates --fresh

##################################################################
#                  update locales
##################################################################
RUN locale-gen

##################################################################
#                  Create Base directory for various soft
##################################################################
ENV EMG_LOCAL_BASE_DIR=/usr/local/share/epicmorg
ENV EMG_WELCOME_MESSAGE=true
ENV EMG_DONATION_MESSAGE=true
RUN mkdir -p ${EMG_LOCAL_BASE_DIR}
COPY usr/local/epicmorg ${EMG_LOCAL_BASE_DIR}
RUN chmod +x ${EMG_LOCAL_BASE_DIR}/welcome.sh && \
    echo '[ ! -z "$TERM" -a -x ${EMG_LOCAL_BASE_DIR}/welcome.sh -a -x ${EMG_LOCAL_BASE_DIR}/welcome.sh ] && ${EMG_LOCAL_BASE_DIR}/welcome.sh' >> /etc/bash.bashrc

##################################################################
#                  Preparew dhparam.pem (4096 bit)
##################################################################
ENV SSL_DHPARAM_FILE=/etc/ssl/dhparam.pem
COPY etc/ssl/dhparam.pem ${SSL_DHPARAM_FILE}
RUN openssl dhparam -in ${SSL_DHPARAM_FILE} -text -noout | grep bit

##################################################################
#                   Set default workdir
##################################################################
WORKDIR ${EMG_LOCAL_BASE_DIR}

##################################################################
#                  Cleanup
##################################################################
RUN echo "clean up" && \
    apt-get clean -y && \
    apt-get autoclean -y && \
    rm -rfv /var/lib/apt/lists/* && \
    rm -rfv /var/cache/apt/archives/*.deb && \
    rm -rfv /root/tmp/* && \
    rm -rfv /tmp/*

##################################################################
#                  update file db
##################################################################
RUN updatedb
