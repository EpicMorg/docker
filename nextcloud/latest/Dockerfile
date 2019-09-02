FROM nextcloud:latest
ENV DEBIAN_FRONTEND noninteractive

#editing sources list
#RUN rm /etc/apt/sources.list
#COPY sources.list /etc/apt/sources.list

RUN docker-php-ext-install -j smbclient
RUN pecl install smbclient
RUN docker-php-ext-enable smbclient

RUN pt update -y  && apt install -y --allow-unauthenticated mc smbclient libsmbclient

#addoing some utils
#RUN apt update -y && apt dist-upgrade -y && apt install -y --allow-unauthenticated ca-certificates gnupg sudo apt-transport-https lsb-release apt-utils locales console-cyrillic wget curl htop mc tmux iftop cmatrix iputils-ping  cmatrix-xfont  lsof lynx fontconfig smbclient nano libsmbclient

#thank u, mac users. rolling back normal ZipStreammer
RUN rm -fv /var/www/html/lib/private/Streamer.php
ADD Streamer.php /var/www/html/lib/private/

#smb fix
RUN rm -fv /etc/samba/smb.conf
ADD smb.conf /etc/samba/
RUN rm -fv /usr/share/samba/smb.conf
ADD smb.conf /usr/share/samba/
