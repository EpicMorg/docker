##################################################################
#                   Start build process
##################################################################
FROM hub.epicm.org/epicmorg/debian:bookworm-develop AS builder
LABEL maintainer="EpicMorg DevTeam, developer@epicm.org"
ARG DEBIAN_FRONTEND=noninteractive

#RUN apt-get update && \
#    apt-get install -y  --allow-unauthenticated \
#    libedit-dev \
#    libreadline-dev

##################################################################
#                   ARGuments
##################################################################
ARG NGINX_TAG=latest
ARG NGINX_VERSION=1.25.3
ARG NGINX_DOWNLOAD_URL=http://nginx.org/download/nginx-${NGINX_VERSION}.tar.gz

ARG OPENSSL_VERSION=3.2.0
ARG OPENSSL_DOWNLOAD_URL=https://www.openssl.org/source/openssl-${OPENSSL_VERSION}.tar.gz

# PCRE source tarball
ARG PCRE_VERSION=10.42
ARG PCRE_DOWNLOAD_URL=https://github.com/PCRE2Project/pcre2/releases/download/pcre2-${PCRE_VERSION}/pcre2-${PCRE_VERSION}.tar.gz

# zlib source tarball
ARG ZLIB_VERSION=1.3
ARG ZLIB_DOWNLOAD_URL=https://zlib.net/fossils/zlib-${ZLIB_VERSION}.tar.gz


ARG BUILDS_DIR=/builds
ARG SRC_DIR=${BUILDS_DIR}/src
ARG EXPORT_DIR=${BUILDS_DIR}/export
ARG PRE_DIR=${BUILDS_DIR}/pre
ARG NGINX_SRC_DIR=${SRC_DIR}/nginx
ARG OPENSSL_SRC_DIR=${SRC_DIR}/openssl
ARG PCRE_SRC_DIR=${SRC_DIR}/pcre
ARG ZLIB_SRC_DIR=${SRC_DIR}/zlib
ARG LUAJIT_INC=/usr/local/include/luajit-2.1
ARG LUAJIT_LIB=/usr/local/lib

##################################################################
#                   Files and folders
##################################################################
RUN mkdir -p ${PRE_DIR}  ${NGINX_SRC_DIR} /usr/lib/nginx ${OPENSSL_SRC_DIR}  ${PCRE_SRC_DIR}-temp ${ZLIB_SRC_DIR}
#ADD pre/luajit2-description-pak ${PRE_DIR}
#ADD pre/nginx-description-pak ${PRE_DIR}
#ADD pre/ip2location-description-pak ${PRE_DIR}

##################################################################
#                   Files and folders
##################################################################
#RUN cd ${SRC_DIR} && \
#    openssl version && \
#    wget --no-check-certificate -nv --random-wait --retry-connrefused --continue ${OPENSSL_DOWNLOAD_URL} -P ${SRC_DIR}  && \
#    tar --verbose -xzf ${SRC_DIR}/openssl-${OPENSSL_VERSION}.tar.gz --strip-components=1 -C ${OPENSSL_SRC_DIR} && \
#    cd ${OPENSSL_SRC_DIR} && \
#    ./configure \
#      --no-shared \
#      --enable-weak-ssl-ciphers \
#      --enable-ktls && \
#    make && \
#    make install && \
#    openssl version && \
#    rm -rfv ${SRC_DIR}/openssl-${OPENSSL_VERSION}.tar.gz

RUN cd ${SRC_DIR} && \
    wget --no-check-certificate -nv --random-wait --retry-connrefused --continue ${PCRE_DOWNLOAD_URL} -P ${SRC_DIR}  && \
    tar --verbose -xzf ${SRC_DIR}/pcre2-${PCRE_VERSION}.tar.gz --strip-components=1 -C ${PCRE_SRC_DIR}-temp && \
    cp -rfv  ${PCRE_SRC_DIR}-temp ${PCRE_SRC_DIR} && \
    rm -rf ${PCRE_SRC_DIR}-temp && \
    cd ${PCRE_SRC_DIR} && \
    ./configure \
      --enable-shared \
      --enable-static \
      --enable-pcre2-16 \
      --enable-pcre2-32  \
      --enable-debug \
      --enable-jit  \
      --enable-newline-is-anycrlf \
      --enable-pcre2grep-libz  \
      --enable-pcre2grep-libbz2 \
      --enable-pcre2test-libedit  \
