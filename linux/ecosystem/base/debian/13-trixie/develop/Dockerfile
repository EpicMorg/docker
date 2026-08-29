FROM docker.io/epicmorg/debian:trixie
LABEL maintainer="EpicMorg DevTeam, developer@epicm.org"
ARG DEBIAN_FRONTEND=noninteractive

##################################################################
#                   ARGuments
##################################################################
# /etc/ld.so.conf.d/
ARG LD_CONF_DIR=/etc/ld.so.conf.d/

# cmake compiller
ENV CMAKE_4_3_MIN_VERSION=4.3
ENV CMAKE_4_3_VERSION=${CMAKE_4_3_MIN_VERSION}.3
ENV CMAKE_4_3_DIR=${EMG_LOCAL_BASE_DIR}/cmake/${CMAKE_4_3_MIN_VERSION}
ARG CMAKE_4_3_BIN_DIR=${CMAKE_4_3_DIR}/bin
ARG CMAKE_4_3_DOWNLOAD_URL=https://github.com/Kitware/CMake/releases/download/v${CMAKE_4_3_VERSION}/cmake-${CMAKE_4_3_VERSION}-linux-x86_64.tar.gz
ARG CMAKE_4_3_TEMP=/tmp/cmake-${CMAKE_4_3_VERSION}-linux-x86_64.tar.gz

# cmake compiller
ENV CMAKE_4_2_MIN_VERSION=4.2
ENV CMAKE_4_2_VERSION=${CMAKE_4_2_MIN_VERSION}.6
ENV CMAKE_4_2_DIR=${EMG_LOCAL_BASE_DIR}/cmake/${CMAKE_4_2_MIN_VERSION}
ARG CMAKE_4_2_BIN_DIR=${CMAKE_4_2_DIR}/bin
ARG CMAKE_4_2_DOWNLOAD_URL=https://github.com/Kitware/CMake/releases/download/v${CMAKE_4_2_VERSION}/cmake-${CMAKE_4_2_VERSION}-linux-x86_64.tar.gz
ARG CMAKE_4_2_TEMP=/tmp/cmake-${CMAKE_4_2_VERSION}-linux-x86_64.tar.gz

# cmake compiller
ENV CMAKE_4_1_MIN_VERSION=4.1
ENV CMAKE_4_1_VERSION=${CMAKE_4_1_MIN_VERSION}.6
ENV CMAKE_4_1_DIR=${EMG_LOCAL_BASE_DIR}/cmake/${CMAKE_4_1_MIN_VERSION}
ARG CMAKE_4_1_BIN_DIR=${CMAKE_4_1_DIR}/bin
ARG CMAKE_4_1_DOWNLOAD_URL=https://github.com/Kitware/CMake/releases/download/v${CMAKE_4_1_VERSION}/cmake-${CMAKE_4_1_VERSION}-linux-x86_64.tar.gz
ARG CMAKE_4_1_TEMP=/tmp/cmake-${CMAKE_4_1_VERSION}-linux-x86_64.tar.gz

# cmake compiller
ENV CMAKE_4_0_MIN_VERSION=4.0
ENV CMAKE_4_0_VERSION=${CMAKE_4_0_MIN_VERSION}.7
ENV CMAKE_4_0_DIR=${EMG_LOCAL_BASE_DIR}/cmake/${CMAKE_4_0_MIN_VERSION}
ARG CMAKE_4_0_BIN_DIR=${CMAKE_4_0_DIR}/bin
ARG CMAKE_4_0_DOWNLOAD_URL=https://github.com/Kitware/CMake/releases/download/v${CMAKE_4_0_VERSION}/cmake-${CMAKE_4_0_VERSION}-linux-x86_64.tar.gz
ARG CMAKE_4_0_TEMP=/tmp/cmake-${CMAKE_4_0_VERSION}-linux-x86_64.tar.gz

# cmake compiller
ENV CMAKE_3_31_MIN_VERSION=3.31
ENV CMAKE_3_31_VERSION=${CMAKE_3_31_MIN_VERSION}.12
ENV CMAKE_3_31_DIR=${EMG_LOCAL_BASE_DIR}/cmake/${CMAKE_3_31_MIN_VERSION}
ARG CMAKE_3_31_BIN_DIR=${CMAKE_3_31_DIR}/bin
ARG CMAKE_3_31_DOWNLOAD_URL=https://github.com/Kitware/CMake/releases/download/v${CMAKE_3_31_VERSION}/cmake-${CMAKE_3_31_VERSION}-linux-x86_64.tar.gz
ARG CMAKE_3_31_TEMP=/tmp/cmake-${CMAKE_3_31_VERSION}-linux-x86_64.tar.gz

# cmake compiller
ENV CMAKE_3_30_MIN_VERSION=3.30
ENV CMAKE_3_30_VERSION=${CMAKE_3_30_MIN_VERSION}.9
ENV CMAKE_3_30_DIR=${EMG_LOCAL_BASE_DIR}/cmake/${CMAKE_3_30_MIN_VERSION}
ARG CMAKE_3_30_BIN_DIR=${CMAKE_3_30_DIR}/bin
ARG CMAKE_3_30_DOWNLOAD_URL=https://github.com/Kitware/CMake/releases/download/v${CMAKE_3_30_VERSION}/cmake-${CMAKE_3_30_VERSION}-linux-x86_64.tar.gz
ARG CMAKE_3_30_TEMP=/tmp/cmake-${CMAKE_3_30_VERSION}-linux-x86_64.tar.gz

# cmake compiller
ENV CMAKE_3_25_MIN_VERSION=3.25
ENV CMAKE_3_25_VERSION=${CMAKE_3_25_MIN_VERSION}.3
ENV CMAKE_3_25_DIR=${EMG_LOCAL_BASE_DIR}/cmake/${CMAKE_3_25_MIN_VERSION}
ARG CMAKE_3_25_BIN_DIR=${CMAKE_3_25_DIR}/bin
ARG CMAKE_3_25_DOWNLOAD_URL=https://github.com/Kitware/CMake/releases/download/v${CMAKE_3_25_VERSION}/cmake-${CMAKE_3_25_VERSION}-linux-x86_64.tar.gz
ARG CMAKE_3_25_TEMP=/tmp/cmake-${CMAKE_3_25_VERSION}-linux-x86_64.tar.gz

# cmake compiller
ENV CMAKE_3_21_MIN_VERSION=3.21
ENV CMAKE_3_21_VERSION=${CMAKE_3_21_MIN_VERSION}.7
ENV CMAKE_3_21_DIR=${EMG_LOCAL_BASE_DIR}/cmake/${CMAKE_3_21_MIN_VERSION}
ARG CMAKE_3_21_BIN_DIR=${CMAKE_3_21_DIR}/bin
ARG CMAKE_3_21_DOWNLOAD_URL=https://github.com/Kitware/CMake/releases/download/v${CMAKE_3_21_VERSION}/cmake-${CMAKE_3_21_VERSION}-linux-x86_64.tar.gz
ARG CMAKE_3_21_TEMP=/tmp/cmake-${CMAKE_3_21_VERSION}-linux-x86_64.tar.gz

# cmake compiller
ENV CMAKE_3_20_MIN_VERSION=3.20
ENV CMAKE_3_20_VERSION=${CMAKE_3_20_MIN_VERSION}.6
ENV CMAKE_3_20_DIR=${EMG_LOCAL_BASE_DIR}/cmake/${CMAKE_3_20_MIN_VERSION}
ARG CMAKE_3_20_BIN_DIR=${CMAKE_3_20_DIR}/bin
ARG CMAKE_3_20_DOWNLOAD_URL=https://github.com/Kitware/CMake/releases/download/v${CMAKE_3_20_VERSION}/cmake-${CMAKE_3_20_VERSION}-linux-x86_64.tar.gz
ARG CMAKE_3_20_TEMP=/tmp/cmake-${CMAKE_3_20_VERSION}-linux-x86_64.tar.gz

# cmake compiller
ENV CMAKE_3_19_MIN_VERSION=3.19
ENV CMAKE_3_19_VERSION=${CMAKE_3_19_MIN_VERSION}.8
ENV CMAKE_3_19_DIR=${EMG_LOCAL_BASE_DIR}/cmake/${CMAKE_3_19_MIN_VERSION}
ARG CMAKE_3_19_BIN_DIR=${CMAKE_3_19_DIR}/bin
ARG CMAKE_3_19_DOWNLOAD_URL=https://github.com/Kitware/CMake/releases/download/v${CMAKE_3_19_VERSION}/cmake-${CMAKE_3_19_VERSION}-linux-x86_64.tar.gz
ARG CMAKE_3_19_TEMP=/tmp/cmake-${CMAKE_3_19_VERSION}-linux-x86_64.tar.gz

# cmake compiller
ENV CMAKE_3_18_MIN_VERSION=3.18
ENV CMAKE_3_18_VERSION=${CMAKE_3_18_MIN_VERSION}.6
ENV CMAKE_3_18_DIR=${EMG_LOCAL_BASE_DIR}/cmake/${CMAKE_3_18_MIN_VERSION}
ARG CMAKE_3_18_BIN_DIR=${CMAKE_3_18_DIR}/bin
ARG CMAKE_3_18_DOWNLOAD_URL=https://github.com/Kitware/CMake/releases/download/v${CMAKE_3_18_VERSION}/cmake-${CMAKE_3_18_VERSION}-linux-x86_64.tar.gz
ARG CMAKE_3_18_TEMP=/tmp/cmake-${CMAKE_3_18_VERSION}-linux-x86_64.tar.gz

# cmake compiller
ENV CMAKE_3_17_MIN_VERSION=3.17
ENV CMAKE_3_17_VERSION=${CMAKE_3_17_MIN_VERSION}.5
ENV CMAKE_3_17_DIR=${EMG_LOCAL_BASE_DIR}/cmake/${CMAKE_3_17_MIN_VERSION}
ARG CMAKE_3_17_BIN_DIR=${CMAKE_3_17_DIR}/bin
ARG CMAKE_3_17_DOWNLOAD_URL=https://github.com/Kitware/CMake/releases/download/v${CMAKE_3_17_VERSION}/cmake-${CMAKE_3_17_VERSION}-linux-x86_64.tar.gz
ARG CMAKE_3_17_TEMP=/tmp/cmake-${CMAKE_3_17_VERSION}-linux-x86_64.tar.gz

# cmake compiller
ENV CMAKE_3_16_MIN_VERSION=3.16
ENV CMAKE_3_16_VERSION=${CMAKE_3_16_MIN_VERSION}.9
ENV CMAKE_3_16_DIR=${EMG_LOCAL_BASE_DIR}/cmake/${CMAKE_3_16_MIN_VERSION}
ARG CMAKE_3_16_BIN_DIR=${CMAKE_3_16_DIR}/bin
ARG CMAKE_3_16_DOWNLOAD_URL=https://github.com/Kitware/CMake/releases/download/v${CMAKE_3_16_VERSION}/cmake-${CMAKE_3_16_VERSION}-linux-x86_64.tar.gz
ARG CMAKE_3_16_TEMP=/tmp/cmake-${CMAKE_3_16_VERSION}-linux-x86_64.tar.gz

# flutter source tarball
ENV FLUTTER_CHANNEL=stable
ENV FLUTTER_MIN_VERSION=3.47
ENV FLUTTER_VERSION=${FLUTTER_MIN_VERSION}.0
ENV FLUTTER_DIR=${EMG_LOCAL_BASE_DIR}/flutter/${FLUTTER_MIN_VERSION}
ARG FLUTTER_BIN_DIR=${FLUTTER_DIR}/bin
ARG FLUTTER_DOWNLOAD_URL=https://storage.googleapis.com/flutter_infra_release/releases/${FLUTTER_CHANNEL}/linux/flutter_linux_${FLUTTER_VERSION}-${FLUTTER_CHANNEL}.tar.xz
ARG FLUTTER_TEMP=/tmp/flutter_linux_${FLUTTER_VERSION}-${FLUTTER_CHANNEL}.tar.xz

# ninja source tarball
ENV NINJA_VERSION=1.13.2
ENV NINJA_DIR=${EMG_LOCAL_BASE_DIR}/ninja/${NINJA_VERSION}
ARG NINJA_BIN_DIR=${NINJA_DIR}/bin
ARG NINJA_DOWNLOAD_URL=https://github.com/ninja-build/ninja/releases/download/v${NINJA_VERSION}/ninja-linux.zip
ARG NINJA_TEMP=/tmp/ninja-linux.zip

# GO source tarball
ENV GO_MIN_VERSION=1.26
ENV GO_VERSION=${GO_MIN_VERSION}.6
ENV GO_DIR=${EMG_LOCAL_BASE_DIR}/go/${GO_MIN_VERSION}
ARG GO_BIN_DIR=${GO_DIR}/bin
ARG GO_PATH_DIR=${GO_DIR}/gopath
ARG GO_PATH_BIN_DIR=${GO_PATH_DIR}/bin
ARG GO_DOWNLOAD_URL=https://go.dev/dl/go${GO_VERSION}.linux-amd64.tar.gz
ARG GO_TEMP=/tmp/go${GO_VERSION}.linux-amd64.tar.gz

# PCRE source tarball
ENV PCRE_VERSION=10.47
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
ENV LUAJIT2OR_BIN_DIR=${LUAJIT2OR_DIR}/bin
ENV LUAJIT2OR_LIB_DIR=${LUAJIT2OR_DIR}/lib
ENV LUAJIT2OR_INC_DIR=${LUAJIT2OR_DIR}/include
ENV LUAJIT2OR_SRC_DIR=/usr/local/src/luajit2/${LUAJIT2OR_VERSION}
ARG LUAJIT2OR_DOWNLOAD_URL=https://github.com/openresty/luajit2.git
ARG LUAJIT2OR_TEMP_SRC=/tmp/luajit2

# bzip2 1.0.6 for old software compatibility
ENV BZIP2_106_VERSION=1.0.6
ENV BZIP2_106_INSTALL_DIR=${EMG_LOCAL_BASE_DIR}/bzip2/${BZIP2_106_VERSION}
ARG BZIP2_106_DOWNLOAD_URL=https://sourceware.org/pub/bzip2/bzip2-${BZIP2_106_VERSION}.tar.gz
ARG BZIP2_106_TEMP=/tmp/bzip2-${BZIP2_106_VERSION}.tar.gz
ARG BZIP2_106_TEMP_SRC=/tmp/bzip2-${BZIP2_106_VERSION}

# bzip2 1.0.8
ENV BZIP2_108_VERSION=1.0.8
ENV BZIP2_108_INSTALL_DIR=${EMG_LOCAL_BASE_DIR}/bzip2/${BZIP2_108_VERSION}
ARG BZIP2_108_DOWNLOAD_URL=https://sourceware.org/pub/bzip2/bzip2-${BZIP2_108_VERSION}.tar.gz
ARG BZIP2_108_TEMP=/tmp/bzip2-${BZIP2_108_VERSION}.tar.gz
ARG BZIP2_108_TEMP_SRC=/tmp/bzip2-${BZIP2_108_VERSION}

