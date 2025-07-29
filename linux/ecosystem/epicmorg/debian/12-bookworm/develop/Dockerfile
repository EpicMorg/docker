FROM epicmorg/debian:bookworm
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
ENV FLUTTER_CHANNEL=stable
ENV FLUTTER_MIN_VERSION=3.32
ENV FLUTTER_VERSION=${FLUTTER_MIN_VERSION}.8
ENV FLUTTER_DIR=${EMG_LOCAL_BASE_DIR}/flutter/${FLUTTER_MIN_VERSION}
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
ENV GO_MIN_VERSION=1.24
ENV GO_VERSION=${GO_MIN_VERSION}.5
ENV GO_DIR=${EMG_LOCAL_BASE_DIR}/go/${GO_MIN_VERSION}
ARG GO_BIN_DIR=${GO_DIR}/bin
ARG GO_PATH_DIR=${GO_DIR}/gopath
ARG GO_PATH_BIN_DIR=${GO_PATH_DIR}/bin
ARG GO_DOWNLOAD_URL=https://go.dev/dl/go${GO_VERSION}.linux-amd64.tar.gz
ARG GO_TEMP=/tmp/go${GO_VERSION}.linux-amd64.tar.gz

# PCRE source tarball
ENV PCRE_VERSION=10.45
ENV PCRE_DIR=${EMG_LOCAL_BASE_DIR}/pcre2/${PCRE_VERSION}
ENV PCRE_BIN_DIR=${PCRE_DIR}/bin
ENV PCRE_LIB_DIR=${PCRE_DIR}/lib
ENV PCRE_INC_DIR=${PCRE_DIR}/include
ENV PCRE_SRC_DIR=/usr/local/src/pcre2/${PCRE_VERSION}
ARG PCRE_DOWNLOAD_URL=https://github.com/PCRE2Project/pcre2/releases/download/pcre2-${PCRE_VERSION}/pcre2-${PCRE_VERSION}.tar.gz
ARG PCRE_TEMP=/tmp/pcre2-${PCRE_VERSION}.tar.gz
ARG PCRE_TEMP_SRC=/tmp/pcre2-${PCRE_VERSION}

# luajit2-openresty source tarball
ENV LUAJIT2OR_VERSION=2.1
ENV LUAJIT2OR_DIR=${EMG_LOCAL_BASE_DIR}/luajit2/${LUAJIT2OR_VERSION}
ENV LUAJIT2OR_BIN_DIR=${PCRE_DIR}/bin
ENV LUAJIT2OR_LIB_DIR=${LUAJIT2OR_DIR}/lib
ENV LUAJIT2OR_INC_DIR=${LUAJIT2OR_DIR}/include
ENV LUAJIT2OR_SRC_DIR=/usr/local/src/luajit2/${LUAJIT2OR_VERSION}
ARG LUAJIT2OR_DOWNLOAD_URL=https://github.com/openresty/luajit2.git
ARG LUAJIT2OR_TEMP_SRC=/tmp/luajit2

# zlib source tarball
ENV ZLIB_VERSION=1.3.1
ENV ZLIB_DIR=${EMG_LOCAL_BASE_DIR}/zlib/${ZLIB_VERSION}
ENV ZLIB_INC_DIR=${ZLIB_DIR}/include
ENV ZLIB_LIB_DIR=${ZLIB_DIR}/lib
ENV ZLIB_SRC_DIR=/usr/local/src/zlib/${ZLIB_VERSION}
ARG ZLIB_DOWNLOAD_URL=https://zlib.net/fossils/zlib-${ZLIB_VERSION}.tar.gz
ARG ZLIB_TEMP=/tmp/zlib-${ZLIB_VERSION}.tar.gz
ARG ZLIB_TEMP_SRC=/tmp/zlib-${ZLIB_VERSION}

# zstd source tarball
ENV ZSTD_VERSION=1.5.7
ENV ZSTD_DIR=${EMG_LOCAL_BASE_DIR}/zstd/${ZLIB_VERSION}
ENV ZSTD_BIN_DIR=${ZSTD_DIR}/bin
ENV ZSTD_INC_DIR=${ZSTD_DIR}/include
ENV ZSTD_LIB_DIR=${ZSTD_DIR}/lib
ENV ZSTD_SRC_DIR=/usr/local/src/zstd/${ZSTD_VERSION}
ARG ZSTD_DOWNLOAD_URL=https://github.com/facebook/zstd/releases/download/v${ZSTD_VERSION}/zstd-${ZSTD_VERSION}.tar.gz
ARG ZSTD_TEMP=/tmp/zstd-${ZSTD_VERSION}.tar.gz
ARG ZSTD_TEMP_SRC=/tmp/zstd-${ZSTD_VERSION}

# IP2Location-C-Library source tarball
ENV IP2LOC_VERSION=8.7.0
ENV IP2LOC_DIR=${EMG_LOCAL_BASE_DIR}/ip2location/${IP2LOC_VERSION}
ENV IP2LOC_BIN_DIR=${IP2LOC_DIR}/bin
ENV IP2LOC_INC_DIR=${IP2LOC_DIR}/include
ENV IP2LOC_LIB_DIR=${IP2LOC_DIR}/lib
ENV IP2LOC_SRC_DIR=/usr/local/src/ip2location/${IP2LOC_VERSION}
ARG IP2LOC_DOWNLOAD_URL=https://github.com/chrislim2888/IP2Location-C-Library/archive/refs/heads/master.tar.gz
ARG IP2LOC_TEMP=/tmp/master.tar.gz
ARG IP2LOC_TEMP_SRC=/tmp/IP2Location-C-Library-master

# libatomic_ops source tarball
ENV LIBATOMICOPS_VERSION=7.8.2
ENV LIBATOMICOPS_DIR=${EMG_LOCAL_BASE_DIR}/libatomic_ops/${LIBATOMICOPS_VERSION}
ENV LIBATOMICOPS_INC_DIR=${LIBATOMICOPS_DIR}/include
ENV LIBATOMICOPS_LIB_DIR=${LIBATOMICOPS_DIR}/lib
ENV LIBATOMICOPS_SRC_DIR=/usr/local/src/libatomic_ops/${LIBATOMICOPS_VERSION}
ARG LIBATOMICOPS_DOWNLOAD_URL=https://github.com/bdwgc/libatomic_ops/releases/download/v${LIBATOMICOPS_VERSION}/libatomic_ops-${LIBATOMICOPS_VERSION}.tar.gz
ARG LIBATOMICOPS_TEMP=/tmp/libatomic_ops-${LIBATOMICOPS_VERSION}.tar.gz
ARG LIBATOMICOPS_TEMP_SRC=/tmp/libatomic_ops-${LIBATOMICOPS_VERSION}

