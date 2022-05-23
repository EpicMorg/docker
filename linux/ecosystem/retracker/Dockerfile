FROM epicmorg/debian:bullseye-develop as builder

RUN go get -v github.com/vvampirius/retracker/...
RUN retracker -v

FROM  epicmorg/debian:bullseye
COPY --from=builder /go/bin/retracker /bin/retracker

ENV RETRACKER_PORT=80
ENV RETRACKER_MINUTS=180
ENV RETRACKER_DEBUG=false
ENV RETRACKER_REAL_IP=true

RUN retracker -v

EXPOSE ${RETRACKER_PORT}

ENTRYPOINT ["tini", "-s", "--", "docker-entrypoint.sh"]
CMD ["docker-entrypoint.sh"]
