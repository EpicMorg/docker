FROM quay.io/epicmorg/astralinux:1.8-rootfs
LABEL maintainer="EpicMorg DevTeam, developer@epicm.org"

##################################################################
#                   prepare system
##################################################################
RUN for i in $(seq 1 8); do mkdir -p "/usr/share/man/man${i}"; done
RUN mkdir -p /etc/apt/keyrings

##################################################################
#                   sources list
##################################################################
RUN rm -rfv /etc/apt/sources.list
RUN rm -rfv /etc/apt/sources.list.d/debian.sources 
RUN rm -rfv /etc/locale.gen

COPY etc/apt/apt.conf.d/99-no-check-valid-until /etc/apt/apt.conf.d/99-no-check-valid-until
COPY etc/apt/apt.conf.d/98-allow-unauthenticated /etc/apt/apt.conf.d/98-allow-unauthenticated
COPY etc/apt/apt.conf.d/97-allow-cert-exp /etc/apt/apt.conf.d/97-allow-cert-exp
COPY etc/apt/apt.conf.d/96-apt-retries /etc/apt/apt.conf.d/96-apt-retries
COPY etc/apt/sources.list /etc/apt/sources.list
COPY etc/locale.gen /etc/locale.gen
COPY usr/local/share/ca-certificates /usr/local/share/ca-certificates

RUN mkdir -p /etc/apt/keyrings
RUN apt-get update && \
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
    coreutils \
    curl \
    dirmngr \
    file \
    gnupg \
    gnupg1 \
    gnupg2 \
    locales \
    locate \
#    rar \
    software-properties-common \
    sudo \
    unrar \
    unrar-free \
    unzip \
    wget \
    zip

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
COPY usr/local/epicmorg ${EMG_LOCAL_BASE_DIR}
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
