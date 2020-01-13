FROM epicmorg/prod
LABEL maintainer="EpicMorg DevTeam, developer@epicm.org"
ARG DEBIAN_FRONTEND=noninteractive

##################################################################
#                   ARGuments
##################################################################
ENV BuildDocker true
ARG BUILDS_DIR=/builds
ARG SRC_DIR=${BUILDS_DIR}/src
ARG EXPORT_DIR=${BUILDS_DIR}/export

##################################################################
#                   Files and folders
##################################################################
RUN mkdir -p ${SRC_DIR} ${EXPORT_DIR} ${PRE_DIR}

##################################################################
#                   sid sources list
##################################################################
RUN rm /etc/apt/sources.list
COPY sources.list /etc/apt/sources.list
RUN apt autoremove -y && apt update && apt dist-upgrade -y

##################################################################
#                   retroarch deps
############################# ####################################
#                   deb creating
############################# ####################################
#                   nginx deps
##################################################################
RUN apt-get update && \
    apt install -y --allow-unauthenticated --allow-downgrades \
    build-essential \
    gcc-multilib \
    g++-multilib \
    libxkbcommon-dev \
    zlib1g-dev \
    libfreetype6-dev \
    libegl1-mesa-dev \
    libgles2-mesa-dev \
    libgbm-dev \
    nvidia-cg-toolkit \
    nvidia-cg-dev \
    libavcodec-dev \
    libsdl2-dev \
    libsdl-image1.2-dev \
    libxml2-dev yasm \
    devscripts \
    autoconf \
    automake \
    libtool \
    autotools-dev \
    dpkg-dev \
    fakeroot \
    checkinstall \
    dh-make \
    zlibc \
    zlib1g \
    zlib1g-dev \
    libssl-dev \
    libxml2-dev \
    libxslt-dev \
    libgd-dev \
    libpcre3-dev \
    libgeoip-dev \
    libkrb5-dev \
    libperl-dev \
    krb5-user \
    samba \
    luajit \
    liblua5.1-0-dev \
    libmaxminddb-dev \
    libpam0g-dev \
    libldap2-dev \
    libavformat-dev \
    libavfilter-dev \
    libswscale-dev \
    libavcodec-dev \
    libz-dev \
    libhiredis-dev \
    libzip-dev \
    libcrypto++-dev \
    libbz2-dev \
    libvpx-dev \
    libvpx6 \
    tcl

##################################################################
#                   steam runtime and ssdk
##################################################################
RUN cd / && \
    sudo mkdir valve && \
    cd valve && \
    sudo wget http://media.steampowered.com/client/runtime/steam-runtime-sdk_latest.tar.xz && \
    sudo tar xvf steam-runtime-sdk_latest.tar.xz && \
    sudo mv steam-runtime-sdk_2013-09-05 steam-runtime && \
    sudo chown root:root * -R && \
    cd steam-runtime && \
    printf '%s\n' 3 1 Y Y Y | ./setup.sh

##################################################################
#                   IP2Location support for prod nginx module
##################################################################
RUN cd ${SRC_DIR} && \
    git clone https://github.com/chrislim2888/IP2Location-C-Library.git ip2 && \
    cd ${SRC_DIR}/ip2 && \
    ./build.sh && \
    fakeroot checkinstall -D --pkgversion=$(date +%Y%m%d%H%M) --pakdir=${EXPORT_DIR} --maintainer="EpicMorg, developer@epicm.org" --pkgname=ip2-custom  --conflicts=ip2 --install=yes -y && \
    rm -rfv ${SRC_DIR}/*

##################################################################
#                   other   customisations
##################################################################


##################################################################
#                   cleaninig up
##################################################################
RUN apt clean -y && \
    apt autoclean -y && \
    rm -rfv /var/lib/apt/lists/* && \
    rm -rfv /var/cache/apt/archives/*.deb
