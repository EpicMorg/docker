FROM epicmorg/debian:wheezy-slim
LABEL maintainer="EpicMorg DevTeam, developer@epicm.org"
ARG DEBIAN_FRONTEND=noninteractive

##################################################################
#                   perforce client binary
##################################################################
ENV P4_VERSION=r22.1
ENV P4_DOWNLOAD_URL=http://filehost.perforce.com/perforce/${P4_VERSION}/bin.linux26x86_64/p4

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
    cmatrix \
    cmatrix-xfont \
    cron \
    curl \
    clzip \
    cvs \
    dos2unix \
    ffmpeg \
    fontconfig \
    git \
    git-extras \
    git-flow \
    git-cvs \
    git-doc \
    git-email \
    git-ftp \
    gnupg \
    gnupg2 \
    graphicsmagick \
    gzip \
    htop \
    iftop \
    iotop \
    iperf \
    iputils-ping \
    jq \
    kmod \
    libxml2-dev \
    libxml2-utils \
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
    plzip \
    p7zip-full \
    p7zip-rar \
    python3-all \
    python-all \
    python-pip \
    python3-pip \
    rsync \
    rar \
    screenfetch \
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
    zip \
    pev

##################################################################
#                   installing fs-tools
##################################################################
#RUN echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections && \
#    apt-get install -y --allow-unauthenticated \
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
#                   gh official binary
##################################################################
RUN wget -c https://cli.github.com/packages/githubcli-archive-keyring.gpg -O /etc/apt/trusted.gpg.d/githubcli-archive-keyring.gpg && \
    chmod go+r /etc/apt/trusted.gpg.d/githubcli-archive-keyring.gpg && \
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/trusted.gpg.d/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list && \
    apt-get update &&  \
    apt-get install -y --allow-unauthenticated \
    gh && \
    gh --version

##################################################################
#                   Install p4client
##################################################################
RUN wget --no-check-certificate -nv --random-wait --retry-connrefused --continue -P /usr/bin ${P4_DOWNLOAD_URL} && \
    chmod +x /usr/bin/p4

##################################################################
#                    dumb init
##################################################################
ENV DUMB_INIT_VERSION=1.2.5
RUN wget -q --no-check-certificate -c https://github.com/Yelp/dumb-init/releases/download/v${DUMB_INIT_VERSION}/dumb-init_${DUMB_INIT_VERSION}_x86_64 --random-wait -O /usr/bin/dumb-init && \
    chmod +x /usr/bin/dumb-init && \
    dumb-init --version

##################################################################
#           grab gosu for easy step-down from root
##################################################################
ENV GOSU_VER 1.14
RUN wget -q --no-check-certificate -c https://github.com/tianon/gosu/releases/download/${GOSU_VER}/gosu-amd64 --random-wait -O /usr/local/bin/gosu && \
    chmod +x /usr/local/bin/gosu && \
    gosu --version

##################################################################
#                   Generate ssl key
##################################################################
RUN openssl dhparam -out /etc/ssl/dhparam.pem 512

##################################################################
#                  cleanup
##################################################################
RUN apt-get purge policykit-1 -y && \
    apt-get clean -y && \
    apt-get autoclean -y && \
    rm -rfv /var/lib/apt/lists/* && \
    rm -rfv /tmp/* && \
    rm -rfv /var/cache/apt/archives/*.deb
