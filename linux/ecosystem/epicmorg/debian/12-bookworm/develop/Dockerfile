FROM epicmorg/debian:bookworm
LABEL maintainer="EpicMorg DevTeam, developer@epicm.org"
ARG DEBIAN_FRONTEND=noninteractive

##################################################################
#                   ARGuments
##################################################################
RUN echo "Default folder for installation of customized soft is: ${EMG_LOCAL_BASE_DIR}"

ENV FLUTTER_VERSION=3.22.3
ENV FLUTTER_CHANNEL=stable
ENV FLUTTER_DIR=${EMG_LOCAL_BASE_DIR}/flutter/${FLUTTER_VERSION}
ARG FLUTTER_BIN_DIR=${FLUTTER_DIR}/bin
ARG FLUTTER_DOWNLOAD_URL=https://storage.googleapis.com/flutter_infra_release/releases/${FLUTTER_CHANNEL}/linux/flutter_linux_${FLUTTER_VERSION}-${FLUTTER_CHANNEL}.tar.xz
ARG FLUTTER_TEMP=/tmp/flutter_linux_${FLUTTER_VERSION}-${FLUTTER_CHANNEL}.tar.xz

ENV NINJA_VERSION=1.12.1
ENV NINJA_DIR=${EMG_LOCAL_BASE_DIR}/ninja/${NINJA_VERSION}
ARG NINJA_BIN_DIR=${NINJA_DIR}/bin
ARG NINJA_DOWNLOAD_URL=https://github.com/ninja-build/ninja/releases/download/v${NINJA_VERSION}/ninja-linux.zip
ARG NINJA_TEMP=/tmp/ninja-linux.zip

ENV GO_VERSION=1.22.5
ENV GO_DIR=${EMG_LOCAL_BASE_DIR}/go/${GO_VERSION}
ARG GO_BIN_DIR=${GO_DIR}/bin
ARG GO_DOWNLOAD_URL=https://go.dev/dl/go${GO_VERSION}.linux-amd64.tar.gz
ARG GO_TEMP=/tmp/go${GO_VERSION}.linux-amd64.tar.gz

# PCRE source tarball
ENV PCRE_VERSION=10.44
ENV PCRE_DIR=${EMG_LOCAL_BASE_DIR}/pcre2/${PCRE_VERSION}
ARG PCRE_BIN_DIR=${PCRE_DIR}/bin
ARG PCRE_DOWNLOAD_URL=https://github.com/PCRE2Project/pcre2/releases/download/pcre2-${PCRE_VERSION}/pcre2-${PCRE_VERSION}.tar.gz
ARG PCRE_TEMP=/tmp/pcre2-${PCRE_VERSION}.tar.gz
ARG PCRE_TEMP_SRC=/tmp/pcre2-${PCRE_VERSION}

# zlib source tarball
ENV ZLIB_VERSION=1.3.1
ENV ZLIB_DIR=${EMG_LOCAL_BASE_DIR}/zlib/${ZLIB_VERSION}
ARG ZLIB_DOWNLOAD_URL=https://zlib.net/fossils/zlib-${ZLIB_VERSION}.tar.gz
ARG ZLIB_TEMP=/tmp/zlib-${ZLIB_VERSION}.tar.gz
ARG ZLIB_TEMP_SRC=/tmp/zlib-${ZLIB_VERSION}

# zstd source tarball
ENV ZSTD_VERSION=1.5.6
ENV ZSTD_DIR=${EMG_LOCAL_BASE_DIR}/zstd/${ZLIB_VERSION}
ARG ZSTD_BIN_DIR=${ZSTD_DIR}/bin
ARG ZSTD_DOWNLOAD_URL=https://github.com/facebook/zstd/releases/download/v${ZSTD_VERSION}/zstd-${ZSTD_VERSION}.tar.gz
ARG ZSTD_TEMP=/tmp/zstd-${ZSTD_VERSION}.tar.gz
ARG ZSTD_TEMP_SRC=/tmp/zstd-${ZSTD_VERSION}

