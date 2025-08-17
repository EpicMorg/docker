FROM docker.io/epicmorg/debian:trixie-jdk8
LABEL maintainer="EpicMorg DevTeam, developer@epicm.org"
ARG DEBIAN_FRONTEND=noninteractive

ARG SMP_MAJOR_VERSION=3
ARG SMP_FULL_VERSION=3.0.0
ARG SMP_BUILD_VERSION=241210
ENV SMP_DIR=${EMG_LOCAL_BASE_DIR}/supermicro
ENV SMP_VOLUME=${SMP_DIR}/config
ARG SMP_URL=https://www.supermicro.com/Bios/sw_download/849/Supermicro_Management_Plugin_for_vCenter_${SMP_FULL_VERSION}_build_${SMP_BUILD_VERSION}.zip
ARG SMP_TEMP=/tmp/Supermicro_Management_Plugin_for_vCenter_${SMP_FULL_VERSION}_build_${SMP_BUILD_VERSION}.zip

ADD ${SMP_URL} /tmp

#COPY supermicro /supermicro
RUN mkdir -p ${SMP_DIR} && \
    cd /tmp && \
    unzip ${SMP_TEMP} && \
    mv -fv /tmp/supermicro/* ${SMP_DIR}/ && \
    ln -sfv ${SMP_DIR} /supermicro && \
    java -version && \
    apt-get update && \
    apt-get install -y curl gcc openssl && \
# cleanup
    apt-get clean -y && \
    apt-get clean all -y && \
    apt-get autoclean -y && \
    rm -rfv /var/lib/apt/lists/* && \
    rm -rfv /var/cache/apt/archives/*.deb && \
    rm -rfv /tmp/* 

VOLUME [ "${SMP_VOLUME}" ]
WORKDIR ${SMP_DIR}

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

EXPOSE 8443

CMD ["/entrypoint.sh", "-fg"]
ENTRYPOINT ["/usr/bin/tini", "--"]

RUN updatedb
