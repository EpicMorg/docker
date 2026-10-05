FROM docker.io/epicmorg/perforce:r21.2
LABEL org.opencontainers.image.title="EpicMorg p4d"
LABEL org.opencontainers.image.description="Perforce Helix server (p4d) with a graceful 'p4 admin stop' on docker stop, checkpoint and db-upgrade helpers, by EpicMorg"
ARG DEBIAN_FRONTEND=noninteractive

# p4d defaults (the base image carries p4p ones, e.g. P4LOG=.../p4p.log)
ENV P4ROOT=/perforce/root
ENV P4JOURNAL=/perforce/journals/journal
ENV P4LOG=/perforce/logs/p4d.log
ENV P4PORT=1666
ENV P4BACKUPS=/perforce/backups
ENV P4STOP_TIMEOUT=120

# root = db.* (+ depots unless mapped elsewhere), journals, logs, archives (depot
# files when the depot Map points there), backups (checkpoints)
VOLUME ["/perforce/root", "/perforce/journals", "/perforce/logs", "/perforce/archives", "/perforce/backups"]
WORKDIR /perforce

EXPOSE 1666

COPY p4d-common.sh /usr/local/lib/p4d-common.sh
COPY docker-entrypoint.sh p4d-checkpoint p4d-upgrade /usr/local/bin/
RUN chmod +x /usr/local/bin/docker-entrypoint.sh /usr/local/bin/p4d-checkpoint /usr/local/bin/p4d-upgrade && \
    p4d -V | tail -1 && \
    p4 -V | tail -1

# docker stop -> SIGTERM to tini -> forwarded to the entrypoint, which runs
# `p4 admin stop`. Give it time: docker run --stop-timeout / compose stop_grace_period.
STOPSIGNAL SIGTERM
ENTRYPOINT ["tini", "-s", "--", "docker-entrypoint.sh"]
