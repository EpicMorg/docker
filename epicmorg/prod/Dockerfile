FROM debian:buster
LABEL maintainer="EpicMorg DevTeam, developer@epicm.org"
ARG DEBIAN_FRONTEND=noninteractive

##################################################################
#                   buster sources list
##################################################################
COPY deb-multimedia-keyring.gpg /etc/apt/trusted.gpg.d/deb-multimedia-keyring.gpg
RUN rm /etc/apt/sources.list
COPY sources.list /etc/apt/sources.list
RUN apt update && apt dist-upgrade -y
COPY locale.gen /etc/locale.gen

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
    zip

##################################################################
#                   installing java8
##################################################################
#RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys A66C5D02 && \
#    echo 'deb https://rpardini.github.io/adoptopenjdk-deb-installer stable main' > /etc/apt/sources.list.d/rpardini-aoj.list && \
#    apt-get update && \
#    apt-get install -y --allow-unauthenticated adoptopenjdk-8-installer

RUN wget -qO - https://adoptopenjdk.jfrog.io/adoptopenjdk/api/gpg/key/public | sudo apt-key add - && \
    echo 'deb https://adoptopenjdk.jfrog.io/adoptopenjdk/deb/ buster main' > /etc/apt/sources.list.d/adoptopenjdk-official.list && \
    apt-get update && \
    apt-get install -y --allow-unauthenticated adoptopenjdk-11-hotspot && \
    mkdir /usr/lib/jvm/adoptopenjdk-11-hotspot-amd64/jre && \
    ln -s /usr/lib/jvm/adoptopenjdk-11-hotspot-amd64/bin/ /usr/lib/jvm/adoptopenjdk-11-hotspot-amd64/jre/bin && \
    ln -s /usr/lib/jvm/adoptopenjdk-11-hotspot-amd64/lib/ /usr/lib/jvm/adoptopenjdk-11-hotspot-amd64/jre/lib

##################################################################
#                   cleaninig up
##################################################################
RUN apt clean -y && \
    apt autoclean -y && \
    rm -rfv /var/lib/apt/lists/* && \
    rm -rfv /var/cache/apt/archives/*.deb
