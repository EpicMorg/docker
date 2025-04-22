FROM epicmorg/linux-steamcmd
LABEL maintainer="EpicMorg DevTeam, developer@epicm.org"
ARG DEBIAN_FRONTEND=noninteractive

WORKDIR $VALVE_GAME_FOLDER

##################################################################
#                   installing csgo
##################################################################

RUN steamcmd +login anonymous +force_install_dir $VALVE_GAME_FOLDER  +app_update 740 validate +quit && \
    ls -asl $VALVE_GAME_FOLDER


##################################################################
#                   cleaninig up
##################################################################
RUN apt clean -y && \
    apt autoclean -y && \
    rm -rfv $VALVE_STEAMCMD_FOLDER/steamcmd_linux.tar.gz && \
    rm -rfv /tmp/ && \
    rm -rfv /var/lib/apt/lists/* && \
    rm -rfv /var/cache/apt/archives/*.deb
