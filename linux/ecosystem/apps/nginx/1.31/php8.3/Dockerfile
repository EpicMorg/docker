# check=skip=UndefinedVar
##################################################################
##################################################################
#        nginx 1.31 - built in ../main, only copied from here
##################################################################
##################################################################
FROM ghcr.io/epicmorg/nginx:1.31 AS nginx

##################################################################
##################################################################
#                   Final Layer: PHP 8.3 (fpm) + nginx 1.31
##################################################################
##################################################################
FROM ghcr.io/epicmorg/php:8.3
LABEL org.opencontainers.image.title="EpicMorg nginx + PHP (fpm)"
LABEL org.opencontainers.image.description="nginx 1.31 + PHP 8.3 (fpm) by EpicMorg"
LABEL maintainer="EpicMorg DevTeam, developer@epicm.org"
ARG DEBIAN_FRONTEND=noninteractive

##################################################################
#        nginx layout - keep in sync with ../main/Dockerfile
##################################################################
ENV NGINX_VERSION=1.31
ENV NGINX_VERSION_FULL=${NGINX_VERSION}.3
ENV NGINX_DIR=${EMG_LOCAL_BASE_DIR}/nginx/${NGINX_VERSION}
ENV NGINX_CONF_DIR=/etc/nginx
ENV NGINX_MODULES_DIR=${NGINX_CONF_DIR}/modules
ENV NGINX_MODULES_PERL_DIR=${NGINX_CONF_DIR}/modules-perl
ENV NGINX_SBIN_DIR=${NGINX_DIR}/sbin
ENV NGINX_BIN_DIR=${NGINX_SBIN_DIR}
ENV NGINX_CACHE_DIR=/var/cache/nginx
ENV NGINX_LOGS_DIR=/var/log/nginx
ENV NGINX_LOCK_DIR=/var/lock/nginx
ENV NGINX_LOCK=${NGINX_LOCK_DIR}/nginx.lock
ENV NGINX_HTML_DIR=${NGINX_DIR}/html
ENV NGINX_PID_DIR=/run/nginx
ENV NGINX_PID=${NGINX_PID_DIR}/nginx.pid

# libimagequant source
# NOTE: pinned to master deliberately. Upstream tagged 4.4.0 with known issues
# and the fixed 4.5.0 was never tagged. Switch to a tag once one appears.
ENV LIBIMAGEQUANT_VERSION=4.5.0
ENV LIBIMAGEQUANT_DIR=${EMG_LOCAL_BASE_DIR}/libimagequant/${LIBIMAGEQUANT_VERSION}
ENV LIBIMAGEQUANT_INC_DIR=${LIBIMAGEQUANT_DIR}/include
ENV LIBIMAGEQUANT_LIB_DIR=${LIBIMAGEQUANT_DIR}/lib

# IP2Location-C-Library
ENV IP2LOC_VERSION=8.7.0
ENV IP2LOC_DIR=${EMG_LOCAL_BASE_DIR}/ip2location/${IP2LOC_VERSION}
ENV IP2LOC_BIN_DIR=${IP2LOC_DIR}/bin
ENV IP2LOC_INC_DIR=${IP2LOC_DIR}/include
ENV IP2LOC_LIB_DIR=${IP2LOC_DIR}/lib

# libxml2
ENV LIBXML2_VERSION=2.15.3
ENV LIBXML2_DIR=${EMG_LOCAL_BASE_DIR}/libxml2/${LIBXML2_VERSION}
ENV LIBXML2_BIN_DIR=${LIBXML2_DIR}/bin
ENV LIBXML2_INC_DIR=${LIBXML2_DIR}/include
ENV LIBXML2_LIB_DIR=${LIBXML2_DIR}/lib

# libxslt
ENV LIBXSLT_VERSION=1.1.45
ENV LIBXSLT_DIR=${EMG_LOCAL_BASE_DIR}/libxslt/${LIBXSLT_VERSION}
ENV LIBXSLT_BIN_DIR=${LIBXSLT_DIR}/bin
ENV LIBXSLT_INC_DIR=${LIBXSLT_DIR}/include
ENV LIBXSLT_LIB_DIR=${LIBXSLT_DIR}/lib

# luajit2
ENV LUAJIT2OR_VERSION=2.1
ENV LUAJIT2OR_DIR=${EMG_LOCAL_BASE_DIR}/luajit2/${LUAJIT2OR_VERSION}
ENV LUAJIT2OR_BIN_DIR=${LUAJIT2OR_DIR}/bin
ENV LUAJIT2OR_LIB_DIR=${LUAJIT2OR_DIR}/lib
ENV LUAJIT2OR_INC_DIR=${LUAJIT2OR_DIR}/include

# libgd
ENV LIBGD_VERSION=2.3.3
ENV LIBGD_DIR=${EMG_LOCAL_BASE_DIR}/libgd/${LIBGD_VERSION}
ENV LIBGD_BIN_DIR=${LIBGD_DIR}/bin
ENV LIBGD_INC_DIR=${LIBGD_DIR}/include
ENV LIBGD_LIB_DIR=${LIBGD_DIR}/lib

