FROM docker.io/epicmorg/debian:trixie AS temp

RUN set -eux; \     
    echo "============================================="

FROM docker.io/epicmorg/gcc:15 AS builder

# /etc/ld.so.conf.d/
ARG LD_CONF_DIR=/etc/ld.so.conf.d/

ARG GCC_MAJOR_VERSION=15
ARG GCC_MINOR_VERSION=2.0
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

COPY --from=temp /usr/local/share/epicmorg/aria2 /usr/local/share/epicmorg/aria2
COPY --from=temp /usr/local/share/epicmorg/user-agents /usr/local/share/epicmorg/user-agents
RUN tree -L 2 /usr/local/share/epicmorg/ && \
    apt update && \
    apt install -y --no-install-recommends \
        aria2

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
        --enable-checking=release && \
    make -j$(nproc) && \
    make install && \
    rm -rf ${GCC_TEMP} ${GCC_TEMP_SRC} /tmp/gcc-build

#RUN set -eux; \
#    echo "# EpicMorg GCC ${GCC_MAJIOR_VERSION} support" > ${LD_CONF_DIR}/epicmorg-gcc-${GCC_MAJIOR_VERSION}.conf && \
#    echo ${GCC_INSTALL_DIR}/lib >> ${LD_CONF_DIR}/epicmorg-gcc-${GCC_MAJIOR_VERSION}.conf && \
#    echo ${GCC_INSTALL_DIR}/lib64 >> ${LD_CONF_DIR}/epicmorg-gcc-${GCC_MAJIOR_VERSION}.conf && \
#    ldconfig

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

ARG GCC_MAJIOR_VERSION=15
ARG GCC_MINOR_VERSION=2.0
ENV GCC_VERSION=${GCC_MAJIOR_VERSION}.${GCC_MINOR_VERSION}
ENV GCC_INSTALL_DIR=${EMG_LOCAL_BASE_DIR}/gcc/${GCC_MAJIOR_VERSION}

COPY --from=builder ${GCC_INSTALL_DIR} ${GCC_INSTALL_DIR}

#RUN set -eux; \
#    echo "# EpicMorg GCC ${GCC_MAJIOR_VERSION} support" > ${LD_CONF_DIR}/epicmorg-gcc-${GCC_MAJIOR_VERSION}.conf && \
#    echo ${GCC_INSTALL_DIR}/lib >> ${LD_CONF_DIR}/epicmorg-gcc-${GCC_MAJIOR_VERSION}.conf && \
#    echo ${GCC_INSTALL_DIR}/lib64 >> ${LD_CONF_DIR}/epicmorg-gcc-${GCC_MAJIOR_VERSION}.conf && \
#    ldconfig

ENV PATH="${GCC_INSTALL_DIR}/bin:${PATH}"

RUN set -eux; \     
    echo "=============================================" && \
    gcc --version && \
    g++ --version && \
    echo "============================================="
