<!-- hub-description: Redis 6.2-8.x from source (TLS, baked OpenSSL), drop-in for bitnami/redis -->
# `epicmorg/redis`

Redis built from the redis.io source tarballs (sha256-checked) on Debian 13 `trixie`, one tag per maintained
release line at its newest patch. The entrypoint is a **drop-in for `bitnami/redis`**: the same
`REDIS_*` / `ALLOW_EMPTY_PASSWORD` variables, the same data path `/bitnami/redis/data`, the same mounted
config files and the same uid (`1001`) - switch the `image:` line of an existing bitnami compose service and
keep its environment and volume.

## What's inside

* `redis-server`, `redis-cli`, `redis-benchmark`, `redis-check-aof/rdb`, `redis-sentinel` in
  `/usr/local/share/epicmorg/redis/<major.minor>/bin`, on `PATH`; the upstream `redis.conf` / `sentinel.conf`
  in `.../etc` (8.x: the `loadmodule` lines commented out, see below);
* TLS built in against the baked OpenSSL `3.5` (LTS, `/usr/local/share/epicmorg/openssl/3.5`, real `RPATH`,
  nothing in `ld.so.conf`), jemalloc, no systemd;
* `/emg-export` - redis + the OpenSSL it links as a self-contained tree for `COPY --from`;
* entrypoint under `tini`; `redis-server` runs as `redis` (uid `1001`, group `root`) when the container starts as
  root (the data directory is chowned to it), or as whatever `--user` you give;
* volume `/data` (native) - `/bitnami/redis/data` is used instead when it is mounted; port `6379`;
  `HEALTHCHECK` = `redis-cli ping` (with `REDIS_PASSWORD`).

Built with the system compiler (gcc 14) from `epicmorg/gcc:14`; only `src/` is built - the Redis 8 module trees
(search, JSON, time series, probabilistic; Rust / CMake toolchains) are not part of the image.
Fatal build-time checks: exact version, jemalloc, no unresolved libraries, no `RUNPATH`, exactly one `libssl` and
it is the baked one, and an entrypoint smoke test (AUTH, AOF, TLS port, disabled command, runs as `redis`,
refuses to start without a password).

## Variables

As in `bitnami/redis`. Every start renders `/run/redis/redis.conf` (mode `0600`) from the base config + these.

| Variable | Default | Meaning |
| -------- | ------- | ------- |
| `REDIS_PASSWORD` / `REDIS_PASSWORD_FILE` | _(none)_ | `requirepass`; the file (Docker secret) wins |
| `ALLOW_EMPTY_PASSWORD` | `no` | `yes` = start without a password (development only); otherwise no password = fatal |
| `REDIS_PORT_NUMBER` | `6379` | `port` |
| `REDIS_AOF_ENABLED` | `yes` | `appendonly` |
| `REDIS_RDB_POLICY` | _(none)_ | `save` points, e.g. `900#1 300#10` |
| `REDIS_RDB_POLICY_DISABLED` | `no` | `yes` = no RDB snapshots even with a policy |
| `REDIS_ALLOW_REMOTE_CONNECTIONS` | `yes` | `bind 0.0.0.0`, `protected-mode no`; `no` keeps the base config's localhost bind |
| `REDIS_DISABLE_COMMANDS` | _(none)_ | comma list, e.g. `FLUSHDB,FLUSHALL` (`rename-command X ""`) |
| `REDIS_ACLFILE` | _(none)_ | `aclfile` |
| `REDIS_IO_THREADS` / `REDIS_IO_THREADS_DO_READS` | _(none)_ | `io-threads` / `io-threads-do-reads` |
| `REDIS_EXTRA_FLAGS` | _(none)_ | extra `redis-server` arguments (word-split) |
| `REDIS_REPLICATION_MODE` | _(none)_ | `master` or `replica` (`slave`) |
| `REDIS_MASTER_HOST` / `REDIS_MASTER_PORT_NUMBER` | _(none)_ / `6379` | replica: `replicaof` |
| `REDIS_MASTER_PASSWORD` / `_FILE` | _(none)_ | replica: `masterauth` |
| `REDIS_REPLICA_IP` / `REDIS_REPLICA_PORT` | _(none)_ | `replica-announce-ip` / `-port` |
| `REDIS_TLS_ENABLED` | `no` | TLS listener; needs cert, key and CA file or dir |
| `REDIS_TLS_PORT_NUMBER` | `6379` | `tls-port`; equal to `REDIS_PORT_NUMBER` = TLS only (`port 0`) |
| `REDIS_TLS_CERT_FILE` / `_KEY_FILE` / `_KEY_FILE_PASS` / `_CA_FILE` / `_CA_DIR` / `_DH_PARAMS_FILE` | _(none)_ | the `tls-*` files |
| `REDIS_TLS_AUTH_CLIENTS` | `yes` | `tls-auth-clients` |
| `REDIS_DATA_DIR` | `/bitnami/redis/data` if mounted, else `/data` | `dir` |

