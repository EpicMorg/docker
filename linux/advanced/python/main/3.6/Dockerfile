FROM python:3.6-bullseye

ARG DEBIAN_FRONTEND=noninteractive
LABEL maintainer="EpicMorg DevTeam, developer@epicm.org"
LABEL org.opencontainers.image.vendor="EpicMorg DevTeam, developer@epicm.org"
LABEL org.opencontainers.image.authors="STAM, kasthack, Aleks-Z"
LABEL org.opencontainers.image.source="https://github.com/EpicMorg/docker"
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

##################################################################
#                   prepare system
##################################################################
RUN for i in $(seq 1 8); do mkdir -p "/usr/share/man/man${i}"; done

##################################################################
#                   sources list
##################################################################
RUN rm -rfv /etc/apt/sources.list
RUN rm -rfv /etc/locale.gen

COPY etc/apt/trusted.gpg.d/deb-multimedia-keyring.gpg /etc/apt/trusted.gpg.d/deb-multimedia-keyring.gpg
COPY etc/apt/apt.conf.d/99-no-check-valid-until /etc/apt/apt.conf.d/99-no-check-valid-until
COPY etc/apt/sources.list /etc/apt/sources.list
COPY etc/locale.gen /etc/locale.gen

RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get dist-upgrade -y

##################################################################
#                   installing utils
##################################################################
RUN echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections && \
    apt-get install -y --allow-unauthenticated \
    apt-transport-https \
    apt-utils \
    gnupg \
    gnupg1 \
    gnupg2 \
    aptitude \
    bash \
    binutils \
    console-cyrillic \
    ca-certificates \
    locales \
    software-properties-common \
    sudo

RUN apt-key adv --keyserver keyserver.ubuntu.com --refresh-keys
RUN apt-key list  | grep "expired: " | sed -ne 's|pub .*/\([^ ]*\) .*|\1|gp' | xargs -n1  apt-key adv --keyserver keyserver.ubuntu.com --recv-keys

RUN update-ca-certificates

##################################################################
#                   perforce client binary
##################################################################
ENV P4_VERSION=r22.1
ENV P4_DOWNLOAD_URL=http://filehost.perforce.com/perforce/${P4_VERSION}/bin.linux26x86_64/p4

##################################################################
#                   7z official binary
##################################################################
ENV SZ_VERSION=7z2200
ENV SZ_DOWNLOAD_URL=https://www.7-zip.org/a/${SZ_VERSION}-linux-x64.tar.xz

##################################################################
#                   LazyGit official binary
##################################################################
ENV LZGIT_VERSION=0.34
ENV LZGIT_DOWNLOAD_URL=https://github.com/jesseduffield/lazygit/releases/download/v${LZGIT_VERSION}/lazygit_${LZGIT_VERSION}_Linux_x86_64.tar.gz

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
RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys A1715D88E1DF1F24 && \
    rm -rfv /etc/apt/sources.list.d/launchpad_git-mainline.list && \
    rm -rfv /etc/apt/sources.list.d/launchpad_git-stable.list
COPY etc/apt/sources.list.d/launchpad_git-mainline.list /etc/apt/sources.list.d/launchpad_git-mainline.list
COPY etc/apt/sources.list.d/launchpad_git-stable.list /etc/apt/sources.list.d/launchpad_git-stable.list
RUN apt-get update &&  \
    apt-get install -y --allow-unauthenticated \
    git && \
    git --version

##################################################################
#                   git-lfs official binary
##################################################################
#RUN curl -s https://packagecloud.io/github/git-lfs/gpgkey | sudo gpg --no-default-keyring --keyring gnupg-ring:/etc/apt/trusted.gpg.d/git-lfs.gpg --import && \
RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 6B05F25D762E3157 && \
    rm -rfv /etc/apt/sources.list.d/github_git-lfs.list
COPY etc/apt/sources.list.d/github_git-lfs.list /etc/apt/sources.list.d/github_git-lfs.list
RUN apt-get update &&  \
    apt-get install -y --allow-unauthenticated \
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
    apt-get install -y --allow-unauthenticated \
    gh && \
    gh --version

##################################################################
#                   Install p4client
##################################################################
RUN wget --no-check-certificate -nv --random-wait --retry-connrefused --continue -P /usr/bin ${P4_DOWNLOAD_URL} && \
    chmod +x /usr/bin/p4

##################################################################
#                   Install 7z official binary
##################################################################
RUN wget --no-check-certificate -nv --random-wait --retry-connrefused --continue -O /tmp/7z.tar.xz ${SZ_DOWNLOAD_URL} && \
    mkdir -p /tmp/7z && \
    tar -xf /tmp/7z.tar.xz -C /tmp/7z && \
    chmod +x /tmp/7z/7zz && \
    mv -fv /tmp/7z/7zz /usr/bin/ && \
    7zz | head -4 && \
    7z | head -4

##################################################################
#                   Install LazyGit official binary
##################################################################
RUN wget --no-check-certificate -nv --random-wait --retry-connrefused --continue -O /tmp/lazygit.tar.xz ${LZGIT_DOWNLOAD_URL} && \
    mkdir -p /tmp/lazygit && \
    tar -zxvf /tmp/lazygit.tar.xz -C /tmp/lazygit && \
    chmod +x /tmp/lazygit/lazygit && \
    mv -fv /tmp/lazygit/lazygit /usr/bin/ && \
    echo "lazygit version:" && \
    lazygit --version

##################################################################
#                   Generate ssl key
##################################################################
#RUN openssl dhparam -out /etc/ssl/dhparam.pem 4096

##################################################################
#                  update locales
##################################################################
RUN locale-gen

##################################################################
#                  cleanup
##################################################################
RUN apt-get purge policykit-1 -y && \
    apt-get clean -y && \
    apt-get autoclean -y && \
    rm -rfv /var/lib/apt/lists/* && \
    rm -rfv /tmp/* && \
    rm -rfv /var/cache/apt/archives/*.deb