FROM epicmorg/debian:bullseye-slim
LABEL maintainer="EpicMorg DevTeam, developer@epicm.org"
ARG DEBIAN_FRONTEND=noninteractive

##################################################################
#                   ARGuments
##################################################################

ARG P4_VERSION=r23.2
ARG P4_DOWNLOAD_URL=https://filehost.perforce.com/perforce/${P4_VERSION}/bin.linux26x86_64/p4

ARG SZ_VERSION=7z2407
ARG SZ_DOWNLOAD_URL=https://www.7-zip.org/a/${SZ_VERSION}-linux-x64.tar.xz
ARG SZ_TEMP=/tmp/${SZ_VERSION}-linux-x64.tar.xz

ARG LAZYGIT_VERSION=0.42.0
ARG LAZYGIT_DOWNLOAD_URL=https://github.com/jesseduffield/lazygit/releases/download/v${LAZYGIT_VERSION}/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz
ARG LAZYGIT_TEMP=/tmp/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz

ARG LAZYCLI_VERSION=0.1.15
ARG LAZYCLI_DOWNLOAD_URL=https://github.com/jesseduffield/lazycli/releases/download/v${LAZYCLI_VERSION}/lazycli-linux-x64.tar.gz
ARG LAZYCLI_TEMP=/tmp/lazycli-linux-x64.tar.gz

ARG LAZYNPM_VERSION=0.1.4
ARG LAZYNPM_DOWNLOAD_URL=https://github.com/jesseduffield/lazynpm/releases/download/v${LAZYNPM_VERSION}/lazynpm_${LAZYNPM_VERSION}_Linux_x86_64.tar.gz
ARG LAZYNPM_TEMP=/tmp/lazynpm_${LAZYNPM_VERSION}_Linux_x86_64.tar.gz

ARG LAZYDOCKER_VERSION=0.23.3
ARG LAZYDOCKER_DOWNLOAD_URL=https://github.com/jesseduffield/lazydocker/releases/download/v${LAZYDOCKER_VERSION}/lazydocker_${LAZYDOCKER_VERSION}_Linux_x86_64.tar.gz
ARG LAZYDOCKER_TEMP=/tmp/lazydocker_${LAZYDOCKER_VERSION}_Linux_x86_64.tar.gz

ARG DUMB_INIT_VERSION=1.2.5
ARG DUMB_INIT_DOWNLOAD_URL=https://github.com/Yelp/dumb-init/releases/download/v${DUMB_INIT_VERSION}/dumb-init_${DUMB_INIT_VERSION}_x86_64

ARG GOSU_VER=1.17
ARG GOSU_DOWNLOAD_URL=https://github.com/tianon/gosu/releases/download/${GOSU_VER}/gosu-amd64


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
#RUN echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections && \
#    apt-get install -y --allow-unauthenticated \
#    btrfs-progs \
#    exfat-utils \
#    e2fsprogs \
#    f2fs-tools \
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
#                   git fresh binary
##################################################################
RUN gpg --keyserver keyserver.ubuntu.com --recv-keys A1715D88E1DF1F24 && \
    gpg --export --output /etc/apt/keyrings/launchpad-git.gpg A1715D88E1DF1F24 && \
    rm -rfv /etc/apt/sources.list.d/launchpad_git-mainline.list && \
    rm -rfv /etc/apt/sources.list.d/launchpad_git-stable.list
COPY etc/apt/sources.list.d/launchpad_git-mainline.list /etc/apt/sources.list.d/launchpad_git-mainline.list
COPY etc/apt/sources.list.d/launchpad_git-stable.list /etc/apt/sources.list.d/launchpad_git-stable.list
RUN apt-get update &&  \
    apt-get install -y --allow-unauthenticated \
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
    apt-get install -y --allow-unauthenticated \
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
RUN curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo gpg --dearmor -o /etc/apt/keyrings/githubcli-archive-keyring.gpg && \
    chmod go+r /etc/apt/keyrings/githubcli-archive-keyring.gpg && \
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list && \
    apt-get update &&  \
    apt-get install -y --allow-unauthenticated \
    gh

RUN echo "=============================================" && \
    echo gh $(gh --version) && \
    echo "============================================="

##################################################################
#                   Install p4client
##################################################################
ADD ${P4_DOWNLOAD_URL} /usr/local/bin
RUN chmod +x /usr/local/bin/p4

##################################################################
#                   Install 7z official binary
##################################################################
ADD ${SZ_DOWNLOAD_URL} /tmp
RUN mkdir -p /usr/local/7z-${SZ_VERSION} && \
    tar -xf ${SZ_TEMP} --directory /usr/local/7z-${SZ_VERSION} && \
    chmod +x -R /usr/local/7z-${SZ_VERSION}&& \
    ln -sfv /usr/local/7z-${SZ_VERSION}/7zz /usr/local/bin/7zz  && \
    ln -sfv /usr/local/7z-${SZ_VERSION}/7zzs /usr/local/bin/7zzs

