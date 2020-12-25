FROM epicmorg/devel:jdk11
LABEL maintainer="EpicMorg DevTeam, developer@epicm.org"
ARG DEBIAN_FRONTEND=noninteractive

##################################################################
#                  bullseye  sources list
##################################################################
#COPY sources.bullseye.list /etc/apt/sources.list.d/sources.bullseye.list
RUN  apt update && \
     apt autoremove -y && \
     apt dist-upgrade -y && \
     apt autoremove -y

##################################################################
#                   teamcity minimal agent
##################################################################
LABEL dockerImage.teamcity.version="latest" \
      dockerImage.teamcity.buildNumber="latest"

VOLUME /data/teamcity_agent/conf

ENV CONFIG_FILE=/data/teamcity_agent/conf/buildAgent.properties
ENV LANG=C.UTF-8
ENV GIT_SSH_VARIANT=ssh

COPY run-agent.sh /run-agent.sh
RUN chmod +x /run-agent.sh && \
    sync

COPY run-services.sh /run-services.sh
RUN chmod +x /run-services.sh && \
    sync

ADD https://teamcity.jetbrains.com/update/buildAgent.zip /buildAgent.zip
RUN unzip -q /buildAgent.zip -d /opt/buildagent && \
    mv /opt/buildagent/conf /opt/buildagent/conf_dist && \
    rm -rfv /buildAgent.zip

