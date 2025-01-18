FROM epicmorg/debian:bullseye-jdk8
LABEL maintainer="Atlassian Crowd Server Team; EpicMorg DevTeam, developer@epicm.org"
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
ENV APP_NAME            crowd

# https://confluence.atlassian.com/crowd/important-directories-and-files-78676537.html
ENV CROWD_HOME                                      /var/atlassian/application-data/crowd
ENV CROWD_INSTALL_DIR                               /opt/atlassian/crowd
ENV CROWD_DB                                       ${CROWD_INSTALL_DIR}/database

# Expose HTTP port
EXPOSE 8095

##################################################################
#                   Installing
##################################################################
RUN apt-get update \
    && apt-get upgrade -y \
    && apt-get install -y --no-install-recommends fontconfig python3 python3-jinja2 tini \
    && apt-get clean autoclean && apt-get autoremove -y && rm -rf /var/lib/apt/lists/*

RUN mkdir -p                                     ${CROWD_DB} && \
    curl -L                                      ${DOWNLOAD_URL} | tar -xz --strip-components=1 -C "${CROWD_INSTALL_DIR}" && \
    chown -R $RUN_USER:$RUN_GROUP                ${CROWD_INSTALL_DIR} && \
    sed -i -e 's/-Xms\([0-9]\+[kmg]\) -Xmx\([0-9]\+[kmg]\)/-Xms\${JVM_MINIMUM_MEMORY:=\1} -Xmx\${JVM_MAXIMUM_MEMORY:=\2} \${JVM_SUPPORT_RECOMMENDED_ARGS} -Dcrowd.home=\${CROWD_HOME}/g' ${CROWD_INSTALL_DIR}/apache-tomcat/bin/setenv.sh && \
    update-locale LC_ALL=en_US.UTF-8 LANG=en_US.UTF-8 && \
    apt clean -y && \
    apt autoclean -y && \
    rm -rfv /var/lib/apt/lists/* && \
    rm -rfv /var/cache/apt/archives/*.deb

VOLUME ["${CROWD_HOME}"] # Must be declared after setting perms
VOLUME ["${CROWD_DB}"] # Must be declared after setting perms
WORKDIR $CROWD_HOME

CMD ["/entrypoint.py"]
ENTRYPOINT ["/usr/bin/tini", "--"]

COPY entrypoint.py \
     shutdown-wait.sh \
     shared-components/image/entrypoint_helpers.py  /
COPY shared-components/support                      /opt/atlassian/support
COPY config/*                                       /opt/atlassian/etc/
COPY .                                              /tmp
