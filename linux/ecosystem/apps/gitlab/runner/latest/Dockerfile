FROM docker.io/epicmorg/gitlab-runner:minimal
LABEL maintainer="EpicMorg DevTeam, developer@epicm.org"
ARG DEBIAN_FRONTEND=noninteractive

##################################################################
#        OCI setup: Buildah, Podman, Kaniko, Docker
##################################################################
# Docker CE repo for the base's own codename (trixie): keyring file + deb822 .sources.
# https://docs.docker.com/engine/install/debian/
RUN install -m 0755 -d /etc/apt/keyrings && \
    curl -fsSL https://download.docker.com/linux/debian/gpg -o /etc/apt/keyrings/docker.asc && \
    chmod a+r /etc/apt/keyrings/docker.asc && \
    . /etc/os-release && \
    printf '%s\n' \
      "Types: deb" \
      "URIs: https://download.docker.com/linux/debian" \
      "Suites: ${VERSION_CODENAME}" \
      "Components: stable" \
      "Architectures: $(dpkg --print-architecture)" \
      "Signed-By: /etc/apt/keyrings/docker.asc" \
      > /etc/apt/sources.list.d/docker.sources && \
    apt-get update && \
    apt-get install -y --no-install-recommends \
      docker-ce \
      docker-ce-cli \
      containerd.io \
      docker-buildx-plugin \
      docker-compose-plugin \
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
# legacy `docker-compose` name -> the compose plugin installed above (same binary,
# works standalone), instead of a second download resolved via the GitHub API.
    rm -f /usr/local/bin/docker-compose && \
    ln -sfv /usr/libexec/docker/cli-plugins/docker-compose /usr/local/bin/docker-compose && \
    docker --version && \
    docker-compose version && \
# cleanup
    apt-get clean -y && \
    apt-get clean all -y && \
    apt-get autoclean -y && \
    rm -rfv /var/lib/apt/lists/* && \
    rm -rfv /var/cache/apt/archives/*.deb && \
    rm -rfv /tmp/*  

##################################################################
#              OCI post-setup
##################################################################
ENV BUILDAH_FORMAT=docker
ENV BUILDAH_ISOLATION=docker
ENV DOCKER_HOST="unix:///var/run/docker.sock"
ENV PODMAN_HOST="unix:///var/run/docker.sock"

COPY etc/ /etc/

##################################################################
#                   installing dotnet
##################################################################
ENV DOTNET_CHANNEL=STS
ENV DOTNET_ROOT=${EMG_LOCAL_BASE_DIR}/dotnet/${DOTNET_CHANNEL}
ARG DOTNET_TOOLS_DIR=${DOTNET_ROOT}/tools
ARG DOTNET_INSTALL_DIR=${DOTNET_ROOT}
ARG DOTNET_INSTALL_SCRIPT_URL=https://dotnet.microsoft.com/download/dotnet/scripts/v1/dotnet-install.sh

ENV DOTNET_CLI_TELEMETRY_OPTOUT=true
ENV DOTNET_SKIP_FIRST_TIME_EXPERIENCE=true

ADD ${DOTNET_INSTALL_SCRIPT_URL} /tmp
RUN mkdir -p ${DOTNET_ROOT} && \ 
    chmod +x /tmp/dotnet-install.sh && \
    /tmp/dotnet-install.sh --verbose --no-path --install-dir ${DOTNET_ROOT} --channel ${DOTNET_CHANNEL} --version latest

##################################################################
#                   Setup $PATH
##################################################################
ENV PATH=$PATH:${DOTNET_ROOT}:${DOTNET_TOOLS_DIR}

##################################################################
#                   Version after install
##################################################################
RUN echo "=============================================" && \
    echo $(dotnet --info) && \
    echo $(dotnet --list-sdks) && \
    echo $(dotnet --list-runtimes) && \
    echo "============================================="

##################################################################
#                    Mono
##################################################################
# Debian's own mono (trixie: 6.12.0.199, i.e. the final upstream 6.12 line).
# download.mono-project.com ends at stable-buster/stable-focal (6.12.0.200,
# built for buster) and is no longer maintained (mono moved to WineHQ, which
# ships no Debian packages); apt-key is gone in trixie anyway.
# Not in trixie and dropped: mono-llvm-support, referenceassemblies-pcl
# (mono-project only), mono-xsp4 (last in bookworm).
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
      mono-complete \
      mono-devel \
      mono-dbg \
      ca-certificates-mono && \
    mono --version && \
    apt-get clean -y && \
    rm -rf /var/lib/apt/lists/* /var/cache/apt/archives/*.deb /tmp/*

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

VOLUME ["/var/lib/docker", "/var/lib/containers", "/var/tmp"]