#      --enable-pcre2test-libreadline \
      --enable-unicode-properties \
      --enable-unicode \
#      --enable-valgrind \
      --enable-fuzz-support && \
    make && \
    make install && \
    rm -rfv ${SRC_DIR}/pcre2-${PCRE_VERSION}.tar.gz

RUN cd ${SRC_DIR} && \
    wget --no-check-certificate -nv --random-wait --retry-connrefused --continue ${ZLIB_DOWNLOAD_URL} -P ${SRC_DIR}  && \
    tar --verbose -xzf ${SRC_DIR}/zlib-${ZLIB_VERSION}.tar.gz --strip-components=1 -C ${ZLIB_SRC_DIR} && \
    rm -rfv ${SRC_DIR}/zlib-${ZLIB_VERSION}.tar.gz

##################################################################
#                   IP2Location support for prod nginx module
##################################################################
RUN cd ${SRC_DIR} && \
    git clone https://github.com/chrislim2888/IP2Location-C-Library.git ip2 && \
    cp -fv ${PRE_DIR}/ip2location-description-pak ${SRC_DIR}/ip2/description-pak && \
    cd ${SRC_DIR}/ip2 && \
    ls -las && \
    autoreconf -i -v --force && \
    aclocal && \
    automake --gnu --add-missing && \
    autoconf && \
    autoreconf -i -v --force && \
    ./configure && \
    ls -las && \
    make clean && \
    make && \
    make -C data convert && \
    make check && \
    ls -las && \
    fakeroot checkinstall -D --pakdir=${EXPORT_DIR} --maintainer="EpicMorg, developer@epicm.org" --pkgname=ip2-custom  --conflicts=ip2 --install=yes -y  && \
#    ln -sfv /usr/local/lib/libIP2Location.so /usr/lib/libIP2Location.so && \
    ln -sfv /usr/local/lib/libIP2Location.so.1 /usr/lib/libIP2Location.so.1 && \
    ln -sfv /usr/local/lib/libIP2Location.so.2 /usr/lib/libIP2Location.so.2 && \
    ln -sfv /usr/local/lib/libIP2Location.so.3 /usr/lib/libIP2Location.so.3 && \
    ln -sfv /usr/local/lib/libIP2Location.so.4 /usr/lib/libIP2Location.so.4 && \
    ln -sfv /usr/local/lib/libIP2Location.so.5 /usr/lib/libIP2Location.so.5 && \
    ln -sfv /lib/x86_64-linux-gnu/libcrypto.so.1.1 /lib/x86_64-linux-gnu/libcrypto.so.1 && \
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

#RUN cd ${SRC_DIR} && \
#    git clone https://gitlab.gnome.org/GNOME/libxml2.git libxml2-src && \
#    cd ${SRC_DIR}/libxml2-src && \
#    ./autogen.sh --prefix=/usr && \
#    make && \
#    make install&& \
#    git clone https://gitlab.gnome.org/GNOME/libxslt.git libxslt-src && \
#    ./autogen.sh --prefix=/usr && \
#    make && \
#    make install

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
    git clone https://github.com/kaprog/nginx-upload-progress-module http-uploadprogress && \
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
    --with-cc-opt='-I/usr/local/include/luajit-2.1 -I/builds/src/openssl/include  -g -O2 -lz -fstack-protector-strong -Wformat -Wno-error=date-time -Wno-error=implicit-fallthrough= -Wno-error=cast-function-type -Wno-error=format-security -Wno-error=implicit-function-declaration -Wno-error=deprecated-declarations -Wno-error=unused-result  -fPIC -Wdate-time -D_FORTIFY_SOURCE=2' \
    --with-ld-opt='-Wl,-z,relro -Wl,-z,now -lz -fPIC -Wl,-Bsymbolic-functions -Wl,-z,relro -Wl,-z,now -Wl,--as-needed -pie' \
#    --with-openssl \
    --with-openssl-opt='no-shared enable-weak-ssl-ciphers enable-ktls' \
    --with-pcre \