# IP2Location-C-Library source tarball
ENV IP2LOC_VERSION=8.7.0
ENV IP2LOC_DIR=${EMG_LOCAL_BASE_DIR}/ip2location/${IP2LOC_VERSION}
ARG IP2LOC_BIN_DIR=${IP2LOC_DIR}/bin
ARG IP2LOC_DOWNLOAD_URL=https://github.com/chrislim2888/IP2Location-C-Library/archive/refs/heads/master.tar.gz
#ARG IP2LOC_DOWNLOAD_URL=https://github.com/chrislim2888/IP2Location-C-Library/archive/refs/tags/${IP2LOC_VERSION}.tar.gz
ARG IP2LOC_TEMP=/tmp/master.tar.gz
#ARG IP2LOC_TEMP=/tmp/${IP2LOC_VERSION}.tar.gz
ARG IP2LOC_TEMP_SRC=/tmp/IP2Location-C-Library-master
#ARG IP2LOC_TEMP_SRC=/tmp/IP2Location-C-Library-${IP2LOC_VERSION}

# OpenSSL 1.1.1
ENV OPENSSL_111_VERSION=1.1.1
ENV OPENSSL_111_DIR=${EMG_LOCAL_BASE_DIR}/openssl/${OPENSSL_111_VERSION}
ARG OPENSSL_111_BIN=${OPENSSL_111_DIR}/bin
ARG OPENSSL_111_LIB=${OPENSSL_111_DIR}/lib
ARG OPENSSL_111_LIB64=${OPENSSL_111_DIR}/lib64
ARG OPENSSL_111_DOWNLOAD_URL=https://www.openssl.org/source/old/${OPENSSL_111_VERSION}/openssl-${OPENSSL_111_VERSION}w.tar.gz
ARG OPENSSL_111_TEMP=/tmp/openssl-${OPENSSL_111_VERSION}w.tar.gz
ARG OPENSSL_111_TEMP_SRC=/tmp/openssl-${OPENSSL_111_VERSION}w

# OpenSSL 3.0.14
ENV OPENSSL_30_VERSION=3.0.14
ENV OPENSSL_30_DIR=${EMG_LOCAL_BASE_DIR}/openssl/${OPENSSL_30_VERSION}
ARG OPENSSL_30_BIN=${OPENSSL_30_DIR}/bin
ARG OPENSSL_30_LIB=${OPENSSL_30_DIR}/lib
ARG OPENSSL_30_LIB64=${OPENSSL_30_DIR}/lib64
ARG OPENSSL_30_DOWNLOAD_URL=https://www.openssl.org/source/openssl-${OPENSSL_30_VERSION}.tar.gz
ARG OPENSSL_30_TEMP=/tmp/openssl-${OPENSSL_30_VERSION}.tar.gz
ARG OPENSSL_30_TEMP_SRC=/tmp/openssl-${OPENSSL_30_VERSION}

# OpenSSL 3.1.6
ENV OPENSSL_31_VERSION=3.1.6
ENV OPENSSL_31_DIR=${EMG_LOCAL_BASE_DIR}/openssl/${OPENSSL_31_VERSION}
ARG OPENSSL_31_BIN=${OPENSSL_31_DIR}/bin
ARG OPENSSL_31_LIB=${OPENSSL_31_DIR}/lib
ARG OPENSSL_31_LIB64=${OPENSSL_31_DIR}/lib64
ARG OPENSSL_31_DOWNLOAD_URL=https://www.openssl.org/source/openssl-${OPENSSL_31_VERSION}.tar.gz
ARG OPENSSL_31_TEMP=/tmp/openssl-${OPENSSL_31_VERSION}.tar.gz
ARG OPENSSL_31_TEMP_SRC=/tmp/openssl-${OPENSSL_31_VERSION}

# OpenSSL 3.2.2
ENV OPENSSL_32_VERSION=3.2.2
ENV OPENSSL_32_DIR=${EMG_LOCAL_BASE_DIR}/openssl/${OPENSSL_32_VERSION}
ARG OPENSSL_32_BIN=${OPENSSL_32_DIR}/bin
ARG OPENSSL_32_LIB=${OPENSSL_32_DIR}/lib
ARG OPENSSL_32_LIB64=${OPENSSL_32_DIR}/lib64
ARG OPENSSL_32_DOWNLOAD_URL=https://www.openssl.org/source/openssl-${OPENSSL_32_VERSION}.tar.gz
ARG OPENSSL_32_TEMP=/tmp/openssl-${OPENSSL_32_VERSION}.tar.gz
ARG OPENSSL_32_TEMP_SRC=/tmp/openssl-${OPENSSL_32_VERSION}

