##################################################################
##################################################################
##################################################################
#                   Temp Build Layer
##################################################################
##################################################################
##################################################################
FROM docker.io/epicmorg/gcc:14 AS build
LABEL maintainer="EpicMorg DevTeam, developer@epicm.org"
ARG DEBIAN_FRONTEND=noninteractive

##################################################################
#                   Nginx
##################################################################
ENV NGINX_VERSION=1.25
ENV NGINX_VERSION_FULL=${NGINX_VERSION}.5
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
ENV NGINX_SRC_DIR=/usr/local/src/nginx/${NGINX_VERSION}
ARG NGINX_DOWNLOAD_URL=http://nginx.org/download/nginx-${NGINX_VERSION_FULL}.tar.gz
ARG NGINX_TEMP=nginx-${NGINX_VERSION_FULL}.tar.gz
ARG NGINX_TEMP_SRC=/tmp/nginx-${NGINX_VERSION_FULL}

##################################################################
#                   Nginx Modules
##################################################################

# NJS
ENV NGM_NJS_VERSION=1.0.0
ARG NGM_NJS_DOWNLOAD_URL=https://github.com/nginx/njs
ARG NGM_NJS_DIR=${NGINX_TEMP_SRC}/modules/nginx-njs

# QuickJS for NJS
ENV NGM_QJS_VERSION=2026-06-04
ARG NGM_QJS_DOWNLOAD_URL=https://bellard.org/quickjs/quickjs-${NGM_QJS_VERSION}.tar.xz
ARG NGM_QJS_DIR=${NGINX_TEMP_SRC}/modules/nginx-njs-quickjs

# ip2location
ENV NGM_IP2LOC_VERSION=8.7.0
ARG NGM_IP2LOC_DOWNLOAD_URL=https://github.com/ip2location/ip2location-nginx

# Precheck
RUN set -eu; \
    for so in \
      ${OPENSSL_35_LIB_DIR}/libssl.so \
      ${LIBGD_LIB_DIR}/libgd.so \
      ${LIBRAQM_LIB_DIR}/libraqm.so \
      ${LIBIMAGEQUANT_LIB_DIR}/libimagequant.so \
      ${LIBXML2_LIB_DIR}/libxml2.so \
      ${LIBXSLT_LIB_DIR}/libxslt.so \
    ; do \
      test -f "$so" || { echo "FATAL: missing $so" >&2; ls -la "$(dirname $(dirname $so))" >&2; exit 1; }; \
    done; \
    echo "OK: copied libs present"

