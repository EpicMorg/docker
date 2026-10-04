<!-- hub-description: Go 1.25-1.27 toolchains on epicmorg/debian:trixie-develop-light -->
# `epicmorg/go`

The official Go toolchain (`go.dev/dl` linux-amd64 builds) on top of
[`epicmorg/debian:trixie-develop-light`](https://github.com/EpicMorg/docker/tree/master/linux/ecosystem/base/debian),
so cgo has a full Debian C toolchain at hand. Also carries the
[llvm-mingw](https://github.com/mstorsjo/llvm-mingw) release packages.

## What's inside

| Tag | Go |
| --- | -- |
| `1.25` | `1.25.14` |
| `1.26` | `1.26.8` |
| `1.27` | `1.27.1` |

* `GOROOT=/usr/local/share/epicmorg/go/<minor>`, `GOPATH=${GOROOT}/gopath`;
  `go` and `${GOPATH}/bin` are on `PATH`.
* llvm-mingw `20260826` release archives (msvcrt and ucrt variants) under
  `LLVM_MINGW_DIR=/usr/local/share/epicmorg/llvm-mingw/20260826`.

## Tags

<!-- readme-sync:tags:begin -->
| Tags | Dockerfile |
| ---- | ---------- |
| `1.25` | [`1.25`](1.25/Dockerfile) |
| `1.26` | [`1.26`](1.26/Dockerfile) |
| `1.27` | [`1.27`](1.27/Dockerfile) |

Every tag is pushed to `docker.io`, `quay.io` and `ghcr.io` (`epicmorg/go:<tag>` on each) - same digest everywhere.
<!-- readme-sync:tags:end -->

## Usage

```dockerfile
FROM epicmorg/go:1.26 AS build
WORKDIR /src
COPY . .
RUN go build -o /out/app ./cmd/app

FROM epicmorg/debian:trixie
COPY --from=build /out/app /usr/local/bin/app
CMD ["app"]
```

```sh
docker run --rm -v "$PWD":/src -w /src epicmorg/go:1.26 go test ./...
```

## Links

* Source: [EpicMorg/docker](https://github.com/EpicMorg/docker) - issues and PRs welcome
* Tags float and are rebuilt weekly; pin by digest for reproducible builds: [Tags, pinning and updates](https://github.com/EpicMorg/docker#tags-pinning-and-updates)
* [CHANGELOG](https://github.com/EpicMorg/docker/blob/master/CHANGELOG.md) - License: MIT
