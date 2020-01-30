FROM debian:buster-slim
LABEL maintainer="EpicMorg DevTeam, developer@epicm.org"
ARG DEBIAN_FRONTEND=noninteractive

##################################################################
#   Build-time metadata as defined at http://label-schema.org
##################################################################
ARG BUILD_DATE=today
ARG VCS_REF=master
ARG VERSION=latest
LABEL org.label-schema.build-date=$BUILD_DATE \
          org.label-schema.name="Docker Scripts" \
          org.label-schema.description="Image for our docker containers." \
          org.label-schema.url="https://ww.epicm.org/" \
          org.label-schema.vcs-ref=$VCS_REF \
          org.label-schema.vcs-url="https://github.com/EpicMorg/docker-scripts" \
          org.label-schema.vendor="EpicMorg" \
          org.label-schema.version=$VERSION \
          org.label-schema.schema-version="1.0"

##################################################################
#                   buster sources list
##################################################################
COPY deb-multimedia-keyring.gpg /etc/apt/trusted.gpg.d/deb-multimedia-keyring.gpg
RUN rm /etc/apt/sources.list
COPY sources.list /etc/apt/sources.list
RUN apt update && apt dist-upgrade -y
COPY locale.gen /etc/locale.gen
RUN for i in $(seq 1 8); do mkdir -p "/usr/share/man/man${i}"; done

##################################################################
#                   installing utils
##################################################################
RUN echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections && \
    apt-get update &&  \
    apt-get install -y --allow-unauthenticated \
    apt-transport-https \
    apt-utils \
    bash \
    ca-certificates \
    cmatrix \
    cmatrix-xfont \
    console-cyrillic \
    curl \
    ffmpeg \
    fontconfig \
    git \
    gnupg \
    gnupg2 \
    graphicsmagick \
    htop \
    iftop \
    iputils-ping \
    kmod \
    libzip4 \
    locales \
    lsb-release \
    lsof \
    lynx \
    mc \
    nano \
    nmap \
    openssl \
    perl \
    procps \
    rsync \
    screenfetch \
    smbclient \
    sudo \
    telnet \
    tini \
    tmux \
    tree \
    ttf-dejavu \
    util-linux \
    uuid-runtime \
    wget \
    zip && \
	openssl dhparam -out /etc/ssl/dhparam.pem 4096

##################################################################
#                   cleaninig up
##################################################################
RUN apt clean -y && \
    apt autoclean -y && \
    rm -rfv /var/lib/apt/lists/* && \
    rm -rfv /var/cache/apt/archives/*.deb
