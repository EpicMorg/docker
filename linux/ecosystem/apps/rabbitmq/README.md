<!-- hub-description: RabbitMQ 3.9-4.4 on our Erlang/OTP, management on, drop-in for library/rabbitmq and bitnami/rabbitmq -->
# `epicmorg/rabbitmq`

RabbitMQ from the generic-unix release tarballs (GPG signature checked with the RabbitMQ release key) on Debian 13
`trixie` and our Erlang/OTP (`epicmorg/erlang`), one tag per release line at its newest patch. The management and
Prometheus plugins are on. The entrypoint is a **drop-in for `library/rabbitmq`** (`RABBITMQ_DEFAULT_*`,
`/var/lib/rabbitmq`, `/etc/rabbitmq/conf.d`, uid `999`) **and for `bitnami/rabbitmq`** (`RABBITMQ_USERNAME` /
`_PASSWORD`, `RABBITMQ_PLUGINS`, `RABBITMQ_VHOSTS`, `/bitnami/rabbitmq`, clustering variables) - switch the
`image:` line and keep the environment and volume.

## What's inside

| Line | Erlang/OTP |
| ---- | ---------- |
| `4.4` (`4`, `latest`) | 29 |
| `4.0` - `4.3` | 27 |
| `3.12`, `3.13` (`3`) | 26 |
| `3.10`, `3.11` | 25 |
| `3.9` | 24 |

The OTP major per line is the newest one RabbitMQ's [compatibility matrix](https://www.rabbitmq.com/docs/which-erlang)
fully supports for it (4.x: the one `library/rabbitmq` ships).

* RabbitMQ in `/usr/local/share/epicmorg/rabbitmq/<major.minor>`, linked as `/opt/rabbitmq` (`RABBITMQ_HOME`, as
  library) and `/opt/bitnami/rabbitmq`; `/plugins`; config `/etc/rabbitmq` (`rabbitmq.conf`, `conf.d/`,
  `enabled_plugins`), data `/var/lib/rabbitmq` (also `HOME` - the Erlang cookie lives there);
* Erlang + its OpenSSL from `epicmorg/erlang:<otp>` (`COPY --from`), TLS for AMQP / management / inter-node;
* entrypoint under `tini`; RabbitMQ runs as `rabbitmq` (uid `999`) when the container starts as root;
  `HEALTHCHECK` = `rabbitmq-diagnostics ping`; every tag also has a `-management` alias (`4.3-management`, ...),
  as the library images are usually referenced.

Fatal build-time checks: RabbitMQ and OTP versions, then a smoke test - library mode (`RABBITMQ_DEFAULT_USER` /
`_PASS`, management API answers with the exact version, runs as `rabbitmq`), bitnami mode (`RABBITMQ_USERNAME` /
`_PASSWORD`, `RABBITMQ_VHOSTS` declared with permissions, restart on the persisted node data).

## Modes

**library mode** (default) - exactly `library/rabbitmq`: RabbitMQ reads `RABBITMQ_DEFAULT_USER` / `_PASS` /
`_VHOST` (+ `_FILE`) itself; `conf.d/10-defaults.conf` lets `guest` in from the network and logs to stdout; your own
`rabbitmq.conf` / `conf.d/*.conf` / `enabled_plugins` mount into `/etc/rabbitmq`. Long hostnames switch on
`RABBITMQ_USE_LONGNAME` as in library.

**bitnami mode** - on when `/bitnami/rabbitmq` is mounted or a bitnami-only variable is set. As `bitnami/rabbitmq`
it writes `/etc/rabbitmq/rabbitmq.conf` (unless one is mounted), `rabbitmq-env.conf` and `enabled_plugins`, copies
`/bitnami/rabbitmq/conf/*` over `/etc/rabbitmq`, keeps the node data in `/bitnami/rabbitmq/mnesia` (node name
`rabbit@localhost` by default - an existing bitnami volume starts), and on the first start declares the vhosts and
joins the cluster.

