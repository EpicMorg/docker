# check=skip=UndefinedVar
FROM docker.io/epicmorg/gcc:10 AS builder

# /etc/ld.so.conf.d/
ARG LD_CONF_DIR=/etc/ld.so.conf.d/

ENV PYTHON_VERSION=3.7
ENV PYTHON_FULL_VERSION=${PYTHON_VERSION}.17
ENV PYTHON_DIR=${EMG_LOCAL_BASE_DIR}/python/${PYTHON_VERSION}
ARG PYTHON_BIN_DIR=${PYTHON_DIR}/bin
ARG PYTHON_SRC_DIR=${PYTHON_DIR}/src
ENV PIP_ROOT_USER_ACTION=warn
ARG PYTHON_DOWNLOAD_URL=https://www.python.org/ftp/python/${PYTHON_FULL_VERSION}/Python-${PYTHON_FULL_VERSION}.tgz
ARG PYTHON_TEMP=/tmp/Python-${PYTHON_FULL_VERSION}.tgz
ENV SSL_CERT_DIR=/etc/ssl/certs
ENV REQUESTS_CA_BUNDLE=/etc/ssl/certs/ca-certificates.crt

##################################################################
#                    Prepeare Python build
##################################################################

# Simple check if ENVs are alive.
RUN : "${OPENSSL_111_DIR:?empty — check epicmorg/gcc ENV}" \
      "${OPENSSL_111_LIB_DIR:?empty}" "${ZLIB_LIB_DIR:?empty}"

# Pin all python*-* packages to priority -1 so apt never pulls distro python.
COPY etc/apt/preferences.d /etc/apt/preferences.d

