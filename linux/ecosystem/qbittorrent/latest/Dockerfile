FROM epicmorg/edge
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
COPY qbittorrent-unstable.list /etc/apt/sources.list.d/qbittorrent-unstable.list
RUN apt autoremove -y && apt purge policykit-1 -y &&  apt update && apt dist-upgrade -y

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

#healthcheck. good practice
HEALTHCHECK --interval=2m --timeout=3s CMD curl -f http://localhost:8282/ || exit 1

# Add image configuration and scripts
COPY docker-entrypoint.sh /usr/bin/docker-entrypoint.sh
RUN chmod 755 /usr/bin/docker-entrypoint.sh

#Final config
EXPOSE 8282

ENTRYPOINT ["tini", "-s", "--", "docker-entrypoint.sh"]
CMD ["docker-entrypoint.sh"]