RUN echo "=============================================" && \
    echo 7zz $(7zz | head -4) && \
    echo 7z $(7z | head -4) && \
    echo "============================================="

##################################################################
#                   Install LazyGit official binary
##################################################################
ADD ${LAZYGIT_DOWNLOAD_URL} /tmp
RUN mkdir -p /usr/local/lazygit-${LAZYGIT_VERSION} && \
    tar -xzf ${LAZYGIT_TEMP} --directory /usr/local/lazygit-${LAZYGIT_VERSION} && \
    chmod +x -R /usr/local/lazygit-${LAZYGIT_VERSION} && \
    ln -sfv /usr/local/lazygit-${LAZYGIT_VERSION}/lazygit /usr/local/bin/lazygit

RUN echo "=============================================" && \
    echo lazygit $(lazygit --version) && \
    echo "============================================="

##################################################################
#                   Install LazyCLI official binary
##################################################################
ADD ${LAZYCLI_DOWNLOAD_URL} /tmp
RUN mkdir -p /usr/local/lazycli-${LAZYCLI_VERSION} && \
    tar -xzf ${LAZYCLI_TEMP} --directory /usr/local/lazycli-${LAZYCLI_VERSION} && \
    chmod +x -R /usr/local/lazycli-${LAZYCLI_VERSION} && \
    ln -sfv /usr/local/lazycli-${LAZYCLI_VERSION}/lazycli /usr/local/bin/lazycli

RUN echo "=============================================" && \
    echo lazycli $(lazycli --version) && \
    echo "============================================="

##################################################################
#                   Install LazyNPM official binary
##################################################################
ADD ${LAZYNPM_DOWNLOAD_URL} /tmp
RUN mkdir -p /usr/local/lazynpm-${LAZYNPM_VERSION} && \
    tar -xzf ${LAZYNPM_TEMP} --directory /usr/local/lazynpm-${LAZYNPM_VERSION} && \
    chmod +x -R /usr/local/lazynpm-${LAZYNPM_VERSION} && \
    ln -sfv /usr/local/lazynpm-${LAZYNPM_VERSION}/lazynpm /usr/local/bin/lazynpm

RUN echo "=============================================" && \
    echo lazynpm $(lazynpm --version) && \
    echo "============================================="

##################################################################
#                   Install LazyDocker official binary
##################################################################
ADD ${LAZYDOCKER_DOWNLOAD_URL} /tmp
RUN mkdir -p /usr/local/lazydocker-${LAZYDOCKER_VERSION} && \
    tar -xzf ${LAZYDOCKER_TEMP} --directory /usr/local/lazydocker-${LAZYDOCKER_VERSION} && \
    chmod +x -R /usr/local/lazydocker-${LAZYDOCKER_VERSION} && \
    ln -sfv /usr/local/lazydocker-${LAZYDOCKER_VERSION}/lazydocker /usr/local/bin/lazydocker

RUN echo "=============================================" && \
    echo lazydocker $(lazydocker --version) && \
    echo "============================================="

##################################################################
#                    dumb init
##################################################################
RUN mkdir -p /usr/local/dumb-init-${DUMB_INIT_VERSION}/
ADD ${DUMB_INIT_DOWNLOAD_URL} /usr/local/dumb-init-${DUMB_INIT_VERSION}/
RUN chmod +x -R /usr/local/dumb-init-${DUMB_INIT_VERSION}/ && \
    ln -sfv /usr/local/dumb-init-${DUMB_INIT_VERSION}/dumb-init_${DUMB_INIT_VERSION}_x86_64 /usr/local/bin/dumb-init

RUN echo "=============================================" && \
    echo dumb-init $(dumb-init --version) && \
    echo "============================================="

##################################################################
#                    gosu for easy step-down from root
##################################################################
RUN mkdir -p /usr/local/gosu-${GOSU_VER}/
ADD ${GOSU_DOWNLOAD_URL} /usr/local/gosu-${GOSU_VER}/
RUN chmod +x -R /usr/local/gosu-${GOSU_VER}/ && \
    ln -sfv /usr/local/gosu-${GOSU_VER}/gosu-amd64  /usr/local/bin/gosu

RUN echo "=============================================" && \
    echo gosu $(gosu --version) && \
    echo "============================================="

##################################################################
#                   Generate ssl key
##################################################################
RUN openssl dhparam -out /etc/ssl/dhparam.pem 4096

##################################################################
#                  cleanup
##################################################################
RUN echo "clean up" && \
    apt-get clean -y && \
    apt-get autoclean -y && \
    rm -rfv /var/lib/apt/lists/* && \
    rm -rfv /tmp/* && \
    rm -rfv /var/cache/apt/archives/*.deb