# Install dependencies for building Python 2.7 and its modules.
RUN apt-get update && apt-get install -y \
    build-essential \
    pkg-config \
    libffi-dev \
    libncurses-dev \
    libreadline-dev \
    libsqlite3-dev \
    libgdbm-dev \
    libbz2-dev \
    libexpat1-dev \
    liblzma-dev \
    uuid-dev \
    tk-dev \
    libc6 \
    libgcc-s1 \
    libstdc++6 \
    libncursesw6 \
    libreadline8 \
    libsqlite3-0 \
    libgdbm6 \
    libexpat1 \
    liblzma5 \
    uuid-runtime \
    tk \
    && rm -rf /var/lib/apt/lists/*

# Move sources out of the runtime prefix and re-point system python/pip
# to our interpreter via update-alternatives.
RUN mv /usr/include/openssl /usr/include/openssl.disabled

RUN set -eux; \
    mkdir -p ${PYTHON_DIR} ${PYTHON_SRC_DIR} ${PYTHON_BIN_DIR} && \
    aria2c \
        --conf-path=/usr/local/share/epicmorg/aria2/config/aria2.conf \
        --user-agent="$(shuf -n 1 /usr/local/share/epicmorg/user-agents/user-agents.txt)" \
        -d / \
        -o ${PYTHON_TEMP}  \
        "${PYTHON_DOWNLOAD_URL}" && \
    tar -xzf ${PYTHON_TEMP} --strip-components=1 --directory ${PYTHON_SRC_DIR} && \
    rm -rfv ${PYTHON_TEMP}

ENV PATH="${PYTHON_BIN_DIR}:${PATH}"

WORKDIR ${PYTHON_SRC_DIR}

RUN set -eux; \
    export LDFLAGS="-L${OPENSSL_111_LIB_DIR} -L${ZLIB_LIB_DIR} -Wl,-rpath,${OPENSSL_111_LIB_DIR} -Wl,-rpath,${PYTHON_DIR}/lib -Wl,-rpath,${ZLIB_LIB_DIR}" && \
    export CPPFLAGS="-I${OPENSSL_111_INC_DIR} -I${ZLIB_INC_DIR}" && \
    ./configure \
    --prefix=${PYTHON_DIR} \
    --enable-shared \
    --enable-optimizations \
    --enable-option-checking=fatal \
    --with-lto \
    --enable-loadable-sqlite-extensions \
    --with-ensurepip=install \
    --with-computed-gotos \
    --with-openssl=${OPENSSL_111_DIR} && \
    make -j$(nproc) && \
    make altinstall && \
    ${PYTHON_DIR}/bin/python${PYTHON_VERSION} -m pip install --upgrade pip setuptools && \
    rm -rf /tmp/*

# Version-agnostic aliases: keep the assertion block below byte-identical across all python versions.
ARG PY_SSL_DIR=${OPENSSL_111_DIR}
ARG PY_SSL_LIB_DIR=${OPENSSL_111_LIB_DIR}
ARG PY_SSL_VERSION=${OPENSSL_111_VERSION}

# Expected compile-time OpenSSL version prefix (_ssl.OPENSSL_VERSION_NUMBER, format 0xMNNFFPPS).
# Guards against building against system headers while linking our own libs:
# ssl.OPENSSL_VERSION reports the RUNTIME lib, this constant reports the HEADERS used at compile time.
# A mismatch means ABI drift - build must fail.
# Masks: 1.0.x -> 0x1000 | 1.1.x -> 0x1010 | 3.x -> 0x30 | 4.x -> 0x40
ARG PY_SSL_HDR_MASK=0x1010

# Assert the built interpreter actually uses OUR OpenSSL, not the system one.
# Three independent checks, each catches a different failure:
#   1. runtime version  - ssl.OPENSSL_VERSION      (which lib is loaded)
#   2. compile-time ver - _ssl.OPENSSL_VERSION_NUMBER (which headers were used)
#   3. linkage          - ldd of _ssl / _hashlib   (resolved from our prefix, no 'not found')
# Checks 1 and 2 disagreeing means ABI drift: compiled against system headers, linked to ours.
RUN set -eu; \
    py="${PYTHON_DIR}/bin/python${PYTHON_VERSION}"; \
    echo "--- Checking SSL compile-time headers (builder) ---"; \
    hdr="$("$py" -c 'import _ssl; print(hex(_ssl.OPENSSL_VERSION_NUMBER))')"; \
    echo "compile-time OPENSSL_VERSION_NUMBER = ${hdr}"; \
    case "${hdr}" in \
      ${PY_SSL_HDR_MASK}*) ;; \
      *) echo "FATAL: built against wrong OpenSSL headers: ${hdr} (expected ${PY_SSL_HDR_MASK}*)" >&2; exit 1 ;; \
    esac; \
    echo "--- Checking SSL version (builder) ---"; \
    got="$("$py" -c 'import ssl; print(ssl.OPENSSL_VERSION)')"; \
    echo "ssl.OPENSSL_VERSION = ${got}"; \
    case "${got}" in \
      "OpenSSL ${PY_SSL_VERSION}"*) ;; \
      *) echo "FATAL: expected OpenSSL ${PY_SSL_VERSION}, got '${got}'" >&2; exit 1 ;; \
    esac; \
    for m in _ssl _hashlib; do \
      so="$("$py" -c "import ${m}; print(${m}.__file__)")"; \
      echo "${m} -> ${so}"; \
      if ldd "$so" | grep -q 'not found'; then \
        echo "FATAL: ${m} has unresolved deps" >&2; ldd "$so" >&2; exit 1; \
      fi; \
      if ! ldd "$so" | grep -q "${PY_SSL_LIB_DIR}/lib"; then \
        echo "FATAL: ${m} not linked against ${PY_SSL_LIB_DIR}" >&2; ldd "$so" >&2; exit 1; \
      fi; \
    done; \
    echo "OK (builder): OpenSSL ${PY_SSL_VERSION} from ${PY_SSL_LIB_DIR}"

##################################################################
##################################################################
##################################################################
#                  Final Layer
##################################################################
##################################################################
##################################################################
FROM docker.io/epicmorg/debian:trixie
LABEL org.opencontainers.image.title="EpicMorg Python"
LABEL org.opencontainers.image.description="Python by EpicMorg"

# Pin all python*-* packages to priority -1 so apt never pulls distro python.
COPY etc/apt/preferences.d /etc/apt/preferences.d

# Build toolchain + headers for the FINAL image: some pip packages have no wheels
# and compile C extensions at `pip install` time (psycopg2, pycurl, lxml, python-ldap...).
# Not used to build Python itself - that happens in the builder stage.
RUN apt-get update && apt-get install -y \
    build-essential \
    pkg-config \
    libffi-dev \
    libncurses-dev \
    libreadline-dev \
    libsqlite3-dev \
    libgdbm-dev \
    libbz2-dev \
    libexpat1-dev \
    liblzma-dev \
    uuid-dev \
    tk-dev \
    libc6 \
    libgcc-s1 \
    libstdc++6 \
    libncursesw6 \
    libreadline8 \
    libsqlite3-0 \
    libgdbm6 \
    libexpat1 \
    liblzma5 \
    libpq-dev \
    libcairo2-dev \
    uuid-runtime \
    tk \
    && apt-get remove -y python3-pip \
    && apt-get autoremove -y \
    && rm -rf /var/lib/apt/lists/*

# /etc/ld.so.conf.d/
ARG LD_CONF_DIR=/etc/ld.so.conf.d/

##################################################################
#                  OpenSSL 1.1.1
##################################################################
ENV OPENSSL_111_VERSION=1.1.1
ENV OPENSSL_111_DIR=${EMG_LOCAL_BASE_DIR}/openssl/${OPENSSL_111_VERSION}
ENV OPENSSL_111_BIN_DIR=${OPENSSL_111_DIR}/bin
ENV OPENSSL_111_INC_DIR=${OPENSSL_111_DIR}/include
ENV OPENSSL_111_LIB_DIR=${OPENSSL_111_DIR}/lib
ENV OPENSSL_111_SRC_DIR=/usr/local/src/openssl/${OPENSSL_111_VERSION}
ENV SSL_CERT_DIR=/etc/ssl/certs
ENV REQUESTS_CA_BUNDLE=/etc/ssl/certs/ca-certificates.crt

##################################################################
#                  Python 3.7
##################################################################
ENV PYTHON_VERSION=3.7
ENV PYTHON_FULL_VERSION=${PYTHON_VERSION}.17
ENV PYTHON_DIR=${EMG_LOCAL_BASE_DIR}/python/${PYTHON_VERSION}
ARG PYTHON_BIN_DIR=${PYTHON_DIR}/bin
ARG PYTHON_SRC_DIR=${PYTHON_DIR}/src
ENV PIP_ROOT_USER_ACTION=warn

# Expected compile-time OpenSSL version prefix (_ssl.OPENSSL_VERSION_NUMBER, format 0xMNNFFPPS).
# Guards against building against system headers while linking our own libs:
# ssl.OPENSSL_VERSION reports the RUNTIME lib, this constant reports the HEADERS used at compile time.
# A mismatch means ABI drift - build must fail.
# Masks: 1.0.x -> 0x1000 | 1.1.x -> 0x1010 | 3.x -> 0x30 | 4.x -> 0x40
ENV PY_SSL_HDR_MASK=0x1010

# Need for future builds that require SSL linkage to Python
ENV PY_SSL_DIR=${OPENSSL_111_DIR}
ENV PY_SSL_LIB_DIR=${OPENSSL_111_LIB_DIR}
ENV PY_SSL_VERSION=${OPENSSL_111_VERSION}
ENV PKG_CONFIG_PATH=${PY_SSL_LIB_DIR}/pkgconfig:${PKG_CONFIG_PATH}
ENV CPPFLAGS="-I${PY_SSL_DIR}/include"
ENV LDFLAGS="-L${PY_SSL_LIB_DIR} -Wl,-rpath,${PY_SSL_LIB_DIR}"

COPY etc/pip.conf /etc/pip.conf
COPY --from=builder ${PYTHON_DIR} ${PYTHON_DIR}
COPY --from=builder ${OPENSSL_111_DIR} ${OPENSSL_111_DIR}
COPY --from=builder ${OPENSSL_111_SRC_DIR} ${OPENSSL_111_SRC_DIR}

ENV OPENSSL_ROOT=${OPENSSL_111_DIR}
ENV PATH="${OPENSSL_111_BIN_DIR}:${PYTHON_BIN_DIR}:${PATH}"

RUN mkdir -p /usr/local/src/python && \
    mv ${PYTHON_SRC_DIR} /usr/local/src/python/${PYTHON_VERSION} && \
    ln -sfv /usr/local/src/python/${PYTHON_VERSION} ${PYTHON_SRC_DIR} && \
    rm -rfv /usr/bin/pip3 && \
    rm -rfv /usr/bin/pip && \
    rm -rfv /usr/bin/python && \
    rm -rfv /usr/bin/python3 && \
    rm -rf /tmp/* && \
    update-alternatives --install /usr/bin/pip3 pip3 ${PYTHON_DIR}/bin/pip${PYTHON_VERSION} 1 && \
    update-alternatives --install /usr/bin/pip pip ${PYTHON_DIR}/bin/pip${PYTHON_VERSION} 1 && \
    update-alternatives --install /usr/bin/python python ${PYTHON_DIR}/bin/python${PYTHON_VERSION} 1 && \
    update-alternatives --install /usr/bin/python3 python3 ${PYTHON_DIR}/bin/python${PYTHON_VERSION} 1

# Assert the built interpreter actually uses OUR OpenSSL, not the system one.
# Three independent checks, each catches a different failure:
#   1. runtime version  - ssl.OPENSSL_VERSION      (which lib is loaded)
#   2. compile-time ver - _ssl.OPENSSL_VERSION_NUMBER (which headers were used)
#   3. linkage          - ldd of _ssl / _hashlib   (resolved from our prefix, no 'not found')
# Checks 1 and 2 disagreeing means ABI drift: compiled against system headers, linked to ours.
RUN set -eu; \
    py="${PYTHON_DIR}/bin/python${PYTHON_VERSION}"; \
    echo "============================================="; \
    "$py" --version; \
    python3 --version; \
    python --version; \
    pip3 --version; \
    pip --version; \
    echo "============================================="; \
    echo "--- Checking SSL compile-time headers (Final) ---"; \
    hdr="$("$py" -c 'import _ssl; print(hex(_ssl.OPENSSL_VERSION_NUMBER))')"; \
    echo "compile-time OPENSSL_VERSION_NUMBER = ${hdr}"; \
    case "${hdr}" in \
      ${PY_SSL_HDR_MASK}*) ;; \
      *) echo "FATAL: built against wrong OpenSSL headers: ${hdr} (expected ${PY_SSL_HDR_MASK}*)" >&2; exit 1 ;; \
    esac; \
    echo "--- Checking SSL version (Final) ---"; \
    got="$("$py" -c 'import ssl; print(ssl.OPENSSL_VERSION)')"; \
    echo "ssl.OPENSSL_VERSION = ${got}"; \
    case "${got}" in \
      "OpenSSL ${PY_SSL_VERSION}"*) ;; \
      *) echo "FATAL: expected OpenSSL ${PY_SSL_VERSION}, got '${got}'" >&2; exit 1 ;; \
    esac; \
    echo "--- Checking SSL linkage (Final) ---"; \
    for m in _ssl _hashlib; do \
      so="$("$py" -c "import ${m}; print(${m}.__file__)")"; \
      echo "${m} -> ${so}"; \
      if ldd "$so" | grep -q 'not found'; then \
        echo "FATAL: ${m} has unresolved deps" >&2; ldd "$so" >&2; exit 1; \
      fi; \
      if ! ldd "$so" | grep -q "${PY_SSL_LIB_DIR}/lib"; then \
        echo "FATAL: ${m} not linked against ${PY_SSL_LIB_DIR}" >&2; ldd "$so" >&2; exit 1; \
      fi; \
    done; \
    echo "OK: OpenSSL ${PY_SSL_VERSION} from ${PY_SSL_LIB_DIR}"; \
    echo "============================================="

WORKDIR ${PYTHON_DIR}
