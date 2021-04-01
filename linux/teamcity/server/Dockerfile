FROM jetbrains/teamcity-server
LABEL maintainer="EpicMorg DevTeam, developer@epicm.org"
ARG DEBIAN_FRONTEND=noninteractive
USER root

##################################################################
#                  editing sources list
##################################################################
COPY sources.list /etc/apt/sources.list
COPY locale.gen /etc/locale.gen

##################################################################
#                   perforce client binary
##################################################################
ARG P4_VERSION=r20.2
ARG P4_DOWNLOAD_URL=http://www.perforce.com/downloads/perforce/${P4_VERSION}/bin.linux26x86_64/p4

##################################################################
#                   installing utils
##################################################################
RUN echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections && \
    apt-get update &&  \
    apt-get install -y --allow-unauthenticated \
    apt-transport-https \
    apt-utils \
    bash \
    binutils \
    ca-certificates \
    cmatrix \
    cmatrix-xfont \
    console-cyrillic \
    cron \
    curl \
    git \
    gnupg \
    gnupg2 \
    htop \
    iftop \
    iputils-ping \
    jq \
    kmod \
    locales \
    lsb-release \
    lsof \
    lynx \
    mc \
    mercurial \
    nano \
    nload \
    nmap \
    openssl \
    perl \
    procps \
    rsync \
    screenfetch \
    smbclient \
    software-properties-common \
    subversion \
    sudo \
    telnet \
    tini \
    tmux \
    tree \
    util-linux \
    uuid-runtime \
    wget \
    zip && \
    wget -nv --random-wait -c -P /usr/bin ${P4_DOWNLOAD_URL} && \
    chmod +x /usr/bin/p4
