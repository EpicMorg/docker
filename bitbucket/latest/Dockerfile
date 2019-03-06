FROM adoptopenjdk/openjdk8:slim

MAINTAINER Atlassian Bitbucket Server Team

ENV RUN_USER            					daemon
ENV RUN_GROUP           					daemon

# https://confluence.atlassian.com/display/BitbucketServer/Bitbucket+Server+home+directory
ENV BITBUCKET_HOME          				/var/atlassian/application-data/bitbucket
ENV BITBUCKET_INSTALL_DIR   				/opt/atlassian/bitbucket

VOLUME ["${BITBUCKET_HOME}"]
WORKDIR $BITBUCKET_HOME

# Expose HTTP and SSH ports
EXPOSE 7990
EXPOSE 7999

CMD ["/entrypoint.sh", "-fg"]
ENTRYPOINT ["/tini", "--"]

RUN apt-get update \
    && apt-get install -y --no-install-recommends fontconfig git perl \
    && apt-get clean autoclean && apt-get autoremove -y && rm -rf /var/lib/apt/lists/*

ARG TINI_VERSION=v0.18.0
ADD https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini /tini
RUN chmod +x /tini

COPY entrypoint.sh             				/entrypoint.sh

ARG BITBUCKET_VERSION=6.1.0
ARG DOWNLOAD_URL=https://product-downloads.atlassian.com/software/stash/downloads/atlassian-bitbucket-${BITBUCKET_VERSION}.tar.gz

RUN mkdir -p                             	${BITBUCKET_INSTALL_DIR} \
    && curl -L --silent                  	${DOWNLOAD_URL} | tar -xz --strip-components=1 -C "${BITBUCKET_INSTALL_DIR}" \
    && chown -R ${RUN_USER}:${RUN_GROUP} 	${BITBUCKET_INSTALL_DIR}/ \
    && sed -i -e 's/^# umask/umask/' 		${BITBUCKET_INSTALL_DIR}/bin/_start-webapp.sh