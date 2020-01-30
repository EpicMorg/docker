FROM epicmorg/edge
LABEL maintainer="EpicMorg DevTeam, developer@epicm.org"
ARG DEBIAN_FRONTEND=noninteractive

##################################################################
#   Build-time metadata as defined at http://label-schema.org
##################################################################
ARG BUILD_DATE=today
ARG VCS_REF=master
ARG VERSION=latest
LABEL org.label-schema.build-date=$BUILD_DATE \
          org.label-schema.name="Docker Scripts" \
          org.label-schema.description="Image for our docker containers." \
          org.label-schema.url="https://ww.epicm.org/" \
          org.label-schema.vcs-ref=$VCS_REF \
          org.label-schema.vcs-url="https://github.com/EpicMorg/docker-scripts" \
          org.label-schema.vendor="EpicMorg" \
          org.label-schema.version=$VERSION \
          org.label-schema.schema-version="1.0"

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
RUN apt update && \
    apt-get autoremove -y && \
    apt dist-upgrade -y

##################################################################
#                   deps
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
