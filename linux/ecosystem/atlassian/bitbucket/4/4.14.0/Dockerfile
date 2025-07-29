FROM epicmorg/debian:bookworm-jdk8
LABEL maintainer="Atlassian Bitbucket Team; EpicMorg DevTeam, developer@epicm.org"
ARG DEBIAN_FRONTEND=noninteractive

##################################################################
#                   ARGuments
##################################################################
ARG RELEASE=4.14.0
ARG DOWNLOAD_URL=https://www.atlassian.com/software/stash/downloads/binary/atlassian-bitbucket-${RELEASE}.tar.gz
ARG TEMP_ARCHIVE=/tmp/atlassian-bitbucket-${RELEASE}.tar.gz

##################################################################
#                   Setup
##################################################################
ENV RUN_USER            daemon
ENV RUN_GROUP           daemon

# https://confluence.atlassian.com/display/BitbucketServer/Bitbucket+Server+home+directory
ENV BITBUCKET_HOME          /var/atlassian/application-data/bitbucket
ENV BITBUCKET_INSTALL_DIR   /opt/atlassian/bitbucket

VOLUME ["${BITBUCKET_HOME}"]
WORKDIR $BITBUCKET_HOME

# Expose HTTP and SSH ports
EXPOSE 7990
EXPOSE 7999

##################################################################
#                   Installing
##################################################################
RUN wget -c \
    --user-agent="Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:128.0) Gecko/20100101 Firefox/128.0" \
    --no-check-certificate \
    --tries=5 \
    --timeout=30 \
    --waitretry=5 \
    --retry-connrefused \
    --dns-timeout=10 \
    --read-timeout=20 \
    --progress=dot:giga \
    --no-clobber \
    -O /tmp/$(basename "${DOWNLOAD_URL}") \
    "${DOWNLOAD_URL}"

RUN mkdir -p                                 ${BITBUCKET_INSTALL_DIR} &&  \
    tar -xzf ${TEMP_ARCHIVE} --strip-components=1 --directory "${BITBUCKET_INSTALL_DIR}" && \
    chown -R ${RUN_USER}:${RUN_GROUP}        ${BITBUCKET_INSTALL_DIR}

##################################################################
#                   Post-Installing Setup
##################################################################
RUN rm -rfv /etc/apt/sources.list.d/launchpad_git-mainline.list && \
    rm -rfv /etc/apt/sources.list.d/launchpad_git-stable.list && \
    rm -rfv /etc/apt/sources.list.d/github_git-lfs.list && \
    apt-get update &&  \
    apt-get remove -y \
      git \
      git-extras \
      git-flow \
      git-cvs \
      git-doc \
      git-email \
      git-mediawiki \
      git-crypt \
      git-lfs \
      git-ftp && \
    apt-get autoremove -y && \
    apt-get install -y --allow-unauthenticated --no-install-recommends --no-install-suggests \
      git \
      git-extras \
      git-flow \
      git-cvs \
      git-doc \
      git-email \
      git-mediawiki \
      git-crypt \
      git-lfs \
      git-ftp

##################################################################
#                  Git Check
##################################################################
RUN git-lfs install --skip-repo --system --force && \
    echo "=============================================" && \
    echo git $(git --version) && \
    echo git-lfs $(git-lfs --version) && \
    echo "============================================="

##################################################################
#                  cleanup
##################################################################
RUN echo "clean up" && \
    apt-get clean -y && \
    apt-get autoremove -y && \
    apt-get autoclean -y && \
    rm -rfv /var/lib/apt/lists/* && \
    rm -rfv /var/cache/apt/archives/*.deb && \
    rm -rfv /root/tmp/* && \
    rm -rfv /tmp/*

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

CMD ["/entrypoint.sh", "-fg"]
ENTRYPOINT ["/usr/bin/tini", "--"]

RUN updatedb
