FROM epicmorg/debian:jessie-slim
LABEL maintainer="EpicMorg DevTeam, developer@epicm.org"
ARG DEBIAN_FRONTEND=noninteractive

##################################################################
#                   installing utils
##################################################################
RUN echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections && \
    apt-get update && \
    apt-get install -y --allow-unauthenticated \
    bzip2 \
    cmatrix \
    cmatrix-xfont \
    cron \
    curl \
    clzip \
    dos2unix \
    ffmpeg \
    fontconfig \
    git \
    git-extras \
    git-flow \
    git-cvs \
    git-doc \
    git-email \
    git-mediawiki \
    git-crypt \
    git-lfs \
    git-ftp \
    git-hub \
    gnupg \
    gnupg2 \
    graphicsmagick \
    gzip \
    htop \
    iftop \
    iotop \
    iperf \
    iperf3 \
    iputils-ping \
    jq \
    kmod \
    libxml2-dev \
    libxml2-utils \
    lbzip2 \
    libsvn-java \
    locales \
    lsb-release \
    lsof \
    lynx \
    lzma \
    libzip4 \
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
    plzip \
    p7zip-full \
    p7zip-rar \
    rsync \
    rar \
    screenfetch \
    smbclient \
    subversion \
    telnet \
    tini \
    tmux \
    tree \
    util-linux \
    uuid-runtime \
    unrar \
    xz-utils \
    wget \
    zip

##################################################################
#                   installing fs-tools
##################################################################
RUN echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections && \
    apt-get update && \
    apt-get install -y --allow-unauthenticated \
    btrfs-progs \
    exfatprogs \
    e2fsprogs \
    f2fs-tools \
    dosfstools \
    hfsutils \
    hfsprogs \
    jfsutils \
    mdadm \
    util-linux \
    cryptsetup \
    lvm2 \
    nilfs-tools \
    ntfs-3g \
    reiser4progs \
    reiserfsprogs \
    udftools \
    xfsprogs \
    xfsdump


##################################################################
#                   Generate ssl key
##################################################################
RUN openssl dhparam -out /etc/ssl/dhparam.pem 4096

##################################################################
#                  cleanup
##################################################################
RUN apt-get purge policykit-1 -y && \
    apt-get clean -y && \
    apt-get autoclean -y && \
    rm -rfv /var/lib/apt/lists/* && \
    rm -rfv /tmp/* && \
    rm -rfv /var/cache/apt/archives/*.deb
