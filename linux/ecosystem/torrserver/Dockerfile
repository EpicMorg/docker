FROM hub.epicm.org/epicmorg/debian:bullseye

#ARG TORRSERVER_LINK=https://releases.yourok.ru/torr/server/TorrServer-linux-amd64
ARG TORRSERVER_LINK=https://github.com/YouROK/TorrServer/releases/latest/download/TorrServer-linux-amd64

WORKDIR /opt

ADD $TORRSERVER_LINK torrServer

RUN \
  apt-get update && \
  apt-get upgrade -y && \
  export GODEBUG=madvdontneed=1 && \
  chmod +x torrServer 

ENV UI_PORT 8090
ENV UPNP_PORT 32000

EXPOSE \ 
  $UI_PORT \
  $UPNP_PORT \
  $UPNP_PORT/udp

VOLUME \
  /config

#healthcheck. good practice
HEALTHCHECK --interval=2m --timeout=3s CMD curl -f http://localhost:${UI_PORT}/ || exit 1

ENTRYPOINT /opt/torrServer --port $UI_PORT -path /config