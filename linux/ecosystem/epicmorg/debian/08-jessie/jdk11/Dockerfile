FROM epicmorg/debian:jessie
LABEL maintainer="EpicMorg DevTeam, developer@epicm.org"
ARG DEBIAN_FRONTEND=noninteractive

##################################################################
#                   installing java11
##################################################################
RUN wget -qO - https://packages.adoptium.net/artifactory/api/gpg/key/public | apt-key add - && \
    echo 'deb https://adoptopenjdk.jfrog.io/adoptopenjdk/deb/ jessie main' > /etc/apt/sources.list.d/adoptopenjdk-official.list && \
    apt-get update && \
    apt-get autoremove -y && \
    apt-get install -y --allow-unauthenticated adoptopenjdk-11-hotspot adoptopenjdk-11-hotspot-jre && \
#    mkdir /usr/lib/jvm/adoptopenjdk-11-hotspot-amd64/jre && \
#    ln -s /usr/lib/jvm/adoptopenjdk-11-hotspot-amd64/bin/ /usr/lib/jvm/adoptopenjdk-11-hotspot-amd64/jre/bin && \
#    ln -s /usr/lib/jvm/adoptopenjdk-11-hotspot-amd64/lib/ /usr/lib/jvm/adoptopenjdk-11-hotspot-amd64/jre/lib && \    
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
