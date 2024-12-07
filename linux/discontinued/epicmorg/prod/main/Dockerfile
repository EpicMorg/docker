FROM debian:buster-slim
LABEL maintainer="EpicMorg DevTeam, developer@epicm.org"
ARG DEBIAN_FRONTEND=noninteractive

##################################################################
#                   buster sources list
##################################################################
COPY trusted.gpg.d/deb-multimedia-keyring.gpg /etc/apt/trusted.gpg.d/deb-multimedia-keyring.gpg
COPY trusted.gpg.d/githubcli-archive-keyring.gpg /etc/apt/trusted.gpg.d/githubcli-archive-keyring.gpg

RUN rm /etc/apt/sources.list
COPY sources.list.d/sources.list /etc/apt/sources.list

RUN apt-get update && apt-get dist-upgrade -y

COPY etc/locale.gen /etc/locale.gen

RUN for i in $(seq 1 8); do mkdir -p "/usr/share/man/man${i}"; done

##################################################################
#                   perforce client binary
##################################################################
ARG P4_VERSION=r23.2
ARG P4_DOWNLOAD_URL=https://www.perforce.com/downloads/perforce/${P4_VERSION}/bin.linux26x86_64/p4

##################################################################
#                   7z official binary
##################################################################
ARG SZ_VERSION=7z2407
ARG SZ_DOWNLOAD_URL=https://www.7-zip.org/a/${SZ_VERSION}-linux-x64.tar.xz
ARG SZ_TEMP=/tmp/${SZ_VERSION}-linux-x64.tar.xz

##################################################################
#                   LazyGit official binary
##################################################################
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

##################################################################
#                   installing utils
##################################################################
RUN echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections && \
    apt-get update &&  \
    apt-get install -y --allow-unauthenticated --no-install-recommends --no-install-suggests \
    apt-transport-https \
    apt-utils \
    aptitude \
    bash \
    binutils \
    bzip2 \
    ca-certificates \
    cmatrix \
    cmatrix-xfont \
    console-cyrillic \
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
    nmap \
    openssl \
    perl \
    procps \
    pbzip2 \
    plzip \
    p7zip-full \
    p7zip-rar \
    python2.7 \
    python3 \
    python3-pil \
    python3-numpy \
    python3-pip \
    hugin-tools \
    rsync \
    rar \
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
    unrar \
    xz-utils \
    wget \
    zip

##################################################################
#                   git-lfs official binary
##################################################################
#RUN curl -s https://packagecloud.io/github/git-lfs/gpgkey | sudo gpg --no-default-keyring --keyring gnupg-ring:/etc/apt/trusted.gpg.d/git-lfs.gpg --import && \
RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 6B05F25D762E3157 && \
    rm -rfv /etc/apt/sources.list.d/github_git-lfs.list
COPY sources.list.d/github_git-lfs.list /etc/apt/sources.list.d/github_git-lfs.list
RUN apt-get update &&  \
    apt-get install -y --allow-unauthenticated --no-install-recommends --no-install-suggests \
    git \
    git-lfs && \
    git --version && \
    git-lfs --version

##################################################################
#                   gh official binary
##################################################################
COPY sources.list.d/github-cli.list /etc/apt/sources.list.d/github-cli.list
RUN apt-get update &&  \
    apt-get install -y --allow-unauthenticated --no-install-recommends --no-install-suggests \
    gh && \
    gh --version

##################################################################
#                   Install p4client
##################################################################
RUN wget -nv --random-wait -c -P /usr/bin ${P4_DOWNLOAD_URL} && \
    chmod +x /usr/bin/p4

##################################################################
#                   Install 7z official binary
##################################################################
RUN wget -nv --random-wait -c -O /tmp/7z.tar.xz ${SZ_DOWNLOAD_URL} && \
    mkdir -p /tmp/7z && \
    tar -xf /tmp/7z.tar.xz -C /tmp/7z && \
    chmod +x /tmp/7z/7zz && \
    mv -fv /tmp/7z/7zz /usr/bin/ && \
    7zz | head -4 && \
    7z | head -4

##################################################################
#                   Install LazyGit official binary
##################################################################
RUN wget -nv --random-wait -c -O /tmp/lazygit.tar.xz ${LAZYGIT_DOWNLOAD_URL} && \
    mkdir -p /tmp/lazygit && \
    tar -zxvf /tmp/lazygit.tar.xz -C /tmp/lazygit && \
    chmod +x /tmp/lazygit/lazygit && \
    mv -fv /tmp/lazygit/lazygit /usr/bin/ && \
    echo "lazygit version:" && \
    lazygit --version



##################################################################
#                   cleaninig up
##################################################################
RUN apt clean -y && \
    apt autoclean -y && \
    rm -rfv /var/lib/apt/lists/* && \
    rm -rfv /tmp/* && \
    rm -rfv /var/cache/apt/archives/*.deb
