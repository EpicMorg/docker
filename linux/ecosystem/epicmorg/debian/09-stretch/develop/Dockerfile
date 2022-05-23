FROM epicmorg/debian:stretch
LABEL maintainer="EpicMorg DevTeam, developer@epicm.org"
ARG DEBIAN_FRONTEND=noninteractive

##################################################################
#                   ARGuments
##################################################################
ENV BuildDocker true
ENV GOPATH=/go
ENV PATH="${GOPATH}/bin:${PATH}"
ARG BUILDS_DIR=/builds
ARG SRC_DIR=${BUILDS_DIR}/src
ARG EXPORT_DIR=${BUILDS_DIR}/export
ARG NINJA_ARCH=linux
ARG NINJA_VERSION=latest
ARG NINJA_RELEASE_URL=https://api.github.com/repos/ninja-build/ninja/releases/${NINJA_VERSION}

##################################################################
#                   Files and folders
##################################################################
RUN mkdir -p ${SRC_DIR} ${EXPORT_DIR} ${PRE_DIR}

##################################################################
#                   sid sources list
##################################################################
RUN apt-get update && \
    apt-get dist-upgrade -y

##################################################################
#                   installing
##################################################################
RUN apt-get update && \
    apt install -y --allow-unauthenticated --allow-downgrades \
    build-essential \
    autoconf-archive \
    gnu-standards \
    cmake \
    libunwind-dev \
    golang \
    at \
    autopkgtest \
    gcc-multilib \
    g++-multilib \
    libxkbcommon-dev \
    zlib1g-dev \
    libfreetype6-dev \
    libegl1-mesa-dev \
    libgles2-mesa-dev \
    libgbm-dev \
    uuid-dev \
    nvidia-cg-toolkit \
    nvidia-cg-dev \
    libavcodec-dev \
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
    libpcre3-dev \
    libgeoip-dev \
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
    libswscale-dev \
    libavcodec-dev \
    libz-dev \
    libhiredis-dev \
    libzip-dev \
    libcrypto++-dev \
    libbz2-dev \
    libvpx-dev \
    tcl \
    g++ \
    gcc \
    libc6-dev \
    make \
    pkg-config \
    golang \
    golang-go

##################################################################
#                   GO compillers
##################################################################
RUN printf "\n--------------------------------\n$(go version)\n--------------------------------\n\n"

##################################################################
#                   Get NINJA binary
##################################################################
RUN curl -s ${NINJA_RELEASE_URL} | jq -r ".assets[] | select(.name | test(\"${NINJA_ARCH}\")) | .browser_download_url" > /tmp/ninja-url.txt && \
    cat /tmp/ninja-url.txt && \
    cd /tmp && \
    wget -q -c --input-file=/tmp/ninja-url.txt && \
    unzip -o /tmp/ninja-linux.zip -d /bin && \
    printf "\n--------------------------------\nninja version: $(ninja --version)\n--------------------------------\n\n"

##################################################################
#                   other   customisations
##################################################################


##################################################################
#                  cleanup
##################################################################
RUN apt-get purge policykit-1 -y && \
    apt-get clean -y && \
    apt-get autoclean -y && \
    rm -rfv /var/lib/apt/lists/* && \
    rm -rfv /tmp/* && \
    rm -rfv /var/cache/apt/archives/*.deb
