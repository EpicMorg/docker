<!-- hub-description: opentracker - fast open BitTorrent tracker (UDP+HTTP), built from source -->
# `epicmorg/opentracker`

[opentracker](https://erdgeist.org/arts/software/opentracker/) — an open and free BitTorrent tracker
by erdgeist. Built from source (with [libowfat](https://www.fefe.de/libowfat/)) in an
`epicmorg/debian:trixie-develop` stage, linked statically and shipped on `epicmorg/debian:trixie`.
Originally based on [wiltonsr/opentracker-docker](https://github.com/wiltonsr/opentracker-docker).

## What's inside

* `/usr/bin/opentracker` and `/usr/bin/opentracker.debug` — static builds with the default compile
  options, i.e. **open mode** (no white/black access lists compiled in)
* config: `/etc/opentracker/opentracker.conf` (all defaults) and `opentracker.conf.sample` with every
  option documented
* `docker-entrypoint.sh` under `tini` runs `opentracker ${RETRACKER_OPTS} -f ${RETRACKER_CONFIG}`
* port `6969` TCP (HTTP announce/scrape) and UDP; healthcheck over HTTP; `STOPSIGNAL SIGINT`

## Tags

<!-- readme-sync:tags:begin -->
| Tags | Dockerfile |
| ---- | ---------- |
| `latest` | [`.`](./Dockerfile) |

Every tag is pushed to `docker.io`, `quay.io` and `ghcr.io` (`epicmorg/opentracker:<tag>` on each) - same digest everywhere.
<!-- readme-sync:tags:end -->

## Usage

```sh
docker run -d --name opentracker \
  -p 6969:6969/udp -p 6969:6969 \
  epicmorg/opentracker:latest
```

Announce URLs: `udp://<host>:6969/announce` and `http://<host>:6969/announce`.

Custom configuration (start from `opentracker.conf.sample`):

```sh
docker run -d --name opentracker \
  -p 6969:6969/udp -p 6969:6969 \
  -v "$PWD/opentracker.conf":/etc/opentracker/opentracker.conf:ro \
  epicmorg/opentracker:latest
```

| Variable | Default | Meaning |
| --- | --- | --- |
| `RETRACKER_CONFIG` | `/etc/opentracker/opentracker.conf` | config file passed with `-f` |
| `RETRACKER_DEBUG` | `false` | `true` runs `opentracker.debug` instead |
| `RETRACKER_OPTS` | (empty) | extra command-line options |
| `RETRACKER_PORT` | `6969` | port used by the healthcheck; set the listen port in the config to match |

## Notes

* Closed (whitelist/blacklist) mode needs a build with `-DWANT_ACCESSLIST_WHITE` /
  `-DWANT_ACCESSLIST_BLACK`; this image does not ship such a build.

## Links

* Source: [EpicMorg/docker](https://github.com/EpicMorg/docker) - issues and PRs welcome
* Tags float and are rebuilt weekly; pin by digest for reproducible builds: [Tags, pinning and updates](https://github.com/EpicMorg/docker#tags-pinning-and-updates)
* [CHANGELOG](https://github.com/EpicMorg/docker/blob/master/CHANGELOG.md) - License: MIT
