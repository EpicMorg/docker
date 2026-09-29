# check=skip=UndefinedVar
FROM docker.io/epicmorg/gcc:4 AS builder

# /etc/ld.so.conf.d/
ARG LD_CONF_DIR=/etc/ld.so.conf.d/

ENV PYTHON_VERSION=3.0
ENV PYTHON_FULL_VERSION=${PYTHON_VERSION}.1
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

# ncurses 6 hardcodes NCURSES_OPAQUE=1 (WINDOW is an incomplete type), but Include/py_curses.h of
# this version forces WINDOW_HAS_FLAGS=1 whenever <ncurses.h> is used -> _curses fails with
# "dereferencing pointer to incomplete type" on win->_flags. Backport the 3.6 guard.
RUN sed -i 's/^#ifndef WINDOW_HAS_FLAGS$/#if !defined(WINDOW_HAS_FLAGS) \&\& !(NCURSES_OPAQUE+0)/' Include/py_curses.h && \
    grep -q 'NCURSES_OPAQUE+0' Include/py_curses.h

# Configure flags checked against 3.0.1's own `./configure --help`:
#   - no --with-openssl (appears in 3.7): setup.py finds OpenSSL via -I/-L parsed from CPPFLAGS/LDFLAGS
#     (/usr/include/openssl is moved away above, so only our headers can match);
#   - no --enable-optimizations / --with-lto / --with-ensurepip / --enable-loadable-sqlite-extensions /
#     --with-computed-gotos (appear in 3.5.3 / 3.6 / 3.4 / 3.2 / 3.1);
#   - --with-system-ffi: 3.0 defaults to the bundled Modules/_ctypes/libffi, use Debian's libffi-dev instead;
#   - 3.0.1 configure is autoconf 2.61, which predates --enable-option-checking: the flag is kept but
#     is a no-op here, so every flag above was verified by hand;
#   - setup.py predates Debian multiarch support: /usr/{lib,include}/x86_64-linux-gnu are passed via
#     LDFLAGS/CPPFLAGS (after our OpenSSL/zlib dirs) so readline/sqlite3/ffi/bz2/... are found;
#   - ac_cv_prog_SVNVERSION=not-found: the builder has svnversion, which prints 'Unversioned directory'
#     and 3.0's getbuildinfo rule does not quote it -> 'gcc: error: directory": No such file'.
RUN set -eux; \
    export LDFLAGS="-L${OPENSSL_102_LIB_DIR} -L${ZLIB_LIB_DIR} -L/usr/lib/x86_64-linux-gnu -Wl,-rpath,${OPENSSL_102_LIB_DIR} -Wl,-rpath,${PYTHON_DIR}/lib -Wl,-rpath,${ZLIB_LIB_DIR}" && \
    export CPPFLAGS="-I${OPENSSL_102_INC_DIR} -I${ZLIB_INC_DIR} -I/usr/include/x86_64-linux-gnu" && \
    ac_cv_prog_SVNVERSION=not-found ./configure \
    --prefix=${PYTHON_DIR} \
    --enable-shared \
    --enable-option-checking=fatal \
    --with-system-ffi && \
    make -j$(nproc) && \
    make altinstall && \
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
# ADAPTED for 3.0: ssl.OPENSSL_VERSION and _ssl.OPENSSL_VERSION_NUMBER only exist since 2.7/3.2.
#   1. runtime version  - SSLeay_version(0) called via ctypes on the libcrypto that _ssl resolved;
#   2. compile-time ver - include dir recorded in _ssl's DWARF line table (built with -g) must be
#                         ${PY_SSL_DIR}/include/openssl, and that opensslv.h must match the mask.
RUN set -eu; \
    py="${PYTHON_DIR}/bin/python${PYTHON_VERSION}"; \
    echo "--- Checking SSL compile-time headers (builder) ---"; \
    ssl_so="$("$py" -c 'import _ssl; print(_ssl.__file__)')"; \
    inc="$(readelf --debug-dump=line "$ssl_so" | grep -oE '/[^[:space:]]*/openssl$' | sort -u)"; \
    echo "compile-time OpenSSL include dir(s) = ${inc}"; \
    if [ "${inc}" != "${PY_SSL_DIR}/include/openssl" ]; then \
      echo "FATAL: _ssl compiled against wrong OpenSSL headers: '${inc}' (expected ${PY_SSL_DIR}/include/openssl)" >&2; exit 1; \
    fi; \
    hdr="$(sed -n 's/^# *define OPENSSL_VERSION_NUMBER[[:space:]]*\(0x[0-9a-fA-F]*\)L.*/\1/p' "${inc}/opensslv.h")"; \
    echo "compile-time OPENSSL_VERSION_NUMBER = ${hdr}"; \
    case "${hdr}" in \
      ${PY_SSL_HDR_MASK}*) ;; \
      *) echo "FATAL: built against wrong OpenSSL headers: ${hdr} (expected ${PY_SSL_HDR_MASK}*)" >&2; exit 1 ;; \
    esac; \
    echo "--- Checking SSL version (builder) ---"; \
    crypto="$(ldd "$ssl_so" | awk '/libcrypto/ {print $3}')"; \
    got="$("$py" -c "import _ssl, ctypes; lib = ctypes.CDLL('${crypto}'); lib.SSLeay_version.restype = ctypes.c_char_p; v = lib.SSLeay_version(0); print(v if isinstance(v, str) else v.decode())")"; \
    echo "SSLeay_version(SSLEAY_VERSION) = ${got}"; \
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
#                  Python 3.0
##################################################################
ENV PYTHON_VERSION=3.0
ENV PYTHON_FULL_VERSION=${PYTHON_VERSION}.1
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
ENV LDFLAGS="-L${PY_SSL_LIB_DIR} -Wl,-rpath,${PY_SSL_LIB_DIR}"

