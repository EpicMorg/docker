<!-- hub-description: Apache Cassandra 3.11 on epicmorg/jdk:8 with Python 2.7 cqlsh and Lucene index plugin -->
# `epicmorg/cassandra`

[Apache Cassandra](https://cassandra.apache.org/) `3.11.19`, based on the official `cassandra:3.11`
image recipe, rebuilt on our [`epicmorg/jdk:8`](https://github.com/EpicMorg/docker/tree/master/linux/ecosystem/apps/java/jdk)
(Debian trixie). Used, among others, as the Cassandra server for
[`epicmorg/testrail`](https://github.com/EpicMorg/docker/tree/master/linux/ecosystem/apps/testrail) 7.0+.

## What's inside

* Cassandra `3.11.19` binary tarball from Apache (sha512 + GPG verified) in `/opt/cassandra`,
  config in `/etc/cassandra`, data in `/var/lib/cassandra` (a `VOLUME`);
* Java 8 from `epicmorg/jdk:8`;
* Python `2.7` from [`epicmorg/python:2.7`](https://github.com/EpicMorg/docker/tree/master/linux/ecosystem/apps/python)
  for `cqlsh` (Debian's `python*` packages are apt-pinned out);
* [Stratio Cassandra Lucene index](https://github.com/Stratio/cassandra-lucene-index) plugin
  `3.11.4` in `/opt/cassandra/lib`;
* `libjemalloc2`, `gosu`; runs as user `cassandra` (UID/GID `1337`);
* ports: `7000` (inter-node), `7001` (inter-node TLS), `7199` (JMX), `9042` (CQL), `9160` (Thrift).

## Tags

<!-- readme-sync:tags:begin -->
| Tags | Dockerfile |
| ---- | ---------- |
| `3.11` | [`.`](./Dockerfile) |

Every tag is pushed to `docker.io`, `quay.io` and `ghcr.io` (`epicmorg/cassandra:<tag>` on each) - same digest everywhere.
<!-- readme-sync:tags:end -->

## Usage

```sh
docker run -d --name cassandra \
  -v cassandra:/var/lib/cassandra \
  -p 9042:9042 \
  epicmorg/cassandra:3.11
```

The entrypoint is the one of the official image: these variables are written into
`cassandra.yaml` / `cassandra-rackdc.properties` on start - `CASSANDRA_LISTEN_ADDRESS`
(default `auto`), `CASSANDRA_BROADCAST_ADDRESS`, `CASSANDRA_RPC_ADDRESS` (default `0.0.0.0`),
`CASSANDRA_BROADCAST_RPC_ADDRESS`, `CASSANDRA_SEEDS`, `CASSANDRA_CLUSTER_NAME`,
`CASSANDRA_NUM_TOKENS`, `CASSANDRA_ENDPOINT_SNITCH`, `CASSANDRA_START_RPC`, `CASSANDRA_DC`,
`CASSANDRA_RACK`. See the [official `cassandra` image docs](https://hub.docker.com/_/cassandra).

## Links

* Source: [EpicMorg/docker](https://github.com/EpicMorg/docker) - issues and PRs welcome
* Tags float and are rebuilt weekly; pin by digest for reproducible builds: [Tags, pinning and updates](https://github.com/EpicMorg/docker#tags-pinning-and-updates)
* [CHANGELOG](https://github.com/EpicMorg/docker/blob/master/CHANGELOG.md) - License: MIT
