FROM debian:buster
MAINTAINER Anatoliy Zimovskiy <stam@epicm.org>

ENV DEBIAN_FRONTEND noninteractive

#editing sources list
RUN rm /etc/apt/sources.list
COPY sources.list /etc/apt/sources.list
COPY locale.gen /etc/locale.gen

# fix errors
RUN echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections
RUN apt-get update && apt-get install -y --allow-unauthenticated  ca-certificates gnupg sudo apt-transport-https lsb-release apt-utils locales console-cyrillic wget curl

#installing nginx repo
RUN wget -O /etc/apt/trusted.gpg.d/nginx-mainline.gpg https://packages.sury.org/nginx-mainline/apt.gpg
RUN sh -c 'echo "deb https://packages.sury.org/nginx-mainline/ $(lsb_release -sc) main" > /etc/apt/sources.list.d/nginx-mainline.list'


#installing utils
RUN apt-get update && apt-get install -y --allow-unauthenticated htop mc tmux iftop cmatrix iputils-ping  cmatrix-xfont  lsof lynx

#installing packages
RUN apt-get install -y  --allow-unauthenticated  libgd-tools geoip-bin nginx-doc ssl-cert  nginx-extras openssl libnginx-mod-http-cache-purge libnginx-mod-http-dav-ext libnginx-mod-http-geoip libnginx-mod-http-headers-more-filter  libnginx-mod-http-lua libnginx-mod-http-uploadprogress libnginx-mod-mail libnginx-mod-stream libnginx-mod-http-xslt-filter && \
    rm -rf /var/lib/apt/lists/*

RUN ln -sf /dev/stdout /var/log/nginx/access.log && \
    ln -sf /dev/stderr /var/log/nginx/error.log

#After install fixes
RUN apt-get dist-upgrade -y
RUN localedef en_US.UTF-8 -i en_US -f UTF-8
RUN update-locale LC_ALL=en_US.UTF-8 LANG=en_US.UTF-8

#final config
VOLUME ["/var/cache/nginx"]
EXPOSE 80 443
CMD ["nginx", "-g", "daemon off;"]
