FROM epicmorg/debian:bullseye
LABEL maintainer="EpicMorg DevTeam, developer@epicm.org"
ARG DEBIAN_FRONTEND=noninteractive

##################################################################
#                   installing java11
##################################################################
RUN wget -qO - https://packages.adoptium.net/artifactory/api/gpg/key/public  | apt-key add - && \
    echo 'deb https://packages.adoptium.net/artifactory/deb bullseye main' > /etc/apt/sources.list.d/temurin-official.list && \
    apt-get update && \
    apt-get autoremove -y && \
    apt-get install -y --allow-unauthenticated temurin-11-jdk && \
    mkdir /usr/lib/jvm/temurin-11-jdk-amd64/jre && \
    ln -s /usr/lib/jvm/temurin-11-jdk-amd64/bin/ /usr/lib/jvm/temurin-11-jdk-amd64/jre/bin && \
    ln -s /usr/lib/jvm/temurin-11-jdk-amd64/lib/ /usr/lib/jvm/temurin-11-jdk-amd64/jre/lib && \
    java -version

##################################################################
#                  cleanup
##################################################################
RUN apt-get purge policykit-1 -y && \
    apt-get clean -y && \
    apt-get autoclean -y && \
    rm -rfv /var/lib/apt/lists/* && \
    rm -rfv /tmp/* && \
    rm -rfv /var/cache/apt/archives/*.deb