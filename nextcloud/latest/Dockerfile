FROM nextcloud:latest
ENV DEBIAN_FRONTEND noninteractive

#editing sources list
RUN rm /etc/apt/sources.list
COPY sources.list /etc/apt/sources.list

#addoing some utils
RUN apt update -y && apt dist-upgrade -y && apt install -y --allow-unauthenticated ca-certificates gnupg sudo apt-transport-https lsb-release apt-utils locales console-cyrillic wget curl htop mc tmux iftop cmatrix iputils-ping  cmatrix-xfont  lsof lynx fontconfig smbclient nano libsmbclient

#thank u, mac users. rolling back normal ZipStreammer
RUN rm -fv /var/www/html/lib/private/Streamer.php
ADD Streamer.php /var/www/html/lib/private/
