FROM epicmorg/debian:bullseye-jdk7
LABEL maintainer="Atlassian Jira Server Team; EpicMorg DevTeam, developer@epicm.org"
ARG DEBIAN_FRONTEND=noninteractive

##################################################################
#                   ARGuments
##################################################################
ARG RELEASE
ARG DOWNLOAD_URL

##################################################################
#                   Setup
##################################################################
ENV RUN_USER            daemon
ENV RUN_GROUP           daemon

# https://confluence.atlassian.com/fisheye/fisheye-folder-layout-298976940.html
ENV FISHEYE_HOME        /opt/atlassian/crucible
ENV FISHEYE_INST        /var/atlassian/application-data/crucible

VOLUME ["${FISHEYE_INST}"]
WORKDIR $FISHEYE_INST

# Expose HTTP port
EXPOSE 8060

##################################################################
#                   Installing
##################################################################
RUN mkdir -p                 ${FISHEYE_HOME} \
    && wget -nv --random-wait -c ${DOWNLOAD_URL} -O /tmp/crucible-${RELEASE}.zip \
    && unzip -q /tmp/crucible-${RELEASE}.zip -d /tmp \
    && mv /tmp/crucible-${RELEASE}/* ${FISHEYE_HOME} \
    && chown -R ${RUN_USER}:${RUN_GROUP} ${FISHEYE_HOME} \
    && chmod +x /usr/bin/p4 \
    && update-locale LC_ALL=en_US.UTF-8 LANG=en_US.UTF-8 \
    && apt-get clean -y \
    && apt-get autoclean -y \
    && rm -rfv  /tmp/crucible-${RELEASE}.zip \
    && rm -rfv  /tmp/crucible-${RELEASE} \
    && rm -rfv /var/lib/apt/lists/* \
    && rm -rfv /var/cache/apt/archives/*.deb

COPY entrypoint.sh /entrypoint.sh 

CMD ["/entrypoint.sh", "run"]
ENTRYPOINT ["/usr/bin/tini", "--"]
