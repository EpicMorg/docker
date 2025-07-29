FROM epicmorg/debian:bookworm
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

RUN wget -c \
    --user-agent="Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:128.0) Gecko/20100101 Firefox/128.0" \
    --no-check-certificate \
    --retry-connrefused \
    --tries=15 \
    --timeout=30 \
    --waitretry=15 \
    --dns-timeout=30 \
    --read-timeout=30 \
    --progress=dot:giga \
    --no-clobber \
    -O ${VALVE_STEAMCMD_TEMP} \
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

##################################################################
#                   cleaninig up
##################################################################
RUN echo "clean up" && \
    apt-get clean -y && \
    apt-get autoclean -y && \
    rm -rfv /var/lib/apt/lists/* && \
    rm -rfv /var/cache/apt/archives/*.deb && \
    rm -rfv /root/tmp/* && \
    rm -rfv /tmp/*


WORKDIR ${VALVE_STEAMCMD_FOLDER}
VOLUME ${VALVE_STEAMCMD_LOGS} ${VALVE_VOLUME_FOLDER}

RUN updatedb
