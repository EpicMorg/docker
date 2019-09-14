FROM debian:buster
MAINTAINER EpicMorg DevTeam
ENV DEBIAN_FRONTEND noninteractive

#editing sources list
RUN rm /etc/apt/sources.list
COPY sources.list /etc/apt/sources.list
RUN apt update && apt dist-upgrade -y
COPY locale.gen /etc/locale.gen

#installing utils
# url: missing
RUN echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections
RUN apt-get update && apt-get install -y --allow-unauthenticated uuid-runtime gnupg2 rsync ca-certificates htop mc tmux iftop cmatrix iputils-ping cmatrix-xfont lsof lynx fontconfig smbclient nano screenfetch git ffmpeg tree  gnupg sudo apt-transport-https lsb-release apt-utils locales console-cyrillic wget curl bash procps openssl perl ttf-dejavu tini util-linux fontconfig

##################################################################
#                   installing java8
##################################################################

RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys A66C5D02
RUN echo 'deb https://rpardini.github.io/adoptopenjdk-deb-installer stable main' > /etc/apt/sources.list.d/rpardini-aoj.list
RUN apt-get update && apt-get install -y --allow-unauthenticated  adoptopenjdk-8-installer

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
#fix of missing dist. sorry.
ADD https://teamcity.jetbrains.com/update/buildAgent.zip /buildAgent.zip
RUN unzip /buildAgent.zip -d /opt/buildagent && \
    mv /opt/buildagent/conf /opt/buildagent/conf_dist


RUN apt-get update && \
    apt-get install -y --no-install-recommends sudo && \
    useradd -m buildagent && \
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
#                   steam runtime and ssdk
##################################################################

RUN apt-get update && apt install -y --allow-unauthenticated build-essential gcc-multilib g++-multilib
RUN cd / && \
    sudo mkdir valve && \
    cd valve && \
    sudo wget http://media.steampowered.com/client/runtime/steam-runtime-sdk_latest.tar.xz && \
    sudo tar xvf steam-runtime-sdk_latest.tar.xz && \
    sudo mv steam-runtime-sdk_2013-09-05 steam-runtime && \
    sudo chown root:root * -R && \
    cd steam-runtime && \
    printf '%s\n' 3 1 Y Y Y | ./setup.sh


##################################################################
#                   retroarch deps
##################################################################
RUN apt-get update && apt install -y --allow-unauthenticated libxkbcommon-dev zlib1g-dev libfreetype6-dev libegl1-mesa-dev libgles2-mesa-dev libgbm-dev nvidia-cg-toolkit nvidia-cg-dev libavcodec-dev libsdl2-dev libsdl-image1.2-dev libxml2-dev yasm


##################################################################
#                       deb creating
##################################################################
RUN apt-get update && apt install -y --allow-unauthenticated devscripts autoconf automake libtool autotools-dev dpkg-dev fakeroot checkinstall dh-make


##################################################################
#                   other   customisations
##################################################################



CMD ["/run-services.sh"]

EXPOSE 9090
