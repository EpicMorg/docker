##################################################################
#                   Build retracker with the EpicMorg go toolchain
##################################################################
FROM ghcr.io/epicmorg/go:1.26 AS builder

ARG RETRACKER_VERSION=latest

# static binary: the final image needs neither the go toolchain nor a libc match
RUN set -eux; \
    export GOBIN=/tmp/retracker-bin CGO_ENABLED=0 GO111MODULE=on && \
    go install "github.com/vvampirius/retracker@${RETRACKER_VERSION}" && \
    /tmp/retracker-bin/retracker -v

##################################################################
#                   Final image
##################################################################
FROM ghcr.io/epicmorg/debian:trixie
LABEL org.opencontainers.image.title="EpicMorg retracker"
LABEL org.opencontainers.image.description="Simple HTTP torrent tracker (vvampirius/retracker)"

ENV RETRACKER_FOLDER=${EMG_LOCAL_BASE_DIR}/retracker
ENV RETRACKER_PORT=80
ENV RETRACKER_MINUTS=180
ENV RETRACKER_DEBUG=false
ENV RETRACKER_REAL_IP=true
ENV RETRACKER_OPTS=

ENV PATH="${RETRACKER_FOLDER}:${PATH}"

RUN mkdir -p ${RETRACKER_FOLDER}

COPY --from=builder /tmp/retracker-bin/retracker ${RETRACKER_FOLDER}/

RUN retracker -v && \
    command -v tini

EXPOSE ${RETRACKER_PORT}

# Add image configuration and scripts
COPY docker-entrypoint.sh /usr/bin/docker-entrypoint.sh
RUN chmod 755 /usr/bin/docker-entrypoint.sh

ENTRYPOINT ["tini", "-s", "--", "docker-entrypoint.sh"]
