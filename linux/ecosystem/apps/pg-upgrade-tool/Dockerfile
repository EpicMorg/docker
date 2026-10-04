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
COPY etc/apt/sources.list.d/pgdg.sources /etc/apt/sources.list.d/pgdg.sources
COPY etc/apt/sources.list.d/timescaledb.sources /etc/apt/sources.list.d/timescaledb.sources
COPY usr/share/postgresql-common/pgdg/apt.postgresql.org.asc /usr/share/postgresql-common/pgdg/apt.postgresql.org.asc
COPY usr/share/timescaledb-common/gpg/apt.timescaledb.gpg /usr/share/timescaledb-common/gpg/apt.timescaledb.gpg

RUN apt-get update \
    && apt-get install -y \
    postgresql-8.2 \
    postgresql-server-dev-8.2 \
    postgresql-contrib-8.2 \
    postgresql-client-8.2 \
    postgresql-8.3 \
    postgresql-server-dev-8.3 \
    postgresql-contrib-8.3 \
    postgresql-client-8.3 \
    postgresql-8.4 \
    postgresql-server-dev-8.4 \
    postgresql-contrib-8.4 \
    postgresql-client-8.4 \
    postgresql-9.0 \
    postgresql-server-dev-9.0 \
    postgresql-contrib-9.0 \
    postgresql-client-9.0 \
    postgresql-9.1 \
    postgresql-server-dev-9.1 \
    postgresql-contrib-9.1 \
    postgresql-client-9.1 \
    postgresql-9.2 \
    postgresql-server-dev-9.2 \
    postgresql-contrib-9.2 \
    postgresql-client-9.2 \
    postgresql-9.3 \
    postgresql-server-dev-9.3 \
    postgresql-contrib-9.3 \
    postgresql-client-9.3 \
    postgresql-9.4 \
    postgresql-server-dev-9.4 \
    postgresql-contrib-9.4 \
    postgresql-client-9.4 \
    postgresql-9.5 \
    postgresql-server-dev-9.5 \
    postgresql-contrib-9.5 \
    postgresql-client-9.5 \
    postgresql-9.6 \
    postgresql-server-dev-9.6 \
    postgresql-contrib-9.6 \
    postgresql-client-9.6 \
    postgresql-10 \
    postgresql-server-dev-10 \
    postgresql-contrib-10 \
    postgresql-doc-10 \
    postgresql-pltcl-10 \
    postgresql-plpython3-10 \
    postgresql-plperl-10 \
    postgresql-10-wal2json \
    postgresql-10-unit \
    postgresql-10-toastinfo \
    postgresql-10-tds-fdw \
    postgresql-10-tdigest \
    postgresql-10-tablelog \
    postgresql-10-snakeoil \
    postgresql-10-slony1-2 \
    postgresql-10-similarity \
    postgresql-10-set-user \
    postgresql-10-semver \
    postgresql-10-roaringbitmap \
    postgresql-10-repmgr \
    postgresql-10-repack \
    postgresql-10-rdkit \
    postgresql-10-q3c \
    postgresql-10-prioritize \
    postgresql-10-preprepare \
    postgresql-10-prefix \
    postgresql-10-powa \
    postgresql-10-pointcloud \
    postgresql-10-plsh \
    postgresql-10-plr \
    postgresql-10-plproxy \
    postgresql-10-plprofiler \
    postgresql-10-plpgsql-check \
    postgresql-10-pllua \
    postgresql-10-pljava \
    postgresql-10-pldebugger \
    postgresql-10-pgtap \
    postgresql-10-pgsphere \
    postgresql-10-pgq3 \
    postgresql-10-pgq-node \
    postgresql-10-pgpool2 \
    postgresql-10-pgpcre \
    postgresql-10-pgmp \
    postgresql-10-pgmemcache \
    postgresql-10-pglogical-ticker \
    postgresql-10-pglogical \
    postgresql-10-pgl-ddl-deploy \
    postgresql-10-pgfincore \
    postgresql-10-pgextwlist \
    postgresql-10-pgauditlogtofile \
    postgresql-10-pgaudit \
    postgresql-10-pg-wait-sampling \
    postgresql-10-pg-track-settings \
    postgresql-10-pg-stat-kcache \
    postgresql-10-pg-qualstats \
    postgresql-10-pg-fact-loader \
    postgresql-10-pg-checksums \
    postgresql-10-pg-catcheck \
    postgresql-10-periods \
    postgresql-10-partman \
    postgresql-10-oracle-fdw \
    postgresql-10-omnidb \
    postgresql-10-numeral \
    postgresql-10-mimeo \
    postgresql-10-londiste-sql \
    postgresql-10-jsquery \
    postgresql-10-ip4r \
    postgresql-10-hypopg \
    postgresql-10-http \
    postgresql-10-hll \
    postgresql-10-first-last-agg \
    postgresql-10-extra-window-functions \
    postgresql-10-dirtyread \
    postgresql-10-decoderbufs \
    postgresql-10-cron \
    postgresql-10-bgw-replstatus \
    postgresql-10-asn1oid \
    postgresql-client-10 \
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
    postgresql-client-11 \
    postgresql-12 \
    postgresql-server-dev-12 \
    postgresql-contrib-12 \
    postgresql-doc-12 \
    postgresql-pltcl-12 \
    postgresql-plpython3-12 \
    postgresql-plperl-12 \
    postgresql-12-wal2json \
    postgresql-12-unit \
    postgresql-12-toastinfo \
    postgresql-12-tds-fdw \
    postgresql-12-tdigest \
    postgresql-12-tablelog \
    postgresql-12-squeeze \
    postgresql-12-snakeoil \
    postgresql-12-slony1-2 \
    postgresql-12-similarity \
    postgresql-12-set-user \
    postgresql-12-semver \
    postgresql-12-rum \
    postgresql-12-roaringbitmap \
    postgresql-12-repmgr \
    postgresql-12-repack \
    postgresql-12-rdkit \
    postgresql-12-rational \
    postgresql-12-q3c \
    postgresql-12-prioritize \
    postgresql-12-preprepare \
    postgresql-12-prefix \
    postgresql-12-powa \
    postgresql-12-postgis-3-scripts \
    postgresql-12-postgis-3 \
    postgresql-12-pointcloud \
    postgresql-12-plsh \
    postgresql-12-plr \
    postgresql-12-plproxy \
    postgresql-12-plprofiler \
    postgresql-12-plpgsql-check \
    postgresql-12-pllua \
    postgresql-12-pljava \
    postgresql-12-pldebugger \
    postgresql-12-pgvector \
    postgresql-12-pgtap \
    postgresql-12-pgsphere \
    postgresql-12-pgrouting-scripts \
    postgresql-12-pgrouting-doc \
    postgresql-12-pgrouting \
    postgresql-12-pgq3 \
    postgresql-12-pgq-node \
    postgresql-12-pgpool2 \
    postgresql-12-pgpcre \
    postgresql-12-pgmp \
    postgresql-12-pgmemcache \
    postgresql-12-pglogical-ticker \
    postgresql-12-pglogical \
    postgresql-12-pgl-ddl-deploy \
    postgresql-12-pgfincore \
    postgresql-12-pgextwlist \
    postgresql-12-pgauditlogtofile \
    postgresql-12-pgaudit \
    postgresql-12-pg-wait-sampling \
    postgresql-12-pg-track-settings \
    postgresql-12-pg-stat-kcache \
    postgresql-12-pg-qualstats \
    postgresql-12-pg-hint-plan \
    postgresql-12-pg-failover-slots \
    postgresql-12-pg-fact-loader \
    postgresql-12-pg-checksums \
    postgresql-12-pg-catcheck \
    postgresql-12-periods \
    postgresql-12-partman \
    postgresql-12-orafce \
    postgresql-12-oracle-fdw \
    postgresql-12-omnidb \
    postgresql-12-numeral \
    postgresql-12-mysql-fdw \
    postgresql-12-mobilitydb \
    postgresql-12-mimeo \
    postgresql-12-londiste-sql \
    postgresql-12-jsquery \
    postgresql-12-ip4r \
    postgresql-12-icu-ext \
    postgresql-12-hypopg \
    postgresql-12-http \
    postgresql-12-hll \
    postgresql-12-h3 \
    postgresql-12-first-last-agg \
    postgresql-12-extra-window-functions \
    postgresql-12-dirtyread \
    postgresql-12-decoderbufs \
    postgresql-12-debversion \
    postgresql-12-cron \
    postgresql-12-credcheck \
    postgresql-12-bgw-replstatus \
    postgresql-12-auto-failover \
    postgresql-12-asn1oid \
    postgresql-12-age \
    postgresql-client-12 \
    postgresql-13 \
    postgresql-server-dev-13 \
    postgresql-contrib-13 \
    postgresql-doc-13 \
    postgresql-pltcl-13 \
    postgresql-plpython3-13 \
    postgresql-plperl-13 \
    postgresql-13-wal2json \
    postgresql-13-unit \
    postgresql-13-toastinfo \
    postgresql-13-tds-fdw \
    postgresql-13-tdigest \
    postgresql-13-tablelog \
    postgresql-13-squeeze \
    postgresql-13-snakeoil \
    postgresql-13-slony1-2 \
    postgresql-13-similarity \
    postgresql-13-set-user \
    postgresql-13-semver \
    postgresql-13-rum \
    postgresql-13-roaringbitmap \
    postgresql-13-repmgr \
    postgresql-13-repack \
    postgresql-13-rdkit \
    postgresql-13-rational \
    postgresql-13-q3c \
    postgresql-13-prioritize \
    postgresql-13-preprepare \
    postgresql-13-prefix \
    postgresql-13-powa \
    postgresql-13-postgis-3-scripts \
    postgresql-13-postgis-3 \
    postgresql-13-pointcloud \
    postgresql-13-plsh \
    postgresql-13-plr \
    postgresql-13-plproxy \
    postgresql-13-plprofiler \
    postgresql-13-plpgsql-check \
    postgresql-13-pllua \
    postgresql-13-pljava \
    postgresql-13-pldebugger \
    postgresql-13-pgvector \
    postgresql-13-pgtap \
    postgresql-13-pgsphere \
    postgresql-13-pgrouting-scripts \
    postgresql-13-pgrouting-doc \
    postgresql-13-pgrouting \
    postgresql-13-pgq3 \
    postgresql-13-pgq-node \
    postgresql-13-pgpool2 \
    postgresql-13-pgpcre \
    postgresql-13-pgmp \
    postgresql-13-pgmemcache \
    postgresql-13-pglogical-ticker \
    postgresql-13-pglogical \
    postgresql-13-pgl-ddl-deploy \
    postgresql-13-pgfincore \
    postgresql-13-pgextwlist \
    postgresql-13-pgauditlogtofile \
    postgresql-13-pgaudit \
    postgresql-13-pg-wait-sampling \
    postgresql-13-pg-track-settings \
    postgresql-13-pg-stat-kcache \
    postgresql-13-pg-qualstats \
    postgresql-13-pg-hint-plan \
    postgresql-13-pg-failover-slots \
    postgresql-13-pg-fact-loader \
    postgresql-13-pg-checksums \
    postgresql-13-pg-catcheck \
    postgresql-13-periods \
    postgresql-13-partman \
    postgresql-13-orafce \
    postgresql-13-oracle-fdw \
    postgresql-13-omnidb \
    postgresql-13-numeral \
    postgresql-13-mysql-fdw \
    postgresql-13-mobilitydb \
    postgresql-13-mimeo \
    postgresql-13-londiste-sql \
    postgresql-13-jsquery \
    postgresql-13-ip4r \
    postgresql-13-icu-ext \
    postgresql-13-hypopg \
    postgresql-13-http \
    postgresql-13-hll \
    postgresql-13-h3 \
    postgresql-13-first-last-agg \
    postgresql-13-extra-window-functions \
    postgresql-13-dirtyread \
    postgresql-13-decoderbufs \
    postgresql-13-debversion \
    postgresql-13-cron \
    postgresql-13-credcheck \
    postgresql-13-bgw-replstatus \
    postgresql-13-auto-failover \
    postgresql-13-asn1oid \
    postgresql-13-age \
    postgresql-client-13 \
    postgresql-14 \
    postgresql-server-dev-14 \
    postgresql-contrib-14 \
    postgresql-doc-14 \
    postgresql-pltcl-14 \
    postgresql-plpython3-14 \
    postgresql-plperl-14 \
    postgresql-14-wal2json \
    postgresql-14-unit \
    postgresql-14-toastinfo \
    postgresql-14-tds-fdw \
    postgresql-14-tdigest \
    postgresql-14-tablelog \
    postgresql-14-squeeze \
    postgresql-14-snakeoil \
    postgresql-14-slony1-2 \
    postgresql-14-similarity \
    postgresql-14-set-user \
    postgresql-14-semver \
    postgresql-14-rum \
    postgresql-14-roaringbitmap \
    postgresql-14-repmgr \
    postgresql-14-repack \
    postgresql-14-rdkit \
    postgresql-14-rational \
    postgresql-14-q3c \
    postgresql-14-prioritize \
    postgresql-14-preprepare \
    postgresql-14-prefix \
    postgresql-14-powa \
    postgresql-14-postgis-3-scripts \
    postgresql-14-postgis-3 \
    postgresql-14-pointcloud \
    postgresql-14-plsh \
    postgresql-14-plr \
    postgresql-14-plproxy \
    postgresql-14-plprofiler \
    postgresql-14-plpgsql-check \
    postgresql-14-pllua \
    postgresql-14-pljava \
    postgresql-14-pldebugger \
    postgresql-14-pgvector \
    postgresql-14-pgtap \
    postgresql-14-pgsphere \
    postgresql-14-pgrouting-scripts \
    postgresql-14-pgrouting-doc \
    postgresql-14-pgrouting \
    postgresql-14-pgq3 \
    postgresql-14-pgq-node \
    postgresql-14-pgpool2 \
    postgresql-14-pgpcre \
    postgresql-14-pgmp \
    postgresql-14-pgmemcache \
    postgresql-14-pglogical-ticker \
    postgresql-14-pglogical \
    postgresql-14-pgl-ddl-deploy \
    postgresql-14-pgfincore \
    postgresql-14-pgfaceting \
    postgresql-14-pgextwlist \
    postgresql-14-pgauditlogtofile \
    postgresql-14-pgaudit \
    postgresql-14-pg-wait-sampling \
    postgresql-14-pg-track-settings \
    postgresql-14-pg-stat-kcache \
    postgresql-14-pg-qualstats \
    postgresql-14-pg-hint-plan \
    postgresql-14-pg-failover-slots \
    postgresql-14-pg-fact-loader \
    postgresql-14-pg-checksums \
    postgresql-14-pg-catcheck \
    postgresql-14-periods \
    postgresql-14-partman \
    postgresql-14-orafce \
    postgresql-14-oracle-fdw \
    postgresql-14-omnidb \
    postgresql-14-numeral \
    postgresql-14-mysql-fdw \
    postgresql-14-mimeo \
    postgresql-14-londiste-sql \
    postgresql-14-jsquery \
    postgresql-14-ip4r \
    postgresql-14-icu-ext \
    postgresql-14-hypopg \
    postgresql-14-http \
    postgresql-14-hll \
    postgresql-14-h3 \
    postgresql-14-first-last-agg \
    postgresql-14-extra-window-functions \
    postgresql-14-dirtyread \
    postgresql-14-decoderbufs \
    postgresql-14-debversion \
    postgresql-14-cron \
    postgresql-14-credcheck \
    postgresql-14-bgw-replstatus \
    postgresql-14-auto-failover \
    postgresql-14-asn1oid \
    postgresql-14-age \
    postgresql-client-14 \
    postgresql-15 \
    postgresql-server-dev-15 \
    postgresql-contrib-15 \
    postgresql-doc-15 \
    postgresql-pltcl-15 \
    postgresql-plpython3-15 \
    postgresql-plperl-15 \
    postgresql-15-wal2json \
    postgresql-15-unit \
    postgresql-15-toastinfo \
    postgresql-15-tds-fdw \
    postgresql-15-tdigest \
    postgresql-15-tablelog \
    postgresql-15-squeeze \
    postgresql-15-snakeoil \
    postgresql-15-slony1-2 \
    postgresql-15-similarity \
    postgresql-15-set-user \
    postgresql-15-semver \
    postgresql-15-rum \
    postgresql-15-roaringbitmap \
    postgresql-15-repmgr \
    postgresql-15-repack \
    postgresql-15-rdkit \
    postgresql-15-rational \
    postgresql-15-q3c \
    postgresql-15-prioritize \
    postgresql-15-preprepare \
    postgresql-15-prefix \
    postgresql-15-powa \
    postgresql-15-postgis-3-scripts \
    postgresql-15-postgis-3 \
    postgresql-15-pointcloud \
    postgresql-15-plsh \
    postgresql-15-plr \
    postgresql-15-plproxy \
    postgresql-15-plprofiler \
    postgresql-15-plpgsql-check \
    postgresql-15-pllua \
    postgresql-15-pljava \
    postgresql-15-pldebugger \
    postgresql-15-pgvector \
    postgresql-15-pgtap \
    postgresql-15-pgsphere \
    postgresql-15-pgrouting-scripts \
    postgresql-15-pgrouting-doc \
    postgresql-15-pgrouting \
    postgresql-15-pgq3 \
    postgresql-15-pgq-node \
    postgresql-15-pgpool2 \
    postgresql-15-pgpcre \
    postgresql-15-pgmp \
    postgresql-15-pgmemcache \
    postgresql-15-pglogical-ticker \
    postgresql-15-pglogical \
    postgresql-15-pgl-ddl-deploy \
    postgresql-15-pgfincore \
    postgresql-15-pgfaceting \
    postgresql-15-pgextwlist \
    postgresql-15-pgauditlogtofile \
    postgresql-15-pgaudit \
    postgresql-15-pg-wait-sampling \
    postgresql-15-pg-track-settings \
    postgresql-15-pg-stat-kcache \
    postgresql-15-pg-qualstats \
    postgresql-15-pg-hint-plan \
    postgresql-15-pg-failover-slots \
    postgresql-15-pg-fact-loader \
    postgresql-15-pg-checksums \
    postgresql-15-pg-catcheck \
    postgresql-15-periods \
    postgresql-15-partman \
    postgresql-15-orafce \
    postgresql-15-oracle-fdw \
    postgresql-15-omnidb \
    postgresql-15-numeral \
    postgresql-15-mysql-fdw \
    postgresql-15-mobilitydb \
    postgresql-15-mimeo \
    postgresql-15-londiste-sql \
    postgresql-15-jsquery \
    postgresql-15-ip4r \
    postgresql-15-icu-ext \
    postgresql-15-hypopg \
    postgresql-15-http \
    postgresql-15-hll \
    postgresql-15-h3 \
    postgresql-15-first-last-agg \
    postgresql-15-extra-window-functions \
    postgresql-15-dirtyread \
    postgresql-15-decoderbufs \
    postgresql-15-debversion \
    postgresql-15-cron \
    postgresql-15-credcheck \
    postgresql-15-bgw-replstatus \
    postgresql-15-auto-failover \
    postgresql-15-asn1oid \
    postgresql-15-age \
    postgresql-client-15 \
    timescaledb-2-postgresql-15 \
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
    postgresql-17 \
    postgresql-server-dev-17 \
    postgresql-contrib-17 \
    postgresql-doc-17 \
    postgresql-pltcl-17 \
    postgresql-plpython3-17 \
    postgresql-plperl-17 \
    postgresql-17-wal2json \
    postgresql-17-unit \
    postgresql-17-toastinfo \
    postgresql-17-tds-fdw \
    postgresql-17-tdigest \
    postgresql-17-tablelog \
    postgresql-17-squeeze \
    postgresql-17-snakeoil \
    postgresql-17-slony1-2 \
    postgresql-17-similarity \
    postgresql-17-set-user \
    postgresql-17-semver \
    postgresql-17-rum \
    postgresql-17-roaringbitmap \
    postgresql-17-repack \
    postgresql-17-rational \
    postgresql-17-q3c \
    postgresql-17-prioritize \
    postgresql-17-preprepare \
    postgresql-17-prefix \
    postgresql-17-powa \
    postgresql-17-postgis-3-scripts \
    postgresql-17-postgis-3 \
    postgresql-17-pointcloud \
    postgresql-17-plsh \
    postgresql-17-plr \
    postgresql-17-plproxy \
    postgresql-17-plprofiler \
    postgresql-17-plpgsql-check \
    postgresql-17-pllua \
    postgresql-17-pljava \
    postgresql-17-pldebugger \
    postgresql-17-pgvector \
    postgresql-17-pgtap \
    postgresql-17-pgsphere \
    postgresql-17-pgrouting-scripts \
    postgresql-17-pgrouting-doc \
    postgresql-17-pgrouting \
    postgresql-17-pgq3 \
    postgresql-17-pgq-node \
    postgresql-17-pgpool2 \
    postgresql-17-pgpcre \
    postgresql-17-pgmp \
    postgresql-17-pgmemcache \
    postgresql-17-pglogical-ticker \
    postgresql-17-pglogical \
    postgresql-17-pgl-ddl-deploy \
    postgresql-17-pgfincore \
    postgresql-17-pgfaceting \
    postgresql-17-pgextwlist \
    postgresql-17-pgauditlogtofile \
    postgresql-17-pgaudit \
    postgresql-17-pg-wait-sampling \
    postgresql-17-pg-track-settings \
    postgresql-17-pg-stat-kcache \
    postgresql-17-pg-qualstats \
    postgresql-17-pg-hint-plan \
    postgresql-17-pg-failover-slots \
    postgresql-17-pg-fact-loader \
    postgresql-17-pg-checksums \
    postgresql-17-pg-catcheck \
    postgresql-17-periods \
    postgresql-17-partman \
    postgresql-17-orafce \
    postgresql-17-oracle-fdw \
    postgresql-17-omnidb \
    postgresql-17-numeral \
    postgresql-17-mysql-fdw \
    postgresql-17-mimeo \
    postgresql-17-londiste-sql \
    postgresql-17-jsquery \
    postgresql-17-ip4r \
    postgresql-17-icu-ext \
    postgresql-17-hypopg \
    postgresql-17-http \
    postgresql-17-hll \
    postgresql-17-h3 \
    postgresql-17-first-last-agg \
    postgresql-17-extra-window-functions \
    postgresql-17-dirtyread \
    postgresql-17-decoderbufs \
    postgresql-17-debversion \
    postgresql-17-cron \
    postgresql-17-credcheck \
    postgresql-17-bgw-replstatus \
    postgresql-17-auto-failover \
    postgresql-17-asn1oid \
    postgresql-17-age \
    postgresql-client-17 \
    timescaledb-2-postgresql-17 \
    postgresql-18 \
    postgresql-server-dev-18 \
    postgresql-contrib-18 \
    postgresql-doc-18 \
    postgresql-pltcl-18 \
    postgresql-plpython3-18 \
    postgresql-plperl-18 \
    postgresql-18-asn1oid \
    postgresql-18-bgw-replstatus \
    postgresql-18-credcheck \
    postgresql-18-cron \
    postgresql-18-debversion \
    postgresql-18-decoderbufs \
    postgresql-18-dirtyread \
    postgresql-18-documentdb \
    postgresql-18-extra-window-functions \
    postgresql-18-first-last-agg \
    postgresql-18-h3 \
    postgresql-18-hll \
    postgresql-18-http \
    postgresql-18-hypopg \
    postgresql-18-icu-ext \
    postgresql-18-ip4r \
    postgresql-18-jit \
    postgresql-18-jsquery \
    postgresql-18-londiste-sql \
    postgresql-18-mimeo \
    postgresql-18-mobilitydb \
    postgresql-18-mongo-fdw \
    postgresql-18-mysql-fdw \
    postgresql-18-numeral \
    postgresql-18-ogr-fdw \
    postgresql-18-oracle-fdw \
    postgresql-18-orafce \
    postgresql-18-partman \
    postgresql-18-periods \
    postgresql-18-pg-catcheck \
    postgresql-18-pg-checksums \
    postgresql-18-pg-crash \
    postgresql-18-pg-failover-slots \
    postgresql-18-pg-gvm \
    postgresql-18-pg-hint-plan \
    postgresql-18-pg-permissions \
    postgresql-18-pg-qualstats \
    postgresql-18-pg-rewrite \
    postgresql-18-pg-rrule \
    postgresql-18-pg-stat-kcache \
    postgresql-18-pg-stat-plans \
    postgresql-18-pg-track-settings \
    postgresql-18-pg-wait-sampling \
    postgresql-18-pgaudit \
    postgresql-18-pgauditlogtofile \
    postgresql-18-pgextwlist \
    postgresql-18-pgfaceting \
    postgresql-18-pglogical \
    postgresql-18-pgmemcache \
    postgresql-18-pgmp \
    postgresql-18-pgnodemx \
    postgresql-18-pgpcre \
    postgresql-18-pgpool2 \
    postgresql-18-pgq-node \
    postgresql-18-pgq3 \
    postgresql-18-pgrouting \
    postgresql-18-pgrouting-scripts \
    postgresql-18-pgsentinel \
    postgresql-18-pgsphere \
    postgresql-18-pgtap \
    postgresql-18-pgtt \
    postgresql-18-pgvector \
    postgresql-18-pldebugger \
    postgresql-18-pljs \
    postgresql-18-pllua \
    postgresql-18-plpgsql-check \
    postgresql-18-plprofiler \
    postgresql-18-plproxy \
    postgresql-18-plr \
    postgresql-18-plsh \
    postgresql-18-pointcloud \
    postgresql-18-postgis-3 \
    postgresql-18-postgis-3-scripts \
    postgresql-18-powa \
    postgresql-18-prefix \
    postgresql-18-preprepare \
    postgresql-18-prioritize \
    postgresql-18-q3c \
    postgresql-18-rational \
    postgresql-18-rdkit \
    postgresql-18-repack \
    postgresql-18-repmgr \
    postgresql-18-roaringbitmap \
    postgresql-18-rum \
    postgresql-18-semver \
    postgresql-18-set-user \
    postgresql-18-show-plans \
    postgresql-18-similarity \
    postgresql-18-snakeoil \
    postgresql-18-squeeze \
    postgresql-18-statviz \
    postgresql-18-tablelog \
    postgresql-18-tdigest \
    postgresql-18-tds-fdw \
    postgresql-18-toastinfo \
    postgresql-18-unit \
    postgresql-18-wal2json \
    postgresql-client-18 \
    timescaledb-2-postgresql-18 \
    pgloader && \
    sed -ri 's/#(create_main_cluster) .*$/\1 = false/' /etc/postgresql-common/createcluster.conf && \
    apt-get clean -y && \
    apt-get clean all -y && \
    apt-get autoclean -y && \
    rm -rfv /var/lib/apt/lists/* && \
    rm -rfv /var/cache/apt/archives/*.deb && \
    rm -rfv /tmp/*    

ENV PG_STATS=4.1
RUN aria2c \
      --conf-path=/usr/local/share/epicmorg/aria2/config/aria2.conf \
      --user-agent="$(shuf -n 1 /usr/local/share/epicmorg/user-agents/user-agents.txt)" \
      -d /tmp \
      "https://github.com/EnterpriseDB/system_stats/archive/refs/tags/v${PG_STATS}.tar.gz" && \
    cd /tmp && \
    tar -zxvf system_stats-${PG_STATS}.tar.gz && \
    cd /tmp/system_stats-${PG_STATS} && \
    PATH="/usr/lib/postgresql/10/bin:$PATH" make USE_PGXS=1 && \
    PATH="/usr/lib/postgresql/10/bin:$PATH" make install USE_PGXS=1 && \
    cd /tmp && \
    rm -rf /tmp/system_stats-${PG_STATS} && \
    tar -zxvf system_stats-${PG_STATS}.tar.gz && \
    cd /tmp/system_stats-${PG_STATS} && \
    PATH="/usr/lib/postgresql/11/bin:$PATH" make USE_PGXS=1 && \
    PATH="/usr/lib/postgresql/11/bin:$PATH" make install USE_PGXS=1 && \
    cd /tmp && \
    rm -rf /tmp/system_stats-${PG_STATS} && \
    tar -zxvf system_stats-${PG_STATS}.tar.gz && \
    cd /tmp/system_stats-${PG_STATS} && \
    PATH="/usr/lib/postgresql/12/bin:$PATH" make USE_PGXS=1 && \
    PATH="/usr/lib/postgresql/12/bin:$PATH" make install USE_PGXS=1 && \
    cd /tmp && \
    rm -rf /tmp/system_stats-${PG_STATS} && \
    tar -zxvf system_stats-${PG_STATS}.tar.gz && \
    cd /tmp/system_stats-${PG_STATS} && \
    PATH="/usr/lib/postgresql/13/bin:$PATH" make USE_PGXS=1 && \
    PATH="/usr/lib/postgresql/13/bin:$PATH" make install USE_PGXS=1 && \
    cd /tmp && \
    rm -rf /tmp/system_stats-${PG_STATS} && \
    tar -zxvf system_stats-${PG_STATS}.tar.gz && \
    cd /tmp/system_stats-${PG_STATS} && \
    PATH="/usr/lib/postgresql/14/bin:$PATH" make USE_PGXS=1 && \
    PATH="/usr/lib/postgresql/14/bin:$PATH" make install USE_PGXS=1 && \
    cd /tmp && \
    rm -rf /tmp/system_stats-${PG_STATS} && \
    tar -zxvf system_stats-${PG_STATS}.tar.gz && \
    cd /tmp/system_stats-${PG_STATS} && \
    PATH="/usr/lib/postgresql/15/bin:$PATH" make USE_PGXS=1 && \
    PATH="/usr/lib/postgresql/15/bin:$PATH" make install USE_PGXS=1 && \
    cd /tmp && \
    rm -rf /tmp/system_stats-${PG_STATS} && \
    tar -zxvf system_stats-${PG_STATS}.tar.gz && \
    cd /tmp/system_stats-${PG_STATS} && \
    PATH="/usr/lib/postgresql/16/bin:$PATH" make USE_PGXS=1 && \
    PATH="/usr/lib/postgresql/16/bin:$PATH" make install USE_PGXS=1 && \
    cd /tmp && \
    rm -rf /tmp/system_stats-${PG_STATS} && \
    tar -zxvf system_stats-${PG_STATS}.tar.gz && \
    cd /tmp/system_stats-${PG_STATS} && \
    PATH="/usr/lib/postgresql/17/bin:$PATH" make USE_PGXS=1 && \
    PATH="/usr/lib/postgresql/17/bin:$PATH" make install USE_PGXS=1 && \
    cd /tmp && \
    rm -rf /tmp/system_stats-${PG_STATS} && \
    tar -zxvf system_stats-${PG_STATS}.tar.gz && \
    cd /tmp/system_stats-${PG_STATS} && \
    PATH="/usr/lib/postgresql/18/bin:$PATH" make USE_PGXS=1 && \
    PATH="/usr/lib/postgresql/18/bin:$PATH" make install USE_PGXS=1 && \
    rm -rf /tmp/ *

RUN mkdir -p /var/run/postgresql && \
    mkdir -p /var/lib/postgresql/8.2/data && \
    mkdir -p /var/lib/postgresql/8.3/data && \
    mkdir -p /var/lib/postgresql/8.4/data && \
    mkdir -p /var/lib/postgresql/9.0/data && \
    mkdir -p /var/lib/postgresql/9.1/data && \
    mkdir -p /var/lib/postgresql/9.2/data && \
    mkdir -p /var/lib/postgresql/9.3/data && \
    mkdir -p /var/lib/postgresql/9.4/data && \
    mkdir -p /var/lib/postgresql/9.5/data && \
    mkdir -p /var/lib/postgresql/9.6/data && \
    mkdir -p /var/lib/postgresql/10/data && \
    mkdir -p /var/lib/postgresql/11/data && \
    mkdir -p /var/lib/postgresql/12/data && \
    mkdir -p /var/lib/postgresql/13/data && \
    mkdir -p /var/lib/postgresql/14/data && \
    mkdir -p /var/lib/postgresql/15/data && \
    mkdir -p /var/lib/postgresql/16/data && \
    mkdir -p /var/lib/postgresql/17/data && \
    mkdir -p /var/lib/postgresql/18/data && \
    chown -R postgres:postgres /var/run/postgresql && \
    chown -R postgres:postgres /var/lib/postgresql

VOLUME [ '/var/lib/postgresql/8.2/data', \
         '/var/lib/postgresql/8.3/data', \
         '/var/lib/postgresql/8.4/data', \
         '/var/lib/postgresql/9.0/data', \
         '/var/lib/postgresql/9.1/data', \
         '/var/lib/postgresql/9.2/data', \
         '/var/lib/postgresql/9.3/data', \
         '/var/lib/postgresql/9.4/data', \
         '/var/lib/postgresql/9.5/data', \
         '/var/lib/postgresql/9.6/data', \
         '/var/lib/postgresql/10/data', \
         '/var/lib/postgresql/11/data', \
         '/var/lib/postgresql/12/data', \
         '/var/lib/postgresql/13/data', \
         '/var/lib/postgresql/14/data', \
         '/var/lib/postgresql/15/data', \
         '/var/lib/postgresql/16/data', \
         '/var/lib/postgresql/17/data', \
         '/var/lib/postgresql/18/data' ]

WORKDIR /var/lib/postgresql

CMD ["/bin/bash"]