##################################################################
#                   Prepare Nginx
##################################################################
RUN set -eux; \
    mkdir -p ${NGINX_DIR} ${NGINX_SRC_DIR} && \
    aria2c \
        --conf-path=/usr/local/share/epicmorg/aria2/config/aria2.conf \
        --user-agent="$(shuf -n 1 /usr/local/share/epicmorg/user-agents/user-agents.txt)" \
        -d /tmp \
        -o ${NGINX_TEMP} \
        "${NGINX_DOWNLOAD_URL}" && \
    tar -xf /tmp/${NGINX_TEMP} --directory /tmp && \
    aria2c \
        --conf-path=/usr/local/share/epicmorg/aria2/config/aria2.conf \
        --user-agent="$(shuf -n 1 /usr/local/share/epicmorg/user-agents/user-agents.txt)" \
        -d /tmp \
        -o quickjs.tar.xz \
        "${NGM_QJS_DOWNLOAD_URL}" && \
    mkdir -p ${NGM_QJS_DIR} && \
    tar -xJf /tmp/quickjs.tar.xz --strip-components=1 --directory ${NGM_QJS_DIR} && \
    echo "clean up" && \
    apt-get clean -y && \
    apt-get autoclean -y && \
    rm -rfv /tmp/*.tar.xz && \
    rm -rfv /tmp/*.tar.gz

WORKDIR ${NGINX_TEMP_SRC}

RUN set -eux; \
    git clone  --depth 1 --branch ${NGM_NJS_VERSION} ${NGM_NJS_DOWNLOAD_URL} modules/nginx-njs  && \
    git clone  --depth 1 --branch ${NGM_IP2LOC_VERSION} ${NGM_IP2LOC_DOWNLOAD_URL} modules/ip2location-nginx && \
    git clone https://github.com/openresty/headers-more-nginx-module modules/http-headers-more-filter  && \
    git clone https://github.com/sto/ngx_http_auth_pam_module modules/http-auth-pam  && \
    git clone https://github.com/openresty/lua-nginx-module modules/http-lua && \
    git clone https://github.com/leev/ngx_http_geoip2_module modules/http-geoip2 && \
    git clone https://github.com/arut/nginx-dav-ext-module modules/http-dav-ext && \
    git clone https://github.com/openresty/echo-nginx-module modules/http-echo && \
    git clone https://github.com/aperezdc/ngx-fancyindex modules/http-fancyindex && \
    git clone https://github.com/slact/nchan modules/nchan && \
    git clone https://github.com/masterzen/nginx-upload-progress-module modules/http-uploadprogress && \
    git clone https://github.com/yaoweibin/ngx_http_substitutions_filter_module modules/http-subs-filter && \
    git clone https://github.com/stnoonan/spnego-http-auth-nginx-module modules/spnego-http-auth-nginx-module && \
    git clone https://github.com/evanmiller/mod_zip modules/mod-zip && \
    git clone https://github.com/alibaba/nginx-http-user-agent modules/nginx-http-user-agent && \
    git clone https://github.com/youzee/nginx-unzip-module modules/nginx-unzip-module && \
    git clone https://github.com/vladbondarenko/ngx_webp modules/ngx-webp && \
    git clone https://github.com/openresty/xss-nginx-module modules/xss-nginx-module && \
    git clone https://github.com/openresty/set-misc-nginx-module modules/set-misc-nginx-module && \
    git clone https://github.com/arut/nginx-rtmp-module modules/rtmp && \
    git clone https://github.com/simplresty/ngx_devel_kit modules/http-ndk && \
    git clone https://github.com/itoffshore/nginx-upstream-fair modules/http-upstream-fair && \
    git clone https://github.com/yaoweibin/nginx_upstream_check_module modules/nginx-upstream-check-module && \
    export NGNX_CFLAGS="-fstack-protector-strong -fpic -fpie -O2 -D_LARGEFILE_SOURCE -D_FILE_OFFSET_BITS=64" && \
    export NGNX_CPPFLAGS="${NGNX_CFLAGS}" && \
    export NGNX_LDFLAGS="-Wl,-O1 -pie" && \
    export LUAJIT_LIB=${LUAJIT2OR_LIB_DIR} && \
    export LUAJIT_INC=${LUAJIT2OR_INC_DIR}/luajit-2.1 && \
    export CC="${GCC_INSTALL_DIR}/bin/gcc" && \
    export CXX="${GCC_INSTALL_DIR}/bin/g++" && \
    debMultiarch="$(dpkg-architecture --query DEB_BUILD_MULTIARCH)" && \
    export PKG_CONFIG_PATH="${LIBATOMICOPS_LIB_DIR}/pkgconfig:${ZLIB_LIB_DIR}/pkgconfig:${PCRE_LIB_DIR}/pkgconfig:${OPENSSL_35_LIB_DIR}/pkgconfig:${PKG_CONFIG_PATH:-}" && \
    export CFLAGS="${NGNX_CFLAGS}" && \
    export CPPFLAGS="-I${OPENSSL_35_INC_DIR} ${NGNX_CPPFLAGS}"  && \
    export LDFLAGS="-L${OPENSSL_35_LIB_DIR} -Wl,-rpath,${OPENSSL_35_LIB_DIR} ${NGNX_LDFLAGS}"  && \
    cd ${NGM_QJS_DIR} && \
        CFLAGS='-fPIC -O2' make libquickjs.a && \
    cd ${NGM_NJS_DIR} && \
        ./configure \
            --cc-opt="-I${NGM_QJS_DIR} \
                    -I${IP2LOC_INC_DIR} \
                    -I${LIBXML2_INC_DIR} \
                    -I${LIBXSLT_INC_DIR} \
                    -I${LUAJIT2OR_INC_DIR} \
                    -I${LUAJIT2OR_INC_DIR}/luajit-2.1 \
                    -I${LIBGD_INC_DIR} \
                    -I${GPERFTOOLS_INC_DIR} \
                    -I${MM_GEOIP_INC_DIR} \
                    -I${LIBATOMICOPS_INC_DIR} \
                    -I${OPENSSL_35_INC_DIR} \
                    -I${ZLIB_INC_DIR} \
                    -I${PCRE_INC_DIR} \
                    -I/usr/include/x86_64-linux-gnu \
                    -I/usr/include \
                    -g -O2 -fPIC" \
            --ld-opt="-L${NGM_QJS_DIR} \
                    -L${IP2LOC_LIB_DIR} \
                    -Wl,-rpath,${IP2LOC_LIB_DIR} \
                    -L${LIBXML2_LIB_DIR} \
                    -Wl,-rpath,${LIBXML2_LIB_DIR} \
                    -L${LIBXSLT_LIB_DIR} \
                    -Wl,-rpath,${LIBXSLT_LIB_DIR} \
                    -L${LUAJIT2OR_LIB_DIR} \
                    -Wl,-rpath,${LUAJIT2OR_LIB_DIR} \
                    -L${LIBGD_LIB_DIR} \
                    -Wl,-rpath,${LIBGD_LIB_DIR} \
                    -L${GPERFTOOLS_LIB_DIR} \
                    -Wl,-rpath,${GPERFTOOLS_LIB_DIR} \
                    -L${MM_GEOIP_LIB_DIR} \
                    -Wl,-rpath,${MM_GEOIP_LIB_DIR} \
                    -L${LIBATOMICOPS_LIB_DIR} \
                    -Wl,-rpath,${LIBATOMICOPS_LIB_DIR} \
                    -L${OPENSSL_35_LIB_DIR} \
                    -Wl,-rpath,${OPENSSL_35_LIB_DIR} \
                    -L${ZLIB_LIB_DIR} \
                    -Wl,-rpath,${ZLIB_LIB_DIR} \
                    -L${PCRE_LIB_DIR} \
                    -Wl,-rpath,${PCRE_LIB_DIR} \
                    -L/usr/lib/x86_64-linux-gnu \
                    -L/usr/lib \
                    -Wl,-z,relro -Wl,-z,now -lz -fPIC" \
    && \
    make && \
    cd ${NGINX_TEMP_SRC} && \
    ./configure \
        --user=www-data \
        --group=www-data \
        --prefix=${NGINX_DIR} \
        --sbin-path=${NGINX_SBIN_DIR}/nginx \
        --conf-path=${NGINX_CONF_DIR}/nginx.conf  \
        --http-log-path=${NGINX_LOGS_DIR}/access.log \
        --error-log-path=${NGINX_LOGS_DIR}/error.log \
        --modules-path=${NGINX_MODULES_DIR} \
        --lock-path=${NGINX_LOCK} \
        --pid-path=${NGINX_PID} \
        --http-client-body-temp-path=${NGINX_CACHE_DIR}/body \
        --http-fastcgi-temp-path=${NGINX_CACHE_DIR}/fastcgi \
        --http-proxy-temp-path=${NGINX_CACHE_DIR}/proxy \
        --http-scgi-temp-path=${NGINX_CACHE_DIR}/scgi \
        --http-uwsgi-temp-path=${NGINX_CACHE_DIR}/uwsgi \
        --with-cc-opt="-I${IP2LOC_INC_DIR} \
                -I${LIBXML2_INC_DIR} \
                -I${LIBXSLT_INC_DIR} \
                -I${LUAJIT2OR_INC_DIR} \
                -I${LUAJIT2OR_INC_DIR}/luajit-2.1 \
                -I${LIBGD_INC_DIR} \
                -I${GPERFTOOLS_INC_DIR} \
                -I${MM_GEOIP_INC_DIR} \
                -I${LIBATOMICOPS_INC_DIR} \
                -I${OPENSSL_35_INC_DIR} \
                -I${ZLIB_INC_DIR} \
                -I${PCRE_INC_DIR} \
                -I/usr/include/x86_64-linux-gnu \
                -I/usr/include \
                -I${NGM_QJS_DIR} \
                -g -O2 -fPIC" \
        --with-ld-opt="-L${IP2LOC_LIB_DIR} \
                -Wl,-rpath,${IP2LOC_LIB_DIR} \
                -L${LIBXML2_LIB_DIR} \
                -Wl,-rpath,${LIBXML2_LIB_DIR} \
                -L${LIBXSLT_LIB_DIR} \
                -Wl,-rpath,${LIBXSLT_LIB_DIR} \
                -L${LUAJIT2OR_LIB_DIR} \
                -Wl,-rpath,${LUAJIT2OR_LIB_DIR} \
                -L${LIBGD_LIB_DIR} \
                -Wl,-rpath,${LIBGD_LIB_DIR} \
                -L${GPERFTOOLS_LIB_DIR} \
                -Wl,-rpath,${GPERFTOOLS_LIB_DIR} \
                -L${MM_GEOIP_LIB_DIR} \
                -Wl,-rpath,${MM_GEOIP_LIB_DIR} \
                -L${LIBATOMICOPS_LIB_DIR} \
                -Wl,-rpath,${LIBATOMICOPS_LIB_DIR} \
                -L${OPENSSL_35_LIB_DIR} \
                -Wl,-rpath,${OPENSSL_35_LIB_DIR} \
                -L${ZLIB_LIB_DIR} \
                -Wl,-rpath,${ZLIB_LIB_DIR} \
                -L${PCRE_LIB_DIR} \
                -Wl,-rpath,${PCRE_LIB_DIR} \
                -L/usr/lib/x86_64-linux-gnu \
                -L/usr/lib \
                -L${NGM_QJS_DIR} \
                -Wl,-z,relro -Wl,-z,now -lz -fPIC" \
            --user=www-data \
            --group=www-data \
            --with-pcre-jit \
            --with-pcre \
            --with-threads \
            --with-file-aio \
            --with-compat \
            --with-select_module \
            --with-poll_module \
            --without-quic_bpf_module \
            --with-http_ssl_module \
            --with-http_v2_module \
            --with-http_v3_module \
            --with-http_realip_module \
            --with-http_addition_module \
            --with-http_xslt_module=dynamic \
            --with-http_image_filter_module=dynamic \
            --with-http_geoip_module=dynamic \
            --with-http_sub_module \
            --with-http_dav_module \
            --with-http_flv_module \
            --with-http_mp4_module \
            --with-http_gunzip_module \
            --with-http_gzip_static_module \
            --with-http_auth_request_module \
            --with-http_random_index_module \
            --with-http_secure_link_module \
            --with-http_degradation_module \
            --with-http_slice_module \
            --with-http_stub_status_module \
            --with-http_perl_module=dynamic \
            --with-perl_modules_path=${NGINX_MODULES_PERL_DIR} \
            --with-mail=dynamic  \
            --with-mail_ssl_module \
            --with-stream=dynamic  \
            --with-stream_ssl_module \
            --with-stream_realip_module \
            --with-stream_geoip_module=dynamic \
            --with-stream_ssl_preread_module \
            --with-google_perftools_module \
            --with-cpp_test_module \
            --with-compat \
      --add-dynamic-module=modules/http-headers-more-filter \
      --add-dynamic-module=modules/nginx-http-user-agent \
      --add-dynamic-module=modules/http-ndk \
      --add-dynamic-module=modules/http-echo \
      --add-dynamic-module=modules/http-fancyindex \
      --add-dynamic-module=modules/nchan \
      --add-dynamic-module=modules/http-uploadprogress \
      --add-dynamic-module=modules/http-subs-filter \
      --add-dynamic-module=modules/mod-zip \
      --add-dynamic-module=modules/http-geoip2 \
      --add-dynamic-module=modules/ngx-webp \
      --add-dynamic-module=modules/set-misc-nginx-module \
      --add-dynamic-module=modules/rtmp \
      --add-dynamic-module=modules/http-upstream-fair \
      --add-dynamic-module=modules/nginx-upstream-check-module \
      --add-dynamic-module=modules/ip2location-nginx \
      --add-dynamic-module=modules/http-dav-ext \
      --add-dynamic-module=modules/http-lua \
      --add-dynamic-module=modules/http-auth-pam \
      --add-dynamic-module=modules/nginx-unzip-module \
      --add-dynamic-module=modules/spnego-http-auth-nginx-module \
      --add-dynamic-module=modules/xss-nginx-module \
      --add-dynamic-module=modules/nginx-njs/nginx \
        && \
        make -j$(nproc) && \
        make -j$(nproc) install

##################################################################
##################################################################
##################################################################
#                   Main Final Layer
##################################################################
##################################################################
##################################################################
FROM docker.io/epicmorg/debian:trixie

ENV NGINX_VERSION=1.25
ENV NGINX_VERSION_FULL=${NGINX_VERSION}.5
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
RUN apt-get update && \
    apt-get install -y \
        libunwind8 \
        libmaxminddb0 \
        libxpm4 \
        libavif16 \
    && \
    echo "clean up" && \
    apt-get clean -y && \
    apt-get autoclean -y && \
    rm -rfv /var/lib/apt/lists/* && \
    rm -rfv /var/cache/apt/archives/*.deb && \
    rm -rfv /tmp/*

##################################################################
#        Copy compilled nginx FROM stage and prepare
##################################################################
COPY --from=build ${NGINX_CONF_DIR} ${NGINX_CONF_DIR}
COPY --from=build ${NGINX_DIR} ${NGINX_DIR}

COPY --from=build ${OPENSSL_35_DIR} ${OPENSSL_35_DIR}
COPY --from=build ${PCRE_DIR} ${PCRE_DIR}
COPY --from=build ${ZLIB_DIR} ${ZLIB_DIR}
COPY --from=build ${ZSTD_DIR} ${ZSTD_DIR}
COPY --from=build ${LIBATOMICOPS_DIR} ${LIBATOMICOPS_DIR}
COPY --from=build ${LIBIMAGEQUANT_DIR} ${LIBIMAGEQUANT_DIR}
COPY --from=build ${LIBRAQM_DIR} ${LIBRAQM_DIR}
COPY --from=build ${MM_GEOIP_DIR} ${MM_GEOIP_DIR}
COPY --from=build ${GPERFTOOLS_DIR} ${GPERFTOOLS_DIR}
COPY --from=build ${LIBGD_DIR} ${LIBGD_DIR}
COPY --from=build ${LUAJIT2OR_DIR} ${LUAJIT2OR_DIR}
COPY --from=build ${LIBXSLT_DIR} ${LIBXSLT_DIR}
COPY --from=build ${LIBXML2_DIR} ${LIBXML2_DIR}
COPY --from=build ${IP2LOC_DIR} ${IP2LOC_DIR}

#COPY etc /etc

RUN set -eu; \
    for so in \
      ${OPENSSL_35_LIB_DIR}/libssl.so \
      ${LIBGD_LIB_DIR}/libgd.so \
      ${LIBRAQM_LIB_DIR}/libraqm.so \
      ${LIBIMAGEQUANT_LIB_DIR}/libimagequant.so \
      ${LIBXML2_LIB_DIR}/libxml2.so \
      ${LIBXSLT_LIB_DIR}/libxslt.so \
    ; do \
      test -f "$so" || { echo "FATAL: missing $so" >&2; ls -la "$(dirname $(dirname $so))" >&2; exit 1; }; \
    done; \
    echo "OK: copied libs present"

RUN mkdir -p \
      ${NGINX_CONF_DIR}/sites-enabled \
      ${NGINX_CONF_DIR}/modules-enabled \
      ${NGINX_LOCK_DIR} \
      ${NGINX_LOGS_DIR} \
      ${NGINX_PID_DIR} \
      ${NGINX_CACHE_DIR} \
      /var/www \
    && \
    mv ${NGINX_HTML_DIR} /var/www/ && \
    ln -sfv ${LUAJIT2OR_INC_DIR}/luajit-2.1/* ${LUAJIT2OR_INC_DIR}/ && \
    ln -sfv /etc/ssl/dhparam.pem ${NGINX_CONF_DIR}/dhparam.pem && \
    ln -sfv ${NGINX_CONF_DIR} ${NGINX_DIR}/etc && \
    ln -sfv ${NGINX_MODULES_DIR} ${NGINX_DIR}/modules && \
    ln -sfv ${NGINX_MODULES_PERL_DIR} ${NGINX_DIR}/modules-perl && \
    ln -sfv ${NGINX_CACHE_DIR} ${NGINX_DIR}/cache && \
    ln -sfv ${NGINX_LOGS_DIR} ${NGINX_DIR}/logs && \
    ln -sfv /dev/stdout /var/log/nginx/access.log && \
    ln -sfv /dev/stderr /var/log/nginx/error.log && \
    ln -sfv /var/lock/nginx ${NGINX_DIR}/lock && \
    ln -sfv /var/run/nginx ${NGINX_DIR}/run && \
    ln -sfv /var/www/html ${NGINX_HTML_DIR} && \
    rm -rfv \
        ${OPENSSL_35_DIR}/src \
        ${PCRE_DIR}/src \
        ${ZLIB_DIR}/src \
        ${ZSTD_DIR}/src \
        ${LIBATOMICOPS_DIR}/src \
        ${MM_GEOIP_DIR}/src \
        ${GPERFTOOLS_DIR}/src \
        ${LUAJIT2OR_DIR}/src \
        ${LIBXSLT_DIR}/src \
        ${LIBXML2_DIR}/src \
        ${IP2LOC_DIR}/src \
        ${LIBIMAGEQUANT_DIR}/src \
        ${LIBRAQM_DIR}/src \
        ${LIBGD_DIR}/src \
    && \
    ln -sfv ${NGINX_DIR} /usr/share/nginx

##################################################################
#                   Add nginx to $PATH
##################################################################
ENV PATH="${NGINX_SBIN_DIR}:${PATH}"

##################################################################
#                   Expose default nginx ports
##################################################################
EXPOSE 80 443

##################################################################
#                   Setup volume with nginx cache
##################################################################
VOLUME ["${NGINX_CACHE_DIR}"]

##################################################################
#                   Setup nginx workdir 
##################################################################
WORKDIR ${NGINX_DIR}

RUN set -eu; \
    echo "--- nginx linkage ---"; \
    ldd ${NGINX_SBIN_DIR}/nginx | grep -E 'lib(ssl|crypto)\.so'; \
    ldd ${NGINX_SBIN_DIR}/nginx | grep -q 'not found' \
      && { echo "FATAL: unresolved deps" >&2; ldd ${NGINX_SBIN_DIR}/nginx >&2; exit 1; }; \
    [ "$(ldd ${NGINX_SBIN_DIR}/nginx | grep -c 'libssl\.so')" = "1" ] \
      || { echo "FATAL: multiple libssl" >&2; exit 1; }; \
    [ "$(ldd ${NGINX_SBIN_DIR}/nginx | grep -c 'libcrypto\.so')" = "1" ] \
      || { echo "FATAL: multiple libcrypto" >&2; exit 1; }; \
    ldd ${NGINX_SBIN_DIR}/nginx | grep -q "${OPENSSL_35_LIB_DIR}/libssl" \
      || { echo "FATAL: nginx not linked against our OpenSSL" >&2; exit 1; }; \
    \
    echo "--- modules ---"; \
    for m in ${NGINX_MODULES_DIR}/*.so; do \
      ldd "$m" 2>/dev/null | grep -q 'not found' \
        && { echo "FATAL: $(basename $m) has unresolved deps" >&2; ldd "$m" >&2; exit 1; }; \
      if ldd "$m" 2>/dev/null | grep -E 'lib(ssl|crypto)\.so' | grep -qv "${EMG_LOCAL_BASE_DIR}"; then \
        echo "FATAL: $(basename $m) links system OpenSSL" >&2; \
        ldd "$m" | grep -E 'lib(ssl|crypto)\.so' >&2; exit 1; \
      fi; \
    done; \
    \
    echo "--- njs / quickjs ---"; \
    ldd ${NGINX_MODULES_DIR}/ngx_http_js_module.so | grep -qi quickjs \
      && { echo "FATAL: quickjs should be statically linked" >&2; exit 1; }; \
    \
    nginx -V; \
    nginx -t; \
    echo "OK: nginx ${NGINX_VERSION_FULL}"

CMD ["nginx", "-g", "daemon off;"]
