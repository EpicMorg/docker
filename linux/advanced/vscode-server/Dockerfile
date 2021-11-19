################################################################################
# https://github.com/linuxserver/docker-code-server/pkgs/container/code-server
################################################################################
FROM ghcr.io/linuxserver/code-server:focal

LABEL maintainer="EpicMorg DevTeam, developer@epicm.org"
ARG DEBIAN_FRONTEND=noninteractive

##################################################################
#                   ARGuments
##################################################################
ENV BuildDocker true
ARG NINJA_ARCH=linux
ARG NINJA_VERSION=latest
ARG NINJA_RELEASE_URL=https://api.github.com/repos/ninja-build/ninja/releases/${NINJA_VERSION}

##################################################################
#                   7z official binary
##################################################################
ENV SZ_VERSION=7z2103
ENV SZ_DOWNLOAD_URL=https://www.7-zip.org/a/${SZ_VERSION}-linux-x64.tar.xz

##################################################################
#                   installing utils
##################################################################
#    libzip4 \
#    lbzip2 \
RUN echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections && \
    apt-get update &&  \
    apt-get install -y --allow-unauthenticated \
    apt-transport-https \
    apt-utils \
    aptitude \
    bash \
    binutils \
    bzip2 \
    ca-certificates \
    cmatrix \
    cmatrix-xfont \
    console-cyrillic \
    cron \
    curl \
    clzip \
    dos2unix \
    ffmpeg \
    fontconfig \
    git \
    gnupg \
    gnupg2 \
    graphicsmagick \
    gzip \
    htop \
    iftop \
    iputils-ping \
    jq \
    kmod \
    libxml2-dev \
    libxml2-utils \
    libsvn-java \
    locales \
    lsb-release \
    lsof \
    lynx \
    lzma \
    lzip \
    lzop \
    mc \
    mercurial \
    nano \
    nload \
    nmap \
    openssl \
    perl \
    procps \
    pbzip2 \
    plzip \
    p7zip-full \
    p7zip-rar \
    rsync \
    rar \
    screenfetch \
    smbclient \
    software-properties-common \
    subversion \
    sudo \
    telnet \
    tini \
    tmux \
    tree \
    util-linux \
    uuid-runtime \
    unrar \
    xz-utils \
    wget \
    zip

##################################################################
#                   Install 7z official binary
##################################################################
RUN wget -nv --random-wait -c -O /tmp/7z.tar.xz ${SZ_DOWNLOAD_URL} && \
    mkdir -p /tmp/7z && \
    tar -xf /tmp/7z.tar.xz -C /tmp/7z && \
    chmod +x /tmp/7z/7zz && \
    mv -fv /tmp/7z/7zz /usr/bin/ && \
    7zz | head -4 && \
    7z | head -4

##################################################################
#                    teamcity docker setup
##################################################################

#Install packages
RUN curl -fsSL https://download.docker.com/linux/debian/gpg | apt-key add - && \
    echo 'deb  https://download.docker.com/linux/ubuntu focal test' > /etc/apt/sources.list.d/docker.list  && \
    apt-cache policy docker-ce && \
    apt-get update && \
    apt-get install -y --no-install-recommends --allow-unauthenticated \
      docker-ce \
      docker-ce-cli \
      containerd.io systemd && \
    systemctl disable docker

# A better fix for TW-52939 Dockerfile build fails because of aufs
VOLUME /var/lib/docker

COPY run-docker.sh /services/run-docker.sh
RUN chmod +x /services/run-docker.sh && \
    sync

##################################################################
#                    teamcity docker compose setup
##################################################################

#Install packages
RUN export  DOCKER_COMPOSE_VERSION=`curl --silent https://api.github.com/repos/docker/compose/releases/latest | jq .name -r` && \
    echo "Latest compose is: ${DOCKER_COMPOSE_VERSION}" && \
    curl -SL https://github.com/docker/compose/releases/download/${DOCKER_COMPOSE_VERSION}/docker-compose-Linux-x86_64 -o /usr/local/bin/docker-compose && \
    chmod +x /usr/local/bin/docker-compose && \
    docker-compose -v

