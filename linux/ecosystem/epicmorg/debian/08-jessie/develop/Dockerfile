FROM epicmorg/debian:jessie
LABEL maintainer="EpicMorg DevTeam, developer@epicm.org"
ARG DEBIAN_FRONTEND=noninteractive

##################################################################
#                   ARGuments
##################################################################
# /etc/ld.so.conf.d/
ARG LD_CONF_DIR=/etc/ld.so.conf.d/

# steam runtime sdk
ENV STEAM_RUNTIME_SDK_DIR=${EMG_LOCAL_BASE_DIR}/valve/steam/runtime-sdk/latest
ARG STEAM_RUNTIME_SDK_BIN_DIR=${STEAM_RUNTIME_SDK_DIR}/bin
ARG STEAM_RUNTIME_SDK_URL=http://media.steampowered.com/client/runtime/steam-runtime-sdk_latest.tar.xz
ARG STEAM_RUNTIME_SDK_TEMP=/tmp/steam-runtime-sdk_latest.tar.xz

# cmake compiller
ENV CMAKE_VERSION=3.31.3
ENV CMAKE_DIR=${EMG_LOCAL_BASE_DIR}/cmake/${CMAKE_VERSION}
ARG CMAKE_BIN_DIR=${CMAKE_DIR}/bin
ARG CMAKE_DOWNLOAD_URL=https://github.com/Kitware/CMake/releases/download/v${CMAKE_VERSION}/cmake-${CMAKE_VERSION}-linux-x86_64.tar.gz
ARG CMAKE_TEMP=/tmp/cmake-${CMAKE_VERSION}-linux-x86_64.tar.gz

# flutter source tarball
ENV FLUTTER_VERSION=3.27.1
ENV FLUTTER_CHANNEL=stable
ENV FLUTTER_DIR=${EMG_LOCAL_BASE_DIR}/flutter/${FLUTTER_VERSION}
ARG FLUTTER_BIN_DIR=${FLUTTER_DIR}/bin
ARG FLUTTER_DOWNLOAD_URL=https://storage.googleapis.com/flutter_infra_release/releases/${FLUTTER_CHANNEL}/linux/flutter_linux_${FLUTTER_VERSION}-${FLUTTER_CHANNEL}.tar.xz
ARG FLUTTER_TEMP=/tmp/flutter_linux_${FLUTTER_VERSION}-${FLUTTER_CHANNEL}.tar.xz

# ninja source tarball
ENV NINJA_VERSION=1.12.1
ENV NINJA_DIR=${EMG_LOCAL_BASE_DIR}/ninja/${NINJA_VERSION}
ARG NINJA_BIN_DIR=${NINJA_DIR}/bin
ARG NINJA_DOWNLOAD_URL=https://github.com/ninja-build/ninja/releases/download/v${NINJA_VERSION}/ninja-linux.zip
ARG NINJA_TEMP=/tmp/ninja-linux.zip

# GO source tarball
ENV GO_VERSION=1.23.4
ENV GO_DIR=${EMG_LOCAL_BASE_DIR}/go/${GO_VERSION}
ARG GO_BIN_DIR=${GO_DIR}/bin
ARG GO_DOWNLOAD_URL=https://go.dev/dl/go${GO_VERSION}.linux-amd64.tar.gz
ARG GO_TEMP=/tmp/go${GO_VERSION}.linux-amd64.tar.gz

##################################################################
#                  update lists
##################################################################
RUN apt-get update && \
    apt-get dist-upgrade -y

##################################################################
#                   installing
##################################################################
RUN apt-get update && \
    apt-get install -y --allow-unauthenticated --no-install-recommends --no-install-suggests \
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
    tcl \
    g++ \
    gcc \
    libc6-dev \
    make \
    pkg-config \
    golang \
    golang-go \
    python3-all-dev \
    python-dev \
    g++-multilib \
    autoconf \
    automake \
    libtool \
    gdb \
    strace

##################################################################
#                   Rust compillers
##################################################################
ENV CARGO_HOME=${EMG_LOCAL_BASE_DIR}/cargo
ENV RUSTUP_HOME=${EMG_LOCAL_BASE_DIR}/rustup
ARG CARGO_BIN=${CARGO_HOME}/bin

RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y --no-modify-path --profile complete --default-toolchain stable --verbose

