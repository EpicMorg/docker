FROM docker.io/epicmorg/debian:trixie-develop  as builder

##################################################################
#                   Build
##################################################################
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

# /etc/ld.so.conf.d/
ARG LD_CONF_DIR=/etc/ld.so.conf.d/

ENV PYTHON_VERSION=3.13
ENV PYTHON_FULL_VERSION=${PYTHON_VERSION}.5
ENV PYTHON_DIR=${EMG_LOCAL_BASE_DIR}/python/${PYTHON_VERSION}
ARG PYTHON_BIN_DIR=${PYTHON_DIR}/bin
ARG PYTHON_SRC_DIR=${PYTHON_DIR}/src
ARG PYTHON_DOWNLOAD_URL=https://www.python.org/ftp/python/${PYTHON_FULL_VERSION}/Python-${PYTHON_FULL_VERSION}.tgz
ARG PYTHON_TEMP=/tmp/Python-${PYTHON_FULL_VERSION}.tgz

RUN mkdir -p ${PYTHON_DIR} ${PYTHON_SRC_DIR} ${PYTHON_BIN_DIR}
ADD ${PYTHON_DOWNLOAD_URL} /tmp

RUN tar -xzf ${PYTHON_TEMP} --strip-components=1 --directory ${PYTHON_SRC_DIR}

ENV OPENSSL_ROOT=${OPENSSL_34_DIR}
ENV LD_LIBRARY_PATH="${OPENSSL_ROOT}/lib64:${PYTHON_DIR}/lib:$LD_LIBRARY_PATH"
ENV PYTHONPATH="${PYTHON_DIR}/lib/python${PYTHON_VERSION}/site-packages:$PYTHONPATH"

ENV PATH="${PYTHON_BIN_DIR}:${PATH}"

WORKDIR ${PYTHON_SRC_DIR}

RUN ./configure \
    --prefix=${PYTHON_DIR} \
    --enable-optimizations \
    --enable-option-checking=fatal \
    --with-lto \
    --enable-loadable-sqlite-extensions \
    --with-ensurepip=install \
    --enable-profiling \
  #  --with-system-expat \
    --with-computed-gotos \
    --with-pydebug \
    --with-trace-refs \
    --with-assertions \
    --with-valgrind \
    --with-static-libpython \
    --with-openssl-rpath=auto \
    --with-openssl=${OPENSSL_34_DIR} \
    SSL=${OPENSSL_34_DIR} \
    CFLAGS="-I${OPENSSL_34_DIR}/include" \
    CPPFLAGS="-I${OPENSSL_34_DIR}/include" \
    PKG_CONFIG_PATH="${OPENSSL_34_DIR}/lib64/pkgconfig" \
    LDFLAGS="-L${OPENSSL_34_DIR}/lib64 -Wl,-rpath,${OPENSSL_34_DIR}/lib64"

RUN make -j$(nproc) && \
    make altinstall

RUN python${PYTHON_VERSION} -c "import ssl; print(ssl.OPENSSL_VERSION)"

##################################################################
##################################################################
##################################################################
#                  Final Layer
##################################################################
##################################################################
##################################################################
FROM docker.io/epicmorg/debian:trixie

RUN apt-get remove -y python3-pip

# /etc/ld.so.conf.d/
ARG LD_CONF_DIR=/etc/ld.so.conf.d/

##################################################################
#                  OpenSSL 3.4
##################################################################
ENV OPENSSL_34_MIN_VERSION=3.4
ENV OPENSSL_34_VERSION=${OPENSSL_34_MIN_VERSION}.2
ENV OPENSSL_34_DIR=${EMG_LOCAL_BASE_DIR}/openssl/${OPENSSL_34_MIN_VERSION}
ENV OPENSSL_34_BIN_DIR=${OPENSSL_34_DIR}/bin
ENV OPENSSL_34_INC_DIR=${OPENSSL_34_DIR}/include
ENV OPENSSL_34_LIB_DIR=${OPENSSL_34_DIR}/lib64
ENV OPENSSL_34_SRC_DIR=/usr/local/src/openssl/${OPENSSL_34_VERSION}

##################################################################
#                  Python 3.13
##################################################################
ENV PYTHON_VERSION=3.13
ENV PYTHON_FULL_VERSION=${PYTHON_VERSION}.5
ENV PYTHON_DIR=${EMG_LOCAL_BASE_DIR}/python/${PYTHON_VERSION}
ARG PYTHON_BIN_DIR=${PYTHON_DIR}/bin
ARG PYTHON_SRC_DIR=${PYTHON_DIR}/src

COPY etc/apt/preferences.d /etc/apt/preferences.d
COPY --from=builder ${PYTHON_DIR} ${PYTHON_DIR}
COPY --from=builder ${OPENSSL_34_DIR} ${OPENSSL_34_DIR}
COPY --from=builder ${OPENSSL_34_SRC_DIR} ${OPENSSL_34_SRC_DIR}

ENV OPENSSL_ROOT=${OPENSSL_34_DIR}
ENV LD_LIBRARY_PATH="${OPENSSL_ROOT}/lib64:${PYTHON_DIR}/lib:$LD_LIBRARY_PATH"
ENV PYTHONPATH="${PYTHON_DIR}/lib/python${PYTHON_VERSION}/site-packages:$PYTHONPATH"
ENV PATH="${OPENSSL_34_BIN_DIR}:${PYTHON_BIN_DIR}:${PATH}"

RUN mv ${PYTHON_SRC_DIR} /usr/local/src/${PYTHON_FULL_VERSION} && \
    ln -sfv /usr/local/src/${PYTHON_FULL_VERSION} ${PYTHON_SRC_DIR} && \
    rm -rfv /usr/bin/pip3 && \
    rm -rfv /usr/bin/pip && \
    rm -rfv /usr/bin/python && \
    rm -rfv /usr/bin/python3 && \
    update-alternatives --install /usr/bin/pip3 pip3 ${PYTHON_DIR}/bin/pip${PYTHON_VERSION} 1 && \
    update-alternatives --install /usr/bin/pip pip ${PYTHON_DIR}/bin/pip${PYTHON_VERSION} 1 && \
    update-alternatives --install /usr/bin/python python ${PYTHON_DIR}/bin/python${PYTHON_VERSION} 1 && \
    update-alternatives --install /usr/bin/python3 python3 ${PYTHON_DIR}/bin/python${PYTHON_VERSION} 1 && \
    echo "# OpenSSL support" >> ${LD_CONF_DIR}/OpenSSL.conf && \
    echo ${OPENSSL_34_LIB_DIR} >> ${LD_CONF_DIR}/OpenSSL.conf && \
    ldconfig

RUN echo "=============================================" && \
    python${PYTHON_VERSION} --version && \
    python3 --version && \
    python --version && \
    pip3 --version && \
    pip --version && \
    echo "=============================================" && \
    python${PYTHON_VERSION} -c "import ssl; print(ssl.OPENSSL_VERSION)" && \
    echo "============================================="

WORKDIR ${EMG_LOCAL_BASE_DIR}

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
