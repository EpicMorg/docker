################################################################################
# https://github.com/linuxserver/docker-code-server/pkgs/container/code-server
################################################################################
FROM ghcr.io/linuxserver/code-server:latest

LABEL maintainer="EpicMorg DevTeam, developer@epicm.org"
LABEL org.opencontainers.image.vendor="EpicMorg DevTeam, developer@epicm.org"
LABEL org.opencontainers.image.authors="STAM, kasthack, Aleks-Z"
LABEL org.opencontainers.image.source="https://github.com/EpicMorg/docker"
LABEL org.opencontainers.image.title="EpicMorg Debian (Light)"
LABEL org.opencontainers.image.description="Debian Trixie base by EpicMorg"
LABEL org.opencontainers.image.licenses="MIT"
LABEL org.opencontainers.image.documentation="https://github.com/EpicMorg/docker"
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
#                  Set temp user for advanced setup
#################################################################
USER root

##################################################################
#                  Create Base directory for various soft
##################################################################
ENV EMG_LOCAL_BASE_DIR=/usr/local/share/epicmorg
RUN mkdir -p ${EMG_LOCAL_BASE_DIR}
COPY usr/local/share/epicmorg ${EMG_LOCAL_BASE_DIR}

##################################################################
#                   prepare system
##################################################################
RUN for i in $(seq 1 8); do mkdir -p "/usr/share/man/man${i}"; done
RUN mkdir -p /etc/apt/keyrings

##################################################################
#                   ARGuments
##################################################################
ENV P4_VERSION=r24.1
ARG P4_BIN_DIR=${EMG_LOCAL_BASE_DIR}/p4/${P4_VERSION}/bin
ARG P4_DOWNLOAD_URL=https://filehost.perforce.com/perforce/${P4_VERSION}/bin.linux26x86_64/p4

ENV SZ_VERSION=7z2501
ARG SZ_BIN_DIR=${EMG_LOCAL_BASE_DIR}/7z/${SZ_VERSION}/bin
ARG SZ_DOWNLOAD_URL=https://www.7-zip.org/a/${SZ_VERSION}-linux-x64.tar.xz
ARG SZ_TEMP=/tmp/${SZ_VERSION}-linux-x64.tar.xz

ENV LAZYGIT_VERSION=0.42.0
ARG LAZYGIT_BIN_DIR=${EMG_LOCAL_BASE_DIR}/lazygit/${LAZYGIT_VERSION}/bin
ARG LAZYGIT_DOWNLOAD_URL=https://github.com/jesseduffield/lazygit/releases/download/v${LAZYGIT_VERSION}/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz
ARG LAZYGIT_TEMP=/tmp/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz

ENV LAZYCLI_VERSION=0.1.15
ARG LAZYCLI_BIN_DIR=${EMG_LOCAL_BASE_DIR}/lazycli/${LAZYCLI_VERSION}/bin
ARG LAZYCLI_DOWNLOAD_URL=https://github.com/jesseduffield/lazycli/releases/download/v${LAZYCLI_VERSION}/lazycli-linux-x64.tar.gz
ARG LAZYCLI_TEMP=/tmp/lazycli-linux-x64.tar.gz

ENV LAZYNPM_VERSION=0.1.4
ARG LAZYNPM_BIN_DIR=${EMG_LOCAL_BASE_DIR}/lazynpm/${LAZYNPM_VERSION}/bin
ARG LAZYNPM_DOWNLOAD_URL=https://github.com/jesseduffield/lazynpm/releases/download/v${LAZYNPM_VERSION}/lazynpm_${LAZYNPM_VERSION}_Linux_x86_64.tar.gz
ARG LAZYNPM_TEMP=/tmp/lazynpm_${LAZYNPM_VERSION}_Linux_x86_64.tar.gz