# OpenSSL 3.3.1
ENV OPENSSL_33_VERSION=3.3.1
ENV OPENSSL_33_DIR=${EMG_LOCAL_BASE_DIR}/openssl/${OPENSSL_33_VERSION}
ARG OPENSSL_33_BIN=${OPENSSL_33_DIR}/bin
ARG OPENSSL_33_LIB=${OPENSSL_33_DIR}/lib
ARG OPENSSL_33_LIB64=${OPENSSL_33_DIR}/lib64
ARG OPENSSL_33_DOWNLOAD_URL=https://www.openssl.org/source/openssl-${OPENSSL_33_VERSION}.tar.gz
ARG OPENSSL_33_TEMP=/tmp/openssl-${OPENSSL_33_VERSION}.tar.gz
ARG OPENSSL_33_TEMP_SRC=/tmp/openssl-${OPENSSL_33_VERSION}

# LibreSSL
ENV LIBRESSL_VERSION=3.9.2
ENV LIBRESSL_DIR=${EMG_LOCAL_BASE_DIR}/libressl/${LIBRESSL_VERSION}
ARG LIBRESSL_BIN=${LIBRESSL_DIR}/bin
ARG LIBRESSL_LIB=${LIBRESSL_DIR}/lib
ARG LIBRESSL_LIB64=${LIBRESSL_DIR}/lib64
ARG LIBRESSL_DOWNLOAD_URL=https://ftp.openbsd.org/pub/OpenBSD/LibreSSL/libressl-${LIBRESSL_VERSION}.tar.gz
ARG LIBRESSL_TEMP=/tmp/libressl-${LIBRESSL_VERSION}.tar.gz
ARG LIBRESSL_TEMP_SRC=/tmp/libressl-${LIBRESSL_VERSION}

# BoringSSL
ENV BORINGSSL_VERSION=master
ENV BORINGSSL_DIR=${EMG_LOCAL_BASE_DIR}/boringssl/${BORINGSSL_VERSION}
ARG BORINGSSL_BIN=${BORINGSSL_DIR}/bin
ARG BORINGSSL_LIB=${BORINGSSL_DIR}/lib
ARG BORINGSSL_LIB64=${BORINGSSL_DIR}/lib64
ARG BORINGSSL_DOWNLOAD_URL=https://boringssl.googlesource.com/boringssl
ARG BORINGSSL_TEMP=/tmp/boringssl

##################################################################
#                   bookworm sources list
##################################################################
RUN apt-get update && \
    apt-get dist-upgrade -y

##################################################################
#                   installing
##################################################################
RUN apt-get update && \
    apt-get install -y --allow-unauthenticated --no-install-recommends --no-install-suggests --allow-downgrades \
    build-essential \
    autoconf-archive \
    gnu-standards \
    cmake \
    libunwind-dev \
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
    python3-all-dev \
    g++-multilib \
    autoconf \
    automake \
    libtool \
    gdb \
    strace \
    libbsd-dev \
    libedit-dev \
    libmd-dev \
    valgrind \
    valgrind-dbg \
    valgrind-if-available \
    valgrind-mpi \
    gcovr \
    lcov \
    libsctp-dev

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

RUN 7zz x ${NINJA_TEMP} -o${NINJA_BIN_DIR} -y  && \
    chmod +x ${NINJA_BIN_DIR}/ninja

ENV PATH="${NINJA_BIN_DIR}:${PATH}"

RUN echo "=============================================" && \
    echo nninja $(ninja --version) && \
    echo "============================================="

##################################################################
#                   ZLib static library
##################################################################
RUN mkdir -p ${ZLIB_DIR} ${ZLIB_TEMP_SRC}
ADD ${ZLIB_DOWNLOAD_URL} /tmp

RUN tar -xzf ${ZLIB_TEMP} --directory ${ZLIB_TEMP_SRC} --strip-components=1 && \
    cd ${ZLIB_TEMP_SRC} && \
    ./configure --static --prefix=${ZLIB_DIR} && \
    make -j$(nproc) && \
    make -j$(nproc) install

##################################################################
#                   ZSTD static library
##################################################################
RUN mkdir -p ${ZSTD_DIR} ${ZSTD_TEMP_SRC}
ADD ${ZSTD_DOWNLOAD_URL} /tmp

RUN tar -xzf ${ZSTD_TEMP} --directory ${ZSTD_TEMP_SRC} --strip-components=1 && \
    cd ${ZSTD_TEMP_SRC} && \
    mkdir -p ${ZSTD_TEMP_SRC}/build/cmake/builddir && \
    cd ${ZSTD_TEMP_SRC}/build/cmake/builddir && \
    cmake -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=${ZSTD_DIR} -DZSTD_BUILD_STATIC=ON -DZSTD_BUILD_SHARED=OFF .. && \
    make -j$(nproc) && \
    make -j$(nproc) install

