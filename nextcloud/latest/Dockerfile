FROM nextcloud:latest
ENV DEBIAN_FRONTEND noninteractive

#editing sources list
#RUN rm /etc/apt/sources.list
#COPY sources.list /etc/apt/sources.list


#smb additional magic
ADD php-smbclient-latest.tar.gz /tmp 
RUN cp -fv /tmp/php-smbclient-latest/etc/php/7.3/mods-available/smbclient.ini /usr/local/etc/php/conf.d/smbclient.ini && \
    cp -fv /tmp/php-smbclient-latest/usr/lib/php/20180731/smbclient.so /usr/local/lib/php/extensions/no-debug-non-zts-20180731/smbclient.so && \
    rm -frv /tmp/php-smbclient-latest.tar.gz  && \ 
            /tmp/php-smbclient-latest
 
#addoing some utils
#RUN apt update -y && apt dist-upgrade -y && apt install -y --allow-unauthenticated ca-certificates gnupg sudo apt-transport-https lsb-release apt-utils locales console-cyrillic wget curl htop mc tmux iftop cmatrix iputils-ping  cmatrix-xfont  lsof lynx fontconfig smbclient nano libsmbclient

#thank u, mac users. rolling back normal ZipStreammer
RUN rm -fv /var/www/html/lib/private/Streamer.php
ADD Streamer.php /var/www/html/lib/private/

#smb fix
RUN rm -fv /etc/samba/smb.conf  && \
    /usr/share/samba/smb.conf
ADD smb.conf /etc/samba/ 
ADD smb.conf /usr/share/samba/
