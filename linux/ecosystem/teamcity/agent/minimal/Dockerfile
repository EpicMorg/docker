FROM epicmorg/debian:bookworm-develop-jdk21
LABEL maintainer="EpicMorg DevTeam, developer@epicm.org"
ARG DEBIAN_FRONTEND=noninteractive

##################################################################
#              TeamCity Agent setup
##################################################################
LABEL dockerImage.teamcity.version="latest" \
      dockerImage.teamcity.buildNumber="latest"

USER root

ENV LANG=C.UTF-8
ENV GIT_SSH_VARIANT=ssh
# TeamCity Agent dirs
ENV AGENT_DIST=${EMG_LOCAL_BASE_DIR}/teamcity/agent
ENV CONFIG_DIR=${AGENT_DIST}/conf
ENV CONFIG_FILE=${AGENT_DIST}/conf/buildAgent.properties
ENV LOG_DIR=${AGENT_DIST}/logs

COPY etc/ /etc/
COPY usr/local/share/epicmorg/ /usr/local/share/epicmorg/

ADD https://teamcity.jetbrains.com/update/buildAgent.zip /tmp/buildAgent.zip
RUN apt-get update && \
    apt-get install -y --no-install-recommends --allow-unauthenticated \
        supervisor && \
    unzip -q /tmp/buildAgent.zip -d ${AGENT_DIST} && \
    mv -fv ${AGENT_DIST}/conf ${AGENT_DIST}/conf_dist && \
    rm -rfv /tmp/buildAgent.zip && \
    useradd -m buildagent && \
    chmod +x ${AGENT_DIST}/bin/*.sh && \
    chmod +x ${AGENT_DIST}/sbin/*.sh && \
    sync

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
#                   final config
##################################################################
WORKDIR ${AGENT_DIST}

VOLUME ["${AGENT_DIST}/conf", "${AGENT_DIST}/work", "${AGENT_DIST}/logs", "/var/log/supervisor"]

CMD ["/usr/bin/supervisord"]

RUN updatedb
