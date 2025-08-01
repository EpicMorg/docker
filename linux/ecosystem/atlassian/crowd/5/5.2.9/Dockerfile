FROM docker.io/epicmorg/debian:bookworm-jdk8
LABEL maintainer="Atlassian Crowd Server Team; EpicMorg DevTeam, developer@epicm.org"
ARG DEBIAN_FRONTEND=noninteractive

##################################################################
#                   ARGuments
##################################################################
ARG RELEASE=5.2.9
ARG DOWNLOAD_URL=https://www.atlassian.com/software/crowd/downloads/binary/atlassian-crowd-${RELEASE}.tar.gz
ARG TEMP_ARCHIVE=/tmp/atlassian-crowd-${RELEASE}.tar.gz

##################################################################
#                   Setup
##################################################################
ENV RUN_USER            daemon
ENV RUN_GROUP           daemon
ENV APP_NAME            crowd

#2004
#ENV RUN_UID             0
#ENV RUN_GID             0

# https://confluence.atlassian.com/crowd/important-directories-and-files-78676537.html
ENV CROWD_HOME                                      /var/atlassian/application-data/crowd
ENV CROWD_INSTALL_DIR                               /opt/atlassian/crowd
ENV CROWD_DB                                        ${CROWD_INSTALL_DIR}/database

##################################################################
#                   Installing
##################################################################
RUN wget -c \
    --user-agent="Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:128.0) Gecko/20100101 Firefox/128.0" \
    --no-check-certificate \
    --retry-connrefused \
    --tries=15 \
    --timeout=30 \
    --waitretry=15 \
    --dns-timeout=30 \
    --read-timeout=30 \
    --progress=dot:giga \
    --no-clobber \
    -O /tmp/$(basename "${DOWNLOAD_URL}") \
    "${DOWNLOAD_URL}"


RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y --no-install-recommends fontconfig python3 python3-jinja2 tini && \
    apt-get clean autoclean && apt-get autoremove -y && rm -rf /var/lib/apt/lists/*

RUN mkdir -p ${CROWD_INSTALL_DIR} ${CROWD_DB} /opt/atlassian/support /opt/atlassian/etc && \
    tar -xzf ${TEMP_ARCHIVE} --strip-components=1 --directory "${CROWD_INSTALL_DIR}" && \
    sed -i -e 's/-Xms\([0-9]\+[kmg]\) -Xmx\([0-9]\+[kmg]\)/-Xms\${JVM_MINIMUM_MEMORY:=\1} -Xmx\${JVM_MAXIMUM_MEMORY:=\2} \${JVM_SUPPORT_RECOMMENDED_ARGS} -Dcrowd.home=\${CROWD_HOME}/g' ${CROWD_INSTALL_DIR}/apache-tomcat/bin/setenv.sh && \
    sed -i -e 's/port="8095"/port="8095" secure="${catalinaConnectorSecure}" scheme="${catalinaConnectorScheme}" proxyName="${catalinaConnectorProxyName}" proxyPort="${catalinaConnectorProxyPort}"/' ${CROWD_INSTALL_DIR}/apache-tomcat/conf/server.xml && \
    apt-get clean -y && \
    apt-get autoremove -y && \
    apt-get autoclean -y && \
    rm -rfv /var/lib/apt/lists/* && \
    rm -rfv /var/cache/apt/archives/*.deb && \
    rm -rfv /root/tmp/* && \
    rm -rfv /tmp/*

COPY entrypoint.sh                                  /
#COPY shutdown-wait.sh                               /
#COPY shared-components/image/entrypoint_helpers.py  /
#COPY shared-components/support                      /opt/atlassian/support
#COPY config/*                                       /opt/atlassian/etc/

RUN chmod +x /entrypoint.sh && \
#    chmod +x /entrypoint.py && \ 
#    chmod +x /shutdown-wait.sh && \
#    chmod +x /entrypoint_helpers.py && \
    chown -R ${RUN_USER}:${RUN_GROUP} ${CROWD_INSTALL_DIR}

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

# Expose HTTP port
EXPOSE 8095

VOLUME ["${CROWD_HOME}"] # Must be declared after setting perms
VOLUME ["${CROWD_DB}"] # Must be declared after setting perms
WORKDIR ${CROWD_HOME}

CMD ["/entrypoint.sh", "-fg"]
#CMD ["/entrypoint.py"]
ENTRYPOINT ["/usr/bin/tini", "--"]

RUN updatedb
