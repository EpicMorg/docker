FROM docker.io/epicmorg/astralinux:1.7-light
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
#                   installing utils
##################################################################
# Same set as debian:trixie. Not in the Astra 1.7 repositories, dropped:
#   lbzip2 cmatrix cmatrix-xfont clzip git-extras git-mediawiki git-crypt git-ftp iotop lzip nload pbzip2 plzip rar screenfetch rclone pev
# libzip5 (trixie) -> libzip4 (Astra 1.7).
RUN echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections && \
    apt-get update && \
    apt-get install -y \
        bzip2 \
        cron \
        curl \
        dos2unix \
        ffmpeg \
        fontconfig \
        fontconfig-config \
        git \
        git-flow \
        git-cvs \
        git-doc \
        git-email \
        git-lfs \
        gnupg \
        gnupg2 \
        graphicsmagick \
        gzip \
        htop \
        iftop \
        iperf \
        iperf3 \
        iputils-ping \
        jq \
        kmod \
        libxml2-dev \
        libxml2-utils \
        libatomic1 \
        libsvn-java \
        locales \
        lsb-release \
        lsof \
        lynx \
        lzma \
        lzop \
        mc \
        mercurial \
        nano \
        nmap \
        openssl \
        perl \
        procps \
        p7zip-full \
        p7zip-rar \
        rsync \
        screen \
        smbclient \
        subversion \
        telnet \
        tmux \
        vim \
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
        aptitude \
        sudo \
        cvs \
        python3-pip \
        python3-all \
        logrotate \
        subversion-tools

##################################################################
#                   installing fs-tools
##################################################################
# Not installable from the Astra 1.7 repositories, dropped: duperemove jmtpfs hfsprogs
RUN echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections && \
    apt-get install -y --allow-unauthenticated --no-install-recommends --no-install-suggests \
        parted \
        fuse2fs \
        e2fsck-static \
        keyutils \
        btrfs-progs \
        e2fsprogs \
        f2fs-tools \
        dosfstools \
        jfsutils \
        mdadm \
        util-linux \
        cryptsetup \
        lvm2 \
        nilfs-tools \
        ntfs-3g \
        reiserfsprogs \
        udftools \
        xfsprogs \
        xfsdump \
        zfsutils-linux

##################################################################
#                   git fresh binary
##################################################################
# git-core PPA suite = newest Ubuntu whose glibc is not newer than Astra's
# (bionic for Astra 1.7); a newer suite's git would not install here.
# Astra pins its own repositories at 900 (/etc/apt/preferences.d/astra.pin.pref),
# so a vendor repo at the default 500 never wins and git / git-lfs silently stay
# at Astra's versions. etc/apt/preferences.d/epicmorg-vendor-repos.pref lifts
# exactly git* (git-core PPA) and git-lfs (packagecloud) above that pin.
COPY etc/apt/preferences.d/epicmorg-vendor-repos.pref /etc/apt/preferences.d/epicmorg-vendor-repos.pref
RUN gpg --keyserver keyserver.ubuntu.com --recv-keys F911AB184317630C59970973E363C90F8F1B6217 && \
    gpg --export --output /etc/apt/keyrings/launchpad-git.gpg F911AB184317630C59970973E363C90F8F1B6217 && \
    rm -rfv /etc/apt/sources.list.d/launchpad_git-mainline.list && \
    rm -rfv /etc/apt/sources.list.d/launchpad_git-stable.list && \
    rm -rfv /etc/apt/sources.list.d/launchpad_git-mainline.sources && \
    rm -rfv /etc/apt/sources.list.d/launchpad_git-stable.sources

COPY etc/apt/sources.list.d/launchpad_git-mainline.sources /etc/apt/sources.list.d/launchpad_git-mainline.sources
COPY etc/apt/sources.list.d/launchpad_git-stable.sources /etc/apt/sources.list.d/launchpad_git-stable.sources
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
    rm -rfv /etc/apt/sources.list.d/github_git-lfs.list && \
    rm -rfv /etc/apt/sources.list.d/github_git-lfs.sources

COPY etc/apt/sources.list.d/github_git-lfs.sources /etc/apt/sources.list.d/github_git-lfs.sources
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
    rm -rfv /etc/apt/sources.list.d/github-cli.list && \
    rm -rfv /etc/apt/sources.list.d/github-cli.sources

COPY etc/apt/sources.list.d/github-cli.sources /etc/apt/sources.list.d/github-cli.sources
RUN apt-get update &&  \
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
#                   Assertions
##################################################################
# Fatal: the downloaded tools actually run on this glibc and the
# vendor-repo binaries (git PPA, git-lfs, gh) are the ones on PATH.
RUN set -eu; \
    for b in p4 7zz dumb-init gosu git git-lfs gh; do \
      command -v "$b" >/dev/null || { echo "FATAL: $b not on PATH" >&2; exit 1; }; \
    done; \
    p4 -V | tail -n 2; \
    gosu --version; \
    dumb-init --version; \
    git --version; \
    git lfs version; \
    v="$(dpkg-query -W -f='${Version}' git)"; \
    case "$v" in *ppa*) ;; *) echo "FATAL: git $v is not from the git-core PPA" >&2; exit 1 ;; esac; \
    v="$(dpkg-query -W -f='${Version}' git-lfs)"; \
    case "$v" in *astra*) echo "FATAL: git-lfs $v is Astra's, not packagecloud's" >&2; exit 1 ;; esac; \
    gh --version | head -n 1; \
    echo "OK: main assertions"

##################################################################
#                   Version after install
##################################################################
RUN echo "=============================================" && \
    echo $(lsb_release -d) && \
    echo "Astra: $(cat /etc/astra_version)" && \
    echo "Debian base: $(cat /etc/debian_version)" && \
    echo "============================================="

##################################################################
#                   other   customisations
##################################################################
