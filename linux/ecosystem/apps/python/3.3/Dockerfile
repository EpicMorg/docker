# check=skip=UndefinedVar
FROM docker.io/epicmorg/gcc:7 AS builder

# /etc/ld.so.conf.d/
ARG LD_CONF_DIR=/etc/ld.so.conf.d/

ENV PYTHON_VERSION=3.3
ENV PYTHON_FULL_VERSION=${PYTHON_VERSION}.7
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
RUN : "${OPENSSL_102_DIR:?empty — check epicmorg/gcc ENV}" \
      "${OPENSSL_102_LIB_DIR:?empty}" "${ZLIB_LIB_DIR:?empty}"

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

# No ensurepip in this version: bootstrap the last setuptools/pip that still support it
# (pip 18 / setuptools 40 dropped 3.3), from sdists via `setup.py install` like 2.7 does.
ARG PIP_VERSION=10.0.1
ARG PIP_DOWNLOAD_URL=https://files.pythonhosted.org/packages/ae/e8/2340d46ecadb1692a1e455f13f75e596d4eab3d11a57446f08259dee8f02/pip-${PIP_VERSION}.tar.gz
ARG PIP_TEMP=/tmp/pip-${PIP_VERSION}.tar.gz
ARG PIP_TEMP_SRC=/tmp/pip-${PIP_VERSION}

ARG SETUPTOOLS_VERSION=39.2.0
ARG SETUPTOOLS_DOWNLOAD_URL=https://files.pythonhosted.org/packages/1a/04/d6f1159feaccdfc508517dba1929eb93a2854de729fa68da9d5c6b48fa00/setuptools-${SETUPTOOLS_VERSION}.zip
ARG SETUPTOOLS_TEMP=/tmp/setuptools.zip
ARG SETUPTOOLS_TEMP_SRC=/tmp/setuptools-${SETUPTOOLS_VERSION}

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

# distutils' runtime_library_dir_option() emits "-Wl,--enable-new-dtags,-R<dir>" for GNU ld,
# so extensions built with runtime_library_dirs (e.g. _sqlite3) get RUNPATH instead of RPATH
# (ADR-055). Flip it to --disable-new-dtags; no-op where this distutils doesn't have the line.
RUN f=Lib/distutils/unixccompiler.py; \
    if grep -q -- '--enable-new-dtags' "$f"; then \
      sed -i 's/--enable-new-dtags/--disable-new-dtags/g' "$f" && \
      ! grep -q -- '--enable-new-dtags' "$f"; \
    fi

# glibc >= 2.41 declares C23 sinpi() in <math.h>; Modules/mathmodule.c has its own static sinpi()
# -> "static declaration of 'sinpi' follows non-static declaration", math is silently skipped and
# everything importing it (random, tempfile, ensurepip) breaks. Rename it as upstream did (m_sinpi, 3.7+).
RUN sed -i 's/\bsinpi\b/m_sinpi/g' Modules/mathmodule.c && \
    grep -q 'm_sinpi(double x)' Modules/mathmodule.c

# ncurses 6 hardcodes NCURSES_OPAQUE=1 (WINDOW is an incomplete type), but Include/py_curses.h of
# this version forces WINDOW_HAS_FLAGS=1 whenever <ncurses.h> is used -> _curses fails with
# "dereferencing pointer to incomplete type" on win->_flags. Backport the 3.6 guard.
RUN sed -i 's/^#ifndef WINDOW_HAS_FLAGS$/#if !defined(WINDOW_HAS_FLAGS) \&\& !(NCURSES_OPAQUE+0)/' Include/py_curses.h && \
    grep -q 'NCURSES_OPAQUE+0' Include/py_curses.h

