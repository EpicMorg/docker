FROM zabbix/zabbix-web-apache-mysql:ubuntu-latest
ENV DEBIAN_FRONTEND noninteractive

USER root

#editing sources list
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
     sudo \
     php-cli \
     php-curl \
     telnet \
     nmap && \
     echo "zabbix ALL=(ALL) NOPASSWD: /usr/bin/nmap" > /etc/sudoers.d/zabbix