# libimagequant source
ENV LIBIMAGEQUANT_VERSION=4.3.4
ARG LIBIMAGEQUANT_DOWNLOAD_URL=https://github.com/ImageOptim/libimagequant
ENV LIBIMAGEQUANT_DIR=${EMG_LOCAL_BASE_DIR}/libimagequant
ENV LIBIMAGEQUANT_SRC_DIR=/usr/local/src/libimagequant/${LIBIMAGEQUANT_VERSION}
ARG LIBIMAGEQUANT_TEMP_SRC=/tmp/libimagequant

# libraqm source
ENV LIBRAQM_VERSION=0.10.1
ARG LIBRAQM_DOWNLOAD_URL=https://github.com/HOST-Oman/libraqm
ENV LIBRAQM_DIR=${EMG_LOCAL_BASE_DIR}/libraqm
ENV LIBRAQM_SRC_DIR=/usr/local/src/libraqm/${LIBRAQM_VERSION}
ARG LIBRAQM_TEMP_SRC=/tmp/libraqm

# libgd source tarball
ENV LIBGD_VERSION=2.3.3
ENV LIBGD_DIR=${EMG_LOCAL_BASE_DIR}/libgd/${LIBGD_VERSION}
ENV LIBGD_BIN_DIR=${LIBGD_DIR}/bin
ENV LIBGD_INC_DIR=${LIBGD_DIR}/include
ENV LIBGD_LIB_DIR=${LIBGD_DIR}/lib
ENV LIBGD_SRC_DIR=/usr/local/src/libgd/${LIBGD_VERSION}
ARG LIBGD_DOWNLOAD_URL=https://github.com/libgd/libgd/releases/download/gd-${LIBGD_VERSION}/libgd-${LIBGD_VERSION}.tar.gz
ARG LIBGD_TEMP=/tmp/libgd-${LIBGD_VERSION}.tar.gz
ARG LIBGD_TEMP_SRC=/tmp/libgd-${LIBGD_VERSION}

# libxml2 source tarball
ENV LIBXML2_VERSION=2.13.5
ENV LIBXML2_DIR=${EMG_LOCAL_BASE_DIR}/libxml2/${LIBXML2_VERSION}
ENV LIBXML2_BIN_DIR=${LIBXML2_DIR}/bin
ENV LIBXML2_INC_DIR=${LIBXML2_DIR}/include
ENV LIBXML2_LIB_DIR=${LIBXML2_DIR}/lib
ENV LIBXML2_SRC_DIR=/usr/local/src/libxml2/${LIBXML2_VERSION}
ARG LIBXML2_DOWNLOAD_URL=https://gitlab.gnome.org/GNOME/libxml2/-/archive/v${LIBXML2_VERSION}/libxml2-v${LIBXML2_VERSION}.tar.gz
ARG LIBXML2_TEMP=/tmp/libxml2-v${LIBXML2_VERSION}.tar.gz
ARG LIBXML2_TEMP_SRC=/tmp/libxml2-v${LIBXML2_VERSION}

# libxslt source tarball
ENV LIBXSLT_VERSION=1.1.42
ENV LIBXSLT_DIR=${EMG_LOCAL_BASE_DIR}/libxslt/${LIBXSLT_VERSION}
ENV LIBXSLT_BIN_DIR=${LIBXSLT_DIR}/bin
ENV LIBXSLT_INC_DIR=${LIBXSLT_DIR}/include
ENV LIBXSLT_LIB_DIR=${LIBXSLT_DIR}/lib
ENV LIBXSLT_SRC_DIR=/usr/local/src/libxslt/${LIBXSLT_VERSION}
ARG LIBXSLT_DOWNLOAD_URL=https://gitlab.gnome.org/GNOME/libxslt/-/archive/v${LIBXSLT_VERSION}/libxslt-v${LIBXSLT_VERSION}.tar.gz
ARG LIBXSLT_TEMP=/tmp/libxslt-v${LIBXSLT_VERSION}.tar.gz
ARG LIBXSLT_TEMP_SRC=/tmp/libxslt-v${LIBXSLT_VERSION}

# maxmind geoip
ENV MM_GEOIP_VERSION=1.6.12
ENV MM_GEOIP_DIR=${EMG_LOCAL_BASE_DIR}/geoip/${MM_GEOIP_VERSION}
ENV MM_GEOIP_BIN_DIR=${MM_GEOIP_DIR}/bin
ENV MM_GEOIP_INC_DIR=${MM_GEOIP_DIR}/include
ENV MM_GEOIP_LIB_DIR=${MM_GEOIP_DIR}/lib
ENV MM_GEOIP_SRC_DIR=/usr/local/src/geoip/${MM_GEOIP_VERSION}
ARG MM_GEOIP_DOWNLOAD_URL=https://github.com/maxmind/geoip-api-c/releases/download/v${MM_GEOIP_VERSION}/GeoIP-${MM_GEOIP_VERSION}.tar.gz
ARG MM_GEOIP_TEMP=/tmp/GeoIP-${MM_GEOIP_VERSION}.tar.gz
ARG MM_GEOIP_TEMP_SRC=/tmp/GeoIP-${MM_GEOIP_VERSION}

# Google perftools
ENV GPERFTOOLS_VERSION=2.15
ENV GPERFTOOLS_DIR=${EMG_LOCAL_BASE_DIR}/gperftools/${GPERFTOOLS_VERSION}
ENV GPERFTOOLS_BIN_DIR=${GPERFTOOLS_DIR}/bin
ENV GPERFTOOLS_INC_DIR=${GPERFTOOLS_DIR}/include
ENV GPERFTOOLS_LIB_DIR=${GPERFTOOLS_DIR}/lib
ENV GPERFTOOLS_SRC_DIR=/usr/local/src/gperftools/${GPERFTOOLS_VERSION}
ARG GPERFTOOLS_DOWNLOAD_URL=https://github.com/gperftools/gperftools/releases/download/gperftools-${GPERFTOOLS_VERSION}/gperftools-${GPERFTOOLS_VERSION}.tar.gz
ARG GPERFTOOLS_TEMP=/tmp/gperftools-${GPERFTOOLS_VERSION}.tar.gz
ARG GPERFTOOLS_TEMP_SRC=/tmp/gperftools-${GPERFTOOLS_VERSION}

# OpenSSL 1.0.2
ENV OPENSSL_102_VERSION=1.0.2
ENV OPENSSL_102_DIR=${EMG_LOCAL_BASE_DIR}/openssl/${OPENSSL_102_VERSION}
ENV OPENSSL_102_BIN_DIR=${OPENSSL_102_DIR}/bin
ENV OPENSSL_102_INC_DIR=${OPENSSL_102_DIR}/include
ENV OPENSSL_102_LIB_DIR=${OPENSSL_102_DIR}/lib
ENV OPENSSL_102_SRC_DIR=/usr/local/src/openssl/${OPENSSL_102_VERSION}
ARG OPENSSL_102_DOWNLOAD_URL=https://github.com/openssl/openssl/releases/download/OpenSSL_1_0_2u/openssl-1.0.2u.tar.gz
ARG OPENSSL_102_TEMP=/tmp/openssl-1.0.2u.tar.gz
ARG OPENSSL_102_TEMP_SRC=/tmp/openssl-1.0.2u

