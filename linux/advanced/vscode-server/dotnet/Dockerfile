################################################################################
# https://github.com/linuxserver/docker-code-server/pkgs/container/code-server
################################################################################
FROM epicmorg/vscode-server:latest

LABEL maintainer="EpicMorg DevTeam, developer@epicm.org"
ARG DEBIAN_FRONTEND=noninteractive

##################################################################
#                   ARGuments
##################################################################
ENV BuildDocker true

##################################################################
#                    dotnet+powershell setup
##################################################################
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

#Install packages
RUN curl https://packages.microsoft.com/keys/microsoft.asc | sudo apt-key add - && \
    echo 'deb [arch=amd64,arm64,armhf] https://packages.microsoft.com/ubuntu/20.04/prod focal main' > /etc/apt/sources.list.d/microsoft.dotnet.list  && \
    apt-get update && \
    apt-get install -y --no-install-recommends --allow-unauthenticated \
#      dotnet-sdk-2.1 \
#      dotnet-runtime-deps-2.1 \
#      dotnet-runtime-2.1 \
#      dotnet-hostfxr-2.1 \
#      dotnet-sdk-3.1 \
#      dotnet-targeting-pack-3.1 \
#      dotnet-runtime-deps-3.1 \
#      dotnet-runtime-3.1 \
#      dotnet-hostfxr-3.1 \
#      dotnet-apphost-pack-3.1 \
#      dotnet-sdk-5.0 \
#      dotnet-targeting-pack-5.0 \
#      dotnet-runtime-deps-5.0 \
#      dotnet-runtime-5.0 \
#      dotnet-hostfxr-5.0 \
#      dotnet-apphost-pack-5.0 \
#      dotnet-sdk-6.0 \
#      dotnet-targeting-pack-6.0 \
#      dotnet-runtime-deps-6.0 \
#      dotnet-runtime-6.0 \
#      dotnet-hostfxr-6.0 \
#      dotnet-apphost-pack-6.0 \
      dotnet-sdk-7.0 \
      dotnet-targeting-pack-7.0 \
      dotnet-runtime-deps-7.0 \
      dotnet-runtime-7.0 \
      dotnet-hostfxr-7.0 \
      dotnet-apphost-pack-7.0 \
      dotnet-host \
      procdump \
      procmon \
      powershell-preview \
      powershell

# Trigger .NET CLI first run experience by running arbitrary cmd to populate local package cache
RUN dotnet help && \
    pwsh-preview -v && \
    pwsh -v

# install dotnet tools
RUN dotnet tool list -g && \
    dotnet tool install -g dotnet-script && \
    curl -s https://raw.githubusercontent.com/filipw/dotnet-script/master/install/install.sh | bash && \
    dotnet tool list -g && \
    dotnet-script --version

##################################################################
#                   cleaninig up
##################################################################
RUN apt purge policykit-1 -y && \
    apt clean -y && \
    apt autoclean -y && \
    rm -rfv /var/lib/apt/lists/* && \
    rm -rfv /tmp/mc.patch && \
    rm -rfv /var/cache/apt/archives/*.deb && \
    rm -rfv /tmp/*