# libffi-3.0.13 for old software compatibility
ENV FFI_VERSION=3.0.13
ENV FFI_INSTALL_DIR=${EMG_LOCAL_BASE_DIR}/libffi/${FFI_VERSION}
ARG FFI_DOWNLOAD_URL=https://github.com/libffi/libffi/archive/refs/tags/v${FFI_VERSION}.tar.gz
ARG FFI_TEMP=/tmp/libffi-v${FFI_VERSION}.tar.gz
ARG FFI_TEMP_SRC=/tmp/libffi-${FFI_VERSION}

# ncurses-5.9 for old software compatibility
ENV NCURSES_VERSION=5.9
ENV NCURSES_INSTALL_DIR=${EMG_LOCAL_BASE_DIR}/ncurses/${NCURSES_VERSION}
ARG NCURSES_DOWNLOAD_URL=https://invisible-island.net/archives/ncurses/ncurses-${NCURSES_VERSION}.tar.gz
#ARG NCURSES_DOWNLOAD_URL=https://ftp.gnu.org/gnu/ncurses/ncurses-${NCURSES_VERSION}.tar.gz
ARG NCURSES_TEMP=/tmp/ncurses-${NCURSES_VERSION}.tar.gz
ARG NCURSES_TEMP_SRC=/tmp/ncurses-${NCURSES_VERSION}

# libdb-5.3 for old software compatibility
ENV LIBDB_VERSION=5.3.28
ENV LIBDB_INSTALL_DIR=${EMG_LOCAL_BASE_DIR}/libdb/${LIBDB_VERSION}
ARG LIBDB_DOWNLOAD_URL=https://download.oracle.com/berkeley-db/db-${LIBDB_VERSION}.tar.gz
ARG LIBDB_TEMP=/tmp/db-${LIBDB_VERSION}.tar.gz
ARG LIBDB_TEMP_SRC=/tmp/db-${LIBDB_VERSION}

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
ENV ZSTD_DIR=${EMG_LOCAL_BASE_DIR}/zstd/${ZSTD_VERSION}
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
ARG IP2LOC_DOWNLOAD_URL=https://github.com/chrislim2888/IP2Location-C-Library/archive/refs/tags/${IP2LOC_VERSION}.tar.gz
ARG IP2LOC_TEMP=/tmp/${IP2LOC_VERSION}.tar.gz
ARG IP2LOC_TEMP_SRC=/tmp/IP2Location-C-Library-${IP2LOC_VERSION}

# libatomic_ops source tarball
ENV LIBATOMICOPS_VERSION=7.8.4
ENV LIBATOMICOPS_DIR=${EMG_LOCAL_BASE_DIR}/libatomic_ops/${LIBATOMICOPS_VERSION}
ENV LIBATOMICOPS_INC_DIR=${LIBATOMICOPS_DIR}/include
ENV LIBATOMICOPS_LIB_DIR=${LIBATOMICOPS_DIR}/lib
ENV LIBATOMICOPS_SRC_DIR=/usr/local/src/libatomic_ops/${LIBATOMICOPS_VERSION}
ARG LIBATOMICOPS_DOWNLOAD_URL=https://github.com/bdwgc/libatomic_ops/releases/download/v${LIBATOMICOPS_VERSION}/libatomic_ops-${LIBATOMICOPS_VERSION}.tar.gz
ARG LIBATOMICOPS_TEMP=/tmp/libatomic_ops-${LIBATOMICOPS_VERSION}.tar.gz
ARG LIBATOMICOPS_TEMP_SRC=/tmp/libatomic_ops-${LIBATOMICOPS_VERSION}

# libimagequant source
# NOTE: pinned to master deliberately. Upstream tagged 4.4.0 with known issues
# and the fixed 4.5.0 was never tagged. Switch to a tag once one appears.
ENV LIBIMAGEQUANT_VERSION=4.5.0
ARG LIBIMAGEQUANT_DOWNLOAD_URL=https://github.com/ImageOptim/libimagequant
ENV LIBIMAGEQUANT_DIR=${EMG_LOCAL_BASE_DIR}/libimagequant/${LIBIMAGEQUANT_VERSION}
ENV LIBIMAGEQUANT_INC_DIR=${LIBIMAGEQUANT_DIR}/include
ENV LIBIMAGEQUANT_LIB_DIR=${LIBIMAGEQUANT_DIR}/lib
ENV LIBIMAGEQUANT_SRC_DIR=/usr/local/src/libimagequant/${LIBIMAGEQUANT_VERSION}
ARG LIBIMAGEQUANT_TEMP_SRC=/tmp/libimagequant

# libraqm source
ENV LIBRAQM_VERSION=0.11.0
ARG LIBRAQM_DOWNLOAD_URL=https://github.com/HOST-Oman/libraqm
ENV LIBRAQM_DIR=${EMG_LOCAL_BASE_DIR}/libraqm/${LIBRAQM_VERSION}
ENV LIBRAQM_INC_DIR=${LIBRAQM_DIR}/include
ENV LIBRAQM_LIB_DIR=${LIBRAQM_DIR}/lib
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
ENV LIBXML2_VERSION=2.15.3
ENV LIBXML2_DIR=${EMG_LOCAL_BASE_DIR}/libxml2/${LIBXML2_VERSION}
ENV LIBXML2_BIN_DIR=${LIBXML2_DIR}/bin
ENV LIBXML2_INC_DIR=${LIBXML2_DIR}/include
ENV LIBXML2_LIB_DIR=${LIBXML2_DIR}/lib
ENV LIBXML2_SRC_DIR=/usr/local/src/libxml2/${LIBXML2_VERSION}
ARG LIBXML2_DOWNLOAD_URL=https://gitlab.gnome.org/GNOME/libxml2/-/archive/v${LIBXML2_VERSION}/libxml2-v${LIBXML2_VERSION}.tar.gz
ARG LIBXML2_TEMP=/tmp/libxml2-v${LIBXML2_VERSION}.tar.gz
ARG LIBXML2_TEMP_SRC=/tmp/libxml2-v${LIBXML2_VERSION}

# libxslt source tarball
ENV LIBXSLT_VERSION=1.1.45
ENV LIBXSLT_DIR=${EMG_LOCAL_BASE_DIR}/libxslt/${LIBXSLT_VERSION}
ENV LIBXSLT_BIN_DIR=${LIBXSLT_DIR}/bin
ENV LIBXSLT_INC_DIR=${LIBXSLT_DIR}/include
ENV LIBXSLT_LIB_DIR=${LIBXSLT_DIR}/lib
ENV LIBXSLT_SRC_DIR=/usr/local/src/libxslt/${LIBXSLT_VERSION}
ARG LIBXSLT_DOWNLOAD_URL=https://gitlab.gnome.org/GNOME/libxslt/-/archive/v${LIBXSLT_VERSION}/libxslt-v${LIBXSLT_VERSION}.tar.gz
ARG LIBXSLT_TEMP=/tmp/libxslt-v${LIBXSLT_VERSION}.tar.gz
ARG LIBXSLT_TEMP_SRC=/tmp/libxslt-v${LIBXSLT_VERSION}

# maxmind geoip End-Of-Life!
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
ENV GPERFTOOLS_VERSION=2.18.1
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
ARG OPENSSL_111_DOWNLOAD_URL=https://github.com/openssl/openssl/releases/download/OpenSSL_1_1_1w/openssl-1.1.1w.tar.gz
ARG OPENSSL_111_TEMP=/tmp/openssl-${OPENSSL_111_VERSION}w.tar.gz
ARG OPENSSL_111_TEMP_SRC=/tmp/openssl-${OPENSSL_111_VERSION}w

# OpenSSL 3.0 [LTS]
ENV OPENSSL_30_MIN_VERSION=3.0
ENV OPENSSL_30_VERSION=${OPENSSL_30_MIN_VERSION}.21
ENV OPENSSL_30_DIR=${EMG_LOCAL_BASE_DIR}/openssl/${OPENSSL_30_MIN_VERSION}
ENV OPENSSL_30_BIN_DIR=${OPENSSL_30_DIR}/bin
ENV OPENSSL_30_INC_DIR=${OPENSSL_30_DIR}/include
ENV OPENSSL_30_LIB_DIR=${OPENSSL_30_DIR}/lib64
ENV OPENSSL_30_SRC_DIR=/usr/local/src/openssl/${OPENSSL_30_MIN_VERSION}
ARG OPENSSL_30_DOWNLOAD_URL=https://github.com/openssl/openssl/releases/download/openssl-${OPENSSL_30_VERSION}/openssl-${OPENSSL_30_VERSION}.tar.gz
ARG OPENSSL_30_TEMP=/tmp/openssl-${OPENSSL_30_VERSION}.tar.gz
ARG OPENSSL_30_TEMP_SRC=/tmp/openssl-${OPENSSL_30_VERSION}

# OpenSSL 3.1
ENV OPENSSL_31_MIN_VERSION=3.1
ENV OPENSSL_31_VERSION=${OPENSSL_31_MIN_VERSION}.8
ENV OPENSSL_31_DIR=${EMG_LOCAL_BASE_DIR}/openssl/${OPENSSL_31_MIN_VERSION}
ENV OPENSSL_31_BIN_DIR=${OPENSSL_31_DIR}/bin
ENV OPENSSL_31_INC_DIR=${OPENSSL_31_DIR}/include
ENV OPENSSL_31_LIB_DIR=${OPENSSL_31_DIR}/lib64
ENV OPENSSL_31_SRC_DIR=/usr/local/src/openssl/${OPENSSL_31_MIN_VERSION}
ARG OPENSSL_31_DOWNLOAD_URL=https://github.com/openssl/openssl/releases/download/openssl-${OPENSSL_31_VERSION}/openssl-${OPENSSL_31_VERSION}.tar.gz
ARG OPENSSL_31_TEMP=/tmp/openssl-${OPENSSL_31_VERSION}.tar.gz
ARG OPENSSL_31_TEMP_SRC=/tmp/openssl-${OPENSSL_31_VERSION}

# OpenSSL 3.2
ENV OPENSSL_32_MIN_VERSION=3.2
ENV OPENSSL_32_VERSION=${OPENSSL_32_MIN_VERSION}.6
ENV OPENSSL_32_DIR=${EMG_LOCAL_BASE_DIR}/openssl/${OPENSSL_32_MIN_VERSION}
ENV OPENSSL_32_BIN_DIR=${OPENSSL_32_DIR}/bin
ENV OPENSSL_32_INC_DIR=${OPENSSL_32_DIR}/include
ENV OPENSSL_32_LIB_DIR=${OPENSSL_32_DIR}/lib64
ENV OPENSSL_32_SRC_DIR=/usr/local/src/openssl/${OPENSSL_32_MIN_VERSION}
ARG OPENSSL_32_DOWNLOAD_URL=https://github.com/openssl/openssl/releases/download/openssl-${OPENSSL_32_VERSION}/openssl-${OPENSSL_32_VERSION}.tar.gz
ARG OPENSSL_32_TEMP=/tmp/openssl-${OPENSSL_32_VERSION}.tar.gz
ARG OPENSSL_32_TEMP_SRC=/tmp/openssl-${OPENSSL_32_VERSION}

# OpenSSL 3.3
ENV OPENSSL_33_MIN_VERSION=3.3
ENV OPENSSL_33_VERSION=${OPENSSL_33_MIN_VERSION}.7
ENV OPENSSL_33_DIR=${EMG_LOCAL_BASE_DIR}/openssl/${OPENSSL_33_MIN_VERSION}
ENV OPENSSL_33_BIN_DIR=${OPENSSL_33_DIR}/bin
ENV OPENSSL_33_INC_DIR=${OPENSSL_33_DIR}/include
ENV OPENSSL_33_LIB_DIR=${OPENSSL_33_DIR}/lib64
ENV OPENSSL_33_SRC_DIR=/usr/local/src/openssl/${OPENSSL_33_MIN_VERSION}
ARG OPENSSL_33_DOWNLOAD_URL=https://github.com/openssl/openssl/releases/download/openssl-${OPENSSL_33_VERSION}/openssl-${OPENSSL_33_VERSION}.tar.gz
ARG OPENSSL_33_TEMP=/tmp/openssl-${OPENSSL_33_VERSION}.tar.gz
ARG OPENSSL_33_TEMP_SRC=/tmp/openssl-${OPENSSL_33_VERSION}

# OpenSSL 3.4
ENV OPENSSL_34_MIN_VERSION=3.4
ENV OPENSSL_34_VERSION=${OPENSSL_34_MIN_VERSION}.5
ENV OPENSSL_34_DIR=${EMG_LOCAL_BASE_DIR}/openssl/${OPENSSL_34_MIN_VERSION}
ENV OPENSSL_34_BIN_DIR=${OPENSSL_34_DIR}/bin
ENV OPENSSL_34_INC_DIR=${OPENSSL_34_DIR}/include
ENV OPENSSL_34_LIB_DIR=${OPENSSL_34_DIR}/lib64
ENV OPENSSL_34_SRC_DIR=/usr/local/src/openssl/${OPENSSL_34_MIN_VERSION}
ARG OPENSSL_34_DOWNLOAD_URL=https://github.com/openssl/openssl/releases/download/openssl-${OPENSSL_34_VERSION}/openssl-${OPENSSL_34_VERSION}.tar.gz
ARG OPENSSL_34_TEMP=/tmp/openssl-${OPENSSL_34_VERSION}.tar.gz
ARG OPENSSL_34_TEMP_SRC=/tmp/openssl-${OPENSSL_34_VERSION}

# OpenSSL 3.5 [LTS]
ENV OPENSSL_35_MIN_VERSION=3.5
ENV OPENSSL_35_VERSION=${OPENSSL_35_MIN_VERSION}.7
ENV OPENSSL_35_DIR=${EMG_LOCAL_BASE_DIR}/openssl/${OPENSSL_35_MIN_VERSION}
ENV OPENSSL_35_BIN_DIR=${OPENSSL_35_DIR}/bin
ENV OPENSSL_35_INC_DIR=${OPENSSL_35_DIR}/include
ENV OPENSSL_35_LIB_DIR=${OPENSSL_35_DIR}/lib64
ENV OPENSSL_35_SRC_DIR=/usr/local/src/openssl/${OPENSSL_35_MIN_VERSION}
ARG OPENSSL_35_DOWNLOAD_URL=https://github.com/openssl/openssl/releases/download/openssl-${OPENSSL_35_VERSION}/openssl-${OPENSSL_35_VERSION}.tar.gz
ARG OPENSSL_35_TEMP=/tmp/openssl-${OPENSSL_35_VERSION}.tar.gz
ARG OPENSSL_35_TEMP_SRC=/tmp/openssl-${OPENSSL_35_VERSION}