# Google perftools
ENV GPERFTOOLS_VERSION=2.18.1
ENV GPERFTOOLS_DIR=${EMG_LOCAL_BASE_DIR}/gperftools/${GPERFTOOLS_VERSION}
ENV GPERFTOOLS_BIN_DIR=${GPERFTOOLS_DIR}/bin
ENV GPERFTOOLS_INC_DIR=${GPERFTOOLS_DIR}/include
ENV GPERFTOOLS_LIB_DIR=${GPERFTOOLS_DIR}/lib

# maxmind geoip End-Of-Life!
ENV MM_GEOIP_VERSION=1.6.12
ENV MM_GEOIP_DIR=${EMG_LOCAL_BASE_DIR}/geoip/${MM_GEOIP_VERSION}
ENV MM_GEOIP_BIN_DIR=${MM_GEOIP_DIR}/bin
ENV MM_GEOIP_INC_DIR=${MM_GEOIP_DIR}/include
ENV MM_GEOIP_LIB_DIR=${MM_GEOIP_DIR}/lib

# libatomic_ops
ENV LIBATOMICOPS_VERSION=7.8.4
ENV LIBATOMICOPS_DIR=${EMG_LOCAL_BASE_DIR}/libatomic_ops/${LIBATOMICOPS_VERSION}
ENV LIBATOMICOPS_INC_DIR=${LIBATOMICOPS_DIR}/include
ENV LIBATOMICOPS_LIB_DIR=${LIBATOMICOPS_DIR}/lib

# zstd
ENV ZSTD_VERSION=1.5.7
ENV ZSTD_DIR=${EMG_LOCAL_BASE_DIR}/zstd/${ZSTD_VERSION}
ENV ZSTD_BIN_DIR=${ZSTD_DIR}/bin
ENV ZSTD_INC_DIR=${ZSTD_DIR}/include
ENV ZSTD_LIB_DIR=${ZSTD_DIR}/lib

# zlib
ENV ZLIB_VERSION=1.3.1
ENV ZLIB_DIR=${EMG_LOCAL_BASE_DIR}/zlib/${ZLIB_VERSION}
ENV ZLIB_INC_DIR=${ZLIB_DIR}/include
ENV ZLIB_LIB_DIR=${ZLIB_DIR}/lib

# PCRE
ENV PCRE_VERSION=10.47
ENV PCRE_DIR=${EMG_LOCAL_BASE_DIR}/pcre2/${PCRE_VERSION}
ENV PCRE_BIN_DIR=${PCRE_DIR}/bin
ENV PCRE_LIB_DIR=${PCRE_DIR}/lib
ENV PCRE_INC_DIR=${PCRE_DIR}/include

# OpenSSL 3.5 [LTS]
ENV OPENSSL_35_MIN_VERSION=3.5
ENV OPENSSL_35_VERSION=${OPENSSL_35_MIN_VERSION}.7
ENV OPENSSL_35_DIR=${EMG_LOCAL_BASE_DIR}/openssl/${OPENSSL_35_MIN_VERSION}
ENV OPENSSL_35_BIN_DIR=${OPENSSL_35_DIR}/bin
ENV OPENSSL_35_INC_DIR=${OPENSSL_35_DIR}/include
ENV OPENSSL_35_LIB_DIR=${OPENSSL_35_DIR}/lib64

# libraqm
ENV LIBRAQM_VERSION=0.11.0
ENV LIBRAQM_DIR=${EMG_LOCAL_BASE_DIR}/libraqm/${LIBRAQM_VERSION}
ENV LIBRAQM_INC_DIR=${LIBRAQM_DIR}/include
ENV LIBRAQM_LIB_DIR=${LIBRAQM_DIR}/lib

