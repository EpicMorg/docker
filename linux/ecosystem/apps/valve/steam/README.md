<!-- hub-description: SteamCMD base and Steam Runtime SDK build images on Debian trixie -->
# `epicmorg/steam`

Valve tooling images: a SteamCMD base for game servers and the Steam Runtime SDK for building
Linux games and plugins against the Steam runtime.

## What's inside

| Tag | Base | Content |
| --- | --- | --- |
| `cmd` | `epicmorg/debian:trixie` | [SteamCMD](https://developer.valvesoftware.com/wiki/SteamCMD) in `/usr/local/share/epicmorg/valve/steamcmd` (on `PATH` as `steamcmd`, also linked as `/root/Steam`), i386 multilib (`gcc-multilib`, `lib32stdc++6`, `lib32gcc-s1`); bootstrapped with `steamcmd +quit` at build time |
| `runtime-sdk` | `epicmorg/debian:trixie-develop` | `steam-runtime-sdk_latest` in `/usr/local/share/epicmorg/valve/steam/runtime-sdk/latest`, set up with the **release** runtime |
| `runtime-sdk-debug` | `epicmorg/debian:trixie-develop` | the same SDK set up with the **debug** runtime (`Dockerfile.debug`) |

`cmd` layout (all under `/usr/local/share/epicmorg/valve`):

| Variable | Path | Purpose |
| --- | --- | --- |
| `VALVE_STEAMCMD_FOLDER` | `…/valve/steamcmd` | SteamCMD itself (workdir) |
| `VALVE_STEAMCMD_LOGS` | `…/valve/steamcmd/logs` | SteamCMD logs (volume) |
| `VALVE_GAME_FOLDER` | `…/valve/game` | install target for game servers |
| `VALVE_VOLUME_FOLDER` | `…/valve/volume` | persistent data (volume) |

## Tags

<!-- readme-sync:tags:begin -->
| Tags | Dockerfile |
| ---- | ---------- |
| `cmd` | [`cmd`](cmd/Dockerfile) |
| `runtime-sdk`, `runtime-sdk-debug` | [`runtime-sdk`](runtime-sdk/Dockerfile) |

Every tag is pushed to `docker.io`, `quay.io` and `ghcr.io` (`epicmorg/steam:<tag>` on each) - same digest everywhere.
<!-- readme-sync:tags:end -->

## Usage

`cmd` is a base image — derive your game server from it:

```dockerfile
FROM docker.io/epicmorg/steam:cmd
RUN steamcmd +force_install_dir ${VALVE_GAME_FOLDER} +login anonymous +app_update <app_id> validate +quit
```

or run SteamCMD directly:

```sh
docker run --rm -it -v steam-data:/usr/local/share/epicmorg/valve/volume epicmorg/steam:cmd \
  steamcmd +login anonymous +quit
```

`runtime-sdk` is a build environment: the SDK's `shell.sh`, `shell-amd64.sh` and `shell-i386.sh`
enter the runtime chroot for the matching architecture.

```sh
docker run --rm -it -v "$PWD":/src epicmorg/steam:runtime-sdk ./shell-amd64.sh
```

## Links

* Source: [EpicMorg/docker](https://github.com/EpicMorg/docker) - issues and PRs welcome
* Tags float and are rebuilt weekly; pin by digest for reproducible builds: [Tags, pinning and updates](https://github.com/EpicMorg/docker#tags-pinning-and-updates)
* [CHANGELOG](https://github.com/EpicMorg/docker/blob/master/CHANGELOG.md) - License: MIT
