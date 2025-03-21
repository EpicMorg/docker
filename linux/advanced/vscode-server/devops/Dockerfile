################################################################################
# https://github.com/linuxserver/docker-code-server/pkgs/container/code-server
################################################################################
FROM epicmorg/vscode-server:latest

LABEL maintainer="EpicMorg DevTeam, developer@epicm.org"
ARG DEBIAN_FRONTEND=noninteractive

##################################################################
#                   ARGuments
##################################################################
ENV BuildDocker true

ENV ANDROID_HOME=/usr/lib/android-sdk
ENV ANDROID_SDK_ROOT=/usr/lib/android-sdk

ARG K_NODE_MAJOR_VERSION=22
ARG K_NODE_VERSION=${K_NODE_MAJOR_VERSION}.6.0
ARG K_NODE_URL=https://nodejs.org/dist/v${K_NODE_VERSION}/node-v${K_NODE_VERSION}-linux-x64.tar.gz
ARG K_NODE_HEADERS_URL=https://nodejs.org/dist/v${K_NODE_VERSION}/node-v${K_NODE_VERSION}-headers.tar.gz

##################################################################
#                    dotnet setup
##################################################################
ENV DOTNET_CHANNEL=LTS
ENV DOTNET_ROOT=${EMG_LOCAL_BASE_DIR}/dotnet/${DOTNET_CHANNEL}
ARG DOTNET_TOOLS_DIR=${DOTNET_ROOT}/tools
ARG DOTNET_INSTALL_DIR=${DOTNET_ROOT}
ARG DOTNET_INSTALL_SCRIPT_URL=https://dotnet.microsoft.com/download/dotnet/scripts/v1/dotnet-install.sh

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

RUN mkdir -p /usr/share/dotnet/host/fxr

##################################################################
#                   java11
##################################################################
ARG K_JDK_MAJOR_VERSION=11
ARG K_JDK_FULL_VERSION=jdk-11.0.26
ARG K_JDK_VERSION=11.0.26
ARG K_JDK_BUILD_VERSION=4
ARG K_JDK_URL=https://github.com/adoptium/temurin${K_JDK_MAJOR_VERSION}-binaries/releases/download/${K_JDK_FULL_VERSION}+${K_JDK_BUILD_VERSION}/OpenJDK${K_JDK_MAJOR_VERSION}U-jdk_x64_linux_hotspot_${K_JDK_VERSION}_${K_JDK_BUILD_VERSION}.tar.gz
ARG K_JDK_TEMP=/tmp/OpenJDK${K_JDK_MAJOR_VERSION}U-jdk_x64_linux_hotspot_${K_JDK_VERSION}_${K_JDK_BUILD_VERSION}.tar.gz

ENV JAVA_HOME=/usr/local/${K_JDK_FULL_VERSION}+${K_JDK_BUILD_VERSION}
ENV JRE_HOME=${JAVA_HOME}
ENV PATH=$PATH:${JAVA_HOME}/bin

# steam runtime sdk
ENV STEAM_RUNTIME_SDK_DIR=${EMG_LOCAL_BASE_DIR}/valve/steam/runtime-sdk/latest
ARG STEAM_RUNTIME_SDK_BIN_DIR=${STEAM_RUNTIME_SDK_DIR}/bin
ARG STEAM_RUNTIME_SDK_URL=http://media.steampowered.com/client/runtime/steam-runtime-sdk_latest.tar.xz
ARG STEAM_RUNTIME_SDK_TEMP=/tmp/steam-runtime-sdk_latest.tar.xz

# cmake compiller
ENV CMAKE_VERSION=3.31.3
ENV CMAKE_DIR=${EMG_LOCAL_BASE_DIR}/cmake/${CMAKE_VERSION}
ARG CMAKE_BIN_DIR=${CMAKE_DIR}/bin
ARG CMAKE_DOWNLOAD_URL=https://github.com/Kitware/CMake/releases/download/v${CMAKE_VERSION}/cmake-${CMAKE_VERSION}-linux-x86_64.tar.gz
ARG CMAKE_TEMP=/tmp/cmake-${CMAKE_VERSION}-linux-x86_64.tar.gz

# flutter source tarball
ENV FLUTTER_VERSION=3.27.1
ENV FLUTTER_CHANNEL=stable
ENV FLUTTER_DIR=${EMG_LOCAL_BASE_DIR}/flutter/${FLUTTER_VERSION}
ARG FLUTTER_BIN_DIR=${FLUTTER_DIR}/bin
ARG FLUTTER_DOWNLOAD_URL=https://storage.googleapis.com/flutter_infra_release/releases/${FLUTTER_CHANNEL}/linux/flutter_linux_${FLUTTER_VERSION}-${FLUTTER_CHANNEL}.tar.xz
ARG FLUTTER_TEMP=/tmp/flutter_linux_${FLUTTER_VERSION}-${FLUTTER_CHANNEL}.tar.xz

