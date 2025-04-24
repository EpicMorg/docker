FROM epicmorg/edge
LABEL maintainer="EpicMorg DevTeam, developer@epicm.org"
ARG DEBIAN_FRONTEND=noninteractive

ENV LD_LIBRARY_PATH=/steamcmd/linux64
ENV VALVE_FOLDER=/valve
ENV VALVE_STEAMCMD_FOLDER=${VALVE_FOLDER}/steamcmd
ENV VALVE_GAME_FOLDER=${VALVE_FOLDER}/game
ENV VALVE_VOLUME_FOLDER=${VALVE_FOLDER}/volume
ENV PATH="${VALVE_STEAMCMD_FOLDER}:${PATH}"

WORKDIR $VALVE_STEAMCMD_FOLDER

##################################################################
#                   installing steamcmd
##################################################################
RUN mkdir -p ${VALVE_STEAMCMD_FOLDER} ${VALVE_GAME_FOLDER} ${VALVE_VOLUME_FOLDER}
ADD http://media.steampowered.com/installer/steamcmd_linux.tar.gz $VALVE_STEAMCMD_FOLDER

RUN dpkg --add-architecture i386 && \
    apt-get update && \
    apt-get autoremove -y && \
    apt-get install -y --allow-unauthenticated gcc-multilib lib32stdc++6 lib32gcc1 && \
    tar -xvf $VALVE_STEAMCMD_FOLDER/steamcmd_linux.tar.gz -C $VALVE_STEAMCMD_FOLDER && \
    ln -s $VALVE_STEAMCMD_FOLDER/steamcmd.sh $VALVE_STEAMCMD_FOLDER/steamcmd && \
    ln -s $VALVE_STEAMCMD_FOLDER/steam.sh $VALVE_STEAMCMD_FOLDER/steam && \
    steamcmd +quit

##################################################################
#                   cleaninig up
##################################################################
RUN apt clean -y && \
    apt autoclean -y && \
    rm -rfv $VALVE_STEAMCMD_FOLDER/steamcmd_linux.tar.gz && \
    rm -rfv /tmp/ && \
    rm -rfv /var/lib/apt/lists/* && \
    rm -rfv /var/cache/apt/archives/*.deb
