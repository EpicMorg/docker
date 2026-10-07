# git + git-lfs: newest epicmorg/git and epicmorg/git-lfs (floating toolchain tags,
# ADR-060). They are themselves built FROM this image - the loop is closed by using
# the last published release (bootstrap).
FROM ghcr.io/epicmorg/git:latest AS git
FROM ghcr.io/epicmorg/git-lfs:latest AS git-lfs

FROM ghcr.io/epicmorg/debian:trixie-light
LABEL maintainer="EpicMorg DevTeam, developer@epicm.org"
ARG DEBIAN_FRONTEND=noninteractive

##################################################################
#                   ARGuments
##################################################################
RUN echo "Default folder for installation of customized soft is: ${EMG_LOCAL_BASE_DIR}"

ENV P4_VERSION=r26.1
ARG P4_BIN_DIR=${EMG_LOCAL_BASE_DIR}/p4/${P4_VERSION}/bin
ARG P4_DOWNLOAD_URL=https://filehost.perforce.com/perforce/${P4_VERSION}/bin.linux26x86_64/p4

ENV SZ_VERSION=7z2602
ARG SZ_BIN_DIR=${EMG_LOCAL_BASE_DIR}/7z/${SZ_VERSION}/bin
ARG SZ_DOWNLOAD_URL=https://www.7-zip.org/a/${SZ_VERSION}-linux-x64.tar.xz
ARG SZ_TEMP=/tmp/${SZ_VERSION}-linux-x64.tar.xz

ARG DUMB_INIT_VERSION=1.2.5
ARG DUMB_INIT_BIN_DIR=${EMG_LOCAL_BASE_DIR}/dumb-init/${DUMB_INIT_VERSION}/bin
ARG DUMB_INIT_DOWNLOAD_URL=https://github.com/Yelp/dumb-init/releases/download/v${DUMB_INIT_VERSION}/dumb-init_${DUMB_INIT_VERSION}_x86_64

ARG GOSU_VERSION=1.19
ARG GOSU_BIN_DIR=${EMG_LOCAL_BASE_DIR}/gosu/${GOSU_VERSION}/bin
ARG GOSU_DOWNLOAD_URL=https://github.com/tianon/gosu/releases/download/${GOSU_VERSION}/gosu-amd64