COPY --from=builder ${PYTHON_DIR} ${PYTHON_DIR}
COPY --from=builder ${OPENSSL_102_DIR} ${OPENSSL_102_DIR}
COPY --from=builder ${OPENSSL_102_SRC_DIR} ${OPENSSL_102_SRC_DIR}

ENV OPENSSL_ROOT=${OPENSSL_102_DIR}
ENV PATH="${OPENSSL_102_BIN_DIR}:${PYTHON_BIN_DIR}:${PATH}"

# 3.0 ships no pip/ensurepip and no pip release supports it: no pip alternatives.
RUN mkdir -p /usr/local/src/python && \
    mv ${PYTHON_SRC_DIR} /usr/local/src/python/${PYTHON_VERSION} && \
    ln -sfv /usr/local/src/python/${PYTHON_VERSION} ${PYTHON_SRC_DIR} && \
    rm -rfv /usr/bin/pip3 && \
    rm -rfv /usr/bin/pip && \
    rm -rfv /usr/bin/python && \
    rm -rfv /usr/bin/python3 && \
    rm -rf /tmp/* && \
    update-alternatives --install /usr/bin/python python ${PYTHON_DIR}/bin/python${PYTHON_VERSION} 1 && \
    update-alternatives --install /usr/bin/python3 python3 ${PYTHON_DIR}/bin/python${PYTHON_VERSION} 1

# Assert the built interpreter actually uses OUR OpenSSL, not the system one.
# Three independent checks, each catches a different failure:
#   1. runtime version  - ssl.OPENSSL_VERSION      (which lib is loaded)
#   2. compile-time ver - _ssl.OPENSSL_VERSION_NUMBER (which headers were used)
#   3. linkage          - ldd of _ssl / _hashlib   (resolved from our prefix, no 'not found')
# Checks 1 and 2 disagreeing means ABI drift: compiled against system headers, linked to ours.
# ADAPTED for 3.0: ssl.OPENSSL_VERSION and _ssl.OPENSSL_VERSION_NUMBER only exist since 2.7/3.2.
#   1. runtime version  - SSLeay_version(0) called via ctypes on the libcrypto that _ssl resolved;
#   2. compile-time ver - include dir recorded in _ssl's DWARF line table (built with -g) must be
#                         ${PY_SSL_DIR}/include/openssl, and that opensslv.h must match the mask.
RUN set -eu; \
    py="${PYTHON_DIR}/bin/python${PYTHON_VERSION}"; \
    echo "============================================="; \
    "$py" --version; \
    python3 --version; \
    python --version; \
    echo "============================================="; \
    echo "--- Checking SSL compile-time headers (Final) ---"; \
    ssl_so="$("$py" -c 'import _ssl; print(_ssl.__file__)')"; \
    inc="$(readelf --debug-dump=line "$ssl_so" | grep -oE '/[^[:space:]]*/openssl$' | sort -u)"; \
    echo "compile-time OpenSSL include dir(s) = ${inc}"; \
    if [ "${inc}" != "${PY_SSL_DIR}/include/openssl" ]; then \
      echo "FATAL: _ssl compiled against wrong OpenSSL headers: '${inc}' (expected ${PY_SSL_DIR}/include/openssl)" >&2; exit 1; \
    fi; \
    hdr="$(sed -n 's/^# *define OPENSSL_VERSION_NUMBER[[:space:]]*\(0x[0-9a-fA-F]*\)L.*/\1/p' "${inc}/opensslv.h")"; \
    echo "compile-time OPENSSL_VERSION_NUMBER = ${hdr}"; \
    case "${hdr}" in \
      ${PY_SSL_HDR_MASK}*) ;; \
      *) echo "FATAL: built against wrong OpenSSL headers: ${hdr} (expected ${PY_SSL_HDR_MASK}*)" >&2; exit 1 ;; \
    esac; \
    echo "--- Checking SSL version (Final) ---"; \
    crypto="$(ldd "$ssl_so" | awk '/libcrypto/ {print $3}')"; \
    got="$("$py" -c "import _ssl, ctypes; lib = ctypes.CDLL('${crypto}'); lib.SSLeay_version.restype = ctypes.c_char_p; v = lib.SSLeay_version(0); print(v if isinstance(v, str) else v.decode())")"; \
    echo "SSLeay_version(SSLEAY_VERSION) = ${got}"; \
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
