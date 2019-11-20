FROM epicmorg/devel
LABEL maintainer="EpicMorg DevTeam, developer@epicm.org"
ARG DEBIAN_FRONTEND=noninteractive

##################################################################
#                   ARGuments
##################################################################
ENV BuildDocker true
ARG SBM_DIR=/mnt/smb
ARG QBT_DIR=/opt/qbittorrent

##################################################################
#                   Files and folders
##################################################################
RUN mkdir -p ${SMB_DIR} ${QBT_DIR}

##################################################################
#                   qBitTorrent sources list
##################################################################
RUN apt-key adv --recv-keys --keyserver keyserver.ubuntu.com D35164147CA69FC4
COPY qbittorrent-unstable.list /etc/apt/sources.list.d/qbittorrent-unstable.list
RUN apt autoremove -y && apt update && apt dist-upgrade -y

############################# ####################################
#                   qbittorrent install
##################################################################
RUN apt-get update && \
    apt install -y --allow-unauthenticated --allow-downgrades \
    qbittorrent-nox \
    ntfs-3g \
    winbind \
    cifs-utils


##################################################################
#                   other   customisations
##################################################################


##################################################################
#                   cleaninig up
##################################################################
RUN apt clean -y && \
    apt autoclean -y && \
    rm -rfv /var/lib/apt/lists/* && \
    rm -rfv /var/cache/apt/archives/*.deb

VOLUME ${QBT_DIR}

EXPOSE 8080

ENTRYPOINT /entrypoint.sh