#    --with-pcre=/builds/src/pcre \
    --with-pcre-opt='--enable-shared --enable-static --enable-pcre2-16 --enable-pcre2-32 --enable-debug --enable-jit --enable-newline-is-anycrlf --enable-pcre2grep-libz --enable-pcre2grep-libbz2 --enable-pcre2test-libedit --enable-unicode-properties --enable-unicode --enable-fuzz-support' \
    --with-zlib=/builds/src/zlib \
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
    --with-http_v3_module \
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
    --with-http_xslt_module \
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
#    --add-dynamic-module=http-uploadprogress \ #not stable
    --add-dynamic-module=http-subs-filter \
    --add-dynamic-module=ssl-ct \
    --add-dynamic-module=http-geoip2 \
    --add-dynamic-module=spnego-http-auth-nginx-module \
    --add-dynamic-module=http-auth-ldap \
#    --add-dynamic-module=nginx-audio-track-for-hls-module \ #not stable
    --add-dynamic-module=ip2location-nginx \
    --add-dynamic-module=nginx-vod-module \
#    --add-dynamic-module=nginx-module-vts \ #not stable
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

RUN ls -las ${NGINX_SRC_DIR}

##################################################################
##################################################################
##################################################################

FROM hub.epicm.org/epicmorg/debian:bookworm
LABEL maintainer="EpicMorg DevTeam, developer@epicm.org"
ARG DEBIAN_FRONTEND=noninteractive

##################################################################
#                   LDAP Fix
##################################################################
RUN echo "TLS_REQCERT never" >> /etc/ldap/ldap.conf

##################################################################
#                   Installing nginx from deb
##################################################################
COPY ./pre/nginx-pre /tmp/nginx-pre
COPY --from=builder /builds/export /tmp/deb

RUN cp -rfv /tmp/nginx-pre/* / && \
    apt-get update && \
    apt-get install -y  --allow-unauthenticated \
    geoip-database \
    geoip-bin \
    libgeoip1 \
    libxml2 \
    libxml2-utils \
    libmaxminddb0 \
    libgd3 \
    libxslt1.1 && \
    dpkg --force-all -i /tmp/deb/*.deb && \
    ln -sfv /usr/local/lib/libIP2Location.so /usr/lib/libIP2Location.so && \
    ln -sfv /usr/local/lib/libIP2Location.so.1 /usr/lib/libIP2Location.so.1 && \
    ln -sfv /usr/local/lib/libIP2Location.so.2 /usr/lib/libIP2Location.so.2 && \
    ln -sfv /usr/local/lib/libIP2Location.so.3 /usr/lib/libIP2Location.so.3 && \
    ln -sfv /usr/local/lib/libIP2Location.so.4 /usr/lib/libIP2Location.so.4 && \
    ln -sfv /usr/local/lib/libIP2Location.so.5 /usr/lib/libIP2Location.so.5 && \
    ln -sfv /lib/x86_64-linux-gnu/libcrypto.so.1.1 /lib/x86_64-linux-gnu/libcrypto.so.1 && \
    ln -sfv /dev/stdout /var/log/nginx/access.log && \
    ln -sfv /dev/stderr /var/log/nginx/error.log && \
    ln -sfv /etc/ssl/dhparam.pem /etc/nginx/dhparam.pem && \
    apt clean -y && \
    apt autoclean -y && \
    rm -rfv /var/lib/apt/lists/* && \
    rm -rfv /var/cache/apt/archives/*.deb && \
    rm -rfv /root/tmp/* && \
    rm -rfv /tmp/* && \
    rm -rfv /builds/* && \
    rm -rfv /valve/*  && \
    rm -rfv /builds && \
    rm -rfv /valve

RUN nginx -V

#healthcheck. good practice
HEALTHCHECK --interval=2m --timeout=3s CMD curl -f http://localhost:80/ || exit 1

# Add image configuration and scripts
COPY ./docker-entrypoint.sh /usr/bin/docker-entrypoint.sh
RUN chmod +x /usr/bin/docker-entrypoint.sh

#Final config
VOLUME ["/var/cache/nginx"]
EXPOSE 80 443

ENTRYPOINT ["tini", "-s", "--", "docker-entrypoint.sh"]
CMD ["docker-entrypoint.sh"]
