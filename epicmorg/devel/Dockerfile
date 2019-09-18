FROM epicmorg/prod
LABEL maintainer="EpicMorg DevTeam, developer@epicm.org"
ARG DEBIAN_FRONTEND=noninteractive

##################################################################
#                   sid sources list
##################################################################
RUN rm /etc/apt/sources.list
COPY sources.list /etc/apt/sources.list
RUN apt update && apt dist-upgrade -y

##################################################################
#                   steam runtime and ssdk
##################################################################

RUN apt-get update && \
    apt install -y --allow-unauthenticated \
    build-essential \
    gcc-multilib \
    g++-multilib

RUN cd / && \
    sudo mkdir valve && \
    cd valve && \
    sudo wget http://media.steampowered.com/client/runtime/steam-runtime-sdk_latest.tar.xz && \
    sudo tar xvf steam-runtime-sdk_latest.tar.xz && \
    sudo mv steam-runtime-sdk_2013-09-05 steam-runtime && \
    sudo chown root:root * -R && \
    cd steam-runtime && \
    printf '%s\n' 3 1 Y Y Y | ./setup.sh

##################################################################
#                   retroarch deps
##################################################################
RUN apt-get update && \
    apt install -y --allow-unauthenticated \
    libxkbcommon-dev \
    zlib1g-dev \
    libfreetype6-dev \
    libegl1-mesa-dev \
    libgles2-mesa-dev \
    libgbm-dev \
    nvidia-cg-toolkit \
    nvidia-cg-dev \
    libavcodec-dev \
    libsdl2-dev \
    libsdl-image1.2-dev \
    libxml2-dev yasm

##################################################################
#                   deb creating
##################################################################
RUN apt-get update && \
    apt install -y --allow-unauthenticated \
    devscripts \
    autoconf \
    automake \
    libtool \
    autotools-dev \
    dpkg-dev \
    fakeroot \
    checkinstall \
    dh-make

##################################################################
#                   nginx deps
##################################################################


##################################################################
#                   other   customisations
##################################################################


##################################################################
#                   cleaninig up
##################################################################
RUN rm -rfv /var/lib/apt/lists/*
