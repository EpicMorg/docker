<!-- hub-description: Mattermost server 10.x-12.x repackaged on epicmorg/debian:trixie -->
# `epicmorg/mattermost-enterprise-edition`

The [Mattermost](https://mattermost.com/) server, repackaged onto our
[`epicmorg/debian:trixie`](https://github.com/EpicMorg/docker/tree/master/linux/ecosystem/base/debian)
base instead of the vendor's Ubuntu image.

## What's inside

* `/mattermost` (server, `mmctl`, client, bundled plugins) copied from
  `mattermost/mattermost-enterprise-edition:release-<version>`; the vendor image is only used as a
  build stage and is smoke-tested there (`mattermost version`);
* runtime: `epicmorg/debian:trixie` (our CA bundle, locales, tools), `tini` as PID 1;
* user `mattermost`, UID/GID `2000` (build args `PUID` / `PGID`), working dir `/mattermost`;
* `MM_SERVICESETTINGS_ENABLELOCALMODE=true` - `mmctl --local` works inside the container; the
  healthcheck uses it (`mmctl system status --local`);
* exposed ports: `8065` (HTTP), `8067` (metrics), `8074` / `8075` (cluster);
* volumes: `/mattermost/data`, `/mattermost/logs`, `/mattermost/config`, `/mattermost/plugins`,
  `/mattermost/client/plugins`.

Tags: `<major>.<minor>` follows the vendor's `release-<major>.<minor>`; the bare major (`10`, `11`,
`12`) follows `release-<major>` (latest minor of that major).

## Tags

<!-- readme-sync:tags:begin -->
| Tags | Dockerfile |
| ---- | ---------- |
| `10` | [`10/10-stable`](10/10-stable/Dockerfile) |
| `10.0` | [`10/10.0`](10/10.0/Dockerfile) |
| `10.1` | [`10/10.1`](10/10.1/Dockerfile) |
| `10.2` | [`10/10.2`](10/10.2/Dockerfile) |
| `10.3` | [`10/10.3`](10/10.3/Dockerfile) |
| `10.4` | [`10/10.4`](10/10.4/Dockerfile) |
| `10.5` | [`10/10.5`](10/10.5/Dockerfile) |
| `10.6` | [`10/10.6`](10/10.6/Dockerfile) |
| `10.7` | [`10/10.7`](10/10.7/Dockerfile) |
| `10.8` | [`10/10.8`](10/10.8/Dockerfile) |
| `10.9` | [`10/10.9`](10/10.9/Dockerfile) |
| `10.10` | [`10/10.10`](10/10.10/Dockerfile) |
| `10.11` | [`10/10.11`](10/10.11/Dockerfile) |
| `10.12` | [`10/10.12`](10/10.12/Dockerfile) |
| `11` | [`11/11-stable`](11/11-stable/Dockerfile) |
| `11.0` | [`11/11.0`](11/11.0/Dockerfile) |
| `11.1` | [`11/11.1`](11/11.1/Dockerfile) |
| `11.2` | [`11/11.2`](11/11.2/Dockerfile) |
| `11.3` | [`11/11.3`](11/11.3/Dockerfile) |
| `11.4` | [`11/11.4`](11/11.4/Dockerfile) |
| `11.5` | [`11/11.5`](11/11.5/Dockerfile) |
| `11.6` | [`11/11.6`](11/11.6/Dockerfile) |
| `11.7` | [`11/11.7`](11/11.7/Dockerfile) |
| `11.8` | [`11/11.8`](11/11.8/Dockerfile) |
| `11.9` | [`11/11.9`](11/11.9/Dockerfile) |
| `11.10` | [`11/11.10`](11/11.10/Dockerfile) |
| `11.11` | [`11/11.11`](11/11.11/Dockerfile) |
| `12` | [`12/12-stable`](12/12-stable/Dockerfile) |
| `12.0` | [`12/12.0`](12/12.0/Dockerfile) |

Every tag is pushed to `docker.io`, `quay.io` and `ghcr.io` (`epicmorg/mattermost-enterprise-edition:<tag>` on each) - same digest everywhere.
<!-- readme-sync:tags:end -->

## Usage

```yml
services:
  mattermost:
    image: epicmorg/mattermost-enterprise-edition:12
    restart: unless-stopped
    ports:
      - "8065:8065"
    environment:
      MM_SQLSETTINGS_DRIVERNAME: postgres
      MM_SQLSETTINGS_DATASOURCE: postgres://mmuser:password@postgres:5432/mattermost?sslmode=disable&connect_timeout=10
      MM_SERVICESETTINGS_SITEURL: https://chat.example.com
    volumes:
      - ./config:/mattermost/config
      - ./data:/mattermost/data
      - ./logs:/mattermost/logs
      - ./plugins:/mattermost/plugins
      - ./client-plugins:/mattermost/client/plugins
```

Host directories must be writable by UID `2000`. Configuration is done with `MM_*` environment
variables or `config.json` - see the
[Mattermost configuration settings](https://docs.mattermost.com/configure/configuration-settings.html).

## Notes

* The `mattermost` server binary is modified at build time (see `edit.py` next to each
  Dockerfile); it is not byte-identical to the vendor binary.
* Upgrade between majors along the vendor's supported upgrade path.

## Links

* Source: [EpicMorg/docker](https://github.com/EpicMorg/docker) - issues and PRs welcome
* Tags float and are rebuilt weekly; pin by digest for reproducible builds: [Tags, pinning and updates](https://github.com/EpicMorg/docker#tags-pinning-and-updates)
* [CHANGELOG](https://github.com/EpicMorg/docker/blob/master/CHANGELOG.md) - License: MIT
