FROM epicmorg/php:php8.0
LABEL maintainer="EpicMorg DevTeam, developer@epicm.org"
ARG DEBIAN_FRONTEND=noninteractive

ARG K_JDK_MAJOR_VERSION=jdk-17.0.11
ARG K_JDK_VERSION=17.0.11
ARG K_JDK_BUILD_VERSION=9
ARG K_JDK_URL=https://github.com/adoptium/temurin17-binaries/releases/download/${K_JDK_MAJOR_VERSION}+${K_JDK_BUILD_VERSION}/OpenJDK17U-jdk_x64_linux_hotspot_${K_JDK_VERSION}_${K_JDK_BUILD_VERSION}.tar.gz

ENV JAVA_HOME=/usr/local/${K_JDK_MAJOR_VERSION}+${K_JDK_BUILD_VERSION}
ENV PATH=$PATH:${JAVA_HOME}/bin

##################################################################
#                   installing java17
##################################################################
ADD ${K_JDK_URL} /tmp
RUN tar -xvzf ${K_JDK_TEMP} --directory /usr/local && \
    java -version

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
#                   php
##################################################################
RUN php -m && \
    php -v


##################################################################
#                   cleaninig up
##################################################################
RUN apt clean -y && \
    apt-get clean all && \
    apt autoclean -y && \
    rm -rfv /var/lib/apt/lists/* && \
    rm -rfv /root/.cache/* && \
    rm -rfv /var/cache/* && \
    rm -rfv /root/tmp/* && \
    rm -rfv /tmp/*

CMD ["/run-services.sh"]

EXPOSE 9090
