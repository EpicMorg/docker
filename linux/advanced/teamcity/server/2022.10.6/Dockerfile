FROM jetbrains/teamcity-server:2022.10.6
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

##################################################################
#                  Set temp user for advanced setup
#################################################################
USER root

##################################################################
#                  Create Base directory for various soft
##################################################################
ENV EMG_LOCAL_BASE_DIR=/usr/local/share/epicmorg
RUN mkdir -p ${EMG_LOCAL_BASE_DIR}
COPY usr/local/epicmorg ${EMG_LOCAL_BASE_DIR}

##################################################################
#                   prepare system
##################################################################
RUN for i in $(seq 1 8); do mkdir -p "/usr/share/man/man${i}"; done
RUN mkdir -p /etc/apt/keyrings

##################################################################
#                   ARGuments
##################################################################
ARG P4_VERSION=r24.1
ARG P4_BIN_DIR=${EMG_LOCAL_BASE_DIR}/p4/${P4_VERSION}/bin
ARG P4_DOWNLOAD_URL=https://filehost.perforce.com/perforce/${P4_VERSION}/bin.linux26x86_64/p4

ARG SZ_VERSION=7z2409
ARG SZ_BIN_DIR=${EMG_LOCAL_BASE_DIR}/7z/${SZ_VERSION}/bin
ARG SZ_DOWNLOAD_URL=https://www.7-zip.org/a/${SZ_VERSION}-linux-x64.tar.xz
ARG SZ_TEMP=/tmp/${SZ_VERSION}-linux-x64.tar.xz

ARG LAZYGIT_VERSION=0.42.0
ARG LAZYGIT_BIN_DIR=${EMG_LOCAL_BASE_DIR}/lazygit/${LAZYGIT_VERSION}/bin
ARG LAZYGIT_DOWNLOAD_URL=https://github.com/jesseduffield/lazygit/releases/download/v${LAZYGIT_VERSION}/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz
ARG LAZYGIT_TEMP=/tmp/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz

ARG LAZYCLI_VERSION=0.1.15
ARG LAZYCLI_BIN_DIR=${EMG_LOCAL_BASE_DIR}/lazycli/${LAZYCLI_VERSION}/bin
ARG LAZYCLI_DOWNLOAD_URL=https://github.com/jesseduffield/lazycli/releases/download/v${LAZYCLI_VERSION}/lazycli-linux-x64.tar.gz
ARG LAZYCLI_TEMP=/tmp/lazycli-linux-x64.tar.gz

ARG LAZYNPM_VERSION=0.1.4
ARG LAZYNPM_BIN_DIR=${EMG_LOCAL_BASE_DIR}/lazynpm/${LAZYNPM_VERSION}/bin
ARG LAZYNPM_DOWNLOAD_URL=https://github.com/jesseduffield/lazynpm/releases/download/v${LAZYNPM_VERSION}/lazynpm_${LAZYNPM_VERSION}_Linux_x86_64.tar.gz
ARG LAZYNPM_TEMP=/tmp/lazynpm_${LAZYNPM_VERSION}_Linux_x86_64.tar.gz

ARG LAZYDOCKER_VERSION=0.23.3
ARG LAZYDOCKER_BIN_DIR=${EMG_LOCAL_BASE_DIR}/lazydocker/${LAZYDOCKER_VERSION}/bin
ARG LAZYDOCKER_DOWNLOAD_URL=https://github.com/jesseduffield/lazydocker/releases/download/v${LAZYDOCKER_VERSION}/lazydocker_${LAZYDOCKER_VERSION}_Linux_x86_64.tar.gz
ARG LAZYDOCKER_TEMP=/tmp/lazydocker_${LAZYDOCKER_VERSION}_Linux_x86_64.tar.gz

ARG DUMB_INIT_VERSION=1.2.5
ARG DUMB_INIT_BIN_DIR=${EMG_LOCAL_BASE_DIR}/dumb-init/${DUMB_INIT_VERSION}/bin
ARG DUMB_INIT_DOWNLOAD_URL=https://github.com/Yelp/dumb-init/releases/download/v${DUMB_INIT_VERSION}/dumb-init_${DUMB_INIT_VERSION}_x86_64