# OpenSSL 1.1.1
ENV OPENSSL_111_VERSION=1.1.1
ENV OPENSSL_111_DIR=${EMG_LOCAL_BASE_DIR}/openssl/${OPENSSL_111_VERSION}
ENV OPENSSL_111_BIN_DIR=${OPENSSL_111_DIR}/bin
ENV OPENSSL_111_INC_DIR=${OPENSSL_111_DIR}/include
ENV OPENSSL_111_LIB_DIR=${OPENSSL_111_DIR}/lib
ENV OPENSSL_111_SRC_DIR=/usr/local/src/openssl/${OPENSSL_111_VERSION}
ARG OPENSSL_111_DOWNLOAD_URL=https://www.openssl.org/source/old/${OPENSSL_111_VERSION}/openssl-${OPENSSL_111_VERSION}w.tar.gz
ARG OPENSSL_111_TEMP=/tmp/openssl-${OPENSSL_111_VERSION}w.tar.gz
ARG OPENSSL_111_TEMP_SRC=/tmp/openssl-${OPENSSL_111_VERSION}w

# OpenSSL 3.0
ENV OPENSSL_30_VERSION=3.0.16
ENV OPENSSL_30_DIR=${EMG_LOCAL_BASE_DIR}/openssl/${OPENSSL_30_VERSION}
ENV OPENSSL_30_BIN_DIR=${OPENSSL_30_DIR}/bin
ENV OPENSSL_30_INC_DIR=${OPENSSL_30_DIR}/include
ENV OPENSSL_30_LIB_DIR=${OPENSSL_30_DIR}/lib64
ENV OPENSSL_30_SRC_DIR=/usr/local/src/openssl/${OPENSSL_30_VERSION}
ARG OPENSSL_30_DOWNLOAD_URL=https://www.openssl.org/source/openssl-${OPENSSL_30_VERSION}.tar.gz
ARG OPENSSL_30_TEMP=/tmp/openssl-${OPENSSL_30_VERSION}.tar.gz
ARG OPENSSL_30_TEMP_SRC=/tmp/openssl-${OPENSSL_30_VERSION}

# OpenSSL 3.1
ENV OPENSSL_31_VERSION=3.1.8
ENV OPENSSL_31_DIR=${EMG_LOCAL_BASE_DIR}/openssl/${OPENSSL_31_VERSION}
ENV OPENSSL_31_BIN_DIR=${OPENSSL_31_DIR}/bin
ENV OPENSSL_31_INC_DIR=${OPENSSL_31_DIR}/include
ENV OPENSSL_31_LIB_DIR=${OPENSSL_31_DIR}/lib64
ENV OPENSSL_31_SRC_DIR=/usr/local/src/openssl/${OPENSSL_31_VERSION}
ARG OPENSSL_31_DOWNLOAD_URL=https://www.openssl.org/source/openssl-${OPENSSL_31_VERSION}.tar.gz
ARG OPENSSL_31_TEMP=/tmp/openssl-${OPENSSL_31_VERSION}.tar.gz
ARG OPENSSL_31_TEMP_SRC=/tmp/openssl-${OPENSSL_31_VERSION}

# OpenSSL 3.2
ENV OPENSSL_32_VERSION=3.2.4
ENV OPENSSL_32_DIR=${EMG_LOCAL_BASE_DIR}/openssl/${OPENSSL_32_VERSION}
ENV OPENSSL_32_BIN_DIR=${OPENSSL_32_DIR}/bin
ENV OPENSSL_32_INC_DIR=${OPENSSL_32_DIR}/include
ENV OPENSSL_32_LIB_DIR=${OPENSSL_32_DIR}/lib64
ENV OPENSSL_32_SRC_DIR=/usr/local/src/openssl/${OPENSSL_32_VERSION}
ARG OPENSSL_32_DOWNLOAD_URL=https://www.openssl.org/source/openssl-${OPENSSL_32_VERSION}.tar.gz
ARG OPENSSL_32_TEMP=/tmp/openssl-${OPENSSL_32_VERSION}.tar.gz
ARG OPENSSL_32_TEMP_SRC=/tmp/openssl-${OPENSSL_32_VERSION}

# OpenSSL 3.3
ENV OPENSSL_33_VERSION=3.3.3
ENV OPENSSL_33_DIR=${EMG_LOCAL_BASE_DIR}/openssl/${OPENSSL_33_VERSION}
ENV OPENSSL_33_BIN_DIR=${OPENSSL_33_DIR}/bin
ENV OPENSSL_33_INC_DIR=${OPENSSL_33_DIR}/include
ENV OPENSSL_33_LIB_DIR=${OPENSSL_33_DIR}/lib64
ENV OPENSSL_33_SRC_DIR=/usr/local/src/openssl/${OPENSSL_33_VERSION}
ARG OPENSSL_33_DOWNLOAD_URL=https://www.openssl.org/source/openssl-${OPENSSL_33_VERSION}.tar.gz
ARG OPENSSL_33_TEMP=/tmp/openssl-${OPENSSL_33_VERSION}.tar.gz
ARG OPENSSL_33_TEMP_SRC=/tmp/openssl-${OPENSSL_33_VERSION}

# OpenSSL 3.4
ENV OPENSSL_34_VERSION=3.4.1
ENV OPENSSL_34_DIR=${EMG_LOCAL_BASE_DIR}/openssl/${OPENSSL_34_VERSION}
ENV OPENSSL_34_BIN_DIR=${OPENSSL_34_DIR}/bin
ENV OPENSSL_34_INC_DIR=${OPENSSL_34_DIR}/include
ENV OPENSSL_34_LIB_DIR=${OPENSSL_34_DIR}/lib64
ENV OPENSSL_34_SRC_DIR=/usr/local/src/openssl/${OPENSSL_34_VERSION}
ARG OPENSSL_34_DOWNLOAD_URL=https://www.openssl.org/source/openssl-${OPENSSL_34_VERSION}.tar.gz
ARG OPENSSL_34_TEMP=/tmp/openssl-${OPENSSL_34_VERSION}.tar.gz
ARG OPENSSL_34_TEMP_SRC=/tmp/openssl-${OPENSSL_34_VERSION}

