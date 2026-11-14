<!-- hub-description: pg_upgrade toolbox: PostgreSQL 8.2-18 binaries (with extensions) in one image -->
# `epicmorg/pg-upgrade-tool`

A one-shot toolbox for major PostgreSQL upgrades with `pg_upgrade`: every PostgreSQL major from
`8.2` to `18` (PGDG packages on `epicmorg/debian:trixie`) is installed side by side in
`/usr/lib/postgresql/<major>/bin`, together with the same extension set as
[`epicmorg/postgres`](https://github.com/EpicMorg/docker/tree/master/linux/ecosystem/apps/postgres)
(PostGIS, TimescaleDB, `system_stats`, ...) so that `pg_upgrade --check` finds the extensions on both
sides, plus `pgloader`.

## Usage

Example: upgrade an 11 cluster to 16.

### 0. Stop the old server cleanly

Stop the old container itself (`docker compose stop -t 120 postgres`), not `pg_ctl` inside it: with
`restart: always` the server comes straight back, and `pg_upgrade` needs a clean shutdown.

### 1. Start the toolbox

```sh
docker run --rm -it \
  -v /path/to/pgdata:/var/lib/postgresql/upgrade \
  -u postgres -w /tmp \
  epicmorg/pg-upgrade-tool:latest
```

with `/path/to/pgdata/11` (old cluster) and `/path/to/pgdata/16` (new, empty) on the host. One mount
holding both clusters matters for `--link` / `--clone`: across two bind mounts they fail with
`EXDEV`, only the default copy mode works. `-w /tmp`: `pg_upgrade` puts its sockets in the working
directory.

### 2. Initialise the new cluster with the old cluster's settings

`pg_upgrade --check` refuses a new cluster whose data checksums, encoding or locale differ from the
old one. Encoding and locale: `docker exec postgres psql -U postgres -l` before step 0; checksums:

```sh
/usr/lib/postgresql/11/bin/pg_controldata /var/lib/postgresql/upgrade/11 | grep -i checksum
```

and repeat them in `initdb` (`-k` when the old cluster has checksums; 18 enables them by default, so
there `--no-data-checksums` when it has none):

```sh
/usr/lib/postgresql/16/bin/initdb -D /var/lib/postgresql/upgrade/16 \
  -U postgres -E UTF8 --locale=en_US.UTF-8 -k -A scram-sha-256 --pwprompt
```

Alternative: start `epicmorg/postgres:16` once on the empty new directory with the same
`POSTGRES_INITDB_ARGS` (and user) as the old container, then stop it - same checksums / locale, and the
image's network `pg_hba.conf` instead of `initdb`'s local-only one.

### 3. (Optional) Check - if this passes, all extensions are in place

```sh
/usr/lib/postgresql/16/bin/pg_upgrade \
  -b /usr/lib/postgresql/11/bin \
  -B /usr/lib/postgresql/16/bin \
  -d /var/lib/postgresql/upgrade/11 \
  -D /var/lib/postgresql/upgrade/16 \
  --check
```

### 4. Upgrade

```sh
/usr/lib/postgresql/16/bin/pg_upgrade \
  -b /usr/lib/postgresql/11/bin \
  -B /usr/lib/postgresql/16/bin \
  -d /var/lib/postgresql/upgrade/11 \
  -D /var/lib/postgresql/upgrade/16
```

Default copy mode keeps the old cluster usable. `--link` (or `--clone` on a reflink filesystem) is much
faster but needs both clusters on one filesystem (step 1), and after `--link` the old cluster must not
be started again.

### 5. Post-upgrade, in the new `epicmorg/postgres:16` container

Copy your `postgresql.conf` / `pg_hba.conf` changes to the new cluster before starting it, then:

```sh
docker exec -d postgres-16 vacuumdb --all --analyze-in-stages -U postgres
```

## Tags

<!-- readme-sync:tags:begin -->
| Tags | Dockerfile |
| ---- | ---------- |
| `latest` | [`.`](./Dockerfile) |

Every tag is pushed to `docker.io`, `quay.io` and `ghcr.io` (`epicmorg/pg-upgrade-tool:<tag>` on each) - same digest everywhere.
<!-- readme-sync:tags:end -->

## Links

* Source: [EpicMorg/docker](https://github.com/EpicMorg/docker) - issues and PRs welcome
* Tags float and are rebuilt weekly; pin by digest for reproducible builds: [Tags, pinning and updates](https://github.com/EpicMorg/docker#tags-pinning-and-updates)
* [CHANGELOG](https://github.com/EpicMorg/docker/blob/master/CHANGELOG.md) - License: MIT
