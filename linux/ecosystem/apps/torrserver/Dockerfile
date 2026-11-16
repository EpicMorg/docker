FROM ghcr.io/epicmorg/debian:trixie
LABEL org.opencontainers.image.title="EpicMorg TorrServer"
LABEL org.opencontainers.image.description="TorrServer (torrent streaming server) on Debian trixie"

#ARG TORRSERVER_LINK=https://releases.yourok.ru/torr/server/TorrServer-linux-amd64
# pinned: from Silo.* upstream is a rewrite (YAML config via -c, no --port/--path/--version,
# new data layout) - releases/latest moved there on 2026-11-14 and broke this image
ARG TORRSERVER_VERSION=MatriX.150
ARG TORRSERVER_SHA256=2326559e5047fe0cbea8fd36168d3c9da1243466640f8ee55051640b154788ae
ARG TORRSERVER_LINK=https://github.com/YouROK/TorrServer/releases/download/${TORRSERVER_VERSION}/TorrServer-linux-amd64

ENV TORRSERVER_DIR=${EMG_LOCAL_BASE_DIR}/torrserver
ENV TORRSERVER_BIN_DIR=${TORRSERVER_DIR}/bin
ENV TORRSERVER_CONF_DIR=${TORRSERVER_DIR}/config

ENV GODEBUG=madvdontneed=1
ENV UI_PORT=8090
ENV UPNP_PORT=32000

ADD ${TORRSERVER_LINK} /tmp/torrServer
RUN echo "${TORRSERVER_SHA256}  /tmp/torrServer" | sha256sum -c - && \
    mkdir -p ${TORRSERVER_DIR} ${TORRSERVER_CONF_DIR} ${TORRSERVER_BIN_DIR} && \
    mv -fv /tmp/torrServer ${TORRSERVER_BIN_DIR}/torrServer && \
    chmod +x ${TORRSERVER_BIN_DIR}/torrServer

ENV PATH="${TORRSERVER_BIN_DIR}:${PATH}"

RUN torrServer --version

#healthcheck. good practice
HEALTHCHECK --interval=2m --timeout=3s --start-period=2m CMD curl -f http://localhost:${UI_PORT}/ || exit 1

EXPOSE "${UI_PORT}"
EXPOSE "${UPNP_PORT}"
EXPOSE "${UPNP_PORT}/udp"

VOLUME ["${TORRSERVER_CONF_DIR}"]

WORKDIR ${TORRSERVER_DIR}

# exec-form ENTRYPOINT does not expand ${VARS}: go through sh, keep torrServer as PID 1,
# extra `docker run` arguments are appended
ENTRYPOINT ["/bin/sh", "-c", "exec torrServer --port \"${UI_PORT}\" --path \"${TORRSERVER_CONF_DIR}\" \"$@\"", "torrServer"]