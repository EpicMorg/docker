FROM epicmorg/debian:bookworm-develop as builder

RUN git clone https://www-dev.cockos.com/ninjam/ninjam.git /tmp/ninjam && \
    cd /tmp/ninjam/ninjam/server && \
    make && \
    dos2unix *.cfg && \
    dos2unix *.txt

FROM epicmorg/debian:bookworm
LABEL maintainer="EpicMorg DevTeam, developer@epicm.org"
ARG DEBIAN_FRONTEND=noninteractive

##################################################################
#                   Setup
##################################################################
ENV NINJAM_CONFIG=config.cfg
ENV NINJAM_PORT=2049
ENV NINJAM_UID=1337
ENV NINJAM_DIR=/app
ENV NINJAM_BIN=${NINJAM_DIR}/bin
ENV NINJAM_ARCHIVE=${NINJAM_DIR}/archive
ENV NINJAM_LOG=${NINJAM_DIR}/log
ENV NINJAM_RUN=${NINJAM_DIR}/run
ENV NINJAM_LOGFILE=${NINJAM_LOG}/ninjamserver.log
ENV NINJAM_PID=${NINJAM_RUN}/ninjamserver.pid

RUN mkdir -p ${NINJAM_DIR} ${NINJAM_LOG} ${NINJAM_ARCHIVE} ${NINJAM_RUN} ${NINJAM_BIN}

ENV PATH="${PATH}:${NINJAM_BIN}"

COPY --from=builder /tmp/ninjam/ninjam/server/ninjamsrv  ${NINJAM_BIN}/ninjamsrv
COPY --from=builder /tmp/ninjam/ninjam/server/example.cfg  ${NINJAM_BIN}/example.cfg
COPY --from=builder /tmp/ninjam/ninjam/server/license.txt  ${NINJAM_BIN}/license.txt
COPY --from=builder /tmp/ninjam/ninjam/server/cclicense.txt  ${NINJAM_BIN}/cclicense.txt

##################################################################
#                   cleaninig up
##################################################################
RUN apt clean -y && \
    apt-get clean all && \
    apt autoclean -y && \
    rm -rfv /var/lib/apt/lists/* && \
    rm -rfv /root/.cache/* && \
    rm -rfv /var/cache/* && \
    rm -rfv /root/tmp/* && \
    rm -rfv /tmp/*

VOLUME ${NINJAM_LOG} ${NINJAM_ARCHIVE}

# Add image configuration and scripts
COPY docker-entrypoint.sh /usr/bin/docker-entrypoint.sh
RUN chmod 755 /usr/bin/docker-entrypoint.sh

RUN updatedb
RUN chmod 755 ${NINJAM_BIN}/ninjamsrv

#Final config
EXPOSE ${NINJAM_PORT} ${NINJAM_PORT}/udp

WORKDIR ${NINJAM_BIN}

ENTRYPOINT ["tini", "-s", "--", "docker-entrypoint.sh"]
CMD ["docker-entrypoint.sh"]

#ENTRYPOINT ${NINJAM_BIN}/ninjamsrv ${NINJAM_CONFIG} -port ${NINJAM_PORT} -setuid ${NINJAM_UID} -archive ${NINJAM_ARCHIVE} -logfile ${NINJAM_LOGFILE} -pidfile ${NINJAM_PID}
