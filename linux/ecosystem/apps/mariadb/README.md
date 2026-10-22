<!-- hub-description: MariaDB 5.5-13.0 (project binaries), drop-in for library/mariadb and bitnami/mariadb -->
# `epicmorg/mariadb`

MariaDB from the project's bintar tarballs (archive.mariadb.org, GPG signature checked with the MariaDB signing keys)
on Debian 13 `trixie`, one tag per release line at its newest patch: the supported LTS lines `10.11`, `11.4`,
`11.8`, `12.3`, the rolling stable `13.0`, and the ended series `5.5`, `10.0` - `10.6` for data that has to be read or
migrated. The entrypoint is a **drop-in for `library/mariadb`** (`MARIADB_*` with the `MYSQL_*` aliases,
`/var/lib/mysql`, `/etc/mysql/conf.d`, `/docker-entrypoint-initdb.d`, uid `999`) and understands the
**`bitnami/mariadb`** variables too (`MARIADB_ROOT_USER`, `ALLOW_EMPTY_PASSWORD`, character set, replication,
`/bitnami/mariadb`, `my_custom.cnf`). MariaDB itself is not built from source; what is ours: the base, the libraries
trixie lacks, the entrypoint and the fatal checks.

## What's inside

| Line | Tags | Upstream |
| ---- | ---- | -------- |
| `13.0` | `13`, `latest` | rolling stable |
| `12.3` | `12`, `lts` | LTS |
| `11.8` | `11` | LTS |
| `11.4` | | LTS |
| `10.11` | `10` | LTS |
| `10.6`, `10.5`, `10.4`, `10.3`, `10.2`, `10.1`, `10.0` | | ended |
| `5.5` | `5` | ended |

* MariaDB in `/usr/local/share/epicmorg/mariadb/<line>` (also `/usr/local/mariadb`, `/usr/local/mysql`), on `PATH`;
  glibc_214 builds up to 10.4, systemd builds from 10.5; TLS is linked into the server statically;
* baked here: `libaio` `0.3.113` (trixie only has `libaio.so.1t64`) and ncurses `6.6` built with ABI 5
  (`libncurses.so.5` / `libtinfo.so.5`) for the clients up to 10.5, wired into the vendor ELF files with
  `patchelf --force-rpath` - nothing in `ld.so.conf`; Debian's `libcrack2` / `libodbc2` / Judy for the
  cracklib / CONNECT / OQGraph plugins;
