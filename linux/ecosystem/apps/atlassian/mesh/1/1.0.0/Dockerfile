FROM ghcr.io/epicmorg/jdk:8
LABEL org.opencontainers.image.title="EpicMorg Bitbucket Mesh"
LABEL org.opencontainers.image.description="Atlassian Bitbucket Mesh by EpicMorg"
ARG DEBIAN_FRONTEND=noninteractive

##################################################################
#                   ARGuments
##################################################################
ARG RELEASE=1.0.0
# Old releases (1.x, 2.5.0) are not on the download site, only in Atlassian's maven repo.
ARG DOWNLOAD_URL=https://www.atlassian.com/software/stash/downloads/binary/atlassian-bitbucket-mesh-${RELEASE}.tar.gz
ARG DOWNLOAD_URL_MAVEN=https://packages.atlassian.com/mvn/maven-external/com/atlassian/bitbucket/mesh/mesh-distribution/${RELEASE}/mesh-distribution-${RELEASE}.tar.gz
ARG TEMP_ARCHIVE=/tmp/atlassian-bitbucket-mesh-${RELEASE}.tar.gz

##################################################################
#                   Setup
##################################################################
ENV RUN_USER=daemon
ENV RUN_GROUP=daemon

# https://confluence.atlassian.com/bitbucketserver/bitbucket-mesh-1128304351.html
ENV MESH_HOME=/var/atlassian/application-data/mesh
ENV MESH_INSTALL_DIR=/opt/atlassian/mesh

VOLUME ["${MESH_HOME}"]
WORKDIR $MESH_HOME

# Expose gRPC port
EXPOSE 7777

##################################################################
#                   Installing
##################################################################
RUN set -eux; \
    aria2c --conf-path=/usr/local/share/epicmorg/aria2/config/aria2.conf \
        --user-agent="$(shuf -n 1 /usr/local/share/epicmorg/user-agents/user-agents.txt)" \
        -d / -o ${TEMP_ARCHIVE} ${DOWNLOAD_URL} || { rm -f ${TEMP_ARCHIVE} ${TEMP_ARCHIVE}.aria2; \
    aria2c --conf-path=/usr/local/share/epicmorg/aria2/config/aria2.conf \
        --user-agent="$(shuf -n 1 /usr/local/share/epicmorg/user-agents/user-agents.txt)" \
        -d / -o ${TEMP_ARCHIVE} ${DOWNLOAD_URL_MAVEN}; } && \
    mkdir -p ${MESH_INSTALL_DIR} ${MESH_HOME} && \
    tar -xzf ${TEMP_ARCHIVE} --strip-components=1 --directory "${MESH_INSTALL_DIR}" && \
    test -x ${MESH_INSTALL_DIR}/bin/start-mesh.sh && \
    chown -R ${RUN_USER}:${RUN_GROUP} ${MESH_INSTALL_DIR} ${MESH_HOME} && \
    rm -fv ${TEMP_ARCHIVE}

##################################################################
#                   Git (Debian's, as in our Bitbucket images)
##################################################################
RUN rm -rfv /etc/apt/sources.list.d/github_git-lfs.sources && \
    rm -rfv /etc/apt/sources.list.d/github_git-lfs.todo.sources && \
    rm -rfv /etc/apt/sources.list.d/launchpad_git-mainline.sources && \
    rm -rfv /etc/apt/sources.list.d/launchpad_git-stable.sources && \
    apt-get update &&  \
    apt-get remove -y \
      git \
      git-lfs && \
    apt-get autoremove -y && \
    apt-get install -y --allow-unauthenticated --no-install-recommends --no-install-suggests \
      git \
      git-lfs

##################################################################
#                  Git Check
##################################################################
RUN git-lfs install --skip-repo --system --force && \
    echo "=============================================" && \
    echo git $(git --version) && \
    echo git-lfs $(git-lfs --version) && \
    echo "============================================="

##################################################################
#                  Git supported by this Mesh release
##################################################################
ENV GIT_PREFIX=/usr/local/share/epicmorg/git
COPY mesh-git.sh /tmp/mesh-git.sh
RUN bash /tmp/mesh-git.sh && \
    rm -f /tmp/mesh-git.sh
ENV PATH="${GIT_PREFIX}/bin:${PATH}"

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
