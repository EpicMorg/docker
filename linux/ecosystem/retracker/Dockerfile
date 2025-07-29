FROM epicmorg/debian:bookworm-develop as builder

ARG GOPATH=/tmp/gopath

RUN go install 'github.com/vvampirius/retracker@latest'

RUN retracker -v

FROM  epicmorg/debian:bookworm
COPY --from=builder  /tmp/gopath/retracker /bin/retracker

ENV RETRACKER_PORT=80
ENV RETRACKER_MINUTS=180
ENV RETRACKER_DEBUG=false
ENV RETRACKER_REAL_IP=true
ENV RETRACKER_OPTS=

RUN retracker -v

EXPOSE ${RETRACKER_PORT}

# Add image configuration and scripts
COPY docker-entrypoint.sh /usr/bin/docker-entrypoint.sh
RUN chmod 755 /usr/bin/docker-entrypoint.sh

RUN updatedb

ENTRYPOINT ["tini", "-s", "--", "docker-entrypoint.sh"]
CMD ["docker-entrypoint.sh"]
