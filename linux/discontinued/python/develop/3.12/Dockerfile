FROM epicmorg/python:3.12

ARG DEBIAN_FRONTEND=noninteractive
LABEL maintainer="EpicMorg DevTeam, developer@epicm.org"

##################################################################
#                   ARGuments
##################################################################
ENV BuildDocker true
ENV GOPATH=/usr/local/go
ENV PATH="${GOPATH}/bin:${PATH}"
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
#                   Version
##################################################################
RUN python3 --version
RUN pip3 --version
RUN python --version
RUN pip --version

##################################################################
#                   installing
##################################################################
RUN apt-get update && \
    apt-get install -y --allow-unauthenticated --no-install-recommends --no-install-suggests --allow-downgrades \
    at \
    autoconf \
    autoconf-archive \
    automake \
    autopkgtest \
    autotools-dev \
    build-essential \
    checkinstall \
    cmake \
    devscripts \
    dh-make \
    dpkg-dev \
    fakeroot \
    fuse3 \
    g++ \
    g++-multilib \
    gcc \
    gcc-multilib \
    gdal-bin \
    gdb \
    gnu-standards \
    golang \
    golang-go \
    krb5-user \
    libavcodec-dev \
    libavfilter-dev \
    libavformat-dev \
    libbz2-dev \
    libc6-dev \
    libcrypto++-dev \
    libegl1-mesa-dev \
    libfreetype6-dev \
    libfuse3-3 \
    libgbm-dev \
    libgd-dev \
    libgdal-dev \
    libgeoip-dev \
    libgeos-dev \
    libgles2-mesa-dev \
    libgtk-3-dev \
    libhiredis-dev \
    libkrb5-dev \
    libldap2-dev \
    liblua5.1-0-dev \
    liblzma-dev \
    libmaxminddb-dev \
    libpam0g-dev \
    libpcre3-dev \
    libperl-dev \
    libproj-dev \
    libprotobuf-c-dev \
    libsdl-image1.2-dev \
    libsdl2-dev \
    libsqlite3-dev \
    libssl-dev \
    libswscale-dev \
    libtool \
    libunwind-dev \
    libvpx-dev \
    libxkbcommon-dev \
    libxml2-dev \
    libxslt-dev \
    libz-dev \
    libzip-dev \
    luajit \
    make \
    nvidia-cg-dev \
    nvidia-cg-toolkit \
    pkg-config \
    protobuf-c-compiler \
    python-dev-is-python3 \
    python3-all-dev \
    qml-module-qt-labs-qmlmodels \
    qml-module-qtquick-controls2 \
    qt5-qmake \
    qtbase5-dev \
    qtbase5-dev-tools \
    qtcreator \
    qtdeclarative5-dev \
    qttools5-dev \
    strace \
    tcl \
    uuid-dev \
    yasm \
    zlib1g \
    zlib1g-dev

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
#                   Version
##################################################################
RUN python3 --version
RUN pip3 --version
RUN python --version
RUN pip --version

##################################################################
#                  update locales
##################################################################
RUN locale-gen

##################################################################
#                  Cleanup
##################################################################
RUN echo "clean up" && \
    apt-get clean -y && \
    apt-get autoclean -y && \
    rm -rfv /var/lib/apt/lists/* && \
    rm -rfv /var/cache/apt/archives/*.deb && \
    rm -rfv /root/tmp/* && \
    rm -rfv /tmp/*

RUN updatedb
