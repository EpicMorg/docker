FROM docker.io/epicmorg/astralinux:1.8-rootfs
LABEL maintainer="EpicMorg DevTeam, developer@epicm.org"
LABEL org.opencontainers.image.vendor="EpicMorg DevTeam, developer@epicm.org"
LABEL org.opencontainers.image.authors="STAM, kasthack, Aleks-Z"
LABEL org.opencontainers.image.source="https://github.com/EpicMorg/docker"
LABEL org.opencontainers.image.title="EpicMorg Astra Linux 1.8 (ALSE)"
LABEL org.opencontainers.image.description="Astra Linux 1.8 SE base by EpicMorg"
LABEL org.opencontainers.image.licenses="MIT"
LABEL org.opencontainers.image.documentation="https://github.com/EpicMorg/docker"
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
#                   prepare system
##################################################################
RUN for i in $(seq 1 8); do mkdir -p "/usr/share/man/man${i}"; done
RUN mkdir -p /etc/apt/keyrings

##################################################################
#                   sources list
##################################################################
# Astra's own repositories (etc/apt/sources.list) are kept as they are -
# no Debian mirrors. sources.list.d is NOT wiped: the rootfs ships Astra's
# (commented-out) hotfix list there; only a stray debian.sources is removed.
RUN rm -rfv /etc/apt/sources.list
RUN rm -rfv /etc/apt/sources.list.d/debian.sources
RUN rm -rfv /etc/locale.gen

COPY etc/apt /etc/apt
COPY etc/locale.gen /etc/locale.gen
COPY usr/local/share/ca-certificates /usr/local/share/ca-certificates

# Astra's apt refuses plain `apt-get upgrade` (APT::Get::EnableUpgrade is off
# by design) - dist-upgrade only.
RUN apt-get update && \
    apt-get dist-upgrade -y

##################################################################
#                   installing utils
##################################################################
# Dropped vs trixie (not in Astra 1.8 repositories): rar (deb-multimedia only)
RUN apt-get update && \
    apt-get dist-upgrade -y && \
    echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections && \
    apt-get install -y \
        apt-transport-https \
        apt-utils \
        gnupg \
        gnupg1 \
        gnupg2 \
        bash \
        binutils \
        console-cyrillic \
        ca-certificates \
        dirmngr \
        dos2unix \
        lsb-release \
        locales \
        locate \
        logrotate \
        sudo \
        rsync \
        htop \
        iputils-ping \
        net-tools \
        lsof \
        mc \
        curl \
        tini \
        tree \
        unrar \
        unrar-free \
        unzip \
        zip \
        wget \
        aria2 \
        aptitude \
        coreutils \
        file \
        software-properties-common && \
    # cleanup
    apt-get clean -y && \
    apt-get autoclean -y && \
    rm -rfv /var/lib/apt/lists/* && \
    rm -rfv /tmp/* && \
    rm -rfv /var/cache/apt/archives/*.deb

RUN update-ca-certificates --fresh

##################################################################
#                  update locales
##################################################################
RUN locale-gen

##################################################################
#                  Create Base directory for various soft
##################################################################
ENV EMG_LOCAL_BASE_DIR=/usr/local/share/epicmorg
ENV EMG_WELCOME_MESSAGE=true
ENV EMG_DONATION_MESSAGE=true
RUN mkdir -p ${EMG_LOCAL_BASE_DIR}
COPY usr/local/share/epicmorg ${EMG_LOCAL_BASE_DIR}
RUN chmod +x ${EMG_LOCAL_BASE_DIR}/welcome.sh && \
    echo '[ ! -z "$TERM" -a -x ${EMG_LOCAL_BASE_DIR}/welcome.sh -a -x ${EMG_LOCAL_BASE_DIR}/welcome.sh ] && ${EMG_LOCAL_BASE_DIR}/welcome.sh' >> /etc/bash.bashrc

##################################################################
#                  Prepare dhparam.pem (4096 bit)
##################################################################
ENV SSL_DHPARAM_FILE=/etc/ssl/dhparam.pem
COPY etc/ssl/dhparam.pem ${SSL_DHPARAM_FILE}
RUN openssl dhparam -in ${SSL_DHPARAM_FILE} -text -noout | grep bit

##################################################################
#                   Set default workdir
##################################################################
WORKDIR ${EMG_LOCAL_BASE_DIR}

##################################################################
# Fix for requests library (python) to use system CA certificates
##################################################################
ENV REQUESTS_CA_BUNDLE=/etc/ssl/certs/ca-certificates.crt

##################################################################
#                   Assertions
##################################################################
# Fatal: our CAs are in the system bundle, locales were generated, the
# aria2 / user-agents helpers that every child image relies on are usable.
RUN set -eu; \
    for crt in /usr/local/share/ca-certificates/*.crt; do \
      test -e "/etc/ssl/certs/$(basename "$crt" .crt).pem" \
        || { echo "FATAL: $crt not linked into /etc/ssl/certs" >&2; exit 1; }; \
      grep -qF "$(sed -n 2p "$crt")" /etc/ssl/certs/ca-certificates.crt \
        || { echo "FATAL: $crt not in ca-certificates.crt" >&2; exit 1; }; \
    done; \
    test -s "${REQUESTS_CA_BUNDLE}" || { echo "FATAL: no CA bundle at ${REQUESTS_CA_BUNDLE}" >&2; exit 1; }; \
    for l in en_US.utf8 en_GB.utf8 ru_RU.utf8 ru_RU.cp1251 ru_RU.koi8r ru_UA.utf8; do \
      locale -a | grep -qx "$l" || { echo "FATAL: locale $l not generated" >&2; locale -a >&2; exit 1; }; \
    done; \
    test -s ${EMG_LOCAL_BASE_DIR}/aria2/config/aria2.conf || { echo "FATAL: aria2.conf missing" >&2; exit 1; }; \
    test -s ${EMG_LOCAL_BASE_DIR}/user-agents/user-agents.txt || { echo "FATAL: user-agents.txt missing" >&2; exit 1; }; \
    aria2c --version | head -1; \
    tini --version; \
    echo "OK: light assertions"

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
