FROM docker.io/epicmorg/debian:squeeze-light
LABEL maintainer="EpicMorg DevTeam, developer@epicm.org"
ARG DEBIAN_FRONTEND=noninteractive
LABEL org.opencontainers.image.title="EpicMorg Debian (Main)"

##################################################################
#                   ARGuments
##################################################################
RUN echo "Default folder for installation of customized soft is: ${EMG_LOCAL_BASE_DIR}"

ARG P4_VERSION=r16.2
ARG P4_BIN_DIR=${EMG_LOCAL_BASE_DIR}/p4/${P4_VERSION}/bin
ARG P4_DOWNLOAD_URL=https://filehost.perforce.com/perforce/${P4_VERSION}/bin.linux26x86_64/p4

ARG DUMB_INIT_VERSION=1.2.5
ARG DUMB_INIT_BIN_DIR=${EMG_LOCAL_BASE_DIR}/dumb-init/${DUMB_INIT_VERSION}/bin
ARG DUMB_INIT_DOWNLOAD_URL=https://github.com/Yelp/dumb-init/releases/download/v${DUMB_INIT_VERSION}/dumb-init_${DUMB_INIT_VERSION}_x86_64

ARG GOSU_VERSION=1.19
ARG GOSU_BIN_DIR=${EMG_LOCAL_BASE_DIR}/gosu/${GOSU_VERSION}/bin
ARG GOSU_DOWNLOAD_URL=https://github.com/tianon/gosu/releases/download/${GOSU_VERSION}/gosu-amd64

##################################################################
#                   update lists
##################################################################
RUN echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections && \
    apt-get update

##################################################################
#                   installing utils
##################################################################
RUN echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections && \
    apt-get install -y --allow-unauthenticated --no-install-recommends \
    acl \
    bzip2 \
    cmatrix \
    cmatrix-xfont \
    cron \
    curl \
    cvs \
    dos2unix \
    ffmpeg \
    fontconfig \
    git \
    git-flow \
    git-cvs \
    git-doc \
    git-email \
    gnupg \
    gnupg2 \
    graphicsmagick \
    gzip \
    htop \
    iftop \
    iotop \
    iperf \
    iputils-ping \
    libxml2-dev \
    libxml2-utils \
    lbzip2 \
    libsvn-java \
    locales \
    lsb-release \
    lsof \
    lynx \
    lzma \
    lzip \
    lzop \
    mc \
    mercurial \
    nano \
    nload \
    ntop \
    nmap \
    openssl \
    perl \
    procps \
    pbzip2 \
    p7zip-full \
    p7zip-rar \
    python3-all \
    python-all \
    python-pip \
    rsync \
    rar \
    smbclient \
    subversion \
    telnet \
    tmux \
    tree \
    util-linux \
    uuid-runtime \
    unrar \
    xz-utils \
    wget \
    aptitude  \
    sudo  \
    logrotate \
    subversion-tools \
    zip

RUN aptitude remove '~njava' -y

# Global disable ssl verify due very old dists
RUN git config --global http.sslVerify false

##################################################################
#                   installing fs-tools
##################################################################
#RUN echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections && \
#    apt-get install -y --allow-unauthenticated --no-install-recommends \
#    btrfs-tools \
#    exfat-utils \
#    e2fsprogs \
#    dosfstools \
#    hfsutils \
#    hfsprogs \
#    jfsutils \
#    mdadm \
#    util-linux \
#    cryptsetup \
#    lvm2 \
#    nilfs-tools \
#    ntfs-3g \
#    reiser4progs \
#    reiserfsprogs \
#    udftools \
#    xfsprogs \
#    xfsdump

##################################################################
#                   Install p4client
##################################################################
RUN mkdir -p ${P4_BIN_DIR}
ADD ${P4_DOWNLOAD_URL} ${P4_BIN_DIR}
RUN chmod +x ${P4_BIN_DIR}/p4

ENV PATH="${P4_BIN_DIR}:${PATH}"

##################################################################
#                   Install 7z binary
##################################################################
RUN echo "=============================================" && \
    echo 7z $(7z | head -4) && \
    echo "============================================="

##################################################################
#                    dumb init
##################################################################
RUN mkdir -p ${DUMB_INIT_BIN_DIR}
ADD ${DUMB_INIT_DOWNLOAD_URL} ${DUMB_INIT_BIN_DIR}
RUN mv -fv ${DUMB_INIT_BIN_DIR}/dumb-init_${DUMB_INIT_VERSION}_x86_64 ${DUMB_INIT_BIN_DIR}/dumb-init && \
    chmod +x ${DUMB_INIT_BIN_DIR}/dumb-init

ENV PATH="${DUMB_INIT_BIN_DIR}:${PATH}"

RUN echo "=============================================" && \
    echo dumb-init $(dumb-init --version) && \
    echo "============================================="

##################################################################
#                    gosu
##################################################################
RUN mkdir -p ${GOSU_BIN_DIR}
ADD ${GOSU_DOWNLOAD_URL} ${GOSU_BIN_DIR}
RUN mv -fv ${GOSU_BIN_DIR}/gosu-amd64  ${GOSU_BIN_DIR}/gosu && \
    chmod +x -R ${GOSU_BIN_DIR}/gosu

ENV PATH="${GOSU_BIN_DIR}:${PATH}"

RUN echo "=============================================" && \
    echo gosu $(gosu --version) && \
    echo "============================================="

##################################################################
#                   Version after install
##################################################################
RUN echo "=============================================" && \
    echo $(lsb_release -d) && \
    echo "Version: $(cat /etc/debian_version)" && \
    echo "============================================="

##################################################################
#                   other   customisations
##################################################################
 