FROM zabbix/zabbix-web-apache-mysql:ubuntu-latest
ENV DEBIAN_FRONTEND noninteractive

##################################################################
#   Build-time metadata as defined at http://label-schema.org
##################################################################
ARG BUILD_DATE=today
ARG VCS_REF=master
ARG VERSION=latest
LABEL org.label-schema.build-date=$BUILD_DATE \
          org.label-schema.name="Docker Scripts" \
          org.label-schema.description="Image for our docker containers." \
          org.label-schema.url="https://ww.epicm.org/" \
          org.label-schema.vcs-ref=$VCS_REF \
          org.label-schema.vcs-url="https://github.com/EpicMorg/docker-scripts" \
          org.label-schema.vendor="EpicMorg" \
          org.label-schema.version=$VERSION \
          org.label-schema.schema-version="1.0"

#editing sources list
RUN rm /etc/apt/sources.list
COPY sources.list /etc/apt/sources.list
COPY locale.gen /etc/locale.gen


# installing additional apps
RUN apt update -y && \
     apt install -y --allow-unauthenticated \
     ca-certificates \
     gnupg \
     sudo \
     apt-transport-https \
     lsb-release \
     apt-utils \
     locales \
     console-cyrillic \
     wget \
     curl \
     htop \
     mc \
     tmux \
     iftop \
     iputils-ping \
     lsof lynx \
     fontconfig \
     smbclient \
     nano \
     php-cli \
     php-curl \
     telnet \
     nmap && \
     echo "zabbix ALL=(ALL) NOPASSWD: /usr/bin/nmap" > /etc/sudoers.d/zabbix
