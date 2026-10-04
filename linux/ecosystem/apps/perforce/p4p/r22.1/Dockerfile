FROM docker.io/epicmorg/perforce:r22.1
LABEL maintainer="EpicMorg DevTeam, developer@epicm.org"
ARG DEBIAN_FRONTEND=noninteractive

VOLUME /perforce/cache
VOLUME /perforce/logs
WORKDIR /perforce

EXPOSE 1666

COPY docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh
RUN chmod +x /usr/local/bin/docker-entrypoint.sh && \
    p4p -V | tail -1

ENTRYPOINT ["tini", "-s", "--", "docker-entrypoint.sh"]
