##############################################################################
# Cassandra PHP driver (TestRail >= 7.0 refuses to start without it)
##############################################################################
# DataStax/Apache C/C++ driver built against PHP's own OpenSSL (${PHP_SSL_DIR}),
# real RPATH (-Wl,--disable-new-dtags), so no system libssl/libcrypto gets loaded.
FROM docker.io/epicmorg/apache2:php7.4 AS cassandra-builder
ARG DEBIAN_FRONTEND=noninteractive

ENV CASSANDRA_CPP_DRIVER_VERSION=2.17.1
ENV CASSANDRA_CPP_DRIVER_DIR=${EMG_LOCAL_BASE_DIR}/cassandra-cpp-driver/${CASSANDRA_CPP_DRIVER_VERSION}
ARG CASSANDRA_CPP_DRIVER_SHA256=e6ab5f5c60a916dd6c0dd9a19a883a4a1ab3d6b4e95cab925a186fecff08344e
ARG CASSANDRA_CPP_DRIVER_URL=https://github.com/apache/cassandra-cpp-driver/archive/refs/tags/${CASSANDRA_CPP_DRIVER_VERSION}.tar.gz

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
      cmake \
      libuv1-dev \
      patchelf && \
    rm -rf /var/lib/apt/lists/*

RUN set -eux; \
    mkdir -p /usr/local/src/cassandra-cpp-driver; \
    cd /usr/local/src/cassandra-cpp-driver; \
    wget --quiet --tries=15 --retry-connrefused --timeout=30 -O cpp-driver.tar.gz "${CASSANDRA_CPP_DRIVER_URL}"; \
    echo "${CASSANDRA_CPP_DRIVER_SHA256}  cpp-driver.tar.gz" | sha256sum -c -; \
    tar -xzf cpp-driver.tar.gz --strip-components=1; \
    rm -f cpp-driver.tar.gz; \
    cmake -S . -B build \
      -DCMAKE_BUILD_TYPE=Release \
      -DCMAKE_INSTALL_PREFIX="${CASSANDRA_CPP_DRIVER_DIR}" \
      -DCMAKE_INSTALL_LIBDIR=lib \
      -DCASS_BUILD_SHARED=ON \
      -DCASS_BUILD_STATIC=OFF \
      -DCASS_BUILD_TESTS=OFF \
      -DCASS_BUILD_EXAMPLES=OFF \
      -DCASS_BUILD_DOCS=OFF \
      -DCASS_USE_OPENSSL=ON \
      -DOPENSSL_ROOT_DIR="${PHP_SSL_DIR}" \
      -DCASS_USE_ZLIB=ON \
      -DCASS_USE_KERBEROS=OFF \
      -DCMAKE_BUILD_WITH_INSTALL_RPATH=ON \
      -DCMAKE_INSTALL_RPATH="${PHP_SSL_LIB_DIR};${CASSANDRA_CPP_DRIVER_DIR}/lib" \
      -DCMAKE_SHARED_LINKER_FLAGS="-Wl,--disable-new-dtags"; \
    cmake --build build -j"$(nproc)"; \
    cmake --install build; \
    readelf -d "${CASSANDRA_CPP_DRIVER_DIR}/lib/libcassandra.so" | grep -E 'RPATH|RUNPATH|NEEDED'; \
    readelf -d "${CASSANDRA_CPP_DRIVER_DIR}/lib/libcassandra.so" | grep -q '(RPATH)' || { echo "FATAL: no RPATH in ${CASSANDRA_CPP_DRIVER_DIR}/lib/libcassandra.so" >&2; exit 1; }; \
    ! readelf -d "${CASSANDRA_CPP_DRIVER_DIR}/lib/libcassandra.so" | grep -q '(RUNPATH)' || { echo "FATAL: RUNPATH in ${CASSANDRA_CPP_DRIVER_DIR}/lib/libcassandra.so" >&2; exit 1; }; \
    ! ldd "${CASSANDRA_CPP_DRIVER_DIR}/lib/libcassandra.so" | grep -q 'not found' || { echo "FATAL: ${CASSANDRA_CPP_DRIVER_DIR}/lib/libcassandra.so has unresolved deps" >&2; ldd "${CASSANDRA_CPP_DRIVER_DIR}/lib/libcassandra.so" >&2; exit 1; }; \
    test "$(ldd "${CASSANDRA_CPP_DRIVER_DIR}/lib/libcassandra.so" | grep -c 'libssl\.so')" = 1 || { echo "FATAL: not exactly one libssl behind ${CASSANDRA_CPP_DRIVER_DIR}/lib/libcassandra.so" >&2; ldd "${CASSANDRA_CPP_DRIVER_DIR}/lib/libcassandra.so" >&2; exit 1; }; \
    test "$(ldd "${CASSANDRA_CPP_DRIVER_DIR}/lib/libcassandra.so" | grep -c 'libcrypto\.so')" = 1 || { echo "FATAL: not exactly one libcrypto behind ${CASSANDRA_CPP_DRIVER_DIR}/lib/libcassandra.so" >&2; ldd "${CASSANDRA_CPP_DRIVER_DIR}/lib/libcassandra.so" >&2; exit 1; }; \
    ldd "${CASSANDRA_CPP_DRIVER_DIR}/lib/libcassandra.so" | grep -q "${PHP_SSL_LIB_DIR}/libssl" || { echo "FATAL: ${CASSANDRA_CPP_DRIVER_DIR}/lib/libcassandra.so not linked against ${PHP_SSL_LIB_DIR}" >&2; ldd "${CASSANDRA_CPP_DRIVER_DIR}/lib/libcassandra.so" >&2; exit 1; }

# PHP extension: prebuilt by Gurock from the DataStax php-driver (API 20190902, NTS).
# It has no RPATH of its own; patchelf points it at the baked C/C++ driver.
ARG CASSANDRA_PHP_SO_URL=https://raw.githubusercontent.com/gurock/CassandraDrivers/088320d8d35d11911fa5eeeceed122657451573b/Linux/7.4/cassandra.so
ARG CASSANDRA_PHP_SO_SHA256=3569361d9a20c35dbd09adb97b4f442602221884f76fd34a574330e3330d7b2c

RUN set -eux; \
    mkdir -p /tmp/cassandra; \
    wget --quiet --tries=15 --retry-connrefused --timeout=30 -O /tmp/cassandra/cassandra.so "${CASSANDRA_PHP_SO_URL}"; \
    echo "${CASSANDRA_PHP_SO_SHA256}  /tmp/cassandra/cassandra.so" | sha256sum -c -; \
    patchelf --force-rpath --set-rpath "${CASSANDRA_CPP_DRIVER_DIR}/lib:${PHP_SSL_LIB_DIR}" /tmp/cassandra/cassandra.so; \
    readelf -d "/tmp/cassandra/cassandra.so" | grep -E 'RPATH|RUNPATH|NEEDED'; \
    readelf -d "/tmp/cassandra/cassandra.so" | grep -q '(RPATH)' || { echo "FATAL: no RPATH in /tmp/cassandra/cassandra.so" >&2; exit 1; }; \
    ! readelf -d "/tmp/cassandra/cassandra.so" | grep -q '(RUNPATH)' || { echo "FATAL: RUNPATH in /tmp/cassandra/cassandra.so" >&2; exit 1; }; \
    ! ldd "/tmp/cassandra/cassandra.so" | grep -q 'not found' || { echo "FATAL: /tmp/cassandra/cassandra.so has unresolved deps" >&2; ldd "/tmp/cassandra/cassandra.so" >&2; exit 1; }; \
    test "$(ldd "/tmp/cassandra/cassandra.so" | grep -c 'libssl\.so')" = 1 || { echo "FATAL: not exactly one libssl behind /tmp/cassandra/cassandra.so" >&2; ldd "/tmp/cassandra/cassandra.so" >&2; exit 1; }; \
    test "$(ldd "/tmp/cassandra/cassandra.so" | grep -c 'libcrypto\.so')" = 1 || { echo "FATAL: not exactly one libcrypto behind /tmp/cassandra/cassandra.so" >&2; ldd "/tmp/cassandra/cassandra.so" >&2; exit 1; }; \
    ldd "/tmp/cassandra/cassandra.so" | grep -q "${PHP_SSL_LIB_DIR}/libssl" || { echo "FATAL: /tmp/cassandra/cassandra.so not linked against ${PHP_SSL_LIB_DIR}" >&2; ldd "/tmp/cassandra/cassandra.so" >&2; exit 1; }; \
    php -d extension=/tmp/cassandra/cassandra.so -m | grep -qix cassandra

FROM docker.io/epicmorg/apache2:php7.4
LABEL org.opencontainers.image.title="EpicMorg TestRail"
LABEL org.opencontainers.image.description="TestRail 7.4.1.8092 on Apache2 + PHP 7.4 (fpm) by EpicMorg"
ARG DEBIAN_FRONTEND=noninteractive

##############################################################################
# Testrail Install
##############################################################################
ENV TESTRAIL_VERSION=7.4.1.8092
ENV TESTRAIL_ION=ion72
ARG DOWNLOAD_URL=https://secure.testrail.com/downloads/testrail/testrail-${TESTRAIL_VERSION}-${TESTRAIL_ION}.zip

ENV TR_DEFAULT_TASK_EXECUTION=60

ENV TESTRAIL_RELEASE_DIR=/testrail-release

ENV TR_WWW_PATH=/var/www/testrail
ENV TR_CONFIG_DIR=${TR_WWW_PATH}/config
ENV TR_CUSTOM_DIR=${TR_WWW_PATH}/custom
ENV TR_CUSTOM_AUTH_DIR=${TR_CUSTOM_DIR}/auth

ENV TR_OPT_PATH=/opt/testrail
ENV TR_DEFAULT_LOG_DIR=${TR_OPT_PATH}/logs
ENV TR_DEFAULT_AUDIT_DIR=${TR_OPT_PATH}/audit
ENV TR_DEFAULT_REPORT_DIR=${TR_OPT_PATH}/reports
ENV TR_DEFAULT_ATTACHMENT_DIR=${TR_OPT_PATH}/attachments

ENV TR_OPTPATH="/opt/testrail/"
ENV TR_CONFIGPATH="/var/www/testrail/config/"

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

##################################################################
#                   Installing
##################################################################
# The zip stays in TESTRAIL_RELEASE_DIR: the entrypoint re-extracts it on every
# start, so a /var/www volume always carries the code of this image.
RUN set -eux; \
    mkdir -p ${TESTRAIL_RELEASE_DIR} ${TR_WWW_PATH}; \
    mkdir -p ${TR_DEFAULT_ATTACHMENT_DIR} ${TR_DEFAULT_REPORT_DIR} ${TR_DEFAULT_AUDIT_DIR} ${TR_DEFAULT_LOG_DIR}; \
    echo "[testrail] Downloading ${DOWNLOAD_URL}"; \
    wget ${WGET_ARGS} --user-agent "${WGET_USER_AGENT}" -O ${TESTRAIL_RELEASE_DIR}/testrail-${TESTRAIL_VERSION}.zip ${DOWNLOAD_URL}; \
    unzip -tq ${TESTRAIL_RELEASE_DIR}/testrail-${TESTRAIL_VERSION}.zip; \
    unzip -q -o ${TESTRAIL_RELEASE_DIR}/testrail-${TESTRAIL_VERSION}.zip -d /var/www/; \
    test -f ${TR_WWW_PATH}/index.php; \
    mkdir -p ${TR_CONFIG_DIR} ${TR_CUSTOM_AUTH_DIR}; \
    chown -R www-data:www-data ${TESTRAIL_RELEASE_DIR} ${TR_WWW_PATH} ${TR_OPT_PATH}; \
    echo "[testrail] Testrail version is: $(cat ${TR_WWW_PATH}/version.txt 2>/dev/null || echo ${TESTRAIL_VERSION})"

##################################################################
#                   Cassandra PHP driver
##################################################################
ENV CASSANDRA_CPP_DRIVER_VERSION=2.17.1
ENV CASSANDRA_CPP_DRIVER_DIR=${EMG_LOCAL_BASE_DIR}/cassandra-cpp-driver/${CASSANDRA_CPP_DRIVER_VERSION}

RUN apt-get update && \
    apt-get install -y --no-install-recommends libuv1 && \
    rm -rf /var/lib/apt/lists/*

COPY --from=cassandra-builder ${CASSANDRA_CPP_DRIVER_DIR} ${CASSANDRA_CPP_DRIVER_DIR}
COPY --from=cassandra-builder /tmp/cassandra/cassandra.so /tmp/cassandra/cassandra.so

RUN set -eux; \
    so="$(php-config --extension-dir)/cassandra.so"; \
    mv /tmp/cassandra/cassandra.so "$so"; \
    rm -rf /tmp/cassandra; \
    readelf -d "$so" | grep -E 'RPATH|RUNPATH|NEEDED'; \
    readelf -d "$so" | grep -q '(RPATH)' || { echo "FATAL: no RPATH in $so" >&2; exit 1; }; \
    ! readelf -d "$so" | grep -q '(RUNPATH)' || { echo "FATAL: RUNPATH in $so" >&2; exit 1; }; \
    ! ldd "$so" | grep -q 'not found' || { echo "FATAL: $so has unresolved deps" >&2; ldd "$so" >&2; exit 1; }; \
    test "$(ldd "$so" | grep -c 'libssl\.so')" = 1 || { echo "FATAL: not exactly one libssl behind $so" >&2; ldd "$so" >&2; exit 1; }; \
    test "$(ldd "$so" | grep -c 'libcrypto\.so')" = 1 || { echo "FATAL: not exactly one libcrypto behind $so" >&2; ldd "$so" >&2; exit 1; }; \
    ldd "$so" | grep -q "${PHP_SSL_LIB_DIR}/libssl" || { echo "FATAL: $so not linked against ${PHP_SSL_LIB_DIR}" >&2; ldd "$so" >&2; exit 1; }; \
    php-ext-enable cassandra; \
    php -m | grep -qix cassandra || { echo "FATAL: cassandra extension not active" >&2; php -m >&2; exit 1; }; \
    php --ri cassandra

##################################################################
#                   PHP checks
##################################################################
# ionCube loader and the extensions come from the epicmorg/php base image.
# TestRail is ionCube-encoded for PHP 7.2+ (ion72 package).
RUN set -eux; \
    php -v; \
    php -v | grep -qi 'ionCube' || { echo "FATAL: ionCube loader not active" >&2; exit 1; }; \
    grep -rqE '^listen *= */run/php/php-fpm.sock' ${PHP_INI_DIR}/php-fpm.d/ \
      || { echo "FATAL: php-fpm does not listen on /run/php/php-fpm.sock (apache2 base expects the unix socket)" >&2; exit 1; }; \
    for ext in curl json mbstring mysqli pdo_mysql openssl zip gd xml session zlib; do \
      php -m | grep -qix "${ext}" || { echo "FATAL: php extension ${ext} missing" >&2; php -m >&2; exit 1; }; \
    done

##################################################################
#                   Apache2 + supervisor
##################################################################
COPY etc/apache2/    /etc/apache2/
COPY etc/supervisor/ /etc/supervisor/
COPY usr/local/bin/testrail-entrypoint.sh /usr/local/bin/testrail-entrypoint.sh
COPY usr/local/bin/testrail-task.sh       /usr/local/bin/testrail-task.sh

RUN set -eux; \
    chmod 755 /usr/local/bin/testrail-entrypoint.sh /usr/local/bin/testrail-task.sh; \
    a2dissite localhost; \
    a2ensite testrail; \
    apachectl configtest

#healthcheck. good practice
HEALTHCHECK --interval=2m --timeout=3s --start-period=30s \
        CMD curl -fsS -o /dev/null http://localhost/ || exit 1

#Final config
WORKDIR ${TR_WWW_PATH}
EXPOSE 80 443

ENTRYPOINT ["/usr/local/bin/testrail-entrypoint.sh"]
CMD ["/usr/bin/supervisord", "-n", "-c", "/etc/supervisor/supervisord.conf"]
