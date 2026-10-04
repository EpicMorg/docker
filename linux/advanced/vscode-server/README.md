<!-- hub-description: code-server (VS Code in the browser) with dev toolchains: C++/Rust/Go, Android, .NET, node -->
# `epicmorg/vscode-server`

[code-server](https://github.com/coder/code-server) - VS Code in the browser - based on
[`linuxserver/code-server`](https://docs.linuxserver.io/images/docker-code-server/) (Ubuntu), with a
set of development toolchains on top. Startup, users, ports and settings are the linuxserver ones.

## What's inside

| Tag | Built from | Adds |
| --- | --- | --- |
| `latest` | `ghcr.io/linuxserver/code-server:latest` | fresh `git` (git-core PPA), `git-lfs`, `gh`, Perforce `p4` `r24.1`, 7-Zip `7zz`, `dumb-init`, `gosu`, `aria2`, Python 3, common CLI tools (`curl`, `jq`, `mc`, `htop`, `tmux`, `rsync`, `nmap`, …), EpicMorg / Russian trusted CAs, generated locales |
| `cpp` | `latest` | `build-essential`, `clang`, multilib, several CMake releases (3.16 … 4.0), Ninja `1.13.1`, Rust (`rustup` / `cargo`), Go `1.25`, Flutter `3.35` (stable), Steam Runtime SDK |
| `android` | `cpp` | JDK 17, Maven, Gradle, Kotlin compiler + Kotlin/Native, Debian `android-sdk` + `sdkmanager` |
| `docker` | `latest` | Docker CE CLI / engine, buildx and compose plugins, `buildah`, `podman`, `podman-compose`, `fuse-overlayfs`, `buildah-wrapper` / `kaniko-wrapper` |
| `dotnet` | `latest` | .NET SDK (`STS` channel) |
| `dotnet-full` | `latest` | .NET SDK (`STS`) + Ubuntu `mono-complete`, `mono-devel`, `mono-xsp4` |
| `mono` | `latest` | Ubuntu `mono-complete`, `mono-devel`, `mono-dbg`, `ca-certificates-mono`, `mono-xsp4` |
| `nodejs` | `latest` | Node.js 22 (release tarball from nodejs.org) |
| `amxx`, `amxx-rc` | `latest` | [AMX Mod X](https://www.amxmodx.org/) 1.9 / 1.10 compiler |

Tools the project installs live under `/usr/local/share/epicmorg`.

## Tags

<!-- readme-sync:tags:begin -->
| Tags | Dockerfile |
| ---- | ---------- |
| `amxx` | [`amxx/1.9`](amxx/1.9/Dockerfile) |
| `amxx-rc` | [`amxx/1.10`](amxx/1.10/Dockerfile) |
| `android` | [`android`](android/Dockerfile) |
| `cpp` | [`cpp`](cpp/Dockerfile) |
| `docker` | [`docker`](docker/Dockerfile) |
| `dotnet` | [`dotnet`](dotnet/Dockerfile) |
| `dotnet-full` | [`dotnet-full`](dotnet-full/Dockerfile) |
| `latest` | [`latest`](latest/Dockerfile) |
| `mono` | [`mono`](mono/Dockerfile) |
| `nodejs` | [`nodejs`](nodejs/Dockerfile) |

Every tag is pushed to `docker.io`, `quay.io` and `ghcr.io` (`epicmorg/vscode-server:<tag>` on each) - same digest everywhere.
<!-- readme-sync:tags:end -->

## Usage

Configuration is the [linuxserver one](https://docs.linuxserver.io/images/docker-code-server/): the UI is on
port `8443`, settings and extensions live in `/config`, the usual `PUID` / `PGID` / `TZ` variables apply and
`PASSWORD` (or `HASHED_PASSWORD`) protects the UI.

```yaml
services:
  code-server:
    image: epicmorg/vscode-server:cpp
    restart: unless-stopped
    environment:
      PUID: "1000"
      PGID: "1000"
      TZ: "Etc/UTC"
      PASSWORD: "change-me"
    ports:
      - "8443:8443"
    volumes:
      - code-config:/config
volumes:
  code-config:
```

For the `docker` tag, mount the host socket to work with the host Docker daemon:
`-v /var/run/docker.sock:/var/run/docker.sock`.

## Notes

* Unlike the rest of the repository this image is Ubuntu-based (it follows `linuxserver/code-server:latest`);
  `latest` is rebuilt whenever the upstream image moves.
* Mono comes from Ubuntu's own packages: `download.mono-project.com` is no longer maintained.

## Links

* Source: [EpicMorg/docker](https://github.com/EpicMorg/docker) - issues and PRs welcome
* Tags float and are rebuilt weekly; pin by digest for reproducible builds: [Tags, pinning and updates](https://github.com/EpicMorg/docker#tags-pinning-and-updates)
* [CHANGELOG](https://github.com/EpicMorg/docker/blob/master/CHANGELOG.md) - License: MIT
