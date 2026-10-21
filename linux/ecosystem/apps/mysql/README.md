<!-- hub-description: MySQL 5.6-26.x (Oracle generic binaries), drop-in for library/mysql and bitnami/mysql -->
# `epicmorg/mysql`

MySQL from Oracle's generic Linux tarballs (GPG signature checked with the MySQL Release Engineering keys) on
Debian 13 `trixie`, one tag per release line at its newest patch: the legacy `5.6` / `5.7`, `8.0`, the LTS lines
`8.4` and `9.7`, and the current Innovation release. The entrypoint is a **drop-in for `library/mysql`**
(`MYSQL_ROOT_PASSWORD` & co., `/var/lib/mysql`, `/etc/mysql/conf.d`, `/docker-entrypoint-initdb.d`, uid `999`) and
understands the **`bitnami/mysql`** variables too (`MYSQL_ROOT_USER`, `ALLOW_EMPTY_PASSWORD`, character set,
replication, `/bitnami/mysql`, `my_custom.cnf`). MySQL itself is not built from source (CMake + Boost, hours per
line); what is ours: the base, the libraries trixie lacks, the entrypoint and the fatal checks.

## What's inside

| Line | Tarball | TLS |
| ---- | ------- | --- |
| `26.10` (`26`, `innovation`, `latest`) | glibc2.28 minimal | MySQL's own OpenSSL 3 (`lib/private`) |
| `9.7` (`9`, `lts`) | glibc2.28 minimal | MySQL's own OpenSSL 3 |
| `8.4` (`8`) | glibc2.28 minimal | MySQL's own OpenSSL 3 |
| `8.0` | glibc2.28 (pruned) | MySQL's own OpenSSL 3 |
| `5.7` (`5`) | glibc2.12 (pruned) | linked in statically |
| `5.6` | glibc2.12 (pruned) | yaSSL, linked in statically |

* MySQL in `/usr/local/share/epicmorg/mysql/<line>` (also `/usr/local/mysql`), on `PATH`; the vendor's
  `lib/private` (OpenSSL, Kerberos, LDAP, SASL, protobuf of 8.0+) is used as shipped - one OpenSSL per process;
* baked here: `libaio` `0.3.113` (trixie only has `libaio.so.1t64`) for every line and ncurses `6.6` built with
  ABI 5 (`libncurses.so.5` / `libtinfo.so.5`) for the 5.x clients, wired into the vendor ELF files with
  `patchelf --force-rpath` (appended after their own `$ORIGIN/../lib/private`) - nothing in `ld.so.conf`;
* the test suite, debug / embedded binaries and static libraries are removed from the tarballs;
* `/emg-export` - MySQL + those libraries for `COPY --from`;
* entrypoint under `tini`; `mysqld` runs as `mysql` (uid `999`) when the container starts as root; volume
  `/var/lib/mysql`, ports `3306` / `33060`; `HEALTHCHECK` = `mysqladmin ping`.

Fatal build-time checks: server and client versions, no unresolved libraries anywhere in `bin/` / `lib/`, at most
one `libssl` per ELF and it is MySQL's own, `mysqld` uses the baked `libaio`, and a smoke test - first start with
root / database / user, time zone tables, a TLS session (5.7+), runs as `mysql`, restart on the persisted datadir,
the bitnami variables (`MYSQL_ROOT_USER`, character set and collation), refusal to initialise without a password
option.

## Variables

Read on the first start (empty datadir) unless noted.

