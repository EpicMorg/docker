FROM epicmorg/debian:bookworm-develop as builder


RUN mkdir /tmp/gopath

ENV GOPATH=/tmp/gopath 
ENV GO111MODULE=on

RUN go install 'github.com/vvampirius/retracker@latest'

RUN /tmp/gopath/bin/retracker -v

FROM  epicmorg/debian:bookworm


ENV RETRACKER_FOLDER=${EMG_LOCAL_BASE_DIR}/retracker
ENV RETRACKER_PORT=80
ENV RETRACKER_MINUTS=180
ENV RETRACKER_DEBUG=false
ENV RETRACKER_REAL_IP=true
ENV RETRACKER_OPTS=

ENV PATH="${RETRACKER_FOLDER}:${PATH}"

RUN mkdir -p ${RETRACKER_FOLDER}

COPY --from=builder  /tmp/gopath/bin/retracker ${RETRACKER_FOLDER}

RUN retracker -v

EXPOSE ${RETRACKER_PORT}

# Add image configuration and scripts
COPY docker-entrypoint.sh /usr/bin/docker-entrypoint.sh
RUN chmod 755 /usr/bin/docker-entrypoint.sh

RUN updatedb

ENTRYPOINT ["tini", "-s", "--", "docker-entrypoint.sh"]
CMD ["docker-entrypoint.sh"]
