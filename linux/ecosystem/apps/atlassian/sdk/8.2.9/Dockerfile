FROM docker.io/epicmorg/jdk:8
ARG DEBIAN_FRONTEND=noninteractive

##################################################################
#                   ARGuments
##################################################################
ARG RELEASE=8.2.9
ARG DOWNLOAD_URL=https://maven.artifacts.atlassian.com/com/atlassian/amps/atlassian-plugin-sdk/${RELEASE}/atlassian-plugin-sdk-${RELEASE}.tar.gz
ARG TEMP_ARCHIVE=/tmp/atlassian-plugin-sdk-${RELEASE}.tar.gz
ENV ATLASSIAN_SDK_INSTALL_DIR=${EMG_LOCAL_BASE_DIR}/atlassian/sdk
ENV ATLASSIAN_SDK_BIN_DIR=${ATLASSIAN_SDK_INSTALL_DIR}/bin
ENV ATLASSIAN_SDK_PROJECTS_DIR=${ATLASSIAN_SDK_INSTALL_DIR}/projects

# Use the maven bundled in the SDK archive instead of a system one
ENV MAVEN_VERSION=3.9.5
ENV MAVEN_PATH=${ATLASSIAN_SDK_INSTALL_DIR}/apache-maven-${MAVEN_VERSION}
ENV MAVEN_BIN=${MAVEN_PATH}/bin
ENV MAVEN_HOME=${ATLASSIAN_SDK_INSTALL_DIR}
ENV MAVEN_ROOT=${ATLASSIAN_SDK_INSTALL_DIR}
ENV MAVEN_OPTS="-Dmaven.repo.local=${EMG_LOCAL_BASE_DIR}/atlassian/sdk/repository"

ENV PATH="${MAVEN_BIN}:${ATLASSIAN_SDK_BIN_DIR}:${PATH}"

VOLUME ["${ATLASSIAN_SDK_PROJECTS_DIR}"]
WORKDIR ${ATLASSIAN_SDK_PROJECTS_DIR}

##################################################################
#                   Installing
##################################################################
# downloaded and removed in the same RUN: an ADD layer would keep the archive in the image
RUN mkdir -p ${ATLASSIAN_SDK_PROJECTS_DIR} && \
    wget -q -O ${TEMP_ARCHIVE} ${DOWNLOAD_URL} && \
    tar -xzf ${TEMP_ARCHIVE} --strip-components=1 --directory "${ATLASSIAN_SDK_INSTALL_DIR}" && \
    rm -fv ${TEMP_ARCHIVE} && \
    test -x ${MAVEN_BIN}/mvn && \
    rm -rfv ${ATLASSIAN_SDK_BIN_DIR}/*.bat && \
    chmod +x -R ${ATLASSIAN_SDK_BIN_DIR} && \
    mkdir -p /root/.m2 && \
    ln -sfv ${ATLASSIAN_SDK_INSTALL_DIR}/repository /root/.m2/repository && \
# cleanup
    apt-get clean -y && \
    apt-get clean all -y && \
    apt-get autoclean -y && \
    rm -rfv /var/lib/apt/lists/* && \
    rm -rfv /var/cache/apt/archives/*.deb && \
    rm -rfv /tmp/*    

##################################################################
#                   Version after install
##################################################################
RUN echo "=============================================" && \
    mvn -v && \
    echo "=============================================" && \
    atlas-version && \
    echo "============================================="
# no atlas-update: it would replace the pinned SDK with the newest one (and 8.x points to a dead marketplace URL)

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

