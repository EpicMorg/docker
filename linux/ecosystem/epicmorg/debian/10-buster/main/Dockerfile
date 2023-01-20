FROM epicmorg/debian:buster-slim
LABEL maintainer="EpicMorg DevTeam, developer@epicm.org"
ARG DEBIAN_FRONTEND=noninteractive

##################################################################
#                   perforce client binary
##################################################################
ENV P4_VERSION=r22.1
ENV P4_DOWNLOAD_URL=https://filehost.perforce.com/perforce/${P4_VERSION}/bin.linux26x86_64/p4

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
