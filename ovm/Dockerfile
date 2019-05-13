FROM debian:buster
MAINTAINER Anatoliy Zimovskiy <stam@epicm.org>

ENV DEBIAN_FRONTEND noninteractive

#editing sources list
RUN rm /etc/apt/sources.list
COPY sources.list /etc/apt/sources.list

#COPY locale.gen /etc/locale.gen

# fix errors
RUN echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections

#installing utils
RUN apt-get update && apt-get install -y --allow-unauthenticated ca-certificates gnupg sudo apt-transport-https lsb-release apt-utils locales console-cyrillic wget curl htop mc tmux iftop cmatrix iputils-ping  cmatrix-xfont  lsof lynx fontconfig smbclient nano


#installing packages
RUN gpg --keyserver keyserver.ubuntu.com --recv 7E7A6C592EF35D13
RUN gpg --keyserver keyserver.ubuntu.com --recv 24863F0C716B980B
RUN wget -qO - http://packages.openmediavault.org/public/archive.key | sudo apt-key add -
COPY openmediavault.list /etc/apt/sources.list.d/openmediavault.list
RUN apt-get update && apt-get install -y  --allow-unauthenticated  openmediavault-keyring postfix  openmediavault


#After install fixes
#RUN localedef en_US.UTF-8 -i en_US -f UTF-8
#RUN update-locale LC_ALL=en_US.UTF-8 LANG=en_US.UTF-8
#RUN apt update
#RUN apt upgrade -y
#RUN apt dist-upgrade -y
#RUN apt-get clean autoclean
#RUN apt-get autoremove -y
#RUN rm -rf /var/lib/apt/lists/*

#final config
# We need to make sure rrdcached uses /data for it's data
COPY defaults/rrdcached /etc/default

# Add our startup script last because we don't want changes
# to it to require a full container rebuild
COPY omv-startup /usr/sbin/omv-startup
RUN chmod +x /usr/sbin/omv-startup

EXPOSE 8080 8443

VOLUME /data

ENTRYPOINT /usr/sbin/omv-startup