RUN useradd -m buildagent && \
    chmod +x /opt/buildagent/bin/*.sh && \
    chmod +x /run-agent.sh /run-services.sh && sync

##################################################################
#                    teamcity dotnet+powershell setup
##################################################################
# Opt out of the telemetry feature
ENV DOTNET_CLI_TELEMETRY_OPTOUT=true

# Disable first time experience
ENV DOTNET_SKIP_FIRST_TIME_EXPERIENCE=true

# Configure Kestrel web server to bind to port 80 when present
ENV ASPNETCORE_URLS=http://+:80

# Enable detection of running in a container
ENV DOTNET_RUNNING_IN_CONTAINER=true

# Enable correct mode for dotnet watch (only mode supported in a container)
ENV DOTNET_USE_POLLING_FILE_WATCHER=true

# Skip extraction of XML docs - generally not useful within an image/container - helps perfomance
ENV NUGET_XMLDOC_MODE=skip

#unofficial support of openssl1.1 instead of 1.0 [https://stackoverflow.com/questions/51901359]
ENV CLR_OPENSSL_VERSION_OVERRIDE=45

#Install packages
RUN curl https://packages.microsoft.com/keys/microsoft.asc | sudo apt-key add - && \
    echo 'deb [arch=amd64,arm64,armhf] https://packages.microsoft.com/debian/10/prod buster main' > /etc/apt/sources.list.d/microsoft.dotnet.list  && \
    apt-get update && \
    apt-get install -y --no-install-recommends --allow-unauthenticated \
      libc6 \
#      libgcc1 \
      libgssapi-krb5-2 \
      libicu63 \
      liblttng-ust0 \
      libssl1.1 \
      libstdc++6 \
      zlib1g \
      dotnet-sdk-3.1  \
      aspnetcore-runtime-3.1 \
      dotnet-runtime-3.1 \
      powershell

# Trigger .NET CLI first run experience by running arbitrary cmd to populate local package cache
RUN ln -s /usr/lib/x86_64-linux-gnu/libcrypto.so.1.1 /usr/lib/x86_64-linux-gnu/libcrypto.so.1.0 && \
    ln -s /usr/lib/x86_64-linux-gnu/libssl.so.1.1 /usr/lib/x86_64-linux-gnu/libssl.so.1.0 && \
    dotnet help && \
    pwsh -v

##################################################################
#                    teamcity docker setup
##################################################################

#Install packages
RUN curl -fsSL https://download.docker.com/linux/debian/gpg | apt-key add - && \
    echo 'deb  https://download.docker.com/linux/debian buster test' > /etc/apt/sources.list.d/docker.list  && \
    apt-cache policy docker-ce && \
    apt-get update && \
    apt-get install -y --no-install-recommends --allow-unauthenticated \
      docker-ce \
      docker-ce-cli \
      containerd.io systemd && \
    systemctl disable docker && \
    usermod -aG docker buildagent

# A better fix for TW-52939 Dockerfile build fails because of aufs
VOLUME /var/lib/docker

COPY run-docker.sh /services/run-docker.sh
RUN chmod +x /services/run-docker.sh && \
    sync

##################################################################
#                    teamcity docker compose setup
##################################################################

#Install packages
RUN export  DOCKER_COMPOSE_VERSION=`curl --silent https://api.github.com/repos/docker/compose/releases/latest | jq .name -r` && \
    echo "Latest compose is: ${DOCKER_COMPOSE_VERSION}" && \
    curl -SL https://github.com/docker/compose/releases/download/${DOCKER_COMPOSE_VERSION}/docker-compose-Linux-x86_64 -o /usr/local/bin/docker-compose && \
    chmod +x /usr/local/bin/docker-compose

##################################################################
#                    teamcity AMXXModX setup
##################################################################
#
# Reserved for future
#    export AMXX_CSTRIKE_LATEST_VERSION=`curl -s https://www.amxmodx.org/amxxdrop/1.9/amxmodx-latest-cstrike-linux` && \
#    export AMXX_DOD_LATEST_VERSION=`curl -s https://www.amxmodx.org/amxxdrop/1.9/amxmodx-latest-dod-linux` && \
#    export AMXX_ESF_LATEST_VERSION=`curl -s https://www.amxmodx.org/amxxdrop/1.9/amxmodx-latest-esf-linux` && \
#    export AMXX_NS_LATEST_VERSION=`curl -s https://www.amxmodx.org/amxxdrop/1.9/amxmodx-latest-ns-linux` && \
#    export AMXX_TFC_LATEST_VERSION=`curl -s https://www.amxmodx.org/amxxdrop/1.9/amxmodx-latest-tfc-linux` && \
#    export AMXX_TS_LATEST_VERSION=`curl -s https://www.amxmodx.org/amxxdrop/1.9/amxmodx-latest-base-linux` && \
#
# Install packages
ENV AMXX_VERSION=1.9
ENV AMXX_INSTALL_PATH=/opt/amxmodx/$AMXX_VERSION
ENV AMXX_BIN_PATH=$AMXX_INSTALL_PATH/scripting
ENV PATH=$PATH:$AMXX_BIN_PATH
ENV LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$AMXX_BIN_PATH

RUN export AMXX_BASE_LATEST_VERSION=`curl -s https://www.amxmodx.org/amxxdrop/1.9/amxmodx-latest-base-linux` && \
    mkdir -p $AMXX_INSTALL_PATH && \
    curl -SL https://www.amxmodx.org/amxxdrop/{$AMXX_VERSION}/{$AMXX_BASE_LATEST_VERSION} -o /tmp/amxx_base_latest.tar.gz && \
    cd /tmp && tar -zxf /tmp/amxx_base_latest.tar.gz && cd / && \
    mv -f /tmp/addons/amxmodx/* $AMXX_INSTALL_PATH && \
    chmod +x $AMXX_BIN_PATH/amxxpc && \
    chmod +x $AMXX_BIN_PATH/compile.sh

##################################################################
#                    teamcity atlassian-sdk setup
##################################################################

#Install packages
#RUN curl -SL https://packages.atlassian.com/atlassian-sdk-deb/debian/pool/contrib/a/atlassian-plugin-sdk/atlassian-plugin-sdk_8.0.16_all.deb -o /tmp/atlassian-plugin-sdk.deb && \
#    dpkg -i /tmp/atlassian-plugin-sdk.deb

###############################
# https://community.atlassian.com/t5/Continuous-Delivery-questions/The-repository-https-packages-atlassian-com-atlassian-sdk-deb/qaq-p/1334014
#
# https://community.developer.atlassian.com/t/the-repository-https-packages-atlassian-com-atlassian-sdk-deb-stable-release-is-not-signed/36901
###############################
RUN curl -fsSL https://packages.atlassian.com/api/gpg/key/public | apt-key add - && \
    echo 'deb [trusted=yes] https://packages.atlassian.com/atlassian-sdk-deb stable contrib' > /etc/apt/sources.list.d/atlassian-sdk.list  && \
    apt-get update  --allow-insecure-repositories && \
    apt-get install -y --no-install-recommends  --allow-unauthenticated  \
      atlassian-plugin-sdk

##################################################################
#                   Installing PHP7.4
##################################################################
#installing php repo
RUN wget -O /etc/apt/trusted.gpg.d/php.gpg https://packages.sury.org/php/apt.gpg
RUN sh -c 'echo "deb https://packages.sury.org/php/ buster main" > /etc/apt/sources.list.d/php.list'

#installing apache2 repo
RUN wget -O /etc/apt/trusted.gpg.d/apache2.gpg https://packages.sury.org/apache2/apt.gpg
RUN sh -c 'echo "deb https://packages.sury.org/apache2/ buster main" > /etc/apt/sources.list.d/apache2.list'

#Install base packages
RUN apt-get update && \
    apt-get install -y  --allow-unauthenticated \
      php7.4 \
      php7.4-dev \
      php7.4-fpm \
      php7.4-cli \
      php7.4-cgi \
      php-pear \
      php-gmp \
      php-snmp \
      php-ldap \
      php-mail  \
#     php-mailparse \
      php-interbase \
      php-soap \
      php-mysql \
      php-memcached \
      php-memcache \
      php-igbinary \
      php-curl \
      php-gd \
      php-intl \
      php-zip \
      php-bcmath \
      php-imap \
      php-pspell \
      php-sqlite3 \
      php-tidy \
      php-xmlrpc \
      php-xml \
      php-mbstring \
#     php-gettext \
      php-apcu \
      php-common \
      php-json \
      php-readline \
      php-enchant \
      php-ssh2 \
      php-oauth \
      php-gmagick \
      php-gnupg \
      php-redis \
      php-smbclient \
      php-yaml \
      php-geoip \
      sendmail && \
    phpenmod \
      snmp \
      interbase \
      gmp \
      calendar \
      ldap \
      curl \
      exif \
      ftp \
      fileinfo \
      gd \
      geoip \
#     gettext \
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
    rm /tmp/composer-setup.php && \
    composer global require elendev/nexus-composer-push && \
    composer



##################################################################
#                   Node.js 15.x
##################################################################
RUN curl -sL https://deb.nodesource.com/setup_15.x | bash - && \
    curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add - && \
    echo "deb https://nightly.yarnpkg.com/debian/ nightly main" > /etc/apt/sources.list.d/yarn.list && \
    apt-get update && \
    apt-get install -y nodejs yarn

##################################################################
#                   steam runtime and ssdk
##################################################################
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
#                   Android SDK
##################################################################
RUN apt-get install -y -t sid --allow-unauthenticated \
      android-sdk \
      android-sdk-build-tools \
      android-sdk-platform-tools libsqlite3-0 sqlite3 && \
      echo "24333f8a63b6825ea9c5514f83c2829b004d1fee" > /usr/lib/android-sdk/licenses/android-sdk-license

ENV ANDROID_HOME=/usr/lib/android-sdk
ENV ANDROID_SDK_ROOT=/usr/lib/android-sdk

##################################################################
#                   cleaninig up
##################################################################
RUN apt clean -y && \
    apt-get clean all && \
    apt autoclean -y && \
    rm -rfv /var/lib/apt/lists/* && \
    rm -rfv /var/cache/apt/archives/*.deb && \
    rm -rfv /tmp/deb/* && \
    rm -rfv /tmp/composer-setup.php && \
    rm -rfv /tmp/amxx_base_latest.tar.gz && \
    rm -rfv /tmp/atlassian-plugin-sdk.deb && \
    rm -rfv /tmp/addons

CMD ["/run-services.sh"]

EXPOSE 9090
