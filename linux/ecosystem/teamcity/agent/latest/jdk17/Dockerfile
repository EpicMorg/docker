FROM epicmorg/debian:bookworm-develop-jdk17
LABEL maintainer="EpicMorg DevTeam, developer@epicm.org"
ARG DEBIAN_FRONTEND=noninteractive

##################################################################
#                   sid sources list
##################################################################
#RUN rm -rfv /etc/apt/sources.list
#COPY  sources.sid.list /etc/apt/sources.list
RUN  apt-get update && \
     apt autoremove -y && \
     apt-get dist-upgrade -y && \
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
    echo 'deb  https://download.docker.com/linux/debian bullseye test' > /etc/apt/sources.list.d/docker.list  && \
    echo 'deb  https://download.docker.com/linux/debian bullseye nightly' >> /etc/apt/sources.list.d/docker.list  && \
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
#                   Additional settings
##################################################################
ENV MAVEN_VERSION=3.9.8
ENV MAVEN_LINK=https://dlcdn.apache.org/maven/maven-3/${MAVEN_VERSION}/binaries/apache-maven-${MAVEN_VERSION}-bin.zip
ENV MAVEN_ROOT=${EMG_LOCAL_BASE_DIR}/maven/${MAVEN_VERSION}
ENV MAVEN_PATH=${MAVEN_ROOT}/apache-maven-${MAVEN_VERSION}
ENV MAVEN_BIN=${MAVEN_PATH}/bin
ARG MAVEN_TEMP=/tmp/apache-maven-${MAVEN_VERSION}-bin.zip

ENV GRADLE_VERSION=8.8
ENV GRADLE_LINK=https://services.gradle.org/distributions/gradle-${GRADLE_VERSION}-all.zip
ENV GRADLE_ROOT=${EMG_LOCAL_BASE_DIR}/gradle/${GRADLE_VERSION}
ENV GRADLE_PATH=${GRADLE_ROOT}/gradle-${GRADLE_VERSION}
ENV GRADLE_BIN=${GRADLE_PATH}/bin
ARG GRADLE_TEMP=/tmp/gradle-${GRADLE_VERSION}-all.zip

ENV KTC_VERSION=2.0.0
ENV KTC_LINK=https://github.com/JetBrains/kotlin/releases/download/v${KTC_VERSION}/kotlin-compiler-${KTC_VERSION}.zip
ARG KTC_TEMP=/tmp/kotlin-compiler-${KTC_VERSION}.zip
ENV KTC_ROOT=${EMG_LOCAL_BASE_DIR}/kotlin/${KTC_VERSION}
ENV KTC_PATH=${KTC_ROOT}/kotlinc
ENV KTC_BIN=${KTC_PATH}/bin

ENV KNPL_VERSION=${KTC_VERSION}
ENV KNPL_LINK=https://github.com/JetBrains/kotlin/releases/download/v${KNPL_VERSION}/kotlin-native-prebuilt-linux-x86_64-${KNPL_VERSION}.tar.gz
ARG KNPL_TEMP=/tmp/kotlin-native-prebuilt-linux-x86_64-${KNPL_VERSION}.tar.gz
ENV KNPL_ROOT=${EMG_LOCAL_BASE_DIR}/kotlin/${KNPL_VERSION}
ENV KNPL_PATH=${KNPL_ROOT}/kotlin-native-prebuilt-linux-x86_64-${KNPL_VERSION}
ENV KNPL_BIN=${KNPL_PATH}/bin

RUN mkdir -p ${MAVEN_PATH} ${KTC_PATH} ${KNPL_PATH} ${GRADLE_PATH}
ENV PATH=${PATH}:${MAVEN_BIN}:${GRADLE_BIN}:${KTC_BIN}:${KNPL_BIN}

##################################################################
#                   Maven
##################################################################
ENV MAVEN_HOME=${MAVEN_ROOT}
ENV M2_HOME=${MAVEN_ROOT}

ADD ${MAVEN_LINK} /tmp
RUN 7zz x ${MAVEN_TEMP} -o${MAVEN_ROOT}
RUN chmod +x -R ${MAVEN_BIN}
RUN mvn -v

##################################################################
#                   GRADLE
##################################################################
ADD ${GRADLE_LINK} /tmp
RUN 7zz x ${GRADLE_TEMP} -o${GRADLE_ROOT}
RUN chmod +x -R ${GRADLE_BIN}
RUN gradle -v

##################################################################
#                   kotlin-compiler
##################################################################
ADD ${KTC_LINK} /tmp
RUN 7zz x ${KTC_TEMP} -o${KTC_ROOT}
RUN chmod +x -R ${KTC_BIN}
RUN kotlin -version

##################################################################
#                   kotlin-native-prebuilt-linux
##################################################################
ADD ${KNPL_LINK} /tmp
RUN tar -xvzf ${KNPL_TEMP} --directory ${KTC_ROOT}
RUN chmod +x -R ${KNPL_BIN}

##################################################################
#                   cleaninig up
##################################################################
RUN apt clean -y && \
    apt-get clean all && \
    apt autoclean -y && \
    rm -rfv /var/lib/apt/lists/* && \
    rm -rfv /var/cache/apt/archives/*.deb && \
    rm -rfv /tmp/*

CMD ["/run-services.sh"]

EXPOSE 9090
