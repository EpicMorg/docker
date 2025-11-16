FROM docker.io/epicmorg/gcc:5 AS builder

##################################################################
#                    Shared wget args
##################################################################
ARG WGET_ARGS="--continue \
  --quiet \
  --no-check-certificate \
  --retry-connrefused \
  --tries=15 \
  --timeout=30 \
  --waitretry=15 \
  --dns-timeout=30 \
  --connect-timeout=30 \
  --read-timeout=30 \
  --no-clobber"

ARG WGET_USER_AGENT="Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:128.0) Gecko/20100101 Firefox/128.0"

# /etc/ld.so.conf.d/
ARG LD_CONF_DIR=/etc/ld.so.conf.d/

ARG GCC_MAJIOR_VERSION=5
ARG GCC_MINOR_VERSION=5.0
ENV GCC_VERSION=${GCC_MAJIOR_VERSION}.${GCC_MINOR_VERSION}
ENV GCC_INSTALL_DIR=${EMG_LOCAL_BASE_DIR}/gcc/${GCC_MAJIOR_VERSION}
ARG GCC_DOWNLOAD_URL=https://ftp.gnu.org/gnu/gcc/gcc-${GCC_VERSION}/gcc-${GCC_VERSION}.tar.xz
ARG GCC_TEMP=/tmp/gcc.tar.xz
ARG GCC_TEMP_SRC=/tmp/gcc-${GCC_VERSION}

RUN set -eux; \     
    echo "=============================================" && \
    gcc --version && \
    g++ --version && \
    echo "============================================="

RUN set -eux; \
    mkdir -p ${GCC_INSTALL_DIR} && \
    wget ${WGET_ARGS} --user-agent "${WGET_USER_AGENT}" -O ${GCC_TEMP} ${GCC_DOWNLOAD_URL} && \
    tar -xf ${GCC_TEMP} -C /tmp && \
    cd ${GCC_TEMP_SRC} && \
    ./contrib/download_prerequisites && \
    ./configure \
        --prefix=${GCC_INSTALL_DIR} \
        --enable-languages=c,c++ \
        --disable-multilib \
        --disable-bootstrap \
        --disable-libsanitizer \
        --enable-checking=release && \
    make -j$(nproc) && \
    make install && \
    rm -rf ${GCC_TEMP} ${GCC_TEMP_SRC}

RUN set -eux; \
    echo "# EpicMorg GCC ${GCC_MAJIOR_VERSION} support" > ${LD_CONF_DIR}/epicmorg-gcc-${GCC_MAJIOR_VERSION}.conf && \
    echo ${GCC_INSTALL_DIR}/lib >> ${LD_CONF_DIR}/epicmorg-gcc-${GCC_MAJIOR_VERSION}.conf && \
    echo ${GCC_INSTALL_DIR}/lib64 >> ${LD_CONF_DIR}/epicmorg-gcc-${GCC_MAJIOR_VERSION}.conf && \
    ldconfig

ENV PATH="${GCC_INSTALL_DIR}/bin:${PATH}"

RUN set -eux; \     
    echo "=============================================" && \
    gcc --version && \
    g++ --version && \
    echo "============================================="

##################################################################
##################################################################
##################################################################
#                  Final Layer
##################################################################
##################################################################
##################################################################
FROM docker.io/epicmorg/debian:trixie-develop

ARG GCC_MAJIOR_VERSION=5
ARG GCC_MINOR_VERSION=5.0
ENV GCC_VERSION=${GCC_MAJIOR_VERSION}.${GCC_MINOR_VERSION}
ENV GCC_INSTALL_DIR=${EMG_LOCAL_BASE_DIR}/gcc/${GCC_MAJIOR_VERSION}

COPY --from=builder ${GCC_INSTALL_DIR} ${GCC_INSTALL_DIR}

RUN set -eux; \
    echo "# EpicMorg GCC ${GCC_MAJIOR_VERSION} support" > ${LD_CONF_DIR}/epicmorg-gcc-${GCC_MAJIOR_VERSION}.conf && \
    echo ${GCC_INSTALL_DIR}/lib >> ${LD_CONF_DIR}/epicmorg-gcc-${GCC_MAJIOR_VERSION}.conf && \
    echo ${GCC_INSTALL_DIR}/lib64 >> ${LD_CONF_DIR}/epicmorg-gcc-${GCC_MAJIOR_VERSION}.conf && \
    ldconfig

ENV PATH="${GCC_INSTALL_DIR}/bin:${PATH}"

RUN set -eux; \     
    echo "=============================================" && \
    gcc --version && \
    g++ --version && \
    echo "============================================="
