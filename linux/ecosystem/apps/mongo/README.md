<!-- hub-description: MongoDB 1.2-9.0 (vendor binaries, TLS on baked OpenSSL), drop-in for library/mongo -->
# `epicmorg/mongo`

MongoDB from MongoDB's own prebuilt binaries (`fastdl.mongodb.org`, sha256-checked) on Debian 13 `trixie`, one tag
per release line at its newest patch, from `1.2` to `9.0`. The entrypoint is a **drop-in for `library/mongo`**
(`MONGO_INITDB_*`, `/docker-entrypoint-initdb.d`, `/data/db`, uid `999`) and understands the common
`bitnami/mongodb` variables too. MongoDB itself is not built from source (SCons / its own toolchain, hours and
tens of GB of RAM per build); what is ours: the base, the TLS stacks the old binaries need, the entrypoint and
the fatal checks.

## What's inside

| Lines | Vendor build | TLS |
| ----- | ------------ | --- |
| `1.2`-`2.6` | generic "legacy" | none (no Debian/Ubuntu TLS builds exist; libc only) |
| `3.0`-`3.6` | ubuntu1604 | OpenSSL `1.0.2g` built from Ubuntu 16.04's source package (all its patches incl. the symbol-version script and security fixes) |
| `4.0`-`5.0` (+ `4.1`) | ubuntu1804 / debian10 / debian11 | baked OpenSSL `1.1.1` + curl `8.17` + openldap `2.6` / cyrus-sasl `2.1` built against it |
| `6.0`-`9.0` | ubuntu2204 / debian12 / debian13 | Debian's OpenSSL 3 |

* `mongod`, `mongos` and the tarball's tools in `/usr/local/share/epicmorg/mongo/<major.minor>/bin`, on `PATH`;
  legacy `mongo` shell up to 5.0; `mongosh` (2.x) for 6.0+; MongoDB Database Tools (100.x) for 4.4+;
* baked stacks are wired into the vendor ELF files with `patchelf --force-rpath` (DT_RPATH, so it also covers the
  libraries they load) - nothing in `ld.so.conf`; `/emg-export` has mongo + the prefixes it links for `COPY --from`;
* entrypoint under `tini`, `gosu`, `numactl` (interleave when available); volumes `/data/db`, `/data/configdb`;
  port `27017`.

Fatal build-time checks: the release, no unresolved libraries, at most one `libssl` per binary and - per line -
none / the baked one / Debian's, no OpenSSL 3 in the 1.x-TLS `mongod`, and a smoke test: first-start
initialisation with a root user, `listDatabases` with and without credentials, and a TLS listener.

## Variables

| Variable | Meaning |
| -------- | ------- |
| `MONGO_INITDB_ROOT_USERNAME` / `_PASSWORD` (`_FILE`) | root user created on the first start (empty dbpath); then `--auth` |
| `MONGO_INITDB_DATABASE` | database for `/docker-entrypoint-initdb.d/*.js` (default `test`); `*.sh` are sourced |
| `MONGODB_ROOT_USER` (`root`) / `MONGODB_ROOT_PASSWORD` (`_FILE`) | bitnami names for the root user |
| `MONGODB_USERNAME` / `MONGODB_PASSWORD` (`_FILE`) / `MONGODB_DATABASE` | bitnami: an extra `readWrite` user in that database |
| `MONGODB_PORT_NUMBER` | bitnami: `--port` |
| `MONGODB_EXTRA_FLAGS` | bitnami: extra `mongod` flags (word-split) |

A mounted `/bitnami/mongodb` becomes `--dbpath /bitnami/mongodb/data/db`. Arguments starting with `-` go to
`mongod`; any other command (`mongosh`, `mongodump`, `bash`) runs as is. 3.6+ get `--bind_ip_all` unless you pass a
bind option or a config file. Users are created with `db.createUser` (2.6+) or `db.addUser` (older).

## Tags

