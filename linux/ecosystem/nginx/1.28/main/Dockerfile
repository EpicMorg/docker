##################################################################
##################################################################
##################################################################
#                   Temp Build Layer
##################################################################
##################################################################
##################################################################
FROM quay.io/epicmorg/debian:bookworm-develop AS build
LABEL maintainer="EpicMorg DevTeam, developer@epicm.org"
ARG DEBIAN_FRONTEND=noninteractive

##################################################################
#                   Nginx
##################################################################
ENV NGINX_VERSION=1.28
ENV NGINX_VERSION_FULL=${NGINX_VERSION}.0
ENV NGINX_DIR=${EMG_LOCAL_BASE_DIR}/nginx/${NGINX_VERSION}
ENV NGINX_BIN_DIR=${NGINX_SBIN_DIR}
ENV NGINX_CONF_DIR=/etc/nginx
ENV NGINX_MODULES_DIR=${NGINX_CONF_DIR}/modules
ENV NGINX_MODULES_PERL_DIR=${NGINX_CONF_DIR}/modules-perl
ENV NGINX_SBIN_DIR=${NGINX_DIR}/sbin
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
ENV NJS_VERSION=0.8.10
ARG NJS_DOWNLOAD_URL=https://github.com/nginx/njs

##################################################################
#                   Prepare zlib
##################################################################
WORKDIR ${ZLIB_SRC_DIR}
RUN CFLAGS="-Wno-error -fPIC" CXXFLAGS="-fPIC" ./configure \
      --prefix=${ZLIB_DIR}

##################################################################
#                   Prepare pcre2
##################################################################
WORKDIR ${PCRE_SRC_DIR}
RUN CFLAGS="-Wno-error -fPIC" CXXFLAGS="-fPIC" ./configure --prefix=${PCRE_DIR} \
        --disable-silent-rules \
        --enable-shared \
        --enable-static \
        --enable-rebuild-chartables \
        --enable-pcre2-8 \
        --enable-pcre2-16 \
        --enable-pcre2-32 \
        --enable-jit \
        --enable-newline-is-cr \
        --enable-newline-is-lf \
        --enable-newline-is-anycrlf \
        --enable-newline-is-any \
        --enable-newline-is-nul \
        --enable-bsr-anycrlf \
        --enable-pcre2grep-libz \
        --enable-pcre2grep-libbz2 \
        --enable-pcre2test-libedit \
        --enable-unicode \
        --enable-valgrind \
        --enable-fuzz-support \
        --enable-diff-fuzz-support

