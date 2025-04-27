FROM quay.io/epicmorg/debian:bookworm-jdk6
LABEL maintainer="Atlassian Crucible Server Team; EpicMorg DevTeam, developer@epicm.org"
ARG DEBIAN_FRONTEND=noninteractive

##################################################################
#                   ARGuments
##################################################################
ARG RELEASE=1.5.3
ARG DOWNLOAD_URL=https://www.atlassian.com/software/crucible/downloads/binary/crucible-${RELEASE}.zip
ARG TEMP_ARCHIVE=/tmp/crucible-${RELEASE}.zip

##################################################################
#                   Setup
##################################################################
ENV RUN_USER            daemon
ENV RUN_GROUP           daemon

# https://confluence.atlassian.com/fisheye/fisheye-folder-layout-298976940.html
ENV FISHEYE_HOME        /opt/atlassian/сrucible
ENV FISHEYE_INST        /var/atlassian/application-data/сrucible

VOLUME ["${FISHEYE_INST}"]
WORKDIR $FISHEYE_INST

# Expose HTTP port
EXPOSE 8060

##################################################################
#                   Installing
##################################################################
ADD ${DOWNLOAD_URL} /tmp

RUN mkdir -p  ${FISHEYE_HOME} ${FISHEYE_INST} && \
    7zz x ${TEMP_ARCHIVE} -o/tmp/crucible-temp && \
    mv /tmp/crucible-temp/*/* "${FISHEYE_HOME}" && \
    update-locale LC_ALL=en_US.UTF-8 LANG=en_US.UTF-8 && \
    apt-get clean -y && \
    apt-get autoremove -y && \
    apt-get autoclean -y && \
    rm -rfv /var/lib/apt/lists/* && \
    rm -rfv /var/cache/apt/archives/*.deb && \
    rm -rfv /root/tmp/* && \
    rm -rfv /tmp/*

COPY entrypoint.sh   /

RUN chmod +x /entrypoint.sh && \
    chown -R ${RUN_USER}:${RUN_GROUP} ${FISHEYE_HOME}

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

COPY entrypoint.sh /entrypoint.sh 

CMD ["/entrypoint.sh", "run"]
ENTRYPOINT ["/usr/bin/tini", "--"]
