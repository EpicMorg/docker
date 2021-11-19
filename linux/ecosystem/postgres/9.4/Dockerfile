FROM epicmorg/edge
LABEL maintainer="EpicMorg DevTeam, developer@epicm.org"
ARG DEBIAN_FRONTEND=noninteractive

####################################################################################################################################
# add our user and group first to make sure their IDs get assigned consistently, regardless of whatever dependencies get added
####################################################################################################################################

RUN groupadd -r postgres && useradd -r -g postgres postgres

####################################################################################################################################
# grab gosu for easy step-down from root
####################################################################################################################################
ENV GOSU_VER 1.14

RUN apt-get update && apt-get install -y curl && rm -rf /var/lib/apt/lists/* \
    && curl -o /usr/local/bin/gosu -SL https://github.com/tianon/gosu/releases/download/$GOSU_VER/gosu-amd64 \
    && chmod +x /usr/local/bin/gosu \
    && apt-get purge -y --auto-remove curl

####################################################################################################################################
# make the "en_US.UTF-8" locale so postgres will be utf-8 enabled by default
####################################################################################################################################

RUN apt-get update && apt-get install -y locales && rm -rf /var/lib/apt/lists/* \
    && localedef -i en_US -c -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8
ENV LANG en_US.utf8

RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys B97B0AFCAA1A47F044F244A07FCC7D46ACCC4CF8

####################################################################################################################################
# http://apt.postgresql.org/pub/repos/apt/pool/9.4/p/postgresql-9.4/
####################################################################################################################################
ENV PG_MAJOR 9.4

RUN echo 'deb http://apt.postgresql.org/pub/repos/apt/ bullseye-pgdg main' $PG_MAJOR > /etc/apt/sources.list.d/pgdg.list && \
    echo 'deb http://apt.postgresql.org/pub/repos/apt/ bullseye-pgdg-testing main' $PG_MAJOR >> /etc/apt/sources.list.d/pgdg.list

RUN apt-get update \
    && apt-get install -y postgresql-common \
    && sed -ri 's/#(create_main_cluster) .*$/\1 = false/' /etc/postgresql-common/createcluster.conf \
    && apt-get install -y \
    postgresql-$PG_MAJOR \
    postgresql-contrib-$PG_MAJOR \
    && rm -rf /var/lib/apt/lists/*

RUN mkdir /docker-entrypoint-initdb.d
RUN mkdir -p /var/run/postgresql && chown -R postgres /var/run/postgresql

ENV PATH /usr/lib/postgresql/$PG_MAJOR/bin:$PATH
ENV PGDATA /var/lib/postgresql/data
VOLUME /var/lib/postgresql/data
WORKDIR /var/lib/postgresql/data

COPY ./docker-entrypoint.sh /

ENTRYPOINT ["/docker-entrypoint.sh"]

# We set the default STOPSIGNAL to SIGINT, which corresponds to what PostgreSQL
# calls "Fast Shutdown mode" wherein new connections are disallowed and any
# in-progress transactions are aborted, allowing PostgreSQL to stop cleanly and
# flush tables to disk, which is the best compromise available to avoid data
# corruption.
#
# Users who know their applications do not keep open long-lived idle connections
# may way to use a value of SIGTERM instead, which corresponds to "Smart
# Shutdown mode" in which any existing sessions are allowed to finish and the
# server stops when all sessions are terminated.
#
# See https://www.postgresql.org/docs/12/server-shutdown.html for more details
# about available PostgreSQL server shutdown signals.
#
# See also https://www.postgresql.org/docs/12/server-start.html for further
# justification of this as the default value, namely that the example (and
# shipped) systemd service files use the "Fast Shutdown mode" for service
# termination.
#
STOPSIGNAL SIGINT
#
# An additional setting that is recommended for all users regardless of this
# value is the runtime "--stop-timeout" (or your orchestrator/runtime's
# equivalent) for controlling how long to wait between sending the defined
# STOPSIGNAL and sending SIGKILL (which is likely to cause data corruption).
#
# The default in most runtimes (such as Docker) is 10 seconds, and the
# documentation at https://www.postgresql.org/docs/12/server-start.html notes
# that even 90 seconds may not be long enough in many instances.

EXPOSE 5432
CMD ["postgres"]