##################################################################
#        git + git-lfs from epicmorg/git(-lfs) (ADR-060)
##################################################################
# /emg-export = git (or git-lfs) + exactly the baked libs it links. Binaries are
# symlinked into /usr/bin (tools look for /usr/bin/git), and a placeholder deb
# "provides" git, git-man, git-email, git-cvs, git-doc, git-lfs so apt
# dependencies (git-extras, git-flow, git-ftp, git-crypt ...) are met without
# Debian's git; block-git-packages pins Debian's builds out for good.
COPY --from=git /emg-export/ /
COPY --from=git-lfs /emg-export/ /
COPY etc/apt/preferences.d/block-git-packages /etc/apt/preferences.d/block-git-packages
RUN set -eux; \
    git_dir="$(find "${EMG_LOCAL_BASE_DIR}/git" -mindepth 1 -maxdepth 1 -type d)"; \
    lfs_dir="$(find "${EMG_LOCAL_BASE_DIR}/git-lfs" -mindepth 1 -maxdepth 1 -type d)"; \
    [ "$(echo "$git_dir" | wc -l)" = 1 ] && [ "$(echo "$lfs_dir" | wc -l)" = 1 ]; \
    for b in "$git_dir"/bin/* "$lfs_dir"/bin/git-lfs; do ln -sfn "$b" "/usr/bin/$(basename "$b")"; done; \
    gv="$(git --version | awk '{print $3}')"; \
    lv="$(git-lfs version | sed -E 's#^git-lfs/([0-9.]+).*#\1#')"; \
    d="$(mktemp -d)"; mkdir -p "$d/DEBIAN"; \
    printf '%s\n' \
      "Package: epicmorg-git" \
      "Version: 1:${gv}-epicmorg" \
      "Architecture: all" \
      "Maintainer: EpicMorg DevTeam <developer@epicm.org>" \
      "Section: vcs" \
      "Priority: optional" \
      "Provides: git (= 1:${gv}), git-core (= 1:${gv}), git-man (= 1:${gv}), git-email (= 1:${gv}), git-cvs (= 1:${gv}), git-doc (= 1:${gv}), git-lfs (= ${lv})" \
      "Conflicts: git, git-core, git-man, git-email, git-cvs, git-doc, git-lfs" \
      "Replaces: git, git-core, git-man, git-email, git-cvs, git-doc, git-lfs" \
      "Description: git ${gv} + git-lfs ${lv} from epicmorg/git and epicmorg/git-lfs" \
      " Placeholder: the binaries live in ${EMG_LOCAL_BASE_DIR} and are symlinked into /usr/bin." \
      > "$d/DEBIAN/control"; \
    dpkg-deb --build "$d" /tmp/epicmorg-git.deb; \
    dpkg -i /tmp/epicmorg-git.deb; \
    rm -rf "$d" /tmp/epicmorg-git.deb; \
    git lfs install --system --skip-repo; \
    echo "=============================================" && \
    echo git $(git --version) && \
    echo git-lfs $(git-lfs version) && \
    echo "============================================="

##################################################################
#                   installing utils
##################################################################
RUN echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections && \
    apt-get update && \
    apt-get install -y \
        bzip2 \
        lbzip2 \
        cmatrix \
        cmatrix-xfont \
        cron \
        curl \
        clzip \
        dos2unix \
        ffmpeg \
        fontconfig \
        fontconfig-config \
        git-extras \
        libexpat1 \
        libio-socket-ssl-perl \
        libauthen-sasl-perl \
        libnet-smtp-ssl-perl \
        libdbd-sqlite3-perl \
        man-db \
        git-flow \
        git-crypt \
        git-ftp \
        gnupg \
        gnupg2 \
        graphicsmagick \
        gzip \
        htop \
        iftop \
        iotop \
        iperf \
        iperf3 \
        iputils-ping \
        jq \
        kmod \
        libxml2-dev \
        libxml2-utils \
        libatomic1 \
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
        screen \
        screenfetch \
        smbclient \
        subversion \
        telnet \
        tmux \
        vim \
        tree \
        util-linux \
        uuid-runtime \
        unrar \
        xz-utils \
        wget \
        zip \
        tini \
        libzip5 \
        acl \
        aptitude  \
        sudo  \
        cvs \
        python3-pip \
        python3-all \
        rclone \
        logrotate \
        subversion-tools \
        pev

##################################################################
#                   installing fs-tools
##################################################################
RUN echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections && \
    apt-get install -y --allow-unauthenticated --no-install-recommends --no-install-suggests \
        duperemove \
        parted \
        fuse2fs \
        e2fsck-static \
        keyutils \
        jmtpfs \
        btrfs-progs \
        e2fsprogs \
        f2fs-tools \
        dosfstools \
#        hfsutils \
        hfsprogs \
        jfsutils \
        mdadm \
        util-linux \
        cryptsetup \
        lvm2 \
        nilfs-tools \
        ntfs-3g \
#        reiser4progs \
        reiserfsprogs \
        udftools \
        xfsprogs \
        xfsdump \
        zfsutils-linux

##################################################################
#                   git / git-lfs man pages (man-db)
##################################################################
RUN set -eux; \
    for d in "${EMG_LOCAL_BASE_DIR}"/git/*/share/man "${EMG_LOCAL_BASE_DIR}"/git-lfs/*/share/man; do \
      [ -d "$d" ] && echo "MANDATORY_MANPATH $d" >> /etc/manpath.config; \
    done; \
    man -w git

##################################################################
#                   gh official binary
##################################################################
RUN curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | gpg --batch --yes --dearmor -o /etc/apt/keyrings/githubcli-archive-keyring.gpg && \
    chmod go+r /etc/apt/keyrings/githubcli-archive-keyring.gpg && \
    rm -rfv /etc/apt/sources.list.d/github-cli.list && \
    rm -rfv /etc/apt/sources.list.d/github-cli.sources

COPY etc/apt/sources.list.d/github-cli.sources /etc/apt/sources.list.d/github-cli.sources
RUN apt-get update &&  \
    apt-get install -y --allow-unauthenticated --no-install-recommends --no-install-suggests \
    gh

RUN echo "=============================================" && \
    echo gh $(gh --version) && \
    echo "============================================="

##################################################################
#                   Install p4client
##################################################################
RUN set -eux; \
    mkdir -p ${P4_BIN_DIR} && \
    aria2c \
        --conf-path="/usr/local/share/epicmorg/aria2/config/aria2.conf" \
        --user-agent="$(shuf -n 1 /usr/local/share/epicmorg/user-agents/user-agents.txt)" \
        -d ${P4_BIN_DIR} \
        "${P4_DOWNLOAD_URL}" && \
    chmod +x ${P4_BIN_DIR}/p4

ENV PATH="${P4_BIN_DIR}:${PATH}"

##################################################################
#                   Install 7z official binary
##################################################################
RUN set -eux; \
    mkdir -p ${SZ_BIN_DIR} && \
    aria2c \
        --conf-path="/usr/local/share/epicmorg/aria2/config/aria2.conf" \
        --user-agent="$(shuf -n 1 /usr/local/share/epicmorg/user-agents/user-agents.txt)" \
        -d / \
        -o ${SZ_TEMP} \
        "${SZ_DOWNLOAD_URL}" && \
    tar -xf ${SZ_TEMP} --directory ${SZ_BIN_DIR} && \
    chmod +x ${SZ_BIN_DIR}/7zz && \
    chmod +x ${SZ_BIN_DIR}/7zzs && \
    find ${SZ_BIN_DIR} -maxdepth 1 -mindepth 1 ! -name '7zz' ! -name '7zzs' -exec mv {} ${SZ_BIN_DIR}/.. \; && \
    rm -rfv ${SZ_TEMP}

ENV PATH="${SZ_BIN_DIR}:${PATH}"

RUN echo "=============================================" && \
    echo 7zz $(7zz | head -4) && \
    echo 7z $(7z | head -4) && \
    echo "============================================="

##################################################################
#                    dumb init
##################################################################
RUN set -eux; \
    mkdir -p ${DUMB_INIT_BIN_DIR} && \
    aria2c \
        --conf-path="/usr/local/share/epicmorg/aria2/config/aria2.conf" \
        --user-agent="$(shuf -n 1 /usr/local/share/epicmorg/user-agents/user-agents.txt)" \
        -d / \
        -o ${DUMB_INIT_BIN_DIR}/dumb-init \
        "${DUMB_INIT_DOWNLOAD_URL}" && \
    chmod +x ${DUMB_INIT_BIN_DIR}/dumb-init

ENV PATH="${DUMB_INIT_BIN_DIR}:${PATH}"

RUN echo "=============================================" && \
    echo dumb-init $(dumb-init --version) && \
    echo "============================================="

##################################################################
#                    gosu
##################################################################
RUN set -eux; \
    mkdir -p ${GOSU_BIN_DIR} && \
    aria2c \
        --conf-path="/usr/local/share/epicmorg/aria2/config/aria2.conf" \
        --user-agent="$(shuf -n 1 /usr/local/share/epicmorg/user-agents/user-agents.txt)" \
        -d / \
        -o ${GOSU_BIN_DIR}/gosu \
        "${GOSU_DOWNLOAD_URL}" && \
    chmod +x ${GOSU_BIN_DIR}/gosu

ENV PATH="${GOSU_BIN_DIR}:${PATH}"

RUN echo "=============================================" && \
    echo gosu $(gosu --version) && \
    echo "============================================="

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
 