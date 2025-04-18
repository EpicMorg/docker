################################################################################
# https://github.com/linuxserver/docker-code-server/pkgs/container/code-server
################################################################################
FROM hub.epicm.org/epicmorg/vscode-server:latest

LABEL maintainer="EpicMorg DevTeam, developer@epicm.org"
ARG DEBIAN_FRONTEND=noninteractive

##################################################################
#                   ARGuments
##################################################################
ENV BuildDocker true

##################################################################
#                    dotnet setup
##################################################################
ENV DOTNET_CHANNEL=LTS
ENV DOTNET_ROOT=${EMG_LOCAL_BASE_DIR}/dotnet/${DOTNET_CHANNEL}
ARG DOTNET_TOOLS_DIR=${DOTNET_ROOT}/tools
ARG DOTNET_INSTALL_DIR=${DOTNET_ROOT}
ARG DOTNET_INSTALL_SCRIPT_URL=https://dotnet.microsoft.com/download/dotnet/scripts/v1/dotnet-install.sh

# Opt out of the telemetry feature
ENV DOTNET_CLI_TELEMETRY_OPTOUT=true
# Disable first time experience
ENV DOTNET_SKIP_FIRST_TIME_EXPERIENCE=true
# Configure Kestrel web server to bind to port 80 when present
ENV ASPNETCORE_URLS=\
# Enable detection of running in a container
ENV DOTNET_RUNNING_IN_CONTAINER=true
# Enable correct mode for dotnet watch (only mode supported in a container)
ENV DOTNET_USE_POLLING_FILE_WATCHER=true
# Skip extraction of XML docs - generally not useful within an image/container - helps perfomance
ENV NUGET_XMLDOC_MODE=skip
# unofficial support of openssl1.1 instead of 1.0 [https://stackoverflow.com/questions/51901359]
ENV CLR_OPENSSL_VERSION_OVERRIDE=45
# PowerShell telemetry for docker image usage
ENV POWERSHELL_DISTRIBUTION_CHANNEL=PSDocker-DotnetSDK-Ubuntu-20.04

RUN mkdir -p /usr/share/dotnet/host/fxr

##################################################################
#                   installing dotnet
##################################################################
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
RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 3FA7E0328081BFF6A14DA29AA6A19B38D3D831EF && \
    echo "deb https://download.mono-project.com/repo/ubuntu stable-focal main" | sudo tee /etc/apt/sources.list.d/mono-official-stable.list && \
#    echo "deb https://download.mono-project.com/repo/ubuntu nightly-focal main" | sudo tee /etc/apt/sources.list.d/mono-official-nightly.list && \
#    echo "deb https://download.mono-project.com/repo/ubuntu preview-focal main" | sudo tee /etc/apt/sources.list.d/mono-official-preview.list && \
    apt-get update && \
    apt-get install -y  --allow-unauthenticated \
    mono-complete \
    mono-llvm-support \
    mono-devel \
    mono-dbg \
    referenceassemblies-pcl \
    ca-certificates-mono \
    mono-xsp4

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

RUN updatedb