<!-- readme-sync:tags:begin -->
| Tags | Dockerfile |
| ---- | ---------- |
| `1.2`, `1.2.5` | [`1.2`](1.2/Dockerfile) |
| `1.4`, `1.4.5` | [`1.4`](1.4/Dockerfile) |
| `1.6`, `1.6.5` | [`1.6`](1.6/Dockerfile) |
| `1.8`, `1.8.5`, `1` | [`1.8`](1.8/Dockerfile) |
| `2.0`, `2.0.9` | [`2.0`](2.0/Dockerfile) |
| `2.2`, `2.2.7` | [`2.2`](2.2/Dockerfile) |
| `2.4`, `2.4.14` | [`2.4`](2.4/Dockerfile) |
| `2.6`, `2.6.12`, `2` | [`2.6`](2.6/Dockerfile) |
| `3.0`, `3.0.15` | [`3.0`](3.0/Dockerfile) |
| `3.2`, `3.2.22` | [`3.2`](3.2/Dockerfile) |
| `3.4`, `3.4.24` | [`3.4`](3.4/Dockerfile) |
| `3.6`, `3.6.23`, `3` | [`3.6`](3.6/Dockerfile) |
| `4.0`, `4.0.28` | [`4.0`](4.0/Dockerfile) |
| `4.1`, `4.1.13` | [`4.1`](4.1/Dockerfile) |
| `4.2`, `4.2.25` | [`4.2`](4.2/Dockerfile) |
| `4.4`, `4.4.31`, `4` | [`4.4`](4.4/Dockerfile) |
| `5.0`, `5.0.34`, `5` | [`5.0`](5.0/Dockerfile) |
| `6.0`, `6.0.29`, `6` | [`6.0`](6.0/Dockerfile) |
| `7.0`, `7.0.43`, `7` | [`7.0`](7.0/Dockerfile) |
| `8.0`, `8.0.32` | [`8.0`](8.0/Dockerfile) |
| `8.2`, `8.2.12`, `8` | [`8.2`](8.2/Dockerfile) |
| `9.0`, `9.0.2`, `9`, `latest` | [`9.0`](9.0/Dockerfile) |

Every tag is pushed to `docker.io`, `quay.io` and `ghcr.io` (`epicmorg/mongo:<tag>` on each) - same digest everywhere.
<!-- readme-sync:tags:end -->

## Usage

```yaml
services:
  mongo:
    image: epicmorg/mongo:8.2          # was: mongo:8.2 - environment and volumes unchanged
    restart: always
    environment:
      MONGO_INITDB_ROOT_USERNAME: root
      MONGO_INITDB_ROOT_PASSWORD_FILE: /run/secrets/mongo-root
    volumes:
      - ./db:/data/db
      - ./initdb:/docker-entrypoint-initdb.d:ro
    secrets: [mongo-root]
secrets:
  mongo-root:
    file: ./mongo-root.txt
```

## Notes

* `1.0` is not provided: its `mongod` has no `--fork` / `--logpath` (the first-start initialisation needs them).
  `1.6` is `1.6.5` (1.6.6 is gone from fastdl). `mongosniff` (1.x-2.4, needs libpcap 0.9) is dropped.
* Old lines (everything before 7.0) are end-of-life upstream; they are here for data that has to be read or
  migrated, not for new deployments. Upgrade a data directory one major line at a time.
* Licences: MongoDB up to 4.0.3 is AGPLv3, later releases SSPL; the image recipe is MIT.

Folders are written by `bin/python/mongo-versions-sync.py`; the entrypoint lives once in
[`docker-entrypoint.sh`](docker-entrypoint.sh) and is copied into each folder.

## Links

* Source: [EpicMorg/docker](https://github.com/EpicMorg/docker) - issues and PRs welcome
* Tags float and are rebuilt weekly; pin by digest for reproducible builds: [Tags, pinning and updates](https://github.com/EpicMorg/docker#tags-pinning-and-updates)
* [CHANGELOG](https://github.com/EpicMorg/docker/blob/master/CHANGELOG.md) - License: MIT
