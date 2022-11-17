FROM epicmorg/php:php7.3
LABEL maintainer="EpicMorg DevTeam, developer@epicm.org"
ARG DEBIAN_FRONTEND=noninteractive

##################################################################
#                   php
##################################################################
RUN php -m && \
    php -v

ENV GITLAB_RUNNER_HOME=/opt/gitlab-runner
ENV GITLAB_RUNNER_CONF=/etc/gitlab-runner
ENV GIT_SSH_VARIANT=ssh
RUN mkdir -p ${GITLAB_RUNNER_HOME} ${GITLAB_RUNNER_CONF} ${GITLAB_RUNNER_CONF}/certs && \
    chmod -R 700 /etc/gitlab-runner

##################################################################
#                    gitlab runner setup
##################################################################
COPY install-gitlab-runner.sh /tmp/install-gitlab-runner.sh
RUN cd /tmp && \
    chmod +x /tmp/install-gitlab-runner.sh && \
    bash /tmp/install-gitlab-runner.sh && \
#    useradd --comment 'GitLab Runner' --create-home gitlab-runner --shell /bin/bash && \
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
    rm -rfv /tmp/*

#Final config
STOPSIGNAL SIGQUIT
VOLUME ["${GITLAB_RUNNER_CONF}", "${GITLAB_RUNNER_HOME}", "/var/lib/docker"]
WORKDIR ${GITLAB_RUNNER_HOME}

# Add image configuration and scripts
COPY docker-entrypoint.sh /usr/bin/docker-entrypoint.sh
RUN chmod 755 /usr/bin/docker-entrypoint.sh

ENTRYPOINT ["/usr/bin/dumb-init", "docker-entrypoint.sh"]
CMD ["run", "--user=gitlab-runner", "--working-directory=${GITLAB_RUNNER_HOME}"]

