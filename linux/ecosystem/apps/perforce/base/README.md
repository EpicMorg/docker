<!-- hub-description: Perforce Helix Core (P4) server and tools binaries on Debian 13 trixie, r16.2-r26.1 -->
# `epicmorg/perforce`

Perforce Helix Core binaries for one release per tag, on
[`epicmorg/debian:trixie`](https://github.com/EpicMorg/docker/tree/master/linux/ecosystem/base/debian).
A base image: it has no entrypoint and starts nothing by itself - build your own server, broker or
proxy image on top of it (see [`epicmorg/p4p`](https://github.com/EpicMorg/docker/tree/master/linux/ecosystem/apps/perforce/p4p)).

## What's inside

The official Linux x86_64 binaries of the tagged release from `filehost.perforce.com`, in `/usr/bin`:

* `p4` (client), `p4d` (server), `p4broker`, `p4p` (proxy), `perfmerge`, `perfsplit`;
* older releases also `p4ftpd`; newer ones also `p4dctl`, `p4migrate`, `p4mon-prometheus-exporter`.

Working directory: `/perforce`. Each binary path is also exported (`P4_BIN`, `P4D_BIN`, `P4P_BIN`, …).

## Tags

<!-- readme-sync:tags:begin -->
| Tags | Dockerfile |
| ---- | ---------- |
| `r16.2` | [`r16.2`](r16.2/Dockerfile) |
| `r17.1` | [`r17.1`](r17.1/Dockerfile) |
| `r17.2` | [`r17.2`](r17.2/Dockerfile) |
| `r18.1` | [`r18.1`](r18.1/Dockerfile) |
| `r18.2` | [`r18.2`](r18.2/Dockerfile) |
| `r19.1` | [`r19.1`](r19.1/Dockerfile) |
| `r19.2` | [`r19.2`](r19.2/Dockerfile) |
| `r20.1` | [`r20.1`](r20.1/Dockerfile) |
| `r20.2` | [`r20.2`](r20.2/Dockerfile) |
| `r21.1` | [`r21.1`](r21.1/Dockerfile) |
| `r21.2` | [`r21.2`](r21.2/Dockerfile) |
| `r22.1` | [`r22.1`](r22.1/Dockerfile) |
| `r23.1` | [`r23.1`](r23.1/Dockerfile) |
| `r23.2` | [`r23.2`](r23.2/Dockerfile) |
| `r24.1` | [`r24.1`](r24.1/Dockerfile) |
| `r24.2` | [`r24.2`](r24.2/Dockerfile) |
| `r25.1` | [`r25.1`](r25.1/Dockerfile) |
| `r25.2` | [`r25.2`](r25.2/Dockerfile) |
| `r26.1` | [`r26.1`](r26.1/Dockerfile) |

Every tag is pushed to `docker.io`, `quay.io` and `ghcr.io` (`epicmorg/perforce:<tag>` on each) - same digest everywhere.
<!-- readme-sync:tags:end -->

## Usage

```dockerfile
FROM epicmorg/perforce:r24.2
# your p4d / p4broker setup, entrypoint, volumes ...
```

```sh
docker run --rm epicmorg/perforce:r24.2 p4 -V
```

## Notes

* Tags are Perforce release names (`r16.2` … `r26.1`); each one downloads that release's binaries.

## Links

* Source: [EpicMorg/docker](https://github.com/EpicMorg/docker) - issues and PRs welcome
* Tags float and are rebuilt weekly; pin by digest for reproducible builds: [Tags, pinning and updates](https://github.com/EpicMorg/docker#tags-pinning-and-updates)
* [CHANGELOG](https://github.com/EpicMorg/docker/blob/master/CHANGELOG.md) - License: MIT
