<!-- hub-description: Perforce Helix proxy (p4p) on Debian 13 trixie, one tag per release r16.2-r24.2 -->
# `epicmorg/p4p`

The Perforce Helix proxy (`p4p`) as a container: built `FROM`
[`epicmorg/perforce:<release>`](https://github.com/EpicMorg/docker/tree/master/linux/ecosystem/apps/perforce/base)
on Debian 13 `trixie`, runs `p4p` under `tini` and caches file content in front of a remote Helix server.

## What's inside

* everything from `epicmorg/perforce:<release>` (the Helix binaries of that release);
* entrypoint that starts `p4p -p ${P4PORT} -t ${P4TARGET} -L ${P4LOG} ${P4ARGS}`;
* volumes `/perforce/cache` and `/perforce/logs`, port `1666`.

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

Every tag is pushed to `docker.io`, `quay.io` and `ghcr.io` (`epicmorg/p4p:<tag>` on each) - same digest everywhere.
<!-- readme-sync:tags:end -->

## Usage

| Variable | Default | Meaning |
| --- | --- | --- |
| `P4TARGET` | - | upstream Helix server, e.g. `ssl:perforce.example.com:1666` - **required**, the container exits without it |
| `P4PORT` | `1666` | port the proxy listens on |
| `P4LOG` | `/perforce/logs/p4p.log` | proxy log file |
| `P4ARGS` | - | extra `p4p` arguments |

```yaml
services:
  p4p:
    image: epicmorg/p4p:r24.2
    restart: unless-stopped
    environment:
      P4TARGET: "ssl:perforce.example.com:1666"
    ports:
      - "1666:1666"
    volumes:
      - p4p-cache:/perforce/cache
      - p4p-logs:/perforce/logs
volumes:
  p4p-cache:
  p4p-logs:
```

Clients then use the proxy as their `P4PORT` (`p4 -p proxy-host:1666 ...`).

## Notes

* Use the same release as (or one supported by) your Helix server.

## Links

* Source: [EpicMorg/docker](https://github.com/EpicMorg/docker) - issues and PRs welcome
* Tags float and are rebuilt weekly; pin by digest for reproducible builds: [Tags, pinning and updates](https://github.com/EpicMorg/docker#tags-pinning-and-updates)
* [CHANGELOG](https://github.com/EpicMorg/docker/blob/master/CHANGELOG.md) - License: MIT