ENV PATH="$CARGO_HOME/bin:${PATH}"

RUN echo "=============================================" && \
    echo cargo $(cargo --version) && \
    echo rustc $(rustc --version) && \
    echo rustup $(rustup --version) && \
    echo "============================================="

##################################################################
#                   CMake
##################################################################
RUN mkdir -p ${CMAKE_DIR}
ADD ${CMAKE_DOWNLOAD_URL} /tmp

RUN tar -xf ${CMAKE_TEMP} --directory ${CMAKE_DIR} --strip-components=1 && \
    chmod +x ${CMAKE_BIN_DIR}/ccmake && \
    chmod +x ${CMAKE_BIN_DIR}/cmake && \
    chmod +x ${CMAKE_BIN_DIR}/cmake-gui && \
    chmod +x ${CMAKE_BIN_DIR}/cpack && \
    chmod +x ${CMAKE_BIN_DIR}/ctest

ENV PATH="${CMAKE_BIN_DIR}:${PATH}"

RUN echo "=============================================" && \
    echo $(cmake --version) && \
    echo "============================================="

##################################################################
#                   steam runtime and ssdk
##################################################################
RUN mkdir -p ${STEAM_RUNTIME_SDK_DIR}
ADD ${STEAM_RUNTIME_SDK_URL} /tmp

RUN tar -xf ${STEAM_RUNTIME_SDK_TEMP} --directory ${STEAM_RUNTIME_SDK_DIR} --strip-components=1 && \
    chmod +x ${STEAM_RUNTIME_SDK_BIN_DIR} -R && \
    chmod +x ${STEAM_RUNTIME_SDK_DIR}/setup.sh && \
    chmod +x ${STEAM_RUNTIME_SDK_DIR}/shell.sh && \
    chmod +x ${STEAM_RUNTIME_SDK_DIR}/shell-amd64.sh && \
    chmod +x ${STEAM_RUNTIME_SDK_DIR}/shell-i386.sh
#    printf '%s\n' 3 1 Y Y Y | ./setup.sh

##################################################################
#                   Flutter SDK
##################################################################
RUN mkdir -p ${FLUTTER_DIR}
ADD ${FLUTTER_DOWNLOAD_URL} /tmp

RUN tar -xf ${FLUTTER_TEMP} --directory ${FLUTTER_DIR} --strip-components=1 && \
    chmod +x ${FLUTTER_BIN_DIR}/dart && \
    chmod +x ${FLUTTER_BIN_DIR}/flutter && \
    chmod +x ${FLUTTER_BIN_DIR}/internal/shared.sh && \
    chmod +x ${FLUTTER_BIN_DIR}/internal/update_dart_sdk.sh

ENV PATH="${FLUTTER_BIN_DIR}:${PATH}"

RUN git config --global --add safe.directory ${FLUTTER_DIR} && \
    flutter precache && \
    flutter config --no-analytics && \
    dart --disable-analytics

RUN echo "=============================================" && \
    echo dart $(dart --version) && \
    echo flutter $(flutter --version) && \
    echo "============================================="

##################################################################
#                   GO compillers
##################################################################
RUN mkdir -p ${GO_DIR}
ADD ${GO_DOWNLOAD_URL} /tmp

RUN tar -xzf ${GO_TEMP} --directory ${GO_DIR} --strip-components=1 && \
    chmod +x ${GO_BIN_DIR}/go && \
    chmod +x ${GO_BIN_DIR}/gofmt

ENV GOPATH=${GO_DIR}
ENV PATH="${GO_BIN_DIR}:${PATH}"

RUN echo "=============================================" && \
    echo go $(go version) && \
    echo "============================================="

##################################################################
#                   Get NINJA binary
##################################################################
RUN mkdir -p ${NINJA_BIN_DIR}
ADD ${NINJA_DOWNLOAD_URL} /tmp

RUN 7z x ${NINJA_TEMP} -o${NINJA_BIN_DIR} -y  && \
    chmod +x ${NINJA_BIN_DIR}/ninja

ENV PATH="${NINJA_BIN_DIR}:${PATH}"

RUN echo "=============================================" && \
    echo ninja $(ninja --version) && \
    echo "============================================="

##################################################################
#                   other   customisations
##################################################################

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
