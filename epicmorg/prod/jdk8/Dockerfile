FROM epicmorg/prod
LABEL maintainer="EpicMorg DevTeam, developer@epicm.org"
ARG DEBIAN_FRONTEND=noninteractive

##################################################################
#   Build-time metadata as defined at http://label-schema.org
##################################################################
ARG BUILD_DATE=today
ARG VCS_REF=master
ARG VERSION=latest
LABEL org.label-schema.build-date=$BUILD_DATE \
          org.label-schema.name="Docker Scripts" \
          org.label-schema.description="Image for our docker containers." \
          org.label-schema.url="https://ww.epicm.org/" \
          org.label-schema.vcs-ref=$VCS_REF \
          org.label-schema.vcs-url="https://github.com/EpicMorg/docker-scripts" \
          org.label-schema.vendor="EpicMorg" \
          org.label-schema.version=$VERSION \
          org.label-schema.schema-version="1.0"

##################################################################
#                   installing java8
##################################################################
RUN wget -qO - https://adoptopenjdk.jfrog.io/adoptopenjdk/api/gpg/key/public | sudo apt-key add - && \
    echo 'deb https://adoptopenjdk.jfrog.io/adoptopenjdk/deb/ buster main' > /etc/apt/sources.list.d/adoptopenjdk-official.list && \
    apt-get update && \
    apt-get autoremove -y && \
    apt-get install -y --allow-unauthenticated adoptopenjdk-8-hotspot

##################################################################
#                   cleaninig up
##################################################################
RUN apt clean -y && \
    apt autoclean -y && \
    rm -rfv /var/lib/apt/lists/* && \
    rm -rfv /var/cache/apt/archives/*.deb
