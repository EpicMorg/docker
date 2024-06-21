FROM epicmorg/astralinux:1.7-slim

ARG DEBIAN_FRONTEND=noninteractive

##################################################################
#                   update lists
##################################################################
RUN echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections && \
    apt-get update

##################################################################
#                   installing utils
##################################################################
RUN echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections && \
    apt-get install -y --allow-unauthenticated \
    acl \
    bzip2 \
    cifs-utils \
    cron \
    curl \
    dos2unix \
    fontconfig \
    git \
    gzip \
    htop \
    iftop \
    iotop \
    iputils-ping \
    jq \
    libxml2-utils \
    libzip4 \
    locales \
    logrotate \
    lsb-release \
    lsof \
    lzip \
    lzma \
    lzop \
    mc \
    nano \
    nmap \
    openssl \
    p7zip-full \
    p7zip-rar \
    perl \
    portmap \
    procps \
    rename \
    rsync \
    ssl-cert \
    telnet \
    tini \
    tree \
    unrar \
    util-linux \
    uuid-runtime \
    wget \
    xz-utils \
    zip

##################################################################
#                  cleanup
##################################################################
RUN echo "clean up" && \
    apt-get clean -y && \
    apt-get autoclean -y && \
    rm -rfv /var/lib/apt/lists/* && \
    rm -rfv /tmp/* && \
    rm -rfv /var/cache/apt/archives/*.deb
