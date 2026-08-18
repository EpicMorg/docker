# check=skip=UndefinedVar
##################################################################
##################################################################
#                          Builder
##################################################################
##################################################################
FROM docker.io/epicmorg/gcc:14 AS builder

# /etc/ld.so.conf.d/
ARG LD_CONF_DIR=/etc/ld.so.conf.d/

ENV PHP_VERSION=8.2
ENV PHP_FULL_VERSION=${PHP_VERSION}.33
ENV PHP_DIR=${EMG_LOCAL_BASE_DIR}/php/${PHP_VERSION}
ENV PHP_INI_DIR=${PHP_DIR}/etc
ENV PHP_INI_SCAN_DIR=${PHP_DIR}/etc/conf.d
ARG PHP_BIN_DIR=${PHP_DIR}/bin
ARG PHP_SRC_DIR=${PHP_DIR}/src
ARG PHP_DOWNLOAD_URL=https://www.php.net/distributions/php-${PHP_FULL_VERSION}.tar.xz
ARG PHP_TEMP=/tmp/php-${PHP_FULL_VERSION}.tar.xz
# Upstream sha256 for php-8.2.33.tar.xz - bump together with PHP_FULL_VERSION.
ARG PHP_SHA256=fbdeace9b38220436a4c8fd79b900df92878151db145e641750743a283b514c1

ENV SSL_CERT_DIR=/etc/ssl/certs

##################################################################
#                    Prepare PHP build
##################################################################

# Simple check if ENVs inherited from epicmorg/gcc are alive.
RUN : "${OPENSSL_35_DIR:?empty - check epicmorg/gcc ENV}" \
      "${OPENSSL_35_LIB_DIR:?empty}" "${OPENSSL_35_INC_DIR:?empty}"

# Pin all php* packages to priority -1 so apt never pulls distro PHP.
COPY etc/apt/preferences.d /etc/apt/preferences.d

# Headers required by PHP's ./configure: without these the corresponding
# bundled extensions silently fail to configure (or are skipped entirely).
# NOTE: libcurl4-openssl-dev / libpq-dev depend on libssl-dev - that is why the
# system-OpenSSL-headers hiding below MUST happen after this step.
RUN apt-get update && apt-get install -y --no-install-recommends \
    autoconf \
    bison \
    dpkg-dev \
    file \
    g++ \
    gcc \
    gettext \
    libargon2-dev \
    libbz2-dev \
    libc-dev \
    libfreetype6-dev \
    libgdbm-dev \
    libgmp-dev \
    libicu-dev \
    libjpeg-dev \
    libonig-dev \
    libpng-dev \
    libreadline-dev \
    libsodium-dev \
    libsqlite3-dev \
    libtidy-dev \
    libwebp-dev \
    libxml2-dev \
    libxpm-dev \
    libxslt1-dev \
    libzip-dev \
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
    mv /usr/lib/x86_64-linux-gnu/pkgconfig/openssl.pc /usr/lib/x86_64-linux-gnu/pkgconfig/openssl.pc.disabled 2>/dev/null || true

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
    tar -xJf ${PHP_TEMP} --strip-components=1 --directory ${PHP_SRC_DIR}; \
    rm -rfv ${PHP_TEMP}

ENV PATH="${PHP_BIN_DIR}:${PATH}"

WORKDIR ${PHP_SRC_DIR}

##################################################################
#                    Build flags
##################################################################
# Same hardening/optimization set the official docker-library/php images use.
# https://github.com/docker-library/php/issues/272
ENV PHP_CFLAGS="-fstack-protector-strong -fpic -fpie -O2 -D_LARGEFILE_SOURCE -D_FILE_OFFSET_BITS=64"
ENV PHP_CPPFLAGS="${PHP_CFLAGS}"
ENV PHP_LDFLAGS="-Wl,-O1 -pie"

