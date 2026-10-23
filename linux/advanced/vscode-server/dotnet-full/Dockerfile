################################################################################
# https://github.com/linuxserver/docker-code-server/pkgs/container/code-server
################################################################################
FROM ghcr.io/epicmorg/vscode-server:latest
LABEL org.opencontainers.image.title="EpicMorg VS Code Server"
LABEL org.opencontainers.image.description="code-server (VS Code in the browser) with dev toolchains: C++/Rust/Go, Android, .NET, node"

ARG DEBIAN_FRONTEND=noninteractive

##################################################################
#                   ARGuments
##################################################################
ENV BuildDocker=true

##################################################################
#                    dotnet setup
##################################################################
ENV DOTNET_CHANNEL=STS
ENV DOTNET_ROOT=${EMG_LOCAL_BASE_DIR}/dotnet/${DOTNET_CHANNEL}
ARG DOTNET_TOOLS_DIR=${DOTNET_ROOT}/tools
ARG DOTNET_INSTALL_DIR=${DOTNET_ROOT}
ARG DOTNET_INSTALL_SCRIPT_URL=https://dotnet.microsoft.com/download/dotnet/scripts/v1/dotnet-install.sh

ENV DOTNET_CLI_TELEMETRY_OPTOUT=true
ENV DOTNET_SKIP_FIRST_TIME_EXPERIENCE=true

##################################################################
#                   installing dotnet
##################################################################
RUN set -eux; \
    mkdir -p ${DOTNET_ROOT} && \ 
    aria2c --conf-path=/usr/local/share/epicmorg/aria2/config/aria2.conf \
        --user-agent="$(shuf -n 1 /usr/local/share/epicmorg/user-agents/user-agents.txt)" \
        --check-certificate=true -d /tmp -o dotnet-install.sh ${DOTNET_INSTALL_SCRIPT_URL} && \
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
# Ubuntu's own mono (universe). download.mono-project.com is unmaintained
# (mono moved to WineHQ) and its newest Ubuntu suite is focal; apt-key is
# deprecated. Not in noble and dropped: mono-llvm-support,
# referenceassemblies-pcl (mono-project only).
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
      mono-complete \
      mono-devel \
      mono-dbg \
      ca-certificates-mono \
      mono-xsp4 && \
    mono --version && \
    apt-get clean -y && \
    rm -rf /var/lib/apt/lists/* /var/cache/apt/archives/*.deb /tmp/*

