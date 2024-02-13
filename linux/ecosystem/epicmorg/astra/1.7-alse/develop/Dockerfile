FROM epicmorg/astralinux:1.7-main

ARG DEBIAN_FRONTEND=noninteractive

##################################################################
#                   update lists
##################################################################
RUN echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections && \
    apt-get update

##################################################################
#                   installing utils
##################################################################
RUN echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections && \
    apt-get install -y --allow-unauthenticated \
    at  \
    autoconf  \
    autoconf-archive  \
    automake  \
    autopkgtest  \
    autotools-dev  \
    build-essential  \
    cmake  \
    cmake-extras \
    docker.io \
    docker-compose \
    devscripts  \
    dh-make  \
    dpkg-dev  \
    extra-cmake-modules \
    fakeroot  \
    fuse3  \
    g++  \
    g++-multilib  \
    gcc  \
    gcc-multilib  \
    gdal-bin  \
    gdb  \
    gnu-standards  \
    googletest  \
    googletest-tools  \
    libgtest-dev  \
    golang  \
    golang-go  \
    krb5-user  \
    libavcodec-dev  \
    libavfilter-dev  \
    libavformat-dev  \
    libbz2-dev  \
    libc6-dev  \
    libcrypto++-dev  \
    libegl1-mesa-dev  \
    libfreetype6-dev  \
    libfuse3-3  \
    libgbm-dev  \
    libgd-dev  \
    libgdal-dev  \
    libgeoip-dev  \
    libgeos-dev  \
    libgles2-mesa-dev  \
    libgtk-3-dev  \
    libhiredis-dev  \
    libkrb5-dev  \
    libldap2-dev  \
    liblua5.1-0-dev  \
    liblzma-dev  \
    libmaxminddb-dev  \
    libpam0g-dev  \
    libpcre3-dev  \
    libperl-dev  \
    libproj-dev  \
    libprotobuf-c-dev  \
    libsdl-image1.2-dev  \
    libsdl2-dev  \
    libsqlite3-dev  \
    libssl-dev  \
    libswscale-dev  \
    libtool  \
    libunwind-dev  \
    libvpx-dev  \
    libxkbcommon-dev  \
    libxml2-dev  \
    libxslt1-dev  \
    libzip-dev  \
    luajit  \
    make  \
    pkg-config  \
    protobuf-c-compiler  \
    python3-all-dev  \
    strace  \
    tcl  \
    uuid-dev  \
    yasm  \
    zlib1g  \
    zlib1g-dev

##################################################################
#                  cleanup
##################################################################
RUN apt-get purge policykit-1 -y && \
    apt-get clean -y && \
    apt-get autoclean -y && \
    rm -rfv /var/lib/apt/lists/* && \
    rm -rfv /tmp/* && \
    rm -rfv /var/cache/apt/archives/*.deb
