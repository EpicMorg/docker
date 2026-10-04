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

### 0. Start the container

```sh
docker run --rm -it \
  -v /path/to/old/pg11_data:/var/lib/postgresql/11/data \
  -v /path/to/new/pg16_data:/var/lib/postgresql/16/data \
  -u postgres \
  epicmorg/pg-upgrade-tool:latest
```

### 1. Initialise a new empty 16 cluster

```sh
/usr/lib/postgresql/16/bin/initdb -D /var/lib/postgresql/16/data --locale=en_US.UTF-8 -A md5
```

### 2. (Optional) Check - if this passes, all extensions are in place

```sh
/usr/lib/postgresql/16/bin/pg_upgrade \
  -b /usr/lib/postgresql/11/bin \
  -B /usr/lib/postgresql/16/bin \
  -d /var/lib/postgresql/11/data \
  -D /var/lib/postgresql/16/data \
  --check
```

### 3. Upgrade (copy mode, without `--link`)

```sh
/usr/lib/postgresql/16/bin/pg_upgrade \
  -b /usr/lib/postgresql/11/bin \
  -B /usr/lib/postgresql/16/bin \
  -d /var/lib/postgresql/11/data \
  -D /var/lib/postgresql/16/data
```

### 4. Post-upgrade, in the new `epicmorg/postgres:16` container

```sh
docker exec -d postgres-16 vacuumdb --all --analyze-in-stages -U postgres
```

Copy your `postgresql.conf` / `pg_hba.conf` changes to the new cluster before starting it.

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
