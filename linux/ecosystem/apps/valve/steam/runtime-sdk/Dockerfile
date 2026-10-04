FROM docker.io/epicmorg/debian:trixie-develop
LABEL maintainer="EpicMorg DevTeam, developer@epicm.org"
ARG DEBIAN_FRONTEND=noninteractive

##################################################################
#                   ARGuments
##################################################################
# /etc/ld.so.conf.d/
ARG LD_CONF_DIR=/etc/ld.so.conf.d/

# steam runtime sdk
ENV STEAM_RUNTIME_SDK_DIR=${EMG_LOCAL_BASE_DIR}/valve/steam/runtime-sdk/latest
ARG STEAM_RUNTIME_SDK_BIN_DIR=${STEAM_RUNTIME_SDK_DIR}/bin
ARG STEAM_RUNTIME_SDK_URL=http://media.steampowered.com/client/runtime/steam-runtime-sdk_latest.tar.xz
ARG STEAM_RUNTIME_SDK_TEMP=/tmp/steam-runtime-sdk_latest.tar.xz

##################################################################
#                   steam runtime and ssdk
##################################################################
SHELL ["/bin/bash", "-c"]
RUN mkdir -p ${STEAM_RUNTIME_SDK_DIR} && \
    aria2c \
        --conf-path="/usr/local/share/epicmorg/aria2/config/aria2.conf" \
        --user-agent="$(shuf -n 1 /usr/local/share/epicmorg/user-agents/user-agents.txt)" \
        -d /tmp \
        "${STEAM_RUNTIME_SDK_URL}" && \
    tar -xf ${STEAM_RUNTIME_SDK_TEMP} --directory ${STEAM_RUNTIME_SDK_DIR} --strip-components=1 && \
    chmod +x ${STEAM_RUNTIME_SDK_BIN_DIR} -R && \
    chmod +x ${STEAM_RUNTIME_SDK_DIR}/setup.sh && \
    chmod +x ${STEAM_RUNTIME_SDK_DIR}/shell.sh && \
    chmod +x ${STEAM_RUNTIME_SDK_DIR}/shell-amd64.sh && \
    chmod +x ${STEAM_RUNTIME_SDK_DIR}/shell-i386.sh && \
    printf '%s\n' 3 1 Y Y Y | ${STEAM_RUNTIME_SDK_DIR}/setup.sh && \
      echo "clean up" && \
      rm -rfv /tmp/*
SHELL ["/bin/sh", "-c"]

WORKDIR ${STEAM_RUNTIME_SDK_DIR}

##################################################################
#                   other   customisations
##################################################################
