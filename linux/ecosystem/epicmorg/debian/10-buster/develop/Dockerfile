FROM epicmorg/debian:buster
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
#                  update lists
##################################################################
RUN apt-get update && \
    apt-get dist-upgrade -y

##################################################################
#                   installing
##################################################################
RUN apt-get update && \
    apt install -y --allow-unauthenticated --allow-downgrades \
    build-essential \
    autoconf-archive \
    gnu-standards \
    cmake \
    libunwind-dev \
    golang \
    at \
    autopkgtest \
    gcc-multilib \
    g++-multilib \
    libxkbcommon-dev \
    libsqlite3-dev \
    liblzma-dev \
    libgtk-3-dev \
    zlib1g-dev \
    libfreetype6-dev \
    libegl1-mesa-dev \
    libgles2-mesa-dev \
    libgbm-dev \
    uuid-dev \
    nvidia-cg-toolkit \
    nvidia-cg-dev \
    libavcodec-dev \
    libsdl2-dev \
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
    libgd-dev \
    libpcre3-dev \
    libgeoip-dev \
    libkrb5-dev \
    libperl-dev \
    krb5-user \
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
#   libvpx6 \ #not avalible
    tcl \
    g++ \
    gcc \
    libc6-dev \
    make \
    pkg-config \
    golang \
    golang-go \
    python-dev \
    python3-all-dev \
    g++-multilib \
    autoconf \
    automake \
    libtool \
    gdb \
    strace

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
#                   Get NINJA binary
##################################################################
RUN curl -s ${NINJA_RELEASE_URL} | jq -r ".assets[] | select(.name | test(\"${NINJA_ARCH}\")) | .browser_download_url" > /tmp/ninja-url.txt && \
    cat /tmp/ninja-url.txt && \
    cd /tmp && \
    wget -q -c --input-file=/tmp/ninja-url.txt && \
    unzip -o /tmp/ninja-linux.zip -d /bin && \
    printf "\n--------------------------------\nninja version: $(ninja --version)\n--------------------------------\n\n"

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
