# check=skip=UndefinedVar
##################################################################
##################################################################
#                          Builder
##################################################################
##################################################################
FROM docker.io/epicmorg/gcc:14 AS builder

# /etc/ld.so.conf.d/
ARG LD_CONF_DIR=/etc/ld.so.conf.d/

ENV PHP_VERSION=5.3
ENV PHP_FULL_VERSION=${PHP_VERSION}.29
ENV PHP_DIR=${EMG_LOCAL_BASE_DIR}/php/${PHP_VERSION}
ENV PHP_INI_DIR=${PHP_DIR}/etc
ENV PHP_INI_SCAN_DIR=${PHP_DIR}/etc/conf.d
ARG PHP_BIN_DIR=${PHP_DIR}/bin
ARG PHP_SRC_DIR=${PHP_DIR}/src
ARG PHP_TARBALL=php-${PHP_FULL_VERSION}.tar.xz
ARG PHP_DOWNLOAD_URL=https://www.php.net/distributions/${PHP_TARBALL}
ARG PHP_TEMP=/tmp/${PHP_TARBALL}
# Upstream sha256 for php-5.3.29.tar.xz - bump together with PHP_FULL_VERSION.
ARG PHP_SHA256=8438c2f14ab8f3d6cd2495aa37de7b559e33b610f9ab264f0c61b531bf0c262d

ENV SSL_CERT_DIR=/etc/ssl/certs

##################################################################
#                    Prepare PHP build
##################################################################

# Simple check if ENVs inherited from epicmorg/gcc are alive.
RUN : "${OPENSSL_102_DIR:?empty - check epicmorg/gcc ENV}" \
      "${OPENSSL_102_LIB_DIR:?empty}" "${OPENSSL_102_INC_DIR:?empty}" \
      "${ICU_67_DIR:?empty}" "${ICU_67_LIB_DIR:?empty}" "${ICU_67_INC_DIR:?empty}" \
      "${CURL_817_102_DIR:?empty}" "${CURL_817_102_LIB_DIR:?empty}" \
      "${LIBPQ_13_102_DIR:?empty}" "${LIBPQ_13_102_LIB_DIR:?empty}"

# Pin all php* packages to priority -1 so apt never pulls distro PHP.
COPY etc/apt/preferences.d /etc/apt/preferences.d

