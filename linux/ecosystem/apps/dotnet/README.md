<!-- hub-description: .NET SDK 5-10, LTS, STS and preview channels on epicmorg/debian:trixie -->
# `epicmorg/dotnet`

The .NET SDK installed with Microsoft's official
[`dotnet-install.sh`](https://learn.microsoft.com/dotnet/core/tools/dotnet-install-script)
on top of [`epicmorg/debian:trixie`](https://github.com/EpicMorg/docker/tree/master/linux/ecosystem/base/debian).
One channel per tag, always the newest release of that channel at build time.

## What's inside

| Tag | Channel |
| --- | ------- |
| `5` - `10` | `5.0` ... `10.0` |
| `lts` | current Long Term Support release (`--channel LTS`) |
| `sts` | current Standard Term Support release (`--channel STS`) |
| `preview` | `11.0`, preview quality |

* SDK in `DOTNET_ROOT=/usr/local/share/epicmorg/dotnet/<channel>`; `DOTNET_ROOT`
  and `DOTNET_ROOT/tools` (global tools) are on `PATH`.
* `DOTNET_CLI_TELEMETRY_OPTOUT=true`, `DOTNET_SKIP_FIRST_TIME_EXPERIENCE=true`.
* The base image's CA certificates (incl. EpicMorg CA) are in the system store
  that .NET uses on Linux.

## Tags

<!-- readme-sync:tags:begin -->
| Tags | Dockerfile |
| ---- | ---------- |
| `5` | [`dotnet5`](dotnet5/Dockerfile) |
| `6` | [`dotnet6`](dotnet6/Dockerfile) |
| `7` | [`dotnet7`](dotnet7/Dockerfile) |
| `8` | [`dotnet8`](dotnet8/Dockerfile) |
| `9` | [`dotnet9`](dotnet9/Dockerfile) |
| `10` | [`dotnet10`](dotnet10/Dockerfile) |
| `lts` | [`lts`](lts/Dockerfile) |
| `preview` | [`preview`](preview/Dockerfile) |
| `sts` | [`sts`](sts/Dockerfile) |

Every tag is pushed to `docker.io`, `quay.io` and `ghcr.io` (`epicmorg/dotnet:<tag>` on each) - same digest everywhere.
<!-- readme-sync:tags:end -->

## Usage

```sh
docker run --rm epicmorg/dotnet:lts dotnet --info
```

```dockerfile
FROM epicmorg/dotnet:10 AS build
WORKDIR /src
COPY . .
RUN dotnet publish -c Release -o /out

FROM epicmorg/dotnet:10
COPY --from=build /out /opt/app
CMD ["dotnet", "/opt/app/MyApp.dll"]
```

## Notes

* `5`, `6`, `7` and `9` are out of support upstream; they are kept for legacy
  builds. `lts` / `sts` / `preview` move to a new major when Microsoft does.

## Links

* Source: [EpicMorg/docker](https://github.com/EpicMorg/docker) - issues and PRs welcome
* Tags float and are rebuilt weekly; pin by digest for reproducible builds: [Tags, pinning and updates](https://github.com/EpicMorg/docker#tags-pinning-and-updates)
* [CHANGELOG](https://github.com/EpicMorg/docker/blob/master/CHANGELOG.md) - License: MIT
