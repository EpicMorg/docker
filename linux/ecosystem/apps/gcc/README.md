<!-- hub-description: GCC 4.9-16 C/C++ toolchains built from source on epicmorg/debian:trixie-develop -->
# `epicmorg/gcc`

GNU Compiler Collection, one major version per tag, built from the upstream
release tarballs (`ftp.gnu.org`) on top of
[`epicmorg/debian:trixie-develop`](https://github.com/EpicMorg/docker/tree/master/linux/ecosystem/base/debian).
These images are the build stages for our runtimes (Python, nginx, ...) and a
ready toolchain for anything that needs an older or newer compiler than Debian's.

## What's inside

| Tag | GCC |
| --- | --- |
| `4` | `4.9.4` |
| `5` - `12` | `<major>.5.0` |
| `13`, `14` | `<major>.4.0` |
| `15` | `15.3.0` |
| `16` | `16.2.0` |

* Languages: C and C++ (`--enable-languages=c,c++`), 64-bit only (`--disable-multilib`),
  multiarch-aware (`--enable-multiarch`, finds `/usr/include/x86_64-linux-gnu`),
  PIE by default, POSIX threads, system zlib.
* Installed into `GCC_INSTALL_DIR=/usr/local/share/epicmorg/gcc/<major>`, whose
  `bin` is **first** on `PATH`. `GCC_VERSION` holds the full version.
* Everything from `trixie-develop` is there as well: prebuilt OpenSSL / curl /
  libpq / ICU / libxml2 / zlib / zstd under `/usr/local/share/epicmorg`, CMake,
  Ninja, Debian's own toolchain.

## Tags

<!-- readme-sync:tags:begin -->
| Tags | Dockerfile |
| ---- | ---------- |
| `4` | [`04`](04/Dockerfile) |
| `5` | [`05`](05/Dockerfile) |
| `6` | [`06`](06/Dockerfile) |
| `7` | [`07`](07/Dockerfile) |
| `8` | [`08`](08/Dockerfile) |
| `9` | [`09`](09/Dockerfile) |
| `10` | [`10`](10/Dockerfile) |
| `11` | [`11`](11/Dockerfile) |
| `12` | [`12`](12/Dockerfile) |
| `13` | [`13`](13/Dockerfile) |
| `14` | [`14`](14/Dockerfile) |
| `15` | [`15`](15/Dockerfile) |
| `16` | [`16`](16/Dockerfile) |

Every tag is pushed to `docker.io`, `quay.io` and `ghcr.io` (`epicmorg/gcc:<tag>` on each) - same digest everywhere.
<!-- readme-sync:tags:end -->

## Usage

```dockerfile
FROM epicmorg/gcc:14 AS build
WORKDIR /src
COPY . .
RUN gcc --version && ./configure --prefix=/usr/local/share/epicmorg/myapp && make -j"$(nproc)" && make install

FROM epicmorg/debian:trixie
COPY --from=build /usr/local/share/epicmorg/myapp /usr/local/share/epicmorg/myapp
```

## Notes

* **`gcc` is not `cc`.** `gcc` / `g++` on `PATH` are this image's compiler;
  `cc` / `c++` are still Debian's system gcc 14. Build systems that prefer `cc`
  (PHP's autoconf, for example) silently use Debian's compiler - check which one
  your build picks up.
* Whoever builds a library builds its consumers: C++ code linked against
  libraries compiled by a newer gcc may need that newer `libstdc++`
  (`GLIBCXX_3.4.x` errors). Use the same image for both.
* These are build images (20+ GB together with `trixie-develop`), not runtime bases.

## Links

* Source: [EpicMorg/docker](https://github.com/EpicMorg/docker) - issues and PRs welcome
* Tags float and are rebuilt weekly; pin by digest for reproducible builds: [Tags, pinning and updates](https://github.com/EpicMorg/docker#tags-pinning-and-updates)
* [CHANGELOG](https://github.com/EpicMorg/docker/blob/master/CHANGELOG.md) - License: MIT
