FROM epicmorg/edge
LABEL maintainer="EpicMorg DevTeam, developer@epicm.org"
ARG DEBIAN_FRONTEND=noninteractive

##################################################################
#   Build-time metadata as defined at http://label-schema.org
##################################################################
ARG BUILD_DATE=today
ARG VCS_REF=master
ARG VERSION=latest
LABEL org.label-schema.build-date=$BUILD_DATE \
          org.label-schema.name="Docker Scripts" \
          org.label-schema.description="Image for our docker containers." \
          org.label-schema.url="https://ww.epicm.org/" \
          org.label-schema.vcs-ref=$VCS_REF \
          org.label-schema.vcs-url="https://github.com/EpicMorg/docker-scripts" \
          org.label-schema.vendor="EpicMorg" \
          org.label-schema.version=$VERSION \
          org.label-schema.schema-version="1.0"

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
COPY qbittorrent-unstable.list /etc/apt/sources.list.d/qbittorrent-unstable.list
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
    rm -rf /var/lib/apt/lists/* && \
    rm -rf /var/cache/apt/archives/*.deb && \
    rm -rf /builds/* && \
    rm -rf /valve/*

VOLUME ${QBT_DIR}

EXPOSE 8282

COPY entrypoint.sh /entrypoint.sh
ENTRYPOINT /entrypoint.sh