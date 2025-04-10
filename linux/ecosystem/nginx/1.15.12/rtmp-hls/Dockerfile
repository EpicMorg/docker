##################################################################
#                   Set Global ARG to build process
##################################################################
ARG NGINX_VERSION

##################################################################
#                   Start build process
##################################################################
FROM hub.epicm.org/epicmorg/nginx:${NGINX_VERSION}
LABEL maintainer="EpicMorg DevTeam, developer@epicm.org"
ARG DEBIAN_FRONTEND=noninteractive

ARG  NGINX_RTMP_MODULE_VERSION=1.2.1

##################################################################
#                   Clear sources.list.d
##################################################################
RUN rm -rfv /etc/apt/sources.list.d/*

##################################################################
#                   sid sources list
##################################################################
RUN rm -rfv /etc/apt/sources.list
COPY sources.list.d/sources.sid.list /etc/apt/sources.list
RUN  apt-get update

##################################################################
#                   installing utils
##################################################################
RUN echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections && \
    apt-get update &&  \
    apt-get install -y --allow-unauthenticated --no-install-recommends --no-install-suggests \
    libpcre3-dev \
    librtmp1 \
    libtheora0 \
    libvorbis-dev \
    libmp3lame0 \
    libx264-dev \
    libx265-dev


##################################################################
#                   stretch  sources list + libvpx
##################################################################
RUN rm -rfv /etc/apt/sources.list
COPY sources.list.d/sources.stretch.list /etc/apt/sources.list
RUN echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections && \
    apt-get update &&  \
    apt-get install -y --allow-unauthenticated --no-install-recommends --no-install-suggests \
    libvpx4


##################################################################
#                   buster sources list + libvpx
##################################################################
RUN rm -rfv /etc/apt/sources.list
COPY sources.list.d/sources.buster.list /etc/apt/sources.list
RUN echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections && \
    apt-get update &&  \
    apt-get install -y --allow-unauthenticated --no-install-recommends --no-install-suggests \
    libvpx5


##################################################################
#                   sid sources list + libvpx
##################################################################
RUN rm -rfv /etc/apt/sources.list
COPY sources.list.d/sources.sid.list /etc/apt/sources.list
RUN echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections && \
    apt-get update &&  \
    apt-get install -y --allow-unauthenticated --no-install-recommends --no-install-suggests \
    libvpx6


##################################################################
#                   installing deps for rtmp module
##################################################################
RUN mkdir -p /usr/share/nginx/html \
             /mnt/hls \
             /mnt/dash \
             /tmp/build && \
    chown -R www-data:www-data /mnt/hls && \
    chown -R www-data:www-data /mnt/dash && \
    chmod -R 755 /mnt/hls && \
    chmod -R 755 /mnt/dash && \
    cd /tmp/build && \
    wget https://github.com/arut/nginx-rtmp-module/archive/v${NGINX_RTMP_MODULE_VERSION}.tar.gz && \
    tar -zxf v${NGINX_RTMP_MODULE_VERSION}.tar.gz && \
    rm v${NGINX_RTMP_MODULE_VERSION}.tar.gz && \
    cp /tmp/build/nginx-rtmp-module-${NGINX_RTMP_MODULE_VERSION}/stat.xsl /usr/share/nginx/html/stat.xsl && \
    rm -rf /tmp/build


##################################################################
#                  Forward logs to Docker
##################################################################
RUN ln -sf /dev/stdout /var/log/nginx/access.log && \
    ln -sf /dev/stderr /var/log/nginx/error.log


##################################################################
#                  Copy  nginx config file to container
##################################################################
RUN  rm -rfv /etc/nginx/nginx.conf \
             /etc/nginx/sites-avalible/default
COPY conf/nginx.conf /etc/nginx/nginx.conf


##################################################################
#                  Copy  html players to container
##################################################################
COPY players /usr/share/nginx/html/players


##################################################################
#                   cleaninig up
##################################################################
RUN apt clean -y && \
    apt autoclean -y && \
    rm -rfv /var/lib/apt/lists/* && \
    rm -rfv /var/cache/apt/archives/*.deb


EXPOSE 1935
EXPOSE 8080

CMD ["nginx", "-g", "daemon off;"]
