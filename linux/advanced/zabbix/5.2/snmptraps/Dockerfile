FROM zabbix/zabbix-snmptraps:5.2-ubuntu-latest
ENV DEBIAN_FRONTEND noninteractive

USER root

##################################################################
#                  editing sources list
##################################################################
COPY sources.list /etc/apt/sources.list
COPY locale.gen /etc/locale.gen

##################################################################
#                   installing utils
##################################################################
RUN apt update -y && \
    apt install -y --allow-unauthenticated \
        acl \
        apt-transport-https \
        apt-utils \
        aptitude  \
        ca-certificates \
        console-cyrillic \
        curl \
        dos2unix \
        fontconfig \
        gnupg \
        htop \
        iftop \
        iotop \
        iperf \
        iperf3 \
        iputils-ping \
        jq \
        locales \
        logrotate \
        lsb-release \
        lsof \
        lynx \
        mc \
        nano \
        nmap \
        openssl \
        pev \
        php-cli \
        php-curl \
        procps \
        smbclient \
        sudo \
        telnet \
        tmux \
        util-linux \
        uuid-runtime \
        wget

RUN echo "zabbix ALL=(ALL) NOPASSWD: /usr/bin/nmap" > /etc/sudoers.d/zabbix
