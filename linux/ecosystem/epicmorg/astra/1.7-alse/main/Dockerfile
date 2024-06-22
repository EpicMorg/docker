FROM epicmorg/astralinux:1.7-slim

ARG DEBIAN_FRONTEND=noninteractive
##################################################################
#                   ARGuments
##################################################################

#configured by dockerfile / .ENV
ARG P4_VERSION=r23.2
ARG P4_DOWNLOAD_URL=https://filehost.perforce.com/perforce/${P4_VERSION}/bin.linux26x86_64/p4

ARG SZ_VERSION=7z2400
ARG SZ_DOWNLOAD_URL=https://www.7-zip.org/a/${SZ_VERSION}-linux-x64.tar.xz

ARG LZGIT_VERSION=0.40.2
ARG LZGIT_DOWNLOAD_URL=https://github.com/jesseduffield/lazygit/releases/download/v${LZGIT_VERSION}/lazygit_${LZGIT_VERSION}_Linux_x86_64.tar.gz

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
    acl \
    bzip2 \
    cifs-utils \
    cron \
    curl \
    dos2unix \
    fontconfig \
    git \
    gzip \
    htop \
    iftop \
    iotop \
    iputils-ping \
    jq \
    libxml2-utils \
    libzip4 \
    locales \
    logrotate \
    lsb-release \
    lsof \
    lzip \
    lzma \
    lzop \
    mc \
    nano \
    nmap \
    openssl \
    p7zip-full \
    p7zip-rar \
    perl \
    portmap \
    procps \
    rename \
    rsync \
    ssl-cert \
    telnet \
    tini \
    tree \
    unrar \
    util-linux \
    uuid-runtime \
    wget \
    xz-utils \
    zip

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
    mv -fv /tmp/7z/7zz /usr/bin/

RUN echo "=============================================" && \
    echo 7zz $(7zz | head -4) && \
    echo 7z $(7z | head -4) && \
    echo "============================================="

##################################################################
#                   Install LazyGit official binary
##################################################################
RUN wget --no-check-certificate -nv --random-wait --retry-connrefused --continue -O /tmp/lazygit.tar.xz ${LZGIT_DOWNLOAD_URL} && \
    mkdir -p /tmp/lazygit && \
    tar -zxvf /tmp/lazygit.tar.xz -C /tmp/lazygit && \
    chmod +x /tmp/lazygit/lazygit && \
    mv -fv /tmp/lazygit/lazygit /usr/bin/

RUN echo "=============================================" && \
    echo lazygit $(lazygit --version) && \
    echo "============================================="

##################################################################
#                    dumb init
##################################################################
RUN wget -q --no-check-certificate -c ${DUMB_INIT_DOWNLOAD_URL} --random-wait -O /usr/bin/dumb-init && \
    chmod +x /usr/bin/dumb-init

RUN echo "=============================================" && \
    echo dumb-init $(dumb-init --version) && \
    echo "============================================="

##################################################################
#                    gosu for easy step-down from root
##################################################################
RUN wget -q --no-check-certificate -c ${GOSU_DOWNLOAD_URL} --random-wait -O /usr/local/bin/gosu && \
    chmod +x /usr/local/bin/gosu

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
