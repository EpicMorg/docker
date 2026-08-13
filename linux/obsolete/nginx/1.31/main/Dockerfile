##################################################################
##################################################################
##################################################################
#                   Temp Build Layer
##################################################################
##################################################################
##################################################################
FROM docker.io/epicmorg/gcc:14 
LABEL maintainer="EpicMorg DevTeam, developer@epicm.org"
ARG DEBIAN_FRONTEND=noninteractive

##################################################################
#                   Nginx
##################################################################
ENV NGINX_VERSION=1.31
ENV NGINX_VERSION_FULL=${NGINX_VERSION}.1
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
ARG NGINX_TEMP=/tmp/nginx-${NGINX_VERSION_FULL}.tar.gz
ARG NGINX_TEMP_SRC=/tmp/nginx-${NGINX_VERSION_FULL}

# NJS
ENV NJS_VERSION=0.9.1
ARG NJS_DOWNLOAD_URL=https://github.com/nginx/njs

##################################################################
#                   Prepare Nginx
##################################################################
RUN mkdir -p ${NGINX_DIR} ${NGINX_SRC_DIR}
ADD ${NGINX_DOWNLOAD_URL} /tmp

WORKDIR ${NGINX_TEMP_SRC}

RUN tar -xf ${NGINX_TEMP} --directory /tmp && \ 
#
    git clone  --depth 1 --branch ${NJS_VERSION} ${NJS_DOWNLOAD_URL} modules/nginx-njs && \
#
    git clone https://github.com/openresty/headers-more-nginx-module modules/http-headers-more-filter  && \
    git clone https://github.com/sto/ngx_http_auth_pam_module modules/http-auth-pam  && \
    git clone https://github.com/openresty/lua-nginx-module modules/http-lua && \
    git clone https://github.com/chrislim2888/ip2location-nginx modules/ip2location-nginx && \
    git clone https://github.com/leev/ngx_http_geoip2_module modules/http-geoip2 && \
#
    git clone https://github.com/arut/nginx-dav-ext-module modules/http-dav-ext && \
    git clone https://github.com/openresty/echo-nginx-module modules/http-echo && \
    git clone https://github.com/aperezdc/ngx-fancyindex modules/http-fancyindex && \
    git clone https://github.com/slact/nchan modules/nchan && \
    git clone https://github.com/masterzen/nginx-upload-progress-module modules/http-uploadprogress && \
    git clone https://github.com/yaoweibin/ngx_http_substitutions_filter_module modules/http-subs-filter && \
    git clone https://github.com/grahamedgecombe/nginx-ct modules/ssl-ct && \
    git clone https://github.com/stnoonan/spnego-http-auth-nginx-module modules/spnego-http-auth-nginx-module && \
    git clone https://github.com/flavioribeiro/nginx-audio-track-for-hls-module modules/nginx-audio-track-for-hls-module && \
    git clone https://github.com/kaltura/nginx-vod-module modules/nginx-vod-module && \
    git clone https://github.com/vozlt/nginx-module-vts modules/nginx-module-vts && \
    git clone https://github.com/evanmiller/mod_zip modules/mod-zip && \
    git clone https://github.com/alibaba/nginx-http-user-agent modules/nginx-http-user-agent && \
    git clone https://github.com/youzee/nginx-unzip-module modules/nginx-unzip-module && \
    git clone https://github.com/vladbondarenko/ngx_webp modules/ngx-webp && \
    git clone https://github.com/openresty/xss-nginx-module modules/xss-nginx-module && \
    git clone https://github.com/openresty/set-misc-nginx-module modules/set-misc-nginx-module && \
    git clone https://github.com/arut/nginx-rtmp-module modules/rtmp && \
    git clone https://github.com/kvspb/nginx-auth-ldap modules/http-auth-ldap && \
    git clone https://github.com/simplresty/ngx_devel_kit modules/http-ndk && \
    git clone https://github.com/itoffshore/nginx-upstream-fair modules/http-upstream-fair && \
    git clone https://github.com/yaoweibin/nginx_upstream_check_module modules/nginx-upstream-check-module

