FROM hub.epicm.org/epicmorg/debian:bookworm-develop
LABEL maintainer="EpicMorg DevTeam, developer@epicm.org"
ARG DEBIAN_FRONTEND=noninteractive

##################################################################
#                    gitlab runner setup
##################################################################
ENV GITLAB_RUNNER_DIR=${EMG_LOCAL_BASE_DIR}/gitlab/runner
ENV GITLAB_RUNNER_BIN_DIR=${GITLAB_RUNNER_DIR}/bin
ENV GITLAB_RUNNER_CONF_DIR=${GITLAB_RUNNER_DIR}/etc/gitlab-runner
ENV GITLAB_RUNNER_CERTS_DIR=${GITLAB_RUNNER_CONF_DIR}/certs
ENV GITLAB_RUNNER_WORKER_DIR=${GITLAB_RUNNER_DIR}/worker

ENV GIT_SSH_VARIANT=ssh

ADD https://gitlab-runner-downloads.s3.amazonaws.com/latest/binaries/gitlab-runner-linux-amd64 /tmp

RUN mkdir -p \
      ${GITLAB_RUNNER_DIR} \
      ${GITLAB_RUNNER_BIN_DIR} \
      ${GITLAB_RUNNER_CONF_DIR} \
      ${GITLAB_RUNNER_CERTS_DIR} \
      ${GITLAB_RUNNER_WORKER_DIR} && \
    ln -sfv ${GITLAB_RUNNER_CONF_DIR} /etc/gitlab-runner && \
    mv /tmp/gitlab-runner-linux-amd64 ${GITLAB_RUNNER_BIN_DIR}/gitlab-runner && \
    chmod -R 700 ${GITLAB_RUNNER_CONF_DIR} && \
    chmod +x ${GITLAB_RUNNER_BIN_DIR}/gitlab-runner

ENV PATH=${GITLAB_RUNNER_BIN_DIR}:$PATH

RUN gitlab-runner --version

##################################################################
#                   cleaninig up
##################################################################
RUN apt-get clean -y && \
    apt-get clean all -y && \
    apt-get autoclean -y && \
    rm -rfv /var/lib/apt/lists/* && \
    rm -rfv /var/cache/apt/archives/*.deb && \
    rm -rfv /root/tmp/* && \
    rm -rfv /tmp/*

##################################################################
#                   final config
##################################################################
WORKDIR ${GITLAB_RUNNER_DIR}

VOLUME ["${GITLAB_RUNNER_CONF_DIR}", "${GITLAB_RUNNER_CERTS_DIR}", "${GITLAB_RUNNER_WORKER_DIR}", "/var/log/supervisor"]

CMD ["/usr/bin/supervisord"]

RUN updatedb
