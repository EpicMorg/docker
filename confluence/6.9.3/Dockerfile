FROM debian:buster
MAINTAINER Atlassian Confluence Server Team

ENV RUN_USER            daemon
ENV RUN_GROUP           daemon

# https://confluence.atlassian.com/doc/confluence-home-and-other-important-directories-590259707.html
ENV CONFLUENCE_HOME          /var/atlassian/application-data/confluence
ENV CONFLUENCE_INSTALL_DIR   /opt/atlassian/confluence

ENV DEBIAN_FRONTEND noninteractive

#editing sources list
RUN rm /etc/apt/sources.list
COPY sources.list /etc/apt/sources.list
COPY locale.gen /etc/locale.gen

#installing utils
# https://confluence.atlassian.com/confkb/update-the-confluence-docker-image-to-use-oracle-jdk-829062521.html
RUN echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections
RUN apt-get update && apt-get install -y --allow-unauthenticated gnupg2 ca-certificates htop mc tmux iftop cmatrix iputils-ping cmatrix-xfont lsof lynx  gnupg sudo apt-transport-https lsb-release apt-utils locales console-cyrillic wget curl bash procps openssl perl ttf-dejavu tini util-linux fontconfig

#installing java
RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys A66C5D02
RUN echo 'deb https://rpardini.github.io/adoptopenjdk-deb-installer stable main' > /etc/apt/sources.list.d/rpardini-aoj.list
RUN apt-get update && apt-get install -y --allow-unauthenticated  adoptopenjdk-8-installer

VOLUME ["${CONFLUENCE_HOME}"]
WORKDIR $CONFLUENCE_HOME

# Expose HTTP and Synchrony ports
EXPOSE 8090
EXPOSE 8091

CMD ["/entrypoint.sh", "-fg"]
ENTRYPOINT ["/usr/bin/tini", "--"]

COPY entrypoint.sh              /entrypoint.sh

#After install fixes
RUN localedef en_US.UTF-8 -i en_US -f UTF-8
RUN update-locale LC_ALL=en_US.UTF-8 LANG=en_US.UTF-8
RUN apt update
RUN apt upgrade -y
RUN apt dist-upgrade -y
RUN apt-get clean autoclean
RUN apt-get autoremove -y
RUN rm -rf /var/lib/apt/lists/*

ARG CONFLUENCE_VERSION=6.9.3
ARG DOWNLOAD_URL=http://www.atlassian.com/software/confluence/downloads/binary/atlassian-confluence-${CONFLUENCE_VERSION}.tar.gz

COPY . /tmp

RUN mkdir -p                             ${CONFLUENCE_INSTALL_DIR} \
    && curl -L --silent                  ${DOWNLOAD_URL} | tar -xz --strip-components=1 -C "$CONFLUENCE_INSTALL_DIR" \
    && chown -R ${RUN_USER}:${RUN_GROUP} ${CONFLUENCE_INSTALL_DIR}/ \
    && sed -i -e 's/-Xms\([0-9]\+[kmg]\) -Xmx\([0-9]\+[kmg]\)/-Xms\${JVM_MINIMUM_MEMORY:=\1} -Xmx\${JVM_MAXIMUM_MEMORY:=\2} \${JVM_SUPPORT_RECOMMENDED_ARGS} -Dconfluence.home=\${CONFLUENCE_HOME}/g' ${CONFLUENCE_INSTALL_DIR}/bin/setenv.sh \
    && sed -i -e 's/port="8090"/port="8090" secure="${catalinaConnectorSecure}" scheme="${catalinaConnectorScheme}" proxyName="${catalinaConnectorProxyName}" proxyPort="${catalinaConnectorProxyPort}"/' ${CONFLUENCE_INSTALL_DIR}/conf/server.xml
