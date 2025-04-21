FROM quay.io/epicmorg/debian:bookworm-develop  as builder

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

ENV REQUESTS_CA_BUNDLE=/etc/ssl/certs/ca-certificates.crt
ENV PYTHON_VERSION=2.7
ENV PYTHON_FULL_VERSION=${PYTHON_VERSION}.18
ENV PYTHON_DIR=${EMG_LOCAL_BASE_DIR}/python/${PYTHON_VERSION}
ARG PYTHON_BIN_DIR=${PYTHON_DIR}/bin
ARG PYTHON_SRC_DIR=${PYTHON_DIR}/src
ARG PYTHON_DOWNLOAD_URL=https://www.python.org/ftp/python/${PYTHON_FULL_VERSION}/Python-${PYTHON_FULL_VERSION}.tgz
ARG PYTHON_TEMP=/tmp/Python-${PYTHON_FULL_VERSION}.tgz

RUN mkdir -p ${PYTHON_DIR} ${PYTHON_SRC_DIR} ${PYTHON_BIN_DIR}
ADD ${PYTHON_DOWNLOAD_URL} /tmp

RUN tar -xvzf ${PYTHON_TEMP} --strip-components=1 --directory ${PYTHON_SRC_DIR}

ENV PATH="${PYTHON_BIN_DIR}:${PATH}"

WORKDIR ${PYTHON_SRC_DIR}

RUN ./configure \
    --prefix=${PYTHON_DIR} \
    --enable-option-checking=fatal \
    --with-ensurepip=install \
    --enable-profiling \
    --with-system-expat \
    --with-computed-gotos \
    --with-pydebug \
    --with-valgrind \
    --with-lto

RUN make -j$(nproc) && \
    make altinstall

#RUN python${PYTHON_VERSION} -c "import ssl; print(ssl.OPENSSL_VERSION)"

##################################################################
##################################################################
##################################################################
#                  Final Layer
##################################################################
##################################################################
##################################################################
FROM quay.io/epicmorg/debian:bookworm

RUN apt-get remove -y python3-pip

# /etc/ld.so.conf.d/
ARG LD_CONF_DIR=/etc/ld.so.conf.d/

##################################################################
#                  Python 2.7
##################################################################
ENV REQUESTS_CA_BUNDLE=/etc/ssl/certs/ca-certificates.crt
ENV PYTHON_VERSION=2.7
ENV PYTHON_FULL_VERSION=${PYTHON_VERSION}.18
ENV PYTHON_DIR=${EMG_LOCAL_BASE_DIR}/python/${PYTHON_VERSION}
ARG PYTHON_BIN_DIR=${PYTHON_DIR}/bin
ARG PYTHON_SRC_DIR=${PYTHON_DIR}/src

COPY etc/apt/preferences.d /etc/apt/preferences.d
COPY --from=builder ${PYTHON_DIR} ${PYTHON_DIR}

ENV PATH="${PYTHON_BIN_DIR}:${PATH}"

RUN mv ${PYTHON_SRC_DIR} /usr/local/src/${PYTHON_FULL_VERSION} && \
    ln -sfv /usr/local/src/${PYTHON_FULL_VERSION} ${PYTHON_SRC_DIR} && \
    rm -rfv /usr/bin/pip3 && \
    rm -rfv /usr/bin/pip2 && \
    rm -rfv /usr/bin/pip && \
    rm -rfv /usr/bin/python && \
    rm -rfv /usr/bin/python2 && \
    rm -rfv /usr/bin/python3 && \
    update-alternatives --install /usr/bin/pip2 pip2 ${PYTHON_DIR}/bin/pip${PYTHON_VERSION} 1 && \
    update-alternatives --install /usr/bin/pip pip ${PYTHON_DIR}/bin/pip${PYTHON_VERSION} 1 && \
    update-alternatives --install /usr/bin/python python ${PYTHON_DIR}/bin/python${PYTHON_VERSION} 1 && \
    update-alternatives --install /usr/bin/python2 python2 ${PYTHON_DIR}/bin/python${PYTHON_VERSION} 1 && \
    ldconfig

RUN echo "=============================================" && \
    python${PYTHON_VERSION} --version && \
    python2 --version && \
    python --version && \
    pip2 --version && \
    pip --version && \
#    echo "=============================================" && \
#    python${PYTHON_VERSION} -c "import ssl; print(ssl.OPENSSL_VERSION)" && \
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
