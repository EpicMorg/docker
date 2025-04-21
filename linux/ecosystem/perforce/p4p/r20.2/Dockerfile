FROM quay.io/epicmorg/perforce:r20.2
LABEL maintainer="EpicMorg DevTeam, developer@epicm.org"
ARG DEBIAN_FRONTEND=noninteractive

VOLUME /perforce/cache
VOLUME /perforce/logs
WORKDIR /perforce

EXPOSE 1666

ENTRYPOINT ["tini", "-s", "--", "docker-entrypoint.sh"]
CMD ["docker-entrypoint.sh"]
