FROM epicmorg/debian:buster
LABEL maintainer="EpicMorg DevTeam, developer@epicm.org"
ARG DEBIAN_FRONTEND=noninteractive

##################################################################
#                   installing java13
##################################################################
RUN wget -qO - https://adoptopenjdk.jfrog.io/adoptopenjdk/api/gpg/key/public | apt-key add - && \
    echo 'deb https://adoptopenjdk.jfrog.io/adoptopenjdk/deb/ buster main' > /etc/apt/sources.list.d/adoptopenjdk-official.list && \
    apt-get update && \
    apt-get autoremove -y && \
    apt-get install -y --allow-unauthenticated adoptopenjdk-13-hotspot adoptopenjdk-13-hotspot-jre && \
#    mkdir /usr/lib/jvm/adoptopenjdk-13-hotspot-amd64/jre && \
#    ln -s /usr/lib/jvm/adoptopenjdk-13-hotspot-amd64/bin/ /usr/lib/jvm/adoptopenjdk-13-hotspot-amd64/jre/bin && \
#    ln -s /usr/lib/jvm/adoptopenjdk-13-hotspot-amd64/lib/ /usr/lib/jvm/adoptopenjdk-13-hotspot-amd64/jre/lib && \
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
