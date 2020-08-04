##### Building the final image #####
FROM epicmorg/balancer

ARG  NGINX_RTMP_MODULE_VERSION=1.2.1

# Install dependencies
RUN apt-get update && \
    apt-get install -y \
        tree ca-certificates openssl libpcre3-dev \
        librtmp1 libtheora0 libvorbis-dev libmp3lame0 \
        libx264-dev libx265-dev && \
    wget http://ftp.br.debian.org/debian/pool/main/libv/libvpx/libvpx4_1.6.1-3+deb9u2_amd64.deb && \
    dpkg -i libvpx4_1.6.1-3+deb9u2_amd64.deb && \
    rm -rfv libvpx4_1.6.1-3+deb9u2_amd64.de  && \
    rm -rfv /var/lib/apt/lists/*

RUN mkdir -p /usr/share/nginx/html /mnt/hls /mnt/dash /tmp/build && \
    cd /tmp/build && \
    wget https://github.com/arut/nginx-rtmp-module/archive/v${NGINX_RTMP_MODULE_VERSION}.tar.gz && \
    tar -zxf v${NGINX_RTMP_MODULE_VERSION}.tar.gz && \
    rm v${NGINX_RTMP_MODULE_VERSION}.tar.gz && \
    cp /tmp/build/nginx-rtmp-module-${NGINX_RTMP_MODULE_VERSION}/stat.xsl /usr/share/nginx/html/stat.xsl && \
    rm -rf /tmp/build


# Forward logs to Docker
RUN ln -sf /dev/stdout /var/log/nginx/access.log && \
    ln -sf /dev/stderr /var/log/nginx/error.log

# Copy  nginx config file to container
RUN  rm -rfv /etc/nginx/nginx.conf
COPY conf/nginx.conf /etc/nginx/nginx.conf

# Copy  html players to container
COPY players /usr/share/nginx/html/players


EXPOSE 1935
EXPOSE 8080

CMD ["nginx", "-g", "daemon off;"]