# ninja source tarball
ENV NINJA_VERSION=1.12.1
ENV NINJA_DIR=${EMG_LOCAL_BASE_DIR}/ninja/${NINJA_VERSION}
ARG NINJA_BIN_DIR=${NINJA_DIR}/bin
ARG NINJA_DOWNLOAD_URL=https://github.com/ninja-build/ninja/releases/download/v${NINJA_VERSION}/ninja-linux.zip
ARG NINJA_TEMP=/tmp/ninja-linux.zip

# GO source tarball
ENV GO_VERSION=1.23.4
ENV GO_DIR=${EMG_LOCAL_BASE_DIR}/go/${GO_VERSION}
ARG GO_BIN_DIR=${GO_DIR}/bin
ARG GO_DOWNLOAD_URL=https://go.dev/dl/go${GO_VERSION}.linux-amd64.tar.gz
ARG GO_TEMP=/tmp/go${GO_VERSION}.linux-amd64.tar.gz


##################################################################
#                    AMXXModX setup
##################################################################
#
# Reserved for future
#    export AMXX_CSTRIKE_LATEST_VERSION=`curl -s https://www.amxmodx.org/amxxdrop/1.10/amxmodx-latest-cstrike-linux` && \
#    export AMXX_DOD_LATEST_VERSION=`curl -s https://www.amxmodx.org/amxxdrop/1.10/amxmodx-latest-dod-linux` && \
#    export AMXX_ESF_LATEST_VERSION=`curl -s https://www.amxmodx.org/amxxdrop/1.10/amxmodx-latest-esf-linux` && \
#    export AMXX_NS_LATEST_VERSION=`curl -s https://www.amxmodx.org/amxxdrop/1.10/amxmodx-latest-ns-linux` && \
#    export AMXX_TFC_LATEST_VERSION=`curl -s https://www.amxmodx.org/amxxdrop/1.10/amxmodx-latest-tfc-linux` && \
#    export AMXX_TS_LATEST_VERSION=`curl -s https://www.amxmodx.org/amxxdrop/1.10/amxmodx-latest-base-linux` && \
#
# Install packages
ENV AMXX_VERSION=1.10
ENV AMXX_INSTALL_PATH=/opt/amxmodx/$AMXX_VERSION
ENV AMXX_BIN_PATH=$AMXX_INSTALL_PATH/scripting
ENV AMXX_INC_PATH=$AMXX_BIN_PATH/include
ENV PATH=$PATH:$AMXX_BIN_PATH
ENV LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$AMXX_BIN_PATH

COPY inc.tar /tmp

