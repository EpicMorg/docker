FROM zabbix/zabbix-java-gateway:ubuntu-latest
ENV DEBIAN_FRONTEND noninteractive


#editing sources list
RUN rm /etc/apt/sources.list
COPY sources.list /etc/apt/sources.list
COPY locale.gen /etc/locale.gen

# installing additional apps
RUN apt update -y &&  apt install -y --allow-unauthenticated ca-certificates gnupg sudo apt-transport-https lsb-release apt-utils locales console-cyrillic wget curl htop mc tmux iftop  iputils-ping lsof lynx fontconfig smbclient nano php-cli php-curl
