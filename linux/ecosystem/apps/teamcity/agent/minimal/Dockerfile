FROM docker.io/epicmorg/jdk:21 AS jdk

FROM docker.io/epicmorg/debian:trixie-develop
LABEL maintainer="EpicMorg DevTeam, developer@epicm.org"
ARG DEBIAN_FRONTEND=noninteractive

##################################################################
#              Java (prebuilt epicmorg/jdk image)
##################################################################
# JDK and build tooling are taken as-is from the jdk image, so the agent
# always runs exactly the java that was built and tested there.
ENV JAVA_HOME=${EMG_LOCAL_BASE_DIR}/java/21
ENV JRE_HOME=${JAVA_HOME}
ENV JDK_HOME=${JAVA_HOME}

COPY --from=jdk ${EMG_LOCAL_BASE_DIR}/java/   ${EMG_LOCAL_BASE_DIR}/java/
COPY --from=jdk ${EMG_LOCAL_BASE_DIR}/maven/  ${EMG_LOCAL_BASE_DIR}/maven/
COPY --from=jdk ${EMG_LOCAL_BASE_DIR}/gradle/ ${EMG_LOCAL_BASE_DIR}/gradle/
COPY --from=jdk ${EMG_LOCAL_BASE_DIR}/kotlin/ ${EMG_LOCAL_BASE_DIR}/kotlin/

# versioned tool paths are resolved from the jdk image itself
RUN set -eux; \
    for d in ${EMG_LOCAL_BASE_DIR}/maven/*/apache-maven-*/bin \
             ${EMG_LOCAL_BASE_DIR}/gradle/*/gradle-*/bin \
             ${EMG_LOCAL_BASE_DIR}/kotlin/*/kotlinc/bin; do \
        for b in "$d"/*; do \
            case "$b" in *.bat) continue ;; esac; \
            ln -sfv "$b" /usr/local/bin/; \
        done; \
    done; \
    ln -sfv ${JAVA_HOME} /usr/jre; \
    ln -sfv ${JAVA_HOME} /usr/jdk; \
    for b in ${JAVA_HOME}/bin/*; do ln -sfv "$b" /usr/local/bin/; done; \
    java -version; \
    mvn -v; \
    gradle -v; \
    kotlinc -version

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
#                   final config
##################################################################
WORKDIR ${AGENT_DIST}

VOLUME ["${AGENT_DIST}/conf", "${AGENT_DIST}/work", "${AGENT_DIST}/logs", "/var/log/supervisor"]

CMD ["/usr/bin/supervisord"]
