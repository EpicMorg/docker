<!-- hub-description: Astra Linux SE 1.7 and 1.8 base images by EpicMorg: rootfs, light, main, develop -->
# `epicmorg/astralinux`

Base images for **Astra Linux Special Edition** (`alse`)
`1.7` and `1.8`, built the same way as our Debian images
([`epicmorg/debian`](https://github.com/EpicMorg/docker/tree/master/linux/ecosystem/base/debian)):

| Tag | Built from | What it adds |
| --- | ---------- | ------------ |
| `<ver>-rootfs` | Astra rootfs | the plain Astra Linux root filesystem with official `dl.astralinux.ru` apt repositories; squashed |
| `<ver>-light` | `-rootfs` | our apt settings, locales, CA certificates (incl. EpicMorg CA), basic utilities, `/etc/ssl/dhparam.pem`; squashed |
| `<ver>-main` | `-light` | more tooling: fresh `git`, `git-lfs`, `gh`, Perforce `p4` client, official `7-Zip`, `dumb-init`, `gosu` |
| `<ver>-develop-light` | `-main` | compilers and the common `-dev` packages from the Astra repositories |
| `<ver>-develop` | `-develop-light` | heavy build environment: the same set of libraries built from source as `debian:trixie-develop` (OpenSSL branches, curl, libpq, ICU, libxml2, zlib, zstd, ...), CMake, Ninja, Go, Rust, llvm-mingw |

Unlike Debian there is no bare tag: the main layer is `<ver>-main`. There is no
`latest`.

## What's inside

* `1.8` uses the `1.8_x86-64` stable and frozen (`1.8.1`) main and extended repositories.
* `1.7` uses the `1.7_x86-64` stable main and update repositories.
* Everything EpicMorg installs itself lives under `EMG_LOCAL_BASE_DIR=/usr/local/share/epicmorg`;
  libraries in `develop` are linked with a real `RPATH`, nothing is added to `ld.so.conf`.
* `develop` / `develop-light` are build environments: compile there, copy the
  result into a `-main` based image.

## Tags

<!-- readme-sync:tags:begin -->
| Tags | Dockerfile |
| ---- | ---------- |
| `1.7-develop` | [`1.7-alse/develop`](1.7-alse/develop/Dockerfile) |
| `1.7-develop-light` | [`1.7-alse/develop-light`](1.7-alse/develop-light/Dockerfile) |
| `1.7-light` | [`1.7-alse/light`](1.7-alse/light/Dockerfile) |
| `1.7-main` | [`1.7-alse/main`](1.7-alse/main/Dockerfile) |
| `1.7-rootfs` | [`1.7-alse/rootfs`](1.7-alse/rootfs/Dockerfile) |
| `1.8-develop` | [`1.8-alse/develop`](1.8-alse/develop/Dockerfile) |
| `1.8-develop-light` | [`1.8-alse/develop-light`](1.8-alse/develop-light/Dockerfile) |
| `1.8-light` | [`1.8-alse/light`](1.8-alse/light/Dockerfile) |
| `1.8-main` | [`1.8-alse/main`](1.8-alse/main/Dockerfile) |
| `1.8-rootfs` | [`1.8-alse/rootfs`](1.8-alse/rootfs/Dockerfile) |

Every tag is pushed to `docker.io`, `quay.io` and `ghcr.io` (`epicmorg/astralinux:<tag>` on each) - same digest everywhere.
<!-- readme-sync:tags:end -->

## Usage

```dockerfile
FROM epicmorg/astralinux:1.8-main
RUN apt-get update && apt-get install -y --no-install-recommends <packages>
```

```dockerfile
FROM epicmorg/astralinux:1.8-develop AS builder
RUN ./configure --with-openssl="${OPENSSL_35_DIR}" ... && make && make install

FROM epicmorg/astralinux:1.8-main
COPY --from=builder /usr/local/share/epicmorg/myapp /usr/local/share/epicmorg/myapp
```

```sh
docker run --rm -it epicmorg/astralinux:1.8-main bash
```

`EMG_WELCOME_MESSAGE=false` / `EMG_DONATION_MESSAGE=false` silence the interactive shell banner.

## Links

* Source: [EpicMorg/docker](https://github.com/EpicMorg/docker) - issues and PRs welcome
* Tags float and are rebuilt weekly; pin by digest for reproducible builds: [Tags, pinning and updates](https://github.com/EpicMorg/docker#tags-pinning-and-updates)
* [CHANGELOG](https://github.com/EpicMorg/docker/blob/master/CHANGELOG.md) - License: MIT