| Variable | Meaning |
| -------- | ------- |
| `MYSQL_ROOT_PASSWORD` (`_FILE`) | root password (`root@localhost` and `root@MYSQL_ROOT_HOST`) |
| `MYSQL_ROOT_HOST` | host of the second root account (default `%`; `localhost` = none) |
| `MYSQL_ALLOW_EMPTY_PASSWORD` / `ALLOW_EMPTY_PASSWORD` | allow an empty root password |
| `MYSQL_RANDOM_ROOT_PASSWORD` | generate one (printed to the log) |
| `MYSQL_ONETIME_PASSWORD` | expire root's password after the first start (5.7+) |
| `MYSQL_DATABASE` / `MYSQL_USER` / `MYSQL_PASSWORD` (`_FILE`) | database, and a user with all privileges on it |
| `MYSQL_INITDB_SKIP_TZINFO` | do not load the time zone tables |
| `MYSQL_ROOT_USER` | bitnami: an extra `<user>@%` with all privileges and the root password |
| `MYSQL_CHARACTER_SET` / `MYSQL_COLLATE` | bitnami: `--character-set-server` / `--collation-server`, also for `MYSQL_DATABASE` |
| `MYSQL_AUTHENTICATION_PLUGIN` | bitnami: plugin of the created users (and the server default before 8.4) |
| `MYSQL_PORT_NUMBER` / `MYSQL_BIND_ADDRESS` / `MYSQL_SQL_MODE` | bitnami: `--port` / `--bind-address` / `--sql-mode` (every start) |
| `MYSQL_ENABLE_SLOW_QUERY` / `MYSQL_LONG_QUERY_TIME` | bitnami: slow query log (every start) |
| `MYSQL_EXTRA_FLAGS` | bitnami: extra `mysqld` flags (every start) |
| `MYSQL_REPLICATION_MODE` | bitnami: `master` / `slave` - server id, binlog, relay log, read-only |
| `MYSQL_REPLICATION_USER` / `_PASSWORD` | master: the replication account; slave: the account to replicate with |
| `MYSQL_MASTER_HOST` / `_PORT_NUMBER` / `_ROOT_USER` / `_ROOT_PASSWORD` / `_DELAY` | slave: the source |
| `MYSQL_UPGRADE` | bitnami: `AUTO` (default) / `FORCE` / `NONE` - `mysql_upgrade` when a 5.x / early 8.0 binary meets older data (8.0.16+ upgrade themselves) |

`/docker-entrypoint-initdb.d/*.sh` (sourced, or run when executable) and `*.sql`, `*.sql.gz`, `*.sql.bz2`,
`*.sql.xz`, `*.sql.zst` run once, against `MYSQL_DATABASE` when set. Arguments starting with `-` go to `mysqld`;
any other command (`mysql`, `mysqldump`, `bash`) runs as is. A mounted `/bitnami/mysql` becomes
`--datadir=/bitnami/mysql/data`; `/opt/bitnami/mysql/conf/my_custom.cnf` is included via `/etc/mysql/conf.d`.

## Tags

<!-- readme-sync:tags:begin -->
| Tags | Dockerfile |
| ---- | ---------- |
| `5.6`, `5.6.51` | [`5.6`](5.6/Dockerfile) |
| `5.7`, `5.7.44`, `5` | [`5.7`](5.7/Dockerfile) |
| `8.0`, `8.0.46` | [`8.0`](8.0/Dockerfile) |
| `8.4`, `8.4.13`, `8` | [`8.4`](8.4/Dockerfile) |
| `9.7`, `9.7.4`, `9`, `lts` | [`9.7`](9.7/Dockerfile) |
| `26.10`, `26.10.0`, `26`, `innovation`, `latest` | [`26.10`](26.10/Dockerfile) |

Every tag is pushed to `docker.io`, `quay.io` and `ghcr.io` (`epicmorg/mysql:<tag>` on each) - same digest everywhere.
<!-- readme-sync:tags:end -->

## Usage

```yaml
services:
  mysql:
    image: epicmorg/mysql:8.4          # was: mysql:8.4 - environment and volume unchanged
    restart: always
    environment:
      MYSQL_ROOT_PASSWORD_FILE: /run/secrets/mysql-root
      MYSQL_DATABASE: app
      MYSQL_USER: app
      MYSQL_PASSWORD_FILE: /run/secrets/mysql-app
    volumes:
      - ./mysql:/var/lib/mysql
      - ./initdb:/docker-entrypoint-initdb.d:ro
    secrets: [mysql-root, mysql-app]
secrets:
  mysql-root:
    file: ./mysql-root.txt
  mysql-app:
    file: ./mysql-app.txt
```

## Notes

* 5.6, 5.7 and 8.0 are end-of-life upstream; they are here for data that has to be read or migrated. Upgrade a
  datadir one line at a time (5.6 -> 5.7 -> 8.0 -> 8.4 -> 9.7).
* An Innovation release is supported until the next one; its tag moves with it, the old line is dropped.
* Licences: MySQL Community Server is GPLv2 (with the FOSS exception); the image recipe is MIT.

Folders are written by `bin/python/mysql-versions-sync.py`.

## Links

* Source: [EpicMorg/docker](https://github.com/EpicMorg/docker) - issues and PRs welcome
* Tags float and are rebuilt weekly; pin by digest for reproducible builds: [Tags, pinning and updates](https://github.com/EpicMorg/docker#tags-pinning-and-updates)
* [CHANGELOG](https://github.com/EpicMorg/docker/blob/master/CHANGELOG.md) - License: MIT
