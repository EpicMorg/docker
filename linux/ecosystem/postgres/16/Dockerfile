FROM epicmorg/debian:bookworm
LABEL maintainer="EpicMorg DevTeam, developer@epicm.org"
ARG DEBIAN_FRONTEND=noninteractive

####################################################################################################################################
# add our user and group first to make sure their IDs get assigned consistently, regardless of whatever dependencies get added
####################################################################################################################################

RUN groupadd -r postgres && useradd -m -r -g postgres -s /bin/bash postgres

####################################################################################################################################
# make the "en_US.UTF-8" locale so postgres will be utf-8 enabled by default
####################################################################################################################################

RUN apt-get update && apt-get install -y locales && rm -rf /var/lib/apt/lists/* \
    && localedef -i en_US -c -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8
ENV LANG en_US.utf8

####################################################################################################################################
# http://apt.postgresql.org/pub/repos/apt/pool/16/p/postgresql-16/
# https://docs.timescale.com/self-hosted/latest/upgrades/upgrade-pg/
####################################################################################################################################
ENV PG_MAJOR 16
ENV PG_STATS 2.1

RUN install -d /usr/share/postgresql-common/pgdg && \
    install -d /usr/share/timescaledb-common/gpg && \
    curl -o /usr/share/postgresql-common/pgdg/apt.postgresql.org.asc --fail https://www.postgresql.org/media/keys/ACCC4CF8.asc && \
    echo 'deb [signed-by=/usr/share/postgresql-common/pgdg/apt.postgresql.org.asc] http://apt.postgresql.org/pub/repos/apt/ bookworm-pgdg main' $PG_MAJOR > /etc/apt/sources.list.d/pgdg.list && \
    echo 'deb [signed-by=/usr/share/postgresql-common/pgdg/apt.postgresql.org.asc] http://apt.postgresql.org/pub/repos/apt/ bookworm-pgdg-snapshot main' $PG_MAJOR >> /etc/apt/sources.list.d/pgdg.list && \
    echo 'deb [signed-by=/usr/share/postgresql-common/pgdg/apt.postgresql.org.asc] http://apt.postgresql.org/pub/repos/apt/ bookworm-pgdg-testing main' $PG_MAJOR >> /etc/apt/sources.list.d/pgdg.listt && \
    curl -fsSL https://packagecloud.io/timescale/timescaledb/gpgkey | gpg --dearmor > /usr/share/timescaledb-common/gpg/apt.timescaledb.gpg && \
    echo 'deb [signed-by=/usr/share/timescaledb-common/gpg/apt.timescaledb.gpg] https://packagecloud.io/timescale/timescaledb/debian/ bookworm main' | sudo tee /etc/apt/sources.list.d/timescaledb.list 

RUN apt-get update \
    && apt-get install -y postgresql-common \
    && sed -ri 's/#(create_main_cluster) .*$/\1 = false/' /etc/postgresql-common/createcluster.conf \
    && apt-get install -y \
    postgresql-$PG_MAJOR \
    postgresql-server-dev-$PG_MAJOR \
    postgresql-contrib-$PG_MAJOR \
    postgresql-postgis \
    postgresql-postgis-scripts \
    postgresql-pljava-common \
    postgresql-pgrouting \
    postgresql-pgrouting-scripts \
    postgresql-comparator \
    postgresql-doc-$PG_MAJOR \
    postgresql-pltcl-$PG_MAJOR \
    postgresql-plpython3-$PG_MAJOR \
    postgresql-plperl-$PG_MAJOR \
    postgresql-$PG_MAJOR-wal2json \
    postgresql-$PG_MAJOR-unit \
    postgresql-$PG_MAJOR-toastinfo \
    postgresql-$PG_MAJOR-tds-fdw \
    postgresql-$PG_MAJOR-tdigest \
    postgresql-$PG_MAJOR-tablelog \
    postgresql-$PG_MAJOR-squeeze \
    postgresql-$PG_MAJOR-snakeoil \
    postgresql-$PG_MAJOR-slony1-2 \
    postgresql-$PG_MAJOR-similarity \
    postgresql-$PG_MAJOR-set-user \
    postgresql-$PG_MAJOR-semver \
    postgresql-$PG_MAJOR-rum \
    postgresql-$PG_MAJOR-roaringbitmap \
    postgresql-$PG_MAJOR-repmgr \
    postgresql-$PG_MAJOR-repack \
    postgresql-$PG_MAJOR-rdkit \
    postgresql-$PG_MAJOR-rational \
    postgresql-$PG_MAJOR-q3c \
    postgresql-$PG_MAJOR-prioritize \
    postgresql-$PG_MAJOR-preprepare \
    postgresql-$PG_MAJOR-prefix \
    postgresql-$PG_MAJOR-powa \
    postgresql-$PG_MAJOR-postgis-3-scripts \
    postgresql-$PG_MAJOR-postgis-3 \
    postgresql-$PG_MAJOR-pointcloud \
    postgresql-$PG_MAJOR-plsh \
    postgresql-$PG_MAJOR-plr \
    postgresql-$PG_MAJOR-plproxy \
    postgresql-$PG_MAJOR-plprofiler \
    postgresql-$PG_MAJOR-plpgsql-check \
    postgresql-$PG_MAJOR-pllua \
    postgresql-$PG_MAJOR-pljava \
    postgresql-$PG_MAJOR-pldebugger \
    postgresql-$PG_MAJOR-pgvector \
    postgresql-$PG_MAJOR-pgtap \
    postgresql-$PG_MAJOR-pgsphere \
    postgresql-$PG_MAJOR-pgrouting-scripts \
    postgresql-$PG_MAJOR-pgrouting-doc \
    postgresql-$PG_MAJOR-pgrouting \
    postgresql-$PG_MAJOR-pgq3 \
    postgresql-$PG_MAJOR-pgq-node \
    postgresql-$PG_MAJOR-pgpool2 \
    postgresql-$PG_MAJOR-pgpcre \
    postgresql-$PG_MAJOR-pgmp \
    postgresql-$PG_MAJOR-pgmemcache \
    postgresql-$PG_MAJOR-pglogical-ticker \
    postgresql-$PG_MAJOR-pglogical \
    postgresql-$PG_MAJOR-pgl-ddl-deploy \
    postgresql-$PG_MAJOR-pgfincore \
    postgresql-$PG_MAJOR-pgfaceting \
    postgresql-$PG_MAJOR-pgextwlist \
    postgresql-$PG_MAJOR-pgauditlogtofile \
    postgresql-$PG_MAJOR-pgaudit \
    postgresql-$PG_MAJOR-pg-wait-sampling \
    postgresql-$PG_MAJOR-pg-track-settings \
    postgresql-$PG_MAJOR-pg-stat-kcache \
    postgresql-$PG_MAJOR-pg-qualstats \
    postgresql-$PG_MAJOR-pg-hint-plan \
    postgresql-$PG_MAJOR-pg-failover-slots \
    postgresql-$PG_MAJOR-pg-fact-loader \
    postgresql-$PG_MAJOR-pg-checksums \
    postgresql-$PG_MAJOR-pg-catcheck \
    postgresql-$PG_MAJOR-periods \
    postgresql-$PG_MAJOR-partman \
    postgresql-$PG_MAJOR-orafce \
    postgresql-$PG_MAJOR-oracle-fdw \
    postgresql-$PG_MAJOR-omnidb \
    postgresql-$PG_MAJOR-numeral \
    postgresql-$PG_MAJOR-mysql-fdw \
#    postgresql-$PG_MAJOR-mobilitydb \
    postgresql-$PG_MAJOR-mimeo \
    postgresql-$PG_MAJOR-londiste-sql \
    postgresql-$PG_MAJOR-jsquery \
    postgresql-$PG_MAJOR-ip4r \
    postgresql-$PG_MAJOR-icu-ext \
    postgresql-$PG_MAJOR-hypopg \
    postgresql-$PG_MAJOR-http \
    postgresql-$PG_MAJOR-hll \
    postgresql-$PG_MAJOR-h3 \
    postgresql-$PG_MAJOR-first-last-agg \
    postgresql-$PG_MAJOR-extra-window-functions \
    postgresql-$PG_MAJOR-dirtyread \
    postgresql-$PG_MAJOR-decoderbufs \
    postgresql-$PG_MAJOR-debversion \
    postgresql-$PG_MAJOR-cron \
    postgresql-$PG_MAJOR-credcheck \
    postgresql-$PG_MAJOR-bgw-replstatus \
    postgresql-$PG_MAJOR-auto-failover \
    postgresql-$PG_MAJOR-asn1oid \
    postgresql-$PG_MAJOR-age \
    postgresql-client-8.2 \
    postgresql-client-8.3 \
    postgresql-client-8.4 \
    postgresql-client-9.0 \
    postgresql-client-9.1 \
    postgresql-client-9.2 \
    postgresql-client-9.3 \
    postgresql-client-9.4 \
    postgresql-client-9.5 \
    postgresql-client-9.6 \
    postgresql-client-10 \
    postgresql-client-11 \
    postgresql-client-12 \
    postgresql-client-13 \
    postgresql-client-14 \
    postgresql-client-15 \
    postgresql-client-16 \
    timescaledb-2-postgresql-$PG_MAJOR \
    && rm -rf /var/lib/apt/lists/*

RUN cd /tmp \
    && wget https://github.com/EnterpriseDB/system_stats/archive/refs/tags/v$PG_STATS.tar.gz \
    && tar -zxvf v$PG_STATS.tar.gz \
    && cd /tmp/system_stats-$PG_STATS \
    && PATH="/usr/lib/postgresql/$PG_MAJOR/bin:$PATH" make USE_PGXS=1 \
    && PATH="/usr/lib/postgresql/$PG_MAJOR/bin:$PATH" make install USE_PGXS=1 \
    && rm -rf /tmp/*


RUN mkdir /docker-entrypoint-initdb.d
RUN mkdir -p /var/run/postgresql && chown -R postgres /var/run/postgresql

ENV PATH /usr/lib/postgresql/$PG_MAJOR/bin:$PATH
ENV PGDATA /var/lib/postgresql/data
VOLUME /var/lib/postgresql/data
WORKDIR /var/lib/postgresql/data

#healthcheck. good practice
HEALTHCHECK --interval=3m --timeout=3s CMD pg_isready || exit 1

# Add image configuration and scripts
COPY docker-entrypoint.sh /usr/bin/docker-entrypoint.sh
RUN chmod 755 /usr/bin/docker-entrypoint.sh

RUN updatedb

ENTRYPOINT ["tini", "-s", "--", "docker-entrypoint.sh"]

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