ENV LAZYDOCKER_VERSION=0.23.3
ARG LAZYDOCKER_BIN_DIR=${EMG_LOCAL_BASE_DIR}/lazydocker/${LAZYDOCKER_VERSION}/bin
ARG LAZYDOCKER_DOWNLOAD_URL=https://github.com/jesseduffield/lazydocker/releases/download/v${LAZYDOCKER_VERSION}/lazydocker_${LAZYDOCKER_VERSION}_Linux_x86_64.tar.gz
ARG LAZYDOCKER_TEMP=/tmp/lazydocker_${LAZYDOCKER_VERSION}_Linux_x86_64.tar.gz

ENV DUMB_INIT_VERSION=1.2.5
ARG DUMB_INIT_BIN_DIR=${EMG_LOCAL_BASE_DIR}/dumb-init/${DUMB_INIT_VERSION}/bin
ARG DUMB_INIT_DOWNLOAD_URL=https://github.com/Yelp/dumb-init/releases/download/v${DUMB_INIT_VERSION}/dumb-init_${DUMB_INIT_VERSION}_x86_64

ENV GOSU_VERSION=1.19
ARG GOSU_BIN_DIR=${EMG_LOCAL_BASE_DIR}/gosu/${GOSU_VERSION}/bin
ARG GOSU_DOWNLOAD_URL=https://github.com/tianon/gosu/releases/download/${GOSU_VERSION}/gosu-amd64

ENV BuildDocker true

##################################################################
#                   sources list
##################################################################
RUN rm -rfv /etc/apt/sources.list
RUN rm -rfv /etc/apt/sources.list.d/*.sources 
RUN rm -rfv /etc/locale.gen

COPY etc/apt/apt.conf.d/99-no-check-valid-until /etc/apt/apt.conf.d/99-no-check-valid-until
COPY etc/apt/apt.conf.d/98-allow-unauthenticated /etc/apt/apt.conf.d/98-allow-unauthenticated
COPY etc/apt/apt.conf.d/97-allow-cert-exp /etc/apt/apt.conf.d/97-allow-cert-exp
COPY etc/apt/apt.conf.d/96-apt-retries /etc/apt/apt.conf.d/96-apt-retries
COPY etc/apt/sources.list /etc/apt/sources.list
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
        python3 \
        python3-pip \
        python3-dev \
        cmatrix \
        cmatrix-xfont \
        console-cyrillic \
        cron \
        curl \
        git \
        gnupg \
        gnupg1 \
        gnupg2 \
        htop \
        iftop \
        iputils-ping \
        jq \
        kmod \
        locales \
        locate \
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
        rar \
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
        unrar \
        unrar-free \
        unzip \
        util-linux \
        uuid-runtime \
        wget \
        bzip2 \
        clzip \
        dos2unix \
        ffmpeg \
        fontconfig \
        graphicsmagick \
        gzip \
        libxml2-dev \
        libxml2-utils \
        libsvn-java \
        lzma \
        lzip \
        lzop \
        pbzip2 \
        plzip \
        p7zip-full \
        p7zip-rar \
        xz-utils \
        zip

RUN apt-key adv --keyserver keyserver.ubuntu.com --refresh-keys
RUN apt-key list  | grep "expired: " | sed -ne 's|pub .*/\([^ ]*\) .*|\1|gp' | xargs -n1  apt-key adv --keyserver keyserver.ubuntu.com --recv-keys

RUN update-ca-certificates --fresh

##################################################################
#                  update locales
##################################################################
RUN locale-gen

##################################################################
#                   Install p4client
##################################################################
RUN set -eux; \
    mkdir -p ${P4_BIN_DIR} && \
    aria2c \
        --conf-path=/usr/local/share/epicmorg/aria2/config/aria2.conf \
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
        --conf-path=/usr/local/share/epicmorg/aria2/config/aria2.conf \
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
        --conf-path=/usr/local/share/epicmorg/aria2/config/aria2.conf \
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
#                    gosu for easy step-down FROM docker.io/root
##################################################################
RUN set -eux; \
    mkdir -p ${GOSU_BIN_DIR} && \
    aria2c \
        --conf-path=/usr/local/share/epicmorg/aria2/config/aria2.conf \
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