##################################################################
#                   Prepare openssl
##################################################################
WORKDIR ${OPENSSL_35_SRC_DIR}
RUN CFLAGS="-Wno-error -fPIC" CXXFLAGS="-fPIC" ./config \
      zlib \
      --with-zlib-include=${ZLIB_DIR}/include \
      --with-zlib-lib=${ZLIB_DIR}/lib \
      --with-zstd-include=${ZSTD_DIR}/include \
      --with-zstd-lib=${ZSTD_DIR}/lib \
      enable-ktls \
      enable-ec_nistp_64_gcc_128 \
      enable-egd \
      enable-ssl-trace\
      enable-trace \
      threads \
      sctp \
      shared \
      --release \
      --prefix=${OPENSSL_35_DIR} && \
    cp -rfv ${OPENSSL_35_INC_DIR}/* /usr/local/include && \
    cp -rfv ${OPENSSL_35_LIB_DIR}/* /usr/local/lib

##################################################################
#                   Prepare IP2Location-C-Library
##################################################################
WORKDIR ${IP2LOC_SRC_DIR}
RUN autoreconf -i -v --force && \
    aclocal && \
    automake --gnu --add-missing && \
    autoconf && \
    autoreconf -i -v --force && \
    CFLAGS="-Wno-error -fPIC" CXXFLAGS="-fPIC" ./configure \
      --prefix=${IP2LOC_DIR} \
      --disable-silent-rules \
      --enable-shared \
      --enable-static

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

RUN CFLAGS="-Wno-error -fPIC" CXXFLAGS="-fPIC" ./configure \
      --user=www-data \
      --group=www-data \
      --prefix=${NGINX_DIR} \
      --sbin-path=${NGINX_SBIN_DIR}/nginx \
      --conf-path=${NGINX_CONF_DIR}/nginx.conf  \
      --http-log-path=${NGINX_LOGS_DIR}/access.log \
      --error-log-path=${NGINX_LOGS_DIR}/error.log \
      --modules-path=${NGINX_MODULES_DIR} \
      --with-perl_modules_path=${NGINX_MODULES_PERL_DIR} \
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
                     -I${LIBGD_INC_DIR} \
                     -I${GPERFTOOLS_INC_DIR} \
                     -I${MM_GEOIP_INC_DIR} \
                     -I${LIBATOMICOPS_INC_DIR} \
                     -I/usr/include/x86_64-linux-gnu/libavcodec \
                     -I/usr/include/x86_64-linux-gnu \
                     -I/usr/include \
                     -static -g -O2 -lz -fPIC -Wdate-time -D_FORTIFY_SOURCE=2 -fstack-protector-strong \
                     -Wno-error=unused-but-set-variable -Wformat -Wno-error=date-time -Wno-error=implicit-fallthrough \
                     -Wno-error=cast-function-type -Wno-error=format-security -Wno-error=implicit-function-declaration \
                     -Wno-error=deprecated-declarations -Wno-error=unused-result" \
      --with-ld-opt="-L${IP2LOC_LIB_DIR} \
                     -L${LIBXML2_LIB_DIR} \
                     -L${LIBXSLT_LIB_DIR} \
                     -L${LUAJIT2OR_LIB_DIR} \
                     -L${LIBGD_LIB_DIR} \
                     -L${GPERFTOOLS_LIB_DIR} \
                     -L${MM_GEOIP_LIB_DIR} \
                     -L${LIBATOMICOPS_LIB_DIR} \
                     -L/usr/lib/x86_64-linux-gnu \
                     -L/usr/lib \
                     -static -Wl,-z,relro -Wl,-z,now -lz -fPIC" \  
      --with-pcre=${PCRE_SRC_DIR} \
      --with-pcre-jit \
      --with-zlib=${ZLIB_SRC_DIR} \
#      --with-zlib-opt="--static" \
      --with-libatomic \
      --with-openssl=${OPENSSL_35_SRC_DIR} \
      --with-openssl-opt="shared zlib --with-zlib-include=${ZLIB_INC_DIR} --with-zlib-lib=${ZLIB_LIB_DIR} --with-zstd-include=${ZSTD_INC_DIR} --with-zstd-lib=${ZSTD_LIB_DIR}  enable-ktls enable-ec_nistp_64_gcc_128 enable-egd enable-ssl-trace enable-trace threads sctp --release" \
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
      --add-module=modules/http-headers-more-filter \
      --add-module=modules/nginx-http-user-agent \
      --add-module=modules/http-ndk \
      --add-module=modules/http-echo \
      --add-module=modules/http-fancyindex \
      --add-module=modules/nchan \
      --add-module=modules/http-uploadprogress \
      --add-module=modules/http-subs-filter \
      --add-module=modules/mod-zip \
      --add-module=modules/http-geoip2 \
      --add-module=modules/nginx-vod-module \
      --add-module=modules/ngx-webp \
      --add-module=modules/set-misc-nginx-module \
      --add-module=modules/rtmp \
      --add-module=modules/http-upstream-fair \
      --add-module=modules/nginx-upstream-check-module \
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
      && \
    make -j$(nproc) && \
    make -j$(nproc) install

RUN rm -rfv ${NGINX_CONF_DIR}/nginx.conf && \
    mkdir -p ${NGINX_MODULES_DIR} ${NGINX_MODULES_PERL_DIR}

##################################################################
#                  Cleanup
##################################################################
RUN echo "clean up" && \
    apt-get clean -y && \
    apt-get autoclean -y && \
    rm -rfv /var/lib/apt/lists/* && \
    rm -rfv /var/cache/apt/archives/*.deb && \
    rm -rfv /root/tmp/* && \
    rm -rfv /tmp/*

RUN updatedb

##################################################################
##################################################################
##################################################################
#                   Main Final Layer
##################################################################
##################################################################
##################################################################
FROM quay.io/epicmorg/debian:bookworm

ENV NGINX_VERSION=1.28
ENV NGINX_VERSION_FULL=${NGINX_VERSION}.0
ENV NGINX_DIR=${EMG_LOCAL_BASE_DIR}/nginx/${NGINX_VERSION}
ENV NGINX_BIN_DIR=${NGINX_SBIN_DIR}
ENV NGINX_CONF_DIR=/etc/nginx
ENV NGINX_MODULES_DIR=${NGINX_CONF_DIR}/modules
ENV NGINX_MODULES_PERL_DIR=${NGINX_CONF_DIR}/modules-perl
ENV NGINX_SBIN_DIR=${NGINX_DIR}/sbin
ENV NGINX_CACHE_DIR=/var/cache/nginx
ENV NGINX_LOGS_DIR=/var/log/nginx
ENV NGINX_LOCK_DIR=/var/lock/nginx
ENV NGINX_LOCK=${NGINX_LOCK_DIR}/nginx.lock
ENV NGINX_HTML_DIR=${NGINX_DIR}/html
ENV NGINX_PID_DIR=/run/nginx
ENV NGINX_PID=${NGINX_PID_DIR}/nginx.pid
ENV NGINX_SRC_DIR=/usr/local/src/nginx/${NGINX_VERSION}

##################################################################
#        Copy compilled nginx from dev stage and prepare
##################################################################
RUN mkdir -p \
      ${NGINX_CONF_DIR}/sites-enabled \
      ${NGINX_CONF_DIR}/modules-enabled \
      ${NGINX_LOCK_DIR} \
      ${NGINX_LOGS_DIR} \
      ${NGINX_PID_DIR} \
      ${NGINX_SRC_DIR} \
      /var/www

COPY --from=build ${NGINX_SRC_DIR} ${NGINX_SRC_DIR}
COPY --from=build ${NGINX_CONF_DIR} ${NGINX_CONF_DIR}
COPY --from=build ${NGINX_DIR} ${NGINX_DIR}
COPY etc /etc

RUN mv ${NGINX_HTML_DIR} /var/www/ &\
    ln -sfv /etc/ssl/dhparam.pem ${NGINX_CONF_DIR}/dhparam.pem && \
    ln -sfv ${NGINX_MODULES_DIR} ${NGINX_DIR}/modules && \
    ln -sfv ${NGINX_MODULES_PERL_DIR} ${NGINX_DIR}/modules-perl && \
    ln -sfv ${NGINX_CACHE_DIR} ${NGINX_DIR}/cache && \
    ln -sfv ${NGINX_LOGS_DIR} ${NGINX_DIR}/logs && \
    ln -sfv /dev/stdout /var/log/nginx/access.log && \
    ln -sfv /dev/stderr /var/log/nginx/error.log && \
    ln -sfv /var/lock/nginx ${NGINX_DIR}/lock && \
    ln -sfv /var/run/nginx ${NGINX_DIR}/run && \
    ln -sfv /etc/nginx ${NGINX_DIR}/etc && \
    ln -sfv /var/www/html ${NGINX_HTML_DIR} && \
    ln -sfv ${NGINX_SRC_DIR} ${NGINX_DIR}/src && \
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

##################################################################
#                  Cleanup
##################################################################
RUN echo "clean up" && \
    apt-get clean -y && \
    apt-get autoclean -y && \
    rm -rfv /var/lib/apt/lists/* && \
    rm -rfv /var/cache/apt/archives/*.deb && \
    rm -rfv /root/tmp/* && \
    rm -rfv /tmp/*

RUN updatedb

##################################################################
#                   Run nginx in foreground
##################################################################
RUN nginx -V

CMD ["nginx", "-g", "daemon off;"]
