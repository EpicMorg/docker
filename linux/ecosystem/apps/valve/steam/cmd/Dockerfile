FROM ghcr.io/epicmorg/debian:trixie
LABEL maintainer="EpicMorg DevTeam, developer@epicm.org"
ARG DEBIAN_FRONTEND=noninteractive

#ARG DOWNLOAD_URL=http://media.steampowered.com/installer/steamcmd_linux.tar.gz
ARG DOWNLOAD_URL=http://steamcdn-a.akamaihd.net/client/installer/steamcmd_linux.tar.gz

ENV VALVE_FOLDER=${EMG_LOCAL_BASE_DIR}/valve
ENV VALVE_GAME_FOLDER=${VALVE_FOLDER}/game
ENV VALVE_VOLUME_FOLDER=${VALVE_FOLDER}/volume
ENV VALVE_STEAMCMD_FOLDER=${VALVE_FOLDER}/steamcmd
ENV VALVE_STEAMCMD_LOGS=${VALVE_STEAMCMD_FOLDER}/logs
ARG VALVE_STEAMCMD_TEMP=/tmp/steamcmd_linux.tar.gz

ENV PATH="${VALVE_STEAMCMD_FOLDER}:${PATH}"
ENV LD_LIBRARY_PATH=/${VALVE_STEAMCMD_FOLDER}/linux64

##################################################################
#                   installing steamcmd
##################################################################
RUN mkdir -p ${VALVE_STEAMCMD_FOLDER} ${VALVE_GAME_FOLDER} ${VALVE_VOLUME_FOLDER}

RUN aria2c --conf-path=/usr/local/share/epicmorg/aria2/config/aria2.conf \
    --user-agent="$(shuf -n 1 /usr/local/share/epicmorg/user-agents/user-agents.txt)" \
    -d / -o ${VALVE_STEAMCMD_TEMP} \
    "${DOWNLOAD_URL}"

RUN dpkg --add-architecture i386 && \
    apt-get update && \
    apt-get install -y --allow-unauthenticated \
        gcc-multilib \
        lib32stdc++6 \
        lib32gcc-s1 \
        curl && \
    tar -xvf ${VALVE_STEAMCMD_TEMP} -C ${VALVE_STEAMCMD_FOLDER} && \
    ln -sfv ${VALVE_STEAMCMD_FOLDER} /root/Steam && \
    ln -sfv ${VALVE_STEAMCMD_FOLDER}/steamcmd.sh ${VALVE_STEAMCMD_FOLDER}/steamcmd && \
    ln -sfv ${VALVE_STEAMCMD_FOLDER}/steam.sh ${VALVE_STEAMCMD_FOLDER}/steam && \
    steamcmd +quit


WORKDIR ${VALVE_STEAMCMD_FOLDER}
VOLUME ${VALVE_STEAMCMD_LOGS} ${VALVE_VOLUME_FOLDER}
