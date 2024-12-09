FROM epicmorg/debian:bookworm-develop
LABEL maintainer="EpicMorg DevTeam, developer@epicm.org"
ARG DEBIAN_FRONTEND=noninteractive

ENV GITLAB_RUNNER_HOME=/home/gitlab-runner
ENV GITLAB_RUNNER_CONF=/etc/gitlab-runner
ENV GIT_SSH_VARIANT=ssh
RUN mkdir -p ${GITLAB_RUNNER_HOME} ${GITLAB_RUNNER_CONF} ${GITLAB_RUNNER_CONF}/certs && \
    chmod -R 700 /etc/gitlab-runner

##################################################################
#                    docker setup
##################################################################

#Install packages
RUN install -m 0755 -d /etc/apt/keyrings && \
    curl -fsSL https://download.docker.com/linux/debian/gpg -o /etc/apt/keyrings/docker.asc && \
    chmod a+r /etc/apt/keyrings/docker.asc && \
    echo  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/debian bookworm stable nightly" | tee /etc/apt/sources.list.d/docker.list > /dev/null  && \
    apt-get update && \
    apt-get install -y --no-install-recommends --allow-unauthenticated \
      docker-ce \
      docker-ce-cli \
      containerd.io \
      docker-buildx-plugin \
      docker-compose-plugin \
      systemd && \
    systemctl disable docker && \
    docker --version

COPY run-docker.sh /services/run-docker.sh
RUN chmod +x /services/run-docker.sh && \
    sync

##################################################################
#                    docker compose setup
##################################################################

#Install packages
RUN export  DOCKER_COMPOSE_VERSION=`curl --silent https://api.github.com/repos/docker/compose/releases/latest | jq .name -r` && \
    echo "Latest compose is: ${DOCKER_COMPOSE_VERSION}" && \
    curl -SL https://github.com/docker/compose/releases/download/${DOCKER_COMPOSE_VERSION}/docker-compose-Linux-x86_64 -o /usr/local/bin/docker-compose && \
    chmod +x /usr/local/bin/docker-compose && \
    docker-compose --version

##################################################################
#                    gitlab runner setup
##################################################################
ADD https://gitlab-runner-downloads.s3.amazonaws.com/latest/deb/gitlab-runner_amd64.deb /tmp
RUN dpkg -i /tmp/gitlab-runner_amd64.deb && \
    usermod -aG docker gitlab-runner && \
    cat /etc/passwd && \
    gitlab-runner --version

##################################################################
#                   cleaninig up
##################################################################
RUN apt clean -y && \
    apt-get clean all && \
    apt autoclean -y && \
    rm -rfv /var/lib/apt/lists/* && \
    rm -rfv /root/.cache/* && \
    rm -rfv /var/cache/* && \
    rm -rfv /root/tmp/* && \
    rm -rfv /tmp/*

#Final config
STOPSIGNAL SIGQUIT
VOLUME ["${GITLAB_RUNNER_CONF}", "/home/gitlab-runner", "/var/lib/docker"]
WORKDIR /home/gitlab-runner

# Add image configuration and scripts
COPY docker-entrypoint.sh /usr/bin/docker-entrypoint.sh
RUN chmod 755 /usr/bin/docker-entrypoint.sh

RUN updatedb

ENTRYPOINT ["/usr/bin/dumb-init", "docker-entrypoint.sh"]
CMD ["run", "--user=gitlab-runner", "--working-directory=/home/gitlab-runner"]