# Headers required by PHP's ./configure: without these the corresponding
# bundled extensions silently fail to configure (or are skipped entirely).
#
# NOTE 1: libicu-dev is deliberately absent - Trixie ships ICU 76, whose headers
#         require C++17. ICU 67.1 is baked in the develop image instead.
# NOTE 2: libcurl4-openssl-dev / libpq-dev depend on libssl-dev - that is why the
#         system-OpenSSL-headers hiding below MUST happen after this step.
# NOTE 3: no libargon2/libsodium/libonig/libzip/libwebp here - PHP 5.x has no
#         argon2/sodium/webp support and bundles its own oniguruma and libzip.
RUN apt-get update && apt-get install -y --no-install-recommends \
    autoconf \
    bison \
    bzip2 \
    dpkg-dev \
    file \
    g++ \
    gcc \
    gettext \
    libbz2-dev \
    libc-dev \
    libfreetype6-dev \
    libgdbm-dev \
    libgmp-dev \
    libjpeg-dev \
    libpng-dev \
    libreadline-dev \
    libsqlite3-dev \
    libtidy-dev \
    libxml2-dev \
    libxpm-dev \
    libxslt1-dev \
    make \
    pkg-config \
    re2c \
    xz-utils \
    zlib1g-dev \
    && rm -rf /var/lib/apt/lists/*

# Hide system OpenSSL headers so ./configure and pkg-config cannot pick them up.
# MUST run after apt: several -dev packages depend on libssl-dev and would
# restore this directory.
RUN mv /usr/include/openssl /usr/include/openssl.disabled && \
    mv /usr/lib/x86_64-linux-gnu/pkgconfig/openssl.pc \
       /usr/lib/x86_64-linux-gnu/pkgconfig/openssl.pc.disabled 2>/dev/null || true

# PHP 5.x ext/gmp only looks for <prefix>/include/gmp.h and does not know about
# Debian multiarch (/usr/include/x86_64-linux-gnu/gmp.h). Builder stage only.
RUN ln -sfv /usr/include/x86_64-linux-gnu/gmp.h /usr/include/gmp.h

##################################################################
#                  ICU 67.1
##################################################################
# Debian Trixie ships ICU 76, whose public headers require C++17.
# ICU 67.1 (baked in develop) serves the whole 5.x and 7.0-7.3 line.
RUN set -eux; \
    test -f ${ICU_67_LIB_DIR}/libicuuc.so || { \
      echo "FATAL: ICU libs not in ${ICU_67_LIB_DIR}" >&2; ls -la ${ICU_67_DIR}/ >&2; exit 1; }

# Hide the system ICU from both the compiler and the linker.
# Headers: otherwise ext/intl picks up ICU 76 declarations.
# The unversioned .so / .a symlinks: otherwise `-licuuc` resolves to the system
# ICU 76 and the build fails with "undefined reference to ..._67" at link time.
# The versioned .so.76.1 files stay - other system tools still need them.
RUN set -eux; \
    mv /usr/include/unicode /usr/include/unicode.disabled; \
    rm -f /usr/lib/x86_64-linux-gnu/libicu*.so \
          /usr/lib/x86_64-linux-gnu/libicu*.a

##################################################################
#                    Fetching sources
##################################################################
RUN set -eux; \
    mkdir -p ${PHP_DIR} ${PHP_SRC_DIR} ${PHP_BIN_DIR}; \
    aria2c \
        --conf-path=/usr/local/share/epicmorg/aria2/config/aria2.conf \
        --user-agent="$(shuf -n 1 /usr/local/share/epicmorg/user-agents/user-agents.txt)" \
        -d / \
        -o ${PHP_TEMP} \
        "${PHP_DOWNLOAD_URL}"; \
    echo "${PHP_SHA256} *${PHP_TEMP}" | sha256sum -c -; \
    tar -xaf ${PHP_TEMP} --strip-components=1 --directory ${PHP_SRC_DIR}; \
    rm -rfv ${PHP_TEMP}

ENV PATH="${ICU_67_DIR}/bin:${PHP_BIN_DIR}:${PATH}"

WORKDIR ${PHP_SRC_DIR}

##################################################################
#                    Build flags
##################################################################
# Same hardening/optimization set the official docker-library/php images use.
# https://github.com/docker-library/php/issues/272
#
# gcc 14 turned several old-C diagnostics into hard errors. PHP 5.x sources AND
# its autoconf feature tests (`main(){ exit(0); }` - implicit int, implicit
# exit()) rely on them being warnings. Without these flags ./configure does NOT
# fail - it silently answers "no" to ~20 run-tests (getaddrinfo, pread/pwrite,
# ZEND_MM_ALIGNMENT, ...) and produces a subtly broken PHP.
# The flags restore exactly the gcc <= 13 semantics upstream was tested with;
# the compiler itself stays the system cc (gcc 14), see ADR-015.
ENV PHP_GCC14_COMPAT_CFLAGS="-Wno-error=implicit-function-declaration -Wno-error=implicit-int -Wno-error=int-conversion -Wno-error=incompatible-pointer-types -Wno-error=return-mismatch -Wno-error=declaration-missing-parameter-type"
ENV PHP_CFLAGS="-fstack-protector-strong -fpic -fpie -O2 -D_LARGEFILE_SOURCE -D_FILE_OFFSET_BITS=64"
ENV PHP_CPPFLAGS="${PHP_CFLAGS}"
ENV PHP_LDFLAGS="-Wl,-O1 -pie"

##################################################################
#                    configure + make
##################################################################
# --with-openssl WITHOUT a directory: PHP 5.x then uses pkg-config, and
# PKG_CONFIG_PATH is what pins our baked OpenSSL. With --with-openssl=DIR it
# looks for DIR/$PHP_LIBDIR (= DIR/lib/x86_64-linux-gnu) and fails.
#
# PHP 5.x gd needs freetype-config, which Trixie no longer ships.
RUN set -eux; \
    printf '%s\n' \
      '#!/bin/sh' \
      'case "$1" in' \
      '  --cflags) pkg-config --cflags freetype2 ;;' \
      '  --libs)   pkg-config --libs freetype2 ;;' \
      '  --ftversion) pkg-config --modversion freetype2 ;;' \
      '  --prefix) echo /usr ;;' \
      '  *) exit 1 ;;' \
      'esac' \
      > /usr/local/bin/freetype-config; \
    chmod +x /usr/local/bin/freetype-config; \
    freetype-config --ftversion

# ext/intl in PHP <= 5.4 includes ICU C headers (umsg.h, ubrk.h via
# php_intl.h / msgformat_data.h) inside an `extern "C" {}` block of
# msgformat_helpers.cpp. ICU >= 59 declares C++ LocalPointer helpers in those
# headers, which conflict inside extern "C" ("conflicting declaration of C
# function icu_67::swap"). Upstream fixed it in 5.5 by including the ICU
# headers first; do the same for this one file.
RUN set -eux; \
    f=ext/intl/msgformat/msgformat_helpers.cpp; \
    sed -i 's|^#include <unicode/chariter.h>$|&\n#include <unicode/umsg.h>\n#include <unicode/ubrk.h>\n#include <unicode/ustring.h>|' "$f"; \
    grep -q '^#include <unicode/ubrk.h>$' "$f" || { echo "FATAL: intl msgformat patch did not apply" >&2; exit 1; }

# Unknown options: PHP 5.3's configure is generated by autoconf 2.13, which has
# no --enable-option-checking at all (passing it only yields PHP's own
# "unknown option" notice). The fatal guard here is PHP's own
# "Notice: Following unknown configure options" check below.
#
# Compiler: autoconf 2.13's AC_PROG_CC probes `gcc` BEFORE `cc`, so in the gcc
# image it would pick the image's own gcc instead of the system cc that every
# other PHP image (and ICU 67 / libstdc++) is built with. CC=cc / CXX=c++
# pins the SAME system compiler the other versions pick implicitly - this is
# not a CC=gccNN override (see ADR-015).
#
# LIBS=-lstdc++: 5.3 links php/php-fpm with the C driver and does not add
# libstdc++ for the C++ object from ext/intl
# ("undefined reference to symbol '__gxx_personality_v0@@CXXABI_1.3'").
RUN set -eux; \
    export CC=cc CXX=c++; \
    export LIBS="-lstdc++"; \
    export ac_cv_func_readdir_r=no; \
    debMultiarch="$(dpkg-architecture --query DEB_BUILD_MULTIARCH)"; \
    export ICU_CFLAGS="-I${ICU_67_INC_DIR}"; \
    export ICU_LIBS="-L${ICU_67_LIB_DIR} -licui18n -licuuc -licudata -licuio"; \
    export LD_LIBRARY_PATH="${ICU_67_LIB_DIR}:${CURL_817_102_LIB_DIR}:${LIBPQ_13_102_LIB_DIR}:${OPENSSL_102_LIB_DIR}:${LD_LIBRARY_PATH:-}"; \
    export PKG_CONFIG_PATH="${OPENSSL_102_LIB_DIR}/pkgconfig:${ICU_67_LIB_DIR}/pkgconfig:${CURL_817_102_LIB_DIR}/pkgconfig:${LIBPQ_13_102_LIB_DIR}/pkgconfig:${PKG_CONFIG_PATH:-}"; \
    export CFLAGS="${PHP_CFLAGS} ${PHP_GCC14_COMPAT_CFLAGS}"; \
    export CXXFLAGS="${PHP_CFLAGS} -fpermissive -DU_USING_ICU_NAMESPACE=1"; \
    export CPPFLAGS="-I${OPENSSL_102_INC_DIR} -I${ICU_67_INC_DIR} -I${CURL_817_102_INC_DIR} ${PHP_CPPFLAGS}"; \
    export LDFLAGS="-L${OPENSSL_102_LIB_DIR} -L${ICU_67_LIB_DIR} -L${CURL_817_102_LIB_DIR} -L${LIBPQ_13_102_LIB_DIR} -Wl,-rpath,${OPENSSL_102_LIB_DIR} -Wl,-rpath,${ICU_67_LIB_DIR} -Wl,-rpath,${CURL_817_102_LIB_DIR} -Wl,-rpath,${LIBPQ_13_102_LIB_DIR} -Wl,-rpath,${PHP_DIR}/lib ${PHP_LDFLAGS} -Wl,--disable-new-dtags"; \
    ./configure \
      --prefix=${PHP_DIR} \
      --sysconfdir=${PHP_INI_DIR} \
      --with-config-file-path=${PHP_INI_DIR} \
      --with-config-file-scan-dir=${PHP_INI_SCAN_DIR} \
      --with-libdir="lib/${debMultiarch}" \
      \
#      --enable-option-checking=fatal \
      --with-pic \
      --with-mhash \
      \
      `# ---- SAPI ----` \
      --enable-fpm \
      --with-fpm-user=www-data \
      --with-fpm-group=www-data \
      `# 5.3 builds cli + exactly ONE other SAPI: with fpm there is no` \
      `# php-cgi and no embed (configure: multiple SAPIs error)` \
#      --enable-cgi \
#      --enable-phpdbg \
#      --enable-embed \
      \
      `# ---- core / crypto ----` \
      --with-openssl \
      --with-zlib \
      --with-bz2 \
      --with-curl=${CURL_817_102_DIR} \
      --with-iconv \
      --with-readline \
      --enable-mbstring \
      --enable-json \
      \
      `# ---- database ----` \
      --enable-mysqlnd \
      --with-mysql=mysqlnd \
      --with-mysqli=mysqlnd \
      --with-pdo-mysql=mysqlnd \
      --with-pgsql=${LIBPQ_13_102_DIR} \
      --with-pdo-pgsql=${LIBPQ_13_102_DIR} \
      --with-sqlite3=/usr \
      --with-pdo-sqlite=/usr \
      --enable-dba \
      --with-gdbm \
      \
      `# ---- text / xml ----` \
      --enable-intl \
      --with-icu-dir=${ICU_67_DIR} \
      --with-xsl \
      --with-tidy \
      --with-gettext \
      \
      `# ---- graphics ----` \
      --with-gd \
      --with-jpeg-dir=/usr \
      --with-png-dir=/usr \
      --with-freetype-dir=/usr \
      --with-xpm-dir=/usr \
      --enable-gd-native-ttf \
      \
      `# ---- misc ----` \
      --enable-bcmath \
      --enable-calendar \
      --enable-exif \
      --enable-ftp \
      --enable-pcntl \
      --enable-shmop \
      --enable-soap \
      --enable-sockets \
      --enable-sysvmsg \
      --enable-sysvsem \
      --enable-sysvshm \
#      --enable-opcache \
      --with-gmp \
      --enable-zip \
      \
      `# ---- pear/pecl ----` \
      --with-pear \
      > /tmp/php-configure.log 2>&1 \
    || { tail -n 60 /tmp/php-configure.log >&2; exit 1; }; \
    cat /tmp/php-configure.log; \
    if grep -q 'Following unknown configure options' /tmp/php-configure.log; then \
      echo "FATAL: unknown configure options" >&2; \
      grep -A10 'Following unknown configure options' /tmp/php-configure.log >&2; exit 1; \
    fi; \
    rm -f /tmp/php-configure.log; \
    # Guard against the gcc 14 silent misconfiguration (see PHP_GCC14_COMPAT_CFLAGS):
    # these are "yes" on any glibc system and "no" when the autoconf run-tests
    # were broken by -Werror=implicit-*.
    for def in HAVE_GETADDRINFO HAVE_PREAD HAVE_PWRITE ZEND_MM_ALIGNMENT; do \
      grep -q "^#define ${def} " main/php_config.h || { \
        echo "FATAL: ${def} undefined - configure run-tests broken (gcc 14 errors?)" >&2; exit 1; }; \
    done; \
    make -j"$(nproc)"; \
    find -type f -name '*.a' -delete; \
    make install; \
    make clean

##################################################################
#                    Default ini + scan dir
##################################################################
# PHP 5.x installs a single php-fpm.conf.default with the [www] pool inline;
# there is no php-fpm.d/www.conf.default before 7.0. Our own configs are
# copied in the final stage anyway.
RUN set -eux; \
    mkdir -p ${PHP_INI_SCAN_DIR} ${PHP_INI_DIR}/php-fpm.d; \
    cp ${PHP_SRC_DIR}/php.ini-production ${PHP_INI_DIR}/php.ini; \
    cp ${PHP_INI_DIR}/php-fpm.conf.default ${PHP_INI_DIR}/php-fpm.conf

##################################################################
#                    OpenSSL assertions (builder)
##################################################################
# Version-agnostic aliases: keep the assertion block below byte-identical
# across all PHP versions - only these four lines change.
ARG PHP_SSL_DIR=${OPENSSL_102_DIR}
ARG PHP_SSL_LIB_DIR=${OPENSSL_102_LIB_DIR}
ARG PHP_SSL_VERSION=1.0.2

# Expected compile-time OpenSSL version prefix (OPENSSL_VERSION_NUMBER, format 0xMNNFFPPS).
# Masks: 1.0.x -> 0x1000 | 1.1.x -> 0x1010 | 3.x -> 0x30 | 4.x -> 0x40
ARG PHP_SSL_HDR_MASK=0x1000

# Assert the built interpreter actually uses OUR OpenSSL, not the system one.
# Three independent checks, each catches a different failure:
#   1. header version  - "OpenSSL Header Version"  (which headers were used)
#   2. library version - "OpenSSL Library Version" (which lib is loaded at runtime)
#   3. linkage         - ldd of the php binary     (resolved from our prefix, no 'not found')
# Checks 1 and 2 disagreeing means ABI drift: compiled against system headers, linked to ours.
RUN set -eu; \
    php="${PHP_BIN_DIR}/php"; \
    echo "--- Checking OpenSSL headers/library (builder) ---"; \
    hdr="$("$php" -r 'echo dechex(OPENSSL_VERSION_NUMBER);')"; \
    echo "compile-time OPENSSL_VERSION_NUMBER = 0x${hdr}"; \
    case "0x${hdr}" in \
      ${PHP_SSL_HDR_MASK}*) ;; \
      *) echo "FATAL: built against wrong OpenSSL headers: 0x${hdr} (expected ${PHP_SSL_HDR_MASK}*)" >&2; exit 1 ;; \
    esac; \
    lib="$("$php" -i | sed -n 's/^OpenSSL Library Version => //p')"; \
    echo "runtime OpenSSL Library Version = ${lib}"; \
    case "${lib}" in \
      "OpenSSL ${PHP_SSL_VERSION}"*) ;; \
      *) echo "FATAL: expected OpenSSL ${PHP_SSL_VERSION}, got '${lib}'" >&2; exit 1 ;; \
    esac; \
    echo "--- Checking OpenSSL linkage (builder) ---"; \
    if ldd "$php" | grep -q 'not found'; then \
      echo "FATAL: php has unresolved deps" >&2; ldd "$php" >&2; exit 1; \
    fi; \
    if ! ldd "$php" | grep -q "${PHP_SSL_LIB_DIR}/libssl"; then \
      echo "FATAL: php not linked against ${PHP_SSL_LIB_DIR}" >&2; ldd "$php" >&2; exit 1; \
    fi; \
    echo "OK (builder): OpenSSL ${PHP_SSL_VERSION} from ${PHP_SSL_LIB_DIR}"; \
    if [ "$(ldd "$php" | grep -c 'libssl')" != "1" ]; then \
      echo "WARN: more than one libssl in this binary (system libpq/libcurl pull OpenSSL 3)"; \
      ldd "$php" | grep -i ssl; \
    fi; \
    echo "--- Checking ICU (builder) ---"; \
    icu="$("$php" -i | sed -n 's/^ICU version => //p')"; \
    echo "ICU version = ${icu}"; \
    case "${icu}" in \
      ${ICU_67_VERSION}*) ;; \
      *) echo "FATAL: expected ICU ${ICU_67_VERSION}, got '${icu}'" >&2; exit 1 ;; \
    esac; \
    "$php" -v; \
    "$php" -m

##################################################################
##################################################################
##################################################################
#                          Final Layer
##################################################################
##################################################################
##################################################################
FROM docker.io/epicmorg/debian:trixie
LABEL org.opencontainers.image.title="EpicMorg PHP"
LABEL org.opencontainers.image.description="PHP by EpicMorg"

# Pin all php* packages to priority -1 so apt never pulls distro PHP.
COPY etc/apt/preferences.d /etc/apt/preferences.d

# Build toolchain + headers for the FINAL image: PECL extensions compile C
# sources at install time (redis, apcu, ...).
# Not used to build PHP itself - that happens in the builder stage.
# libicu-dev is deliberately absent here too: PECL builds must not reach ICU 76.
# libmemcached-dev is deliberately absent: see the PECL section below.
RUN apt-get update && apt-get install -y --no-install-recommends \
    autoconf \
    bison \
    dpkg-dev \
    file \
    g++ \
    gcc \
    gettext \
    libbz2-dev \
    libc-dev \
    libfreetype6-dev \
    libgdbm-dev \
    libgmp-dev \
    libjpeg-dev \
    libpng-dev \
    libreadline-dev \
    libsqlite3-dev \
    libtidy-dev \
    libxml2-dev \
    libxpm-dev \
    libxslt1-dev \
    make \
    pkg-config \
    re2c \
    xz-utils \
    zlib1g-dev \
    && apt-get autoremove -y \
    && rm -rf /var/lib/apt/lists/*


##################################################################
#           curl 8.17
##################################################################
ENV CURL_817_VERSION=8.17.0
ENV CURL_817_102_DIR=${EMG_LOCAL_BASE_DIR}/curl/${CURL_817_VERSION}/openssl102
ENV CURL_817_102_INC_DIR=${CURL_817_102_DIR}/include
ENV CURL_817_102_LIB_DIR=${CURL_817_102_DIR}/lib
ENV CURL_817_SRC_DIR=/usr/local/src/curl/${CURL_817_VERSION}

##################################################################
#           libpq 13 + OpenSSL 1.0.2u
##################################################################
ENV LIBPQ_13_VERSION=13
ENV LIBPQ_13_102_DIR=${EMG_LOCAL_BASE_DIR}/libpq/${LIBPQ_13_VERSION}/openssl102
ENV LIBPQ_13_102_INC_DIR=${LIBPQ_13_102_DIR}/include
ENV LIBPQ_13_102_LIB_DIR=${LIBPQ_13_102_DIR}/lib
ENV LIBPQ_13_SRC_DIR=/usr/local/src/postgresql/${LIBPQ_13_VERSION}

##################################################################
#                  ICU 67.1
##################################################################
ENV ICU_67_MIN_VERSION=67
ENV ICU_67_VERSION=${ICU_67_MIN_VERSION}.1
ENV ICU_67_VERSION_U=67_1
ENV ICU_67_DIR=${EMG_LOCAL_BASE_DIR}/icu/${ICU_67_MIN_VERSION}
ENV ICU_67_INC_DIR=${ICU_67_DIR}/include
ENV ICU_67_LIB_DIR=${ICU_67_DIR}/lib
ENV ICU_67_SRC_DIR=/usr/local/src/icu/${ICU_67_MIN_VERSION}

##################################################################
#                  OpenSSL 1.0.2
##################################################################
# NOTE: these must match the layout produced in the develop/gcc image.
# If OpenSSL was installed with --libdir=lib64, change OPENSSL_102_LIB_DIR
# accordingly - the guard after the COPY block below will catch a mismatch.
ENV OPENSSL_102_VERSION=1.0.2
ENV OPENSSL_102_DIR=${EMG_LOCAL_BASE_DIR}/openssl/${OPENSSL_102_VERSION}
ENV OPENSSL_102_BIN_DIR=${OPENSSL_102_DIR}/bin
ENV OPENSSL_102_INC_DIR=${OPENSSL_102_DIR}/include
ENV OPENSSL_102_LIB_DIR=${OPENSSL_102_DIR}/lib
ENV OPENSSL_102_SRC_DIR=/usr/local/src/openssl/${OPENSSL_102_VERSION}
# The compiled-in OPENSSLDIR of the baked 1.0.2 is its own prefix, which has no
# CA store: SSL_CERT_DIR is what points peer verification at the Debian one.
ENV SSL_CERT_DIR=/etc/ssl/certs

##################################################################
#                  PHP 5.3
##################################################################
ENV PHP_VERSION=5.3
ENV PHP_FULL_VERSION=${PHP_VERSION}.29
ENV PHP_DIR=${EMG_LOCAL_BASE_DIR}/php/${PHP_VERSION}
ENV PHP_INI_DIR=${PHP_DIR}/etc
ENV PHP_INI_SCAN_DIR=${PHP_DIR}/etc/conf.d
ARG PHP_BIN_DIR=${PHP_DIR}/bin
ARG PHP_SRC_DIR=${PHP_DIR}/src

# Expected compile-time OpenSSL version prefix (OPENSSL_VERSION_NUMBER, format 0xMNNFFPPS).
# Masks: 1.0.x -> 0x1000 | 1.1.x -> 0x1010 | 3.x -> 0x30 | 4.x -> 0x40
ENV PHP_SSL_HDR_MASK=0x1000

# Needed by PECL builds so extensions link against OUR OpenSSL and ICU,
# not the system ones.
# PHP_CFLAGS carries the gcc 14 compat flags (see builder): php-ext-install /
# php-ext-configure and the PECL builds below compile PHP 5.x-era C code with
# the system gcc 14 as well.
ENV PHP_SSL_DIR=${OPENSSL_102_DIR}
ENV PHP_SSL_LIB_DIR=${OPENSSL_102_LIB_DIR}
ENV PHP_SSL_VERSION=${OPENSSL_102_VERSION}
ENV PKG_CONFIG_PATH=${PHP_SSL_LIB_DIR}/pkgconfig:${ICU_67_LIB_DIR}/pkgconfig:${CURL_817_102_LIB_DIR}/pkgconfig:${LIBPQ_13_102_LIB_DIR}/pkgconfig:${PKG_CONFIG_PATH}
ENV PHP_GCC14_COMPAT_CFLAGS="-Wno-error=implicit-function-declaration -Wno-error=implicit-int -Wno-error=int-conversion -Wno-error=incompatible-pointer-types -Wno-error=return-mismatch -Wno-error=declaration-missing-parameter-type"
ENV PHP_CFLAGS="-fstack-protector-strong -fpic -fpie -O2 -D_LARGEFILE_SOURCE -D_FILE_OFFSET_BITS=64 ${PHP_GCC14_COMPAT_CFLAGS}"
ENV PHP_CPPFLAGS="-I${PHP_SSL_DIR}/include -I${ICU_67_INC_DIR} -fstack-protector-strong -fpic -fpie -O2 -D_LARGEFILE_SOURCE -D_FILE_OFFSET_BITS=64"
ENV PHP_LDFLAGS="-L${PHP_SSL_LIB_DIR} -L${ICU_67_LIB_DIR} -L${CURL_817_102_LIB_DIR} -L${LIBPQ_13_102_LIB_DIR} -Wl,-rpath,${PHP_SSL_LIB_DIR} -Wl,-rpath,${ICU_67_LIB_DIR} -Wl,-rpath,${CURL_817_102_LIB_DIR} -Wl,-rpath,${LIBPQ_13_102_LIB_DIR} -Wl,-O1 -pie -Wl,--disable-new-dtags"

COPY --from=builder ${PHP_DIR}               ${PHP_DIR}
COPY --from=builder ${PHP_SRC_DIR}           ${PHP_SRC_DIR}
COPY --from=builder ${OPENSSL_102_DIR}       ${OPENSSL_102_DIR}
COPY --from=builder ${OPENSSL_102_SRC_DIR}   ${OPENSSL_102_SRC_DIR}
COPY --from=builder ${ICU_67_DIR}            ${ICU_67_DIR}
COPY --from=builder ${ICU_67_SRC_DIR}        ${ICU_67_SRC_DIR}
COPY --from=builder ${CURL_817_102_DIR}      ${CURL_817_102_DIR}
COPY --from=builder ${CURL_817_SRC_DIR}      ${CURL_817_SRC_DIR}
COPY --from=builder ${LIBPQ_13_102_DIR}      ${LIBPQ_13_102_DIR}
COPY --from=builder ${LIBPQ_13_SRC_DIR}      ${LIBPQ_13_SRC_DIR}

# Catch a lib vs lib64 mismatch immediately instead of at the assertion stage.
RUN set -eux; \
    test -f "${OPENSSL_102_LIB_DIR}/libssl.so"     || { echo "FATAL: no libssl.so in ${OPENSSL_102_LIB_DIR}" >&2; exit 1; }; \
    test -f "${ICU_67_LIB_DIR}/libicuuc.so"        || { echo "FATAL: no libicuuc.so in ${ICU_67_LIB_DIR}" >&2; exit 1; }; \
    test -f "${CURL_817_102_LIB_DIR}/libcurl.so"   || { echo "FATAL: no libcurl.so in ${CURL_817_102_LIB_DIR}" >&2; exit 1; }; \
    test -f "${LIBPQ_13_102_LIB_DIR}/libpq.so"     || { echo "FATAL: no libpq.so in ${LIBPQ_13_102_LIB_DIR}" >&2; exit 1; }


ENV PATH="${PHP_BIN_DIR}:${PHP_DIR}/sbin:${PATH}"

# Move sources out of the runtime prefix and expose php/php-fpm
# through update-alternatives (5.3 has no php-cgi next to php-fpm).
RUN set -eux; \
    mkdir -p /usr/local/src/php; \
    mv ${PHP_SRC_DIR} /usr/local/src/php/${PHP_VERSION}; \
    ln -sfv /usr/local/src/php/${PHP_VERSION} ${PHP_SRC_DIR}; \
    rm -rf /tmp/*; \
    update-alternatives --install /usr/bin/php        php        ${PHP_BIN_DIR}/php        1; \
    update-alternatives --install /usr/bin/php-config php-config ${PHP_BIN_DIR}/php-config 1; \
    update-alternatives --install /usr/bin/phpize     phpize     ${PHP_BIN_DIR}/phpize     1; \
    update-alternatives --install /usr/bin/pear       pear       ${PHP_BIN_DIR}/pear       1; \
    update-alternatives --install /usr/bin/pecl       pecl       ${PHP_BIN_DIR}/pecl       1; \
    update-alternatives --install /usr/sbin/php-fpm   php-fpm    ${PHP_DIR}/sbin/php-fpm   1

##################################################################
#           Debian-compatible layout (symlinks only)
##################################################################
# Vanilla PHP has ONE ini scan dir; Debian has per-SAPI conf.d + mods-available.
# We keep a single REAL conf.d and point every Debian path at it, so existing
# configs and scripts that expect /etc/php/<ver>/... keep working.
#
# Deliberate difference from Debian: extensions are enabled for ALL SAPIs at
# once. If a per-SAPI extension set is needed, use a separate container.
RUN set -eux; \
    extDir="$(${PHP_BIN_DIR}/php-config --extension-dir)"; \
    mkdir -p "$extDir"; \
    api="$(basename "$extDir" | sed 's/.*-//')"; \
    echo "PHP module API = ${api}"; \
    echo "${api}" > ${PHP_DIR}/.module-api; \
    \
    mkdir -p ${PHP_INI_SCAN_DIR} ${PHP_INI_DIR}/mods-available; \
    mkdir -p ${PHP_INI_DIR}/cli ${PHP_INI_DIR}/fpm ${PHP_INI_DIR}/cgi; \
    for sapi in cli fpm cgi; do \
      ln -sfn ${PHP_INI_SCAN_DIR}      ${PHP_INI_DIR}/${sapi}/conf.d; \
      ln -sfn ${PHP_INI_DIR}/php.ini   ${PHP_INI_DIR}/${sapi}/php.ini; \
    done; \
    \
    ln -sfn ${PHP_INI_DIR}/php-fpm.conf ${PHP_INI_DIR}/fpm/php-fpm.conf; \
    ln -sfn ${PHP_INI_DIR}/php-fpm.d    ${PHP_INI_DIR}/fpm/pool.d; \
    \
    mkdir -p /etc/php /usr/lib/php; \
    ln -sfn ${PHP_INI_DIR} /etc/php/${PHP_VERSION}; \
    ln -sfn "$extDir"      /usr/lib/php/${api}

##################################################################
#           Extension helper scripts
##################################################################
# php-ext-install / php-ext-configure / php-ext-enable are derived from
# docker-library/php (MIT). php-enmod / php-dismod follow Debian php-common
# conventions. See headers inside each script.
COPY usr/local/bin/php-ext-install   /usr/local/bin/
COPY usr/local/bin/php-ext-configure /usr/local/bin/
COPY usr/local/bin/php-ext-enable    /usr/local/bin/
COPY usr/local/bin/php-enmod         /usr/local/bin/
COPY usr/local/bin/php-dismod        /usr/local/bin/

# Debian-compatible aliases so existing Dockerfiles calling
# phpenmod / phpdismod keep working unchanged.
RUN set -eux; \
    chmod +x /usr/local/bin/php-ext-install \
             /usr/local/bin/php-ext-configure \
             /usr/local/bin/php-ext-enable \
             /usr/local/bin/php-enmod \
             /usr/local/bin/php-dismod; \
    ln -sfn /usr/local/bin/php-enmod  /usr/local/bin/phpenmod; \
    ln -sfn /usr/local/bin/php-dismod /usr/local/bin/phpdismod

##################################################################
#                   php-fpm configuration
##################################################################
# Container-oriented defaults: foreground, logs to stderr, workers recycled,
# stuck requests killed. Upstream defaults leave the last two off entirely.
COPY etc/php-fpm.conf       ${PHP_INI_DIR}/php-fpm.conf
COPY etc/php-fpm.d/       ${PHP_INI_DIR}/php-fpm.d/

# php-fpm.conf carries an absolute include path; patch it to this version.
# The .default files are dropped so nobody edits the wrong one later.
# `php-fpm -t` validates the whole config tree, so a typo fails the build
# instead of the container.
RUN set -eux; \
    mkdir -p /run/php /var/www/html; \
    chown www-data:www-data /var/www/html; \
    chmod 1777 /var/www/html; \
    sed -i "s|PHP_VERSION_PLACEHOLDER|${PHP_VERSION}|g" ${PHP_INI_DIR}/php-fpm.conf; \
    rm -f ${PHP_INI_DIR}/php-fpm.conf.default \
          ${PHP_INI_DIR}/php-fpm.d/www.conf.default; \
    php-fpm -t

##################################################################
#           Enable shared extensions built into this image
##################################################################
# No opcache on 5.3: Zend OPcache was bundled starting with PHP 5.5
# (--enable-opcache does not exist here).

##################################################################
#                   Perforce (p4php)
##################################################################
# Not shipped for 5.x: Perforce publishes prebuilt perforce_php<NN>.so only
# for PHP 7.0+ (r20.1 is the oldest release used in this repo); there is no
# vendor blob for PHP 5.x.

##################################################################
#                   PECL extensions
##################################################################
# ORDER MATTERS: igbinary must be built and enabled BEFORE redis, otherwise
# redis is compiled without igbinary serializer support.
#
# Versions are pinned deliberately - `pecl install <ext>` without a version
# resolves to "latest at build time", which makes builds non-reproducible.
# 5.x pins are the last release lines that still support PHP 5:
#   igbinary 2.0.x (3.x is PHP 7+), msgpack 0.5.x (2.x is PHP 7+),
#   apcu 4.0.x (5.x is PHP 7+), redis 4.3.0 (5.x is PHP 7+; there is no
#   msgpack serializer in redis before 5.0).
#
# imagick and timezonedb are NOT shipped on 5.3: every imagick release that
# supports ImageMagick 7 (3.4.0+) and every current timezonedb declare
# PHP >= 5.4; older releases would mean ImageMagick 6 or stale tz data.
#
# memcached is NOT shipped on 5.x: Debian's libmemcached (libhashkit + libsasl2)
# links the system libcrypto.so.3, which would load next to our
# libcrypto.so.1.0.0 in one process - a library duality (ADR-031), and the
# unversioned 1.0.2 symbols can interpose OpenSSL 3 callers. Reviving it needs
# a libmemcached baked against OpenSSL 1.0.2.
ENV PECL_IGBINARY_VERSION=2.0.8
ENV PECL_MSGPACK_VERSION=0.5.7
ENV PECL_APCU_VERSION=4.0.11
ENV PECL_REDIS_VERSION=4.3.0

# PEAR 1.9.5 bundled with PHP 5.3/5.4 can no longer fetch/unpack current
# pecl.php.net archives ("download failed" / "could not extract the
# package.xml file"), so on these branches the tarballs are fetched directly
# and built with phpize. `pecl` stays in the image but is not used here.
# phpize + explicit ./configure also bypasses pecl's interactive prompts.
#
# Stage 1: serializers first - other extensions detect them at configure time.
RUN set -eux; \
    export CFLAGS="${PHP_CFLAGS}"; \
    pecl_build() { \
      pkg="$1"; shift; \
      aria2c \
        --conf-path=/usr/local/share/epicmorg/aria2/config/aria2.conf \
        --user-agent="$(shuf -n 1 /usr/local/share/epicmorg/user-agents/user-agents.txt)" \
        -d /tmp -o "${pkg}.tgz" "https://pecl.php.net/get/${pkg}.tgz"; \
      tar -C /tmp -xzf "/tmp/${pkg}.tgz"; \
      cd "/tmp/${pkg}"; \
      phpize; \
      ./configure --enable-option-checking=fatal "$@"; \
      make -j"$(nproc)"; \
      make install; \
      cd /tmp; \
      rm -rf "/tmp/${pkg}" "/tmp/${pkg}.tgz" /tmp/package*.xml; \
    }; \
    pecl_build igbinary-${PECL_IGBINARY_VERSION}; \
    php-ext-enable --priority 15 igbinary; \
    pecl_build msgpack-${PECL_MSGPACK_VERSION}; \
    php-ext-enable --priority 15 msgpack; \
    php -m | grep -q '^igbinary$'; \
    php -m | grep -q '^msgpack$'

# Stage 2: extensions that may link against the serializers above.
RUN set -eux; \
    export CFLAGS="${PHP_CFLAGS}"; \
    pecl_build() { \
      pkg="$1"; shift; \
      aria2c \
        --conf-path=/usr/local/share/epicmorg/aria2/config/aria2.conf \
        --user-agent="$(shuf -n 1 /usr/local/share/epicmorg/user-agents/user-agents.txt)" \
        -d /tmp -o "${pkg}.tgz" "https://pecl.php.net/get/${pkg}.tgz"; \
      tar -C /tmp -xzf "/tmp/${pkg}.tgz"; \
      cd "/tmp/${pkg}"; \
      phpize; \
      ./configure --enable-option-checking=fatal "$@"; \
      make -j"$(nproc)"; \
      make install; \
      cd /tmp; \
      rm -rf "/tmp/${pkg}" "/tmp/${pkg}.tgz" /tmp/package*.xml; \
    }; \
    pecl_build apcu-${PECL_APCU_VERSION}; \
    php-ext-enable apcu; \
    pecl_build redis-${PECL_REDIS_VERSION} --enable-redis-igbinary; \
    php-ext-enable redis

# Assert the serializers actually got compiled in, not just loaded.
RUN set -eu; \
    echo "--- PECL serializer support ---"; \
    php --ri redis     | grep -i 'serializers'; \
    php --ri redis     | grep -qi 'igbinary' || { echo "FATAL: redis built without igbinary" >&2; exit 1; }; \
    echo "OK: igbinary support present in redis"

##################################################################
#                   Composer
##################################################################
# Installed via the official installer WITH signature verification.
# Never pipe the installer straight into php - that is a blind
# remote-code-execution by design.
# On PHP < 7.2.5 the installer itself picks the 2.2 LTS line, the last one
# that runs on PHP 5.3.2+.
ENV COMPOSER_HOME=/composer
ENV COMPOSER_ALLOW_SUPERUSER=1
ENV PATH="${COMPOSER_HOME}/vendor/bin:${PATH}"

RUN set -eux; \
    mkdir -p ${COMPOSER_HOME}; \
    cd /tmp; \
    php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"; \
    expected="$(php -r "copy('https://composer.github.io/installer.sig', 'php://stdout');")"; \
    actual="$(php -r "echo hash_file('sha384', 'composer-setup.php');")"; \
    [ "$expected" = "$actual" ] || { echo "FATAL: composer installer signature mismatch" >&2; exit 1; }; \
    php composer-setup.php --install-dir=/usr/local/bin --filename=composer; \
    rm -f /tmp/composer-setup.php; \
    composer --version

##################################################################
#                   PIE (PHP Installer for Extensions)
##################################################################
# Successor to PECL. Installed for forward compatibility - PECL is still the
# primary mechanism here, because PIE requires PHP 8.1+ and does not cover
# extensions that have not published a php-ext composer.json yet.
# Skipped on branches below 8.1, so this block stays identical across versions.
ENV PIE_VERSION=1.4.9
ARG PIE_URL=https://github.com/php/pie/releases/download/${PIE_VERSION}/pie.phar
ARG PIE_SHA256=19a31ddd4bfd08b9eb5eaad2e5f63e76e7919cae7683852da41c80da704ad6c0

RUN set -eux; \
    if php -r 'exit(PHP_VERSION_ID >= 80100 ? 0 : 1);'; then \
      aria2c \
        --conf-path=/usr/local/share/epicmorg/aria2/config/aria2.conf \
        --user-agent="$(shuf -n 1 /usr/local/share/epicmorg/user-agents/user-agents.txt)" \
        -d /tmp -o pie.phar "${PIE_URL}"; \
      echo "${PIE_SHA256}  /tmp/pie.phar" | sha256sum -c -; \
      mv /tmp/pie.phar /usr/local/bin/pie; \
      chmod +x /usr/local/bin/pie; \
      pie --version; \
    else \
      echo "skip: PIE requires PHP 8.1+, this is $(php -r 'echo PHP_VERSION;')"; \
    fi

##################################################################
#                   ionCube loader
##################################################################
# The upstream archive ships loaders for PHP 4.1 .. 8.5.
# NTS build -> use the plain .so, NOT the _ts.so (thread-safe / ZTS) variant.
# Priority 05: ionCube must be loaded before OPcache (priority 10).

ARG IONCUBE_URL=https://downloads.ioncube.com/loader_downloads/ioncube_loaders_lin_x86-64.tar.gz

RUN set -eux; \
    extDir="$(php-config --extension-dir)"; \
    aria2c \
        --conf-path=/usr/local/share/epicmorg/aria2/config/aria2.conf \
        --user-agent="$(shuf -n 1 /usr/local/share/epicmorg/user-agents/user-agents.txt)" \
        -d /tmp -o ioncube.tar.gz "${IONCUBE_URL}"; \
    tar -C /tmp -xzf /tmp/ioncube.tar.gz; \
    src="/tmp/ioncube/ioncube_loader_lin_${PHP_VERSION}.so"; \
    [ -f "$src" ] || { echo "FATAL: no ionCube loader for PHP ${PHP_VERSION}" >&2; ls /tmp/ioncube/ >&2; exit 1; }; \
    cp "$src" "${extDir}/ioncube_loader.so"; \
    php-ext-enable --zend --priority 05 ioncube_loader; \
    rm -rf /tmp/ioncube /tmp/ioncube.tar.gz; \
    php -v | grep -qi 'ionCube' || { echo "FATAL: ionCube loader not active" >&2; php -v >&2; exit 1; }

##################################################################
#                   phpBolt loader
##################################################################
# Not shipped for 5.x: phpBolt loaders exist for PHP 7.0+ only (the oldest
# blob in this repo is php70).

##################################################################
#                  Final assertions
##################################################################
# Assert the shipped interpreter actually uses OUR OpenSSL and ICU, not the
# system ones. Each check catches a different failure:
#   1. header version  - OPENSSL_VERSION_NUMBER   (which headers were used)
#   2. library version - "OpenSSL Library Version" (which lib is loaded at runtime)
#   3. linkage         - ldd of the php binary     (resolved from our prefix)
#   4. ICU version     - ext/intl reports the ICU it was built against
#   5. php, php-fpm and every .so in the extension dir: no
#      'not found', and ONE libssl / libcrypto / libxml2 SONAME across all of
#      them - a second SONAME is a library duality inside one process (ADR-031).
# Checks 1 and 2 disagreeing means ABI drift: compiled against system headers,
# linked to ours.
RUN set -eu; \
    php="${PHP_BIN_DIR}/php"; \
    echo "============================================="; \
    "$php" --version; \
    php-fpm --version; \
    echo "============================================="; \
    echo "--- Checking OpenSSL headers/library (Final) ---"; \
    hdr="$("$php" -r 'echo dechex(OPENSSL_VERSION_NUMBER);')"; \
    echo "compile-time OPENSSL_VERSION_NUMBER = 0x${hdr}"; \
    case "0x${hdr}" in \
      ${PHP_SSL_HDR_MASK}*) ;; \
      *) echo "FATAL: built against wrong OpenSSL headers: 0x${hdr} (expected ${PHP_SSL_HDR_MASK}*)" >&2; exit 1 ;; \
    esac; \
    lib="$("$php" -i | sed -n 's/^OpenSSL Library Version => //p')"; \
    echo "runtime OpenSSL Library Version = ${lib}"; \
    case "${lib}" in \
      "OpenSSL ${PHP_SSL_VERSION}"*) ;; \
      *) echo "FATAL: expected OpenSSL ${PHP_SSL_VERSION}, got '${lib}'" >&2; exit 1 ;; \
    esac; \
    echo "--- Checking OpenSSL linkage (Final) ---"; \
    if ldd "$php" | grep -q 'not found'; then \
      echo "FATAL: php has unresolved deps" >&2; ldd "$php" >&2; exit 1; \
    fi; \
    if ! ldd "$php" | grep -q "${PHP_SSL_LIB_DIR}/libssl"; then \
      echo "FATAL: php not linked against ${PHP_SSL_LIB_DIR}" >&2; ldd "$php" >&2; exit 1; \
    fi; \
    echo "OK: OpenSSL ${PHP_SSL_VERSION} from ${PHP_SSL_LIB_DIR}"; \
    if [ "$(ldd "$php" | grep -c 'libssl')" != "1" ]; then \
       echo "FATAL: more than one libssl in this binary" >&2; \
       ldd "$php" | grep -i ssl >&2; exit 1; \
    fi; \
    echo "--- Checking ICU (Final) ---"; \
    icu="$("$php" -i | sed -n 's/^ICU version => //p')"; \
    echo "ICU version = ${icu}"; \
    case "${icu}" in \
      ${ICU_67_VERSION}*) ;; \
      *) echo "FATAL: expected ICU ${ICU_67_VERSION}, got '${icu}'" >&2; exit 1 ;; \
    esac; \
    echo "--- Checking curl (Final) ---"; \
    cv="$("$php" -r '$v = curl_version(); echo $v["ssl_version"];')"; \
    echo "curl ssl_version = ${cv}"; \
    case "${cv}" in \
      "OpenSSL/${PHP_SSL_VERSION}"*) ;; \
      *) echo "FATAL: curl uses ${cv}, expected OpenSSL/${PHP_SSL_VERSION}" >&2; exit 1 ;; \
    esac; \
    echo "--- Checking binaries + extension dir (Final) ---"; \
    extDir="$(php-config --extension-dir)"; \
    bins="$php ${PHP_DIR}/sbin/php-fpm $(ls "${extDir}"/*.so)"; \
    for bin in $bins; do \
      if ldd "$bin" | grep -q 'not found'; then \
        echo "FATAL: ${bin} has unresolved deps" >&2; ldd "$bin" >&2; exit 1; \
      fi; \
    done; \
    for l in libssl libcrypto libxml2; do \
      n="$(for bin in $bins; do ldd "$bin" | awk '{print $1}' | grep "^${l}\.so" || true; done | sort -u | wc -l)"; \
      if [ "$n" -gt 1 ]; then \
        echo "FATAL: ${n} different ${l} SONAMEs across php + extensions:" >&2; \
        for bin in $bins; do ldd "$bin" | grep "${l}\.so" | sed "s|^|$(basename "$bin"): |" >&2 || true; done; \
        exit 1; \
      fi; \
    done; \
    echo "OK: no unresolved deps, one libssl/libcrypto/libxml2 across php, php-fpm and $(ls "${extDir}"/*.so | wc -l) extensions"; \
    echo "--- Checking RPATH (Final) ---"; \
    for f in "$php" "${PHP_BIN_DIR}/php-cgi" "${PHP_BIN_DIR}/phpdbg" "${PHP_DIR}/sbin/php-fpm" \
             "${PHP_DIR}"/lib/libphp*.so "$(php-config --extension-dir)/opcache.so"; do \
      [ -e "$f" ] || continue; \
      readelf -d "$f" | grep -q '(RUNPATH)' && { echo "FATAL: $f has RUNPATH, expected RPATH" >&2; exit 1; }; \
      readelf -d "$f" | grep -q '(RPATH)' || { echo "FATAL: $f has no RPATH" >&2; readelf -d "$f" >&2; exit 1; }; \
      echo "RPATH ok: $f"; \
    done; \
    echo "--- Loaded modules ---"; \
    "$php" -m; \
    echo "extension_dir = ${extDir}"; \
    echo "============================================="

WORKDIR ${PHP_DIR}
