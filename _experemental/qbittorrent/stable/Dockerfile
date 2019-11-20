FROM epicmorg/devel
LABEL maintainer="EpicMorg DevTeam, developer@epicm.org"
ARG DEBIAN_FRONTEND=noninteractive

##################################################################
#                   ARGuments
##################################################################
#ENV BuildDocker true
#ARG BUILDS_DIR=/builds
#ARG SRC_DIR=${BUILDS_DIR}/src
#ARG EXPORT_DIR=${BUILDS_DIR}/export

##################################################################
#                   Files and folders
##################################################################
#RUN mkdir -p ${SRC_DIR} ${EXPORT_DIR} ${PRE_DIR}

##################################################################
#                   qBitTorrent sources list
##################################################################
RUN apt-key adv --recv-keys --keyserver keyserver.ubuntu.com D35164147CA69FC4
COPY qbittorrent-stable.list /etc/apt/sources.list.d/qbittorrent-stable.list
RUN apt autoremove -y && apt update && apt dist-upgrade -y

############################# ####################################
#                   qbittorrent install
##################################################################
RUN apt-get update && \
    apt install -y --allow-unauthenticated --allow-downgrades \
    qbittorrent \
    cifs-utils

##################################################################
#                   other   customisations
##################################################################
RUN cat /etc/samba/smb.conf

##################################################################
#                   cleaninig up
##################################################################
RUN apt clean -y && \
    apt autoclean -y && \
    rm -rfv /var/lib/apt/lists/* && \
    rm -rfv /var/cache/apt/archives/*.deb