ENV PATH="${ZSTD_BIN_DIR}:${PATH}"

##################################################################
#                   PRCE2 static library
##################################################################
RUN mkdir -p ${PCRE_BIN_DIR} ${PCRE_TEMP_SRC} 
ADD ${PCRE_DOWNLOAD_URL} /tmp

RUN tar -xzf ${PCRE_TEMP} --directory ${PCRE_TEMP_SRC} --strip-components=1 && \
    mkdir -p ${PCRE_TEMP_SRC}/build && \
    cd ${PCRE_TEMP_SRC} && \
    ./configure --prefix=${PCRE_DIR} \
        --disable-silent-rules \
        --disable-shared \
        --enable-static \
        --enable-rebuild-chartables \
        --enable-pcre2-8 \
        --enable-pcre2-16 \
        --enable-pcre2-32 \
        --enable-jit \
        --enable-newline-is-cr \
        --enable-newline-is-lr \
        --enable-newline-is-anycrlf \
        --enable-newline-is-any \
        --enable-newline-is-nul \
        --enable-bsr-anycrlf \
        --enable-pcre2grep-libz \
        --enable-pcre2grep-libbz2 \
        --enable-pcre2test-libedit \
        --enable-unicode-properties \
        --enable-unicode \
        --enable-valgrind \
        --enable-fuzz-support \
        --enable-diff-fuzz-support \
        --enable-year2038 \
        && \
    make -j$(nproc) && \
    make -j$(nproc) install

ENV PATH="${PCRE_BIN_DIR}:${PATH}"

RUN echo "=============================================" && \
    echo pcre2 $(pcre2-config --version) && \
    echo "============================================="

##################################################################
#                   IP2Location static library
##################################################################
RUN mkdir -p ${IP2LOC_DIR} ${IP2LOC_TEMP_SRC}
ADD ${IP2LOC_DOWNLOAD_URL} /tmp

RUN tar -xzf ${IP2LOC_TEMP} --directory ${IP2LOC_TEMP_SRC} --strip-components=1 && \
    cd ${IP2LOC_TEMP_SRC} && \
    autoreconf -i -v --force && \
    aclocal && \
    automake --gnu --add-missing && \
    autoconf && \
    autoreconf -i -v --force && \
    ./configure \
      --prefix=${IP2LOC_DIR} \
      --disable-silent-rules \
      --disable-shared \
      --enable-static \
      && \
    make -j$(nproc) && \
    make -j$(nproc) install && \
    rm -rfv ${IP2LOC_TEMP}

ENV PATH="${IP2LOC_BIN_DIR}:${PATH}"

##################################################################
#                   OpenSSL 1.1.1.1
##################################################################
RUN mkdir -p ${OPENSSL_111_DIR} ${OPENSSL_111_TEMP_SRC}
ADD ${OPENSSL_111_DOWNLOAD_URL} /tmp

RUN tar -xzf ${OPENSSL_111_TEMP} --directory ${OPENSSL_111_TEMP_SRC} --strip-components=1 && \
    cd ${OPENSSL_111_TEMP_SRC} && \
    ./config \
      no-shared \
      zlib \
      --with-zlib-include=${ZLIB_DIR}/include \
      --with-zlib-lib=${ZLIB_DIR}/lib \
      enable-ec_nistp_64_gcc_128 \
      enable-egd \
      enable-ssl-trace \
      threads \
      sctp \
      --release \
      --prefix=${OPENSSL_111_DIR} \
      && \
    make -j$(nproc) && \
    make -j$(nproc) install

##################################################################
#                   OpenSSL 3.0.14
##################################################################
RUN mkdir -p ${OPENSSL_30_DIR} ${OPENSSL_30_TEMP_SRC}
ADD ${OPENSSL_30_DOWNLOAD_URL} /tmp

RUN tar -xzf ${OPENSSL_30_TEMP} --directory ${OPENSSL_30_TEMP_SRC} --strip-components=1 && \
    cd ${OPENSSL_30_TEMP_SRC} && \
    ./config \
      no-shared \
      zlib \
      --with-zlib-include=${ZLIB_DIR}/include \
      --with-zlib-lib=${ZLIB_DIR}/lib \
      enable-ktls \
      enable-ec_nistp_64_gcc_128 \
      enable-egd \
      enable-fips \
      enable-ssl-trace\
      enable-trace \
      threads \
      sctp \
      --release \
      --prefix=${OPENSSL_30_DIR} \
      && \
    make -j$(nproc) && \
    make -j$(nproc) install

