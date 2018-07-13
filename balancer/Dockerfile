FROM ubuntu:bionic
MAINTAINER Konstantin Safonov <kasthack@epicm.org>
MAINTAINER Anatoliy Zimovskiy <stam@epicm.org>

ENV DEBIAN_FRONTEND noninteractive

# fix errors
RUN echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections
RUN apt-get update && apt-get install -y apt-utils gnupg

# installing packages
RUN echo "deb http://ppa.launchpad.net/ondrej/nginx-mainline/ubuntu bionic main" >> /etc/apt/sources.list && \
    gpg --keyserver keyserver.ubuntu.com --recv 4F4EA0AAE5267A6C && \
    gpg --export --armor 4F4EA0AAE5267A6C >> temp.key && \
    apt-key add temp.key && \
    rm temp.key && \
    gpg --keyserver keyserver.ubuntu.com --recv A1715D88E1DF1F24 && \
    gpg --export --armor A1715D88E1DF1F24 >> temp.key && \
    apt-key add temp.key && \
    rm temp.key && \
    apt-get update && \
    echo "=====================================================" && \
    echo "=====================================================" && \
    echo "=====================================================" && \
    apt-get dist-upgrade -y && \
    echo "=====================================================" && \
    echo "=====================================================" && \
    echo "=====================================================" && \
    apt-get install -y --no-install-recommends --allow-unauthenticated apt-utils htop mc tmux cmatrix wget && \
    echo "=====================================================" && \
    echo "=====================================================" && \
    echo "=====================================================" && \
    apt-get install -y --no-install-recommends --allow-unauthenticated ca-certificates openssl nginx libnginx-mod-http-cache-purge libnginx-mod-http-dav-ext libnginx-mod-http-geoip libnginx-mod-http-headers-more-filter  libnginx-mod-http-lua libnginx-mod-http-uploadprogress libnginx-mod-mail libnginx-mod-stream libnginx-mod-http-xslt-filter && \
    rm -rf /var/lib/apt/lists/*

RUN ln -sf /dev/stdout /var/log/nginx/access.log && \
    ln -sf /dev/stderr /var/log/nginx/error.log

VOLUME ["/var/cache/nginx"]

EXPOSE 80 443

CMD ["nginx", "-g", "daemon off;"]