# Configure flags checked against 3.3.7's own `./configure --help`:
#   - no --with-openssl (appears in 3.7): setup.py finds OpenSSL via -I/-L parsed from CPPFLAGS/LDFLAGS
#     (/usr/include/openssl is moved away above, so only our headers can match);
#   - no --enable-optimizations / --with-lto / --with-ensurepip (appear in 3.5.3 / 3.6 / 3.4);
#   - --with-system-ffi: 3.3 defaults to the bundled Modules/_ctypes/libffi, use Debian's libffi-dev instead.
RUN set -eux; \
    export LDFLAGS="-L${OPENSSL_102_LIB_DIR} -L${ZLIB_LIB_DIR} -Wl,-rpath,${OPENSSL_102_LIB_DIR} -Wl,-rpath,${PYTHON_DIR}/lib -Wl,-rpath,${ZLIB_LIB_DIR} -Wl,--disable-new-dtags" && \
    export CPPFLAGS="-I${OPENSSL_102_INC_DIR} -I${ZLIB_INC_DIR}" && \
    ./configure \
    --prefix=${PYTHON_DIR} \
    --enable-shared \
    --enable-option-checking=fatal \
    --enable-loadable-sqlite-extensions \
    --with-computed-gotos \
    --with-system-ffi && \
    make -j$(nproc) && \
    make altinstall && \
    aria2c \
        --conf-path=/usr/local/share/epicmorg/aria2/config/aria2.conf \
        --user-agent="$(shuf -n 1 /usr/local/share/epicmorg/user-agents/user-agents.txt)" \
        -d / \
        -o ${SETUPTOOLS_TEMP}  \
        "${SETUPTOOLS_DOWNLOAD_URL}" && \
    unzip -q ${SETUPTOOLS_TEMP} -d /tmp && \
    cd ${SETUPTOOLS_TEMP_SRC} && \
    ${PYTHON_DIR}/bin/python${PYTHON_VERSION} setup.py install && \
    aria2c \
        --conf-path=/usr/local/share/epicmorg/aria2/config/aria2.conf \
        --user-agent="$(shuf -n 1 /usr/local/share/epicmorg/user-agents/user-agents.txt)" \
        -d / \
        -o ${PIP_TEMP}  \
        "${PIP_DOWNLOAD_URL}" && \
    tar -xzf ${PIP_TEMP} -C /tmp && \
    cd ${PIP_TEMP_SRC} && \
    ${PYTHON_DIR}/bin/python${PYTHON_VERSION} setup.py install && \
    rm -rf /tmp/*

# Version-agnostic aliases: keep the assertion block below byte-identical across all python versions.
ARG PY_SSL_DIR=${OPENSSL_102_DIR}
ARG PY_SSL_LIB_DIR=${OPENSSL_102_LIB_DIR}
ARG PY_SSL_VERSION=${OPENSSL_102_VERSION}

# Expected compile-time OpenSSL version prefix (_ssl.OPENSSL_VERSION_NUMBER, format 0xMNNFFPPS).
# Guards against building against system headers while linking our own libs:
# ssl.OPENSSL_VERSION reports the RUNTIME lib, this constant reports the HEADERS used at compile time.
# A mismatch means ABI drift - build must fail.
# Masks: 1.0.x -> 0x1000 | 1.1.x -> 0x1010 | 3.x -> 0x30 | 4.x -> 0x40
ARG PY_SSL_HDR_MASK=0x1000

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
#                  zlib 
##################################################################
ENV ZLIB_VERSION=1.3.1
ENV ZLIB_DIR=${EMG_LOCAL_BASE_DIR}/zlib/${ZLIB_VERSION}
ENV ZLIB_INC_DIR=${ZLIB_DIR}/include
ENV ZLIB_LIB_DIR=${ZLIB_DIR}/lib
ENV ZLIB_SRC_DIR=/usr/local/src/zlib/${ZLIB_VERSION}

##################################################################
#                  OpenSSL 1.0.2
##################################################################
ENV OPENSSL_102_VERSION=1.0.2
ENV OPENSSL_102_DIR=${EMG_LOCAL_BASE_DIR}/openssl/${OPENSSL_102_VERSION}
ENV OPENSSL_102_BIN_DIR=${OPENSSL_102_DIR}/bin
ENV OPENSSL_102_INC_DIR=${OPENSSL_102_DIR}/include
ENV OPENSSL_102_LIB_DIR=${OPENSSL_102_DIR}/lib
ENV OPENSSL_102_SRC_DIR=/usr/local/src/openssl/${OPENSSL_102_VERSION}
ENV SSL_CERT_DIR=/etc/ssl/certs
ENV REQUESTS_CA_BUNDLE=/etc/ssl/certs/ca-certificates.crt

##################################################################
#                  Python 3.3
##################################################################
ENV PYTHON_VERSION=3.3
ENV PYTHON_FULL_VERSION=${PYTHON_VERSION}.7
ENV PYTHON_DIR=${EMG_LOCAL_BASE_DIR}/python/${PYTHON_VERSION}
ARG PYTHON_BIN_DIR=${PYTHON_DIR}/bin
ARG PYTHON_SRC_DIR=${PYTHON_DIR}/src
ENV PIP_ROOT_USER_ACTION=warn

# Expected compile-time OpenSSL version prefix (_ssl.OPENSSL_VERSION_NUMBER, format 0xMNNFFPPS).
# Guards against building against system headers while linking our own libs:
# ssl.OPENSSL_VERSION reports the RUNTIME lib, this constant reports the HEADERS used at compile time.
# A mismatch means ABI drift - build must fail.
# Masks: 1.0.x -> 0x1000 | 1.1.x -> 0x1010 | 3.x -> 0x30 | 4.x -> 0x40
ENV PY_SSL_HDR_MASK=0x1000

# Need for future builds that require SSL linkage to Python
ENV PY_SSL_DIR=${OPENSSL_102_DIR}
ENV PY_SSL_LIB_DIR=${OPENSSL_102_LIB_DIR}
ENV PY_SSL_VERSION=${OPENSSL_102_VERSION}
ENV PKG_CONFIG_PATH=${PY_SSL_LIB_DIR}/pkgconfig:${PKG_CONFIG_PATH}
ENV CPPFLAGS="-I${PY_SSL_DIR}/include"
ENV LDFLAGS="-L${PY_SSL_LIB_DIR} -Wl,-rpath,${PY_SSL_LIB_DIR} -Wl,--disable-new-dtags"

COPY etc/pip.conf /etc/pip.conf
COPY --from=builder ${PYTHON_DIR} ${PYTHON_DIR}
COPY --from=builder ${OPENSSL_102_DIR} ${OPENSSL_102_DIR}
COPY --from=builder ${OPENSSL_102_SRC_DIR} ${OPENSSL_102_SRC_DIR}
COPY --from=builder ${ZLIB_DIR} ${ZLIB_DIR}
COPY --from=builder ${ZLIB_SRC_DIR} ${ZLIB_SRC_DIR}

ENV OPENSSL_ROOT=${OPENSSL_102_DIR}
ENV PATH="${OPENSSL_102_BIN_DIR}:${PYTHON_BIN_DIR}:${PATH}"

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
    echo "--- Checking RPATH (Final) ---"; \
    for f in "$py" "${PYTHON_DIR}"/lib/libpython*.so.* "${PYTHON_DIR}/lib/python${PYTHON_VERSION}"/lib-dynload/*.so; do \
      readelf -d "$f" | grep -q '(RUNPATH)' && { echo "FATAL: $f has RUNPATH, expected RPATH" >&2; exit 1; }; \
      readelf -d "$f" | grep -q '(RPATH)' || { echo "FATAL: $f has no RPATH" >&2; readelf -d "$f" >&2; exit 1; }; \
    done; \
    echo "--- Checking zlib linkage (Final) ---"; \
    zso="$("$py" -c 'import zlib; print(zlib.__file__)')"; \
    echo "zlib -> ${zso}"; \
    if ! ldd "$zso" | grep -q "${ZLIB_LIB_DIR}/libz"; then \
      echo "FATAL: zlib not linked against ${ZLIB_LIB_DIR}" >&2; ldd "$zso" >&2; exit 1; \
    fi; \
    libz="$("$py" -c 'import ssl, zlib; print(open("/proc/self/maps").read())' | awk '/libz\.so/ {print $NF}' | sort -u)"; \
    echo "runtime libz (after import ssl, zlib) = ${libz}"; \
    if [ -z "${libz}" ] || echo "${libz}" | grep -qv "^${ZLIB_LIB_DIR}/"; then \
      echo "FATAL: runtime libz not (only) from ${ZLIB_LIB_DIR}" >&2; exit 1; \
    fi; \
    echo "OK: OpenSSL ${PY_SSL_VERSION} from ${PY_SSL_LIB_DIR}"; \
    echo "============================================="

WORKDIR ${PYTHON_DIR}
