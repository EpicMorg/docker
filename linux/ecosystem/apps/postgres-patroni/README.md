<!-- hub-description: Patroni 4.1 (etcd) HA cluster node on top of epicmorg/postgres 9.3-18 -->
# `epicmorg/postgres-patroni`

[Patroni](https://github.com/patroni/patroni) high-availability PostgreSQL node, one tag per
PostgreSQL major, built on top of
[`epicmorg/postgres:<major>`](https://github.com/EpicMorg/docker/tree/master/linux/ecosystem/apps/postgres)
(so the same PostgreSQL build and extension set).

## What's inside

* everything from `epicmorg/postgres:<major>`;
* `patroni[psycopg2,etcd]` `4.1.*` installed with `pip` (DCS: etcd);
* the entrypoint starts `patroni /etc/patroni.yml` as the `postgres` user, with
  `PATRONI_LOG_DIR=/var/log/patroni` and `PATRONI_LOG_LEVEL=DEBUG`;
* `/var/lib/postgresql` owned by `postgres` (mode `0700`) - mount the data directory there;
* `htop`, `net-tools` for troubleshooting.

The image ships **no** `patroni.yml`: mount your own at `/etc/patroni.yml` (it defines the
PostgreSQL port, data directory, REST API listen address, etcd hosts, users and replication).

## Tags

<!-- readme-sync:tags:begin -->
| Tags | Dockerfile |
| ---- | ---------- |
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

Every tag is pushed to `docker.io`, `quay.io` and `ghcr.io` (`epicmorg/postgres-patroni:<tag>` on each) - same digest everywhere.
<!-- readme-sync:tags:end -->

## Usage

One node of a cluster (repeat per host with its own `patroni.yml`; an etcd cluster is required):

```yml
services:
  patroni17:
    image: epicmorg/postgres-patroni:17
    container_name: patroni17
    restart: always
    ports:
      - "6432:6432"   # PostgreSQL, as set in patroni.yml
      - "8008:8008"   # Patroni REST API, as set in patroni.yml
    volumes:
      - /etc/localtime:/etc/localtime:ro
      - /etc/timezone:/etc/timezone:ro
      - ./data/17:/var/lib/postgresql
      - ./config/patroni.yml:/etc/patroni.yml:ro
      - ./logs/patroni:/var/log/patroni
      - ./logs/postgresql:/var/log/postgresql
    environment:
      PATRONICTL_CONFIG_FILE: /etc/patroni.yml
    depends_on:
      - etcd
```

Users, passwords and `initdb` options come from `patroni.yml` (the `POSTGRES_*` variables of
`epicmorg/postgres` are not used here). `patronictl list` inside the container shows the cluster state (`PATRONICTL_CONFIG_FILE` points it
at the config). Configuration reference: [Patroni YAML configuration](https://patroni.readthedocs.io/en/latest/yaml_configuration.html).

## Links

* Source: [EpicMorg/docker](https://github.com/EpicMorg/docker) - issues and PRs welcome
* Tags float and are rebuilt weekly; pin by digest for reproducible builds: [Tags, pinning and updates](https://github.com/EpicMorg/docker#tags-pinning-and-updates)
* [CHANGELOG](https://github.com/EpicMorg/docker/blob/master/CHANGELOG.md) - License: MIT
