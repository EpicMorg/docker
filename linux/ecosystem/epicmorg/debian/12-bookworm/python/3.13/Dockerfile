FROM epicmorg/debian:bookworm-develop  as builder

# /etc/ld.so.conf.d/
ARG LD_CONF_DIR=/etc/ld.so.conf.d/

# python 3.13
ENV PYTHON_VERSION=3.13.2
ENV PYTHON_DIR=${EMG_LOCAL_BASE_DIR}/python/${PYTHON_VERSION}
ARG PYTHON_BIN_DIR=${PYTHON_DIR}/bin
ARG PYTHON_SRC_DIR=${PYTHON_DIR}/src
ARG PYTHON_DOWNLOAD_URL=https://www.python.org/ftp/python/${PYTHON_VERSION}/Python-${PYTHON_VERSION}.tgz
ARG PYTHON_TEMP=/tmp/Python-${PYTHON_VERSION}.tgz

RUN apt update && apt install -y \
    build-essential \
    libssl-dev \
    zlib1g-dev \
    libncurses5-dev \
    libncursesw5-dev \
    libreadline-dev \
    libsqlite3-dev \
    libgdbm-dev \
    libdb5.3-dev \
    libbz2-dev \
    libexpat1-dev \
    liblzma-dev \
    libffi-dev \
    uuid-dev \
    tk-dev

##################################################################
#                   CMake
##################################################################
RUN mkdir -p ${PYTHON_DIR} ${PYTHON_SRC_DIR}
ADD ${PYTHON_DOWNLOAD_URL} /tmp

RUN tar -xvzf ${PYTHON_TEMP} --strip-components=1 --directory ${PYTHON_SRC_DIR}

ENV OPENSSL_ROOT=${OPENSSL_34_DIR}
ENV LD_LIBRARY_PATH=${OPENSSL_ROOT}/lib64:$LD_LIBRARY_PATH

WORKDIR ${PYTHON_SRC_DIR}

RUN ./configure \
    --prefix=${PYTHON_DIR} \
    --enable-optimizations \
    --enable-option-checking=fatal \
    --with-lto \
    --enable-loadable-sqlite-extensions \
    --with-ensurepip=install \
    --enable-profiling \
    --with-system-expat \
    --enable-option-checking=fatal \
    --with-computed-gotos \
    --with-pydebug \
    --with-trace-refs \
    --with-assertions \
    --with-valgrind \
    --with-static-libpython \
    --with-openssl-rpath=auto \
    --with-openssl=${OPENSSL_34_DIR} \
    LDFLAGS="-Wl,-rpath,${OPENSSL_34_DIR}/lib64" \
    CPPFLAGS="-I${OPENSSL_34_DIR}/include"

RUN make -j$(nproc) && \
    make altinstall
 
##################################################################
##################################################################
##################################################################
#                  Final Layer
##################################################################
##################################################################
##################################################################
FROM epicmorg/debian:bookworm
 
##################################################################
#                  Python 3.13
##################################################################
ENV PYTHON_VERSION=3.13.2
ENV PYTHON_DIR=${EMG_LOCAL_BASE_DIR}/python/${PYTHON_VERSION}
ARG PYTHON_BIN_DIR=${PYTHON_DIR}/bin
ARG PYTHON_SRC_DIR=${PYTHON_DIR}/src

RUN apt-get remove -y python3-pip

COPY etc/apt/preferences.d /etc/apt/preferences.d
COPY --from=builder ${OPENSSL_34_DIR}/ ${OPENSSL_34_DIR}/

RUN mv ${PYTHON_SRC_DIR} /usr/local/src/${PYTHON_VERSION} && \
    ln -sfv /usr/local/src/${PYTHON_VERSION} ${PYTHON_SRC_DIR} \
    update-alternatives --install /usr/bin/pip3 pip3 ${PYTHON_DIR}/bin/pip3.13 1 && \
    update-alternatives --install /usr/bin/pip pip ${PYTHON_DIR}/bin/pip3.13 1 && \
    update-alternatives --install /usr/bin/python python ${PYTHON_DIR}/bin/python3.13 1 && \
    update-alternatives --install /usr/bin/python3 python3 ${PYTHON_DIR}/bin/python3.13 1

ENV PATH="${PYTHON_BIN_DIR}:${PATH}"
RUN echo "=============================================" && \
    echo python3.13 --version && \
    echo python3 --version && \
    echo python --version && \
    echo pip3 --version && \
    echo pip --version && \
    echo "============================================="

##################################################################
#                  cleanup
##################################################################
RUN echo "clean up" && \
    apt-get clean -y && \
    apt-get autoclean -y && \
    rm -rfv /var/lib/apt/lists/* && \
    rm -rfv /var/cache/apt/archives/*.deb && \
    rm -rfv /root/tmp/* && \
    rm -rfv /tmp/*

RUN updatedb
