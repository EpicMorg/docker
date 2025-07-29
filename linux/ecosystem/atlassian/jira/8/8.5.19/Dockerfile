FROM epicmorg/debian:bookworm-jdk8
LABEL maintainer="Atlassian Jira Server Team; EpicMorg DevTeam, developer@epicm.org"
ARG DEBIAN_FRONTEND=noninteractive

##################################################################
#                   ARGuments
##################################################################
ARG RELEASE=8.5.19
ARG DOWNLOAD_URL=https://www.atlassian.com/software/jira/downloads/binary/atlassian-jira-software-${RELEASE}.tar.gz
ARG TEMP_ARCHIVE=/tmp/atlassian-jira-software-${RELEASE}.tar.gz

##################################################################
#                   Setup
##################################################################
ENV RUN_USER            daemon
ENV RUN_GROUP           daemon

# https://confluence.atlassian.com/display/JSERVERM/Important+directories+and+files
ENV JIRA_HOME          /var/atlassian/application-data/jira
ENV JIRA_INSTALL_DIR   /opt/atlassian/jira

VOLUME ["${JIRA_HOME}"]
WORKDIR $JIRA_HOME

# Expose HTTP port
EXPOSE 8080

##################################################################
#                   Installing
##################################################################
RUN wget -c \
    --user-agent="Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:128.0) Gecko/20100101 Firefox/128.0" \
    --no-check-certificate \
    --tries=5 \
    --timeout=30 \
    --waitretry=5 \
    --retry-connrefused \
    --dns-timeout=10 \
    --read-timeout=20 \
    --progress=dot:giga \
    --no-clobber \
    -O /tmp/$(basename "${DOWNLOAD_URL}") \
    "${DOWNLOAD_URL}"

RUN mkdir -p ${JIRA_INSTALL_DIR} && \
    tar -xzf ${TEMP_ARCHIVE} --strip-components=1 --directory "${JIRA_INSTALL_DIR}" && \
    chown -R ${RUN_USER}:${RUN_GROUP} ${JIRA_INSTALL_DIR}/ && \
    sed -i -e 's/^JVM_SUPPORT_RECOMMENDED_ARGS=""$/: \${JVM_SUPPORT_RECOMMENDED_ARGS:=""}/g' ${JIRA_INSTALL_DIR}/bin/setenv.sh && \
    sed -i -e 's/^JVM_\(.*\)_MEMORY="\(.*\)"$/: \${JVM_\1_MEMORY:=\2}/g' ${JIRA_INSTALL_DIR}/bin/setenv.sh && \
    sed -i -e 's/port="8080"/port="8080" secure="${catalinaConnectorSecure}" scheme="${catalinaConnectorScheme}" proxyName="${catalinaConnectorProxyName}" proxyPort="${catalinaConnectorProxyPort}"/' ${JIRA_INSTALL_DIR}/conf/server.xml

##################################################################
#                  cleanup
##################################################################
RUN echo "clean up" && \
    apt-get clean -y && \
    apt-get autoremove -y && \
    apt-get autoclean -y && \
    rm -rfv /var/lib/apt/lists/* && \
    rm -rfv /var/cache/apt/archives/*.deb && \
    rm -rfv /root/tmp/* && \
    rm -rfv /tmp/*

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

CMD ["/entrypoint.sh", "-fg"]
ENTRYPOINT ["/usr/bin/tini", "--"]

RUN updatedb
