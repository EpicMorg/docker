FROM docker.io/epicmorg/gcc:15 AS builder

# /etc/ld.so.conf.d/
ARG LD_CONF_DIR=/etc/ld.so.conf.d/

ARG GCC_MAJOR_VERSION=15
ARG GCC_MINOR_VERSION=3.0
ENV GCC_VERSION=${GCC_MAJOR_VERSION}.${GCC_MINOR_VERSION}
ENV GCC_INSTALL_DIR=${EMG_LOCAL_BASE_DIR}/gcc/${GCC_MAJOR_VERSION}
ARG GCC_DOWNLOAD_URL=https://ftp.gnu.org/gnu/gcc/gcc-${GCC_VERSION}/gcc-${GCC_VERSION}.tar.xz
ARG DOWNLOAD_URL=${GCC_DOWNLOAD_URL}
ARG GCC_TEMP=/tmp/gcc-${GCC_VERSION}.tar.xz
ARG GCC_TEMP_SRC=/tmp/gcc-${GCC_VERSION}

RUN set -eux; \     
    echo "=============================================" && \
    gcc --version && \
    g++ --version && \
    echo "============================================="

RUN set -eux; \
    mkdir -p ${GCC_INSTALL_DIR} && \
    aria2c \
        --conf-path="/usr/local/share/epicmorg/aria2/config/aria2.conf" \
        --user-agent="$(shuf -n 1 /usr/local/share/epicmorg/user-agents/user-agents.txt)" \
        -d /tmp \
        "${GCC_DOWNLOAD_URL}" && \
    tar -xf ${GCC_TEMP} -C /tmp && \
    cd ${GCC_TEMP_SRC} && \
    ./contrib/download_prerequisites && \
    mkdir -p /tmp/gcc-build && \
    cd /tmp/gcc-build && \
    ${GCC_TEMP_SRC}/configure \
        --prefix=${GCC_INSTALL_DIR} \
        --enable-languages=c,c++ \
        --disable-multilib \
        --disable-bootstrap \
        --enable-checking=release \
        --enable-multiarch \
        --with-multiarch-defaults=x86_64-linux-gnu \
        --build=x86_64-linux-gnu \
        --host=x86_64-linux-gnu \
        --target=x86_64-linux-gnu \
        --enable-default-pie \
        --enable-shared \
        --enable-threads=posix \
        --enable-__cxa_atexit \
        --with-system-zlib \
    && \
    make -j$(nproc) && \
    make install && \
    rm -rf ${GCC_TEMP} ${GCC_TEMP_SRC} /tmp/gcc-build

ENV PATH="${GCC_INSTALL_DIR}/bin:${PATH}"

RUN set -eux; \
    echo "--- include search paths ---"; \
    echo | gcc -E -Wp,-v - 2>&1 | grep '^ /'; \
    echo "--- multiarch ---"; \
    gcc -print-multiarch; \
    echo "--- multiarch header reachable? ---"; \
    echo '#include <sys/types.h>' | gcc -E - >/dev/null && echo "OK" || { echo "FAIL"; exit 1; }; \
    echo '#include <bits/wordsize.h>' | gcc -E - >/dev/null && echo "OK: multiarch works" || { echo "FAIL: multiarch broken"; exit 1; }

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
LABEL org.opencontainers.image.title="EpicMorg GCC"
LABEL org.opencontainers.image.description="GCC compiler by EpicMorg"

ARG GCC_MAJIOR_VERSION=15
ARG GCC_MINOR_VERSION=3.0
ENV GCC_VERSION=${GCC_MAJIOR_VERSION}.${GCC_MINOR_VERSION}
ENV GCC_INSTALL_DIR=${EMG_LOCAL_BASE_DIR}/gcc/${GCC_MAJIOR_VERSION}

COPY --from=builder ${GCC_INSTALL_DIR} ${GCC_INSTALL_DIR}


ENV PATH="${GCC_INSTALL_DIR}/bin:${PATH}"

RUN set -eux; \     
    echo "=============================================" && \
    gcc --version && \
    g++ --version && \
    echo "============================================="

WORKDIR ${GCC_INSTALL_DIR}
