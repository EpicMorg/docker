################################################################################
# https://github.com/linuxserver/docker-code-server/pkgs/container/code-server
################################################################################
FROM ghcr.io/epicmorg/vscode-server:latest

LABEL maintainer="EpicMorg DevTeam, developer@epicm.org"
ARG DEBIAN_FRONTEND=noninteractive

##################################################################
#                   ARGuments
##################################################################
ENV BuildDocker=true

##################################################################
#        OCI setup: Buildah, Podman, Kaniko, Docker
##################################################################
# https://docs.docker.com/build/architecture/#install-buildx
RUN install -m 0755 -d /etc/apt/keyrings && \
    aria2c --conf-path=/usr/local/share/epicmorg/aria2/config/aria2.conf \
        --user-agent="$(shuf -n 1 /usr/local/share/epicmorg/user-agents/user-agents.txt)" \
        --check-certificate=true -d /etc/apt/keyrings -o docker.asc https://download.docker.com/linux/debian/gpg && \
    chmod a+r /etc/apt/keyrings/docker.asc && \
    echo  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/debian bookworm stable nightly" | tee /etc/apt/sources.list.d/docker.list > /dev/null  && \
    apt-get update && \
    apt-get install -y --no-install-recommends --allow-unauthenticated \
      supervisor \
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
# podman-compose (apt) brings Debian's python3-typing-extensions, which pip can't uninstall
# (no RECORD) while pydantic needs a newer one: install it over, then the wrappers.
    pip3 install --no-cache-dir typing-extensions --ignore-installed --no-deps --break-system-packages --root-user-action=ignore && \
    pip3 install --no-cache-dir kaniko-wrapper --ignore-installed --break-system-packages --force-reinstall --root-user-action=ignore && \
    pip3 install --no-cache-dir buildah-wrapper --ignore-installed --break-system-packages --force-reinstall --root-user-action=ignore && \
    systemctl disable docker && \
    systemctl disable podman && \
    rm -rf /bin/docker-compose && \
    rm -rf /sbin/docker-compose && \
    rm -rf /usr/bin/docker-compose && \
    rm -rf /usr/sbin/docker-compose && \
    rm -rf /usr/local/bin/docker-compose && \
    rm -rf /usr/local/sbin/docker-compose && \
    aria2c --conf-path=/usr/local/share/epicmorg/aria2/config/aria2.conf \
        --user-agent="$(shuf -n 1 /usr/local/share/epicmorg/user-agents/user-agents.txt)" \
        --check-certificate=true -d /tmp -o compose-latest.json https://api.github.com/repos/docker/compose/releases/latest && \
    export DOCKER_COMPOSE_VERSION="$(jq -r .name /tmp/compose-latest.json)" && \
    rm -f /tmp/compose-latest.json && \
    echo "Latest compose is: ${DOCKER_COMPOSE_VERSION}" && \
    aria2c --conf-path=/usr/local/share/epicmorg/aria2/config/aria2.conf \
        --user-agent="$(shuf -n 1 /usr/local/share/epicmorg/user-agents/user-agents.txt)" \
        --check-certificate=true -d /usr/local/bin -o docker-compose https://github.com/docker/compose/releases/download/${DOCKER_COMPOSE_VERSION}/docker-compose-Linux-x86_64 && \
    chmod +x /usr/local/bin/docker-compose && \
# cleanup
    apt-get clean -y && \
    apt-get clean all -y && \
    apt-get autoclean -y && \
    rm -rfv /var/lib/apt/lists/* && \
    rm -rfv /var/cache/apt/archives/*.deb && \
    rm -rfv /tmp/*  

ENV BUILDAH_FORMAT=docker
ENV BUILDAH_ISOLATION=oci
ENV DOCKER_HOST="unix:///var/run/docker.sock"
ENV PODMAN_HOST="unix:///var/run/docker.sock"

COPY etc/ /etc/


# A better fix for TW-52939 Dockerfile build fails because of aufs
VOLUME ["/var/lib/docker", "/var/lib/containers", "/var/tmp", "/var/log/supervisor"]
