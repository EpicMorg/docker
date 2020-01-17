FROM epicmorg/devel:jdk11
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
    DOTNET_SDK_VERSION=3.1.101 \
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
    curl -SL https://download.visualstudio.microsoft.com/download/pr/c4b503d6-2f41-4908-b634-270a0a1dcfca/c5a20e42868a48a2cd1ae27cf038044c/dotnet-sdk-$DOTNET_SDK_VERSION-linux-x64.tar.gz --output dotnet.tar.gz \
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
#                   Installing PHP7
##################################################################
#installing php repo
RUN wget -O /etc/apt/trusted.gpg.d/php.gpg https://packages.sury.org/php/apt.gpg
RUN sh -c 'echo "deb https://packages.sury.org/php/ buster main" > /etc/apt/sources.list.d/php.list'

#Install base packages
RUN apt-get update && \
    apt-get install -y  --allow-unauthenticated \
      php7.3-gmp \
      php7.3-snmp \
      php7.3-ldap \
      php7.3-dev \
      php7.3 \
      php7.3-mail  \
      php7.3-mailparse \
      php7.3-soap \
      php7.3-mysql \
      php7.3-memcached \
      php7.3-memcache \
      php7.3-igbinary \
      php7.3-curl \
      php7.3-gd \
      php7.3-intl \
      php7.3-zip \
      php7.3-bcmath \
      php7.3-fpm \
      php-pear \
      php7.3-imap \
      php7.3-pspell \
      php7.3-recode \
      php7.3-sqlite3 \
      php7.3-tidy \
      php7.3-xmlrpc \
      php7.3-xml \
      php7.3-mbstring \
      php7.3-gettext \
      php7.3-apcu \
      php7.3-cli \
      php7.3-common \
      php7.3-cgi \
      php7.3-json \
      php7.3-readline \
      php7.3-enchant \
      php7.3-ssh2 \
      php7.3-oauth \
      php7.3-gmagick \
      php7.3-gnupg \
      php7.3-redis \
      php7.3-smbclient \
      php7.3-yaml \
      php7.3-geoip \
      sendmail && \
    phpenmod \
      snmp \
      gmp \
      calendar \
      ldap \
      curl \
      exif \
      ftp \
      fileinfo \
      gd \
      geoip \
      gettext \
      gnupg \
      iconv \
      imap \
      json \
      mbstring \
      memcached \
      mysqli \
      mysqlnd \
      oauth \
      pdo_mysql \
      pdo_sqlite \
      phar \
      posix \
      readline \
      redis \
      simplexml \
      sockets \
      sqlite3 \
      ssh2 \
      tokenizer \
      xml \
      xmlreader \
      xmlrpc \
      xmlwriter \
      xsl \
      yaml && \
    ln -sf /etc/ssl/dhparam.pem /etc/php/dhparam.pem && \
    php -v

##################################################################
#                   Installing Composer addon
##################################################################
RUN cd /tmp && \
     php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" && \
     php composer-setup.php  --install-dir=/usr/local/bin --filename=composer && \
     rm /tmp/composer-setup.php



##################################################################
#                   cleaninig up
##################################################################
RUN apt clean -y && \
    apt autoclean -y && \
    rm -rfv /var/lib/apt/lists/* && \
    rm -rfv /var/cache/apt/archives/*.deb && \
    rm -rfv /tmp/deb/* && \
    rm -rfv /tmp/composer-setup.php

CMD ["/run-services.sh"]

EXPOSE 9090