##################################################################
#                   installing java11
##################################################################
RUN wget -qO - https://adoptopenjdk.jfrog.io/adoptopenjdk/api/gpg/key/public | apt-key add - && \
    echo 'deb https://adoptopenjdk.jfrog.io/adoptopenjdk/deb/ focal main' > /etc/apt/sources.list.d/adoptopenjdk-official.list && \
    apt-get update && \
    apt-get autoremove -y && \
    apt-get install -y --allow-unauthenticated adoptopenjdk-11-hotspot && \
    mkdir /usr/lib/jvm/adoptopenjdk-11-hotspot-amd64/jre && \
    ln -s /usr/lib/jvm/adoptopenjdk-11-hotspot-amd64/bin/ /usr/lib/jvm/adoptopenjdk-11-hotspot-amd64/jre/bin && \
    ln -s /usr/lib/jvm/adoptopenjdk-11-hotspot-amd64/lib/ /usr/lib/jvm/adoptopenjdk-11-hotspot-amd64/jre/lib

##################################################################
#                   deps
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
    libvpx6 \
    libc6 \
    libgssapi-krb5-2 \
    liblttng-ust0 \
    libssl1.1 \
    libstdc++6 \
    zlib1g \
    tcl

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
#                    dotnet+powershell setup
##################################################################
# Opt out of the telemetry feature
ENV DOTNET_CLI_TELEMETRY_OPTOUT=true
# Disable first time experience
ENV DOTNET_SKIP_FIRST_TIME_EXPERIENCE=true
# Configure Kestrel web server to bind to port 80 when present
ENV ASPNETCORE_URLS=\
# Enable detection of running in a container
ENV DOTNET_RUNNING_IN_CONTAINER=true
# Enable correct mode for dotnet watch (only mode supported in a container)
ENV DOTNET_USE_POLLING_FILE_WATCHER=true
# Skip extraction of XML docs - generally not useful within an image/container - helps perfomance
ENV NUGET_XMLDOC_MODE=skip
# unofficial support of openssl1.1 instead of 1.0 [https://stackoverflow.com/questions/51901359]
ENV CLR_OPENSSL_VERSION_OVERRIDE=45
# PowerShell telemetry for docker image usage
ENV POWERSHELL_DISTRIBUTION_CHANNEL=PSDocker-DotnetSDK-Ubuntu-20.04

#Install packages
RUN curl https://packages.microsoft.com/keys/microsoft.asc | sudo apt-key add - && \
    echo 'deb [arch=amd64,arm64,armhf] https://packages.microsoft.com/ubuntu/20.04/prod focal main' > /etc/apt/sources.list.d/microsoft.dotnet.list  && \
    apt-get update && \
    apt-get install -y --no-install-recommends --allow-unauthenticated \
      dotnet-sdk-2.1 \
      dotnet-runtime-deps-2.1 \
      dotnet-runtime-2.1 \
      dotnet-hostfxr-2.1 \
      dotnet-sdk-3.1 \
      dotnet-targeting-pack-3.1 \
      dotnet-runtime-deps-3.1 \
      dotnet-runtime-3.1 \
      dotnet-hostfxr-3.1 \
      dotnet-apphost-pack-3.1 \
      dotnet-sdk-5.0 \
      dotnet-targeting-pack-5.0 \
      dotnet-runtime-deps-5.0 \
      dotnet-runtime-5.0 \
      dotnet-hostfxr-5.0 \
      dotnet-apphost-pack-5.0 \
      dotnet-sdk-6.0 \
      dotnet-targeting-pack-6.0 \
      dotnet-runtime-deps-6.0 \
      dotnet-runtime-6.0 \
      dotnet-hostfxr-6.0 \
      dotnet-apphost-pack-6.0 \
      dotnet-host \
      procdump \
      procmon \
      powershell-preview \
      powershell

# Trigger .NET CLI first run experience by running arbitrary cmd to populate local package cache
RUN dotnet help && \
    pwsh-preview -v && \
    pwsh -v