##################################################################
#                   OpenSSL 3.1.6
##################################################################
RUN mkdir -p ${OPENSSL_31_DIR} ${OPENSSL_31_TEMP_SRC}
ADD ${OPENSSL_31_DOWNLOAD_URL} /tmp

RUN tar -xzf ${OPENSSL_31_TEMP} --directory ${OPENSSL_31_TEMP_SRC} --strip-components=1 && \
    cd ${OPENSSL_31_TEMP_SRC} && \
    ./config \
      no-shared \
      zlib \
      --with-zlib-include=${ZLIB_DIR}/include \
      --with-zlib-lib=${ZLIB_DIR}/lib \
      enable-ktls \
      enable-ec_nistp_64_gcc_128 \
      enable-egd \
      enable-fips \
      enable-ssl-trace\
      enable-trace \
      threads \
      sctp \
      --release \
      --prefix=${OPENSSL_31_DIR} \
      && \
    make -j$(nproc) && \
    make -j$(nproc) install

##################################################################
#                   OpenSSL 3.2.2
##################################################################
RUN mkdir -p ${OPENSSL_32_DIR} ${OPENSSL_32_TEMP_SRC}
ADD ${OPENSSL_32_DOWNLOAD_URL} /tmp

RUN tar -xzf ${OPENSSL_32_TEMP} --directory ${OPENSSL_32_TEMP_SRC} --strip-components=1 && \
    cd ${OPENSSL_32_TEMP_SRC} && \
    ./config \
      no-shared \
      zlib \
      --with-zlib-include=${ZLIB_DIR}/include \
      --with-zlib-lib=${ZLIB_DIR}/lib \
      enable-ktls \
      enable-ec_nistp_64_gcc_128 \
      enable-egd \
      enable-fips \
      enable-ssl-trace\
      enable-trace \
      threads \
      sctp \
      --release \
      --prefix=${OPENSSL_32_DIR} \
      && \
    make -j$(nproc) && \
    make -j$(nproc) install

##################################################################
#                   OpenSSL 3.3.1
##################################################################
RUN mkdir -p ${OPENSSL_33_DIR} ${OPENSSL_33_TEMP_SRC}
ADD ${OPENSSL_33_DOWNLOAD_URL} /tmp

RUN tar -xzf ${OPENSSL_33_TEMP} --directory ${OPENSSL_33_TEMP_SRC} --strip-components=1 && \
    cd ${OPENSSL_33_TEMP_SRC} && \
    ./config \
      no-shared \
      zlib \
      --with-zlib-include=${ZLIB_DIR}/include \
      --with-zlib-lib=${ZLIB_DIR}/lib \
      enable-ktls \
      enable-ec_nistp_64_gcc_128 \
      enable-egd \
      enable-fips \
      enable-ssl-trace\
      enable-trace \
      threads \
      sctp \
      --release \
      --prefix=${OPENSSL_33_DIR} \
      && \
    make -j$(nproc) && \
    make -j$(nproc) install

##################################################################
#                   LibreSSL
##################################################################
RUN mkdir -p ${LIBRESSL_DIR} ${LIBRESSL_TEMP_SRC}
ADD ${LIBRESSL_DOWNLOAD_URL} /tmp

RUN tar -xzf ${LIBRESSL_TEMP} --directory ${LIBRESSL_TEMP_SRC} --strip-components=1 && \
    cd ${LIBRESSL_TEMP_SRC} && \
    ./config \
      --enable-static \
      --disable-shared \
      --disable-silent-rules \
      --prefix=${LIBRESSL_DIR} \
      && \
    make -j$(nproc) && \
    make -j$(nproc) install

##################################################################
#                   BoringSSL
##################################################################
RUN mkdir -p ${BORINGSSL_DIR} && \
    git clone -b ${BORINGSSL_VERSION} ${BORINGSSL_DOWNLOAD_URL} ${BORINGSSL_TEMP} && \
    cd ${BORINGSSL_TEMP} && \
    mkdir ${BORINGSSL_TEMP}/build && \
    cd ${BORINGSSL_TEMP}/build && \
    cmake -DCMAKE_BUILD_TYPE=Release -DCMAKE_POSITION_INDEPENDENT_CODE=TRUE -DBUILD_SHARED_LIBS=OFF -DCMAKE_INSTALL_PREFIX=${BORINGSSL_DIR} .. && \
    make -j2 && \
    make -j$(nproc) install

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