* **Galera is not included** (its provider and `garbd` link OpenSSL 1.1 / Boost 1.66 - a second OpenSSL next to the
  server's own); the test suite, debug / embedded binaries and static libraries are removed too;
* `/emg-export` - MariaDB + those libraries for `COPY --from`;
* entrypoint under `tini`; the server runs as `mysql` (uid `999`) when the container starts as root; volume
  `/var/lib/mysql`, port `3306`; `HEALTHCHECK` = `mariadb-admin ping`.

Fatal build-time checks: server and client versions, no unresolved libraries anywhere in `bin/` / `lib/`, at most
one `libssl` per ELF, the server uses the baked `libaio`, and a smoke test - first start with root / database /
user, time zone tables, no anonymous accounts, a TLS session (11.4+, zero-configuration TLS), runs as `mysql`,
restart on the persisted datadir, the bitnami variables (`MARIADB_ROOT_USER`, character set and collation),
refusal to initialise without a password option.

## Variables

Every `MARIADB_*` name below also works as `MYSQL_*` (`MARIADB_*` wins). Read on the first start (empty datadir)
unless noted.

| Variable | Meaning |
| -------- | ------- |
| `MARIADB_ROOT_PASSWORD` (`_FILE`) | root password (`root@localhost` and `root@MARIADB_ROOT_HOST`) |
| `MARIADB_ROOT_HOST` | host of the second root account (default `%`; `localhost` = none) |
| `MARIADB_ALLOW_EMPTY_ROOT_PASSWORD` / `ALLOW_EMPTY_PASSWORD` | allow an empty root password |
| `MARIADB_RANDOM_ROOT_PASSWORD` | generate one (printed to the log) |
| `MARIADB_DATABASE` / `MARIADB_USER` / `MARIADB_PASSWORD` (`_FILE`) | database, and a user with all privileges on it |
| `MARIADB_INITDB_SKIP_TZINFO` | do not load the time zone tables |
| `MARIADB_AUTO_UPGRADE` | every start: `0` = do not upgrade the system tables of older data (default: upgrade, after a dump of the `mysql` schema to `system_mysql_backup_<old>.sql.zst` in the datadir) |
| `MARIADB_ROOT_USER` | bitnami: an extra `<user>@%` with all privileges and the root password |
| `MARIADB_CHARACTER_SET` / `MARIADB_COLLATE` | bitnami: `--character-set-server` / `--collation-server`, also for `MARIADB_DATABASE` |
| `MARIADB_PORT_NUMBER` / `MARIADB_BIND_ADDRESS` / `MARIADB_SQL_MODE` | bitnami: `--port` / `--bind-address` / `--sql-mode` (every start) |
| `MARIADB_ENABLE_SLOW_QUERY` / `MARIADB_LONG_QUERY_TIME` | bitnami: slow query log (every start) |
| `MARIADB_EXTRA_FLAGS` | bitnami: extra server flags (every start) |
| `MARIADB_REPLICATION_MODE` | bitnami: `master` / `slave` - server id, binlog, relay log, read-only |
| `MARIADB_REPLICATION_USER` / `_PASSWORD` | master: the replication account; slave: the account to replicate with |
| `MARIADB_MASTER_HOST` / `_PORT_NUMBER` / `_ROOT_USER` / `_ROOT_PASSWORD` / `_DELAY` | slave: the source |

`/docker-entrypoint-initdb.d/*.sh` (sourced, or run when executable) and `*.sql`, `*.sql.gz`, `*.sql.bz2`,
`*.sql.xz`, `*.sql.zst` run once, against `MARIADB_DATABASE` when set. Arguments starting with `-` go to the server;
any other command (`mariadb`, `mariadb-dump`, `bash`) runs as is. A mounted `/bitnami/mariadb` becomes
`--datadir=/bitnami/mariadb/data`; `/opt/bitnami/mariadb/conf/my_custom.cnf` is included via `/etc/mysql/conf.d`.

## Tags

<!-- readme-sync:tags:begin -->
| Tags | Dockerfile |
| ---- | ---------- |
| `5.5`, `5.5.68`, `5` | [`5.5`](5.5/Dockerfile) |
| `10.0`, `10.0.38` | [`10.0`](10.0/Dockerfile) |
| `10.1`, `10.1.48` | [`10.1`](10.1/Dockerfile) |
| `10.2`, `10.2.44` | [`10.2`](10.2/Dockerfile) |
| `10.3`, `10.3.39` | [`10.3`](10.3/Dockerfile) |
| `10.4`, `10.4.34` | [`10.4`](10.4/Dockerfile) |
| `10.5`, `10.5.29` | [`10.5`](10.5/Dockerfile) |
| `10.6`, `10.6.28` | [`10.6`](10.6/Dockerfile) |
| `10.11`, `10.11.19`, `10` | [`10.11`](10.11/Dockerfile) |
| `11.4`, `11.4.13` | [`11.4`](11.4/Dockerfile) |
| `11.8`, `11.8.9`, `11` | [`11.8`](11.8/Dockerfile) |
| `12.3`, `12.3.3`, `12`, `lts` | [`12.3`](12.3/Dockerfile) |
| `13.0`, `13.0.2`, `13`, `latest` | [`13.0`](13.0/Dockerfile) |

Every tag is pushed to `docker.io`, `quay.io` and `ghcr.io` (`epicmorg/mariadb:<tag>` on each) - same digest everywhere.
<!-- readme-sync:tags:end -->

## Usage

```yaml
services:
  mariadb:
    image: epicmorg/mariadb:11.8          # was: mariadb:11.8 - environment and volume unchanged
    restart: always
    environment:
      MARIADB_ROOT_PASSWORD_FILE: /run/secrets/mariadb-root
      MARIADB_DATABASE: app
      MARIADB_USER: app
      MARIADB_PASSWORD_FILE: /run/secrets/mariadb-app
    volumes:
      - ./mariadb:/var/lib/mysql
    secrets: [mariadb-root, mariadb-app]
secrets:
  mariadb-root:
    file: ./mariadb-root.txt
  mariadb-app:
    file: ./mariadb-app.txt
```

## Notes

* Upgrade a datadir one major series at a time (5.5 -> 10.0 -> ... -> 10.6 -> 10.11 -> 11.4 ...); the image upgrades
  the system tables itself (see `MARIADB_AUTO_UPGRADE`).
* Licences: MariaDB Server is GPLv2; the image recipe is MIT.

Folders are written by `bin/python/mariadb-versions-sync.py`.

## Links

* Source: [EpicMorg/docker](https://github.com/EpicMorg/docker) - issues and PRs welcome
* Tags float and are rebuilt weekly; pin by digest for reproducible builds: [Tags, pinning and updates](https://github.com/EpicMorg/docker#tags-pinning-and-updates)
* [CHANGELOG](https://github.com/EpicMorg/docker/blob/master/CHANGELOG.md) - License: MIT