# OpenSSL 3.6
ENV OPENSSL_36_MIN_VERSION=3.6
ENV OPENSSL_36_VERSION=${OPENSSL_36_MIN_VERSION}.3
ENV OPENSSL_36_DIR=${EMG_LOCAL_BASE_DIR}/openssl/${OPENSSL_36_MIN_VERSION}
ENV OPENSSL_36_BIN_DIR=${OPENSSL_36_DIR}/bin
ENV OPENSSL_36_INC_DIR=${OPENSSL_36_DIR}/include
ENV OPENSSL_36_LIB_DIR=${OPENSSL_36_DIR}/lib64
ENV OPENSSL_36_SRC_DIR=/usr/local/src/openssl/${OPENSSL_36_MIN_VERSION}
ARG OPENSSL_36_DOWNLOAD_URL=https://github.com/openssl/openssl/releases/download/openssl-${OPENSSL_36_VERSION}/openssl-${OPENSSL_36_VERSION}.tar.gz
ARG OPENSSL_36_TEMP=/tmp/openssl-${OPENSSL_36_VERSION}.tar.gz
ARG OPENSSL_36_TEMP_SRC=/tmp/openssl-${OPENSSL_36_VERSION}

# OpenSSL 4.0
ENV OPENSSL_40_MIN_VERSION=4.0
ENV OPENSSL_40_VERSION=${OPENSSL_40_MIN_VERSION}.1
ENV OPENSSL_40_DIR=${EMG_LOCAL_BASE_DIR}/openssl/${OPENSSL_40_MIN_VERSION}
ENV OPENSSL_40_BIN_DIR=${OPENSSL_40_DIR}/bin
ENV OPENSSL_40_INC_DIR=${OPENSSL_40_DIR}/include
ENV OPENSSL_40_LIB_DIR=${OPENSSL_40_DIR}/lib64
ENV OPENSSL_40_SRC_DIR=/usr/local/src/openssl/${OPENSSL_40_MIN_VERSION}
ARG OPENSSL_40_DOWNLOAD_URL=https://github.com/openssl/openssl/releases/download/openssl-${OPENSSL_40_VERSION}/openssl-${OPENSSL_40_VERSION}.tar.gz
ARG OPENSSL_40_TEMP=/tmp/openssl-${OPENSSL_40_VERSION}.tar.gz
ARG OPENSSL_40_TEMP_SRC=/tmp/openssl-${OPENSSL_40_VERSION}

# LibreSSL
ENV LIBRESSL_VERSION=4.3.2
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
#                  ICU 73
##################################################################
# Debian Trixie ships ICU 76, whose public headers require C++17.
# PHP's ext/intl compiles with -std=c++11 until PHP 8.1, so anything
# below 8.1 cannot build against the system ICU.
# ICU 73.2 is the last branch whose headers stay C++11-clean.
ENV ICU_73_MIN_VERSION=73
ENV ICU_73_VERSION=${ICU_73_MIN_VERSION}.2
ENV ICU_73_VERSION_U=73_2
ENV ICU_73_DIR=${EMG_LOCAL_BASE_DIR}/icu/${ICU_73_MIN_VERSION}
ENV ICU_73_INC_DIR=${ICU_73_DIR}/include
ENV ICU_73_LIB_DIR=${ICU_73_DIR}/lib
ENV ICU_73_SRC_DIR=/usr/local/src/icu/${ICU_73_MIN_VERSION}
ARG ICU_73_URL=https://github.com/unicode-org/icu/releases/download/release-73-2/icu4c-${ICU_73_VERSION_U}-src.tgz

##################################################################
#                  ICU 67
##################################################################
# Debian Trixie ships ICU 76, whose public headers require C++17.
# PHP's ext/intl compiles with -std=c++11 until PHP 8.1, so anything
# below 8.1 cannot build against the system ICU.
# ICU 73.2 is the last branch whose headers stay C++11-clean.
ENV ICU_67_MIN_VERSION=67
ENV ICU_67_VERSION=${ICU_67_MIN_VERSION}.1
ENV ICU_67_VERSION_U=67_1
ENV ICU_67_DIR=${EMG_LOCAL_BASE_DIR}/icu/${ICU_67_MIN_VERSION}
ENV ICU_67_INC_DIR=${ICU_67_DIR}/include
ENV ICU_67_LIB_DIR=${ICU_67_DIR}/lib
ENV ICU_67_SRC_DIR=/usr/local/src/icu/${ICU_67_MIN_VERSION}
ARG ICU_67_URL=https://github.com/unicode-org/icu/releases/download/release-67-1/icu4c-${ICU_67_VERSION_U}-src.tgz

##################################################################
#           libpq 13 + OpenSSL 1.0.2
##################################################################
ENV LIBPQ_13_VERSION=13
ENV LIBPQ_13_FULL_VERSION=${LIBPQ_13_VERSION}.23
ENV LIBPQ_13_102_DIR=${EMG_LOCAL_BASE_DIR}/libpq/${LIBPQ_13_VERSION}/openssl102
ENV LIBPQ_13_102_INC_DIR=${LIBPQ_13_102_DIR}/include
ENV LIBPQ_13_102_LIB_DIR=${LIBPQ_13_102_DIR}/lib
ENV LIBPQ_13_102_BIN_DIR=${LIBPQ_13_102_DIR}/bin
ENV LIBPQ_13_SRC_DIR=/usr/local/src/postgresql/${LIBPQ_13_VERSION}
ARG LIBPQ_13_URL=https://ftp.postgresql.org/pub/source/v${LIBPQ_13_FULL_VERSION}/postgresql-${LIBPQ_13_FULL_VERSION}.tar.bz2

##################################################################
#           libpq 16 + OpenSSL 1.1.1w + OpenSSL 3.x
##################################################################
# Debian's libpq links OpenSSL 3.x. On PHP branches using OpenSSL 1.1.1 the
# SONAMEs differ (libssl.so.1.1 vs libssl.so.3), so both libraries end up
# loaded in the same process. Building libpq against our OpenSSL removes it.
#
# Only the client library is built - src/interfaces/libpq plus the headers and
# pg_config that PHP's configure needs. A full PostgreSQL build would take
# twenty minutes and pull in dependencies we do not need.
#
# Version note: libpq is forward/backward compatible with a wide range of
# servers, so this is NOT tied to the PHP release date. 16.x is chosen as the
# newest branch that still builds cleanly against OpenSSL 1.1.1.
ENV LIBPQ_16_VERSION=16
ENV LIBPQ_16_FULL_VERSION=${LIBPQ_16_VERSION}.14
ARG LIBPQ_16_URL=https://ftp.postgresql.org/pub/source/v${LIBPQ_16_FULL_VERSION}/postgresql-${LIBPQ_16_FULL_VERSION}.tar.bz2

ENV LIBPQ_16_111_DIR=${EMG_LOCAL_BASE_DIR}/libpq/${LIBPQ_16_VERSION}/openssl111
ENV LIBPQ_16_111_INC_DIR=${LIBPQ_16_111_DIR}/include
ENV LIBPQ_16_111_LIB_DIR=${LIBPQ_16_111_DIR}/lib
ENV LIBPQ_16_111_BIN_DIR=${LIBPQ_16_111_DIR}/bin
ENV LIBPQ_16_111_SRC_DIR=/usr/local/src/postgresql/${LIBPQ_16_VERSION}/openssl111

ENV LIBPQ_16_35_DIR=${EMG_LOCAL_BASE_DIR}/libpq/${LIBPQ_16_VERSION}/openssl35
ENV LIBPQ_16_35_INC_DIR=${LIBPQ_16_35_DIR}/include
ENV LIBPQ_16_35_LIB_DIR=${LIBPQ_16_35_DIR}/lib
ENV LIBPQ_16_35_BIN_DIR=${LIBPQ_16_35_DIR}/bin
ENV LIBPQ_16_35_SRC_DIR=/usr/local/src/postgresql/${LIBPQ_16_VERSION}/openssl35

##################################################################
#           curl 8.17
##################################################################
# Built without ldap / ssh2 / rtmp / gssapi / psl: every one of those links
# against the SYSTEM OpenSSL and would pull libssl.so.3 back into the process,
# defeating the point of building curl at all.
#
# Trade-off, document it in the consumer README: this curl speaks
# http/https/ftp only - no ldap://, scp://, sftp://, rtmp://, no Kerberos auth.
#
# --enable-option-checking=fatal is NOT curl's default: without it an unknown
# or renamed flag is silently ignored and you get a curl with ldap inside while
# believing you disabled it.

ENV CURL_817_VERSION=8.17.0
ENV CURL_817_VERSION_U=8_17_0
ENV CURL_817_SRC_DIR=/usr/local/src/curl/${CURL_817_VERSION}
ARG CURL_817_URL=https://github.com/curl/curl/releases/download/curl-${CURL_817_VERSION_U}/curl-${CURL_817_VERSION}.tar.xz

ENV CURL_817_102_DIR=${EMG_LOCAL_BASE_DIR}/curl/${CURL_817_VERSION}/openssl102
ENV CURL_817_102_BIN_DIR=${CURL_817_102_DIR}/bin
ENV CURL_817_102_INC_DIR=${CURL_817_102_DIR}/include
ENV CURL_817_102_LIB_DIR=${CURL_817_102_DIR}/lib

ENV CURL_817_111_DIR=${EMG_LOCAL_BASE_DIR}/curl/${CURL_817_VERSION}/openssl111
ENV CURL_817_111_BIN_DIR=${CURL_817_111_DIR}/bin
ENV CURL_817_111_INC_DIR=${CURL_817_111_DIR}/include
ENV CURL_817_111_LIB_DIR=${CURL_817_111_DIR}/lib

##################################################################
#           curl 8.21
##################################################################
ENV CURL_821_VERSION=8.21.0
ENV CURL_821_VERSION_U=8_21_0
ENV CURL_821_SRC_DIR=/usr/local/src/curl/${CURL_821_VERSION}
ARG CURL_821_URL=https://github.com/curl/curl/releases/download/curl-${CURL_821_VERSION_U}/curl-${CURL_821_VERSION}.tar.xz

ENV CURL_821_35_DIR=${EMG_LOCAL_BASE_DIR}/curl/${CURL_821_VERSION}/openssl35
ENV CURL_821_35_BIN_DIR=${CURL_821_35_DIR}/bin
ENV CURL_821_35_INC_DIR=${CURL_821_35_DIR}/include
ENV CURL_821_35_LIB_DIR=${CURL_821_35_DIR}/lib

