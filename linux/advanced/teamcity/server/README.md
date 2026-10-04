<!-- hub-description: JetBrains TeamCity server + p4, git/git-lfs/gh, Maven, Gradle, Kotlin, extra CAs -->
# `epicmorg/teamcity-server`

The official [`jetbrains/teamcity-server`](https://hub.docker.com/r/jetbrains/teamcity-server) image,
one tag per TeamCity release, with the tooling and settings we need on top. TeamCity itself, its JRE,
start-up scripts, ports and data layout are unchanged - everything from the
[upstream documentation](https://www.jetbrains.com/help/teamcity/teamcity-docker-images.html) applies.

## What's inside

On top of `jetbrains/teamcity-server:<tag>` (Ubuntu):

* fresh `git` (git-core PPA), `git-lfs`, GitHub CLI `gh`;
* Perforce `p4` client `r26.1` (replaces the one shipped upstream);
* Maven `3.9.16`, Gradle `8.14.5`, Kotlin compiler + Kotlin/Native `2.4.10`, official 7-Zip `7zz`,
  `dumb-init`, `gosu`, `aria2` and the usual CLI tools (`curl`, `jq`, `rsync`, `mc`, `htop`, `tmux`, …);
* EpicMorg root / intermediate CAs and the Russian trusted root / sub CAs, added to the system store
  **and** to the server JRE `cacerts`;
* generated locales; apt sources rewritten for the Ubuntu release of each upstream tag (old tags are
  focal / jammy) with third-party lists cleaned up.

The image stays on `USER root` (upstream switches to `tcuser`), so mounted volumes need no ownership changes.

## Tags

<!-- readme-sync:tags:begin -->
| Tags | Dockerfile |
| ---- | ---------- |
| `2022.04.7` | [`2022.04.7`](2022.04.7/Dockerfile) |
| `2022.10.6` | [`2022.10.6`](2022.10.6/Dockerfile) |
| `2023.05.6` | [`2023.05.6`](2023.05.6/Dockerfile) |
| `2024.03.3` | [`2024.03.3`](2024.03.3/Dockerfile) |
| `2024.07.3` | [`2024.07.3`](2024.07.3/Dockerfile) |
| `2024.12` | [`2024.12`](2024.12/Dockerfile) |
| `2025.03` | [`2025.03`](2025.03/Dockerfile) |
| `2025.07.3` | [`2025.07.3`](2025.07.3/Dockerfile) |
| `2025.11.8` | [`2025.11.8`](2025.11.8/Dockerfile) |
| `2026.1` | [`2026.1`](2026.1/Dockerfile) |
| `2026.1.1` | [`2026.1.1`](2026.1.1/Dockerfile) |
| `2026.1.4` | [`2026.1.4`](2026.1.4/Dockerfile) |
| `2026.2` | [`2026.2`](2026.2/Dockerfile) |
| `latest` | [`latest`](latest/Dockerfile) |

Every tag is pushed to `docker.io`, `quay.io` and `ghcr.io` (`epicmorg/teamcity-server:<tag>` on each) - same digest everywhere.
<!-- readme-sync:tags:end -->

## Usage

Same as upstream: the web UI listens on `8111`, data lives in `/data/teamcity_server/datadir`,
logs in `/opt/teamcity/logs`.

```yaml
services:
  teamcity:
    image: epicmorg/teamcity-server:2026.2
    restart: unless-stopped
    ports:
      - "8111:8111"
    volumes:
      - teamcity-data:/data/teamcity_server/datadir
      - teamcity-logs:/opt/teamcity/logs
volumes:
  teamcity-data:
  teamcity-logs:
```

Agents: [`epicmorg/teamcity-agent`](https://github.com/EpicMorg/docker/tree/master/linux/ecosystem/apps/teamcity/agent).

## Notes

* Pin a release tag (`2026.2`, `2025.11.8`, …) in production; `latest` follows `jetbrains/teamcity-server:latest`
  and upgrades the server (and its data directory) when it moves.
* Upgrading TeamCity across major versions migrates the data directory - back it up first.

## Links

* Source: [EpicMorg/docker](https://github.com/EpicMorg/docker) - issues and PRs welcome
* Tags float and are rebuilt weekly; pin by digest for reproducible builds: [Tags, pinning and updates](https://github.com/EpicMorg/docker#tags-pinning-and-updates)
* [CHANGELOG](https://github.com/EpicMorg/docker/blob/master/CHANGELOG.md) - License: MIT
