FROM docker.io/epicmorg/debian:bookworm-jdk8
LABEL maintainer="Atlassian Fisheye Server Team; EpicMorg DevTeam, developer@epicm.org"
ARG DEBIAN_FRONTEND=noninteractive

##################################################################
#                   ARGuments
##################################################################
ARG RELEASE=3.7.0
ARG DOWNLOAD_URL=https://www.atlassian.com/software/fisheye/downloads/binary/fisheye-${RELEASE}.zip
ARG TEMP_ARCHIVE=/tmp/fisheye-${RELEASE}.zip

##################################################################
#                   Setup
##################################################################
ENV RUN_USER            daemon
ENV RUN_GROUP           daemon

# https://confluence.atlassian.com/fisheye/fisheye-folder-layout-298976940.html
ENV FISHEYE_HOME        /opt/atlassian/fecru
ENV FISHEYE_INST        /var/atlassian/application-data/fecru

VOLUME ["${FISHEYE_INST}"]
WORKDIR $FISHEYE_INST

# Expose HTTP port
EXPOSE 8060

##################################################################
#                   Installing
##################################################################
RUN wget -c \
    --user-agent="Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:128.0) Gecko/20100101 Firefox/128.0" \
    --no-check-certificate \
    --retry-connrefused \
    --tries=15 \
    --timeout=30 \
    --waitretry=15 \
    --dns-timeout=30 \
    --read-timeout=30 \
    --progress=dot:giga \
    --no-clobber \
    -O /tmp/$(basename "${DOWNLOAD_URL}") \
    "${DOWNLOAD_URL}"


RUN mkdir -p ${FISHEYE_HOME} ${FISHEYE_INST} && \
    7zz x ${TEMP_ARCHIVE} -o/tmp/fisheye-temp && \
    mv /tmp/fisheye-temp/*/* "${FISHEYE_HOME}" && \
    update-locale LC_ALL=en_US.UTF-8 LANG=en_US.UTF-8 && \
    apt-get clean -y && \
    apt-get autoremove -y && \
    apt-get autoclean -y && \
    rm -rfv /var/lib/apt/lists/* && \
    rm -rfv /var/cache/apt/archives/*.deb && \
    rm -rfv /root/tmp/* && \
    rm -rfv /tmp/*

COPY entrypoint.sh  /entrypoint.sh 

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
