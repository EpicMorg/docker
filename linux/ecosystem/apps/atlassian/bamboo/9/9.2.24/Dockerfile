FROM docker.io/epicmorg/jdk:11
LABEL org.opencontainers.image.title="EpicMorg Bamboo"
LABEL org.opencontainers.image.description="Atlassian Bamboo Server by EpicMorg"
ARG DEBIAN_FRONTEND=noninteractive

##################################################################
#                   ARGuments
##################################################################
ARG RELEASE=9.2.24
ARG DOWNLOAD_URL=https://www.atlassian.com/software/bamboo/downloads/binary/atlassian-bamboo-${RELEASE}.tar.gz
ARG TEMP_ARCHIVE=/tmp/atlassian-bamboo-${RELEASE}.tar.gz

##################################################################
#                   Setup
##################################################################
# Bamboo runs builds (local agents, repository-stored Specs via Maven) as this
# user, so it gets its own account with a writable home (= BAMBOO_HOME).
ENV RUN_USER=bamboo
ENV RUN_GROUP=bamboo
ENV RUN_UID=2005
ENV RUN_GID=2005

# https://confluence.atlassian.com/bamboo/locating-important-directories-and-files-289277247.html
ENV BAMBOO_HOME=/var/atlassian/application-data/bamboo
ENV BAMBOO_INSTALL_DIR=/opt/atlassian/bamboo

VOLUME ["${BAMBOO_HOME}"]
WORKDIR $BAMBOO_HOME

# Expose HTTP and broker (remote agents) ports
EXPOSE 8085
EXPOSE 54663

##################################################################
#                    Shared wget args
##################################################################
ARG WGET_ARGS="--continue \
  --quiet \
  --no-check-certificate \
  --retry-connrefused \
  --tries=15 \
  --timeout=30 \
  --waitretry=15 \
  --dns-timeout=30 \
  --connect-timeout=30 \
  --read-timeout=30 \
  --no-clobber"

ARG WGET_USER_AGENT="Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:128.0) Gecko/20100101 Firefox/128.0"

##################################################################
#                   User
##################################################################
RUN set -eux; \
    groupadd --gid ${RUN_GID} ${RUN_GROUP} && \
    useradd --uid ${RUN_UID} --gid ${RUN_GID} --home-dir ${BAMBOO_HOME} --no-create-home --shell /bin/bash ${RUN_USER} && \
    mkdir -p ${BAMBOO_HOME} && \
    chown -R ${RUN_USER}:${RUN_GROUP} ${BAMBOO_HOME}

##################################################################
#                   Installing
##################################################################
RUN set -eux; \
    wget ${WGET_ARGS} --user-agent "${WGET_USER_AGENT}" -P /tmp ${DOWNLOAD_URL} && \
    mkdir -p ${BAMBOO_INSTALL_DIR} && \
    tar -xzf ${TEMP_ARCHIVE} --strip-components=1 --directory "${BAMBOO_INSTALL_DIR}" && \
    sed -i -e 's/^JVM_SUPPORT_RECOMMENDED_ARGS=""$/: \${JVM_SUPPORT_RECOMMENDED_ARGS:=""}/' ${BAMBOO_INSTALL_DIR}/bin/setenv.sh && \
    sed -i -e 's/^JVM_\(.*\)_MEMORY="\(.*\)"$/: \${JVM_\1_MEMORY:=\2}/' ${BAMBOO_INSTALL_DIR}/bin/setenv.sh && \
    sed -i -e '0,/port="8085"/s//port="8085" secure="${catalinaConnectorSecure}" scheme="${catalinaConnectorScheme}" proxyName="${catalinaConnectorProxyName}" proxyPort="${catalinaConnectorProxyPort}"/' ${BAMBOO_INSTALL_DIR}/conf/server.xml && \
    chown -R ${RUN_USER}:${RUN_GROUP} ${BAMBOO_INSTALL_DIR} && \
    rm -fv ${TEMP_ARCHIVE}

##################################################################
#                  Tools Check
##################################################################
RUN echo "=============================================" && \
    echo $(java -version 2>&1 | head -1) && \
    echo $(git --version) && \
    echo $(mvn --version 2>&1 | head -1) && \
    echo "============================================="

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
