FROM docker.io/epicmorg/debian:trixie

ARG DEBIAN_FRONTEND=noninteractive

####################################################################################################################################
# add our user and group first to make sure their IDs get assigned consistently, regardless of whatever dependencies get added
####################################################################################################################################

RUN groupadd -r postgres && useradd -m -r -g postgres -s /bin/bash postgres && \
    install -d /usr/share/postgresql-common/pgdg && \
    install -d /usr/share/timescaledb-common/gpg

####################################################################################################################################
# make the "en_US.UTF-8" locale so postgres will be utf-8 enabled by default
####################################################################################################################################

RUN apt-get update && apt-get install -y locales && rm -rf /var/lib/apt/lists/* \
    && localedef -i en_US -c -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8
ENV LANG=en_US.utf8

####################################################################################################################################
# https://docs.timescale.com/self-hosted/latest/upgrades/upgrade-pg/
##################################################################################################################################
COPY etc/apt/sources.list.d/pgdg11.sources /etc/apt/sources.list.d/pgdg11.sources
COPY etc/apt/sources.list.d/pgdg16.sources /etc/apt/sources.list.d/pgdg16.sources
COPY etc/apt/sources.list.d/timescaledb.sources /etc/apt/sources.list.d/timescaledb.sources
COPY usr/share/postgresql-common/pgdg/apt.postgresql.org.asc /usr/share/postgresql-common/pgdg/apt.postgresql.org.asc
COPY usr/share/timescaledb-common/gpg/apt.timescaledb.gpg /usr/share/timescaledb-common/gpg/apt.timescaledb.gpg

RUN apt-get update \
    && apt-get install -y \
    postgresql-11 \
    postgresql-server-dev-11 \
    postgresql-contrib-11 \
    postgresql-doc-11 \
    postgresql-pltcl-11 \
    postgresql-plpython3-11 \
    postgresql-plperl-11 \
    postgresql-11-wal2json \
    postgresql-11-unit \
    postgresql-11-toastinfo \
    postgresql-11-tds-fdw \
    postgresql-11-tdigest \
    postgresql-11-tablelog \
    postgresql-11-snakeoil \
    postgresql-11-slony1-2 \
    postgresql-11-similarity \
    postgresql-11-semver \
    postgresql-11-rum \
    postgresql-11-repmgr \
    postgresql-11-repack \
    postgresql-11-rdkit \
    postgresql-11-rational \
    postgresql-11-q3c \
    postgresql-11-prioritize \
    postgresql-11-preprepare \
    postgresql-11-prefix \
    postgresql-11-powa \
    postgresql-11-pointcloud \
    postgresql-11-plsh \
    postgresql-11-plr \
    postgresql-11-plproxy \
    postgresql-11-plprofiler \
    postgresql-11-pllua \
    postgresql-11-pljava \
    postgresql-11-pldebugger \
    postgresql-11-pgtap \
    postgresql-11-pgsphere \
    postgresql-11-pgrouting-scripts \
    postgresql-11-pgrouting-doc \
    postgresql-11-pgq3 \
    postgresql-11-pgq-node \
    postgresql-11-pgpool2 \
    postgresql-11-pgmemcache \
    postgresql-11-pglogical-ticker \
    postgresql-11-pglogical \
    postgresql-11-pgl-ddl-deploy \
    postgresql-11-pgfincore \
    postgresql-11-pgextwlist \
    postgresql-11-pgauditlogtofile \
    postgresql-11-pgaudit \
    postgresql-11-pg-track-settings \
    postgresql-11-pg-stat-kcache \
    postgresql-11-pg-qualstats \
    postgresql-11-pg-failover-slots \
    postgresql-11-pg-fact-loader \
    postgresql-11-pg-checksums \
    postgresql-11-pg-catcheck \
    postgresql-11-periods \
    postgresql-11-oracle-fdw \
    postgresql-11-omnidb \
    postgresql-11-numeral \
    postgresql-11-mimeo \
    postgresql-11-londiste-sql \
    postgresql-11-jsquery \
    postgresql-11-ip4r \
    postgresql-11-icu-ext \
    postgresql-11-hypopg \
    postgresql-11-hll \
    postgresql-11-first-last-agg \
    postgresql-11-extra-window-functions \
    postgresql-11-dirtyread \
    postgresql-11-decoderbufs \
    postgresql-11-cron \
    postgresql-11-bgw-replstatus \
    postgresql-11-auto-failover \
    postgresql-11-asn1oid \
    postgresql-client-11 && \
# cleanup
    apt-get clean -y && \
    apt-get clean all -y && \
    apt-get autoclean -y && \
    rm -rfv /var/lib/apt/lists/* && \
    rm -rfv /var/cache/apt/archives/*.deb && \
    rm -rfv /tmp/* 

RUN apt-get update \
    && apt-get install -y postgresql-common \
    && sed -ri 's/#(create_main_cluster) .*$/\1 = false/' /etc/postgresql-common/createcluster.conf \
    && apt-get install -y \
    postgresql-16 \
    postgresql-server-dev-16 \
    postgresql-contrib-16 \
    postgresql-doc-16 \
    postgresql-pltcl-16 \
    postgresql-plpython3-16 \
    postgresql-plperl-16 \
    postgresql-16-wal2json \
    postgresql-16-unit \
    postgresql-16-toastinfo \
    postgresql-16-tds-fdw \
    postgresql-16-tdigest \
    postgresql-16-tablelog \
    postgresql-16-squeeze \
    postgresql-16-snakeoil \
    postgresql-16-slony1-2 \
    postgresql-16-similarity \
    postgresql-16-set-user \
    postgresql-16-semver \
    postgresql-16-rum \
    postgresql-16-roaringbitmap \
    postgresql-16-repmgr \
    postgresql-16-repack \
    postgresql-16-rdkit \
    postgresql-16-rational \
    postgresql-16-q3c \
    postgresql-16-prioritize \
    postgresql-16-preprepare \
    postgresql-16-prefix \
    postgresql-16-powa \
    postgresql-16-postgis-3-scripts \
    postgresql-16-postgis-3 \
    postgresql-16-pointcloud \
    postgresql-16-plsh \
    postgresql-16-plr \
    postgresql-16-plproxy \
    postgresql-16-plprofiler \
    postgresql-16-plpgsql-check \
    postgresql-16-pllua \
    postgresql-16-pljava \
    postgresql-16-pldebugger \
    postgresql-16-pgvector \
    postgresql-16-pgtap \
    postgresql-16-pgsphere \
    postgresql-16-pgrouting-scripts \
    postgresql-16-pgrouting-doc \
    postgresql-16-pgrouting \
    postgresql-16-pgq3 \
    postgresql-16-pgq-node \
    postgresql-16-pgpool2 \
    postgresql-16-pgpcre \
    postgresql-16-pgmp \
    postgresql-16-pgmemcache \
    postgresql-16-pglogical-ticker \
    postgresql-16-pglogical \
    postgresql-16-pgl-ddl-deploy \
    postgresql-16-pgfincore \
    postgresql-16-pgfaceting \
    postgresql-16-pgextwlist \
    postgresql-16-pgauditlogtofile \
    postgresql-16-pgaudit \
    postgresql-16-pg-wait-sampling \
    postgresql-16-pg-track-settings \
    postgresql-16-pg-stat-kcache \
    postgresql-16-pg-qualstats \
    postgresql-16-pg-hint-plan \
    postgresql-16-pg-failover-slots \
    postgresql-16-pg-fact-loader \
    postgresql-16-pg-checksums \
    postgresql-16-pg-catcheck \
    postgresql-16-periods \
    postgresql-16-partman \
    postgresql-16-orafce \
    postgresql-16-oracle-fdw \
    postgresql-16-omnidb \
    postgresql-16-numeral \
    postgresql-16-mysql-fdw \
    postgresql-16-mimeo \
    postgresql-16-londiste-sql \
    postgresql-16-jsquery \
    postgresql-16-ip4r \
    postgresql-16-icu-ext \
    postgresql-16-hypopg \
    postgresql-16-http \
    postgresql-16-hll \
    postgresql-16-h3 \
    postgresql-16-first-last-agg \
    postgresql-16-extra-window-functions \
    postgresql-16-dirtyread \
    postgresql-16-decoderbufs \
    postgresql-16-debversion \
    postgresql-16-cron \
    postgresql-16-credcheck \
    postgresql-16-bgw-replstatus \
    postgresql-16-auto-failover \
    postgresql-16-asn1oid \
    postgresql-16-age \
    postgresql-client-16 \
    timescaledb-2-postgresql-16 \
    pgloader && \
# cleanup
    apt-get clean -y && \
    apt-get clean all -y && \
    apt-get autoclean -y && \
    rm -rfv /var/lib/apt/lists/* && \
    rm -rfv /var/cache/apt/archives/*.deb && \
    rm -rfv /tmp/*    

ENV PG_STATS=3.2

RUN cd /tmp \
    && wget https://github.com/EnterpriseDB/system_stats/archive/refs/tags/v$PG_STATS.tar.gz \
    && tar -zxvf v$PG_STATS.tar.gz \
    && cd /tmp/system_stats-$PG_STATS \
    && PATH="/usr/lib/postgresql/11/bin:$PATH" make USE_PGXS=1 \
    && PATH="/usr/lib/postgresql/11/bin:$PATH" make install USE_PGXS=1 \
    && rm -rf /tmp/*

RUN cd /tmp \
    && wget https://github.com/EnterpriseDB/system_stats/archive/refs/tags/v$PG_STATS.tar.gz \
    && tar -zxvf v$PG_STATS.tar.gz \
    && cd /tmp/system_stats-$PG_STATS \
    && PATH="/usr/lib/postgresql/16/bin:$PATH" make USE_PGXS=1 \
    && PATH="/usr/lib/postgresql/16/bin:$PATH" make install USE_PGXS=1 \
    && rm -rf /tmp/*

RUN mkdir -p /var/run/postgresql && chown -R postgres /var/run/postgresql
RUN mkdir -p /var/lib/postgresql/11/data && chown -R postgres:postgres /var/lib/postgresql/11
RUN mkdir -p /var/lib/postgresql/16/data && chown -R postgres:postgres /var/lib/postgresql/16

VOLUME /var/lib/postgresql/11/data
VOLUME /var/lib/postgresql/16/data

WORKDIR /var/lib/postgresql

CMD ["/bin/bash"]
