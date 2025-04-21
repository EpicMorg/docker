FROM quay.io/epicmorg/debian:bookworm-develop
LABEL maintainer="EpicMorg DevTeam, developer@epicm.org"
ARG DEBIAN_FRONTEND=noninteractive

##################################################################
#             GHA setup
##################################################################

USER root

ENV GIT_SSH_VARIANT=ssh

ENV RUNNER_VERSION=2.323.0
ENV RUNNER_DIST_DIR=${EMG_LOCAL_BASE_DIR}/github/actions-runner
ENV RUNNER_BIN_DIR=${RUNNER_DIST_DIR}/bin
ENV RUNNER_DIAG_DIR=${RUNNER_DIST_DIR}_diag
ENV RUNNER_WORK_DIR=${RUNNER_DIST_DIR}/_work
ENV RUNNER_URL=https://github.com/actions/runner/releases/download/v${RUNNER_VERSION}/actions-runner-linux-x64-${RUNNER_VERSION}.tar.gz
ENV RUNNER_TEMP=/tmp/actions-runner-linux-x64-${RUNNER_VERSION}.tar.gz

COPY etc/ /etc/
COPY usr/local/share/epicmorg/ /usr/local/share/epicmorg/

ADD ${RUNNER_URL} ${RUNNER_TEMP}
RUN mkdir -p ${RUNNER_DIST_DIR} ${RUNNER_DIST_DIR} ${RUNNER_WORK_DIR} && \
    apt-get update && \
    apt-get install -y --no-install-recommends --allow-unauthenticated \
        supervisor && \
    tar -xvzf ${RUNNER_TEMP} --directory ${RUNNER_DIST_DIR} && \
    chmod +x ${RUNNER_DIST_DIR}/bin/*.sh && \
    chmod +x ${RUNNER_DIST_DIR}/sbin/*.sh && \
    ${RUNNER_DIST_DIR}/bin//installdependencies.sh && \
    sync

##################################################################
#                  Cleanup
##################################################################
RUN echo "clean up" && \
    apt-get clean -y && \
    apt-get autoclean -y && \
    rm -rfv /var/lib/apt/lists/* && \
    rm -rfv /var/cache/apt/archives/*.deb && \
    rm -rfv /root/tmp/* && \
    rm -rfv /tmp/*

##################################################################
#                   final config
##################################################################
WORKDIR ${RUNNER_DIST_DIR}

VOLUME ["${RUNNER_WORK_DIR}", "${RUNNER_DIAG_DIR}", "/var/log/supervisor"]

CMD ["/usr/bin/supervisord"]

RUN updatedb
