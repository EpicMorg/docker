FROM ghcr.io/epicmorg/testrail:8.0.6.1019
LABEL org.opencontainers.image.title="EpicMorg TestRail (LDAP auth)"
LABEL org.opencontainers.image.description="TestRail 8.0.6.1019 with the LDAP authentication script on Apache2 + PHP 8.1 (fpm) by EpicMorg"
ARG DEBIAN_FRONTEND=noninteractive

##################################################################
#                   OpenLDAP client libraries
##################################################################
# Debian's libldap links the system OpenSSL. PHP here is built against its own
# OpenSSL (${PHP_SSL_DIR}), so the PHP ldap extension gets its own libldap,
# baked against the same OpenSSL with a real RPATH (-Wl,--disable-new-dtags):
# exactly one libssl/libcrypto per process.
# OpenLDAP 2.6 (OpenSSL >= 1.1.1)
ENV OPENLDAP_VERSION=2.6.15
ENV OPENLDAP_DIR=${EMG_LOCAL_BASE_DIR}/openldap/${OPENLDAP_VERSION}
ARG OPENLDAP_SHA256=bc91225dbfc50354033b1303bc91d1a7f6ddd1dc32fac950d79c28fe66d6bca8
ARG OPENLDAP_URL=https://www.openldap.org/software/download/OpenLDAP/openldap-release/openldap-${OPENLDAP_VERSION}.tgz

RUN set -eux; \
    mkdir -p /usr/local/src/openldap; \
    cd /usr/local/src/openldap; \
    wget --quiet --tries=15 --retry-connrefused --timeout=30 -O openldap.tgz "${OPENLDAP_URL}"; \
    echo "${OPENLDAP_SHA256}  openldap.tgz" | sha256sum -c -; \
    tar -xzf openldap.tgz --strip-components=1; \
    rm -f openldap.tgz; \
    ./configure \
      --prefix="${OPENLDAP_DIR}" \
      --enable-option-checking=fatal \
      --disable-slapd \
      --disable-debug \
      --disable-static \
      --enable-shared \
      --without-cyrus-sasl \
      --with-tls=openssl \
      CPPFLAGS="-I${PHP_SSL_DIR}/include" \
      LDFLAGS="-L${PHP_SSL_LIB_DIR} -Wl,-rpath,${PHP_SSL_LIB_DIR} -Wl,-rpath,${OPENLDAP_DIR}/lib -Wl,--disable-new-dtags"; \
    make depend; \
    make -C include -j"$(nproc)"; \
    make -C libraries -j"$(nproc)"; \
    make -C include install; \
    make -C libraries install; \
    cd /; \
    rm -rf /usr/local/src/openldap; \
    for so in "${OPENLDAP_DIR}"/lib/libldap.so "${OPENLDAP_DIR}"/lib/liblber.so; do \
      readelf -d "$so" | grep -E 'RPATH|RUNPATH'; \
      readelf -d "$so" | grep -q '(RPATH)' || { echo "FATAL: no RPATH in $so" >&2; exit 1; }; \
      ! readelf -d "$so" | grep -q '(RUNPATH)' || { echo "FATAL: RUNPATH in $so" >&2; exit 1; }; \
      if ldd "$so" | grep -q 'not found'; then echo "FATAL: $so has unresolved deps" >&2; ldd "$so" >&2; exit 1; fi; \
    done; \
    ldd "${OPENLDAP_DIR}/lib/libldap.so" | grep -q "${PHP_SSL_LIB_DIR}/libssl" \
      || { echo "FATAL: libldap not linked against ${PHP_SSL_LIB_DIR}" >&2; ldd "${OPENLDAP_DIR}/lib/libldap.so" >&2; exit 1; }