# OpenSSL 3.5
ENV OPENSSL_35_VERSION=3.5.0
ENV OPENSSL_35_DIR=${EMG_LOCAL_BASE_DIR}/openssl/${OPENSSL_35_VERSION}
ENV OPENSSL_35_BIN_DIR=${OPENSSL_35_DIR}/bin
ENV OPENSSL_35_INC_DIR=${OPENSSL_35_DIR}/include
ENV OPENSSL_35_LIB_DIR=${OPENSSL_35_DIR}/lib64
ENV OPENSSL_35_SRC_DIR=/usr/local/src/openssl/${OPENSSL_35_VERSION}
ARG OPENSSL_35_DOWNLOAD_URL=https://www.openssl.org/source/openssl-${OPENSSL_35_VERSION}.tar.gz
ARG OPENSSL_35_TEMP=/tmp/openssl-${OPENSSL_35_VERSION}.tar.gz
ARG OPENSSL_35_TEMP_SRC=/tmp/openssl-${OPENSSL_35_VERSION}

# LibreSSL
ENV LIBRESSL_VERSION=4.0.0
ENV LIBRESSL_DIR=${EMG_LOCAL_BASE_DIR}/libressl/${LIBRESSL_VERSION}
ENV LIBRESSL_INC_DIR=${LIBRESSL_DIR}/include
ENV LIBRESSL_LIB_DIR=${LIBRESSL_DIR}/lib
ENV LIBRESSL_SRC_DIR=/usr/local/src/libressl/${LIBRESSL_VERSION}
ARG LIBRESSL_DOWNLOAD_URL=https://ftp.openbsd.org/pub/OpenBSD/LibreSSL/libressl-${LIBRESSL_VERSION}.tar.gz
ARG LIBRESSL_TEMP=/tmp/libressl-${LIBRESSL_VERSION}.tar.gz
ARG LIBRESSL_TEMP_SRC=/tmp/libressl-${LIBRESSL_VERSION}

# BoringSSL
ENV BORINGSSL_VERSION=master
ENV BORINGSSL_DIR=${EMG_LOCAL_BASE_DIR}/boringssl/${BORINGSSL_VERSION}
ENV BORINGSSL_INC_DIR=${BORINGSSL_DIR}/include
ENV BORINGSSL_LIB_DIR=${BORINGSSL_DIR}/lib
ENV BORINGSSL_SRC_DIR=/usr/local/src/boringssl/${BORINGSSL_VERSION}
ARG BORINGSSL_DOWNLOAD_URL=https://boringssl.googlesource.com/boringssl
ARG BORINGSSL_TEMP_SRC=/tmp/boringssl

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
    clang \
    meson \
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
    libavutil-dev \
    libavcodec-dev \
    libxvidcore-dev \
    libtwolame-dev \
    libmp3lame-dev \
    libopus-dev \
    libavcodec-extra \
    libtheora-dev \
    libvorbis-dev \
    libflac-dev \
    libx264-dev \
    libx265-dev \
    libaom-dev \
    libdav1d-dev \
    libaio-dev \ 
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
    libpcre2-dev \
    libgeoip-dev \
    libxml++*-dev \
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
    libavif-dev \
    libswscale-dev \
    libavcodec-dev \
    libz-dev \
    libhiredis-dev \
    libzip-dev \
    libcrypto++-dev \
    libbz2-dev \
    libvpx-dev \
    libsasl2-dev \
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
    libsctp-dev \
    libharfbuzz-dev \
    libfribidi-dev \
    libpng-dev \
    libjpeg-dev \
    libfreetype6-dev

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
    flutter config --no-analytics && \
    flutter config --no-cli-animations && \
    flutter precache && \
    dart --disable-analytics

RUN echo "=============================================" && \
    echo dart $(dart --version) && \
    echo flutter $(flutter --version) && \
    echo "============================================="

##################################################################
#                   GO compillers
##################################################################
RUN mkdir -p ${GO_DIR} ${GO_PATH_BIN_DIR} ${GO_BIN_DIR} ${GO_BIN_DIR}
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
#                   ZLIB library
##################################################################
RUN mkdir -p ${ZLIB_DIR} ${ZLIB_SRC_DIR}
ADD ${ZLIB_DOWNLOAD_URL} /tmp

