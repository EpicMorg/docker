<!-- hub-description: PostgreSQL 8.2-18 from PGDG on Debian trixie; 10+ with ~90 extensions, TimescaleDB -->
# `epicmorg/postgres`

PostgreSQL server images built from the official [PGDG apt repository](https://wiki.postgresql.org/wiki/Apt)
on our [`epicmorg/debian:trixie`](https://github.com/EpicMorg/docker/tree/master/linux/ecosystem/base/debian)
base. The entrypoint is the familiar one from the official `postgres` image, so the usual
`POSTGRES_*` variables and `/docker-entrypoint-initdb.d` work the same way.

## What's inside

* `postgresql-<major>` with `contrib` and `server-dev` from `apt.postgresql.org` (`trixie-pgdg`);
  binaries in `/usr/lib/postgresql/<major>/bin` (on `PATH`);
* **`10` ... `18`** additionally ship a large extension set from PGDG (about 90 packages), among them
  PostGIS 3, pgRouting, pgvector, `pg_cron`, `pg_partman`, `pg_repack`, `pglogical`, `wal2json`,
  `pgaudit`, `orafce`, `hypopg`, `pg_hint_plan`, `pg_stat_kcache`, `pg_qualstats`, PoWA,
  `mysql_fdw` / `oracle_fdw` / `tds_fdw`, PL/R, PL/Lua, PL/Java, PL/Python3, PL/Perl, PL/Tcl, and
  EDB's [`system_stats`](https://github.com/EnterpriseDB/system_stats) built from source;
* **`15` ... `18`** also include [TimescaleDB 2](https://www.timescale.com/) (`timescaledb-2-postgresql-<major>`);
* **`8.2` ... `9.6`** (museum majors) ship only the server, `contrib`, `server-dev` and client;
* [`pgloader`](https://pgloader.io/) in every tag;
* locale `en_US.UTF-8` (`LANG=en_US.utf8`), `listen_addresses='*'` in the sample config;
* `PGDATA=/var/lib/postgresql/data` (a `VOLUME`), port `5432`, `STOPSIGNAL SIGINT`,
  `tini` as PID 1, healthcheck `pg_isready`.

Extensions are installed, not enabled: add them to `shared_preload_libraries` where required and
run `CREATE EXTENSION` in your database.

## Tags

<!-- readme-sync:tags:begin -->
| Tags | Dockerfile |
| ---- | ---------- |
| `8.2` | [`8.2`](8.2/Dockerfile) |
| `8.3` | [`8.3`](8.3/Dockerfile) |
| `8.4` | [`8.4`](8.4/Dockerfile) |
| `9.0` | [`9.0`](9.0/Dockerfile) |
| `9.1` | [`9.1`](9.1/Dockerfile) |
| `9.2` | [`9.2`](9.2/Dockerfile) |
| `9.3` | [`9.3`](9.3/Dockerfile) |
| `9.4` | [`9.4`](9.4/Dockerfile) |
| `9.5` | [`9.5`](9.5/Dockerfile) |
| `9.6` | [`9.6`](9.6/Dockerfile) |
| `10` | [`10`](10/Dockerfile) |
| `11` | [`11`](11/Dockerfile) |
| `12` | [`12`](12/Dockerfile) |
| `13` | [`13`](13/Dockerfile) |
| `14` | [`14`](14/Dockerfile) |
| `15` | [`15`](15/Dockerfile) |
| `16` | [`16`](16/Dockerfile) |
| `17` | [`17`](17/Dockerfile) |
| `18`, `latest` | [`18`](18/Dockerfile) |

Every tag is pushed to `docker.io`, `quay.io` and `ghcr.io` (`epicmorg/postgres:<tag>` on each) - same digest everywhere.
<!-- readme-sync:tags:end -->

## Usage

```sh
docker run -d --name postgres \
  -e POSTGRES_PASSWORD=secret \
  -v pgdata:/var/lib/postgresql/data \
  -p 5432:5432 \
  epicmorg/postgres:17
```

Environment variables handled by the entrypoint (same semantics as the official image, `_FILE`
variants supported): `POSTGRES_PASSWORD`, `POSTGRES_USER`, `POSTGRES_DB`, `POSTGRES_INITDB_ARGS`,
`POSTGRES_INITDB_WALDIR`, `POSTGRES_HOST_AUTH_METHOD`. Scripts (`*.sh`, `*.sql`, `*.sql.gz`, `*.sql.xz`) in
`/docker-entrypoint-initdb.d` run on the first start with an empty data directory. See the
[official `postgres` image docs](https://hub.docker.com/_/postgres) for details.

## Notes

* Major upgrades need `pg_upgrade` or dump/restore - see
  [`epicmorg/pg-upgrade-tool`](https://github.com/EpicMorg/docker/tree/master/linux/ecosystem/apps/pg-upgrade-tool),
  which carries every major from `8.2` to `18` in one image.
* For HA clusters see [`epicmorg/postgres-patroni`](https://github.com/EpicMorg/docker/tree/master/linux/ecosystem/apps/postgres-patroni).

## Links

* Source: [EpicMorg/docker](https://github.com/EpicMorg/docker) - issues and PRs welcome
* Tags float and are rebuilt weekly; pin by digest for reproducible builds: [Tags, pinning and updates](https://github.com/EpicMorg/docker#tags-pinning-and-updates)
* [CHANGELOG](https://github.com/EpicMorg/docker/blob/master/CHANGELOG.md) - License: MIT