| Variable | Default | Meaning |
| -------- | ------- | ------- |
| `RABBITMQ_USERNAME` / `RABBITMQ_PASSWORD` (`_FILE`) | `user` / `bitnami` | default user (`default_user` / `default_pass`) |
| `RABBITMQ_VHOST` / `RABBITMQ_VHOSTS` | `/` / - | default vhost; extra vhosts (`name[:queue-type]`, space-separated) with full permissions for the user |
| `RABBITMQ_PLUGINS` | - | plugins on top of `rabbitmq_management_agent`, `rabbitmq_prometheus` |
| `RABBITMQ_NODE_NAME` / `RABBITMQ_NODE_TYPE` | `rabbit@localhost` / `stats` | node name; `stats` (management), `queue-disc`, `queue-ram` |
| `RABBITMQ_CLUSTER_NODE_NAME` | - | node to join on the first start (non-`stats` nodes) |
| `RABBITMQ_ERL_COOKIE` (`_FILE`) | random | Erlang cookie (needed for clusters / remote CLI) |
| `RABBITMQ_NODE_PORT_NUMBER` / `RABBITMQ_NODE_SSL_PORT_NUMBER` | `5672` / `5671` | AMQP listeners |
| `RABBITMQ_SSL_CACERTFILE` / `_CERTFILE` / `_KEYFILE` / `_PASSWORD` / `_DEPTH` / `_VERIFY` / `_FAIL_IF_NO_PEER_CERT` | - | AMQP TLS (`*_CERT_FILE` spellings too) |
| `RABBITMQ_MANAGEMENT_BIND_IP` / `_PORT_NUMBER` / `_SSL_PORT_NUMBER` | `0.0.0.0` / `15672` / `15671` | management listener |
| `RABBITMQ_MANAGEMENT_SSL_*` | the AMQP ones | management TLS |
| `RABBITMQ_MANAGEMENT_ALLOW_WEB_ACCESS` | `false` | `false` = the default user is loopback-only (bitnami's default) |
| `RABBITMQ_LOAD_DEFINITIONS` / `RABBITMQ_DEFINITIONS_FILE` | `no` / `/app/load_definition.json` | import definitions on boot |
| `RABBITMQ_SECURE_PASSWORD` / `RABBITMQ_UPDATE_PASSWORD` | `no` / `no` | password not in the config file / re-set it on persisted data |
| `RABBITMQ_FORCE_BOOT` | `no` | `rabbitmqctl force_boot` before starting on persisted data |
| `RABBITMQ_ENABLE_LDAP` + `RABBITMQ_LDAP_SERVERS` / `_SERVERS_PORT` / `_USER_DN_PATTERN` / `_TLS` | `no` | LDAP auth backend |
| `RABBITMQ_VM_MEMORY_HIGH_WATERMARK` | - | absolute (`2GB`) or relative (`0.6`, `60%`) |
| `RABBITMQ_DISK_FREE_RELATIVE_LIMIT` / `_ABSOLUTE_LIMIT` | `1.0` / - | free disk limit |
| `RABBITMQ_CLUSTER_PARTITION_HANDLING` | `ignore` | `cluster_partition_handling` |
| `RABBITMQ_NODE_DEFAULT_QUEUE_TYPE` | - | `default_queue_type` |
| `RABBITMQ_ULIMIT_NOFILES` | - | raise `ulimit -n` |

`/docker-entrypoint-initdb.d/*.sh` run on every start with the node up (bitnami behaviour);
`/bitnami/rabbitmq/conf/custom.conf` lines override the generated config. Not covered: `RABBITMQ_COMMUNITY_PLUGINS`
downloads and `RABBITMQ_CLUSTER_REBALANCE`.

## Tags

<!-- readme-sync:tags:begin -->
| Tags | Dockerfile |
| ---- | ---------- |
| `3.9`, `3.9.29`, `3.9-management`, `3.9.29-management` | [`3.9`](3.9/Dockerfile) |
| `3.10`, `3.10.25`, `3.10-management`, `3.10.25-management` | [`3.10`](3.10/Dockerfile) |
| `3.11`, `3.11.28`, `3.11-management`, `3.11.28-management` | [`3.11`](3.11/Dockerfile) |
| `3.12`, `3.12.14`, `3.12-management`, `3.12.14-management` | [`3.12`](3.12/Dockerfile) |
| `3.13`, `3.13.7`, `3.13-management`, `3.13.7-management`, `3`, `3-management` | [`3.13`](3.13/Dockerfile) |
| `4.0`, `4.0.9`, `4.0-management`, `4.0.9-management` | [`4.0`](4.0/Dockerfile) |
| `4.1`, `4.1.8`, `4.1-management`, `4.1.8-management` | [`4.1`](4.1/Dockerfile) |
| `4.2`, `4.2.9`, `4.2-management`, `4.2.9-management` | [`4.2`](4.2/Dockerfile) |
| `4.3`, `4.3.7`, `4.3-management`, `4.3.7-management` | [`4.3`](4.3/Dockerfile) |
| `4.4`, `4.4.0`, `4.4-management`, `4.4.0-management`, `4`, `4-management`, `latest`, `management` | [`4.4`](4.4/Dockerfile) |

Every tag is pushed to `docker.io`, `quay.io` and `ghcr.io` (`epicmorg/rabbitmq:<tag>` on each) - same digest everywhere.
<!-- readme-sync:tags:end -->

## Usage

```yaml
services:
  rabbitmq:
    image: epicmorg/rabbitmq:4.3          # was: rabbitmq:4.3-management - environment and volume unchanged
    restart: always
    hostname: rabbit1
    ports:
      - "5672:5672"
      - "15672:15672"
    environment:
      RABBITMQ_DEFAULT_USER: app
      RABBITMQ_DEFAULT_PASS_FILE: /run/secrets/rabbitmq-pass
    volumes:
      - ./rabbitmq:/var/lib/rabbitmq
    secrets: [rabbitmq-pass]
secrets:
  rabbitmq-pass:
    file: ./rabbitmq-pass.txt
```

## Notes

* Upgrade a node's data one release line at a time (e.g. 3.9 -> 3.10 -> ... -> 3.13 -> 4.0), with all stable feature
  flags enabled before each step (`rabbitmqctl enable_feature_flag all`); the old lines are here for that path.
* Licence: RabbitMQ is MPL 2.0; the image recipe is MIT.

Folders are written by `bin/python/rabbitmq-versions-sync.py`.

## Links

* Source: [EpicMorg/docker](https://github.com/EpicMorg/docker) - issues and PRs welcome
* Tags float and are rebuilt weekly; pin by digest for reproducible builds: [Tags, pinning and updates](https://github.com/EpicMorg/docker#tags-pinning-and-updates)
* [CHANGELOG](https://github.com/EpicMorg/docker/blob/master/CHANGELOG.md) - License: MIT