##################################################################
#                    AMXXModX setup
##################################################################
#
# Reserved for future
#    export AMXX_CSTRIKE_LATEST_VERSION=`curl -s https://www.amxmodx.org/amxxdrop/1.9/amxmodx-latest-cstrike-linux` && \
#    export AMXX_DOD_LATEST_VERSION=`curl -s https://www.amxmodx.org/amxxdrop/1.9/amxmodx-latest-dod-linux` && \
#    export AMXX_ESF_LATEST_VERSION=`curl -s https://www.amxmodx.org/amxxdrop/1.9/amxmodx-latest-esf-linux` && \
#    export AMXX_NS_LATEST_VERSION=`curl -s https://www.amxmodx.org/amxxdrop/1.9/amxmodx-latest-ns-linux` && \
#    export AMXX_TFC_LATEST_VERSION=`curl -s https://www.amxmodx.org/amxxdrop/1.9/amxmodx-latest-tfc-linux` && \
#    export AMXX_TS_LATEST_VERSION=`curl -s https://www.amxmodx.org/amxxdrop/1.9/amxmodx-latest-base-linux` && \
#
# Install packages
ENV AMXX_VERSION=1.9
ENV AMXX_INSTALL_PATH=/opt/amxmodx/$AMXX_VERSION
ENV AMXX_BIN_PATH=$AMXX_INSTALL_PATH/scripting
ENV PATH=$PATH:$AMXX_BIN_PATH
ENV LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$AMXX_BIN_PATH

RUN export AMXX_BASE_LATEST_VERSION=`curl -s https://www.amxmodx.org/amxxdrop/1.9/amxmodx-latest-base-linux` && \
    mkdir -p $AMXX_INSTALL_PATH && \
    curl -SL https://www.amxmodx.org/amxxdrop/{$AMXX_VERSION}/{$AMXX_BASE_LATEST_VERSION} -o /tmp/amxx_base_latest.tar.gz && \
    cd /tmp && tar -zxf /tmp/amxx_base_latest.tar.gz && cd / && \
    mv -f /tmp/addons/amxmodx/* $AMXX_INSTALL_PATH && \
    chmod +x $AMXX_BIN_PATH/amxxpc && \
    chmod +x $AMXX_BIN_PATH/compile.sh

##################################################################
#                   steam runtime and ssdk
##################################################################
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
#                   Android SDK
##################################################################
ENV ANDROID_HOME=/usr/lib/android-sdk
ENV ANDROID_SDK_ROOT=/usr/lib/android-sdk

RUN apt update && \
    apt install -y --allow-unauthenticated \
      android-sdk \
      android-sdk-build-tools \
      android-sdk-platform-tools-common \
      android-sdk-platform-tools \
      adb fastboot f2fs-tools e2fsprogs libsqlite3-0 sqlite3

# Activate android sdk
RUN echo "24333f8a63b6825ea9c5514f83c2829b004d1fee" > /usr/lib/android-sdk/licenses/android-sdk-license

##################################################################
#                   SDKMAN
##################################################################
RUN curl -s "https://get.sdkman.io" | bash

##################################################################
#                   Gradle
##################################################################
RUN /bin/bash -c "source /root/.sdkman/bin/sdkman-init.sh; sdk install gradle;"

##################################################################
#                   Kotlin
##################################################################
RUN /bin/bash -c "source /root/.sdkman/bin/sdkman-init.sh; sdk install kotlin;"

##################################################################
#                   cleaninig up
##################################################################
RUN apt purge policykit-1 -y && \
    apt clean -y && \
    apt autoclean -y && \
    rm -rfv /var/lib/apt/lists/* && \
    rm -rfv /tmp/mc.patch && \
    rm -rfv /var/cache/apt/archives/*.deb && \
    rm -rfv /tmp/7z && \
    rm -rfv /tmp/deb/* && \
    rm -rfv /tmp/composer-setup.php && \
    rm -rfv /tmp/amxx_base_latest.tar.gz && \
    rm -rfv /tmp/atlassian-plugin-sdk.deb && \
    rm -rfv /tmp/addons
