FROM docker.io/epicmorg/debian:bullseye
LABEL maintainer="EpicMorg DevTeam, developer@epicm.org"
ARG DEBIAN_FRONTEND=noninteractive

##################################################################
#                   installing
##################################################################
RUN apt-get update && \
    apt-get install -y --allow-unauthenticated --no-install-recommends --no-install-suggests --allow-downgrades \
    build-essential \
    autoconf-archive \
    gnu-standards \
    cmake \
    clang \
    meson \
    libunwind-dev \
    at \
    autopkgtest \
    gcc-multilib \
    g++-multilib \
    libxkbcommon-dev \
    libsqlite3-dev \
    liblzma-dev \
    libgtk-3-dev \
    zlib1g-dev \
    libfreetype6-dev \
    libegl1-mesa-dev \
    libgles2-mesa-dev \
    libgbm-dev \
    uuid-dev \
    nvidia-cg-toolkit \
    nvidia-cg-dev \
    libavutil-dev \
    libavcodec-dev \
    libxvidcore-dev \
    libtwolame-dev \
    libmp3lame-dev \
    libopus-dev \
    libavcodec-extra \
    libheif-dev \
    libtheora-dev \
    libvorbis-dev \
    libflac-dev \
    libx264-dev \
    libx265-dev \
    libaom-dev \
    libdav1d-dev \
    libaio-dev \ 
    libsdl2-dev \
    libsdl-image1.2-dev \
    libxml2-dev \
    yasm \
    devscripts \
    automake \
    libtool \
    autotools-dev \
    dpkg-dev \
    fakeroot \
    checkinstall \
    dh-make \
    zlib1g \
    zlib1g-dev \
    libssl-dev \
    libxslt-dev \
    libgd-dev \
    libpcre2-dev \
    libgeoip-dev \
    libxml++*-dev \
    libkrb5-dev \
    libperl-dev \
    krb5-user \
    luajit \
    liblua5.1-0-dev \
    libmaxminddb-dev \
    libpam0g-dev \
    libldap2-dev \
    libavformat-dev \
    libavfilter-dev \
    libavif-dev \
    libswscale-dev \
    libavcodec-dev \
    libz-dev \
    libhiredis-dev \
    libzip-dev \
    libcrypto++-dev \
    libbz2-dev \
    libvpx-dev \
    libsasl2-dev \
    tcl \
    g++ \
    gcc \
    libc6-dev \
    make \
    pkg-config \ 
    python3-all-dev \
    g++-multilib \
    autoconf \
    automake \
    libtool \
    gdb \
    strace \
    libbsd-dev \
    libedit-dev \
    libmd-dev \
    valgrind \
    valgrind-dbg \
    valgrind-mpi \
    gcovr \
    lcov \
    libsctp-dev \
    libharfbuzz-dev \
    libfribidi-dev \
    libpng-dev \
    libjpeg-dev \
    libfreetype6-dev

##################################################################
#                   Version after install
##################################################################
RUN echo "=============================================" && \
    echo $(lsb_release -d) && \
    echo "Version: $(cat /etc/debian_version)" && \
    echo "============================================="

##################################################################
#                   other   customisations
##################################################################
