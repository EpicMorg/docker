FROM epicmorg/astralinux:1.7-slim

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
    apt-get install -y --allow-unauthenticated --no-install-recommends --no-install-suggests \
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