ARG GOSU_VERSION=1.17
ARG GOSU_BIN_DIR=${EMG_LOCAL_BASE_DIR}/gosu/${GOSU_VERSION}/bin
ARG GOSU_DOWNLOAD_URL=https://github.com/tianon/gosu/releases/download/${GOSU_VERSION}/gosu-amd64

##################################################################
#                   Additional settings
##################################################################
ENV MAVEN_VERSION=3.9.11
ENV MAVEN_LINK=https://dlcdn.apache.org/maven/maven-3/${MAVEN_VERSION}/binaries/apache-maven-${MAVEN_VERSION}-bin.zip
ENV MAVEN_ROOT=${EMG_LOCAL_BASE_DIR}/maven/${MAVEN_VERSION}
ENV MAVEN_PATH=${MAVEN_ROOT}/apache-maven-${MAVEN_VERSION}
ENV MAVEN_BIN=${MAVEN_PATH}/bin
ARG MAVEN_TEMP=/tmp/apache-maven-${MAVEN_VERSION}-bin.zip

ENV GRADLE_VERSION=8.14
ENV GRADLE_LINK=https://services.gradle.org/distributions/gradle-${GRADLE_VERSION}-all.zip
ENV GRADLE_ROOT=${EMG_LOCAL_BASE_DIR}/gradle/${GRADLE_VERSION}
ENV GRADLE_PATH=${GRADLE_ROOT}/gradle-${GRADLE_VERSION}
ENV GRADLE_BIN=${GRADLE_PATH}/bin
ARG GRADLE_TEMP=/tmp/gradle-${GRADLE_VERSION}-all.zip

ENV KTC_VERSION=2.2.0
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
#                   update lists
##################################################################
RUN echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections && \
    apt-get update

##################################################################
#                   sources list
##################################################################
RUN rm -rfv /etc/apt/sources.list
RUN rm -rfv /etc/apt/sources.list.d/*.sources 
RUN rm -rfv /etc/locale.gen

COPY etc/apt/apt.conf.d/99-no-check-valid-until /etc/apt/apt.conf.d/99-no-check-valid-until
COPY etc/apt/apt.conf.d/98-allow-unauthenticated /etc/apt/apt.conf.d/98-allow-unauthenticated
COPY etc/apt/apt.conf.d/97-allow-cert-exp /etc/apt/apt.conf.d/97-allow-cert-exp
COPY etc/apt/apt.conf.d/96-apt-retries /etc/apt/apt.conf.d/96-apt-retries
COPY etc/apt/sources.list /etc/apt/sources.list
COPY etc/locale.gen /etc/locale.gen
COPY usr/local/share/ca-certificates /usr/local/share/ca-certificates

RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get dist-upgrade -y

##################################################################
#                   installing utils
##################################################################
RUN echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections && \
    apt-get install -y --allow-unauthenticated --no-install-recommends --no-install-suggests \
    apt-transport-https \
    apt-utils \
    aptitude \
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
    gnupg1 \
    gnupg2 \
    htop \
    iftop \
    iputils-ping \
    jq \
    kmod \
    locales \
    locate \
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
    rar \
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
    unrar \
    unrar-free \
    unzip \
    util-linux \
    uuid-runtime \
    wget \
    zip

RUN apt-key adv --keyserver keyserver.ubuntu.com --refresh-keys
RUN apt-key list  | grep "expired: " | sed -ne 's|pub .*/\([^ ]*\) .*|\1|gp' | xargs -n1  apt-key adv --keyserver keyserver.ubuntu.com --recv-keys

RUN update-ca-certificates --fresh

