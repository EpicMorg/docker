FROM docker.io/epicmorg/debian:buster-light
LABEL maintainer="EpicMorg DevTeam, developer@epicm.org"
ARG DEBIAN_FRONTEND=noninteractive

##################################################################
#                   ARGuments
##################################################################
RUN echo "Default folder for installation of customized soft is: ${EMG_LOCAL_BASE_DIR}"

ENV P4_VERSION=r26.1
ARG P4_BIN_DIR=${EMG_LOCAL_BASE_DIR}/p4/${P4_VERSION}/bin
ARG P4_DOWNLOAD_URL=https://filehost.perforce.com/perforce/${P4_VERSION}/bin.linux26x86_64/p4

ENV SZ_VERSION=7z2602
ARG SZ_BIN_DIR=${EMG_LOCAL_BASE_DIR}/7z/${SZ_VERSION}/bin
ARG SZ_DOWNLOAD_URL=https://www.7-zip.org/a/${SZ_VERSION}-linux-x64.tar.xz
ARG SZ_TEMP=/tmp/${SZ_VERSION}-linux-x64.tar.xz

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
    apt-get install -y --allow-unauthenticated --no-install-recommends --no-install-suggests \
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
    lzip \
    lzop \
    mc \
    mercurial \
    nano \
    nload \
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
    tmux \
    tree \
    util-linux \
    uuid-runtime \
    unrar \
    xz-utils \
    wget \
    zip \
    tini \
    libzip4 \
    acl \
    aptitude  \
    sudo  \
    cvs \
    python-pip \
    python3-pip \
    python3-all \
    python-all \
    rclone \
    logrotate \
    subversion-tools \
    pev

##################################################################
#                   installing fs-tools
##################################################################
RUN echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections && \
    apt-get install -y --allow-unauthenticated --no-install-recommends --no-install-suggests \
    btrfs-progs \
    exfat-utils \
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
#                   git fresh binary
##################################################################
RUN gpg --keyserver keyserver.ubuntu.com --recv-keys A1715D88E1DF1F24 && \
    gpg --export --output /etc/apt/keyrings/launchpad-git.gpg A1715D88E1DF1F24 && \
    rm -rfv /etc/apt/sources.list.d/launchpad_git-mainline.list && \
    rm -rfv /etc/apt/sources.list.d/launchpad_git-stable.list
COPY etc/apt/sources.list.d/launchpad_git-mainline.list /etc/apt/sources.list.d/launchpad_git-mainline.list
COPY etc/apt/sources.list.d/launchpad_git-stable.list /etc/apt/sources.list.d/launchpad_git-stable.list
RUN apt-get update &&  \
    apt-get install -y --allow-unauthenticated --no-install-recommends --no-install-suggests \
    git

RUN echo "=============================================" && \
    echo git $(git --version) && \
    echo "============================================="

##################################################################
#                   git-lfs official binary
##################################################################
RUN curl -fsSL https://packagecloud.io/github/git-lfs/gpgkey | gpg --dearmor > /etc/apt/keyrings/github_git-lfs-archive-keyring.gpg && \
    rm -rfv /etc/apt/sources.list.d/github_git-lfs.list
COPY etc/apt/sources.list.d/github_git-lfs.list /etc/apt/sources.list.d/github_git-lfs.list
RUN apt-get update &&  \
    apt-get install -y --allow-unauthenticated --no-install-recommends --no-install-suggests \
    git \
    git-lfs && \
    git-lfs install --skip-repo

RUN echo "=============================================" && \
    echo git $(git --version) && \
    echo git-lfs $(git-lfs --version) && \
    echo "============================================="

##################################################################
#                   gh official binary
##################################################################
RUN curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | gpg --batch --yes --dearmor -o /etc/apt/keyrings/githubcli-archive-keyring.gpg && \
    chmod go+r /etc/apt/keyrings/githubcli-archive-keyring.gpg && \
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list && \
    apt-get update &&  \
    apt-get install -y --allow-unauthenticated --no-install-recommends --no-install-suggests \
    gh

RUN echo "=============================================" && \
    echo gh $(gh --version) && \
    echo "============================================="

##################################################################
#                   Install p4client
##################################################################
RUN set -eux; \
    mkdir -p ${P4_BIN_DIR} && \
    aria2c \
        --conf-path="/usr/local/share/epicmorg/aria2/config/aria2.conf" \
        --user-agent="$(shuf -n 1 /usr/local/share/epicmorg/user-agents/user-agents.txt)" \
        -d ${P4_BIN_DIR} \
        "${P4_DOWNLOAD_URL}" && \
    chmod +x ${P4_BIN_DIR}/p4

ENV PATH="${P4_BIN_DIR}:${PATH}"

##################################################################
#                   Install 7z official binary
##################################################################
RUN set -eux; \
    mkdir -p ${SZ_BIN_DIR} && \
    aria2c \
        --conf-path="/usr/local/share/epicmorg/aria2/config/aria2.conf" \
        --user-agent="$(shuf -n 1 /usr/local/share/epicmorg/user-agents/user-agents.txt)" \
        -d / \
        -o ${SZ_TEMP} \
        "${SZ_DOWNLOAD_URL}" && \
    tar -xf ${SZ_TEMP} --directory ${SZ_BIN_DIR} && \
    chmod +x ${SZ_BIN_DIR}/7zz && \
    chmod +x ${SZ_BIN_DIR}/7zzs && \
    find ${SZ_BIN_DIR} -maxdepth 1 -mindepth 1 ! -name '7zz' ! -name '7zzs' -exec mv {} ${SZ_BIN_DIR}/.. \; && \
    rm -rfv ${SZ_TEMP}

ENV PATH="${SZ_BIN_DIR}:${PATH}"

RUN echo "=============================================" && \
    echo 7zz $(7zz | head -4) && \
    echo 7z $(7z | head -4) && \
    echo "============================================="

##################################################################
#                    dumb init
##################################################################
RUN set -eux; \
    mkdir -p ${DUMB_INIT_BIN_DIR} && \
    aria2c \
        --conf-path="/usr/local/share/epicmorg/aria2/config/aria2.conf" \
        --user-agent="$(shuf -n 1 /usr/local/share/epicmorg/user-agents/user-agents.txt)" \
        -d / \
        -o ${DUMB_INIT_BIN_DIR}/dumb-init \
        "${DUMB_INIT_DOWNLOAD_URL}" && \
    chmod +x ${DUMB_INIT_BIN_DIR}/dumb-init

ENV PATH="${DUMB_INIT_BIN_DIR}:${PATH}"

RUN echo "=============================================" && \
    echo dumb-init $(dumb-init --version) && \
    echo "============================================="

##################################################################
#                    gosu
##################################################################
RUN set -eux; \
    mkdir -p ${GOSU_BIN_DIR} && \
    aria2c \
        --conf-path="/usr/local/share/epicmorg/aria2/config/aria2.conf" \
        --user-agent="$(shuf -n 1 /usr/local/share/epicmorg/user-agents/user-agents.txt)" \
        -d / \
        -o ${GOSU_BIN_DIR}/gosu \
        "${GOSU_DOWNLOAD_URL}" && \
    chmod +x ${GOSU_BIN_DIR}/gosu

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
