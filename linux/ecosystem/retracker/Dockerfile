FROM epicmorg/debian:bullseye-develop as builder

RUN go get -v github.com/vvampirius/retracker/...
RUN retracker -v

FROM  epicmorg/debian:bullseye
COPY --from=builder /go/bin/retracker /bin/retracker

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

ENTRYPOINT ["tini", "-s", "--", "docker-entrypoint.sh"]
CMD ["docker-entrypoint.sh"]
