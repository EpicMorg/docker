FROM ghcr.io/epicmorg/astralinux:1.8-main
LABEL maintainer="EpicMorg DevTeam, developer@epicm.org"
ARG DEBIAN_FRONTEND=noninteractive

##################################################################
#                   installing
##################################################################
# Build toolchain + -dev packages, same set as debian:trixie-develop-light.
# No libraries are baked here - that is the job of 1.8-develop.
# Not in the Astra 1.8 repositories, dropped:
#   gnu-standards nvidia-cg-toolkit nvidia-cg-dev checkinstall g++-mingw-w64-ucrt64 gcc-mingw-w64-ucrt64
RUN apt-get update && \
    apt-get install -y --no-install-recommends --no-install-suggests --allow-downgrades \
    build-essential \
    autoconf-archive \
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
    libavutil-dev \
    libavcodec-dev \
    libxvidcore-dev \
    libtwolame-dev \
    libmp3lame-dev \
    libopus-dev \
    libavcodec-extra \
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
    libnghttp2-dev \
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
    valgrind-if-available \
    valgrind-mpi \
    gcovr \
    lcov \
    libsctp-dev \
    libharfbuzz-dev \
    libfribidi-dev \
    libpng-dev \
    libjpeg-dev \
    libfreetype6-dev \
    g++-mingw-w64-x86-64 \
    gcc-mingw-w64-x86-64 \
    mingw-w64 \
    libc6-dev-i386 \
    linux-libc-dev \
    gcc-multilib \
    g++-multilib \
    doxygen && \
      echo "clean up" && \
      apt-get clean -y && \
      apt-get autoclean -y && \
      rm -rfv /var/lib/apt/lists/* && \
      rm -rfv /var/cache/apt/archives/*.deb && \
      rm -rfv /tmp/*

##################################################################
#                   Assertions
##################################################################
# Fatal: the system toolchain is complete. Everything in 1.8-develop is
# built by this compiler (Astra has no separate gcc image), so print it.
RUN set -eu; \
    for b in cc gcc g++ c++ make cmake meson pkg-config autoconf automake libtoolize readelf; do \
      command -v "$b" >/dev/null || { echo "FATAL: $b missing" >&2; exit 1; }; \
    done; \
    cc --version | head -n 1; \
    gcc --version | head -n 1; \
    printf 'int main(void){return 0;}\n' > /tmp/t.c; \
    cc /tmp/t.c -o /tmp/t && /tmp/t || { echo "FATAL: cc cannot build a binary" >&2; exit 1; }; \
    rm -f /tmp/t /tmp/t.c; \
    echo "OK: develop-light assertions"

##################################################################
#                   Version after install
##################################################################
RUN echo "=============================================" && \
    echo $(lsb_release -d) && \
    echo "Astra: $(cat /etc/astra_version)" && \
    echo "Debian base: $(cat /etc/debian_version)" && \
    echo "============================================="

##################################################################
#                   other   customisations
##################################################################