##################################################################
#                   installing
##################################################################
# Debian runtime libs of nginx, its modules and the baked libgd/libraqm/gperftools (same list
# as ../main; listed explicitly, not taken for granted from debian main) + supervisor, which
# runs php-fpm and nginx side by side.
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        libunwind8 \
        libmaxminddb0 \
        libxpm4 \
        libavif16 \
        libzip5 \
        libwebp7 \
        libheif1 \
        libtiff6 \
        libharfbuzz0b \
        libfribidi0 \
        libfreetype6 \
        libfontconfig1 \
        libjpeg62-turbo \
        libpng16-16t64 \
        libgssapi-krb5-2 \
        libkrb5-3 \
        libcom-err2 \
        libpam0g \
        libperl5.40 \
        supervisor \
    && \
    echo "clean up" && \
    apt-get clean -y && \
    apt-get autoclean -y && \
    rm -rfv /var/lib/apt/lists/* && \
    rm -rfv /var/cache/apt/archives/*.deb && \
    rm -rfv /tmp/*

##################################################################
#        Copy compiled nginx FROM image and prepare
##################################################################
# The PHP image already ships some of these prefixes (e.g. OpenSSL 3.5 on
# PHP 8.1+). Both come from the same epicmorg/gcc:14 build, so the copy is a
# no-op overwrite, not a version mix.
COPY --from=nginx ${NGINX_CONF_DIR} ${NGINX_CONF_DIR}
COPY --from=nginx ${NGINX_DIR} ${NGINX_DIR}
COPY --from=nginx ${OPENSSL_35_DIR} ${OPENSSL_35_DIR}
COPY --from=nginx ${PCRE_DIR} ${PCRE_DIR}
COPY --from=nginx ${ZLIB_DIR} ${ZLIB_DIR}
COPY --from=nginx ${ZSTD_DIR} ${ZSTD_DIR}
COPY --from=nginx ${LIBATOMICOPS_DIR} ${LIBATOMICOPS_DIR}
COPY --from=nginx ${LIBIMAGEQUANT_DIR} ${LIBIMAGEQUANT_DIR}
COPY --from=nginx ${LIBRAQM_DIR} ${LIBRAQM_DIR}
COPY --from=nginx ${MM_GEOIP_DIR} ${MM_GEOIP_DIR}
COPY --from=nginx ${GPERFTOOLS_DIR} ${GPERFTOOLS_DIR}
COPY --from=nginx ${LIBGD_DIR} ${LIBGD_DIR}
COPY --from=nginx ${LUAJIT2OR_DIR} ${LUAJIT2OR_DIR}
COPY --from=nginx ${LIBXSLT_DIR} ${LIBXSLT_DIR}
COPY --from=nginx ${LIBXML2_DIR} ${LIBXML2_DIR}
COPY --from=nginx ${IP2LOC_DIR} ${IP2LOC_DIR}
COPY --from=nginx /var/www/html/ /var/www/html/

RUN set -eux; \
    mkdir -p \
      ${NGINX_CONF_DIR}/sites-enabled \
      ${NGINX_CONF_DIR}/modules-enabled \
      ${NGINX_LOCK_DIR} \
      ${NGINX_LOGS_DIR} \
      ${NGINX_PID_DIR} \
      ${NGINX_CACHE_DIR} \
      /run/php \
      /var/log/supervisor; \
    ln -sfv /dev/stdout ${NGINX_LOGS_DIR}/access.log; \
    ln -sfv /dev/stderr ${NGINX_LOGS_DIR}/error.log; \
    ln -sfn ${NGINX_DIR} /usr/share/nginx; \
    chown -R www-data:www-data /run/php /var/www

##################################################################
#                   nginx + php-fpm + supervisor configs
##################################################################
COPY etc/nginx/ ${NGINX_CONF_DIR}/
COPY etc/php-fpm.d/zz-nginx.conf ${PHP_INI_DIR}/php-fpm.d/zz-nginx.conf
COPY etc/supervisor/ /etc/supervisor/
COPY usr/bin/docker-entrypoint.sh /usr/bin/docker-entrypoint.sh

RUN set -eux; \
    chmod +x /usr/bin/docker-entrypoint.sh; \
    rm -fv ${NGINX_CONF_DIR}/sites-enabled/*; \
    ln -sfv ${NGINX_CONF_DIR}/sites-available/default.conf ${NGINX_CONF_DIR}/sites-enabled/default.conf

ENV PATH="${NGINX_SBIN_DIR}:${PATH}"

##################################################################
#                   Assertions
##################################################################
RUN set -eu; \
    echo "--- nginx linkage ---"; \
    ldd ${NGINX_SBIN_DIR}/nginx | grep -q 'not found' \
      && { echo "FATAL: nginx has unresolved deps" >&2; ldd ${NGINX_SBIN_DIR}/nginx >&2; exit 1; }; \
    ldd ${NGINX_SBIN_DIR}/nginx | grep -q "${OPENSSL_35_LIB_DIR}/libssl" \
      || { echo "FATAL: nginx not linked against our OpenSSL" >&2; exit 1; }; \
    for m in ${NGINX_MODULES_DIR}/*.so; do \
      ldd "$m" 2>/dev/null | grep -q 'not found' \
        && { echo "FATAL: $(basename $m) has unresolved deps" >&2; ldd "$m" >&2; exit 1; }; \
    done; \
    echo "--- php-fpm pool ---"; \
    php-fpm -tt 2>&1 | grep -E "listen = /run/php/php-fpm.sock" \
      || { echo "FATAL: php-fpm does not listen on /run/php/php-fpm.sock" >&2; php-fpm -tt >&2; exit 1; }; \
    php-fpm -t; \
    nginx -V; \
    nginx -t; \
    supervisord -v; \
    echo "OK: nginx ${NGINX_VERSION_FULL} + PHP ${PHP_FULL_VERSION}"

##################################################################
#                   Runtime
##################################################################
# /php-fpm-ping is answered by php-fpm through nginx, so one probe covers both.
HEALTHCHECK --interval=2m --timeout=3s --start-period=10s CMD curl -fsS http://127.0.0.1/php-fpm-ping || exit 1

VOLUME ["${NGINX_CACHE_DIR}"]
WORKDIR /var/www/
EXPOSE 80 443

CMD ["/usr/bin/docker-entrypoint.sh"]
