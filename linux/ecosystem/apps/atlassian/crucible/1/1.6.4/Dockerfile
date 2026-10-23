FROM ghcr.io/epicmorg/jdk:6
LABEL org.opencontainers.image.title="EpicMorg Crucible"
LABEL org.opencontainers.image.description="Atlassian Crucible by EpicMorg"
ARG DEBIAN_FRONTEND=noninteractive

##################################################################
#                   ARGuments
##################################################################
ARG RELEASE=1.6.4
ARG DOWNLOAD_URL=https://www.atlassian.com/software/crucible/downloads/binary/crucible-${RELEASE}.zip
ARG TEMP_ARCHIVE=/tmp/crucible-${RELEASE}.zip

##################################################################
#                   Setup
##################################################################
ENV RUN_USER=daemon
ENV RUN_GROUP=daemon

# https://confluence.atlassian.com/fisheye/fisheye-folder-layout-298976940.html
ENV FISHEYE_HOME=/opt/atlassian/сrucible
ENV FISHEYE_INST=/var/atlassian/application-data/сrucible

VOLUME ["${FISHEYE_INST}"]
WORKDIR $FISHEYE_INST

# Expose HTTP port
EXPOSE 8060

##################################################################
#                   Installing
##################################################################
RUN set -eux; \
    aria2c --conf-path=/usr/local/share/epicmorg/aria2/config/aria2.conf \
        --user-agent="$(shuf -n 1 /usr/local/share/epicmorg/user-agents/user-agents.txt)" \
        -d / -o ${TEMP_ARCHIVE} ${DOWNLOAD_URL} && \
    mkdir -p  ${FISHEYE_HOME} ${FISHEYE_INST} && \
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

COPY entrypoint.sh /entrypoint.sh 

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

CMD ["/entrypoint.sh", "run"]
ENTRYPOINT ["/usr/bin/tini", "--"]
