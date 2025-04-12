################################################################################
# https://github.com/linuxserver/docker-code-server/pkgs/container/code-server
################################################################################
FROM hub.epicm.org/epicmorg/vscode-server:latest

LABEL maintainer="EpicMorg DevTeam, developer@epicm.org"
ARG DEBIAN_FRONTEND=noninteractive

##################################################################
#                   ARGuments
##################################################################
ENV BuildDocker true

# steam runtime sdk
ENV STEAM_RUNTIME_SDK_DIR=${EMG_LOCAL_BASE_DIR}/valve/steam/runtime-sdk/latest
ARG STEAM_RUNTIME_SDK_BIN_DIR=${STEAM_RUNTIME_SDK_DIR}/bin
ARG STEAM_RUNTIME_SDK_URL=http://media.steampowered.com/client/runtime/steam-runtime-sdk_latest.tar.xz
ARG STEAM_RUNTIME_SDK_TEMP=/tmp/steam-runtime-sdk_latest.tar.xz

# cmake compiller
ENV CMAKE_3_31_VERSION=3.31.6
ENV CMAKE_3_31_DIR=${EMG_LOCAL_BASE_DIR}/cmake/${CMAKE_3_31_VERSION}
ARG CMAKE_3_31_BIN_DIR=${CMAKE_3_31_DIR}/bin
ARG CMAKE_3_31_DOWNLOAD_URL=https://github.com/Kitware/CMake/releases/download/v${CMAKE_3_31_VERSION}/cmake-${CMAKE_3_31_VERSION}-linux-x86_64.tar.gz
ARG CMAKE_3_31_TEMP=/tmp/cmake-${CMAKE_3_31_VERSION}-linux-x86_64.tar.gz

# cmake compiller
ENV CMAKE_3_30_VERSION=3.30.8
ENV CMAKE_3_30_DIR=${EMG_LOCAL_BASE_DIR}/cmake/${CMAKE_3_30_VERSION}
ARG CMAKE_3_30_BIN_DIR=${CMAKE_3_30_DIR}/bin
ARG CMAKE_3_30_DOWNLOAD_URL=https://github.com/Kitware/CMake/releases/download/v${CMAKE_3_30_VERSION}/cmake-${CMAKE_3_30_VERSION}-linux-x86_64.tar.gz
ARG CMAKE_3_30_TEMP=/tmp/cmake-${CMAKE_3_30_VERSION}-linux-x86_64.tar.gz

# cmake compiller
ENV CMAKE_3_21_VERSION=3.21.7
ENV CMAKE_3_21_DIR=${EMG_LOCAL_BASE_DIR}/cmake/${CMAKE_3_21_VERSION}
ARG CMAKE_3_21_BIN_DIR=${CMAKE_3_21_DIR}/bin
ARG CMAKE_3_21_DOWNLOAD_URL=https://github.com/Kitware/CMake/releases/download/v${CMAKE_3_21_VERSION}/cmake-${CMAKE_3_21_VERSION}-linux-x86_64.tar.gz
ARG CMAKE_3_21_TEMP=/tmp/cmake-${CMAKE_3_21_VERSION}-linux-x86_64.tar.gz

# cmake compiller
ENV CMAKE_3_20_VERSION=3.20.6
ENV CMAKE_3_20_DIR=${EMG_LOCAL_BASE_DIR}/cmake/${CMAKE_3_20_VERSION}
ARG CMAKE_3_20_BIN_DIR=${CMAKE_3_20_DIR}/bin
ARG CMAKE_3_20_DOWNLOAD_URL=https://github.com/Kitware/CMake/releases/download/v${CMAKE_3_20_VERSION}/cmake-${CMAKE_3_20_VERSION}-linux-x86_64.tar.gz
ARG CMAKE_3_20_TEMP=/tmp/cmake-${CMAKE_3_20_VERSION}-linux-x86_64.tar.gz

# cmake compiller
ENV CMAKE_3_19_VERSION=3.19.8
ENV CMAKE_3_19_DIR=${EMG_LOCAL_BASE_DIR}/cmake/${CMAKE_3_19_VERSION}
ARG CMAKE_3_19_BIN_DIR=${CMAKE_3_19_DIR}/bin
ARG CMAKE_3_19_DOWNLOAD_URL=https://github.com/Kitware/CMake/releases/download/v${CMAKE_3_19_VERSION}/cmake-${CMAKE_3_19_VERSION}-linux-x86_64.tar.gz
ARG CMAKE_3_19_TEMP=/tmp/cmake-${CMAKE_3_19_VERSION}-linux-x86_64.tar.gz

