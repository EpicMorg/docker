FROM epicmorg/devel:jdk11
LABEL maintainer="EpicMorg DevTeam, developer@epicm.org"
ARG DEBIAN_FRONTEND=noninteractive

##################################################################
#                   sid sources list
##################################################################
#RUN rm -rfv /etc/apt/sources.list
COPY  sources.sid.list /etc/apt/sources.list.d/
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
#                   Node.js 15.x
##################################################################
RUN curl -sL https://deb.nodesource.com/setup_15.x | bash - && \
    curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add - && \
    echo "deb https://nightly.yarnpkg.com/debian/ nightly main" > /etc/apt/sources.list.d/yarn.list && \
    apt-get update && \
    apt-get install -y nodejs yarn

#   curl -L https://www.npmjs.com/install.sh | sh
#   npm install -g npm

RUN echo "=============================================" && \
    echo node $(node --version) && \
    echo npm $(npm --version) && \
    echo yarn $(yarn --version) && \
    echo "============================================="

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
