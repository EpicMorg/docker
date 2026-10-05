<!-- hub-description: qBittorrent-nox (static build) with web UI on Debian trixie, libtorrent 1.2/2.0 -->
# `epicmorg/qbittorrent`

[qBittorrent](https://www.qbittorrent.org/) headless (`qbittorrent-nox`) with the web UI, on
`epicmorg/debian:trixie`. The binary is the fully static build from
[userdocs/qbittorrent-nox-static](https://github.com/userdocs/qbittorrent-nox-static), so the image
carries no Qt or libtorrent packages of its own.

## What's inside

* `/usr/bin/qbittorrent-nox` — static `qbittorrent-nox` for the tagged qBittorrent version
* `docker-entrypoint.sh` run under `tini`: starts `qbittorrent-nox` with a profile directory and
  tails the qBittorrent log to the container output
* healthcheck: HTTP request to the web UI every 2 minutes
* volume: `/opt/qbittorrent` (profiles, configuration, logs)

### Tag variants

Every qBittorrent version is published in three flavours, built from the same Dockerfile with a
different static binary:

| Tag | libtorrent |
| --- | --- |
| `<version>` | libtorrent **2.0.x** (same binary as `-libtorrent2.0.x`) |
| `<version>-libtorrent2.0.x` | libtorrent 2.0 branch (memory-mapped I/O) |
| `<version>-libtorrent1.2.x` | libtorrent 1.2 branch (classic disk I/O) — pick it if 2.0 behaves badly with your storage |

The exact libtorrent patch version is part of the tag (see the table below).

## Tags

<!-- readme-sync:tags:begin -->
| Tags | Dockerfile |
| ---- | ---------- |
| `4.4.0`, `4.4.0-libtorrent2.0.5`, `4.4.0-libtorrent1.2.15` | [`4.4.0`](4.4.0/Dockerfile) |
| `4.4.1`, `4.4.1-libtorrent2.0.5`, `4.4.1-libtorrent1.2.15` | [`4.4.1`](4.4.1/Dockerfile) |
| `4.4.2`, `4.4.2-libtorrent2.0.6`, `4.4.2-libtorrent1.2.16` | [`4.4.2`](4.4.2/Dockerfile) |
| `4.4.3.1`, `4.4.3.1-libtorrent2.0.7`, `4.4.3.1-libtorrent1.2.17` | [`4.4.3.1`](4.4.3.1/Dockerfile) |
| `4.4.4`, `4.4.4-libtorrent2.0.7`, `4.4.4-libtorrent1.2.17` | [`4.4.4`](4.4.4/Dockerfile) |
| `4.4.5`, `4.4.5-libtorrent2.0.8`, `4.4.5-libtorrent1.2.18` | [`4.4.5`](4.4.5/Dockerfile) |
| `4.5.0`, `4.5.0-libtorrent2.0.8`, `4.5.0-libtorrent1.2.18` | [`4.5.0`](4.5.0/Dockerfile) |
| `4.5.1`, `4.5.1-libtorrent2.0.8`, `4.5.1-libtorrent1.2.18` | [`4.5.1`](4.5.1/Dockerfile) |
| `4.5.2`, `4.5.2-libtorrent2.0.9`, `4.5.2-libtorrent1.2.19` | [`4.5.2`](4.5.2/Dockerfile) |
| `4.5.3`, `4.5.3-libtorrent2.0.9`, `4.5.3-libtorrent1.2.19` | [`4.5.3`](4.5.3/Dockerfile) |
| `4.5.4`, `4.5.4-libtorrent2.0.9`, `4.5.4-libtorrent1.2.19` | [`4.5.4`](4.5.4/Dockerfile) |
| `4.5.5`, `4.5.5-libtorrent2.0.9`, `4.5.5-libtorrent1.2.19` | [`4.5.5`](4.5.5/Dockerfile) |
| `4.6.0`, `4.6.0-libtorrent2.0.9`, `4.6.0-libtorrent1.2.19` | [`4.6.0`](4.6.0/Dockerfile) |
| `4.6.1`, `4.6.1-libtorrent2.0.9`, `4.6.1-libtorrent1.2.19` | [`4.6.1`](4.6.1/Dockerfile) |
| `4.6.2`, `4.6.2-libtorrent2.0.9`, `4.6.2-libtorrent1.2.19` | [`4.6.2`](4.6.2/Dockerfile) |
| `4.6.3`, `4.6.3-libtorrent2.0.9`, `4.6.3-libtorrent1.2.19` | [`4.6.3`](4.6.3/Dockerfile) |
| `4.6.4`, `4.6.4-libtorrent2.0.10`, `4.6.4-libtorrent1.2.19` | [`4.6.4`](4.6.4/Dockerfile) |
| `4.6.5`, `4.6.5-libtorrent2.0.10`, `4.6.5-libtorrent1.2.19` | [`4.6.5`](4.6.5/Dockerfile) |
| `4.6.6`, `4.6.6-libtorrent2.0.10`, `4.6.6-libtorrent1.2.19` | [`4.6.6`](4.6.6/Dockerfile) |
| `4.6.7`, `4.6.7-libtorrent2.0.10`, `4.6.7-libtorrent1.2.19` | [`4.6.7`](4.6.7/Dockerfile) |
| `5.0.0`, `5.0.0-libtorrent2.0.10`, `5.0.0-libtorrent1.2.19` | [`5.0.0`](5.0.0/Dockerfile) |
| `5.0.1`, `5.0.1-libtorrent2.0.10`, `5.0.1-libtorrent1.2.19` | [`5.0.1`](5.0.1/Dockerfile) |
| `5.0.2`, `5.0.2-libtorrent2.0.10`, `5.0.2-libtorrent1.2.19` | [`5.0.2`](5.0.2/Dockerfile) |
| `5.0.3`, `5.0.3-libtorrent2.0.11`, `5.0.3-libtorrent1.2.20` | [`5.0.3`](5.0.3/Dockerfile) |
| `5.0.4`, `5.0.4-libtorrent2.0.11`, `5.0.4-libtorrent1.2.20` | [`5.0.4`](5.0.4/Dockerfile) |
| `5.0.5`, `5.0.5-libtorrent2.0.11`, `5.0.5-libtorrent1.2.20` | [`5.0.5`](5.0.5/Dockerfile) |
| `5.1.0`, `5.1.0-libtorrent2.0.11`, `5.1.0-libtorrent1.2.20` | [`5.1.0`](5.1.0/Dockerfile) |
| `5.1.1`, `5.1.1-libtorrent2.0.11`, `5.1.1-libtorrent1.2.20` | [`5.1.1`](5.1.1/Dockerfile) |
| `5.1.2`, `5.1.2-libtorrent2.0.11`, `5.1.2-libtorrent1.2.20` | [`5.1.2`](5.1.2/Dockerfile) |
| `5.1.3`, `5.1.3-libtorrent2.0.11`, `5.1.3-libtorrent1.2.20` | [`5.1.3`](5.1.3/Dockerfile) |
| `5.1.4`, `5.1.4-libtorrent2.0.11`, `5.1.4-libtorrent1.2.20` | [`5.1.4`](5.1.4/Dockerfile) |
| `5.2.0`, `5.2.0-libtorrent2.0.12`, `5.2.0-libtorrent1.2.20` | [`5.2.0`](5.2.0/Dockerfile) |
| `5.2.1`, `5.2.1-libtorrent2.0.13`, `5.2.1-libtorrent1.2.20` | [`5.2.1`](5.2.1/Dockerfile) |
| `5.2.2`, `5.2.2-libtorrent2.0.13`, `5.2.2-libtorrent1.2.20` | [`5.2.2`](5.2.2/Dockerfile) |
| `5.2.3`, `5.2.3-libtorrent2.0.15`, `5.2.3-libtorrent1.2.20` | [`5.2.3`](5.2.3/Dockerfile) |
| `5.2.4`, `5.2.4-libtorrent2.0.15`, `5.2.4-libtorrent1.2.20` | [`5.2.4`](5.2.4/Dockerfile) |
| `5.0.0beta1`, `5.0.0beta1-libtorrentRC_2_0` | [`testing`](testing/Dockerfile) |

Every tag is pushed to `docker.io`, `quay.io` and `ghcr.io` (`epicmorg/qbittorrent:<tag>` on each) - same digest everywhere.
<!-- readme-sync:tags:end -->

## Usage

```yaml
services:
  qbittorrent:
    image: epicmorg/qbittorrent:5.1.2
    container_name: qbittorrent
    restart: unless-stopped
    ports:
      - "8282:8282"        # web UI
      - "1337:1337/tcp"    # incoming peer connections
      - "1337:1337/udp"
      - "9000:9000/tcp"    # embedded tracker
      - "9000:9000/udp"
    volumes:
      - ./qbt:/opt/qbittorrent
      - /path/to/downloads:/downloads
    environment:
      - QBT_PROFILE_NAME=docker
      - QBT_PORT_WEBUI=8282
    tmpfs:
      - /tmp
```

Then open `http://<host>:8282`. Set the listening port to `QBT_PORT_NAT` (1337) and the tracker
port to `QBT_PORT_TRACKER` (9000) in the qBittorrent settings so they match the published ports.

### Environment

| Variable | Default | Meaning |
| --- | --- | --- |
| `QBT_PROFILES_DIR` | `/opt/qbittorrent/profiles` | `--profile` directory |
| `QBT_PROFILE_NAME` | `docker` | `--configuration` name; data lives in `qBittorrent_<name>/` |
| `QBT_PORT_WEBUI` | `8282` | web UI port (`--webui-port`) |
| `QBT_PORT_NAT` | `1337` | peer port (exposed) |
| `QBT_PORT_TRACKER` | `9000` | embedded tracker port (exposed) |

### Behind nginx

```nginx
location / {
    proxy_pass http://qbittorrent:8282;
    proxy_http_version 1.1;
    proxy_set_header   Host               127.0.0.1:8282;
    proxy_set_header   X-Forwarded-Host   $http_host;
    proxy_set_header   X-Forwarded-For    $remote_addr;
    proxy_cookie_path  /                  "/; Secure";
    client_max_body_size 0;
}
```

## Links

* Source: [EpicMorg/docker](https://github.com/EpicMorg/docker) - issues and PRs welcome
* Tags float and are rebuilt weekly; pin by digest for reproducible builds: [Tags, pinning and updates](https://github.com/EpicMorg/docker#tags-pinning-and-updates)
* [CHANGELOG](https://github.com/EpicMorg/docker/blob/master/CHANGELOG.md) - License: MIT
