FROM nextcloud:latest
ENV DEBIAN_FRONTEND noninteractive
RUN apt update -y && apt dist-upgrade -y && apt install -y --allow-unauthenticated ca-certificates gnupg sudo apt-transport-https lsb-release apt-utils locales console-cyrillic wget curl htop mc tmux iftop cmatrix iputils-ping  cmatrix-xfont  lsof lynx fontconfig smbclient nano libsmbclient
RUN rm -fv /var/www/html/lib/private/Streamer.php
ADD Streamer.php /var/www/html/lib/private/
RUN cat /var/www/html/lib/private/Streamer.php