# cmake compiller
ENV CMAKE_3_18_VERSION=3.18.6
ENV CMAKE_3_18_DIR=${EMG_LOCAL_BASE_DIR}/cmake/${CMAKE_3_18_VERSION}
ARG CMAKE_3_18_BIN_DIR=${CMAKE_3_18_DIR}/bin
ARG CMAKE_3_18_DOWNLOAD_URL=https://github.com/Kitware/CMake/releases/download/v${CMAKE_3_18_VERSION}/cmake-${CMAKE_3_18_VERSION}-linux-x86_64.tar.gz
ARG CMAKE_3_18_TEMP=/tmp/cmake-${CMAKE_3_18_VERSION}-linux-x86_64.tar.gz

# cmake compiller
ENV CMAKE_3_16_VERSION=3.16.9
ENV CMAKE_3_16_DIR=${EMG_LOCAL_BASE_DIR}/cmake/${CMAKE_3_16_VERSION}
ARG CMAKE_3_16_BIN_DIR=${CMAKE_3_16_DIR}/bin
ARG CMAKE_3_16_DOWNLOAD_URL=https://github.com/Kitware/CMake/releases/download/v${CMAKE_3_16_VERSION}/cmake-${CMAKE_3_16_VERSION}-linux-x86_64.tar.gz
ARG CMAKE_3_16_TEMP=/tmp/cmake-${CMAKE_3_16_VERSION}-linux-x86_64.tar.gz

# flutter source tarball
ENV FLUTTER_VERSION=3.29.2
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
ENV GO_VERSION=1.24.2
ENV GO_DIR=${EMG_LOCAL_BASE_DIR}/go/${GO_VERSION}
ARG GO_BIN_DIR=${GO_DIR}/bin
ARG GO_PATH_DIR=${GO_DIR}/gopath
ARG GO_PATH_BIN_DIR=${GO_PATH_DIR}/bin
ARG GO_DOWNLOAD_URL=https://go.dev/dl/go${GO_VERSION}.linux-amd64.tar.gz
ARG GO_TEMP=/tmp/go${GO_VERSION}.linux-amd64.tar.gz

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
RUN mkdir -p ${CMAKE_3_31_DIR} ${CMAKE_3_30_DIR} ${CMAKE_3_21_DIR} ${CMAKE_3_20_DIR} ${CMAKE_3_19_DIR}  ${CMAKE_3_18_DIR} ${CMAKE_3_16_DIR}
ADD ${CMAKE_3_31_DOWNLOAD_URL} /tmp
ADD ${CMAKE_3_30_DOWNLOAD_URL} /tmp
ADD ${CMAKE_3_21_DOWNLOAD_URL} /tmp
ADD ${CMAKE_3_20_DOWNLOAD_URL} /tmp
ADD ${CMAKE_3_19_DOWNLOAD_URL} /tmp
ADD ${CMAKE_3_18_DOWNLOAD_URL} /tmp
ADD ${CMAKE_3_16_DOWNLOAD_URL} /tmp

