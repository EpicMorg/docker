FROM hub.epicm.org/epicmorg/debian:bookworm-develop  as builder

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

ENV PYTHON_VERSION=3.3
ENV PYTHON_FULL_VERSION=${PYTHON_VERSION}.7
ENV PYTHON_DIR=${EMG_LOCAL_BASE_DIR}/python/${PYTHON_VERSION}
ARG PYTHON_BIN_DIR=${PYTHON_DIR}/bin
ARG PYTHON_SRC_DIR=${PYTHON_DIR}/src
ARG PYTHON_DOWNLOAD_URL=https://www.python.org/ftp/python/${PYTHON_FULL_VERSION}/Python-${PYTHON_FULL_VERSION}.tgz
ARG PYTHON_TEMP=/tmp/Python-${PYTHON_FULL_VERSION}.tgz

RUN mkdir -p ${PYTHON_DIR} ${PYTHON_SRC_DIR} ${PYTHON_BIN_DIR}
ADD ${PYTHON_DOWNLOAD_URL} /tmp

RUN tar -xvzf ${PYTHON_TEMP} --strip-components=1 --directory ${PYTHON_SRC_DIR}

ENV OPENSSL_ROOT=${OPENSSL_102_DIR}
ENV LD_LIBRARY_PATH="${OPENSSL_ROOT}/lib:${PYTHON_DIR}/lib:$LD_LIBRARY_PATH"
ENV PYTHONPATH="${PYTHON_DIR}/lib/python${PYTHON_VERSION}/site-packages:$PYTHONPATH"

ENV PATH="${PYTHON_BIN_DIR}:${PATH}"

WORKDIR ${PYTHON_SRC_DIR}

RUN ./configure \
    --prefix=${PYTHON_DIR} \
    --enable-option-checking=fatal \
    --enable-loadable-sqlite-extensions \
    --enable-profiling \
    --with-system-expat \
    --with-computed-gotos \
    --with-pydebug \
    --with-valgrind \
    SSL=${OPENSSL_102_DIR} \
    CFLAGS="-I${OPENSSL_102_DIR}/include" \
    CPPFLAGS="-I${OPENSSL_102_DIR}/include" \
    PKG_CONFIG_PATH="${OPENSSL_102_DIR}/lib/pkgconfig" \
    LDFLAGS="-L${OPENSSL_102_DIR}/lib -Wl,-rpath,${OPENSSL_102_DIR}/lib"

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
FROM hub.epicm.org/epicmorg/debian:bookworm

RUN apt-get remove -y python3-pip

# /etc/ld.so.conf.d/
ARG LD_CONF_DIR=/etc/ld.so.conf.d/

##################################################################
#                  OpenSSL 1.0.2u
##################################################################
ENV OPENSSL_102_VERSION=1.0.2
ENV OPENSSL_102_DIR=${EMG_LOCAL_BASE_DIR}/openssl/${OPENSSL_102_VERSION}
ENV OPENSSL_102_BIN_DIR=${OPENSSL_102_DIR}/bin
ENV OPENSSL_102_INC_DIR=${OPENSSL_102_DIR}/include
ENV OPENSSL_102_LIB_DIR=${OPENSSL_102_DIR}/lib
ENV OPENSSL_102_SRC_DIR=/usr/local/src/openssl/${OPENSSL_102_VERSION}

##################################################################
#                  Python 3.3
##################################################################
ENV PYTHON_VERSION=3.3
ENV PYTHON_FULL_VERSION=${PYTHON_VERSION}.7
ENV PYTHON_DIR=${EMG_LOCAL_BASE_DIR}/python/${PYTHON_VERSION}
ARG PYTHON_BIN_DIR=${PYTHON_DIR}/bin
ARG PYTHON_SRC_DIR=${PYTHON_DIR}/src

COPY etc/apt/preferences.d /etc/apt/preferences.d
COPY --from=builder ${PYTHON_DIR} ${PYTHON_DIR}
COPY --from=builder ${OPENSSL_102_DIR} ${OPENSSL_102_DIR}
COPY --from=builder ${OPENSSL_102_SRC_DIR} ${OPENSSL_102_SRC_DIR}

ENV OPENSSL_ROOT=${OPENSSL_102_DIR}
ENV LD_LIBRARY_PATH="${OPENSSL_ROOT}/lib:${PYTHON_DIR}/lib:$LD_LIBRARY_PATH"
ENV PYTHONPATH="${PYTHON_DIR}/lib/python${PYTHON_VERSION}/site-packages:$PYTHONPATH"
ENV PATH="${OPENSSL_102_BIN_DIR}:${PYTHON_BIN_DIR}:${PATH}"

ADD https://bootstrap.pypa.io/pip/3.3/get-pip.py /tmp

RUN mv ${PYTHON_SRC_DIR} /usr/local/src/${PYTHON_FULL_VERSION} && \
    ln -sfv /usr/local/src/${PYTHON_FULL_VERSION} ${PYTHON_SRC_DIR} && \
    rm -rfv /usr/bin/pip3 && \
    rm -rfv /usr/bin/pip && \
    rm -rfv /usr/bin/python && \
    rm -rfv /usr/bin/python3 && \
    ${PYTHON_DIR}/bin/python${PYTHON_VERSION} /tmp/get-pip.py && \
    update-alternatives --install /usr/bin/pip3 pip3 ${PYTHON_DIR}/bin/pip${PYTHON_VERSION} 1 && \
    update-alternatives --install /usr/bin/pip pip ${PYTHON_DIR}/bin/pip${PYTHON_VERSION} 1 && \
    update-alternatives --install /usr/bin/python python ${PYTHON_DIR}/bin/python${PYTHON_VERSION} 1 && \
    update-alternatives --install /usr/bin/python3 python3 ${PYTHON_DIR}/bin/python${PYTHON_VERSION} 1 && \
    echo "# OpenSSL support" >> ${LD_CONF_DIR}/OpenSSL.conf && \
    echo ${OPENSSL_102_LIB_DIR} >> ${LD_CONF_DIR}/OpenSSL.conf && \
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