RUN export NGNX_CFLAGS="-fstack-protector-strong -fpic -fpie -O2 -D_LARGEFILE_SOURCE -D_FILE_OFFSET_BITS=64" \
    export NGNX_CPPFLAGS="${NGNX_CFLAGS}" \
    export NGNX_LDFLAGS="-Wl,-O1 -pie" \
    export CC="${GCC_INSTALL_DIR}/bin/gcc" \
    export CXX="${GCC_INSTALL_DIR}/bin/g++" \
    debMultiarch="$(dpkg-architecture --query DEB_BUILD_MULTIARCH)" \
    export PKG_CONFIG_PATH="${LIBATOMICOPS_LIB_DIR}/pkgconfig:${ZLIB_LIB_DIR}/pkgconfig:${PCRE_LIB_DIR}/pkgconfig:${OPENSSL_35_LIB_DIR}/pkgconfig:${PKG_CONFIG_PATH:-}" \
    export CFLAGS="${NGNX_CFLAGS}" \
    export CPPFLAGS="-I${OPENSSL_35_INC_DIR} ${NGNX_CPPFLAGS}" \
    export LDFLAGS="-L${OPENSSL_35_LIB_DIR} -Wl,-rpath,${OPENSSL_35_LIB_DIR} -Wl,-rpath,${NGNX_DIR}/lib ${NGNX_LDFLAGS}" \
    ./configure \
        --with-cc-opt="-I${IP2LOC_INC_DIR} \
                -I${LIBXML2_INC_DIR} \
                -I${LIBXSLT_INC_DIR} \
                -I${LUAJIT2OR_INC_DIR} \
                -I${LIBGD_INC_DIR} \
                -I${GPERFTOOLS_INC_DIR} \
                -I${MM_GEOIP_INC_DIR} \
                -I${LIBATOMICOPS_INC_DIR} \
                -I${OPENSSL_35_INC_DIR} \
                -I${ZLIB_INC_DIR} \
                -I${PCRE_INC_DIR} \
                -I/usr/include/x86_64-linux-gnu/libavcodec \
                -I/usr/include/x86_64-linux-gnu \
                -I/usr/include \
                -g -O2 -lz -fPIC" \
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
            --with-http_geoip_module \
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
            --with-mail  \
            --with-mail_ssl_module \
            --with-stream  \
            --with-stream_ssl_module \
            --with-stream_realip_module \
            --with-stream_geoip_module \
            --with-stream_ssl_preread_module \
            --with-cpp_test_module \
            --with-http_xslt_module \
            --with-compat \
        && \
        make -j$(nproc) && \
        make -j$(nproc) install


#      --add-module=modules/http-headers-more-filter \
 #     --add-module=modules/nginx-http-user-agent \
  #    --add-module=modules/http-ndk \
   #   --add-module=modules/http-echo \
    #  --add-module=modules/http-fancyindex \
     # --add-module=modules/nchan \
      #--add-module=modules/http-uploadprogress \
#      --add-module=modules/http-subs-filter \
 #     --add-module=modules/mod-zip \
  #    --add-module=modules/http-geoip2 \
   #   --add-module=modules/nginx-vod-module \
    #  --add-module=modules/ngx-webp \
     # --add-module=modules/set-misc-nginx-module \
#      --add-module=modules/rtmp \
 #     --add-module=modules/http-upstream-fair \
  #    --add-module=modules/nginx-upstream-check-module \
## xslt fuck 
##      --with-http_xslt_module \
## xslt fuck 
##  --add-module=modules/nginx-njs/nginx \  
## lua fuck 
##     --add-module=modules/http-lua \
## ip2location fuck 
##      --add-module=modules/ip2location-nginx \
## xslt fuck 
##      --add-module=modules/http-dav-ext \
## gd fuck 
##       --with-http_image_filter_module \
## perftools fuck 
##      --with-google_perftools_module \
## perl problem fuck
##      --with-http_perl_module \
##
##      --with-perl_modules_path=${NGINX_MODULES_PERL_DIR} \
## some compile fuck
##       --add-module=modules/http-auth-pam \
## some compile fuck
##    --add-module=modules/nginx-audio-track-for-hls-module \
## some compile fuck
##    --add-module=modules/nginx-module-vts \
## some compile fuck
##     --add-module=modules/nginx-unzip-module \
## some compile fuck
##      --add-module=modules/spnego-http-auth-nginx-module \
## ssl outdated compile fuck
##--add-module=modules/ssl-ct \
##  undefined reference to `sasl_getprop'
##     --add-module=modules/http-auth-ldap \