##################################################################
#                   installing
##################################################################
RUN apt-get update && \
    apt-get install -y --no-install-recommends --no-install-suggests --allow-downgrades \
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
    libnghttp2-dev \
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
#    valgrind-dbg \
    valgrind-if-available \
    valgrind-mpi \
    gcovr \
    lcov \
    libsctp-dev \
    libharfbuzz-dev \
    libfribidi-dev \
    libpng-dev \
    libjpeg-dev \
    libfreetype6-dev \
    g++-mingw-w64-ucrt64 \
    gcc-mingw-w64-ucrt64 \
    g++-mingw-w64-x86-64 \
    gcc-mingw-w64-x86-64  \
    mingw-w64 \
    libc6-dev-i386 \
    linux-libc-dev \
    gcc-multilib \
    g++-multilib \
    doxygen && \
      echo "clean up" && \
      apt-get clean -y && \
      apt-get autoclean -y && \
      rm -rfv /var/lib/apt/lists/* && \
      rm -rfv /var/cache/apt/archives/*.deb && \
      rm -rfv /tmp/*

##################################################################
#                   Rust compilers
##################################################################
ENV CARGO_HOME=${EMG_LOCAL_BASE_DIR}/cargo
ENV RUSTUP_HOME=${EMG_LOCAL_BASE_DIR}/rustup
ARG CARGO_BIN=${CARGO_HOME}/bin

RUN set -eux; \
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | stdbuf -e0  sh -s -- -y --no-modify-path --profile complete --default-toolchain stable --verbose

ENV PATH="$CARGO_HOME/bin:${PATH}"

RUN echo "=============================================" && \
    rustup update && \
    echo "=============================================" && \
    echo "installing cargo-c in quiet mode... please wait" && \
    cargo install --quiet --color never --message-format short cargo-c && \
    echo "=============================================" && \
    echo $(cargo --version) && \
    echo "=============================================" && \
    echo $(cargo-cinstall -V) && \
    echo "=============================================" && \
    echo $(rustc --version) && \
    echo "=============================================" && \
    echo $(rustup --version) && \
    echo "============================================="

##################################################################
#                   CMake
##################################################################
RUN set -eux; \
    mkdir -p ${CMAKE_4_3_DIR} \
             ${CMAKE_4_2_DIR} \
             ${CMAKE_4_1_DIR} \
             ${CMAKE_4_0_DIR} \
             ${CMAKE_3_31_DIR} \
             ${CMAKE_3_30_DIR} \
             ${CMAKE_3_25_DIR} \
             ${CMAKE_3_21_DIR} \
             ${CMAKE_3_20_DIR} \
             ${CMAKE_3_19_DIR} \
             ${CMAKE_3_18_DIR} \
             ${CMAKE_3_17_DIR} \
             ${CMAKE_3_16_DIR} && \
    aria2c \
        --conf-path="/usr/local/share/epicmorg/aria2/config/aria2.conf" \
        --user-agent="$(shuf -n 1 /usr/local/share/epicmorg/user-agents/user-agents.txt)" \
        -d / \
        -o ${CMAKE_4_3_TEMP} \
        "${CMAKE_4_3_DOWNLOAD_URL}" && \
    aria2c \
        --conf-path="/usr/local/share/epicmorg/aria2/config/aria2.conf" \
        --user-agent="$(shuf -n 1 /usr/local/share/epicmorg/user-agents/user-agents.txt)" \
        -d / \
        -o ${CMAKE_4_2_TEMP} \
        "${CMAKE_4_2_DOWNLOAD_URL}" && \
    aria2c \
        --conf-path="/usr/local/share/epicmorg/aria2/config/aria2.conf" \
        --user-agent="$(shuf -n 1 /usr/local/share/epicmorg/user-agents/user-agents.txt)" \
        -d / \
        -o ${CMAKE_4_1_TEMP} \
        "${CMAKE_4_1_DOWNLOAD_URL}" && \
    aria2c \
        --conf-path="/usr/local/share/epicmorg/aria2/config/aria2.conf" \
        --user-agent="$(shuf -n 1 /usr/local/share/epicmorg/user-agents/user-agents.txt)" \
        -d / \
        -o ${CMAKE_4_0_TEMP} \
        "${CMAKE_4_0_DOWNLOAD_URL}" && \
    aria2c \
        --conf-path="/usr/local/share/epicmorg/aria2/config/aria2.conf" \
        --user-agent="$(shuf -n 1 /usr/local/share/epicmorg/user-agents/user-agents.txt)" \
        -d / \
        -o ${CMAKE_3_31_TEMP} \
        "${CMAKE_3_31_DOWNLOAD_URL}" && \
    aria2c \
        --conf-path="/usr/local/share/epicmorg/aria2/config/aria2.conf" \
        --user-agent="$(shuf -n 1 /usr/local/share/epicmorg/user-agents/user-agents.txt)" \
        -d / \
        -o ${CMAKE_3_30_TEMP} \
        "${CMAKE_3_30_DOWNLOAD_URL}" && \
    aria2c \
        --conf-path="/usr/local/share/epicmorg/aria2/config/aria2.conf" \
        --user-agent="$(shuf -n 1 /usr/local/share/epicmorg/user-agents/user-agents.txt)" \
        -d / \
        -o ${CMAKE_3_25_TEMP} \
        "${CMAKE_3_25_DOWNLOAD_URL}" && \
    aria2c \
        --conf-path="/usr/local/share/epicmorg/aria2/config/aria2.conf" \
        --user-agent="$(shuf -n 1 /usr/local/share/epicmorg/user-agents/user-agents.txt)" \
        -d / \
        -o ${CMAKE_3_21_TEMP} \
        "${CMAKE_3_21_DOWNLOAD_URL}" && \
    aria2c \
        --conf-path="/usr/local/share/epicmorg/aria2/config/aria2.conf" \
        --user-agent="$(shuf -n 1 /usr/local/share/epicmorg/user-agents/user-agents.txt)" \
        -d / \
        -o ${CMAKE_3_20_TEMP} \
        "${CMAKE_3_20_DOWNLOAD_URL}" && \
    aria2c \
        --conf-path="/usr/local/share/epicmorg/aria2/config/aria2.conf" \
        --user-agent="$(shuf -n 1 /usr/local/share/epicmorg/user-agents/user-agents.txt)" \
        -d / \
        -o ${CMAKE_3_19_TEMP} \
        "${CMAKE_3_19_DOWNLOAD_URL}" && \
    aria2c \
        --conf-path="/usr/local/share/epicmorg/aria2/config/aria2.conf" \
        --user-agent="$(shuf -n 1 /usr/local/share/epicmorg/user-agents/user-agents.txt)" \
        -d / \
        -o ${CMAKE_3_18_TEMP} \
        "${CMAKE_3_18_DOWNLOAD_URL}" && \
    aria2c \
        --conf-path="/usr/local/share/epicmorg/aria2/config/aria2.conf" \
        --user-agent="$(shuf -n 1 /usr/local/share/epicmorg/user-agents/user-agents.txt)" \
        -d / \
        -o ${CMAKE_3_17_TEMP} \
        "${CMAKE_3_17_DOWNLOAD_URL}" && \
    aria2c \
        --conf-path="/usr/local/share/epicmorg/aria2/config/aria2.conf" \
        --user-agent="$(shuf -n 1 /usr/local/share/epicmorg/user-agents/user-agents.txt)" \
        -d / \
        -o ${CMAKE_3_16_TEMP} \
        "${CMAKE_3_16_DOWNLOAD_URL}" && \
    tar -xf ${CMAKE_4_3_TEMP} --directory ${CMAKE_4_3_DIR} --strip-components=1 && \
      chmod +x ${CMAKE_4_3_BIN_DIR}/ccmake && \
      chmod +x ${CMAKE_4_3_BIN_DIR}/cmake && \
      chmod +x ${CMAKE_4_3_BIN_DIR}/cmake-gui && \
      chmod +x ${CMAKE_4_3_BIN_DIR}/cpack && \
      chmod +x ${CMAKE_4_3_BIN_DIR}/ctest  && \
    tar -xf ${CMAKE_4_2_TEMP} --directory ${CMAKE_4_2_DIR} --strip-components=1 && \
      chmod +x ${CMAKE_4_2_BIN_DIR}/ccmake && \
      chmod +x ${CMAKE_4_2_BIN_DIR}/cmake && \
      chmod +x ${CMAKE_4_2_BIN_DIR}/cmake-gui && \
      chmod +x ${CMAKE_4_2_BIN_DIR}/cpack && \
      chmod +x ${CMAKE_4_2_BIN_DIR}/ctest  && \
    tar -xf ${CMAKE_4_1_TEMP} --directory ${CMAKE_4_1_DIR} --strip-components=1 && \
      chmod +x ${CMAKE_4_1_BIN_DIR}/ccmake && \
      chmod +x ${CMAKE_4_1_BIN_DIR}/cmake && \
      chmod +x ${CMAKE_4_1_BIN_DIR}/cmake-gui && \
      chmod +x ${CMAKE_4_1_BIN_DIR}/cpack && \
    tar -xf ${CMAKE_4_0_TEMP} --directory ${CMAKE_4_0_DIR} --strip-components=1 && \
      chmod +x ${CMAKE_4_0_BIN_DIR}/ccmake && \
      chmod +x ${CMAKE_4_0_BIN_DIR}/cmake && \
      chmod +x ${CMAKE_4_0_BIN_DIR}/cmake-gui && \
      chmod +x ${CMAKE_4_0_BIN_DIR}/cpack && \
      chmod +x ${CMAKE_4_0_BIN_DIR}/ctest  && \
    tar -xf ${CMAKE_3_31_TEMP} --directory ${CMAKE_3_31_DIR} --strip-components=1 && \
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
    tar -xf ${CMAKE_3_25_TEMP} --directory ${CMAKE_3_25_DIR} --strip-components=1 && \
      chmod +x ${CMAKE_3_25_BIN_DIR}/ccmake && \
      chmod +x ${CMAKE_3_25_BIN_DIR}/cmake && \
      chmod +x ${CMAKE_3_25_BIN_DIR}/cmake-gui && \
      chmod +x ${CMAKE_3_25_BIN_DIR}/cpack && \
      chmod +x ${CMAKE_3_25_BIN_DIR}/ctest  && \
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
    tar -xf ${CMAKE_3_17_TEMP} --directory ${CMAKE_3_17_DIR} --strip-components=1 && \
      chmod +x ${CMAKE_3_17_BIN_DIR}/ccmake && \
      chmod +x ${CMAKE_3_17_BIN_DIR}/cmake && \
      chmod +x ${CMAKE_3_17_BIN_DIR}/cmake-gui && \
      chmod +x ${CMAKE_3_17_BIN_DIR}/cpack && \
      chmod +x ${CMAKE_3_17_BIN_DIR}/ctest  && \
    tar -xf ${CMAKE_3_16_TEMP} --directory ${CMAKE_3_16_DIR} --strip-components=1 && \
      chmod +x ${CMAKE_3_16_BIN_DIR}/ccmake && \
      chmod +x ${CMAKE_3_16_BIN_DIR}/cmake && \
      chmod +x ${CMAKE_3_16_BIN_DIR}/cmake-gui && \
      chmod +x ${CMAKE_3_16_BIN_DIR}/cpack && \
      chmod +x ${CMAKE_3_16_BIN_DIR}/ctest && \
    echo "clean up" && \
    rm -rfv /tmp/*

# Install default latest version
ENV PATH="${CMAKE_3_31_BIN_DIR}:${PATH}"

RUN echo "=============================================" && \
    echo $(cmake --version) && \
    echo "============================================="

##################################################################
#                   Flutter SDK
##################################################################
RUN set -eux; \
    mkdir -p ${FLUTTER_DIR} && \
    aria2c \
        --conf-path="/usr/local/share/epicmorg/aria2/config/aria2.conf" \
        --user-agent="$(shuf -n 1 /usr/local/share/epicmorg/user-agents/user-agents.txt)" \
        -d /tmp \
        "${FLUTTER_DOWNLOAD_URL}" && \
    tar -xf ${FLUTTER_TEMP} --directory ${FLUTTER_DIR} --strip-components=1 && \
    chmod +x ${FLUTTER_BIN_DIR}/dart && \
    chmod +x ${FLUTTER_BIN_DIR}/flutter && \
    chmod +x ${FLUTTER_BIN_DIR}/internal/shared.sh && \
    chmod +x ${FLUTTER_BIN_DIR}/internal/update_dart_sdk.sh && \
    echo "clean up" && \
    rm -rfv /tmp/*

ENV PATH="${FLUTTER_BIN_DIR}:${PATH}"

RUN git config --global --add safe.directory ${FLUTTER_DIR} && \
    dart --disable-analytics && \
    flutter config --no-analytics && \
    flutter config --no-cli-animations && \
    flutter precache

RUN echo "=============================================" && \
    echo dart $(dart --version) && \
    echo flutter $(flutter --version) && \
    echo "============================================="

##################################################################
#                   GO compillers
##################################################################
RUN set -eux; \
    mkdir -p ${GO_DIR} ${GO_PATH_BIN_DIR} ${GO_BIN_DIR} && \
    aria2c \
        --conf-path="/usr/local/share/epicmorg/aria2/config/aria2.conf" \
        --user-agent="$(shuf -n 1 /usr/local/share/epicmorg/user-agents/user-agents.txt)" \
        -d /tmp \
        "${GO_DOWNLOAD_URL}" && \
    tar -xzf ${GO_TEMP} --directory ${GO_DIR} --strip-components=1 && \
    chmod +x ${GO_BIN_DIR}/go && \
    chmod +x ${GO_BIN_DIR}/gofmt && \
    echo "clean up" && \
    rm -rfv /tmp/*

ENV GOROOT=${GO_DIR}
ENV GOPATH=${GO_PATH_DIR}
ENV PATH="${GO_BIN_DIR}:${GO_PATH_BIN_DIR}:${PATH}"

RUN echo "=============================================" && \
    echo go $(go version) && \
    echo "============================================="

##################################################################
#                   Get NINJA binary
##################################################################
RUN set -eux; \
    mkdir -p ${NINJA_BIN_DIR} && \
    aria2c \
        --conf-path="/usr/local/share/epicmorg/aria2/config/aria2.conf" \
        --user-agent="$(shuf -n 1 /usr/local/share/epicmorg/user-agents/user-agents.txt)" \
        -d /tmp \
        "${NINJA_DOWNLOAD_URL}" && \
    7zz x ${NINJA_TEMP} -o${NINJA_BIN_DIR} -y  && \
    chmod +x ${NINJA_BIN_DIR}/ninja && \
    echo "clean up" && \
    rm -rfv /tmp/*

ENV PATH="${NINJA_BIN_DIR}:${PATH}"

RUN echo "=============================================" && \
    echo ninja $(ninja --version) && \
    echo "============================================="


##################################################################
#                   BZIP2 1.0.6 library
##################################################################
RUN set -eux; \
    mkdir -p ${BZIP2_106_INSTALL_DIR} && \
    aria2c \
        --conf-path="/usr/local/share/epicmorg/aria2/config/aria2.conf" \
        --user-agent="$(shuf -n 1 /usr/local/share/epicmorg/user-agents/user-agents.txt)" \
        -d /tmp \
        "${BZIP2_106_DOWNLOAD_URL}" && \
    tar -xzf ${BZIP2_106_TEMP} -C /tmp && \
    cd ${BZIP2_106_TEMP_SRC} && \
    make -j$(nproc) CFLAGS="-fPIC -O2 -D_FILE_OFFSET_BITS=64" PREFIX=${BZIP2_106_INSTALL_DIR} install && \
    gcc -shared -Wl,-soname,libbz2.so.1.0 -o ${BZIP2_106_INSTALL_DIR}/lib/libbz2.so.1.0.6 libbz2.a && \
    ln -sf ${BZIP2_106_INSTALL_DIR}/lib/libbz2.so.1.0.6 ${BZIP2_106_INSTALL_DIR}/lib/libbz2.so.1.0 && \
    ln -sf ${BZIP2_106_INSTALL_DIR}/lib/libbz2.so.1.0.6 ${BZIP2_106_INSTALL_DIR}/lib/libbz2.so && \
    echo "clean up" && \
    rm -rfv /tmp/*

##################################################################
#                   BZIP2 1.0.8 library
##################################################################
RUN set -eux; \
    mkdir -p ${BZIP2_108_INSTALL_DIR} && \
    aria2c \
        --conf-path="/usr/local/share/epicmorg/aria2/config/aria2.conf" \
        --user-agent="$(shuf -n 1 /usr/local/share/epicmorg/user-agents/user-agents.txt)" \
        -d /tmp \
        "${BZIP2_108_DOWNLOAD_URL}" && \
    tar -xzf ${BZIP2_108_TEMP} -C /tmp && \
    cd ${BZIP2_108_TEMP_SRC} && \
    make -j$(nproc) CFLAGS="-fPIC -O2 -D_FILE_OFFSET_BITS=64" PREFIX=${BZIP2_108_INSTALL_DIR} install && \
    gcc -shared -Wl,-soname,libbz2.so.1.0 -o ${BZIP2_108_INSTALL_DIR}/lib/libbz2.so.1.0.8 libbz2.a && \
    ln -sf ${BZIP2_108_INSTALL_DIR}/lib/libbz2.so.1.0.8 ${BZIP2_108_INSTALL_DIR}/lib/libbz2.so.1.0 && \
    ln -sf ${BZIP2_108_INSTALL_DIR}/lib/libbz2.so.1.0.8 ${BZIP2_108_INSTALL_DIR}/lib/libbz2.so && \
    echo "clean up" && \
    rm -rfv /tmp/*

##################################################################
#                   FFI library
##################################################################
RUN set -eux; \
    mkdir -p ${FFI_INSTALL_DIR} && \
    aria2c \
        --conf-path="/usr/local/share/epicmorg/aria2/config/aria2.conf" \
        --user-agent="$(shuf -n 1 /usr/local/share/epicmorg/user-agents/user-agents.txt)" \
        -d / \
        -o ${FFI_TEMP} \
        "${FFI_DOWNLOAD_URL}" && \
    tar -xzf ${FFI_TEMP} -C /tmp && \
    cd ${FFI_TEMP_SRC} && \
    ./configure \
        --prefix=${FFI_INSTALL_DIR} \
        --enable-shared \
        --disable-static \
    && \
    make -j$(nproc) && \
    make install && \
    echo "clean up" && \
    rm -rfv /tmp/*

##################################################################
#                   ncurses library
##################################################################
# Issue: https://github.com/pbouda/buildroot-qt-dev/issues/6
COPY tmp/ncurses-${NCURSES_VERSION}-const.patch /tmp/ncurses-${NCURSES_VERSION}-const.patch
COPY tmp/ncurses-${NCURSES_VERSION}-gcc-5.patch /tmp/ncurses-${NCURSES_VERSION}-gcc-5.patch

RUN mkdir -p ${NCURSES_INSTALL_DIR} && \
    aria2c \
        --conf-path="/usr/local/share/epicmorg/aria2/config/aria2.conf" \
        --user-agent="$(shuf -n 1 /usr/local/share/epicmorg/user-agents/user-agents.txt)" \
        -d /tmp \
        "${NCURSES_DOWNLOAD_URL}" && \
    tar -xzf ${NCURSES_TEMP} -C /tmp && \
    cd ${NCURSES_TEMP_SRC} && \
    mv /tmp/ncurses-${NCURSES_VERSION}-const.patch . && \
    mv /tmp/ncurses-${NCURSES_VERSION}-gcc-5.patch . && \
    patch -p1 < ncurses-${NCURSES_VERSION}-gcc-5.patch && \
    patch -p1 < ncurses-${NCURSES_VERSION}-const.patch && \
    ./configure \
        CXXFLAGS="-std=c++11" \
        --prefix=${NCURSES_INSTALL_DIR} \
        --with-shared \
        --with-cxx-shared \
        --without-debug \
        --without-ada \
        --enable-widec \
        --enable-symlinks \
        --with-normal \
        && \
    make -j$(nproc) && \
    make install && \
    echo "clean up" && \
    rm -rfv /tmp/*

##################################################################
#                   libdb library
##################################################################
RUN set -eux; \
    mkdir -p ${LIBDB_INSTALL_DIR} && \
    aria2c \
        --conf-path="/usr/local/share/epicmorg/aria2/config/aria2.conf" \
        --user-agent="$(shuf -n 1 /usr/local/share/epicmorg/user-agents/user-agents.txt)" \
        -d /tmp \
        "${LIBDB_DOWNLOAD_URL}" && \
    tar -xzf ${LIBDB_TEMP} -C /tmp && \
    cd ${LIBDB_TEMP_SRC}/build_unix && \
    ../dist/configure \
        CFLAGS="-std=gnu89" \
        --prefix=${LIBDB_INSTALL_DIR} \
        --enable-cxx=no \
        --enable-java=no \
        --enable-tcl=no \
    && \
    make -j$(nproc) && \
    make install && \
    echo "clean up" && \
    rm -rfv /tmp/*

##################################################################
#                   ZLIB library
##################################################################
RUN set -eux; \
    mkdir -p ${ZLIB_DIR} ${ZLIB_SRC_DIR} && \
    aria2c \
        --conf-path="/usr/local/share/epicmorg/aria2/config/aria2.conf" \
        --user-agent="$(shuf -n 1 /usr/local/share/epicmorg/user-agents/user-agents.txt)" \
        -d /tmp \
        "${ZLIB_DOWNLOAD_URL}" && \
    tar -xzf ${ZLIB_TEMP} --directory /tmp && \
    cp -rfv ${ZLIB_TEMP_SRC}/* ${ZLIB_SRC_DIR} && \
    ln -sf ${ZLIB_SRC_DIR}  ${ZLIB_DIR}/src && \
    cd ${ZLIB_TEMP_SRC} && \
    ./configure \
      --prefix=${ZLIB_DIR} \
      && \
    make -j$(nproc) && \
    make -j$(nproc) install && \
    echo "clean up" && \
    rm -rfv /tmp/*

##################################################################
#                   ZSTD library
##################################################################
RUN set -eux; \
    mkdir -p ${ZSTD_DIR} ${ZSTD_SRC_DIR} && \
    aria2c \
        --conf-path="/usr/local/share/epicmorg/aria2/config/aria2.conf" \
        --user-agent="$(shuf -n 1 /usr/local/share/epicmorg/user-agents/user-agents.txt)" \
        -d /tmp \
        "${ZSTD_DOWNLOAD_URL}" && \
    tar -xzf ${ZSTD_TEMP} --directory /tmp && \
    cp -rfv ${ZSTD_TEMP_SRC}/* ${ZSTD_SRC_DIR} && \
    ln -sf ${ZSTD_SRC_DIR}  ${ZSTD_DIR}/src && \
    cd ${ZSTD_TEMP_SRC} && \
    mkdir -p ${ZSTD_TEMP_SRC}/build/cmake/builddir && \
    cd ${ZSTD_TEMP_SRC}/build/cmake/builddir && \
    cmake -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=${ZSTD_DIR} -DZSTD_BUILD_STATIC=ON -DZSTD_BUILD_SHARED=ON .. && \
    make -j$(nproc) && \
    make -j$(nproc) install && \
    echo "clean up" && \
    rm -rfv /tmp/*

ENV PATH="${ZSTD_BIN_DIR}:${PATH}"

##################################################################
#                   PRCE2 static library
##################################################################
RUN set -eux; \
    mkdir -p ${PCRE_BIN_DIR} ${PCRE_SRC_DIR} && \
    aria2c \
        --conf-path="/usr/local/share/epicmorg/aria2/config/aria2.conf" \
        --user-agent="$(shuf -n 1 /usr/local/share/epicmorg/user-agents/user-agents.txt)" \
        -d /tmp \
        "${PCRE_DOWNLOAD_URL}" && \
    tar -xzf ${PCRE_TEMP} --directory /tmp && \
    cp -rfv ${PCRE_TEMP_SRC}/* ${PCRE_SRC_DIR} && \
    ln -sf ${PCRE_SRC_DIR} ${PCRE_DIR}/src && \
    cd ${PCRE_TEMP_SRC} && \
    ./configure --prefix=${PCRE_DIR} \
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
        && \
    make -j$(nproc) && \
    make -j$(nproc) install && \
    echo "clean up" && \
    rm -rfv /tmp/*

ENV PATH="${PCRE_BIN_DIR}:${PATH}"

RUN echo "=============================================" && \
    echo pcre2 $(pcre2-config --version) && \
    echo "============================================="

##################################################################
#                   LuaJIT2 OpenResty 2.1
##################################################################
# See https://github.com/openresty/lua-nginx-module/issues/1834
RUN set -eux; \
    mkdir -p ${LUAJIT2OR_DIR} ${LUAJIT2OR_SRC_DIR} && \
    git clone ${LUAJIT2OR_DOWNLOAD_URL} ${LUAJIT2OR_TEMP_SRC} && \
    cp -rfv ${LUAJIT2OR_TEMP_SRC}/* ${LUAJIT2OR_SRC_DIR} && \
    ln -sf ${LUAJIT2OR_SRC_DIR} ${LUAJIT2OR_DIR}/src && \
    cd ${LUAJIT2OR_TEMP_SRC} && \
#    make -j$(nproc) XCFLAGS='-DLUAJIT_ENABLE_GC64' BUILDMODE=static && \
    make -j$(nproc) XCFLAGS='-DLUAJIT_ENABLE_GC64' BUILDMODE=mixed && \
    make -j$(nproc) install PREFIX=${LUAJIT2OR_DIR} && \
    ln -sfv ${LUAJIT2OR_INC_DIR}/luajit-2.1/* ${LUAJIT2OR_INC_DIR}/ && \
    echo "clean up" && \
    rm -rfv /tmp/*

ENV PATH="${LUAJIT2OR_BIN_DIR}:${PATH}"

RUN echo "=============================================" && \
    echo luajit $(luajit -v) && \
    echo "============================================="

##################################################################
#                   IP2Location
##################################################################
RUN set -eux; \
    mkdir -p ${IP2LOC_DIR} ${IP2LOC_SRC_DIR} && \
    aria2c \
        --conf-path="/usr/local/share/epicmorg/aria2/config/aria2.conf" \
        --user-agent="$(shuf -n 1 /usr/local/share/epicmorg/user-agents/user-agents.txt)" \
        -d / \
        -o ${IP2LOC_TEMP} \
        "${IP2LOC_DOWNLOAD_URL}" && \
    tar -xzf ${IP2LOC_TEMP} --directory /tmp && \
    cp -rfv ${IP2LOC_TEMP_SRC}/* ${IP2LOC_SRC_DIR} && \
    ln -sf ${IP2LOC_SRC_DIR} ${IP2LOC_DIR}/src && \
    cd ${IP2LOC_TEMP_SRC} && \
    autoreconf -i -v --force && \
    aclocal && \
    automake --gnu --add-missing && \
    autoconf && \
    autoreconf -i -v --force && \
    ./configure \
      --prefix=${IP2LOC_DIR} \
      --disable-silent-rules \
      --enable-shared \
      --enable-static \
      && \
    make -j$(nproc) && \
    make -j$(nproc) install && \
    echo "clean up" && \
    rm -rfv /tmp/*

ENV PATH="${IP2LOC_BIN_DIR}:${PATH}"

##################################################################
#                   libatomic_ops
##################################################################
RUN set -eux; \
    mkdir -p ${LIBATOMICOPS_DIR} ${LIBATOMICOPS_SRC_DIR} && \
    aria2c \
        --conf-path="/usr/local/share/epicmorg/aria2/config/aria2.conf" \
        --user-agent="$(shuf -n 1 /usr/local/share/epicmorg/user-agents/user-agents.txt)" \
        -d /tmp \
        "${LIBATOMICOPS_DOWNLOAD_URL}" && \
    tar -xzf ${LIBATOMICOPS_TEMP} --directory /tmp && \
    cp -rfv ${LIBATOMICOPS_TEMP_SRC}/* ${LIBATOMICOPS_SRC_DIR} && \
    ln -sfv ${LIBATOMICOPS_SRC_DIR} ${LIBATOMICOPS_DIR}/src && \
    cd ${LIBATOMICOPS_TEMP_SRC} && \
    ./autogen.sh && \
    ./configure \
      --prefix=${LIBATOMICOPS_DIR} \
      --disable-silent-rules \
      --enable-shared \
      --enable-static \
      && \
    make -j$(nproc) && \
    make -j$(nproc) install && \
    ln -sfv ${LIBATOMICOPS_SRC_DIR} ${LIBATOMICOPS_SRC_DIR}/src && \
    echo "clean up" && \
    rm -rfv /tmp/*

##################################################################
#                   libimagequant
##################################################################
RUN set -eux; \
    mkdir -p ${LIBIMAGEQUANT_DIR} ${LIBIMAGEQUANT_SRC_DIR} && \
    git clone ${LIBIMAGEQUANT_DOWNLOAD_URL} ${LIBIMAGEQUANT_TEMP_SRC} && \
    cp -rfv ${LIBIMAGEQUANT_TEMP_SRC}/* ${LIBIMAGEQUANT_SRC_DIR} && \
    ln -sf ${LIBIMAGEQUANT_SRC_DIR} ${LIBIMAGEQUANT_DIR}/src && \
    cd ${LIBIMAGEQUANT_TEMP_SRC} && \
      cargo build --release && \
    cd ${LIBIMAGEQUANT_TEMP_SRC}/imagequant-sys && \
      cargo cinstall \
          --release \
          --prefix=${LIBIMAGEQUANT_DIR} \
          --libdir=${LIBIMAGEQUANT_LIB_DIR} \
          --includedir=${LIBIMAGEQUANT_INC_DIR} && \
    echo "clean up" && \
    rm -rfv /tmp/*

# Assert: installed into OUR prefix, not /usr/local
RUN RUN set -eu; \
    echo "--- libimagequant ---"; \
    ls -la ${LIBIMAGEQUANT_LIB_DIR}/; \
    test -f ${LIBIMAGEQUANT_LIB_DIR}/pkgconfig/imagequant.pc \
      || { echo "FATAL: imagequant.pc missing - libgd will not find it" >&2; exit 1; }; \
    cat ${LIBIMAGEQUANT_LIB_DIR}/pkgconfig/imagequant.pc; \
    test -f ${LIBIMAGEQUANT_INC_DIR}/libimagequant.h \
      || { echo "FATAL: libimagequant.h missing" >&2; exit 1; }; \
    if [ -f ${LIBIMAGEQUANT_LIB_DIR}/libimagequant.so ]; then \
      readelf -d ${LIBIMAGEQUANT_LIB_DIR}/libimagequant.so | grep NEEDED; \
      ldd ${LIBIMAGEQUANT_LIB_DIR}/libimagequant.so | grep -q 'not found' \
        && { echo "FATAL: unresolved deps" >&2; exit 1; }; \
      echo "OK: libimagequant (shared) -> ${LIBIMAGEQUANT_DIR}"; \
    elif [ -f ${LIBIMAGEQUANT_LIB_DIR}/libimagequant.a ]; then \
      echo "OK: libimagequant (static only) -> ${LIBIMAGEQUANT_DIR}"; \
    else \
      echo "FATAL: no libimagequant library at all" >&2; \
      ls -la ${LIBIMAGEQUANT_DIR}/ >&2; exit 1; \
    fi

##################################################################
#                   libraqm
##################################################################
RUN set -eux; \
    mkdir -p ${LIBRAQM_DIR} ${LIBRAQM_SRC_DIR} && \
    git clone --depth 1 --branch v${LIBRAQM_VERSION} ${LIBRAQM_DOWNLOAD_URL} ${LIBRAQM_TEMP_SRC} && \
    cp -rfv ${LIBRAQM_TEMP_SRC}/* ${LIBRAQM_SRC_DIR} && \
    ln -sfv ${LIBRAQM_SRC_DIR} ${LIBRAQM_DIR}/src && \
    cd ${LIBRAQM_TEMP_SRC} && \
    meson setup build \
      --prefix=${LIBRAQM_DIR} \
      --libdir=lib \
      --buildtype=release \
      -Ddefault_library=shared \
      -Ddocs=false && \
    ninja -C build && \
    ninja -C build install && \
    echo "clean up" && \
    rm -rfv /tmp/*

# Assert: installed into OUR prefix
RUN set -eu; \
    echo "--- libraqm ---"; \
    test -f ${LIBRAQM_LIB_DIR}/libraqm.so || { \
      echo "FATAL: libraqm.so not in ${LIBRAQM_LIB_DIR}" >&2; \
      ls -la ${LIBRAQM_DIR}/ >&2; exit 1; }; \
    test -f ${LIBRAQM_LIB_DIR}/pkgconfig/raqm.pc || { \
      echo "FATAL: raqm.pc missing - libgd will not find it" >&2; exit 1; }; \
    readelf -d ${LIBRAQM_LIB_DIR}/libraqm.so | grep NEEDED; \
    ldd ${LIBRAQM_LIB_DIR}/libraqm.so | grep -q 'not found' && { \
      echo "FATAL: unresolved deps" >&2; ldd ${LIBRAQM_LIB_DIR}/libraqm.so >&2; exit 1; }; \
    echo "OK: libraqm -> ${LIBRAQM_DIR}"

##################################################################
#                   libgd
##################################################################
RUN set -eux; \
    mkdir -p ${LIBGD_DIR} ${LIBGD_SRC_DIR} && \
    aria2c \
        --conf-path="/usr/local/share/epicmorg/aria2/config/aria2.conf" \
        --user-agent="$(shuf -n 1 /usr/local/share/epicmorg/user-agents/user-agents.txt)" \
        -d /tmp \
        "${LIBGD_DOWNLOAD_URL}" && \
    tar -xzf ${LIBGD_TEMP} --directory /tmp && \
    cp -rfv ${LIBGD_TEMP_SRC}/* ${LIBGD_SRC_DIR} && \
    ln -sf ${LIBGD_SRC_DIR} ${LIBGD_DIR}/src && \
    cd ${LIBGD_TEMP_SRC} && \
    export PKG_CONFIG_PATH="${LIBRAQM_LIB_DIR}/pkgconfig:${LIBIMAGEQUANT_LIB_DIR}/pkgconfig:${PKG_CONFIG_PATH:-}" && \
    export LDFLAGS="-L${LIBRAQM_LIB_DIR} -Wl,-rpath,${LIBRAQM_LIB_DIR} -L${LIBIMAGEQUANT_LIB_DIR} -Wl,-rpath,${LIBIMAGEQUANT_LIB_DIR} ${LDFLAGS:-}" && \
    ./bootstrap.sh && \
    ./configure \
      --prefix=${LIBGD_DIR} \
      --disable-silent-rules \
      --enable-static \
      --enable-shared \
      --with-libiconv-prefix \
      --with-zlib=${ZLIB_DIR} \
      --with-png --with-freetype \
      --with-raqm=${LIBRAQM_DIR} \
      --with-fontconfig \
      --with-jpeg \
      --with-liq=${LIBIMAGEQUANT_DIR} \
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
    echo "clean up" && \
    rm -rfv /tmp/*

ENV PATH="${LIBGD_BIN_DIR}:${PATH}" 

RUN set -eu; \
    echo "--- libgd ---"; \
    so="${LIBGD_LIB_DIR}/libgd.so"; \
    readelf -d "$so" | grep NEEDED; \
    ldd "$so" | grep -q 'not found' && { echo "FATAL: unresolved deps" >&2; ldd "$so" >&2; exit 1; }; \
    for dep in libraqm libimagequant; do \
      if readelf -d "$so" | grep -q "${dep}"; then \
        ldd "$so" | grep "${dep}" | grep -q "${EMG_LOCAL_BASE_DIR}" \
          || { echo "FATAL: ${dep} resolved outside our prefix" >&2; ldd "$so" | grep "${dep}" >&2; exit 1; }; \
      fi; \
    done; \
    echo "OK: libgd"

##################################################################
#                   libxml2
##################################################################
# NOTE: --with-icu is deliberately OFF. It links the system ICU 76, which then
# leaks into every consumer (nginx, libxslt) and drags libicuuc/libicudata into
# the process. Nothing here needs ICU-based Unicode normalisation.
RUN set -eux; \
    mkdir -p ${LIBXML2_DIR} ${LIBXML2_SRC_DIR} && \
    aria2c \
        --conf-path="/usr/local/share/epicmorg/aria2/config/aria2.conf" \
        --user-agent="$(shuf -n 1 /usr/local/share/epicmorg/user-agents/user-agents.txt)" \
        -d /tmp \
        "${LIBXML2_DOWNLOAD_URL}" && \
    tar -xzf ${LIBXML2_TEMP} --directory /tmp && \
    cp -rfv ${LIBXML2_TEMP_SRC}/* ${LIBXML2_SRC_DIR} && \
    ln -sf ${LIBXML2_SRC_DIR} ${LIBXML2_DIR}/src && \
    cd ${LIBXML2_TEMP_SRC} && \
    export PKG_CONFIG_PATH="${ZLIB_LIB_DIR}/pkgconfig:${PKG_CONFIG_PATH:-}" && \
    export CFLAGS="-fPIC ${CFLAGS:-}" && \
    export CXXFLAGS="-fPIC ${CXXFLAGS:-}" && \
    export CPPFLAGS="-I${ZLIB_INC_DIR}" && \
    export LDFLAGS="-L${ZLIB_LIB_DIR} -Wl,-rpath,${ZLIB_LIB_DIR}" && \
    ./autogen.sh && \
    ./configure \
      --prefix=${LIBXML2_DIR} \
      --libdir=${LIBXML2_LIB_DIR} \
      --disable-silent-rules \
      --enable-static \
      --enable-shared \
      --without-python \
      --without-icu \
      --with-c14n \
      --with-catalog \
      --with-history \
      --with-html \
      --with-iconv \
      --with-iso8859x \
      --with-legacy \
      --with-lzma \
      --with-output \
      --with-pattern \
      --with-push \
      --with-reader \
      --with-readline \
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
      --with-zlib=${ZLIB_DIR} \
      && \
    make -j$(nproc) && \
    make -j$(nproc) install && \
    echo "clean up" && \
    rm -rfv /tmp/*

ENV PATH="${LIBXML2_BIN_DIR}:${PATH}"

# Assert: our libxml2 exists, resolves cleanly and does NOT pull system ICU.
RUN set -eu; \
    echo "--- libxml2 ---"; \
    so="${LIBXML2_LIB_DIR}/libxml2.so"; \
    test -f "$so" || { echo "FATAL: no libxml2.so in ${LIBXML2_LIB_DIR}" >&2; ls -la ${LIBXML2_DIR}/ >&2; exit 1; }; \
    readelf -d "$so" | grep NEEDED; \
    ldd "$so" | grep -q 'not found' && { echo "FATAL: unresolved deps" >&2; ldd "$so" >&2; exit 1; }; \
    if readelf -d "$so" | grep -qi 'libicu'; then \
      echo "FATAL: libxml2 still links ICU - remove --with-icu" >&2; \
      readelf -d "$so" | grep -i icu >&2; exit 1; \
    fi; \
    ldd "$so" | grep -q "${ZLIB_LIB_DIR}/libz" \
      || { echo "WARN: zlib not resolved from our prefix"; ldd "$so" | grep -i libz; }; \
    ${LIBXML2_BIN_DIR}/xml2-config --version; \
    ${LIBXML2_BIN_DIR}/xml2-config --prefix; \
    echo "OK: libxml2 -> ${LIBXML2_DIR}"

##################################################################
#                   libxslt
##################################################################
# --with-libxml-prefix is what actually pins OUR libxml2. Without it libxslt
# picks up the system libxml2.so.2 and every consumer ends up loading two
# different libxml2 into one process.
RUN set -eux; \
    mkdir -p ${LIBXSLT_DIR} ${LIBXSLT_SRC_DIR} && \
    aria2c \
        --conf-path="/usr/local/share/epicmorg/aria2/config/aria2.conf" \
        --user-agent="$(shuf -n 1 /usr/local/share/epicmorg/user-agents/user-agents.txt)" \
        -d /tmp \
        "${LIBXSLT_DOWNLOAD_URL}" && \
    tar -xzf ${LIBXSLT_TEMP} --directory /tmp && \
    cp -rfv ${LIBXSLT_TEMP_SRC}/* ${LIBXSLT_SRC_DIR} && \
    ln -sf ${LIBXSLT_SRC_DIR} ${LIBXSLT_DIR}/src && \
    cd ${LIBXSLT_TEMP_SRC} && \
    export PATH="${LIBXML2_BIN_DIR}:${PATH}" && \
    export PKG_CONFIG_PATH="${LIBXML2_LIB_DIR}/pkgconfig:${ZLIB_LIB_DIR}/pkgconfig:${PKG_CONFIG_PATH:-}" && \
    export LIBXML_CFLAGS="-I${LIBXML2_INC_DIR}/libxml2 -I${LIBXML2_INC_DIR}" && \
    export LIBXML_LIBS="-L${LIBXML2_LIB_DIR} -lxml2" && \
    export CPPFLAGS="-I${LIBXML2_INC_DIR}/libxml2 -I${LIBXML2_INC_DIR} -I${ZLIB_INC_DIR}" && \
    export CFLAGS="-fPIC ${CFLAGS:-}" && \
    export CXXFLAGS="-fPIC ${CXXFLAGS:-}" && \
    export LDFLAGS="-L${LIBXML2_LIB_DIR} -Wl,-rpath,${LIBXML2_LIB_DIR} -L${ZLIB_LIB_DIR} -Wl,-rpath,${ZLIB_LIB_DIR}" && \
    ./autogen.sh && \
    ./configure \
      --prefix=${LIBXSLT_DIR} \
      --libdir=${LIBXSLT_LIB_DIR} \
      --disable-silent-rules \
      --enable-static \
      --enable-shared \
      --without-python \
      --without-crypto \
      --with-plugins \
      --with-profiler \
      && \
    make -j$(nproc) && \
    make -j$(nproc) install && \
    echo "clean up" && \
    rm -rfv /tmp/*

ENV PATH="${LIBXSLT_BIN_DIR}:${PATH}"

# Assert: libxslt links OUR libxml2, not the system one.
# The SONAMEs differ (ours 2.15 -> libxml2.so.16, Debian's -> libxml2.so.2),
# so a mismatch means both would be loaded into the same process.
RUN set -eu; \
    echo "--- libxslt ---"; \
    for so in ${LIBXSLT_LIB_DIR}/libxslt.so ${LIBXSLT_LIB_DIR}/libexslt.so; do \
      test -f "$so" || { echo "FATAL: $so missing" >&2; ls -la ${LIBXSLT_DIR}/ >&2; exit 1; }; \
      echo "--- $so ---"; \
      readelf -d "$so" | grep NEEDED; \
      ldd "$so" | grep -q 'not found' && { echo "FATAL: unresolved deps in $so" >&2; ldd "$so" >&2; exit 1; }; \
      if ldd "$so" | grep -i 'libxml2' | grep -qv "${LIBXML2_LIB_DIR}"; then \
        echo "FATAL: $so resolves libxml2 outside ${LIBXML2_LIB_DIR}" >&2; \
        ldd "$so" | grep -i libxml2 >&2; exit 1; \
      fi; \
      if [ "$(ldd "$so" | grep -c -i 'libxml2')" != "1" ]; then \
        echo "FATAL: more than one libxml2 in $so" >&2; \
        ldd "$so" | grep -i libxml2 >&2; exit 1; \
      fi; \
      if readelf -d "$so" | grep -qi 'libicu'; then \
        echo "FATAL: $so links ICU via libxml2" >&2; \
        readelf -d "$so" | grep -i icu >&2; exit 1; \
      fi; \
    done; \
    ${LIBXSLT_BIN_DIR}/xslt-config --version; \
    ${LIBXSLT_BIN_DIR}/xsltproc --version; \
    echo "OK: libxslt -> ${LIBXML2_LIB_DIR}"

##################################################################
#                   MAxMind GeoIP
##################################################################
RUN set -eux; \
    mkdir -p ${MM_GEOIP_DIR} ${MM_GEOIP_SRC_DIR} && \
    aria2c \
        --conf-path="/usr/local/share/epicmorg/aria2/config/aria2.conf" \
        --user-agent="$(shuf -n 1 /usr/local/share/epicmorg/user-agents/user-agents.txt)" \
        -d /tmp \
        "${MM_GEOIP_DOWNLOAD_URL}" && \
    tar -xzf ${MM_GEOIP_TEMP} --directory /tmp && \
    cp -rfv ${MM_GEOIP_TEMP_SRC}/* ${MM_GEOIP_SRC_DIR} && \
    ln -sf ${MM_GEOIP_SRC_DIR} ${MM_GEOIP_DIR}/src && \
    cd ${MM_GEOIP_TEMP_SRC} && \
    ./bootstrap && \
    aclocal && \
    autoconf && \
    automake --add-missing && \
    ./configure \
      --prefix=${MM_GEOIP_DIR} \
      --disable-silent-rules \
      --enable-shared \
      --enable-static \
      && \
    make -j$(nproc) && \
    make -j$(nproc) install && \
    echo "clean up" && \
    rm -rfv /tmp/*

ENV PATH="${MM_GEOIP_BIN_DIR}:${PATH}" 

##################################################################
#                   Google perftools
##################################################################
RUN set -eux; \
    mkdir -p ${GPERFTOOLS_DIR} ${GPERFTOOLS_SRC_DIR} && \
    aria2c \
        --conf-path="/usr/local/share/epicmorg/aria2/config/aria2.conf" \
        --user-agent="$(shuf -n 1 /usr/local/share/epicmorg/user-agents/user-agents.txt)" \
        -d /tmp \
        "${GPERFTOOLS_DOWNLOAD_URL}" && \
    tar -xzf ${GPERFTOOLS_TEMP} --directory /tmp && \
    cp -rfv ${GPERFTOOLS_TEMP_SRC}/* ${GPERFTOOLS_SRC_DIR} && \
    ln -sf ${GPERFTOOLS_SRC_DIR} ${GPERFTOOLS_DIR}/src && \
    cd ${GPERFTOOLS_TEMP_SRC} && \
    ./configure \
      --prefix=${GPERFTOOLS_DIR} \
      --disable-silent-rules \
      --enable-shared \
      --enable-static \
      --enable-libunwind \
      --enable-large-alloc-report \
      --enable-aggressive-decommit-by-default \
      && \
    make -j$(nproc) && \
    make -j$(nproc) install && \
    echo "clean up" && \
    rm -rfv /tmp/*

ENV PATH="${GPERFTOOLS_BIN_DIR}:${PATH}" 

##################################################################
#                   OpenSSL 1.0.2u
##################################################################
RUN set -eux; \
    mkdir -p ${OPENSSL_102_DIR} ${OPENSSL_102_SRC_DIR} && \
    aria2c \
        --conf-path="/usr/local/share/epicmorg/aria2/config/aria2.conf" \
        --user-agent="$(shuf -n 1 /usr/local/share/epicmorg/user-agents/user-agents.txt)" \
        -d /tmp \
        "${OPENSSL_102_DOWNLOAD_URL}" && \
    tar -xzf ${OPENSSL_102_TEMP} --directory /tmp && \
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
      sctp \
      shared \
      --release \
      --prefix=${OPENSSL_102_DIR} \
      && \
    make -j$(nproc) && \
    make -j$(nproc) install && \
    echo "clean up" && \
    rm -rfv /tmp/*

##################################################################
#                   OpenSSL 1.1.1w
##################################################################
RUN set -eux; \
    mkdir -p ${OPENSSL_111_DIR} ${OPENSSL_111_SRC_DIR} && \
    aria2c \
        --conf-path="/usr/local/share/epicmorg/aria2/config/aria2.conf" \
        --user-agent="$(shuf -n 1 /usr/local/share/epicmorg/user-agents/user-agents.txt)" \
        -d /tmp \
        "${OPENSSL_111_DOWNLOAD_URL}" && \
    tar -xzf ${OPENSSL_111_TEMP} --directory /tmp && \
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
    make -j$(nproc) install && \
    echo "clean up" && \
    rm -rfv /tmp/*

##################################################################
#                   OpenSSL 3.0
##################################################################
RUN set -eux; \
    mkdir -p ${OPENSSL_30_DIR} ${OPENSSL_30_SRC_DIR} && \
    aria2c \
        --conf-path="/usr/local/share/epicmorg/aria2/config/aria2.conf" \
        --user-agent="$(shuf -n 1 /usr/local/share/epicmorg/user-agents/user-agents.txt)" \
        -d /tmp \
        "${OPENSSL_30_DOWNLOAD_URL}" && \
    tar -xzf ${OPENSSL_30_TEMP} --directory /tmp && \
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
      enable-ssl-trace\
      enable-trace \
      threads \
      sctp \
      shared \
      --release \
      --prefix=${OPENSSL_30_DIR} \
      && \
    make -j$(nproc) && \
    make -j$(nproc) install && \
    echo "clean up" && \
    rm -rfv /tmp/*

##################################################################
#                   OpenSSL 3.1
##################################################################
RUN set -eux; \
    mkdir -p ${OPENSSL_31_DIR} ${OPENSSL_31_SRC_DIR} && \
    aria2c \
        --conf-path="/usr/local/share/epicmorg/aria2/config/aria2.conf" \
        --user-agent="$(shuf -n 1 /usr/local/share/epicmorg/user-agents/user-agents.txt)" \
        -d /tmp \
        "${OPENSSL_31_DOWNLOAD_URL}" && \
    tar -xzf ${OPENSSL_31_TEMP} --directory /tmp && \
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
      enable-ssl-trace\
      enable-trace \
      threads \
      sctp \
      shared \
      --release \
      --prefix=${OPENSSL_31_DIR} \
      && \
    make -j$(nproc) && \
    make -j$(nproc) install && \
    echo "clean up" && \
    rm -rfv /tmp/*

##################################################################
#                   OpenSSL 3.2
##################################################################
RUN set -eux; \
    mkdir -p ${OPENSSL_32_DIR} ${OPENSSL_32_SRC_DIR} && \
    aria2c \
        --conf-path="/usr/local/share/epicmorg/aria2/config/aria2.conf" \
        --user-agent="$(shuf -n 1 /usr/local/share/epicmorg/user-agents/user-agents.txt)" \
        -d /tmp \
        "${OPENSSL_32_DOWNLOAD_URL}" && \
    tar -xzf ${OPENSSL_32_TEMP} --directory /tmp && \
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
      enable-ssl-trace\
      enable-trace \
      threads \
      sctp \
      shared \
      --release \
      --prefix=${OPENSSL_32_DIR} \
      && \
    make -j$(nproc) && \
    make -j$(nproc) install && \
    echo "clean up" && \
    rm -rfv /tmp/*

##################################################################
#                   OpenSSL 3.3
##################################################################
RUN set -eux; \
    mkdir -p ${OPENSSL_33_DIR} ${OPENSSL_33_SRC_DIR} && \
    aria2c \
        --conf-path="/usr/local/share/epicmorg/aria2/config/aria2.conf" \
        --user-agent="$(shuf -n 1 /usr/local/share/epicmorg/user-agents/user-agents.txt)" \
        -d /tmp \
        "${OPENSSL_33_DOWNLOAD_URL}" && \
    tar -xzf ${OPENSSL_33_TEMP} --directory /tmp && \
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
      enable-ssl-trace\
      enable-trace \
      threads \
      sctp \
      shared \
      --release \
      --prefix=${OPENSSL_33_DIR} \
      && \
    make -j$(nproc) && \
    make -j$(nproc) install && \
    echo "clean up" && \
    rm -rfv /tmp/*

##################################################################
#                   OpenSSL 3.4
##################################################################
RUN set -eux; \
    mkdir -p ${OPENSSL_34_DIR} ${OPENSSL_34_SRC_DIR} && \
    aria2c \
        --conf-path="/usr/local/share/epicmorg/aria2/config/aria2.conf" \
        --user-agent="$(shuf -n 1 /usr/local/share/epicmorg/user-agents/user-agents.txt)" \
        -d /tmp \
        "${OPENSSL_34_DOWNLOAD_URL}" && \
    tar -xzf ${OPENSSL_34_TEMP} --directory /tmp && \
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
      enable-ssl-trace\
      enable-trace \
      threads \
      sctp \
      shared \
      --release \
      --prefix=${OPENSSL_34_DIR} \
      && \
    make -j$(nproc) && \
    make -j$(nproc) install && \
    echo "clean up" && \
    rm -rfv /tmp/*

##################################################################
#                   OpenSSL 3.5
##################################################################
RUN set -eux; \
    mkdir -p ${OPENSSL_35_DIR} ${OPENSSL_35_SRC_DIR} && \
    aria2c \
        --conf-path="/usr/local/share/epicmorg/aria2/config/aria2.conf" \
        --user-agent="$(shuf -n 1 /usr/local/share/epicmorg/user-agents/user-agents.txt)" \
        -d /tmp \
        "${OPENSSL_35_DOWNLOAD_URL}" && \
    tar -xzf ${OPENSSL_35_TEMP} --directory /tmp && \
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
      enable-ssl-trace\
      enable-trace \
      threads \
      sctp \
      shared \
      --release \
      --prefix=${OPENSSL_35_DIR} \
      && \
    make -j$(nproc) && \
    make -j$(nproc) install && \
    echo "clean up" && \
    rm -rfv /tmp/*

##################################################################
#                   OpenSSL 3.6
##################################################################
RUN set -eux; \
    mkdir -p ${OPENSSL_36_DIR} ${OPENSSL_36_SRC_DIR} && \
    aria2c \
        --conf-path="/usr/local/share/epicmorg/aria2/config/aria2.conf" \
        --user-agent="$(shuf -n 1 /usr/local/share/epicmorg/user-agents/user-agents.txt)" \
        -d /tmp \
        "${OPENSSL_36_DOWNLOAD_URL}" && \
    tar -xzf ${OPENSSL_36_TEMP} --directory /tmp && \
    cp -rfv ${OPENSSL_36_TEMP_SRC}/* ${OPENSSL_36_SRC_DIR} && \
    ln -sf ${OPENSSL_36_SRC_DIR} ${OPENSSL_36_DIR}/src && \
    cd ${OPENSSL_36_TEMP_SRC} && \
    CFLAGS="-Wno-error -fPIC" CXXFLAGS="-fPIC" ./config \
      zlib \
      --with-zlib-include=${ZLIB_DIR}/include \
      --with-zlib-lib=${ZLIB_DIR}/lib \
      --with-zstd-include=${ZSTD_DIR}/include \
      --with-zstd-lib=${ZSTD_DIR}/lib \
      enable-ktls \
      enable-ec_nistp_64_gcc_128 \
      enable-egd \
      enable-ssl-trace\
      enable-trace \
      threads \
      sctp \
      shared \
      --release \
      --prefix=${OPENSSL_36_DIR} \
      && \
    make -j$(nproc) && \
    make -j$(nproc) install && \
    echo "clean up" && \
    rm -rfv /tmp/*

##################################################################
#                   OpenSSL 4.0
##################################################################
RUN set -eux; \
    mkdir -p ${OPENSSL_40_DIR} ${OPENSSL_40_SRC_DIR} && \
    aria2c \
        --conf-path="/usr/local/share/epicmorg/aria2/config/aria2.conf" \
        --user-agent="$(shuf -n 1 /usr/local/share/epicmorg/user-agents/user-agents.txt)" \
        -d /tmp \
        "${OPENSSL_40_DOWNLOAD_URL}" && \
    tar -xzf ${OPENSSL_40_TEMP} --directory /tmp && \
    cp -rfv ${OPENSSL_40_TEMP_SRC}/* ${OPENSSL_40_SRC_DIR} && \
    ln -sf ${OPENSSL_40_SRC_DIR} ${OPENSSL_40_DIR}/src && \
    cd ${OPENSSL_40_TEMP_SRC} && \
    CFLAGS="-Wno-error -fPIC" CXXFLAGS="-fPIC" ./config \
      zlib \
      --with-zlib-include=${ZLIB_DIR}/include \
      --with-zlib-lib=${ZLIB_DIR}/lib \
      --with-zstd-include=${ZSTD_DIR}/include \
      --with-zstd-lib=${ZSTD_DIR}/lib \
      enable-ktls \
      enable-ec_nistp_64_gcc_128 \
      enable-egd \
      enable-ssl-trace\
      enable-trace \
      threads \
      sctp \
      shared \
      --release \
      --prefix=${OPENSSL_40_DIR} \
      && \
    make -j$(nproc) && \
    make -j$(nproc) install && \
    echo "clean up" && \
    rm -rfv /tmp/*

##################################################################
#                   LibreSSL
##################################################################
RUN set -eux; \
    mkdir -p ${LIBRESSL_DIR} ${LIBRESSL_SRC_DIR} && \
    aria2c \
        --conf-path="/usr/local/share/epicmorg/aria2/config/aria2.conf" \
        --user-agent="$(shuf -n 1 /usr/local/share/epicmorg/user-agents/user-agents.txt)" \
        -d /tmp \
        "${LIBRESSL_DOWNLOAD_URL}" && \
    tar -xzf ${LIBRESSL_TEMP} --directory /tmp && \
    cp -rfv ${LIBRESSL_TEMP_SRC}/* ${LIBRESSL_SRC_DIR} && \
    ln -sfv ${LIBRESSL_SRC_DIR} ${LIBRESSL_DIR}/src && \
    cd ${LIBRESSL_TEMP_SRC} && \
    ./config \
      --enable-static \
      --enable-shared \
      --disable-silent-rules \
      --prefix=${LIBRESSL_DIR} \
      && \
    make -j$(nproc) && \
    make -j$(nproc) install && \
    echo "clean up" && \
    rm -rfv /tmp/*

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
#                   ICU 67 library
##################################################################
RUN set -eux; \
    mkdir -p /usr/local/src/icu; \
    aria2c \
        --conf-path=/usr/local/share/epicmorg/aria2/config/aria2.conf \
        --user-agent="$(shuf -n 1 /usr/local/share/epicmorg/user-agents/user-agents.txt)" \
        -d /tmp -o icu4c.tgz "${ICU_67_URL}"; \
    tar -xzf /tmp/icu4c.tgz -C /usr/local/src/icu; \
    mv /usr/local/src/icu/icu ${ICU_67_SRC_DIR}; \
    cd ${ICU_67_SRC_DIR}/source; \
    export LDFLAGS="-Wl,-rpath,${ICU_67_LIB_DIR}";  \
    ./configure \
      --prefix=${ICU_67_DIR} \
      --libdir=${ICU_67_LIB_DIR} \
      --disable-samples \
      --disable-tests \
      --disable-static \
      --enable-shared; \
    make -j"$(nproc)"; \
    make install; \
    rm -f /tmp/icu4c.tgz; \
    test -f ${ICU_67_LIB_DIR}/libicuuc.so || { \
      echo "FATAL: ICU libs not in ${ICU_67_LIB_DIR}" >&2; ls -la ${ICU_67_DIR}/ >&2; exit 1; }

##################################################################
#                   ICU 73 library
##################################################################
RUN set -eux; \
    mkdir -p /usr/local/src/icu; \
    aria2c \
        --conf-path=/usr/local/share/epicmorg/aria2/config/aria2.conf \
        --user-agent="$(shuf -n 1 /usr/local/share/epicmorg/user-agents/user-agents.txt)" \
        -d /tmp -o icu4c.tgz "${ICU_73_URL}"; \
    tar -xzf /tmp/icu4c.tgz -C /usr/local/src/icu; \
    mv /usr/local/src/icu/icu ${ICU_73_SRC_DIR}; \
    cd ${ICU_73_SRC_DIR}/source; \
    export LDFLAGS="-Wl,-rpath,${ICU_73_LIB_DIR}";  \
    ./configure \
      --prefix=${ICU_73_DIR} \
      --libdir=${ICU_73_LIB_DIR} \
      --disable-samples \
      --disable-tests \
      --disable-static \
      --enable-shared; \
    make -j"$(nproc)"; \
    make install; \
    rm -f /tmp/icu4c.tgz; \
    test -f ${ICU_73_LIB_DIR}/libicuuc.so || { \
      echo "FATAL: ICU libs not in ${ICU_73_LIB_DIR}" >&2; ls -la ${ICU_73_DIR}/ >&2; exit 1; }

##################################################################
#           libpq 13 + OpenSSL 1.0.2
##################################################################
RUN set -eux; \
    mkdir -p ${LIBPQ_13_SRC_DIR}; \
    aria2c \
        --conf-path=/usr/local/share/epicmorg/aria2/config/aria2.conf \
        --user-agent="$(shuf -n 1 /usr/local/share/epicmorg/user-agents/user-agents.txt)" \
        -d /tmp -o postgresql.tar.bz2 "${LIBPQ_13_URL}"; \
    tar -xjf /tmp/postgresql.tar.bz2 --strip-components=1 -C ${LIBPQ_13_SRC_DIR}; \
    cd ${LIBPQ_13_SRC_DIR}; \
    export PKG_CONFIG_PATH="${OPENSSL_102_LIB_DIR}/pkgconfig"; \
    export CPPFLAGS="-I${OPENSSL_102_INC_DIR}"; \
    export LDFLAGS="-L${OPENSSL_102_LIB_DIR} -Wl,-rpath,${OPENSSL_102_LIB_DIR}"; \
    ./configure \
      --prefix=${LIBPQ_13_102_DIR} \
      --libdir=${LIBPQ_13_102_LIB_DIR} \
      --with-openssl \
      --without-readline \
      --without-zlib \
      --without-icu; \
    make -C src/interfaces/libpq -j"$(nproc)"; \
    make -C src/interfaces/libpq install; \
    make -C src/include install; \
    make -C src/bin/pg_config install; \
    rm -f /tmp/postgresql.tar.bz2

RUN set -eu; \
    ldd ${LIBPQ_13_102_LIB_DIR}/libpq.so | grep -q "${OPENSSL_102_LIB_DIR}/libssl" || { \
      echo "FATAL: libpq not linked against ${OPENSSL_102_LIB_DIR}" >&2; \
      ldd ${LIBPQ_13_102_LIB_DIR}/libpq.so >&2; exit 1; }; \
    echo "OK: libpq -> ${OPENSSL_102_LIB_DIR}"

##################################################################
#           libpq 16 + OpenSSL 1.1.1w
##################################################################
RUN set -eux; \
    mkdir -p ${LIBPQ_16_111_SRC_DIR}; \
    aria2c \
        --conf-path=/usr/local/share/epicmorg/aria2/config/aria2.conf \
        --user-agent="$(shuf -n 1 /usr/local/share/epicmorg/user-agents/user-agents.txt)" \
        -d /tmp -o postgresql.tar.bz2 "${LIBPQ_16_URL}"; \
    tar -xjf /tmp/postgresql.tar.bz2 --strip-components=1 -C ${LIBPQ_16_111_SRC_DIR}; \
    cd ${LIBPQ_16_111_SRC_DIR}; \
    export PKG_CONFIG_PATH="${OPENSSL_111_LIB_DIR}/pkgconfig"; \
    export CPPFLAGS="-I${OPENSSL_111_INC_DIR}"; \
    export LDFLAGS="-L${OPENSSL_111_LIB_DIR} -Wl,-rpath,${OPENSSL_111_LIB_DIR}"; \
    ./configure \
      --prefix=${LIBPQ_16_111_DIR} \
      --libdir=${LIBPQ_16_111_LIB_DIR} \
      --with-openssl \
      --without-readline \
      --without-zlib \
      --without-icu; \
    make -C src/interfaces/libpq -j"$(nproc)"; \
    make -C src/interfaces/libpq install; \
    make -C src/include install; \
    make -C src/bin/pg_config install; \
    make distclean; \
    rm -f /tmp/postgresql.tar.bz2

RUN set -eu; \
    ldd ${LIBPQ_16_111_LIB_DIR}/libpq.so | grep -q "${OPENSSL_111_LIB_DIR}/libssl" || { \
      echo "FATAL: libpq not linked against ${OPENSSL_111_LIB_DIR}" >&2; \
      ldd ${LIBPQ_16_111_LIB_DIR}/libpq.so >&2; exit 1; }; \
    echo "OK: libpq -> ${OPENSSL_111_LIB_DIR}"

##################################################################
#           libpq 16 + OpenSSL 3.5.x
##################################################################
RUN set -eux; \
    mkdir -p ${LIBPQ_16_35_SRC_DIR}; \
    aria2c \
        --conf-path=/usr/local/share/epicmorg/aria2/config/aria2.conf \
        --user-agent="$(shuf -n 1 /usr/local/share/epicmorg/user-agents/user-agents.txt)" \
        -d /tmp -o postgresql.tar.bz2 "${LIBPQ_16_URL}"; \
    tar -xjf /tmp/postgresql.tar.bz2 --strip-components=1 -C ${LIBPQ_16_35_SRC_DIR}; \
    cd ${LIBPQ_16_35_SRC_DIR}; \
    export PKG_CONFIG_PATH="${OPENSSL_35_LIB_DIR}/pkgconfig"; \
    export CPPFLAGS="-I${OPENSSL_35_INC_DIR}"; \
    export LDFLAGS="-L${OPENSSL_35_LIB_DIR} -Wl,-rpath,${OPENSSL_35_LIB_DIR}"; \
    ./configure \
      --prefix=${LIBPQ_16_35_DIR} \
      --libdir=${LIBPQ_16_35_LIB_DIR} \
      --with-openssl \
      --without-readline \
      --without-zlib \
      --without-icu; \
    make -C src/interfaces/libpq -j"$(nproc)"; \
    make -C src/interfaces/libpq install; \
    make -C src/include install; \
    make -C src/bin/pg_config install; \
    make distclean; \
    rm -f /tmp/postgresql.tar.bz2

RUN set -eu; \
    so="${LIBPQ_16_35_LIB_DIR}/libpq.so"; \
    ldd "$so" | grep -q "${OPENSSL_35_LIB_DIR}/libssl" || { \
      echo "FATAL: libpq not linked against ${OPENSSL_35_LIB_DIR}" >&2; exit 1; }; \
    if nm -D --undefined-only "$so" | grep -qE 'SSL_get_peer_certificate|ERR_put_error'; then \
      echo "FATAL: libpq built against OpenSSL 1.x API (removed in 3.0)" >&2; \
      nm -D --undefined-only "$so" | grep -E 'SSL_get_peer_certificate|ERR_put_error' >&2; \
      exit 1; \
    fi; \
    printf '#include <libpq-fe.h>\nint main(){return PQlibVersion();}\n' > /tmp/t.c; \
    gcc /tmp/t.c -I${LIBPQ_16_35_INC_DIR} -L${LIBPQ_16_35_LIB_DIR} -lpq -o /tmp/t \
      || { echo "FATAL: libpq does not link" >&2; exit 1; }; \
    rm -f /tmp/t /tmp/t.c; \
    echo "OK: libpq -> ${OPENSSL_35_LIB_DIR}"

##################################################################
#           curl 8.17 (linked against our OpenSSL 1.0.2)
##################################################################
RUN set -eux; \
    mkdir -p ${CURL_817_SRC_DIR}; \
    aria2c \
        --conf-path=/usr/local/share/epicmorg/aria2/config/aria2.conf \
        --user-agent="$(shuf -n 1 /usr/local/share/epicmorg/user-agents/user-agents.txt)" \
        -d /tmp -o curl.tar.xz "${CURL_817_URL}"; \
    tar -xJf /tmp/curl.tar.xz --strip-components=1 -C ${CURL_817_SRC_DIR}; \
    cd ${CURL_817_SRC_DIR}; \
    export PKG_CONFIG_PATH="${OPENSSL_102_LIB_DIR}/pkgconfig"; \
    export CPPFLAGS="-I${OPENSSL_102_INC_DIR}"; \
    export LDFLAGS="-L${OPENSSL_102_LIB_DIR} -Wl,-rpath,${OPENSSL_102_LIB_DIR} -Wl,-rpath,${CURL_817_102_LIB_DIR}"; \
    ./configure \
      --prefix=${CURL_817_102_DIR} \
      --libdir=${CURL_817_102_LIB_DIR} \
      --enable-option-checking=fatal \
      \
      `# ---- TLS: ours, and only ours ----` \
      --with-openssl=${OPENSSL_102_DIR} \
      --without-gnutls \
      --without-mbedtls \
      --without-wolfssl \
      --with-ca-bundle=/etc/ssl/certs/ca-certificates.crt \
      --with-ca-path=/etc/ssl/certs \
      \
      `# ---- keep ----` \
      --with-zlib \
      --with-nghttp2 \
      --enable-versioned-symbols \
      --enable-shared \
      --disable-static \
      \
      `# ---- drop: each of these links the system OpenSSL ----` \
      --without-libssh2 \
      --without-libssh \
      --without-libpsl \
      --disable-ldap \
      --disable-ldaps \
      --without-gssapi \
      --disable-gopher \
      --disable-dict \
      --disable-telnet \
      --disable-tftp \
      --disable-rtsp \
      --disable-smb \
      --disable-pop3 \
      --disable-imap \
      --disable-smtp \
    ; \
    make -j"$(nproc)"; \
    make install; \
    rm -f /tmp/curl.tar.xz

RUN set -eu; \
    so="${CURL_817_102_LIB_DIR}/libcurl.so"; \
    echo "--- curl NEEDED ---"; \
    readelf -d "$so" | grep NEEDED; \
    for bad in libldap liblber libssh2 libssh librtmp libgssapi libpsl; do \
      if readelf -d "$so" | grep -q "\[${bad}"; then \
        echo "FATAL: libcurl still links ${bad} - it will drag in the system OpenSSL" >&2; \
        exit 1; \
      fi; \
    done; \
    if ldd "$so" | grep -q 'not found'; then \
      echo "FATAL: libcurl has unresolved deps" >&2; ldd "$so" >&2; exit 1; \
    fi; \
    ldd "$so" | grep -q "${OPENSSL_102_LIB_DIR}/libssl" || { \
      echo "FATAL: libcurl not linked against ${OPENSSL_102_LIB_DIR}" >&2; \
      ldd "$so" >&2; exit 1; }; \
    backends="$(${CURL_817_102_BIN_DIR}/curl-config --ssl-backends)"; \
    echo "curl ssl backends: ${backends}"; \
    case "${backends}" in \
      *OpenSSL*) ;; \
      *) echo "FATAL: unexpected TLS backend: ${backends}" >&2; exit 1 ;; \
    esac; \
    ${CURL_817_102_BIN_DIR}/curl --version; \
    echo "OK: libcurl ${CURL_817_VERSION} -> ${OPENSSL_102_LIB_DIR}"

##################################################################
#           curl 8.17 (linked against our OpenSSL 1.1.1)
##################################################################
RUN set -eux; \
    mkdir -p ${CURL_817_SRC_DIR}; \
    aria2c \
        --conf-path=/usr/local/share/epicmorg/aria2/config/aria2.conf \
        --user-agent="$(shuf -n 1 /usr/local/share/epicmorg/user-agents/user-agents.txt)" \
        -d /tmp -o curl.tar.xz "${CURL_817_URL}"; \
    tar -xJf /tmp/curl.tar.xz --strip-components=1 -C ${CURL_817_SRC_DIR}; \
    cd ${CURL_817_SRC_DIR}; \
    export PKG_CONFIG_PATH="${OPENSSL_111_LIB_DIR}/pkgconfig"; \
    export CPPFLAGS="-I${OPENSSL_111_INC_DIR}"; \
    export LDFLAGS="-L${OPENSSL_111_LIB_DIR} -Wl,-rpath,${OPENSSL_111_LIB_DIR} -Wl,-rpath,${CURL_817_111_LIB_DIR}"; \
    ./configure \
      --prefix=${CURL_817_111_DIR} \
      --libdir=${CURL_817_111_LIB_DIR} \
      --enable-option-checking=fatal \
      \
      `# ---- TLS: ours, and only ours ----` \
      --with-openssl=${OPENSSL_111_DIR} \
      --without-gnutls \
      --without-mbedtls \
      --without-wolfssl \
      --with-ca-bundle=/etc/ssl/certs/ca-certificates.crt \
      --with-ca-path=/etc/ssl/certs \
      \
      `# ---- keep ----` \
      --with-zlib \
      --with-nghttp2 \
      --enable-versioned-symbols \
      --enable-shared \
      --disable-static \
      \
      `# ---- drop: each of these links the system OpenSSL ----` \
      --without-libssh2 \
      --without-libssh \
      --without-libpsl \
      --disable-ldap \
      --disable-ldaps \
      --without-gssapi \
      --disable-gopher \
      --disable-dict \
      --disable-telnet \
      --disable-tftp \
      --disable-rtsp \
      --disable-smb \
      --disable-pop3 \
      --disable-imap \
      --disable-smtp \
    ; \
    make -j"$(nproc)"; \
    make install; \
    rm -f /tmp/curl.tar.xz

RUN set -eu; \
    so="${CURL_817_111_LIB_DIR}/libcurl.so"; \
    echo "--- curl NEEDED ---"; \
    readelf -d "$so" | grep NEEDED; \
    for bad in libldap liblber libssh2 libssh librtmp libgssapi libpsl; do \
      if readelf -d "$so" | grep -q "\[${bad}"; then \
        echo "FATAL: libcurl still links ${bad} - it will drag in the system OpenSSL" >&2; \
        exit 1; \
      fi; \
    done; \
    if ldd "$so" | grep -q 'not found'; then \
      echo "FATAL: libcurl has unresolved deps" >&2; ldd "$so" >&2; exit 1; \
    fi; \
    ldd "$so" | grep -q "${OPENSSL_111_LIB_DIR}/libssl" || { \
      echo "FATAL: libcurl not linked against ${OPENSSL_111_LIB_DIR}" >&2; \
      ldd "$so" >&2; exit 1; }; \
    backends="$(${CURL_817_111_BIN_DIR}/curl-config --ssl-backends)"; \
    echo "curl ssl backends: ${backends}"; \
    case "${backends}" in \
      *OpenSSL*) ;; \
      *) echo "FATAL: unexpected TLS backend: ${backends}" >&2; exit 1 ;; \
    esac; \
    ${CURL_817_111_BIN_DIR}/curl --version; \
    echo "OK: libcurl ${CURL_817_VERSION} -> ${OPENSSL_111_LIB_DIR}"
 
##################################################################
#           curl 8.21 (linked against our OpenSSL 3.5.x)
##################################################################
RUN set -eux; \
    mkdir -p ${CURL_821_SRC_DIR}; \
    aria2c \
        --conf-path=/usr/local/share/epicmorg/aria2/config/aria2.conf \
        --user-agent="$(shuf -n 1 /usr/local/share/epicmorg/user-agents/user-agents.txt)" \
        -d /tmp -o curl.tar.xz "${CURL_821_URL}"; \
    tar -xJf /tmp/curl.tar.xz --strip-components=1 -C ${CURL_821_SRC_DIR}; \
    cd ${CURL_821_SRC_DIR}; \
    export PKG_CONFIG_PATH="${OPENSSL_35_LIB_DIR}/pkgconfig"; \
    export CPPFLAGS="-I${OPENSSL_35_INC_DIR}"; \
    export LDFLAGS="-L${OPENSSL_35_LIB_DIR} -Wl,-rpath,${OPENSSL_35_LIB_DIR} -Wl,-rpath,${CURL_821_35_LIB_DIR}"; \
    ./configure \
      --prefix=${CURL_821_35_DIR} \
      --libdir=${CURL_821_35_LIB_DIR} \
      --enable-option-checking=fatal \
      \
      `# ---- TLS: ours, and only ours ----` \
      --with-openssl=${OPENSSL_35_DIR} \
      --without-gnutls \
      --without-mbedtls \
      --without-wolfssl \
      --with-ca-bundle=/etc/ssl/certs/ca-certificates.crt \
      --with-ca-path=/etc/ssl/certs \
      \
      `# ---- keep ----` \
      --with-zlib \
      --with-nghttp2 \
      --enable-versioned-symbols \
      --enable-shared \
      --disable-static \
      \
      `# ---- drop: each of these links the system OpenSSL ----` \
      --without-libssh2 \
      --without-libssh \
      --without-libpsl \
      --disable-ldap \
      --disable-ldaps \
      --without-gssapi \
      --disable-gopher \
      --disable-dict \
      --disable-telnet \
      --disable-tftp \
      --disable-rtsp \
      --disable-smb \
      --disable-pop3 \
      --disable-imap \
      --disable-smtp \
    ; \
    make -j"$(nproc)"; \
    make install; \
    rm -f /tmp/curl.tar.xz

RUN set -eu; \
    so="${CURL_821_35_LIB_DIR}/libcurl.so"; \
    echo "--- curl NEEDED ---"; \
    readelf -d "$so" | grep NEEDED; \
    for bad in libldap liblber libssh2 libssh librtmp libgssapi libpsl; do \
      if readelf -d "$so" | grep -q "\[${bad}"; then \
        echo "FATAL: libcurl still links ${bad} - it will drag in the system OpenSSL" >&2; \
        exit 1; \
      fi; \
    done; \
    if ldd "$so" | grep -q 'not found'; then \
      echo "FATAL: libcurl has unresolved deps" >&2; ldd "$so" >&2; exit 1; \
    fi; \
    ldd "$so" | grep -q "${OPENSSL_35_LIB_DIR}/libssl" || { \
      echo "FATAL: libcurl not linked against ${OPENSSL_35_LIB_DIR}" >&2; \
      ldd "$so" >&2; exit 1; }; \
    backends="$(${CURL_821_35_BIN_DIR}/curl-config --ssl-backends)"; \
    echo "curl ssl backends: ${backends}"; \
    case "${backends}" in \
      *OpenSSL*) ;; \
      *) echo "FATAL: unexpected TLS backend: ${backends}" >&2; exit 1 ;; \
    esac; \
    ${CURL_821_35_BIN_DIR}/curl --version; \
    echo "OK: libcurl ${CURL_821_VERSION} -> ${OPENSSL_35_LIB_DIR}"

##################################################################
#                   Version after install
##################################################################
RUN echo "=============================================" && \
    echo $(lsb_release -d) && \
    echo "Version: $(cat /etc/debian_version)" && \
    echo "============================================="

##################################################################
#                   other   customisations
##################################################################
