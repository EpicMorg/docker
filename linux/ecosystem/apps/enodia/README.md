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
* `2.0.0`+: `/usr/local/bin/enodia-cve-update` — downloads the CVE databases that image's Enodia
  version reads into `/var/lib/enodia/cve` (a volume); see [CVE databases](#cve-databases). The
  databases are not baked into the image

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

## CVE databases

Enodia `2.0.0`+ can match versions against local CVE databases (`cve.*.path` in `enodia.yaml`) but
never downloads them itself. Each `2.x` image ships `enodia-cve-update`, which fetches exactly the
ones its Enodia version reads:

| Image | Databases |
| ----- | --------- |
| `2.0.0` | NVD (JSON 2.0, per year), BDU FSTEC |
| `2.1.0`, `2.1.1` | the above + Debian Security Tracker, vendor OVAL (`ENODIA_OVAL`), Alpine secdb (`ENODIA_ALPINE`) |

Run it on a host directory (or a named volume) and give the same directory to `check`/`serve`:

```sh
# refresh — e.g. nightly from cron; unchanged files cost one request each
docker run --rm --entrypoint enodia-cve-update \
  -v /var/lib/enodia/cve:/var/lib/enodia/cve \
  -e ENODIA_OVAL="ubuntu:noble rhel:9 astra:1.8" -e ENODIA_ALPINE="v3.22" \
  epicmorg/enodia:2

# use
docker run --rm \
  -v /etc/enodia:/etc/enodia:ro -v /var/lib/enodia/cve:/var/lib/enodia/cve:ro \
  epicmorg/enodia:2 check --config /etc/enodia/config.yaml
```

```yaml
# enodia.yaml (2.1.x; 2.0.0 has bdu and nvd only)
cve:
  bdu:    {path: /var/lib/enodia/cve/bdu/vulxml.zip}
  nvd:    {path: /var/lib/enodia/cve/nvd}
  debian: {path: /var/lib/enodia/cve/debian.json}
  oval:   {path: /var/lib/enodia/cve/oval}
  alpine: {path: /var/lib/enodia/cve/alpine}
```

| Variable | Default | Meaning |
| -------- | ------- | ------- |
| `ENODIA_CVE_DIR` | `/var/lib/enodia/cve` | target directory (or the first argument) |
| `ENODIA_NVD_YEARS` | `all` | `all`: every year from 2002; `recent`: this year and last, plus years not on disk yet |
| `ENODIA_BDU_INSECURE` | `1` | don't verify bdu.fstec.ru's certificate (Russian Trusted Root CA, no intermediate sent); `0` to verify, with `ENODIA_BDU_CA_FILE` naming a bundle of the root and Sub CA |
| `ENODIA_DEBIAN` | `1` | `2.1.x`: fetch the Debian Security Tracker JSON |
| `ENODIA_OVAL` | — | `2.1.x`: releases to fetch OVAL for: `ubuntu:<codename>`, `rhel:<N>` (also for Rocky), `almalinux:<N>`, `oracle:<N>`, `astra:<1.7\|1.8>`, `redos:<7.3\|8.0>` |
| `ENODIA_ALPINE` | — | `2.1.x`: Alpine branches, e.g. `v3.21 v3.22` (main and community each) |

Every file is fetched with If-Modified-Since into a temporary name, checked (gzip / zip / bz2 / JSON /
XML) and only then moved over the old copy, so a failed or broken download never replaces a working
database. The exit code is 1 if any file failed; the others are still updated. The first run fetches
everything (NVD alone is ~230 MB); after that Enodia re-parses a changed file once and caches it.

## Notes

* Enodia is licensed under AGPL-3.0-or-later; this repository's build files are MIT.
* The image is built and published from this repository on its own schedule, not by Enodia's
  release pipeline.

## Links

* Source: [EpicMorg/docker](https://github.com/EpicMorg/docker) - issues and PRs welcome
* Tags float and are rebuilt weekly; pin by digest for reproducible builds: [Tags, pinning and updates](https://github.com/EpicMorg/docker#tags-pinning-and-updates)
* [CHANGELOG](https://github.com/EpicMorg/docker/blob/master/CHANGELOG.md) - License: MIT
