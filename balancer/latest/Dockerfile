FROM epicmorg/devel AS builder
LABEL maintainer="EpicMorg DevTeam, developer@epicm.org"
ARG DEBIAN_FRONTEND=noninteractive


##################################################################
#                   ARGuments
##################################################################
ENV BuildDocker true
ARG BUILDS_DIR=/builds
ARG SRC_DIR=${BUILDS_DIR}/src
ARG EXPORT_DIR=${BUILDS_DIR}/export
ARG PRE_DIR=${BUILDS_DIR}/pre
ARG NGINX_SRC_DIR=${SRC_DIR}/nginx
ARG NGINX_VERSION=1.17.8
ARG NGINX_DOWNLOAD_URL=http://nginx.org/download/nginx-${NGINX_VERSION}.tar.gz
ARG LUAJIT_INC=/usr/local/include/luajit-2.1
ARG LUAJIT_LIB=/usr/local/lib

##################################################################
#                   Files and folders
##################################################################
RUN mkdir -p ${PRE_DIR}  ${NGINX_SRC_DIR} /usr/lib/nginx
ADD pre/luajit2-description-pak ${PRE_DIR}
ADD pre/nginx-description-pak ${PRE_DIR}
ADD pre/ip2location-description-pak ${PRE_DIR}


##################################################################
#                   IP2Location support for prod nginx module
##################################################################
RUN cd ${SRC_DIR} && \
    git clone https://github.com/chrislim2888/IP2Location-C-Library.git ip2 && \
    cp -fv ${PRE_DIR}/ip2location-description-pak ${SRC_DIR}/ip2/description-pak && \
    cd ${SRC_DIR}/ip2 && \
    ./build.sh && \
    fakeroot checkinstall -D --pakdir=${EXPORT_DIR} --maintainer="EpicMorg, developer@epicm.org" --pkgname=ip2-custom  --conflicts=ip2 --install=yes -y  && \
    ln -s /usr/local/lib/libIP2Location.so /usr/lib/libIP2Location.so && \
    ln -s /usr/local/lib/libIP2Location.so.1 /usr/lib/libIP2Location.so.1 && \
    ln -s /usr/local/lib/libIP2Location.so /lib/libIP2Location.so && \
    ln -s /usr/local/lib/libIP2Location.so.1 /lib/libIP2Location.so.1 && \
    dpkg --force-all -i ${EXPORT_DIR}/*.deb

##################################################################
#                   luaJIT 2 support for prod nginx module
##################################################################
RUN cd ${SRC_DIR} && \
    git clone https://github.com/openresty/luajit2.git luajit2 && \
    cp -fv ${PRE_DIR}/luajit2-description-pak ${SRC_DIR}/luajit2/description-pak && \
    cd ${SRC_DIR}/luajit2 && \
    make && \
    make install  && \
    fakeroot checkinstall -D --pakdir=${EXPORT_DIR} --maintainer="EpicMorg, developer@epicm.org" --pkgname=luajit2-custom  --conflicts=luajit2 --install=no -y

##################################################################
#                   nginx preparing
##################################################################
RUN wget -qO - ${NGINX_DOWNLOAD_URL} | tar -zxv --strip-components=1 -C ${NGINX_SRC_DIR} && \
    cd ${NGINX_SRC_DIR} && \
    git clone https://github.com/openresty/headers-more-nginx-module.git http-headers-more-filter && \
    git clone https://github.com/sto/ngx_http_auth_pam_module.git http-auth-pam && \
    git clone https://github.com/arut/nginx-dav-ext-module.git http-dav-ext && \
    git clone https://github.com/openresty/echo-nginx-module.git http-echo && \
    git clone https://github.com/aperezdc/ngx-fancyindex.git http-fancyindex && \
    git clone https://github.com/slact/nchan.git nchan && \
    git clone https://github.com/masterzen/nginx-upload-progress-module.git http-uploadprogress && \
    git clone https://github.com/yaoweibin/ngx_http_substitutions_filter_module http-subs-filter && \
    git clone https://github.com/grahamedgecombe/nginx-ct.git ssl-ct && \
    git clone https://github.com/stnoonan/spnego-http-auth-nginx-module.git spnego-http-auth-nginx-module && \
    git clone https://github.com/leev/ngx_http_geoip2_module http-geoip2 && \
    git clone https://github.com/flavioribeiro/nginx-audio-track-for-hls-module.git nginx-audio-track-for-hls-module && \
    git clone https://github.com/chrislim2888/ip2location-nginx.git ip2location-nginx && \
    git clone https://github.com/kaltura/nginx-vod-module.git nginx-vod-module && \
    git clone https://github.com/vozlt/nginx-module-vts.git nginx-module-vts && \
    git clone https://github.com/evanmiller/mod_zip.git mod-zip && \
    git clone https://github.com/alibaba/nginx-http-user-agent.git nginx-http-user-agent && \
    git clone https://github.com/youzee/nginx-unzip-module.git nginx-unzip-module && \
    git clone https://github.com/vladbondarenko/ngx_webp.git ngx-webp && \
    git clone https://github.com/openresty/xss-nginx-module.git xss-nginx-module && \
    git clone https://github.com/openresty/set-misc-nginx-module.git set-misc-nginx-module && \
    git clone https://github.com/arut/nginx-rtmp-module.git rtmp && \
    git clone https://github.com/kvspb/nginx-auth-ldap.git http-auth-ldap && \
    git clone https://github.com/simplresty/ngx_devel_kit.git http-ndk && \
    git clone https://github.com/chrislim2888/IP2Location-C-Library.git ip2location-c-7.0.0 && \
    git clone https://github.com/itoffshore/nginx-upstream-fair.git http-upstream-fair && \
    git clone https://github.com/yaoweibin/nginx_upstream_check_module.git nginx-upstream-check-module && \
    git clone https://github.com/openresty/lua-nginx-module http-lua

##################################################################
#                   nginx compilling
##################################################################
RUN cd ${NGINX_SRC_DIR} && \
    ./configure  \
    --sbin-path=/usr/sbin/nginx \
    --prefix=/usr/share/nginx \
    --conf-path=/etc/nginx/nginx.conf  \
    --http-log-path=/var/log/nginx/access.log \
    --error-log-path=/var/log/nginx/error.log \
    --lock-path=/var/lock/nginx.lock \
    --pid-path=/run/nginx.pid \
    --modules-path=/usr/lib/nginx/modules \
    --http-client-body-temp-path=/var/lib/nginx/body \
    --http-fastcgi-temp-path=/var/lib/nginx/fastcgi \
    --http-proxy-temp-path=/var/lib/nginx/proxy \
    --http-scgi-temp-path=/var/lib/nginx/scgi \
    --http-uwsgi-temp-path=/var/lib/nginx/uwsgi \
    --with-cc-opt='-I/usr/local/include/luajit-2.1 -g -O2 -lz -fstack-protector-strong -Wformat -Wno-error=date-time -Wno-error=implicit-fallthrough= -Wno-error=cast-function-type -Wno-error=format-security -Wno-error=implicit-function-declaration -Wno-error=deprecated-declarations -Wno-error=unused-result  -fPIC -Wdate-time -D_FORTIFY_SOURCE=2' \
    --with-ld-opt='-Wl,-z,relro -Wl,-z,now -lz -fPIC -L/usr/local/lib' \
    --with-file-aio \
    --with-compat \
    --with-debug \
    --with-threads \
    --with-pcre-jit \
    --with-http_ssl_module \
    --with-http_stub_status_module \
    --with-http_realip_module \
    --with-http_auth_request_module \
    --with-http_v2_module \
    --with-http_dav_module \
    --with-http_slice_module \
    --with-http_addition_module \
    --with-http_flv_module \
    --with-http_geoip_module=dynamic \
    --with-http_gunzip_module \
    --with-http_gzip_static_module \
    --with-http_image_filter_module=dynamic \
    --with-http_mp4_module \
    --with-http_perl_module=dynamic \
    --with-http_random_index_module \
    --with-http_secure_link_module \
    --with-http_sub_module \
    --with-http_xslt_module=dynamic \
    --with-mail=dynamic \
    --with-mail_ssl_module \
    --with-stream=dynamic \
    --with-stream_ssl_module \
    --with-stream_ssl_preread_module \
    --add-dynamic-module=http-headers-more-filter \
    --add-dynamic-module=http-auth-pam \
    --add-dynamic-module=http-dav-ext \
    --add-dynamic-module=http-ndk \
    --add-dynamic-module=http-echo \
    --add-dynamic-module=http-fancyindex \
    --add-dynamic-module=nchan \
    --add-dynamic-module=http-uploadprogress \
    --add-dynamic-module=http-subs-filter \
    --add-dynamic-module=ssl-ct \
    --add-dynamic-module=http-geoip2 \
    --add-dynamic-module=spnego-http-auth-nginx-module \
    --add-dynamic-module=http-auth-ldap \
    --add-dynamic-module=nginx-audio-track-for-hls-module \
    --add-dynamic-module=ip2location-nginx \
    --add-dynamic-module=nginx-vod-module \
    --add-dynamic-module=nginx-module-vts \
    --add-dynamic-module=mod-zip \
    --add-dynamic-module=nginx-http-user-agent \
    --add-dynamic-module=nginx-unzip-module \
    --add-dynamic-module=ngx-webp \
    --add-dynamic-module=set-misc-nginx-module \
    --add-dynamic-module=rtmp \
    --add-dynamic-module=http-upstream-fair \
    --add-dynamic-module=nginx-upstream-check-module \
    --add-dynamic-module=http-lua && \
    cp -fv ${PRE_DIR}/nginx-description-pak ${NGINX_SRC_DIR}/description-pak && \
    fakeroot checkinstall -D --pakdir=/builds/export --maintainer="EpicMorg, developer@epicm.org" --pkgname=nginx-custom  --install=no -y && \

    apt clean -y && \
    apt autoclean -y && \
    rm -rfv /var/lib/apt/lists/* && \
    rm -rfv /var/cache/apt/archives/*.deb

##################################################################
##################################################################
##################################################################

FROM epicmorg/edge
LABEL maintainer="EpicMorg DevTeam, developer@epicm.org"
ARG DEBIAN_FRONTEND=noninteractive

##################################################################
#                   Installing nginx from deb
##################################################################
ADD pre/ngninx.pre.tar.gz /
COPY --from=builder /builds/export /tmp/deb
RUN apt-get update && \
    apt-get install -y  --allow-unauthenticated \
    geoip-database \
    geoip-bin \
    libgeoip1 \
    libmaxminddb0 \
    libgd3 \
    libxslt1.1 && \
    dpkg --force-all -i /tmp/deb/*.deb && \
    ln -s /usr/local/lib/libIP2Location.so /usr/lib/libIP2Location.so && \
    ln -s /usr/local/lib/libIP2Location.so.1 /usr/lib/libIP2Location.so.1 && \
    ln -s /usr/local/lib/libIP2Location.so /lib/libIP2Location.so && \
    ln -s /usr/local/lib/libIP2Location.so.1 /lib/libIP2Location.so.1 && \
    ln -sf /dev/stdout /var/log/nginx/access.log && \
    ln -sf /dev/stderr /var/log/nginx/error.log && \
    ln -sf /etc/ssl/dhparam.pem /etc/nginx/dhparam.pem && \

    apt clean -y && \
    apt autoclean -y && \
    rm -rf /var/lib/apt/lists/* && \
    rm -rf /var/cache/apt/archives/*.deb && \
    rm -rf /tmp/deb/* && \
    rm -rf /builds/* && \
    rm -rf /valve/*

#Final config
VOLUME ["/var/cache/nginx"]
EXPOSE 80 443

CMD ["nginx", "-g", "daemon off;"]
