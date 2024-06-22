FROM epicmorg/debian:squeeze
LABEL maintainer="EpicMorg DevTeam, developer@epicm.org"
ARG DEBIAN_FRONTEND=noninteractive

##################################################################
#                   ARGuments
##################################################################
ENV BuildDocker true
ENV GOPATH=/go
ENV CARGOPATH=/root/.cargo
ENV FLUTTERPATH=/flutter
ENV PATH="${FLUTTERPATH}/bin:${CARGOPATH}/bin:${GOPATH}/bin:${PATH}"
ARG BUILDS_DIR=/builds
ARG SRC_DIR=${BUILDS_DIR}/src
ARG EXPORT_DIR=${BUILDS_DIR}/export
ARG NINJA_ARCH=linux
ARG NINJA_VERSION=latest
ARG NINJA_RELEASE_URL=https://api.github.com/repos/ninja-build/ninja/releases/${NINJA_VERSION}

##################################################################
#                   Files and folders
##################################################################
RUN mkdir -p ${SRC_DIR} ${EXPORT_DIR} ${PRE_DIR}

##################################################################
#                   sid sources list
##################################################################
RUN apt-get update && \
    apt-get dist-upgrade -y

##################################################################
#                   installing
##################################################################
RUN apt-get update && \
    apt-get install -y --allow-unauthenticated \
    build-essential \
    autoconf-archive \
    gnu-standards \
    cmake \
    at \
    autopkgtest \
    gcc-multilib \
    g++-multilib \
    libsqlite3-dev \
    liblzma-dev \
    zlib1g-dev \
    libfreetype6-dev \
    libegl1-mesa-dev \
    libgles2-mesa-dev \
    uuid-dev \
    nvidia-cg-toolkit \
    libavcodec-dev \
    libsdl-image1.2-dev \
    libxml2-dev \
    yasm \
    devscripts \
    automake \
    libtool \
    autotools-dev \
    dpkg-dev \
    fakeroot \
    checkinstall \
    dh-make \
    zlib1g \
    zlib1g-dev \
    libssl-dev \
    libxslt-dev \
    libpcre3-dev \
    libgeoip-dev \
    libkrb5-dev \
    libperl-dev \
    krb5-user \
    liblua5.1-0-dev \
    libpam0g-dev \
    libldap2-dev \
    libavformat-dev \
    libavfilter-dev \
    libswscale-dev \
    libavcodec-dev \
    libz-dev \
    libzip-dev \
    libcrypto++-dev \
    libbz2-dev \
    libvpx-dev \
    tcl \
    g++ \
    gcc \
    libc6-dev \
    make \
    pkg-config \
    python3-all-dev \
    python-dev \
    g++-multilib \
    autoconf \
    automake \
    libtool \
    gdb \
    strace
   
RUN aptitude remove '~njava' -y
##################################################################
#                   other   customisations
##################################################################


##################################################################
#                  cleanup
##################################################################
RUN echo "clean up" && \
    apt-get clean -y && \
    apt-get autoclean -y && \
    rm -rfv /var/lib/apt/lists/* && \
    rm -rfv /tmp/* && \
    rm -rfv /var/cache/apt/archives/*.deb