##################################################################
#                    configure + make
##################################################################
# PHP 7.4+ locates OpenSSL through pkg-config, NOT --with-openssl=DIR.
# Therefore PKG_CONFIG_PATH is what actually pins our baked OpenSSL.
RUN set -eux; \
    export CC="${GCC_INSTALL_DIR}/bin/gcc"; \
    export CXX="${GCC_INSTALL_DIR}/bin/g++"; \
    debMultiarch="$(dpkg-architecture --query DEB_BUILD_MULTIARCH)"; \
    export PKG_CONFIG_PATH="${OPENSSL_35_LIB_DIR}/pkgconfig:${CURL_821_35_LIB_DIR}/pkgconfig:${LIBPQ_16_35_LIB_DIR}/pkgconfig:${PKG_CONFIG_PATH:-}"; \
    export CFLAGS="${PHP_CFLAGS}"; \
    export CPPFLAGS="-I${OPENSSL_35_INC_DIR} -I${CURL_817_111_INC_DIR} ${PHP_CPPFLAGS}"; \
    export LDFLAGS="-L${OPENSSL_35_LIB_DIR} -L${CURL_821_35_LIB_DIR} -L${LIBPQ_16_35_LIB_DIR} -Wl,-rpath,${OPENSSL_35_LIB_DIR} -Wl,-rpath,${CURL_821_35_LIB_DIR} -Wl,-rpath,${LIBPQ_16_35_LIB_DIR} -Wl,-rpath,${PHP_DIR}/lib ${PHP_LDFLAGS}"; \
    ./configure \
      --prefix=${PHP_DIR} \
      --sysconfdir=${PHP_INI_DIR} \
      --with-config-file-path=${PHP_INI_DIR} \
      --with-config-file-scan-dir=${PHP_INI_SCAN_DIR} \
      --with-libdir="lib/${debMultiarch}" \
      \
      --enable-option-checking=fatal \
      --with-pic \
      --with-mhash \
      \
      `# ---- SAPI ----` \
      --enable-fpm \
      --with-fpm-user=www-data \
      --with-fpm-group=www-data \
      --enable-cgi \
      --enable-phpdbg \
      --enable-phpdbg-readline \
      --enable-embed \
      \
      `# ---- core / crypto ----` \
      --with-openssl \
      --with-password-argon2 \
      --with-sodium \
      --with-zlib \
      --with-bz2 \
      --with-curl=${CURL_821_35_DIR} \
      --with-iconv \
      --with-readline \
      --enable-mbstring \
      \
      `# ---- database ----` \
      --enable-mysqlnd \
      --with-mysqli=mysqlnd \
      --with-pdo-mysql=mysqlnd \
      --with-pgsql=${LIBPQ_16_35_DIR} \
      --with-pdo-pgsql=${LIBPQ_16_35_DIR} \
      --with-sqlite3 \
      --with-pdo-sqlite \
      --enable-dba \
      --with-gdbm \
      \
      `# ---- text / xml ----` \
      --enable-intl \
      --with-xsl \
      --with-tidy \
      --with-gettext \
      \
      `# ---- graphics ----` \
      --enable-gd \
      --with-jpeg \
      --with-webp \
      --with-freetype \
      --with-xpm \
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
      --enable-opcache \
      --with-ffi \
      --with-gmp \
      --with-zip \
      \
      `# ---- pear/pecl ----` \
      --with-pear \
    ; \
    make -j"$(nproc)"; \
    find -type f -name '*.a' -delete; \
    make install; \
    make clean

##################################################################
#                    Default ini + scan dir
##################################################################
RUN set -eux; \
    mkdir -p ${PHP_INI_SCAN_DIR}; \
    cp ${PHP_SRC_DIR}/php.ini-production ${PHP_INI_DIR}/php.ini; \
    cp ${PHP_INI_DIR}/php-fpm.conf.default ${PHP_INI_DIR}/php-fpm.conf; \
    cp ${PHP_INI_DIR}/php-fpm.d/www.conf.default ${PHP_INI_DIR}/php-fpm.d/www.conf

##################################################################
#                    OpenSSL assertions (builder)
##################################################################
# Version-agnostic aliases: keep the assertion block below byte-identical
# across all PHP versions - only these three lines change.
ARG PHP_SSL_DIR=${OPENSSL_35_DIR}
ARG PHP_SSL_LIB_DIR=${OPENSSL_35_LIB_DIR}
ARG PHP_SSL_VERSION=3.5

