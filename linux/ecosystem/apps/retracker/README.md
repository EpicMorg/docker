<!-- hub-description: retracker - simple in-memory HTTP BitTorrent tracker, built from source -->
# `epicmorg/retracker`

[retracker](https://github.com/vvampirius/retracker) — a small HTTP BitTorrent tracker that keeps
peers in memory, handy as a local/LAN "retracker". Built from source with `epicmorg/go` and shipped on
`epicmorg/debian:trixie`.

## What's inside

* `retracker` (static Go build, `CGO_ENABLED=0`) in `/usr/local/share/epicmorg/retracker`
* `docker-entrypoint.sh` under `tini`: turns the `RETRACKER_*` variables into command-line flags
* no persistent state — peers live in memory only

## Tags

<!-- readme-sync:tags:begin -->
| Tags | Dockerfile |
| ---- | ---------- |
| `latest` | [`.`](./Dockerfile) |

Every tag is pushed to `docker.io`, `quay.io` and `ghcr.io` (`epicmorg/retracker:<tag>` on each) - same digest everywhere.
<!-- readme-sync:tags:end -->

## Usage

```sh
docker run -d --name retracker -p 80:80 epicmorg/retracker:latest
```

Behind a reverse proxy keep `RETRACKER_REAL_IP=true` and pass `X-Real-IP`.

| Variable | Default | Flag | Meaning |
| --- | --- | --- | --- |
| `RETRACKER_PORT` | `80` | `-l :<port>` | listen port |
| `RETRACKER_MINUTS` | `180` | `-a <minutes>` | how long a peer is kept in memory |
| `RETRACKER_REAL_IP` | `true` | `-x` | take the client address from `X-Real-IP` |
| `RETRACKER_DEBUG` | `false` | `-d` | debug logging |

If you change `RETRACKER_PORT`, publish that port instead of `80`.

## Links

* Source: [EpicMorg/docker](https://github.com/EpicMorg/docker) - issues and PRs welcome
* Tags float and are rebuilt weekly; pin by digest for reproducible builds: [Tags, pinning and updates](https://github.com/EpicMorg/docker#tags-pinning-and-updates)
* [CHANGELOG](https://github.com/EpicMorg/docker/blob/master/CHANGELOG.md) - License: MIT
