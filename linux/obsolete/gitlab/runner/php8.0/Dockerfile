FROM hub.epicm.org/epicmorg/debian:bookworm-php8.0
LABEL maintainer="EpicMorg DevTeam, developer@epicm.org"
ARG DEBIAN_FRONTEND=noninteractive

##################################################################
#                   php
##################################################################
RUN php -m && \
    php -v

ENV GITLAB_RUNNER_HOME=/home/gitlab-runner
ENV GITLAB_RUNNER_CONF=/etc/gitlab-runner
ENV GIT_SSH_VARIANT=ssh
RUN mkdir -p ${GITLAB_RUNNER_HOME} ${GITLAB_RUNNER_CONF} ${GITLAB_RUNNER_CONF}/certs && \
    chmod -R 700 /etc/gitlab-runner

##################################################################
#                    docker setup
##################################################################

#Install packages
RUN curl -fsSL https://download.docker.com/linux/debian/gpg | apt-key add - && \
    echo 'deb  https://download.docker.com/linux/debian bookworm test' > /etc/apt/sources.list.d/docker.list  && \
    echo 'deb  https://download.docker.com/linux/debian bookworm nightly' >> /etc/apt/sources.list.d/docker.list  && \
    apt-cache policy docker-ce && \
    apt-get update && \
    apt-get install -y --no-install-recommends --allow-unauthenticated \
      docker-ce \
      docker-ce-cli \
      containerd.io systemd && \
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
COPY install-gitlab-runner.sh /tmp/install-gitlab-runner.sh
RUN cd /tmp && \
    chmod +x /tmp/install-gitlab-runner.sh && \
    bash /tmp/install-gitlab-runner.sh && \
#    useradd --comment 'GitLab Runner' --create-home gitlab-runner --shell /bin/bash && \
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
    rm -rfv /var/cache/apt/archives/*.deb && \
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