# Expected compile-time OpenSSL version prefix (OPENSSL_VERSION_NUMBER, format 0xMNNFFPPS).
# Masks: 1.0.x -> 0x1000 | 1.1.x -> 0x1010 | 3.x -> 0x30 | 4.x -> 0x40
ARG PHP_SSL_HDR_MASK=0x30

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
    if ! ldd "$php" | grep -q "${PHP_SSL_LIB_DIR}/lib"; then \
      echo "FATAL: php not linked against ${PHP_SSL_LIB_DIR}" >&2; ldd "$php" >&2; exit 1; \
    fi; \
    echo "OK (builder): OpenSSL ${PHP_SSL_VERSION} from ${PHP_SSL_LIB_DIR}"; \
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

# Build toolchain + headers for the FINAL image: PECL extensions and pip-style
# on-demand builds compile C sources at install time (imagick, redis, ...).
# Not used to build PHP itself - that happens in the builder stage.
RUN apt-get update && apt-get install -y --no-install-recommends \
    autoconf \
    bison \
    dpkg-dev \
    file \
    g++ \
    gcc \
    gettext \
    libmagickwand-dev \
    libmemcached-dev \
    libargon2-dev \
    libbz2-dev \
    libc-dev \
    libfreetype6-dev \
    libgdbm-dev \
    libgmp-dev \
    libicu-dev \
    libjpeg-dev \
    libonig-dev \
    libpng-dev \
    libreadline-dev \
    libsodium-dev \
    libsqlite3-dev \
    libtidy-dev \
    libwebp-dev \
    libxml2-dev \
    libxpm-dev \
    libxslt1-dev \
    libzip-dev \
    make \
    pkg-config \
    re2c \
    xz-utils \
    zlib1g-dev \
    && apt-get autoremove -y \
    && rm -rf /var/lib/apt/lists/*

##################################################################
#           curl 8.21
##################################################################
ENV CURL_821_VERSION=8.21.0
ENV CURL_821_35_DIR=${EMG_LOCAL_BASE_DIR}/curl/${CURL_821_VERSION}/openssl35
ENV CURL_821_35_BIN_DIR=${CURL_821_35_DIR}/bin
ENV CURL_821_35_INC_DIR=${CURL_821_35_DIR}/include
ENV CURL_821_35_LIB_DIR=${CURL_821_35_DIR}/lib
ENV CURL_821_SRC_DIR=/usr/local/src/curl/${CURL_821_VERSION}


##################################################################
#           libpq 16 + OpenSSL 3.5.x
##################################################################
ENV LIBPQ_16_VERSION=16
ENV LIBPQ_16_35_DIR=${EMG_LOCAL_BASE_DIR}/libpq/${LIBPQ_16_VERSION}/openssl35
ENV LIBPQ_16_35_INC_DIR=${LIBPQ_16_35_DIR}/include
ENV LIBPQ_16_35_LIB_DIR=${LIBPQ_16_35_DIR}/lib
ENV LIBPQ_16_35_BIN_DIR=${LIBPQ_16_35_DIR}/bin

##################################################################
#                  OpenSSL 3.5
##################################################################
ENV OPENSSL_35_MIN_VERSION=3.5
ENV OPENSSL_35_VERSION=${OPENSSL_35_MIN_VERSION}.7
ENV OPENSSL_35_DIR=${EMG_LOCAL_BASE_DIR}/openssl/${OPENSSL_35_MIN_VERSION}
ENV OPENSSL_35_BIN_DIR=${OPENSSL_35_DIR}/bin
ENV OPENSSL_35_INC_DIR=${OPENSSL_35_DIR}/include
ENV OPENSSL_35_LIB_DIR=${OPENSSL_35_DIR}/lib64
ENV OPENSSL_35_SRC_DIR=/usr/local/src/openssl/${OPENSSL_35_MIN_VERSION}
ENV SSL_CERT_DIR=/etc/ssl/certs

##################################################################
#                  PHP 8.2
##################################################################
ENV PHP_VERSION=8.2
ENV PHP_FULL_VERSION=${PHP_VERSION}.33
ENV PHP_DIR=${EMG_LOCAL_BASE_DIR}/php/${PHP_VERSION}
ENV PHP_INI_DIR=${PHP_DIR}/etc
ENV PHP_INI_SCAN_DIR=${PHP_DIR}/etc/conf.d
ARG PHP_BIN_DIR=${PHP_DIR}/bin
ARG PHP_SRC_DIR=${PHP_DIR}/src

# Expected compile-time OpenSSL version prefix (OPENSSL_VERSION_NUMBER, format 0xMNNFFPPS).
# Masks: 1.0.x -> 0x1000 | 1.1.x -> 0x1010 | 3.x -> 0x30 | 4.x -> 0x40
ENV PHP_SSL_HDR_MASK=0x30

# Needed by PECL builds so extensions link against OUR OpenSSL, not the system one.
ENV PHP_SSL_DIR=${OPENSSL_35_DIR}
ENV PHP_SSL_LIB_DIR=${OPENSSL_35_LIB_DIR}
ENV PHP_SSL_VERSION=${OPENSSL_35_VERSION}
ENV PKG_CONFIG_PATH=${PHP_SSL_LIB_DIR}/pkgconfig:${PKG_CONFIG_PATH}
ENV PHP_CFLAGS="-fstack-protector-strong -fpic -fpie -O2 -D_LARGEFILE_SOURCE -D_FILE_OFFSET_BITS=64"
ENV PHP_CPPFLAGS="-I${PHP_SSL_DIR}/include ${PHP_CFLAGS}"
ENV PHP_LDFLAGS="-L${PHP_SSL_LIB_DIR} -Wl,-rpath,${PHP_SSL_LIB_DIR} -Wl,-O1 -pie"

COPY --from=builder ${PHP_DIR} ${PHP_DIR}
COPY --from=builder ${OPENSSL_35_DIR} ${OPENSSL_35_DIR}
COPY --from=builder ${OPENSSL_35_SRC_DIR} ${OPENSSL_35_SRC_DIR}
COPY --from=builder ${CURL_821_35_DIR}       ${CURL_821_35_DIR}
COPY --from=builder ${CURL_821_SRC_DIR}      ${CURL_821_SRC_DIR}
COPY --from=builder ${LIBPQ_16_35_DIR}       ${LIBPQ_16_35_DIR}
COPY --from=builder ${LIBPQ_16_SRC_DIR}      ${LIBPQ_16_SRC_DIR}

ENV PATH="${PHP_BIN_DIR}:${PHP_DIR}/sbin:${PATH}"

# Move sources out of the runtime prefix and expose php/php-fpm/php-cgi
# through update-alternatives.
RUN set -eux; \
    mkdir -p /usr/local/src/php; \
    mv ${PHP_SRC_DIR} /usr/local/src/php/${PHP_VERSION}; \
    ln -sfv /usr/local/src/php/${PHP_VERSION} ${PHP_SRC_DIR}; \
    rm -rf /tmp/*; \
    update-alternatives --install /usr/bin/php        php        ${PHP_BIN_DIR}/php        1; \
    update-alternatives --install /usr/bin/php-cgi    php-cgi    ${PHP_BIN_DIR}/php-cgi    1; \
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

RUN set -eux; \
    chmod +x /usr/local/bin/php-ext-install \
             /usr/local/bin/php-ext-configure \
             /usr/local/bin/php-ext-enable \
             /usr/local/bin/php-enmod \
             /usr/local/bin/php-dismod; \
    # Debian-compatible aliases so existing Dockerfiles calling
    # phpenmod / phpdismod keep working unchanged.
    ln -sfn /usr/local/bin/php-enmod  /usr/local/bin/phpenmod; \
    ln -sfn /usr/local/bin/php-dismod /usr/local/bin/phpdismod

##################################################################
#                   php-fpm configuration
##################################################################
# Container-oriented defaults: foreground, logs to stderr, workers recycled,
# stuck requests killed. Upstream defaults leave the last two off entirely.
COPY etc/php-fpm.conf     ${PHP_INI_DIR}/php-fpm.conf
COPY etc/php-fpm.d/www.conf ${PHP_INI_DIR}/php-fpm.d/www.conf

RUN set -eux; \
    mkdir -p /run/php /var/www/html; \
    chown www-data:www-data /var/www/html; \
    chmod 1777 /var/www/html; \
    \
    # php-fpm.conf carries an absolute include path; patch it to this version.
    sed -i "s|PHP_VERSION_PLACEHOLDER|${PHP_VERSION}|g" ${PHP_INI_DIR}/php-fpm.conf; \
    \
    # Drop the .default files so nobody edits the wrong one later.
    rm -f ${PHP_INI_DIR}/php-fpm.conf.default \
          ${PHP_INI_DIR}/php-fpm.d/www.conf.default; \
    \
    # -t validates the whole config tree and exits non-zero on any error,
    # so a typo in these files fails the build instead of the container.
    php-fpm -t

##################################################################
#           Enable shared extensions built into this image
##################################################################
# opcache is built as a shared zend_extension by --enable-opcache and needs
# an ini to actually load. Without this, "php -v" shows no Zend OPcache.
RUN set -eux; \
    php-ext-enable opcache; \
    php -v | grep -q 'Zend OPcache' || { echo "FATAL: opcache not loaded" >&2; exit 1; }

RUN php-dismod xdebug

##################################################################
#                   Perforce (p4php)
##################################################################
# Vendor-prebuilt extension - Perforce ships ready .so files, no build needed.
# The "-ssl3" variant is linked against OpenSSL 3.x; the plain one against 1.1.1.
# Must match the OpenSSL branch this PHP was built with, otherwise two
# different OpenSSL libraries end up in one process.
# ~79 MB: the whole p4api C++ SDK is statically linked in. Do NOT strip it.
ENV P4PHP_RELEASE=r26.1
ARG P4PHP_SO=perforce_php82-ssl3.so
ARG P4PHP_URL=https://ftp.perforce.com/perforce/${P4PHP_RELEASE}/bin.linux26x86_64/${P4PHP_SO}

RUN set -eux; \
    extDir="$(php-config --extension-dir)"; \
    aria2c \
        --conf-path=/usr/local/share/epicmorg/aria2/config/aria2.conf \
        --user-agent="$(shuf -n 1 /usr/local/share/epicmorg/user-agents/user-agents.txt)" \
        -d /tmp -o perforce.so "${P4PHP_URL}"; \
    mv /tmp/perforce.so "${extDir}/perforce.so"; \
    php-ext-enable perforce; \
    php -m | grep -qi '^perforce$' || { echo "FATAL: perforce ext not active" >&2; php -m >&2; exit 1; }; \
    ldd "${extDir}/perforce.so" | grep -i ssl || echo "statically linked (no external ssl)" \
    php --ri perforce \
    php -r 'if (!class_exists("P4")) { fwrite(STDERR, "FATAL: P4 class missing\n"); exit(1); } $p4 = new P4(); echo get_class($p4), PHP_EOL;'

##################################################################
#                   PECL extensions
##################################################################
# ORDER MATTERS: igbinary must be built and enabled BEFORE redis and
# memcached, otherwise they are compiled without igbinary serializer support.
# Production check: `memcached.serializer => igbinary` in php -i.
#
# Versions are pinned deliberately - `pecl install <ext>` without a version
# resolves to "latest at build time", which makes builds non-reproducible.
ENV PECL_IGBINARY_VERSION=3.2.16
ENV PECL_MSGPACK_VERSION=3.0.1
ENV PECL_APCU_VERSION=5.1.28
ENV PECL_REDIS_VERSION=6.3.0
ENV PECL_MEMCACHED_VERSION=3.4.0
ENV PECL_IMAGICK_VERSION=3.8.1
ENV PECL_TIMEZONEDB_VERSION=2026.3

# Stage 1: serializers first - other extensions detect them at configure time.
RUN set -eux; \
    pecl channel-update pecl.php.net; \
    pecl install igbinary-${PECL_IGBINARY_VERSION}; \
    php-ext-enable --priority 15 igbinary; \
    pecl install msgpack-${PECL_MSGPACK_VERSION}; \
    php-ext-enable --priority 15 msgpack; \
    php -m | grep -q '^igbinary$'; \
    php -m | grep -q '^msgpack$'

# Stage 2: extensions that may link against the serializers above.
# Built via `pecl download` + explicit ./configure instead of `pecl install`,
# because pecl's interactive prompts change order between releases and
# silently produce wrong flags (e.g. --with-libmemcached-dir=no).
RUN set -eux; \
    cd /tmp; \
    \
    pecl install apcu-${PECL_APCU_VERSION}; \
    php-ext-enable apcu; \
    \
    pecl download redis-${PECL_REDIS_VERSION}; \
    tar -xzf redis-${PECL_REDIS_VERSION}.tgz; \
    cd redis-${PECL_REDIS_VERSION}; \
    phpize; \
    ./configure \
      --enable-redis-igbinary \
      --enable-redis-msgpack \
      --disable-redis-lzf \
      --disable-redis-zstd \
      --disable-redis-lz4; \
    make -j"$(nproc)"; \
    make install; \
    cd /tmp; \
    php-ext-enable redis; \
    \
    pecl download memcached-${PECL_MEMCACHED_VERSION}; \
    tar -xzf memcached-${PECL_MEMCACHED_VERSION}.tgz; \
    cd memcached-${PECL_MEMCACHED_VERSION}; \
    phpize; \
    ./configure \
      --with-libmemcached-dir=/usr \
      --with-zlib-dir=/usr \
      --enable-memcached-igbinary \
      --enable-memcached-msgpack \
      --enable-memcached-json \
      --enable-memcached-session \
      --enable-memcached-sasl \
      --disable-memcached-protocol; \
    make -j"$(nproc)"; \
    make install; \
    cd /tmp; \
    php-ext-enable memcached; \
    \
    pecl install imagick-${PECL_IMAGICK_VERSION}; \
    php-ext-enable imagick; \
    \
    pecl install timezonedb-${PECL_TIMEZONEDB_VERSION}; \
    php-ext-enable --priority 30 timezonedb; \
    \
    rm -rf /tmp/redis-* /tmp/memcached-* /tmp/pear

# Assert the serializers actually got compiled in, not just loaded.
RUN set -eu; \
    echo "--- PECL serializer support ---"; \
    php --ri redis     | grep -i 'serializers'; \
    php --ri memcached | grep -i 'igbinary'   || { echo "FATAL: memcached built without igbinary" >&2; exit 1; }; \
    php --ri redis     | grep -qi 'igbinary'  || { echo "FATAL: redis built without igbinary" >&2; exit 1; }; \
    echo "OK: igbinary support present in redis and memcached"

##################################################################
#                   Composer
##################################################################
# Installed via the official installer WITH signature verification.
# Never pipe the installer straight into php - that is a blind
# remote-code-execution by design.
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
# Not installed on branches below 8.1.
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
    api="$(cat ${PHP_DIR}/.module-api)"; \
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
# Vendor blob, no source available. Kept in-repo under usr/local/lib/php/.
# Loader filenames are NOT derivable from the version (upstream naming is
# inconsistent: "linux 64 - php7.3", "linux 64-php8.2", "linux-php8.5"),
# so the path is explicit per image.
ARG PHPBOLT_SO=phpBolt-extension-1.0.11-php82.so

COPY usr/local/lib/php/${PHPBOLT_SO} /tmp/${PHPBOLT_SO}

RUN set -eux; \
    extDir="$(php-config --extension-dir)"; \
    cp /tmp/${PHPBOLT_SO} "${extDir}/bolt.so"; \
    rm -f /tmp/${PHPBOLT_SO}; \
    php-ext-enable --priority 06 bolt; \
    php -m | grep -qi 'bolt' || { echo "FATAL: phpBolt not active" >&2; php -m >&2; exit 1; }

##################################################################
#                  OpenSSL assertions (final)
##################################################################
# Assert the shipped interpreter actually uses OUR OpenSSL, not the system one.
# Three independent checks, each catches a different failure:
#   1. header version  - "OpenSSL Header Version"  (which headers were used)
#   2. library version - "OpenSSL Library Version" (which lib is loaded at runtime)
#   3. linkage         - ldd of the php binary     (resolved from our prefix, no 'not found')
# Checks 1 and 2 disagreeing means ABI drift: compiled against system headers, linked to ours.
RUN set -eu; \
    php="${PHP_BIN_DIR}/php"; \
    echo "============================================="; \
    "$php" --version; \
    php --version; \
    php-cgi --version; \
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
    echo "--- Checking curl (Final) ---"; \
    cv="$("$php" -r 'echo curl_version()["ssl_version"];')"; \
    echo "curl ssl_version = ${cv}"; \
    case "${cv}" in \
      "OpenSSL/${PHP_SSL_VERSION}"*) ;; \
      *) echo "FATAL: curl uses ${cv}, expected OpenSSL/${PHP_SSL_VERSION}" >&2; exit 1 ;; \
    esac; \
    echo "--- Loaded modules ---"; \
    "$php" -m; \
    echo "extension_dir = $(php-config --extension-dir)"; \
    echo "============================================="

WORKDIR ${PHP_DIR}
