FROM ghcr.io/epicmorg/teamcity-agent:minimal
LABEL org.opencontainers.image.title="EpicMorg TeamCity Agent"
LABEL org.opencontainers.image.description="TeamCity build agents on Debian 13 trixie: JDK 21, docker/buildah, php, node, SDKs"
ARG DEBIAN_FRONTEND=noninteractive

##################################################################
#                    teamcity AMXXModX setup
##################################################################
#
# Reserved for future
#    export AMXX_CSTRIKE_LATEST_VERSION=`curl -s https://www.amxmodx.org/amxxdrop/1.9/amxmodx-latest-cstrike-linux` && \
#    export AMXX_DOD_LATEST_VERSION=`curl -s https://www.amxmodx.org/amxxdrop/1.9/amxmodx-latest-dod-linux` && \
#    export AMXX_ESF_LATEST_VERSION=`curl -s https://www.amxmodx.org/amxxdrop/1.9/amxmodx-latest-esf-linux` && \
#    export AMXX_NS_LATEST_VERSION=`curl -s https://www.amxmodx.org/amxxdrop/1.9/amxmodx-latest-ns-linux` && \
#    export AMXX_TFC_LATEST_VERSION=`curl -s https://www.amxmodx.org/amxxdrop/1.9/amxmodx-latest-tfc-linux` && \
#    export AMXX_TS_LATEST_VERSION=`curl -s https://www.amxmodx.org/amxxdrop/1.9/amxmodx-latest-base-linux` && \
#
# Install packages
ENV AMXX_VERSION=1.9
ENV AMXX_INSTALL_PATH=${EMG_LOCAL_BASE_DIR}/amxmodx/${AMXX_VERSION}
ENV AMXX_BIN_PATH=${AMXX_INSTALL_PATH}/scripting
ENV AMXX_INC_PATH=${AMXX_BIN_PATH}/include
ENV PATH=${AMXX_BIN_PATH}:${PATH}
ENV LD_LIBRARY_PATH=${AMXX_BIN_PATH}:${LD_LIBRARY_PATH}

COPY inc.tar /tmp

# pinned GitHub release of alliedmodders/amxmodx, sha256 = the release asset digest;
# amxmodx.org/amxxdrop serves the same file - aria2c takes it as an alternative, sha256 still decides
ARG AMXX_RELEASE=1.9.0.5303
ARG AMXX_BASE_TARBALL=amxmodx-1.9.0-git5303-base-linux.tar.gz
ARG AMXX_BASE_SHA256=1ed6898ced2c1fcf225c288b94effc19917e987b284e42911587738ee3c93699
ARG AMXX_DROP_URL=https://www.amxmodx.org/amxxdrop/1.9
RUN mkdir -p ${AMXX_INSTALL_PATH} && \
    aria2c --conf-path=/usr/local/share/epicmorg/aria2/config/aria2.conf \
        --user-agent="$(shuf -n 1 /usr/local/share/epicmorg/user-agents/user-agents.txt)" \
        -d /tmp -o amxx_base_latest.tar.gz "https://github.com/alliedmodders/amxmodx/releases/download/${AMXX_RELEASE}/${AMXX_BASE_TARBALL}" \
        "${AMXX_DROP_URL}/${AMXX_BASE_TARBALL}" && \
    echo "${AMXX_BASE_SHA256}  /tmp/amxx_base_latest.tar.gz" | sha256sum -c - && \
    cd /tmp && tar -zxf /tmp/amxx_base_latest.tar.gz && cd / && \
    mv -f /tmp/addons/amxmodx/* ${AMXX_INSTALL_PATH} && \
    chmod +x ${AMXX_BIN_PATH}/amxxpc && \
    chmod +x ${AMXX_BIN_PATH}/compile.sh && \
    tar -C ${AMXX_INC_PATH} -xvf /tmp/inc.tar && \
    chmod -R 700 ${AMXX_INC_PATH} && \
    amxxpc --help 2>&1 | head -n 1

##################################################################
#                  Cleanup
##################################################################
RUN echo "clean up" && \
    apt-get clean -y && \
    apt-get autoclean -y && \
    rm -rfv /var/lib/apt/lists/* && \
    rm -rfv /var/cache/apt/archives/*.deb && \
    rm -rfv /tmp/*

##################################################################
#                   final config
##################################################################
WORKDIR ${AGENT_DIST}
