FROM epicmorg/teamcity-agent:minimal
LABEL maintainer="EpicMorg DevTeam, developer@epicm.org"
ARG DEBIAN_FRONTEND=noninteractive

##################################################################
#        OCI setup: Buildah, Podman, Kaniko, Docker
##################################################################
# https://docs.docker.com/build/architecture/#install-buildx
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
      containerd.io \
      buildah \ 
      podman \ 
      podman-compose \
      fuse-overlayfs && \
    pip3 install --break-system-packages --no-cache-dir \
      kaniko-wrapper \
      buildah-wrapper && \
    systemctl disable docker && \
    systemctl disable podman && \
    rm -rf /bin/docker-compose && \
    rm -rf /sbin/docker-compose && \
    rm -rf /usr/bin/docker-compose && \
    rm -rf /usr/sbin/docker-compose && \
    rm -rf /usr/local/bin/docker-compose && \
    rm -rf /usr/local/sbin/docker-compose && \
    export  DOCKER_COMPOSE_VERSION=`curl --silent https://api.github.com/repos/docker/compose/releases/latest | jq .name -r` && \
    echo "Latest compose is: ${DOCKER_COMPOSE_VERSION}" && \
    curl -SL https://github.com/docker/compose/releases/download/${DOCKER_COMPOSE_VERSION}/docker-compose-Linux-x86_64 -o /usr/local/bin/docker-compose && \
    chmod +x /usr/local/bin/docker-compose && \
# cleanup
    apt clean -y && \
    apt-get clean all && \
    apt autoclean -y && \
    rm -rfv /var/lib/apt/lists/* && \
    rm -rfv /var/cache/apt/archives/*.deb && \
    rm -rfv /tmp/*  

##################################################################
#              TeamCity Agent post-setup
##################################################################
ENV BUILDAH_FORMAT=docker
ENV BUILDAH_ISOLATION=docker
ENV DOCKER_HOST="unix:///var/run/docker.sock"
ENV PODMAN_HOST="unix:///var/run/docker.sock"

COPY etc/ /etc/

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
WORKDIR ${AGENT_DIST}

# A better fix for TW-52939 Dockerfile build fails because of aufs
VOLUME ["/var/lib/docker", "/var/lib/containers", "/var/tmp"]

RUN updatedb
