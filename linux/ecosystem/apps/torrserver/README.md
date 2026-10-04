<!-- hub-description: TorrServer (torrent streaming server) on Debian trixie -->
# `epicmorg/torrserver`

[TorrServer](https://github.com/YouROK/TorrServer) — streams torrents over HTTP so media players can
play them without waiting for the full download. Runs on `epicmorg/debian:trixie`.

## What's inside

* `torrServer` — the latest `TorrServer-linux-amd64` release binary at build time, in
  `/usr/local/share/epicmorg/torrserver/bin` (on `PATH`)
* config/database directory `/usr/local/share/epicmorg/torrserver/config` (volume)
* healthcheck: HTTP request to the web UI every 2 minutes
* `GODEBUG=madvdontneed=1` — returns freed memory to the OS promptly

## Tags

<!-- readme-sync:tags:begin -->
| Tags | Dockerfile |
| ---- | ---------- |
| `latest` | [`.`](./Dockerfile) |

Every tag is pushed to `docker.io`, `quay.io` and `ghcr.io` (`epicmorg/torrserver:<tag>` on each) - same digest everywhere.
<!-- readme-sync:tags:end -->

## Usage

```yaml
services:
  torrserver:
    image: epicmorg/torrserver:latest
    restart: unless-stopped
    ports:
      - "8090:8090"          # web UI / HTTP API
      - "32000:32000"        # UPnP
      - "32000:32000/udp"
    volumes:
      - ./torrserver:/usr/local/share/epicmorg/torrserver/config
```

Open `http://<host>:8090`.

| Variable | Default | Meaning |
| --- | --- | --- |
| `UI_PORT` | `8090` | web UI / API port |
| `UPNP_PORT` | `32000` | exposed UPnP port |

## Links

* Source: [EpicMorg/docker](https://github.com/EpicMorg/docker) - issues and PRs welcome
* Tags float and are rebuilt weekly; pin by digest for reproducible builds: [Tags, pinning and updates](https://github.com/EpicMorg/docker#tags-pinning-and-updates)
* [CHANGELOG](https://github.com/EpicMorg/docker/blob/master/CHANGELOG.md) - License: MIT