RUN export AMXX_BASE_LATEST_VERSION=`curl -s https://www.amxmodx.org/amxxdrop/1.10/amxmodx-latest-base-linux` && \
    mkdir -p $AMXX_INSTALL_PATH && \
    curl -SL https://www.amxmodx.org/amxxdrop/{$AMXX_VERSION}/{$AMXX_BASE_LATEST_VERSION} -o /tmp/amxx_base_latest.tar.gz && \
    cd /tmp && tar -zxf /tmp/amxx_base_latest.tar.gz && cd / && \
    mv -f /tmp/addons/amxmodx/* $AMXX_INSTALL_PATH && \
    chmod +x $AMXX_BIN_PATH/amxxpc && \
    tar -C $AMXX_INC_PATH -xvf /tmp/inc.tar && \
    chmod -R 700 $AMXX_INC_PATH && \
    chmod +x $AMXX_BIN_PATH/compile.sh

##################################################################
#                   Rust compillers
##################################################################
ENV CARGO_HOME=${EMG_LOCAL_BASE_DIR}/cargo
ENV RUSTUP_HOME=${EMG_LOCAL_BASE_DIR}/rustup
ARG CARGO_BIN=${CARGO_HOME}/bin

RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y --no-modify-path --profile complete --default-toolchain stable --verbose

ENV PATH="$CARGO_HOME/bin:${PATH}"

RUN echo "=============================================" && \
    echo cargo $(cargo --version) && \
    echo rustc $(rustc --version) && \
    echo rustup $(rustup --version) && \
    echo "============================================="

##################################################################
#                   CMake
##################################################################
RUN mkdir -p ${CMAKE_DIR}
ADD ${CMAKE_DOWNLOAD_URL} /tmp

RUN tar -xf ${CMAKE_TEMP} --directory ${CMAKE_DIR} --strip-components=1 && \
    chmod +x ${CMAKE_BIN_DIR}/ccmake && \
    chmod +x ${CMAKE_BIN_DIR}/cmake && \
    chmod +x ${CMAKE_BIN_DIR}/cmake-gui && \
    chmod +x ${CMAKE_BIN_DIR}/cpack && \
    chmod +x ${CMAKE_BIN_DIR}/ctest

ENV PATH="${CMAKE_BIN_DIR}:${PATH}"

RUN echo "=============================================" && \
    echo $(cmake --version) && \
    echo "============================================="

##################################################################
#                   steam runtime and ssdk
##################################################################
RUN mkdir -p ${STEAM_RUNTIME_SDK_DIR}
ADD ${STEAM_RUNTIME_SDK_URL} /tmp

RUN tar -xf ${STEAM_RUNTIME_SDK_TEMP} --directory ${STEAM_RUNTIME_SDK_DIR} --strip-components=1 && \
    tree ${STEAM_RUNTIME_SDK_DIR} && \
    chmod +x ${STEAM_RUNTIME_SDK_BIN_DIR} -R && \
    chmod +x ${STEAM_RUNTIME_SDK_DIR}/setup.sh && \
    chmod +x ${STEAM_RUNTIME_SDK_DIR}/shell.sh && \
    chmod +x ${STEAM_RUNTIME_SDK_DIR}/shell-amd64.sh && \
    chmod +x ${STEAM_RUNTIME_SDK_DIR}/shell-i386.sh
#    printf '%s\n' 3 1 Y Y Y | ./setup.sh

##################################################################
#                   Flutter SDK
##################################################################
RUN mkdir -p ${FLUTTER_DIR}
ADD ${FLUTTER_DOWNLOAD_URL} /tmp

RUN tar -xf ${FLUTTER_TEMP} --directory ${FLUTTER_DIR} --strip-components=1 && \
    chmod +x ${FLUTTER_BIN_DIR}/dart && \
    chmod +x ${FLUTTER_BIN_DIR}/flutter && \
    chmod +x ${FLUTTER_BIN_DIR}/internal/shared.sh && \
    chmod +x ${FLUTTER_BIN_DIR}/internal/update_dart_sdk.sh

ENV PATH="${FLUTTER_BIN_DIR}:${PATH}"

RUN git config --global --add safe.directory ${FLUTTER_DIR} && \
    flutter precache && \
    flutter config --no-analytics && \
    dart --disable-analytics

RUN echo "=============================================" && \
    echo dart $(dart --version) && \
    echo flutter $(flutter --version) && \
    echo "============================================="

##################################################################
#                   GO compillers
##################################################################
RUN mkdir -p ${GO_DIR}
ADD ${GO_DOWNLOAD_URL} /tmp

RUN tar -xzf ${GO_TEMP} --directory ${GO_DIR} --strip-components=1 && \
    chmod +x ${GO_BIN_DIR}/go && \
    chmod +x ${GO_BIN_DIR}/gofmt

ENV GOPATH=${GO_DIR}
ENV PATH="${GO_BIN_DIR}:${PATH}"

RUN echo "=============================================" && \
    echo go $(go version) && \
    echo "============================================="

##################################################################
#                   Get NINJA binary
##################################################################
RUN mkdir -p ${NINJA_BIN_DIR}
ADD ${NINJA_DOWNLOAD_URL} /tmp

RUN 7zz x ${NINJA_TEMP} -o${NINJA_BIN_DIR} -y  && \
    chmod +x ${NINJA_BIN_DIR}/ninja

ENV PATH="${NINJA_BIN_DIR}:${PATH}"

RUN echo "=============================================" && \
    echo ninja $(ninja --version) && \
    echo "============================================="

##################################################################
#                   deps
##################################################################
RUN apt-get update && \
    apt-get install -y --allow-unauthenticated --no-install-recommends --no-install-suggests --allow-downgrades \
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
    libc6 \
    libgssapi-krb5-2 \
    libstdc++6 \
    zlib1g \
    tcl

##################################################################
#                    docker setup
##################################################################

#Install packages
RUN install -m 0755 -d /etc/apt/keyrings && \
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc && \
    chmod a+r /etc/apt/keyrings/docker.asc && \
    echo "deb [signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu noble nightly" > /etc/apt/sources.list.d/docker.list  && \
    echo "deb [signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu noble stable" >> /etc/apt/sources.list.d/docker.list  && \
    echo "deb [signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu noble test" >> /etc/apt/sources.list.d/docker.list  && \
    apt-get update && \
    apt-get install -y --no-install-recommends --allow-unauthenticated \
        docker-ce \
        docker-ce-cli \
        containerd.io \
        docker-buildx-plugin \
        docker-compose-plugin

# A better fix for TW-52939 Dockerfile build fails because of aufs
VOLUME /var/lib/docker

COPY run-docker.sh /services/run-docker.sh
RUN chmod +x /services/run-docker.sh && \
    sync

##################################################################
#                    docker compose setup
##################################################################
COPY docker-compose-update /usr/local/bin/docker-compose-update
RUN chmod +x /usr/local/bin/docker-compose-update && \
    sync

#Try to test
RUN docker-compose-update

#Install packages
RUN export DOCKER_COMPOSE_VERSION=`curl --silent https://api.github.com/repos/docker/compose/releases/latest | jq .name -r` && \
    echo "Latest compose is: ${DOCKER_COMPOSE_VERSION}" && \
    curl -SL https://github.com/docker/compose/releases/download/${DOCKER_COMPOSE_VERSION}/docker-compose-Linux-x86_64 -o /usr/local/bin/docker-compose && \
    chmod +x /usr/local/bin/docker-compose && \
    docker-compose -v


##################################################################
#                   installing java11
##################################################################
ADD ${K_JDK_URL} /tmp
RUN tar -xvzf ${K_JDK_TEMP} --directory /usr/local && \
    ln -sfv ${JAVA_HOME} /usr/jre && \
    java -version

##################################################################
#                   Additional settings
##################################################################
ENV MAVEN_VERSION=3.9.9
ENV MAVEN_LINK=https://dlcdn.apache.org/maven/maven-3/${MAVEN_VERSION}/binaries/apache-maven-${MAVEN_VERSION}-bin.zip
ENV MAVEN_ROOT=${EMG_LOCAL_BASE_DIR}/maven/${MAVEN_VERSION}
ENV MAVEN_PATH=${MAVEN_ROOT}/apache-maven-${MAVEN_VERSION}
ENV MAVEN_BIN=${MAVEN_PATH}/bin
ARG MAVEN_TEMP=/tmp/apache-maven-${MAVEN_VERSION}-bin.zip

ENV GRADLE_VERSION=8.13
ENV GRADLE_LINK=https://services.gradle.org/distributions/gradle-${GRADLE_VERSION}-all.zip
ENV GRADLE_ROOT=${EMG_LOCAL_BASE_DIR}/gradle/${GRADLE_VERSION}
ENV GRADLE_PATH=${GRADLE_ROOT}/gradle-${GRADLE_VERSION}
ENV GRADLE_BIN=${GRADLE_PATH}/bin
ARG GRADLE_TEMP=/tmp/gradle-${GRADLE_VERSION}-all.zip

ENV KTC_VERSION=2.1.10
ENV KTC_LINK=https://github.com/JetBrains/kotlin/releases/download/v${KTC_VERSION}/kotlin-compiler-${KTC_VERSION}.zip
ARG KTC_TEMP=/tmp/kotlin-compiler-${KTC_VERSION}.zip
ENV KTC_ROOT=${EMG_LOCAL_BASE_DIR}/kotlin/${KTC_VERSION}
ENV KTC_PATH=${KTC_ROOT}/kotlinc
ENV KTC_BIN=${KTC_PATH}/bin

ENV KNPL_VERSION=${KTC_VERSION}
ENV KNPL_LINK=https://github.com/JetBrains/kotlin/releases/download/v${KNPL_VERSION}/kotlin-native-prebuilt-linux-x86_64-${KNPL_VERSION}.tar.gz
ARG KNPL_TEMP=/tmp/kotlin-native-prebuilt-linux-x86_64-${KNPL_VERSION}.tar.gz
ENV KNPL_ROOT=${EMG_LOCAL_BASE_DIR}/kotlin/${KNPL_VERSION}
ENV KNPL_PATH=${KNPL_ROOT}/kotlin-native-prebuilt-linux-x86_64-${KNPL_VERSION}
ENV KNPL_BIN=${KNPL_PATH}/bin

RUN mkdir -p ${MAVEN_PATH} ${KTC_PATH} ${KNPL_PATH} ${GRADLE_PATH}
ENV PATH=${PATH}:${MAVEN_BIN}:${GRADLE_BIN}:${KTC_BIN}:${KNPL_BIN}

##################################################################
#                   Maven
##################################################################
ENV MAVEN_HOME=${MAVEN_ROOT}
ENV M2_HOME=${MAVEN_ROOT}

ADD ${MAVEN_LINK} /tmp
RUN 7zz x ${MAVEN_TEMP} -o${MAVEN_ROOT}
RUN chmod +x -R ${MAVEN_BIN}
RUN mvn -v

##################################################################
#                   GRADLE
##################################################################
ADD ${GRADLE_LINK} /tmp
RUN 7zz x ${GRADLE_TEMP} -o${GRADLE_ROOT}
RUN chmod +x -R ${GRADLE_BIN}
RUN gradle -v

##################################################################
#                   kotlin-compiler
##################################################################
ADD ${KTC_LINK} /tmp
RUN 7zz x ${KTC_TEMP} -o${KTC_ROOT}
RUN chmod +x -R ${KTC_BIN}
RUN kotlin -version

##################################################################
#                   kotlin-native-prebuilt-linux
##################################################################
ADD ${KNPL_LINK} /tmp
RUN tar -xvzf ${KNPL_TEMP} --directory ${KTC_ROOT}
RUN chmod +x -R ${KNPL_BIN}

##################################################################
#                   Android SDK
##################################################################
RUN apt-get update && \
    apt-get install -y --allow-unauthenticated --no-install-recommends --no-install-suggests \
      android-sdk \
      android-sdk-build-tools \
      android-sdk-platform-tools-common \
      android-sdk-platform-tools \
      adb fastboot f2fs-tools e2fsprogs libsqlite3-0 sqlite3

##################################################################
#                   Activate Android SDK
##################################################################
RUN echo "24333f8a63b6825ea9c5514f83c2829b004d1fee" > /usr/lib/android-sdk/licenses/android-sdk-license

##################################################################
#                   installing dotnet
##################################################################
ADD ${DOTNET_INSTALL_SCRIPT_URL} /tmp
RUN mkdir -p ${DOTNET_ROOT} && \ 
    chmod +x /tmp/dotnet-install.sh && \
    /tmp/dotnet-install.sh --verbose --no-path --install-dir ${DOTNET_ROOT} --channel ${DOTNET_CHANNEL} --version latest

##################################################################
#                   Setup $PATH
##################################################################
ENV PATH=$PATH:${DOTNET_ROOT}:${DOTNET_TOOLS_DIR}

##################################################################
#                   Version after install
##################################################################
RUN echo "=============================================" && \
    echo $(dotnet --info) && \
    echo $(dotnet --list-sdks) && \
    echo $(dotnet --list-runtimes) && \
    echo "============================================="

##################################################################
#                    Mono
##################################################################
RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 3FA7E0328081BFF6A14DA29AA6A19B38D3D831EF && \
    echo "deb https://download.mono-project.com/repo/ubuntu stable-focal main" | sudo tee /etc/apt/sources.list.d/mono-official-stable.list && \
#    echo "deb https://download.mono-project.com/repo/ubuntu nightly-focal main" | sudo tee /etc/apt/sources.list.d/mono-official-nightly.list && \
#    echo "deb https://download.mono-project.com/repo/ubuntu preview-focal main" | sudo tee /etc/apt/sources.list.d/mono-official-preview.list && \
    apt-get update && \
    apt-get install -y  --allow-unauthenticated \
    mono-complete \
    mono-llvm-support \
    mono-devel \
    mono-dbg \
    referenceassemblies-pcl \
    ca-certificates-mono \
    mono-xsp4

##################################################################
#                   Node.js 22.x
##################################################################
RUN groupadd -g 1337 node && \
    useradd  -u 1337 --gid node --shell /bin/bash --create-home node

ADD ${K_NODE_URL} /tmp
ADD ${K_NODE_HEADERS_URL} /tmp

RUN tar -xvzf /tmp/node-v${K_NODE_VERSION}-linux-x64.tar.gz --strip-components=1 --directory /usr/local && \
    tar -xvzf /tmp/node-v${K_NODE_VERSION}-headers.tar.gz --strip-components=1 --directory /usr/local && \
    rm -rfv /usr/local/CHANGELOG.md /usr/local/LICENSE /usr/local/README.md

RUN npm install -g pnpm yarn

##################################################################
#                   Version after install
##################################################################
RUN echo "=============================================" && \
    echo node $(node --version) && \
    echo npm $(npm --version) && \
    echo yarn $(yarn --version) && \
    echo pnpm $(pnpm --version) && \
    echo "============================================="

##################################################################
#                   other   customisations
##################################################################

##################################################################
#                  Cleanup
##################################################################
RUN echo "clean up" && \
    apt-get clean -y && \
    apt-get autoclean -y && \
    rm -rfv /var/lib/apt/lists/* && \
    rm -rfv /var/cache/apt/archives/*.deb && \
    rm -rfv /root/tmp/* && \
    rm -rfv /tmp/*

RUN updatedb
