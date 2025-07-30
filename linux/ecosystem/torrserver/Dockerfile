FROM docker.io/epicmorg/debian:bookworm

#ARG TORRSERVER_LINK=https://releases.yourok.ru/torr/server/TorrServer-linux-amd64
ARG TORRSERVER_LINK=https://github.com/YouROK/TorrServer/releases/latest/download/TorrServer-linux-amd64

ENV TORRSERVER_DIR=${EMG_LOCAL_BASE_DIR}/torrserver
ENV TORRSERVER_BIN_DIR=${TORRSERVER_DIR}/bin
ENV TORRSERVER_CONF_DIR=${TORRSERVER_DIR}/config

ENV GODEBUG=madvdontneed=1
ENV UI_PORT=8090
ENV UPNP_PORT=32000

ADD ${TORRSERVER_LINK} /tmp/torrServer 
RUN mkdir -p ${TORRSERVER_DIR} ${TORRSERVER_CONF_DIR} ${TORRSERVER_BIN_DIR} && \
    mv -fv /tmp/torrServer ${TORRSERVER_BIN_DIR}/torrServer && \
    chmod +x ${TORRSERVER_BIN_DIR}/torrServer

ENV PATH="${TORRSERVER_BIN_DIR}:${PATH}"

RUN torrServer --version

#healthcheck. good practice
HEALTHCHECK --interval=2m --timeout=3s CMD curl -f http://localhost:${UI_PORT}/ || exit 1

EXPOSE "${UI_PORT}"
EXPOSE "${UPNP_PORT}"
EXPOSE "${UPNP_PORT}/udp"

VOLUME ["${TORRSERVER_CONF_DIR}"]

WORKDIR ${TORRSERVER_DIR}

ENTRYPOINT ["torrServer", "--port", "${UI_PORT}", "-path", "${TORRSERVER_CONF_DIR}"]