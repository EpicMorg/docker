FROM epicmorg/devel
LABEL maintainer="EpicMorg DevTeam, developer@epicm.org"
ARG DEBIAN_FRONTEND=noninteractive

##################################################################
#                   teamcity minimal agent
##################################################################
VOLUME /data/teamcity_agent/conf

ENV CONFIG_FILE=/data/teamcity_agent/conf/buildAgent.properties \
    LANG=C.UTF-8

LABEL dockerImage.teamcity.version="latest" \
      dockerImage.teamcity.buildNumber="latest"

COPY run-agent.sh /run-agent.sh
COPY run-services.sh /run-services.sh

ADD https://teamcity.jetbrains.com/update/buildAgent.zip /buildAgent.zip

RUN unzip /buildAgent.zip -d /opt/buildagent && \
    mv /opt/buildagent/conf /opt/buildagent/conf_dist && \
    rm -rfv /buildAgent.zip

RUN useradd -m buildagent && \
    chmod +x /opt/buildagent/bin/*.sh && \
    chmod +x /run-agent.sh /run-services.sh && sync

##################################################################
#                    teamcity main agent
##################################################################

    # Opt out of the telemetry feature
ENV DOTNET_CLI_TELEMETRY_OPTOUT=true \
    # Disable first time experience
    DOTNET_SKIP_FIRST_TIME_EXPERIENCE=true \
    # Configure Kestrel web server to bind to port 80 when present
    ASPNETCORE_URLS=http://+:80 \
    # Enable detection of running in a container
    DOTNET_RUNNING_IN_CONTAINER=true \
    # Enable correct mode for dotnet watch (only mode supported in a container)
    DOTNET_USE_POLLING_FILE_WATCHER=true \
    # Skip extraction of XML docs - generally not useful within an image/container - helps perfomance
    NUGET_XMLDOC_MODE=skip \
    GIT_SSH_VARIANT=ssh \
    # Install .NET Core SDK
    DOTNET_SDK_VERSION=2.2.402 \
    #unofficial support of openssl1.1 instead of 1.0 [https://stackoverflow.com/questions/51901359]
    CLR_OPENSSL_VERSION_OVERRIDE=45

    # docker insall
RUN apt-get update && \
    apt-get install -y git mercurial apt-transport-https ca-certificates software-properties-common && \
    \
    curl -fsSL https://download.docker.com/linux/debian/gpg | apt-key add - && \
    echo 'deb [arch=amd64] https://download.docker.com/linux/debian buster stable' > /etc/apt/sources.list.d/docker.list  && \
    apt-cache policy docker-ce && \
    apt-get update && apt-get install -y --allow-unauthenticated docker-ce docker-ce-cli containerd.io systemd && \
    systemctl disable docker && \
    curl -SL https://github.com/docker/compose/releases/download/1.24.1/docker-compose-Linux-x86_64 -o /usr/local/bin/docker-compose && chmod +x /usr/local/bin/docker-compose && \
    \
    apt-get install -y --no-install-recommends \
            fontconfig \
            libc6 \
            libgcc1 \
            libgssapi-krb5-2 \
            libicu63 \
            liblttng-ust0 \
            libssl1.1 \
            libstdc++6 \
            zlib1g \
        && rm -rf /var/lib/apt/lists/* && \
    \
    curl -SL https://dotnetcli.blob.core.windows.net/dotnet/Sdk/$DOTNET_SDK_VERSION/dotnet-sdk-$DOTNET_SDK_VERSION-linux-x64.tar.gz --output dotnet.tar.gz \
        && mkdir -p /usr/share/dotnet \
        && tar -zxf dotnet.tar.gz -C /usr/share/dotnet \
        && rm dotnet.tar.gz \
        && find /usr/share/dotnet -name "*.lzma" -type f -delete \
        && ln -s /usr/share/dotnet/dotnet /usr/bin/dotnet && \
    \
    apt-get clean all && \
    \
    usermod -aG docker buildagent

# A better fix for TW-52939 Dockerfile build fails because of aufs
VOLUME /var/lib/docker

COPY run-docker.sh /services/run-docker.sh
RUN chmod +x /services/run-docker.sh && sync

# Trigger .NET CLI first run experience by running arbitrary cmd to populate local package cache
RUN ln -s /usr/lib/x86_64-linux-gnu/libcrypto.so.1.1 /usr/lib/x86_64-linux-gnu/libcrypto.so.1.0 && \
    ln -s /usr/lib/x86_64-linux-gnu/libssl.so.1.1 /usr/lib/x86_64-linux-gnu/libssl.so.1.0 && \
    dotnet help


##################################################################
#                   cleaninig up
##################################################################
RUN apt clean -y && \
    apt autoclean -y && \
    rm -rfv /var/lib/apt/lists/* && \
    rm -rfv /var/cache/apt/archives/*.deb

CMD ["/run-services.sh"]

EXPOSE 9090
