FROM epicmorg/devel:bullseye
LABEL maintainer="EpicMorg DevTeam, developer@epicm.org"
ARG DEBIAN_FRONTEND=noninteractive

##################################################################
#                   installing java11
##################################################################
RUN wget -qO - https://adoptopenjdk.jfrog.io/adoptopenjdk/api/gpg/key/public | apt-key add - && \
    echo 'deb https://adoptopenjdk.jfrog.io/adoptopenjdk/deb/ buster main' > /etc/apt/sources.list.d/adoptopenjdk-official.list && \
    apt-get update && \
    apt-get autoremove -y && \
    apt-get install -y --allow-unauthenticated adoptopenjdk-11-hotspot && \
    mkdir /usr/lib/jvm/adoptopenjdk-11-hotspot-amd64/jre && \
    ln -s /usr/lib/jvm/adoptopenjdk-11-hotspot-amd64/bin/ /usr/lib/jvm/adoptopenjdk-11-hotspot-amd64/jre/bin && \
    ln -s /usr/lib/jvm/adoptopenjdk-11-hotspot-amd64/lib/ /usr/lib/jvm/adoptopenjdk-11-hotspot-amd64/jre/lib


##################################################################
#                   cleaninig up
##################################################################
RUN apt clean -y && \
    apt autoclean -y && \
    rm -rfv /var/lib/apt/lists/* && \
    rm -rfv /var/cache/apt/archives/*.deb
