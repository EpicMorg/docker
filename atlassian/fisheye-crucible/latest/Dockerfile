FROM epicmorg/prod:jdk8
LABEL maintainer="Atlassian Jira Server Team; EpicMorg DevTeam, developer@epicm.org"
ARG DEBIAN_FRONTEND=noninteractive

##################################################################
#                   ARGuments
##################################################################
ARG FECRU_VERSION=4.8.1
ARG DOWNLOAD_URL=https://product-downloads.atlassian.com/software/fisheye/downloads/fisheye-${FECRU_VERSION}.zip

ARG P4_VERSION=r19.2
ARG P4_DOWNLOAD_URL=http://www.perforce.com/downloads/perforce/${P4_VERSION}/bin.linux26x86_64/p4

##################################################################
#                   Setup
##################################################################
ENV RUN_USER            daemon
ENV RUN_GROUP           daemon

# https://confluence.atlassian.com/fisheye/fisheye-folder-layout-298976940.html
ENV FISHEYE_INST        /opt/atlassian/fecru
ENV FISHEYE_HOME        /var/atlassian/application-data/fecru

VOLUME ["${FISHEYE_HOME}"]
WORKDIR $FISHEYE_HOME

# Expose HTTP port
EXPOSE 8060

##################################################################
#                   Installing
##################################################################
RUN mkdir -p                 ${FISHEYE_INST} \
    && wget -nv --random-wait -c -P /usr/bin ${P4_DOWNLOAD_URL} \
    && wget -nv --random-wait -c ${DOWNLOAD_URL} -O /tmp/fisheye-${FECRU_VERSION}.zip \
    && unzip -q /tmp/fisheye-${FECRU_VERSION}.zip -d /tmp \
    && mv /tmp/fecru-${FECRU_VERSION}/* ${FISHEYE_INST} \
    && chown -R ${RUN_USER}:${RUN_GROUP} ${FISHEYE_INST} \
    && chmod +x /usr/bin/p4 \
    && update-locale LC_ALL=en_US.UTF-8 LANG=en_US.UTF-8 \
    && apt-get clean -y \
    && apt-get autoclean -y \
    && rm -rfv  /tmp/fisheye-${FECRU_VERSION}.zip \
    && rm -rfv  /tmp/fecru-${FECRU_VERSION} \
    && rm -rfv /var/lib/apt/lists/* \
    && rm -rfv /var/cache/apt/archives/*.deb

COPY entrypoint.sh              /entrypoint.sh 
COPY . /tmp

CMD ["/entrypoint.sh", "run"]
ENTRYPOINT ["/sbin/tini", "--"]
