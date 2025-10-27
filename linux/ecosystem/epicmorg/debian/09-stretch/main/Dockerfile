FROM docker.io/epicmorg/debian:stretch-slim
LABEL maintainer="EpicMorg DevTeam, developer@epicm.org"
ARG DEBIAN_FRONTEND=noninteractive

##################################################################
#                   ARGuments
##################################################################
RUN echo "Default folder for installation of customized soft is: ${EMG_LOCAL_BASE_DIR}"

ARG P4_VERSION=r16.2
ARG P4_BIN_DIR=${EMG_LOCAL_BASE_DIR}/p4/${P4_VERSION}/bin
ARG P4_DOWNLOAD_URL=https://filehost.perforce.com/perforce/${P4_VERSION}/bin.linux26x86_64/p4

ARG SZ_VERSION=7z2501
ARG SZ_BIN_DIR=${EMG_LOCAL_BASE_DIR}/7z/${SZ_VERSION}/bin
ARG SZ_DOWNLOAD_URL=https://www.7-zip.org/a/${SZ_VERSION}-linux-x64.tar.xz
ARG SZ_TEMP=/tmp/${SZ_VERSION}-linux-x64.tar.xz

ARG LAZYGIT_VERSION=0.42.0
ARG LAZYGIT_BIN_DIR=${EMG_LOCAL_BASE_DIR}/lazygit/${LAZYGIT_VERSION}/bin
ARG LAZYGIT_DOWNLOAD_URL=https://github.com/jesseduffield/lazygit/releases/download/v${LAZYGIT_VERSION}/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz
ARG LAZYGIT_TEMP=/tmp/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz

ARG LAZYCLI_VERSION=0.1.15
ARG LAZYCLI_BIN_DIR=${EMG_LOCAL_BASE_DIR}/lazycli/${LAZYCLI_VERSION}/bin
ARG LAZYCLI_DOWNLOAD_URL=https://github.com/jesseduffield/lazycli/releases/download/v${LAZYCLI_VERSION}/lazycli-linux-x64.tar.gz
ARG LAZYCLI_TEMP=/tmp/lazycli-linux-x64.tar.gz

ARG LAZYNPM_VERSION=0.1.4
ARG LAZYNPM_BIN_DIR=${EMG_LOCAL_BASE_DIR}/lazynpm/${LAZYNPM_VERSION}/bin
ARG LAZYNPM_DOWNLOAD_URL=https://github.com/jesseduffield/lazynpm/releases/download/v${LAZYNPM_VERSION}/lazynpm_${LAZYNPM_VERSION}_Linux_x86_64.tar.gz
ARG LAZYNPM_TEMP=/tmp/lazynpm_${LAZYNPM_VERSION}_Linux_x86_64.tar.gz

ARG LAZYDOCKER_VERSION=0.23.3
ARG LAZYDOCKER_BIN_DIR=${EMG_LOCAL_BASE_DIR}/lazydocker/${LAZYDOCKER_VERSION}/bin
ARG LAZYDOCKER_DOWNLOAD_URL=https://github.com/jesseduffield/lazydocker/releases/download/v${LAZYDOCKER_VERSION}/lazydocker_${LAZYDOCKER_VERSION}_Linux_x86_64.tar.gz
ARG LAZYDOCKER_TEMP=/tmp/lazydocker_${LAZYDOCKER_VERSION}_Linux_x86_64.tar.gz

ARG DUMB_INIT_VERSION=1.2.5
ARG DUMB_INIT_BIN_DIR=${EMG_LOCAL_BASE_DIR}/dumb-init/${DUMB_INIT_VERSION}/bin
ARG DUMB_INIT_DOWNLOAD_URL=https://github.com/Yelp/dumb-init/releases/download/v${DUMB_INIT_VERSION}/dumb-init_${DUMB_INIT_VERSION}_x86_64

ARG GOSU_VERSION=1.17
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

# Global disable ssl verify due very old dists
RUN git config --global http.sslVerify false

##################################################################
#                   installing fs-tools
##################################################################
#RUN echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections && \
#    apt-get install -y --allow-unauthenticated --no-install-recommends --no-install-suggests \
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
#                   git-lfs official binary
##################################################################
#RUN    wget --no-check-certificate -O - https://packagecloud.io/github/git-lfs/gpgkey | gpg --dearmor > /etc/apt/keyrings/github_git-lfs-archive-keyring.gpg && \ && \
RUN wget --no-check-certificate -O - https://packagecloud.io/github/git-lfs/gpgkey | gpg --dearmor > /etc/apt/trusted.gpg.d/github_git-lfs-archive-keyring.gpg && \
    chmod go+r /etc/apt/trusted.gpg.d/github_git-lfs-archive-keyring.gpg && \
    rm -rfv /etc/apt/sources.list.d/github_git-lfs.list
COPY etc/apt/sources.list.d/github_git-lfs.list /etc/apt/sources.list.d/github_git-lfs.list
RUN apt-get update &&  \
    apt-get install -y --allow-unauthenticated --no-install-recommends --no-install-suggests \
    git \
    git-lfs && \
    git --version && \
    git-lfs install --skip-repo && \
    git-lfs --version