RUN tar -xf ${CMAKE_3_31_TEMP} --directory ${CMAKE_3_31_DIR} --strip-components=1 && \
    chmod +x ${CMAKE_3_31_BIN_DIR}/ccmake && \
    chmod +x ${CMAKE_3_31_BIN_DIR}/cmake && \
    chmod +x ${CMAKE_3_31_BIN_DIR}/cmake-gui && \
    chmod +x ${CMAKE_3_31_BIN_DIR}/cpack && \
    chmod +x ${CMAKE_3_31_BIN_DIR}/ctest  && \
    tar -xf ${CMAKE_3_30_TEMP} --directory ${CMAKE_3_30_DIR} --strip-components=1 && \
    chmod +x ${CMAKE_3_30_BIN_DIR}/ccmake && \
    chmod +x ${CMAKE_3_30_BIN_DIR}/cmake && \
    chmod +x ${CMAKE_3_30_BIN_DIR}/cmake-gui && \
    chmod +x ${CMAKE_3_30_BIN_DIR}/cpack && \
    chmod +x ${CMAKE_3_30_BIN_DIR}/ctest  && \
    tar -xf ${CMAKE_3_21_TEMP} --directory ${CMAKE_3_21_DIR} --strip-components=1 && \
    chmod +x ${CMAKE_3_21_BIN_DIR}/ccmake && \
    chmod +x ${CMAKE_3_21_BIN_DIR}/cmake && \
    chmod +x ${CMAKE_3_21_BIN_DIR}/cmake-gui && \
    chmod +x ${CMAKE_3_21_BIN_DIR}/cpack && \
    chmod +x ${CMAKE_3_21_BIN_DIR}/ctest && \
    tar -xf ${CMAKE_3_20_TEMP} --directory ${CMAKE_3_20_DIR} --strip-components=1 && \
    chmod +x ${CMAKE_3_20_BIN_DIR}/ccmake && \
    chmod +x ${CMAKE_3_20_BIN_DIR}/cmake && \
    chmod +x ${CMAKE_3_20_BIN_DIR}/cmake-gui && \
    chmod +x ${CMAKE_3_20_BIN_DIR}/cpack && \
    chmod +x ${CMAKE_3_20_BIN_DIR}/ctest && \
    tar -xf ${CMAKE_3_19_TEMP} --directory ${CMAKE_3_19_DIR} --strip-components=1 && \
    chmod +x ${CMAKE_3_19_BIN_DIR}/ccmake && \
    chmod +x ${CMAKE_3_19_BIN_DIR}/cmake && \
    chmod +x ${CMAKE_3_19_BIN_DIR}/cmake-gui && \
    chmod +x ${CMAKE_3_19_BIN_DIR}/cpack && \
    chmod +x ${CMAKE_3_19_BIN_DIR}/ctest && \
    tar -xf ${CMAKE_3_18_TEMP} --directory ${CMAKE_3_18_DIR} --strip-components=1 && \
    chmod +x ${CMAKE_3_18_BIN_DIR}/ccmake && \
    chmod +x ${CMAKE_3_18_BIN_DIR}/cmake && \
    chmod +x ${CMAKE_3_18_BIN_DIR}/cmake-gui && \
    chmod +x ${CMAKE_3_18_BIN_DIR}/cpack && \
    chmod +x ${CMAKE_3_18_BIN_DIR}/ctest && \
    tar -xf ${CMAKE_3_16_TEMP} --directory ${CMAKE_3_16_DIR} --strip-components=1 && \
    chmod +x ${CMAKE_3_16_BIN_DIR}/ccmake && \
    chmod +x ${CMAKE_3_16_BIN_DIR}/cmake && \
    chmod +x ${CMAKE_3_16_BIN_DIR}/cmake-gui && \
    chmod +x ${CMAKE_3_16_BIN_DIR}/cpack && \
    chmod +x ${CMAKE_3_16_BIN_DIR}/ctest

# Install default latest version
ENV PATH="${CMAKE_3_31_BIN_DIR}:${PATH}"

RUN echo "=============================================" && \
    echo $(cmake --version) && \
    echo "============================================="

##################################################################
#                   steam runtime and ssdk
##################################################################
RUN mkdir -p ${STEAM_RUNTIME_SDK_DIR}
ADD ${STEAM_RUNTIME_SDK_URL} /tmp

RUN tar -xf ${STEAM_RUNTIME_SDK_TEMP} --directory ${STEAM_RUNTIME_SDK_DIR} --strip-components=1 && \
    tree ${STEAM_RUNTIME_SDK_DIR} && \
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
RUN mkdir -p ${GO_DIR} ${GO_PATH_BIN_DIR} ${GO_BIN_DIR}
ADD ${GO_DOWNLOAD_URL} /tmp

RUN tar -xzf ${GO_TEMP} --directory ${GO_DIR} --strip-components=1 && \
    chmod +x ${GO_BIN_DIR}/go && \
    chmod +x ${GO_BIN_DIR}/gofmt

ENV GOROOT=${GO_DIR}
ENV GOPATH=${GO_PATH_DIR}
ENV PATH="${GO_BIN_DIR}:${GO_PATH_BIN_DIR}:${PATH}"

RUN echo "=============================================" && \
    echo go $(go version) && \
    echo "============================================="

##################################################################
#                   Get NINJA binary
##################################################################
RUN mkdir -p ${NINJA_BIN_DIR}
ADD ${NINJA_DOWNLOAD_URL} /tmp

RUN 7zz x ${NINJA_TEMP} -o${NINJA_BIN_DIR} -y  && \
    chmod +x ${NINJA_BIN_DIR}/ninja

ENV PATH="${NINJA_BIN_DIR}:${PATH}"

RUN echo "=============================================" && \
    echo ninja $(ninja --version) && \
    echo "============================================="

##################################################################
#                   deps
##################################################################
RUN apt-get update && \
    apt-get install -y --allow-unauthenticated --no-install-recommends --no-install-suggests --allow-downgrades \
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
    libc6 \
    libgssapi-krb5-2 \
    libstdc++6 \
    zlib1g \
    tcl

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
