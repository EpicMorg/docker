FROM debian:buster
MAINTAINER Atlassian Bitbucket Server Team

ENV RUN_USER            daemon
ENV RUN_GROUP           daemon

# https://confluence.atlassian.com/display/BitbucketServer/Bitbucket+Server+home+directory
ENV BITBUCKET_HOME          /var/atlassian/application-data/bitbucket
ENV BITBUCKET_INSTALL_DIR   /opt/atlassian/bitbucket

ENV DEBIAN_FRONTEND noninteractive

#editing sources list
6666RUN rm /etc/apt/sources.list
COPY sources.list /etc/apt/sources.list
COPY locale.gen /etc/locale.gen

#installing utils
# url: missing
RUN echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections
RUN apt-get update && apt-get install -y --allow-unauthenticated gnupg2 ca-certificates htop mc tmux iftop cmatrix iputils-ping cmatrix-xfont lsof lynx  gnupg sudo apt-transport-https lsb-release apt-utils locales console-cyrillic wget curl bash procps openssl perl ttf-dejavu tini util-linux fontconfig git

#installing java
RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys A66C5D02
6RUN echo 'deb https://rpardini.github.io/adoptopenjdk-deb-installer stable main' > /etc/apt/sources.list.d/rpardini-aoj.list
RUN apt-get update && apt-get install -y --allow-unauthenticated  adoptopenjdk-8-installer

VOLUME ["${BITBUCKET_HOME}"]
WORKDIR $BITBUCKET_HOME

# Expose HTTP and SSH ports
EXPOSE 7990
EXPOSE 7999

CMD ["/entrypoint.sh", "-fg"]
ENTRYPOINT ["/usr/bin/tini", "--"]

COPY entrypoint.sh             /entrypoint.sh

#After install fixes
RUN localedef en_US.UTF-8 -i en_US -f UTF-8
RUN update-locale LC_ALL=en_US.UTF-8 LANG=en_US.UTF-8
RUN apt update
RUN apt upgrade -y
RUN apt dist-upgrade -y
RUN apt-get clean autoclean
RUN apt-get autoremove -y
RUN rm -rf /var/lib/apt/lists/*

ARG BITBUCKET_VERSION=6.4.0
ARG DOWNLOAD_URL=https://product-downloads.atlassian.com/software/stash/downloads/atlassian-bitbucket-${BITBUCKET_VERSION}.tar.gz

COPY . /tmp

RUN mkdir -p                             	${BITBUCKET_INSTALL_DIR} \
    && curl -L --silent                  	${DOWNLOAD_URL} | tar -xz --strip-components=1 -C "${BITBUCKET_INSTALL_DIR}" \
    && chown -R ${RUN_USER}:${RUN_GROUP} 	${BITBUCKET_INSTALL_DIR}/ \
    && sed -i -e 's/^# umask/umask/' 		${BITBUCKET_INSTALL_DIR}/bin/_start-webapp.sh