RUN tar -xzf ${ZLIB_TEMP} --directory /tmp && \
    cp -rfv ${ZLIB_TEMP_SRC}/* ${ZLIB_SRC_DIR} && \
    ln -sf ${ZLIB_SRC_DIR}  ${ZLIB_DIR}/src && \
    cd ${ZLIB_TEMP_SRC} && \
    CFLAGS=-Wno-error ./configure \
#      --static \
      --prefix=${ZLIB_DIR} \
      && \
    make -j$(nproc) && \
    make -j$(nproc) install && \
    echo "# ZLIB support" >> ${LD_CONF_DIR}/ZLIB.conf && \
    echo ${ZLIB_LIB_DIR} >> ${LD_CONF_DIR}/ZLIB.conf && \
    ldconfig

##################################################################
#                   ZSTD library
##################################################################
RUN mkdir -p ${ZSTD_DIR} ${ZSTD_SRC_DIR}
ADD ${ZSTD_DOWNLOAD_URL} /tmp

RUN tar -xzf ${ZSTD_TEMP} --directory /tmp && \
    cp -rfv ${ZSTD_TEMP_SRC}/* ${ZSTD_SRC_DIR} && \
    ln -sf ${ZSTD_SRC_DIR}  ${ZSTD_DIR}/src && \
    cd ${ZSTD_TEMP_SRC} && \
    mkdir -p ${ZSTD_TEMP_SRC}/build/cmake/builddir && \
    cd ${ZSTD_TEMP_SRC}/build/cmake/builddir && \
    CFLAGS=-Wno-error cmake -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=${ZSTD_DIR} -DZSTD_BUILD_STATIC=ON -DZSTD_BUILD_SHARED=ON .. && \
    make -j$(nproc) && \
    make -j$(nproc) install && \
    echo "# ZSTD support" >> ${LD_CONF_DIR}/ZSTD.conf && \
    echo ${ZSTD_LIB_DIR} >> ${LD_CONF_DIR}/ZSTD.conf && \
    ldconfig

ENV PATH="${ZSTD_BIN_DIR}:${PATH}"

##################################################################
#                   PRCE2 static library
##################################################################
RUN mkdir -p ${PCRE_BIN_DIR} ${PCRE_SRC_DIR}
ADD ${PCRE_DOWNLOAD_URL} /tmp

RUN tar -xzf ${PCRE_TEMP} --directory /tmp && \
    cp -rfv ${PCRE_TEMP_SRC}/* ${PCRE_SRC_DIR} && \
    ln -sf ${PCRE_SRC_DIR} ${PCRE_DIR}/src && \
    cd ${PCRE_TEMP_SRC} && \
    CFLAGS=-Wno-error ./configure --prefix=${PCRE_DIR} \
        --disable-silent-rules \
        --enable-shared \
        --enable-static \
        --enable-rebuild-chartables \
        --enable-pcre2-8 \
        --enable-pcre2-16 \
        --enable-pcre2-32 \
        --enable-jit \
        --enable-newline-is-cr \
        --enable-newline-is-lf \
        --enable-newline-is-anycrlf \
        --enable-newline-is-any \
        --enable-newline-is-nul \
        --enable-bsr-anycrlf \
        --enable-pcre2grep-libz \
        --enable-pcre2grep-libbz2 \
        --enable-pcre2test-libedit \
        --enable-unicode \
        --enable-valgrind \
        --enable-fuzz-support \
        --enable-diff-fuzz-support \
        && \
    make -j$(nproc) && \
    make -j$(nproc) install && \
    echo "# PRCE2 support" >> ${LD_CONF_DIR}/PRCE2.conf && \
    echo ${PCRE_LIB_DIR} >> ${LD_CONF_DIR}/PRCE2.conf && \
    ldconfig

ENV PATH="${PCRE_BIN_DIR}:${PATH}"

RUN echo "=============================================" && \
    echo pcre2 $(pcre2-config --version) && \
    echo "============================================="

##################################################################
#                   LuaJIT2 OpenResty 2.1
##################################################################
RUN mkdir -p ${LUAJIT2OR_DIR} ${LUAJIT2OR_SRC_DIR} && \
    git clone ${LUAJIT2OR_DOWNLOAD_URL} ${LUAJIT2OR_TEMP_SRC} && \
    cp -rfv ${LUAJIT2OR_TEMP_SRC}/* ${LUAJIT2OR_SRC_DIR} && \
    ln -sf ${LUAJIT2OR_SRC_DIR} ${LUAJIT2OR_DIR}/src && \
    cd ${LUAJIT2OR_TEMP_SRC} && \
#    make -j$(nproc) XCFLAGS='-DLUAJIT_ENABLE_GC64' BUILDMODE=static && \
    make -j$(nproc) XCFLAGS='-DLUAJIT_ENABLE_GC64' BUILDMODE=mixed && \
    make -j$(nproc) install PREFIX=${LUAJIT2OR_DIR} && \
    echo "# LuaJIT2 support" >> ${LD_CONF_DIR}/LuaJIT2.conf && \
    echo ${LUAJIT2OR_LIB_DIR} >> ${LD_CONF_DIR}/LuaJIT2.conf && \
    ldconfig

ENV PATH="${LUAJIT2OR_BIN_DIR}:${PATH}"

RUN echo "=============================================" && \
    echo luajit $(luajit -v) && \
    echo "============================================="

##################################################################
#                   IP2Location
##################################################################
RUN mkdir -p ${IP2LOC_DIR} ${IP2LOC_SRC_DIR}
ADD ${IP2LOC_DOWNLOAD_URL} /tmp

RUN tar -xzf ${IP2LOC_TEMP} --directory /tmp && \
    cp -rfv ${IP2LOC_TEMP_SRC}/* ${IP2LOC_SRC_DIR} && \
    ln -sf ${IP2LOC_SRC_DIR} ${IP2LOC_DIR}/src && \
    cd ${IP2LOC_TEMP_SRC} && \
    autoreconf -i -v --force && \
    aclocal && \
    automake --gnu --add-missing && \
    autoconf && \
    autoreconf -i -v --force && \
    CFLAGS=-Wno-error ./configure \
      --prefix=${IP2LOC_DIR} \
      --disable-silent-rules \
      --enable-shared \
      --enable-static \
      && \
    make -j$(nproc) && \
    make -j$(nproc) install && \
    echo "# IP2Location support" >> ${LD_CONF_DIR}/IP2Location.conf && \
    echo ${IP2LOC_LIB_DIR} >> ${LD_CONF_DIR}/IP2Location.conf && \
    ldconfig

ENV PATH="${IP2LOC_BIN_DIR}:${PATH}"

##################################################################
#                   libatomic_ops
##################################################################
RUN mkdir -p ${LIBATOMICOPS_DIR} ${LIBATOMICOPS_SRC_DIR}
ADD ${LIBATOMICOPS_DOWNLOAD_URL} /tmp

RUN tar -xzf ${LIBATOMICOPS_TEMP} --directory /tmp && \
    cp -rfv ${LIBATOMICOPS_TEMP_SRC}/* ${LIBATOMICOPS_SRC_DIR} && \
    ln -sf ${LIBATOMICOPS_SRC_DIR} ${LIBATOMICOPS_DIR}/src && \
    cd ${LIBATOMICOPS_TEMP_SRC} && \
    ./autogen.sh && \
    CFLAGS=-Wno-error ./configure \
      --prefix=${LIBATOMICOPS_DIR} \
      --disable-silent-rules \
      --enable-shared \
      --enable-static \
      --enable-assertions \
      --with-aix-soname=both \
      && \
    make -j$(nproc) && \
    make -j$(nproc) install && \
    ln -sfv ${LIBATOMICOPS_SRC_DIR} ${LIBATOMICOPS_SRC_DIR}/src && \
    echo "# libatomic_ops support" >> ${LD_CONF_DIR}/libatomic_ops.conf && \
    echo ${LIBATOMICOPS_LIB_DIR} >> ${LD_CONF_DIR}/libatomic_ops.conf && \
    ldconfig

##################################################################
#                   libimagequant
##################################################################
RUN mkdir -p ${LIBIMAGEQUANT_DIR} ${LIBIMAGEQUANT_SRC_DIR}

RUN git clone ${LIBIMAGEQUANT_DOWNLOAD_URL} ${LIBIMAGEQUANT_TEMP_SRC} && \
    cp -rfv ${LIBIMAGEQUANT_TEMP_SRC}/* ${LIBIMAGEQUANT_SRC_DIR} && \
    ln -sf ${LIBIMAGEQUANT_SRC_DIR} ${LIBIMAGEQUANT_DIR}/src && \
    cd ${LIBIMAGEQUANT_TEMP_SRC} && \
      cargo build --release && \
    cd ${LIBIMAGEQUANT_TEMP_SRC}/imagequant-sys && \
      cargo build --release && \
      make -j$(nproc) && \
      make -j$(nproc) install

##################################################################
#                   libraqm
##################################################################
RUN mkdir -p ${LIBRAQM_DIR} ${LIBRAQM_SRC_DIR}

RUN git clone ${LIBRAQM_DOWNLOAD_URL} ${LIBRAQM_TEMP_SRC} && \
    cp -rfv ${LIBRAQM_TEMP_SRC}/* ${LIBRAQM_SRC_DIR} && \
    ln -sf ${LIBRAQM_SRC_DIR} ${LIBRAQM_DIR}/src && \
    cd ${LIBRAQM_TEMP_SRC} && \
    meson build && \
    ninja -C build && \
    ninja -C build install

##################################################################
#                   libgd
##################################################################
RUN mkdir -p ${LIBGD_DIR} ${LIBGD_SRC_DIR}
ADD ${LIBGD_DOWNLOAD_URL} /tmp

RUN tar -xzf ${LIBGD_TEMP} --directory /tmp && \
    cp -rfv ${LIBGD_TEMP_SRC}/* ${LIBGD_SRC_DIR} && \
    ln -sf ${LIBGD_SRC_DIR} ${LIBGD_DIR}/src && \
    cd ${LIBGD_TEMP_SRC} && \
    ./bootstrap.sh && \
    CFLAGS=-Wno-error ./configure \
      --prefix=${LIBGD_DIR} \
      --disable-silent-rules \
      --enable-static \
      --enable-shared \
      --with-aix-soname=both \
      --with-libiconv-prefix \
      --with-zlib=${ZSTD_SRC_DIR} \
      --with-png --with-freetype \
      --with-raqm=${LIBRAQM_SRC_DIR} \
      --with-fontconfig \
      --with-jpeg \
      --with-liq=${LIBIMAGEQUANT_SRC_DIR} \
      --with-xpm \
      --with-gd \
      --enable-gd-formats \
      --with-tiff \
      --with-webp \
      --with-heif \
      --with-avif \
      --with-x \
      && \
    make -j$(nproc) && \
    make -j$(nproc) install && \
    echo "# libgd support" >> ${LD_CONF_DIR}/libgd.conf && \
    echo ${LIBGD_LIB_DIR} >> ${LD_CONF_DIR}/libgd.conf && \
    ldconfig

ENV PATH="${LIBGD_BIN_DIR}:${PATH}" 

##################################################################
#                   libxml2
##################################################################
RUN mkdir -p ${LIBXML2_DIR} ${LIBXML2_SRC_DIR}
ADD ${LIBXML2_DOWNLOAD_URL} /tmp

RUN tar -xzf ${LIBXML2_TEMP} --directory /tmp && \
    cp -rfv ${LIBXML2_TEMP_SRC}/* ${LIBXML2_SRC_DIR} && \
    ln -sf ${LIBXML2_SRC_DIR} ${LIBXML2_DIR}/src && \
    cd ${LIBXML2_TEMP_SRC} && \
    ./autogen.sh && \
    CFLAGS=-Wno-error ./configure \
      --prefix=${LIBXML2_DIR} \
      --disable-silent-rules \
      --enable-static \
      --enable-shared \
      --with-aix-soname=both \
      --with-c14n \
      --with-catalog \
      --with-debug \
      --with-ftp \
      --with-history \
      --with-html \
      --with-http \
      --with-iconv \
      --with-readline \
      --with-http \
      --with-icu \
      --with-iso8859x \
      --with-output \
      --with-pattern \
      --with-push \
      --with-python \
      --with-reader \
      --with-regexps \
      --with-sax1 \
      --with-schemas \
      --with-schematron \
      --with-threads \
      --with-thread-alloc \
      --with-tree \
      --with-valid \
      --with-writer \
      --with-xinclude \
      --with-xpath \
      --with-xptr \
      --with-xptr-locs \
      --with-lzma \
      --with-zlib=${ZSTD_DIR} \
      --with-legacy \
      --with-tls \
      --with-python-sys-prefix \
      && \
    make -j$(nproc) && \
    make -j$(nproc) install && \
    echo "# libxslt support" >> ${LD_CONF_DIR}/libxml2.conf && \
    echo ${LIBXML2_LIB_DIR} >> ${LD_CONF_DIR}/libxml2.conf && \
    ldconfig

ENV PATH="${LIBXML2_BIN_DIR}:${PATH}" 

##################################################################
#                   libxslt
##################################################################
RUN mkdir -p ${LIBXSLT_DIR} ${LIBXSLT_SRC_DIR}
ADD ${LIBXSLT_DOWNLOAD_URL} /tmp

RUN tar -xzf ${LIBXSLT_TEMP} --directory /tmp && \
    cp -rfv ${LIBXSLT_TEMP_SRC}/* ${LIBXSLT_SRC_DIR} && \
    ln -sf ${LIBXSLT_SRC_DIR} ${LIBXSLT_DIR}/src && \
    cd ${LIBXSLT_TEMP_SRC} && \
    ./autogen.sh && \
    CFLAGS=-Wno-error ./configure \
      --prefix=${LIBXSLT_DIR} \
      --disable-silent-rules \
      --enable-static \
      --enable-shared \
      --with-aix-soname=both \
      --with-python-sys-prefix \
      --with-crypto \
      --with-debug \
      --with-debugger \
      --with-profiler \
      --with-plugins \
      && \
    make -j$(nproc) && \
    make -j$(nproc) install && \
    echo "# libxslt support" >> ${LD_CONF_DIR}/libxslt.conf && \
    echo ${LIBXSLT_LIB_DIR} >> ${LD_CONF_DIR}/libxslt.conf && \
    ldconfig

ENV PATH="${LIBXSLT_BIN_DIR}:${PATH}" 

##################################################################
#                   MAxMind GeoIP
##################################################################
RUN mkdir -p ${MM_GEOIP_DIR} ${MM_GEOIP_SRC_DIR}
ADD ${MM_GEOIP_DOWNLOAD_URL} /tmp

RUN tar -xzf ${MM_GEOIP_TEMP} --directory /tmp && \
    cp -rfv ${MM_GEOIP_TEMP_SRC}/* ${MM_GEOIP_SRC_DIR} && \
    ln -sf ${MM_GEOIP_SRC_DIR} ${MM_GEOIP_DIR}/src && \
    cd ${MM_GEOIP_TEMP_SRC} && \
    ./bootstrap && \
    aclocal && \
    autoconf && \
    automake --add-missing && \
    CFLAGS=-Wno-error ./configure \
      --prefix=${MM_GEOIP_DIR} \
      --disable-silent-rules \
      --enable-shared \
      --enable-static \
      --enable-assertions \
      --with-aix-soname=both \
      && \
    make -j$(nproc) && \
    make -j$(nproc) install && \
    echo "# GeoIP support" >> ${LD_CONF_DIR}/GeoIP.conf && \
    echo ${MM_GEOIP_LIB_DIR} >> ${LD_CONF_DIR}/GeoIP.conf && \
    ldconfig

ENV PATH="${MM_GEOIP_BIN_DIR}:${PATH}" 

##################################################################
#                   Google perftools
##################################################################
RUN mkdir -p ${GPERFTOOLS_DIR} ${GPERFTOOLS_SRC_DIR}
ADD ${GPERFTOOLS_DOWNLOAD_URL} /tmp

RUN tar -xzf ${GPERFTOOLS_TEMP} --directory /tmp && \
    cp -rfv ${GPERFTOOLS_TEMP_SRC}/* ${GPERFTOOLS_SRC_DIR} && \
    ln -sf ${GPERFTOOLS_SRC_DIR} ${GPERFTOOLS_DIR}/src && \
    cd ${GPERFTOOLS_TEMP_SRC} && \
    CFLAGS=-Wno-error ./configure \
      --prefix=${GPERFTOOLS_DIR} \
      --disable-silent-rules \
      --enable-shared \
      --enable-static \
      --enable-libunwind \
      --with-aix-soname=both \
      --enable-large-alloc-report \
      --enable-aggressive-decommit-by-default \
      && \
    make -j$(nproc) && \
    make -j$(nproc) install && \
    echo "# Google perftools support" >> ${LD_CONF_DIR}/Googleperftools.conf && \
    echo ${GPERFTOOLS_LIB_DIR} >> ${LD_CONF_DIR}/Googleperftools.conf && \
    ldconfig

ENV PATH="${GPERFTOOLS_BIN_DIR}:${PATH}" 

##################################################################
#                   OpenSSL 1.0.2u
##################################################################
RUN mkdir -p ${OPENSSL_102_DIR} ${OPENSSL_102_SRC_DIR}
ADD ${OPENSSL_102_DOWNLOAD_URL} /tmp

RUN tar -xzf ${OPENSSL_102_TEMP} --directory /tmp && \
    cp -rfv ${OPENSSL_102_TEMP_SRC}/* ${OPENSSL_102_SRC_DIR} && \
    ln -sf ${OPENSSL_102_SRC_DIR} ${OPENSSL_102_DIR}/src && \
    cd ${OPENSSL_102_TEMP_SRC} && \
    CFLAGS="-Wno-error -fPIC" CXXFLAGS="-fPIC" ./config \
      zlib \
      --with-zlib-include=${ZLIB_DIR}/include \
      --with-zlib-lib=${ZLIB_DIR}/lib \
      enable-ec_nistp_64_gcc_128 \
      enable-egd \
      enable-ssl-trace \
      threads \
      shared \
      sctp \
      shared \
      --release \
      --prefix=${OPENSSL_102_DIR} \
      && \
    make -j$(nproc) && \
    make -j$(nproc) install

##################################################################
#                   OpenSSL 1.1.1.1
##################################################################
RUN mkdir -p ${OPENSSL_111_DIR} ${OPENSSL_111_SRC_DIR}
ADD ${OPENSSL_111_DOWNLOAD_URL} /tmp

RUN tar -xzf ${OPENSSL_111_TEMP} --directory /tmp && \
    cp -rfv ${OPENSSL_111_TEMP_SRC}/* ${OPENSSL_111_SRC_DIR} && \
    ln -sf ${OPENSSL_111_SRC_DIR} ${OPENSSL_111_DIR}/src && \
    cd ${OPENSSL_111_TEMP_SRC} && \
    CFLAGS="-Wno-error -fPIC" CXXFLAGS="-fPIC" ./config \
      zlib \
      --with-zlib-include=${ZLIB_DIR}/include \
      --with-zlib-lib=${ZLIB_DIR}/lib \
      enable-ec_nistp_64_gcc_128 \
      enable-egd \
      enable-ssl-trace \
      threads \
      sctp \
      shared \
      --release \
      --prefix=${OPENSSL_111_DIR} \
      && \
    make -j$(nproc) && \
    make -j$(nproc) install

##################################################################
#                   OpenSSL 3.0
##################################################################
RUN mkdir -p ${OPENSSL_30_DIR} ${OPENSSL_30_SRC_DIR}
ADD ${OPENSSL_30_DOWNLOAD_URL} /tmp

RUN tar -xzf ${OPENSSL_30_TEMP} --directory /tmp && \
    cp -rfv ${OPENSSL_30_TEMP_SRC}/* ${OPENSSL_30_SRC_DIR} && \
    ln -sf ${OPENSSL_30_SRC_DIR} ${OPENSSL_30_DIR}/src && \
    cd ${OPENSSL_30_TEMP_SRC} && \
    CFLAGS="-Wno-error -fPIC" CXXFLAGS="-fPIC" ./config \
      zlib \
      --with-zlib-include=${ZLIB_DIR}/include \
      --with-zlib-lib=${ZLIB_DIR}/lib \
      enable-ktls \
      enable-ec_nistp_64_gcc_128 \
      enable-egd \
#     enable-fips \
      enable-ssl-trace\
      enable-trace \
      threads \
      sctp \
      shared \
      --release \
      --prefix=${OPENSSL_30_DIR} \
      && \
    make -j$(nproc) && \
    make -j$(nproc) install

##################################################################
#                   OpenSSL 3.1
##################################################################
RUN mkdir -p ${OPENSSL_31_DIR} ${OPENSSL_31_SRC_DIR}
ADD ${OPENSSL_31_DOWNLOAD_URL} /tmp

RUN tar -xzf ${OPENSSL_31_TEMP} --directory /tmp && \
    cp -rfv ${OPENSSL_31_TEMP_SRC}/* ${OPENSSL_31_SRC_DIR} && \
    ln -sf ${OPENSSL_31_SRC_DIR} ${OPENSSL_31_DIR}/src && \
    cd ${OPENSSL_31_TEMP_SRC} && \
    CFLAGS="-Wno-error -fPIC" CXXFLAGS="-fPIC" ./config \
      zlib \
      --with-zlib-include=${ZLIB_DIR}/include \
      --with-zlib-lib=${ZLIB_DIR}/lib \
      enable-ktls \
      enable-ec_nistp_64_gcc_128 \
      enable-egd \
#     enable-fips \
      enable-ssl-trace\
      enable-trace \
      threads \
      sctp \
      shared \
      --release \
      --prefix=${OPENSSL_31_DIR} \
      && \
    make -j$(nproc) && \
    make -j$(nproc) install

##################################################################
#                   OpenSSL 3.2
##################################################################
RUN mkdir -p ${OPENSSL_32_DIR} ${OPENSSL_32_SRC_DIR}
ADD ${OPENSSL_32_DOWNLOAD_URL} /tmp

RUN tar -xzf ${OPENSSL_32_TEMP} --directory /tmp && \
    cp -rfv ${OPENSSL_32_TEMP_SRC}/* ${OPENSSL_32_SRC_DIR} && \
    ln -sf ${OPENSSL_32_SRC_DIR} ${OPENSSL_32_DIR}/src && \
    cd ${OPENSSL_32_TEMP_SRC} && \
    CFLAGS="-Wno-error -fPIC" CXXFLAGS="-fPIC" ./config \
      zlib \
      --with-zlib-include=${ZLIB_DIR}/include \
      --with-zlib-lib=${ZLIB_DIR}/lib \
      --with-zstd-include=${ZSTD_DIR}/include \
      --with-zstd-lib=${ZSTD_DIR}/lib \
      enable-ktls \
      enable-ec_nistp_64_gcc_128 \
      enable-egd \
#     enable-fips \
      enable-ssl-trace\
      enable-trace \
      threads \
      sctp \
      shared \
      --release \
      --prefix=${OPENSSL_32_DIR} \
      && \
    make -j$(nproc) && \
    make -j$(nproc) install

##################################################################
#                   OpenSSL 3.3
##################################################################
RUN mkdir -p ${OPENSSL_33_DIR} ${OPENSSL_33_SRC_DIR}
ADD ${OPENSSL_33_DOWNLOAD_URL} /tmp

RUN tar -xzf ${OPENSSL_33_TEMP} --directory /tmp && \
    cp -rfv ${OPENSSL_33_TEMP_SRC}/* ${OPENSSL_33_SRC_DIR} && \
    ln -sf ${OPENSSL_33_SRC_DIR} ${OPENSSL_33_DIR}/src && \
    cd ${OPENSSL_33_TEMP_SRC} && \
    CFLAGS="-Wno-error -fPIC" CXXFLAGS="-fPIC" ./config \
      zlib \
      --with-zlib-include=${ZLIB_DIR}/include \
      --with-zlib-lib=${ZLIB_DIR}/lib \
      --with-zstd-include=${ZSTD_DIR}/include \
      --with-zstd-lib=${ZSTD_DIR}/lib \
      enable-ktls \
      enable-ec_nistp_64_gcc_128 \
      enable-egd \
#     enable-fips \
      enable-ssl-trace\
      enable-trace \
      threads \
      sctp \
      shared \
      --release \
      --prefix=${OPENSSL_33_DIR} \
      && \
    make -j$(nproc) && \
    make -j$(nproc) install

##################################################################
#                   OpenSSL 3.4
##################################################################
RUN mkdir -p ${OPENSSL_34_DIR} ${OPENSSL_34_SRC_DIR}
ADD ${OPENSSL_34_DOWNLOAD_URL} /tmp

RUN tar -xzf ${OPENSSL_34_TEMP} --directory /tmp && \
    cp -rfv ${OPENSSL_34_TEMP_SRC}/* ${OPENSSL_34_SRC_DIR} && \
    ln -sf ${OPENSSL_34_SRC_DIR} ${OPENSSL_34_DIR}/src && \
    cd ${OPENSSL_34_TEMP_SRC} && \
    CFLAGS="-Wno-error -fPIC" CXXFLAGS="-fPIC" ./config \
      zlib \
      --with-zlib-include=${ZLIB_DIR}/include \
      --with-zlib-lib=${ZLIB_DIR}/lib \
      --with-zstd-include=${ZSTD_DIR}/include \
      --with-zstd-lib=${ZSTD_DIR}/lib \
      enable-ktls \
      enable-ec_nistp_64_gcc_128 \
      enable-egd \
#     enable-fips \
      enable-ssl-trace\
      enable-trace \
      threads \
      sctp \
      shared \
      --release \
      --prefix=${OPENSSL_34_DIR} \
      && \
    make -j$(nproc) && \
    make -j$(nproc) install

##################################################################
#                   OpenSSL 3.5
##################################################################
RUN mkdir -p ${OPENSSL_35_DIR} ${OPENSSL_35_SRC_DIR}
ADD ${OPENSSL_35_DOWNLOAD_URL} /tmp

RUN tar -xzf ${OPENSSL_35_TEMP} --directory /tmp && \
    cp -rfv ${OPENSSL_35_TEMP_SRC}/* ${OPENSSL_35_SRC_DIR} && \
    ln -sf ${OPENSSL_35_SRC_DIR} ${OPENSSL_35_DIR}/src && \
    cd ${OPENSSL_35_TEMP_SRC} && \
    CFLAGS="-Wno-error -fPIC" CXXFLAGS="-fPIC" ./config \
      zlib \
      --with-zlib-include=${ZLIB_DIR}/include \
      --with-zlib-lib=${ZLIB_DIR}/lib \
      --with-zstd-include=${ZSTD_DIR}/include \
      --with-zstd-lib=${ZSTD_DIR}/lib \
      enable-ktls \
      enable-ec_nistp_64_gcc_128 \
      enable-egd \
#     enable-fips \
      enable-ssl-trace\
      enable-trace \
      threads \
      sctp \
      shared \
      --release \
      --prefix=${OPENSSL_35_DIR} \
      && \
    make -j$(nproc) && \
    make -j$(nproc) install

##################################################################
#                   LibreSSL
##################################################################
RUN mkdir -p ${LIBRESSL_DIR} ${LIBRESSL_SRC_DIR}
ADD ${LIBRESSL_DOWNLOAD_URL} /tmp

RUN tar -xzf ${LIBRESSL_TEMP} --directory /tmp && \
    cp -rfv ${LIBRESSL_TEMP_SRC}/* ${LIBRESSL_SRC_DIR} && \
    ln -sfv ${LIBRESSL_SRC_DIR} ${LIBRESSL_DIR}/src && \
    cd ${LIBRESSL_TEMP_SRC} && \
    CFLAGS=-Wno-error ./config \
      --enable-static \
      --enable-shared \
      --disable-silent-rules \
      --prefix=${LIBRESSL_DIR} \
      && \
    make -j$(nproc) && \
    make -j$(nproc) install

# ##################################################################
# #                   BoringSSL
# ##################################################################
# RUN mkdir -p ${BORINGSSL_DIR} ${BORINGSSL_SRC_DIR} && \
#     git clone -b ${BORINGSSL_VERSION} ${BORINGSSL_DOWNLOAD_URL} ${BORINGSSL_TEMP_SRC} && \
#     cp -rfv ${BORINGSSL_TEMP_SRC}/* ${BORINGSSL_SRC_DIR} && \
#     ln -sf ${BORINGSSL_SRC_DIR} ${BORINGSSL_DIR}/src && \
#     cd ${BORINGSSL_TEMP_SRC} && \
#     mkdir ${BORINGSSL_TEMP_SRC}/build && \
# #    cmake -GNinja -B build -DCMAKE_BUILD_TYPE=Release -DCMAKE_POSITION_INDEPENDENT_CODE=TRUE -DBUILD_SHARED_LIBS=1 -DCMAKE_INSTALL_PREFIX=${BORINGSSL_DIR} && \
# #    ninja -C build && \
#     cd ${BORINGSSL_TEMP_SRC}/build && \
#     cmake -DCMAKE_BUILD_TYPE=Release -DCMAKE_POSITION_INDEPENDENT_CODE=TRUE -DBUILD_SHARED_LIBS=1 -DCMAKE_INSTALL_PREFIX=${BORINGSSL_DIR} .. && \
#     make -j$(if [ $(nproc) -gt 8 ]; then echo $(( $(nproc) / 2 )); else echo $(nproc); fi) && \
#     make -j$(nproc) install

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
