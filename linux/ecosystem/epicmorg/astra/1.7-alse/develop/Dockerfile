FROM epicmorg/astralinux:1.7-main
LABEL maintainer="EpicMorg DevTeam, developer@epicm.org"
ARG DEBIAN_FRONTEND=noninteractive

##################################################################
#                   ARGuments
##################################################################
ENV BuildDocker true
ENV GOPATH=/usr/local/go
ENV CARGOPATH=/root/.cargo
ENV FLUTTERPATH=/usr/local/flutter
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
#                   update lists
##################################################################
RUN echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections && \
    apt-get update

##################################################################
#                   installing utils
##################################################################
RUN echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections && \
    apt-get install -y --allow-unauthenticated --no-install-recommends --no-install-suggests \
    at  \
    autoconf  \
    autoconf-archive  \
    automake  \
    autopkgtest  \
    autotools-dev  \
    build-essential  \
    cmake  \
    cmake-extras \
    docker.io \
    docker-compose \
    devscripts  \
    dh-make  \
    dpkg-dev  \
    extra-cmake-modules \
    fakeroot  \
    fuse3  \
    g++  \
    g++-multilib  \
    gcc  \
    gcc-multilib  \
    gdal-bin  \
    gdb  \
    gnu-standards  \
    googletest  \
    googletest-tools  \
    libgtest-dev  \
    golang  \
    golang-go  \
    krb5-user  \
    libavcodec-dev  \
    libavfilter-dev  \
    libavformat-dev  \
    libbz2-dev  \
    libc6-dev  \
    libcrypto++-dev  \
    libegl1-mesa-dev  \
    libfreetype6-dev  \
    libfuse3-3  \
    libgbm-dev  \
    libgd-dev  \
    libgdal-dev  \
    libgeoip-dev  \
    libgeos-dev  \
    libgles2-mesa-dev  \
    libgtk-3-dev  \
    libhiredis-dev  \
    libkrb5-dev  \
    libldap2-dev  \
    liblua5.1-0-dev  \
    liblzma-dev  \
    libmaxminddb-dev  \
    libpam0g-dev  \
    libpcre3-dev  \
    libperl-dev  \
    libproj-dev  \
    libprotobuf-c-dev  \
    libsdl-image1.2-dev  \
    libsdl2-dev  \
    libsqlite3-dev  \
    libssl-dev  \
    libswscale-dev  \
    libtool  \
    libunwind-dev  \
    libvpx-dev  \
    libxkbcommon-dev  \
    libxml2-dev  \
    libxslt1-dev  \
    libzip-dev  \
    luajit  \
    make  \
    pkg-config  \
    protobuf-c-compiler  \
    python3-all-dev  \
    strace  \
    tcl  \
    uuid-dev  \
    yasm  \
    zlib1g  \
    zlib1g-dev

##################################################################
#                   Rust compillers
##################################################################
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y --profile complete --default-toolchain stable --verbose
RUN printf "\n--------------------------------\n$(cargo --version)\n--------------------------------\n\n"

##################################################################
#                   Flutter SDK
##################################################################
RUN git clone https://github.com/flutter/flutter.git -b stable /usr/local/flutter
RUN flutter precache
RUN flutter config --no-analytics
RUN dart --disable-analytics
RUN printf "\n--------------------------------\n$(flutter --version)\n--------------------------------\n\n"

##################################################################
#                   GO compillers
##################################################################
RUN printf "\n--------------------------------\n$(go version)\n--------------------------------\n\n"

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
