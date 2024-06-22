FROM jetbrains/teamcity-server
LABEL maintainer="EpicMorg DevTeam, developer@epicm.org"
LABEL org.opencontainers.image.vendor="EpicMorg DevTeam, developer@epicm.org"
LABEL org.opencontainers.image.authors="STAM, kasthack, Aleks-Z"
LABEL org.opencontainers.image.source="https://github.com/EpicMorg/docker"
LABEL org.opencontainers.image.url="https://github.com/EpicMorg/docker"
LABEL donate.crypto.TON="EQDvHXRK-K1ZieJhgTD9JZQk7xCnWzRbctYnUkWq1lZq1bUg"
LABEL donate.crypto.ETH="0x26a8443a694f08cdfec966aa6fd72c45068753ec"
LABEL donate.crypto.BTC="bc1querz8ug9asjmsuy6yn4a94a2athgprnu7e5zq2"
LABEL donate.crypto.LTC="ltc1qtwwacq8f0n76fer2y83wxu540hddnmf8cdrlvg"
LABEL donate.crypto.NVC="4SbMynYETyhmKdggu8f38ULU6yQKiJPuo6"
LABEL donate.crypto.DOGE="DHyfE1CZzWtyaQiaMmv6g4KvXVQRUgrYE6"
LABEL donate.crypto.PPC="pQWArPzYoLppNe7ew3QPfto1k1eq66BYUB"
LABEL donate.crypto.RVN="R9t2LKeLhDSZBKNgUzSDZAossA3UqNvbV3"
LABEL donate.crypto.ZEC="t1KRMMmwMSZth8vJcd2ZHtPEFKTQ74yVixE"
LABEL donate.crypto.XMR="884PqZ1gDjWW7fKxtbaeRoBeSh9EGZbkqUyLriWmuKbwLZrAJdYUs4wQxoVfEJoW7LBhdQMP9cFhZQpJr6xvg7esHLdCbb1"
ARG DEBIAN_FRONTEND=noninteractive
USER root

##################################################################
#                  editing sources list
##################################################################
COPY sources.list /etc/apt/sources.list
COPY locale.gen /etc/locale.gen

##################################################################
#                   7z official binary
##################################################################
ARG SZ_VERSION=7z2400
ARG SZ_DOWNLOAD_URL=https://www.7-zip.org/a/${SZ_VERSION}-linux-x64.tar.xz

##################################################################
#                   perforce client binary
##################################################################
ARG P4_VERSION=r21.2
ARG P4_DOWNLOAD_URL=http://www.perforce.com/downloads/perforce/${P4_VERSION}/bin.linux26x86_64/p4

##################################################################
#                   installing utils
##################################################################
RUN echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections && \
    apt-get update &&  \
    apt-get install -y --allow-unauthenticated \
    apt-transport-https \
    apt-utils \
    bash \
    binutils \
    ca-certificates \
    cmatrix \
    cmatrix-xfont \
    console-cyrillic \
    cron \
    curl \
    git \
    gnupg \
    gnupg2 \
    htop \
    iftop \
    iputils-ping \
    jq \
    kmod \
    locales \
    lsb-release \
    lsof \
    lynx \
    mc \
    mercurial \
    nano \
    nload \
    nmap \
    openssl \
    perl \
    procps \
    rsync \
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
    wget \
    zip

##################################################################
#                   Install 7z official binary
##################################################################
RUN wget --no-check-certificate -nv --random-wait --retry-connrefused --continue -O /tmp/7z.tar.xz ${SZ_DOWNLOAD_URL} && \
    mkdir -p /tmp/7z && \
    tar -xf /tmp/7z.tar.xz -C /tmp/7z && \
    chmod +x /tmp/7z/7zz && \
    mv -fv /tmp/7z/7zz /usr/bin/ && \
    7zz | head -4 && \
    7z | head -4

##################################################################
#                   Additional settings
##################################################################
ENV MAVEN_VERSION=3.9.6
ENV MAVEN_LINK=https://dlcdn.apache.org/maven/maven-3/${MAVEN_VERSION}/binaries/apache-maven-${MAVEN_VERSION}-bin.zip
ENV MAVEN_ROOT=/opt/maven
ENV MAVEN_PATH=${MAVEN_ROOT}/apache-maven-${MAVEN_VERSION}
ENV MAVEN_BIN=${MAVEN_PATH}/bin
ARG MAVEN_TEMP=/tmp/apache-maven-${MAVEN_VERSION}-bin.zip

ENV GRADLE_VERSION=8.6
ENV GRADLE_LINK=https://services.gradle.org/distributions/gradle-${GRADLE_VERSION}-all.zip
ENV GRADLE_ROOT=/opt/gradle
ENV GRADLE_PATH=${GRADLE_ROOT}/gradle-${GRADLE_VERSION}
ENV GRADLE_BIN=${GRADLE_PATH}/bin
ARG GRADLE_TEMP=/tmp/gradle-${GRADLE_VERSION}-all.zip

ENV KTC_VERSION=1.9.22
ENV KTC_LINK=https://github.com/JetBrains/kotlin/releases/download/v${KTC_VERSION}/kotlin-compiler-${KTC_VERSION}.zip
ARG KTC_TEMP=/tmp/kotlin-compiler-${KTC_VERSION}.zip
ENV KTC_ROOT=/opt/kotlin
ENV KTC_PATH=${KTC_ROOT}/kotlinc
ENV KTC_BIN=${KTC_PATH}/bin

RUN mkdir -p ${MAVEN_PATH} ${KTC_PATH} ${GRADLE_PATH}
ENV PATH=${PATH}:${MAVEN_BIN}:${GRADLE_BIN}:${KTC_BIN}

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
#                   KOTLIN
##################################################################
ADD ${KTC_LINK} /tmp
RUN 7zz x $KTC_TEMP -o${KTC_ROOT}
RUN chmod +x -R ${KTC_BIN}
RUN kotlin -version

##################################################################
#                   Install p4client
##################################################################
RUN wget --no-check-certificate -nv --random-wait --retry-connrefused --continue -P /usr/bin ${P4_DOWNLOAD_URL} && \
    chmod +x /usr/bin/p4
