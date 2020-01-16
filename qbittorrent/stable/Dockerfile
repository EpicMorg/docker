FROM epicmorg/devel
LABEL maintainer="EpicMorg DevTeam, developer@epicm.org"
ARG DEBIAN_FRONTEND=noninteractive

##################################################################
#                   ARGuments
##################################################################
ARG QBT_DIR=/opt/qbittorrent

##################################################################
#                   Files and folders
##################################################################
RUN mkdir -p ${QBT_DIR}

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
    qbittorrent-nox


##################################################################
#                   other   customisations
##################################################################


##################################################################
#                   cleaninig up
##################################################################
RUN apt clean -y && \
    apt autoclean -y && \
    rm -rfv /var/lib/apt/lists/* && \
    rm -rfv /var/cache/apt/archives/*.deb && \
    rm -rfv /builds/* && \
    rm -rfv /valve/*

VOLUME ${QBT_DIR}

EXPOSE 8282

COPY entrypoint.sh /entrypoint.sh
ENTRYPOINT /entrypoint.sh