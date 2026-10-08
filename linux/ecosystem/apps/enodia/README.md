<!-- hub-description: Enodia - service version inventory vs vendor lifecycle calendars, CVE correlation -->
# `epicmorg/enodia`

Official container image of [Enodia](https://github.com/EpicMorg/enodia) ([enodia.sh](https://enodia.sh),
[docs](https://docs.enodia.sh)): it asks your deployed services what version they are running, checks
those versions against vendor lifecycle calendars and reports what is already dead, what is dying and
where the fleet has drifted apart. Pipeline: `collect → inventory → evaluate → render`.

## What's inside

* `/usr/bin/enodia` — the release binary (`enodia_linux_amd64.tar.gz`) of the tagged version;
  entrypoint is `enodia`, so container arguments are Enodia subcommands
* base: `epicmorg/debian:trixie-light`; runs as root
* volumes: `/etc/enodia` (config: `enodia.yaml` / `settings.yaml` / `credentials.yaml`) and
  `/opt/enodia` (working directory: `inventory.jsonl`, HTML exports, resolver cache)
* `2.0.0`+: CVE feeds baked in at build time under `/var/lib/enodia/cve` — NVD JSON 2.0 (2002–2026)
  and BDU FSTEC XML — for offline correlation

Alias tags: `latest` and `2` → `2.1.1`, `1` → the newest 1.x; `1.0.0-0` is an alias of `1.0.0`.

## Tags

<!-- readme-sync:tags:begin -->
| Tags | Dockerfile |
| ---- | ---------- |
| `1.0.0`, `1.0.0-0` | [`1.0.0`](1.0.0/Dockerfile) |
| `1.1.0` | [`1.1.0`](1.1.0/Dockerfile) |
| `1.1.1` | [`1.1.1`](1.1.1/Dockerfile) |
| `1.2.0` | [`1.2.0`](1.2.0/Dockerfile) |
| `1.2.1`, `1` | [`1.2.1`](1.2.1/Dockerfile) |
| `2.0.0` | [`2.0.0`](2.0.0/Dockerfile) |
| `2.1.0` | [`2.1.0`](2.1.0/Dockerfile) |
| `2.1.1`, `2`, `latest` | [`2.1.1`](2.1.1/Dockerfile) |

Every tag is pushed to `docker.io`, `quay.io` and `ghcr.io` (`epicmorg/enodia:<tag>` on each) - same digest everywhere.
<!-- readme-sync:tags:end -->

## Usage

```sh
# one-shot check with a config from the host
docker run --rm \
  -v /etc/enodia:/etc/enodia:ro \
  epicmorg/enodia:2 check --config /etc/enodia/config.yaml

# air-gapped: collect inside the closed network, evaluate elsewhere
docker run --rm -v /etc/enodia:/etc/enodia:ro -v "$PWD":/opt/enodia \
  epicmorg/enodia:2 collect --config /etc/enodia/config.yaml -o inventory.jsonl
docker run --rm -v "$PWD":/opt/enodia epicmorg/enodia:2 check --from inventory.jsonl
```

Config format, probes and subcommands: [docs.enodia.sh](https://docs.enodia.sh).

## Notes

* Enodia is licensed under AGPL-3.0-or-later; this repository's build files are MIT.
* The image is built and published from this repository on its own schedule, not by Enodia's
  release pipeline.

## Links

* Source: [EpicMorg/docker](https://github.com/EpicMorg/docker) - issues and PRs welcome
* Tags float and are rebuilt weekly; pin by digest for reproducible builds: [Tags, pinning and updates](https://github.com/EpicMorg/docker#tags-pinning-and-updates)
* [CHANGELOG](https://github.com/EpicMorg/docker/blob/master/CHANGELOG.md) - License: MIT