##################################################################
#                   Update JavaCA
##################################################################
RUN update-ca-certificates --fresh && \
    for cert in /usr/local/share/ca-certificates/*.crt; do \
        alias=$(basename "$cert" .crt); \
        keytool -importcert \
            -keystore "$JAVA_HOME/lib/security/cacerts" \
            -storepass changeit \
            -file "$cert" \
            -alias "$alias" \
            -noprompt; \
    done

##################################################################
#                  update locales
##################################################################
RUN locale-gen

##################################################################
#                   Install p4client
##################################################################
RUN mkdir -p ${P4_BIN_DIR}
ADD ${P4_DOWNLOAD_URL} ${P4_BIN_DIR}
RUN chmod +x ${P4_BIN_DIR}/p4
ENV PATH="${P4_BIN_DIR}:${PATH}"

# Update internal p4 binary to new
RUN rm -rfv /opt/perforce/bin/p4 && \
    ln -sfv ${P4_BIN_DIR}/p4 /opt/perforce/bin/p4  && \
    ln -sfv ${P4_BIN_DIR}/p4 /opt/perforce/usr/bin/p4

##################################################################
#                   Install 7z official binary
##################################################################
RUN mkdir -p ${SZ_BIN_DIR}
ADD ${SZ_DOWNLOAD_URL} /tmp

RUN tar -xf ${SZ_TEMP} --directory ${SZ_BIN_DIR} && \
    chmod +x ${SZ_BIN_DIR}/7zz && \
    chmod +x ${SZ_BIN_DIR}/7zzs && \
    find ${SZ_BIN_DIR} -maxdepth 1 -mindepth 1 ! -name '7zz' ! -name '7zzs' -exec mv {} ${SZ_BIN_DIR}/.. \;

ENV PATH="${SZ_BIN_DIR}:${PATH}"

RUN echo "=============================================" && \
    echo 7zz $(7zz | head -4) && \
    echo 7z $(7z | head -4) && \
    echo "============================================="

##################################################################
#                   Install LazyGit official binary
##################################################################
RUN mkdir -p ${LAZYGIT_BIN_DIR}
ADD ${LAZYGIT_DOWNLOAD_URL} /tmp

RUN tar -xzf ${LAZYGIT_TEMP} --directory ${LAZYGIT_BIN_DIR} && \
    chmod +x ${LAZYGIT_BIN_DIR}/lazygit && \
    find ${LAZYGIT_BIN_DIR} -maxdepth 1 -mindepth 1 ! -name 'lazygit' -exec mv {} ${LAZYGIT_BIN_DIR}/.. \;

ENV PATH="${LAZYGIT_BIN_DIR}:${PATH}"

RUN echo "=============================================" && \
    echo lazygit $(lazygit --version) && \
    echo "============================================="

##################################################################
#                   Install LazyCLI official binary
##################################################################
RUN mkdir -p ${LAZYCLI_BIN_DIR}
ADD ${LAZYCLI_DOWNLOAD_URL} /tmp

RUN tar -xzf ${LAZYCLI_TEMP} --directory ${LAZYCLI_BIN_DIR} && \
    chmod +x ${LAZYCLI_BIN_DIR}/lazycli && \
    find ${LAZYCLI_BIN_DIR} -maxdepth 1 -mindepth 1 ! -name 'lazycli' -exec mv {} ${LAZYCLI_BIN_DIR}/.. \;

ENV PATH="${LAZYCLI_BIN_DIR}:${PATH}"

RUN echo "=============================================" && \
    echo lazycli $(lazycli --version) && \
    echo "============================================="

##################################################################
#                   Install LazyNPM official binary
##################################################################
RUN mkdir -p ${LAZYNPM_BIN_DIR}
ADD ${LAZYNPM_DOWNLOAD_URL} /tmp

RUN tar -xzf ${LAZYNPM_TEMP} --directory ${LAZYNPM_BIN_DIR} && \
    chmod +x ${LAZYNPM_BIN_DIR}/lazynpm && \
    find ${LAZYNPM_BIN_DIR} -maxdepth 1 -mindepth 1 ! -name 'lazynpm' -exec mv {} ${LAZYNPM_BIN_DIR}/.. \;

ENV PATH="${LAZYNPM_BIN_DIR}:${PATH}"

RUN echo "=============================================" && \
    echo lazynpm $(lazynpm --version) && \
    echo "============================================="

##################################################################
#                   Install LazyDocker official binary
##################################################################
RUN mkdir -p ${LAZYDOCKER_BIN_DIR}
ADD ${LAZYDOCKER_DOWNLOAD_URL} /tmp

RUN tar -xzf ${LAZYDOCKER_TEMP} --directory ${LAZYDOCKER_BIN_DIR} && \
    chmod +x -R ${LAZYDOCKER_BIN_DIR}/lazydocker && \
    find ${LAZYDOCKER_BIN_DIR} -maxdepth 1 -mindepth 1 ! -name 'lazydocker' -exec mv {} ${LAZYDOCKER_BIN_DIR}/.. \;

ENV PATH="${LAZYDOCKER_BIN_DIR}:${PATH}"

RUN echo "=============================================" && \
    echo lazydocker $(lazydocker --version) && \
    echo "============================================="

##################################################################
#                    dumb init
##################################################################
RUN mkdir -p ${DUMB_INIT_BIN_DIR}
ADD ${DUMB_INIT_DOWNLOAD_URL} ${DUMB_INIT_BIN_DIR}

RUN mv -fv ${DUMB_INIT_BIN_DIR}/dumb-init_${DUMB_INIT_VERSION}_x86_64 ${DUMB_INIT_BIN_DIR}/dumb-init && \
    chmod +x ${DUMB_INIT_BIN_DIR}/dumb-init

ENV PATH="${DUMB_INIT_BIN_DIR}:${PATH}"

RUN echo "=============================================" && \
    echo dumb-init $(dumb-init --version) && \
    echo "============================================="

##################################################################
#                    gosu for easy step-down from root
##################################################################
RUN mkdir -p ${GOSU_BIN_DIR}
ADD ${GOSU_DOWNLOAD_URL} ${GOSU_BIN_DIR}

RUN mv -fv ${GOSU_BIN_DIR}/gosu-amd64  ${GOSU_BIN_DIR}/gosu && \
    chmod +x -R ${GOSU_BIN_DIR}/gosu

ENV PATH="${GOSU_BIN_DIR}:${PATH}"

RUN echo "=============================================" && \
    echo gosu $(gosu --version) && \
    echo "============================================="

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
RUN tar -xzf ${KNPL_TEMP} --directory ${KTC_ROOT}
RUN chmod +x -R ${KNPL_BIN}

##################################################################
#                   git fresh binary
##################################################################
RUN gpg --keyserver keyserver.ubuntu.com --recv-keys A1715D88E1DF1F24 && \
    gpg --export --output /etc/apt/keyrings/launchpad-git.gpg A1715D88E1DF1F24 && \
    rm -rfv /etc/apt/sources.list.d/launchpad_git-mainline.list && \
    rm -rfv /etc/apt/sources.list.d/launchpad_git-stable.list
COPY etc/apt/sources.list.d/launchpad_git-mainline.list /etc/apt/sources.list.d/launchpad_git-mainline.list
COPY etc/apt/sources.list.d/launchpad_git-stable.list /etc/apt/sources.list.d/launchpad_git-stable.list
RUN apt-get update &&  \
    apt-get install -y --allow-unauthenticated --no-install-recommends --no-install-suggests \
    git

RUN echo "=============================================" && \
    echo git $(git --version) && \
    echo "============================================="

##################################################################
#                   git-lfs official binary
##################################################################
RUN curl -fsSL https://packagecloud.io/github/git-lfs/gpgkey | gpg --dearmor > /etc/apt/keyrings/github_git-lfs-archive-keyring.gpg && \
    rm -rfv /etc/apt/sources.list.d/github_git-lfs.list
COPY etc/apt/sources.list.d/github_git-lfs.list /etc/apt/sources.list.d/github_git-lfs.list
RUN apt-get update &&  \
    apt-get install -y --allow-unauthenticated --no-install-recommends --no-install-suggests \
    git \
    git-lfs && \
    git-lfs install --skip-repo

RUN echo "=============================================" && \
    echo git $(git --version) && \
    echo git-lfs $(git-lfs --version) && \
    echo "============================================="

##################################################################
#                   gh official binary
##################################################################
RUN curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | gpg --batch --yes --dearmor -o /etc/apt/keyrings/githubcli-archive-keyring.gpg && \
    chmod go+r /etc/apt/keyrings/githubcli-archive-keyring.gpg && \
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list && \
    apt-get update &&  \
    apt-get install -y --allow-unauthenticated --no-install-recommends --no-install-suggests \
    gh

RUN echo "=============================================" && \
    echo gh $(gh --version) && \
    echo "============================================="

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

##################################################################
#                  update file db
##################################################################
RUN updatedb

##################################################################
#                  Set original user back
#################################################################
# tcuser 1000
#USER 1000
