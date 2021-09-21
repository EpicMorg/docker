FROM epicmorg/devel:jdk11
LABEL maintainer="EpicMorg DevTeam, developer@epicm.org"
ARG DEBIAN_FRONTEND=noninteractive

##################################################################
#                   sid sources list
##################################################################
RUN rm -rfv /etc/apt/sources.list
COPY  sources.sid.list /etc/apt/sources.list
RUN  apt update && \
     apt autoremove -y && \
     apt dist-upgrade -y && \
     apt autoremove -y

##################################################################
#                   teamcity minimal agent
##################################################################
LABEL dockerImage.teamcity.version="latest" \
      dockerImage.teamcity.buildNumber="latest"

VOLUME /data/teamcity_agent/conf

ENV CONFIG_FILE=/data/teamcity_agent/conf/buildAgent.properties
ENV LANG=C.UTF-8
ENV GIT_SSH_VARIANT=ssh

COPY run-agent.sh /run-agent.sh
RUN chmod +x /run-agent.sh && \
    sync

COPY run-services.sh /run-services.sh
RUN chmod +x /run-services.sh && \
    sync

ADD https://teamcity.jetbrains.com/update/buildAgent.zip /buildAgent.zip
RUN unzip -q /buildAgent.zip -d /opt/buildagent && \
    mv /opt/buildagent/conf /opt/buildagent/conf_dist && \
    rm -rfv /buildAgent.zip

RUN useradd -m buildagent && \
    chmod +x /opt/buildagent/bin/*.sh && \
    chmod +x /run-agent.sh /run-services.sh && sync

##################################################################
#                    teamcity docker setup
##################################################################

#Install packages
RUN curl -fsSL https://download.docker.com/linux/debian/gpg | apt-key add - && \
    echo 'deb  https://download.docker.com/linux/debian buster test' > /etc/apt/sources.list.d/docker.list  && \
    apt-cache policy docker-ce && \
    apt-get update && \
    apt-get install -y --no-install-recommends --allow-unauthenticated \
      docker-ce \
      docker-ce-cli \
      containerd.io systemd && \
    systemctl disable docker && \
    usermod -aG docker buildagent

# A better fix for TW-52939 Dockerfile build fails because of aufs
VOLUME /var/lib/docker

COPY run-docker.sh /services/run-docker.sh
RUN chmod +x /services/run-docker.sh && \
    sync

##################################################################
#                    teamcity docker compose setup
##################################################################

#Install packages
RUN export  DOCKER_COMPOSE_VERSION=`curl --silent https://api.github.com/repos/docker/compose/releases/latest | jq .name -r` && \
    echo "Latest compose is: ${DOCKER_COMPOSE_VERSION}" && \
    curl -SL https://github.com/docker/compose/releases/download/${DOCKER_COMPOSE_VERSION}/docker-compose-Linux-x86_64 -o /usr/local/bin/docker-compose && \
    chmod +x /usr/local/bin/docker-compose

##################################################################
#                   cleaninig up
##################################################################
RUN apt clean -y && \
    apt-get clean all && \
    apt autoclean -y && \
    rm -rfv /var/lib/apt/lists/* && \
    rm -rfv /var/cache/apt/archives/*.deb && \
    rm -rfv /tmp/deb/* && \
    rm -rfv /tmp/composer-setup.php && \
    rm -rfv /tmp/amxx_base_latest.tar.gz && \
    rm -rfv /tmp/atlassian-plugin-sdk.deb && \
    rm -rfv /tmp/addons

CMD ["/run-services.sh"]

EXPOSE 9090
