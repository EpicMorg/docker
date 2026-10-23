FROM ghcr.io/epicmorg/perforce:r22.1
LABEL org.opencontainers.image.title="EpicMorg p4p"
LABEL org.opencontainers.image.description="Perforce Helix proxy (p4p) on Debian 13 trixie, one tag per release r16.2-r26.1"
ARG DEBIAN_FRONTEND=noninteractive

# cache = versioned file content (-r), root = the proxy's own db.* (-R, cache-fault
# coordination), logs; the base image leaves P4PROOT empty
ENV P4PROOT=/perforce/root
# proxy monitoring (p4p -v proxy.monitor.*), empty = off
ENV P4MONITOR_LEVEL=3
ENV P4MONITOR_INTERVAL=10
VOLUME /perforce/cache
VOLUME /perforce/root
VOLUME /perforce/logs
WORKDIR /perforce

EXPOSE 1666

COPY docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh
RUN chmod +x /usr/local/bin/docker-entrypoint.sh && \
    p4p -V | tail -1

ENTRYPOINT ["tini", "-s", "--", "docker-entrypoint.sh"]