##################################################################
#                   gh official binary
##################################################################
RUN wget -c https://cli.github.com/packages/githubcli-archive-keyring.gpg -O /etc/apt/trusted.gpg.d/githubcli-archive-keyring.gpg && \
    chmod go+r /etc/apt/trusted.gpg.d/githubcli-archive-keyring.gpg && \
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/trusted.gpg.d/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list && \
    apt-get update &&  \
    apt-get install -y --allow-unauthenticated --no-install-recommends --no-install-suggests \
    gh && \
    gh --version

##################################################################
#                   Install p4client
##################################################################
RUN mkdir -p ${P4_BIN_DIR}
ADD ${P4_DOWNLOAD_URL} ${P4_BIN_DIR}
RUN chmod +x ${P4_BIN_DIR}/p4
ENV PATH="${P4_BIN_DIR}:${PATH}"

##################################################################
#                   Install 7z official binary
##################################################################
RUN mkdir -p ${SZ_BIN_DIR}
ADD ${SZ_DOWNLOAD_URL} /tmp

RUN tar -xf ${SZ_TEMP} --directory ${SZ_BIN_DIR} && \
    chmod +x ${SZ_BIN_DIR}/7zz && \
    chmod +x ${SZ_BIN_DIR}/7zzs && \
    find ${SZ_BIN_DIR} -maxdepth 1 -mindepth 1 ! -name '7zz' ! -name '7zzs' -exec mv {} ${SZ_BIN_DIR}/.. \;

ENV PATH="${SZ_BIN_DIR}:${PATH}"

RUN echo "=============================================" && \
    echo 7zz $(7zz | head -4) && \
    echo 7z $(7z | head -4) && \
    echo "============================================="

##################################################################
#                   Install LazyGit official binary
##################################################################
RUN mkdir -p ${LAZYGIT_BIN_DIR}
ADD ${LAZYGIT_DOWNLOAD_URL} /tmp

RUN tar -xzf ${LAZYGIT_TEMP} --directory ${LAZYGIT_BIN_DIR} && \
    chmod +x ${LAZYGIT_BIN_DIR}/lazygit && \
    find ${LAZYGIT_BIN_DIR} -maxdepth 1 -mindepth 1 ! -name 'lazygit' -exec mv {} ${LAZYGIT_BIN_DIR}/.. \;

ENV PATH="${LAZYGIT_BIN_DIR}:${PATH}"

RUN echo "=============================================" && \
    echo lazygit $(lazygit --version) && \
    echo "============================================="

##################################################################
#                   Install LazyCLI official binary
##################################################################
RUN mkdir -p ${LAZYCLI_BIN_DIR}
ADD ${LAZYCLI_DOWNLOAD_URL} /tmp

RUN tar -xzf ${LAZYCLI_TEMP} --directory ${LAZYCLI_BIN_DIR} && \
    chmod +x ${LAZYCLI_BIN_DIR}/lazycli && \
    find ${LAZYCLI_BIN_DIR} -maxdepth 1 -mindepth 1 ! -name 'lazycli' -exec mv {} ${LAZYCLI_BIN_DIR}/.. \;

ENV PATH="${LAZYCLI_BIN_DIR}:${PATH}"

RUN echo "=============================================" && \
    echo lazycli $(lazycli --version) && \
    echo "============================================="

##################################################################
#                   Install LazyNPM official binary
##################################################################
RUN mkdir -p ${LAZYNPM_BIN_DIR}
ADD ${LAZYNPM_DOWNLOAD_URL} /tmp

RUN tar -xzf ${LAZYNPM_TEMP} --directory ${LAZYNPM_BIN_DIR} && \
    chmod +x ${LAZYNPM_BIN_DIR}/lazynpm && \
    find ${LAZYNPM_BIN_DIR} -maxdepth 1 -mindepth 1 ! -name 'lazynpm' -exec mv {} ${LAZYNPM_BIN_DIR}/.. \;

ENV PATH="${LAZYNPM_BIN_DIR}:${PATH}"

RUN echo "=============================================" && \
    echo lazynpm $(lazynpm --version) && \
    echo "============================================="

##################################################################
#                   Install LazyDocker official binary
##################################################################
RUN mkdir -p ${LAZYDOCKER_BIN_DIR}
ADD ${LAZYDOCKER_DOWNLOAD_URL} /tmp

RUN tar -xzf ${LAZYDOCKER_TEMP} --directory ${LAZYDOCKER_BIN_DIR} && \
    chmod +x -R ${LAZYDOCKER_BIN_DIR}/lazydocker && \
    find ${LAZYDOCKER_BIN_DIR} -maxdepth 1 -mindepth 1 ! -name 'lazydocker' -exec mv {} ${LAZYDOCKER_BIN_DIR}/.. \;

ENV PATH="${LAZYDOCKER_BIN_DIR}:${PATH}"

RUN echo "=============================================" && \
    echo lazydocker $(lazydocker --version) && \
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
#                    gosu for easy step-down FROM docker.io/root
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
#                  Cleanup
##################################################################
RUN echo "clean up" && \
    apt-get clean -y && \
    apt-get autoclean -y && \
    rm -rfv /var/lib/apt/lists/* && \
    rm -rfv /var/cache/apt/archives/*.deb && \
    rm -rfv /root/tmp/* && \
    rm -rfv /tmp/*

RUN updatedb