Config files, ours or bitnami's paths: base config `/etc/redis/redis.conf` or
`/opt/bitnami/redis/mounted-etc/redis.conf` (else the shipped one), overrides included last from
`/etc/redis/overrides.conf` or `/opt/bitnami/redis/mounted-etc/overrides.conf` (`REDIS_OVERRIDES_FILE`).
Not covered: bitnami's sentinel / cluster images.

## Tags

<!-- readme-sync:tags:begin -->
| Tags | Dockerfile |
| ---- | ---------- |
| `6.2`, `6.2.24`, `6` | [`6.2`](6.2/Dockerfile) |
| `7.2`, `7.2.16` | [`7.2`](7.2/Dockerfile) |
| `7.4`, `7.4.11`, `7` | [`7.4`](7.4/Dockerfile) |
| `8.0`, `8.0.6` | [`8.0`](8.0/Dockerfile) |
| `8.2`, `8.2.10` | [`8.2`](8.2/Dockerfile) |
| `8.4`, `8.4.7` | [`8.4`](8.4/Dockerfile) |
| `8.6`, `8.6.7` | [`8.6`](8.6/Dockerfile) |
| `8.8`, `8.8.3` | [`8.8`](8.8/Dockerfile) |
| `8.10`, `8.10.2`, `8`, `latest` | [`8.10`](8.10/Dockerfile) |

Every tag is pushed to `docker.io`, `quay.io` and `ghcr.io` (`epicmorg/redis:<tag>` on each) - same digest everywhere.
<!-- readme-sync:tags:end -->

## Usage

```yaml
services:
  redis:
    image: epicmorg/redis:8           # was: bitnami/redis:latest - environment and volume unchanged
    restart: always
    environment:
      REDIS_PASSWORD_FILE: /run/secrets/redis
      REDIS_DISABLE_COMMANDS: FLUSHDB,FLUSHALL
    volumes:
      - ./redis:/bitnami/redis/data   # or ./redis:/data
    secrets:
      - redis
secrets:
  redis:
    file: ./redis-password.txt
```

```sh
docker exec -it redis redis-cli -a "$(cat redis-password.txt)" info server
```

## Notes

* Licences: Redis 7.4+ is RSALv2 / SSPLv1, 8.0+ also AGPLv3 (redis.io); 6.2 / 7.2 are BSD-3. The image only
  repackages the unmodified source.
* `vm.overcommit_memory = 1` on the host, as Redis logs at start, for reliable background saves.

## Links

* Source: [EpicMorg/docker](https://github.com/EpicMorg/docker) - issues and PRs welcome
* Tags float and are rebuilt weekly; pin by digest for reproducible builds: [Tags, pinning and updates](https://github.com/EpicMorg/docker#tags-pinning-and-updates)
* [CHANGELOG](https://github.com/EpicMorg/docker/blob/master/CHANGELOG.md) - License: MIT
