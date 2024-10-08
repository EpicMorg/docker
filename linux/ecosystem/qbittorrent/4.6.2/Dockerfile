FROM epicmorg/debian:bookworm
LABEL maintainer="EpicMorg DevTeam, developer@epicm.org"
ARG DEBIAN_FRONTEND=noninteractive

##################################################################
#                   ARGuments
##################################################################

ARG QBT_RELEASE
ARG LT_RELEASE
ENV QBT_VERSION=${QBT_RELEASE}
ENV QBT_LIBTORRENT_VERSION=${LT_RELEASE}
ENV QBT_URL=https://github.com/userdocs/qbittorrent-nox-static/releases/download/release-${QBT_VERSION}_v${QBT_LIBTORRENT_VERSION}/x86_64-qbittorrent-nox

ENV QBT_DIR=/opt/qbittorrent
ENV QBT_PORT_WEBUI=8282
ENV QBT_PORT_TRACKER=9000
ENV QBT_PORT_NAT=1337
ENV QBT_PROTOCOL=http

##################################################################
#                   Files and folders
##################################################################
RUN mkdir -p ${QBT_DIR}

############################# ####################################
#                   qbittorrent install
##################################################################
RUN wget --no-check-certificate -nv --random-wait --retry-connrefused --continue ${QBT_URL} -O /usr/bin/qbittorrent-nox && \
    chmod +x /usr/bin/qbittorrent-nox && \
    qbittorrent-nox --version

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
HEALTHCHECK --interval=2m --timeout=3s CMD curl --insecure -f ${QBT_PROTOCOL}://localhost:${QBT_PORT_WEBUI}/ || exit 1

# Add image configuration and scripts
COPY docker-entrypoint.sh /usr/bin/docker-entrypoint.sh
RUN chmod 755 /usr/bin/docker-entrypoint.sh

RUN updatedb

#Final config
EXPOSE ${QBT_PORT_WEBUI} ${QBT_PORT_WEBUI}/udp ${QBT_PORT_NAT} ${QBT_PORT_NAT}/udp ${QBT_PORT_TRACKER} ${QBT_PORT_TRACKER}/udp

ENTRYPOINT ["tini", "-s", "--", "docker-entrypoint.sh"]
CMD ["docker-entrypoint.sh"]
