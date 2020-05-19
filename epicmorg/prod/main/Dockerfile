FROM debian:buster-slim
LABEL maintainer="EpicMorg DevTeam, developer@epicm.org"
ARG DEBIAN_FRONTEND=noninteractive

##################################################################
#                   buster sources list
##################################################################
COPY deb-multimedia-keyring.gpg /etc/apt/trusted.gpg.d/deb-multimedia-keyring.gpg
RUN rm /etc/apt/sources.list
COPY sources.list /etc/apt/sources.list
RUN apt update && apt dist-upgrade -y
COPY locale.gen /etc/locale.gen
RUN for i in $(seq 1 8); do mkdir -p "/usr/share/man/man${i}"; done

##################################################################
#                   perforce client binary
##################################################################
ARG P4_VERSION=r20.1
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
    ffmpeg \
    fontconfig \
    git \
    gnupg \
    gnupg2 \
    graphicsmagick \
    htop \
    iftop \
    iputils-ping \
    libsvn-java \
    kmod \
    libzip4 \
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
    ttf-dejavu \
    util-linux \
    uuid-runtime \
    wget \
    zip && \
    wget -nv --random-wait -c -P /usr/bin ${P4_DOWNLOAD_URL} && \
    chmod +x /usr/bin/p4 && \
    openssl dhparam -out /etc/ssl/dhparam.pem 4096

##################################################################
#                   cleaninig up
##################################################################
RUN apt clean -y && \
    apt autoclean -y && \
    rm -rfv /var/lib/apt/lists/* && \
    rm -rfv /var/cache/apt/archives/*.deb
