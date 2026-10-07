FROM ghcr.io/epicmorg/gitlab-runner:minimal
LABEL maintainer="EpicMorg DevTeam, developer@epicm.org"
ARG DEBIAN_FRONTEND=noninteractive

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


