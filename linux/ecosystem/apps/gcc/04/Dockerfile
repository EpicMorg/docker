FROM docker.io/epicmorg/gcc:4 AS builder

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

ARG GCC_MAJIOR_VERSION=4
ARG GCC_MINOR_VERSION=9.4
ENV GCC_VERSION=${GCC_MAJIOR_VERSION}.${GCC_MINOR_VERSION}
ENV GCC_INSTALL_DIR=${EMG_LOCAL_BASE_DIR}/gcc/${GCC_MAJIOR_VERSION}
ARG GCC_DOWNLOAD_URL=https://ftp.gnu.org/gnu/gcc/gcc-${GCC_VERSION}/gcc-${GCC_VERSION}.tar.gz
ARG GCC_TEMP=/tmp/gcc.tar.xz
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
        "${DOWNLOAD_URL}" && \
    tar -xzf ${GCC_TEMP} -C /tmp && \
    cd ${GCC_TEMP_SRC} && \
    # oh shit, modern glibc removed ucontext struct, need to patch gcc 4.9.4 to use ucontext_t instead
    # https://github.com/suaefar/ryzen-test/issues/6
    # https://unix.stackexchange.com/questions/566650/how-do-i-compile-gcc-5-from-source
    # https://gcc.gnu.org/bugzilla/show_bug.cgi?id=81712
    echo "--- Patching gcc-4.9.4 for modern glibc (ucontext_t) ---" && \
    find ./libgcc -type f -name "*unwind.h" -exec sed -i 's/struct ucontext/ucontext_t/g' {} + && \
    find ./libgcc -type f -name "*-support.h" -exec sed -i 's/struct ucontext/ucontext_t/g' {} + && \
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

ARG GCC_MAJIOR_VERSION=4
ARG GCC_MINOR_VERSION=9.4
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
