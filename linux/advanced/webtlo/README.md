<!-- hub-description: web-TLO (berkut174/webtlo) with extra CA certificates in the system trust store -->
# `epicmorg/webtlo`

[web-TLO](https://github.com/keepers-team/webtlo) - the web version of the TLO tool for torrent
keepers - packaged from the upstream image [`berkut174/webtlo`](https://hub.docker.com/r/berkut174/webtlo).

## What's inside

`berkut174/webtlo:<version>` unchanged, plus extra CA certificates (EpicMorg root / intermediate
CAs, Russian Trusted Root / Sub CAs) added to the system trust store with `update-ca-certificates`.
Nothing else is modified: application, entrypoint, ports, volumes and settings are the upstream ones.

## Tags

<!-- readme-sync:tags:begin -->
| Tags | Dockerfile |
| ---- | ---------- |
| `3.5.6` | [`3.5.6`](3.5.6/Dockerfile) |
| `3.6.0` | [`3.6.0`](3.6.0/Dockerfile) |
| `3.7.0` | [`3.7.0`](3.7.0/Dockerfile) |
| `3.7.1` | [`3.7.1`](3.7.1/Dockerfile) |
| `3.7.2` | [`3.7.2`](3.7.2/Dockerfile) |
| `3.8.0` | [`3.8.0`](3.8.0/Dockerfile) |
| `3.8.1` | [`3.8.1`](3.8.1/Dockerfile) |
| `3.8.2` | [`3.8.2`](3.8.2/Dockerfile) |
| `4.0.0` | [`4.0.0`](4.0.0/Dockerfile) |
| `4.0.1` | [`4.0.1`](4.0.1/Dockerfile) |
| `4.1.0` | [`4.1.0`](4.1.0/Dockerfile) |
| `latest` | [`latest`](latest/Dockerfile) |

Every tag is pushed to `docker.io`, `quay.io` and `ghcr.io` (`epicmorg/webtlo:<tag>` on each) - same digest everywhere.
<!-- readme-sync:tags:end -->

## Usage

Use it exactly like the upstream image - just replace the image name (`berkut174/webtlo` ->
`epicmorg/webtlo`, same tag). Ports, volumes and configuration are documented upstream:
[keepers-team/webtlo](https://github.com/keepers-team/webtlo) and
[`berkut174/webtlo` on Docker Hub](https://hub.docker.com/r/berkut174/webtlo).

## Links

* Source: [EpicMorg/docker](https://github.com/EpicMorg/docker) - issues and PRs welcome
* Tags float and are rebuilt weekly; pin by digest for reproducible builds: [Tags, pinning and updates](https://github.com/EpicMorg/docker#tags-pinning-and-updates)
* [CHANGELOG](https://github.com/EpicMorg/docker/blob/master/CHANGELOG.md) - License: MIT