##################################################################
#                   PHP ldap extension
##################################################################
RUN set -eux; \
    export LDFLAGS="${PHP_LDFLAGS} -L${OPENLDAP_DIR}/lib -Wl,-rpath,${OPENLDAP_DIR}/lib -Wl,--disable-new-dtags"; \
    php-ext-configure ldap --with-ldap="${OPENLDAP_DIR}"; \
    php-ext-install -j"$(nproc)" ldap; \
    so="$(php-config --extension-dir)/ldap.so"; \
    readelf -d "$so" | grep -E 'RPATH|RUNPATH|NEEDED'; \
    readelf -d "$so" | grep -q '(RPATH)' || { echo "FATAL: no RPATH in $so" >&2; exit 1; }; \
    ! readelf -d "$so" | grep -q '(RUNPATH)' || { echo "FATAL: RUNPATH in $so" >&2; exit 1; }; \
    if ldd "$so" | grep -q 'not found'; then echo "FATAL: ldap.so has unresolved deps" >&2; ldd "$so" >&2; exit 1; fi; \
    ldd "$so" | grep -q "${OPENLDAP_DIR}/lib/libldap" \
      || { echo "FATAL: ldap.so not linked against the baked libldap" >&2; ldd "$so" >&2; exit 1; }; \
    test "$(ldd "$so" | grep -c 'libcrypto\.so')" = 1 \
      || { echo "FATAL: more than one libcrypto behind ldap.so" >&2; ldd "$so" >&2; exit 1; }; \
    test "$(ldd "$so" | grep -c 'libssl\.so')" = 1 \
      || { echo "FATAL: more than one libssl behind ldap.so" >&2; ldd "$so" >&2; exit 1; }; \
    php -m | grep -qix ldap || { echo "FATAL: ldap extension not active" >&2; php -m >&2; exit 1; }; \
    php -v | grep -qi 'ionCube' || { echo "FATAL: ionCube loader not active" >&2; exit 1; }; \
    php --ri ldap

##################################################################
#                   TestRail LDAP authentication script
##################################################################
# Pristine script + readme land in ${TESTRAIL_PLUGIN_DIR}. Configure the
# AUTH_* constants and mount it as ${TR_CUSTOM_AUTH_DIR}/auth.php (see README).
ENV TESTRAIL_PLUGIN_VERSION=1.4
ENV TESTRAIL_PLUGIN_NAME=ldap
ENV TESTRAIL_PLUGIN_FULLNAME=testrail-auth-${TESTRAIL_PLUGIN_NAME}-${TESTRAIL_PLUGIN_VERSION}
ENV TESTRAIL_PLUGIN_FILE=${TESTRAIL_PLUGIN_FULLNAME}.zip
ENV TESTRAIL_PLUGIN_DIR=${TESTRAIL_RELEASE_DIR}/${TESTRAIL_PLUGIN_FULLNAME}
ARG TESTRAIL_PLUGIN_SHA256=69e4f9137ed9bd5340e35b99e65d351c3bb3890d0190ebc58a7da31d58956c51
# The vendor zip (media.gurock.com, dead) is vendored in the generator
# (bin/ansible/roles/gurock.testrail/files/auth/plugins) and copied next to this
# Dockerfile on generation; still pinned by sha256.
COPY ${TESTRAIL_PLUGIN_FILE} ${TESTRAIL_RELEASE_DIR}/

RUN set -eux; \
    cd ${TESTRAIL_RELEASE_DIR}; \
    echo "${TESTRAIL_PLUGIN_SHA256}  ${TESTRAIL_PLUGIN_FILE}" | sha256sum -c -; \
    unzip -q -o "${TESTRAIL_PLUGIN_FILE}" -x '__MACOSX/*' -d ${TESTRAIL_RELEASE_DIR}; \
    test -f "${TESTRAIL_PLUGIN_DIR}/auth.php"; \
    php -l "${TESTRAIL_PLUGIN_DIR}/auth.php"; \
    chown -R www-data:www-data ${TESTRAIL_RELEASE_DIR}
