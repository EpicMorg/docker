<!-- hub-description: Debian 13 trixie and sid base images by EpicMorg: light, main, develop, develop-light -->
# `epicmorg/debian`

Debian base images used by every other EpicMorg image. Each codename comes as a
small family of layers built on top of each other:

| Tag | Built from | What it adds |
| --- | ---------- | ------------ |
| `<codename>-light` | `debian:<codename>-slim` | our apt sources and settings, locales, CA certificates (incl. EpicMorg CA), basic utilities (`curl`, `wget`, `aria2`, `rsync`, `sudo`, `tini`, `mc`, `htop`, archivers), `/etc/ssl/dhparam.pem` (4096 bit); squashed into one layer |
| `<codename>` (main) | `-light` | more tooling: filesystem tools, fresh `git` (launchpad PPA), `git-lfs`, `gh`, Perforce `p4` client, official `7-Zip` (`7zz`), `dumb-init`, `gosu` |
| `<codename>-develop-light` | main | Debian toolchain (`build-essential`, `clang`, `cmake`, `meson`, autotools) and the common `-dev` packages |
| `<codename>-develop` | `-develop-light` | heavy build environment: prebuilt libraries and toolchains under `/usr/local/share/epicmorg` |

`light` is **not** the vanilla `debian:*-slim` - it is a doctored slim. A bare
codename tag (`epicmorg/debian:trixie`) is the `main` layer. There is **no
`latest`** tag on this repository: always name the codename.

## What's inside

* **`trixie` (Debian 13) is the reference base.** Runtimes and applications of
  this repository are built `FROM epicmorg/debian:trixie` (or `trixie-develop`
  for build stages).
* **`sid`** follows Debian unstable. It is a scouting ground for the next release,
  regressions there are expected - do not base production images on it.
* Everything EpicMorg installs itself goes to `EMG_LOCAL_BASE_DIR=/usr/local/share/epicmorg`;
  system paths and `ld.so.conf` stay untouched.
* **`trixie-develop`** carries libraries built from source with a real `RPATH`
  (no `ld.so.conf` entries), one directory per version:
  OpenSSL `1.0.2u`, `1.1.1w`, `3.0`-`3.6`, `4.0`, LibreSSL, BoringSSL; curl `8.17.0`
  (against OpenSSL 1.0.2 / 1.1.1) and `8.21.0` (against OpenSSL 3.5); libpq `13` and `16`
  per OpenSSL branch; ICU `67.1` and `73.2`; libxml2, libxslt, zlib, zstd, bzip2,
  pcre2, libgd, libimagequant, libraqm, ncurses, libdb, libffi, LuaJIT2 (OpenResty),
  GeoIP / IP2Location, gperftools, libatomic_ops; plus CMake `3.16`-`4.3`, Ninja,
  Go, Rust, Flutter and llvm-mingw.
* `develop` is a **build environment only** - use it as a builder stage and copy
  the results into a `main`-based image.

## Tags

<!-- readme-sync:tags:begin -->
| Tags | Dockerfile |
| ---- | ---------- |
| `trixie-develop` | [`13-trixie/develop`](13-trixie/develop/Dockerfile) |
| `trixie-develop-light` | [`13-trixie/develop-light`](13-trixie/develop-light/Dockerfile) |
| `trixie-light` | [`13-trixie/light`](13-trixie/light/Dockerfile) |
| `trixie` | [`13-trixie/main`](13-trixie/main/Dockerfile) |
| `sid-develop` | [`sid/develop`](sid/develop/Dockerfile) |
| `sid-light` | [`sid/light`](sid/light/Dockerfile) |
| `sid` | [`sid/main`](sid/main/Dockerfile) |

Every tag is pushed to `docker.io`, `quay.io` and `ghcr.io` (`epicmorg/debian:<tag>` on each) - same digest everywhere.
<!-- readme-sync:tags:end -->

### Museum: Debian 6-12

Older releases are frozen as-is (vanilla, no runtimes) and rebuilt weekly with
three tags each: `<codename>-light`, `<codename>`, `<codename>-develop` for
`squeeze`, `wheezy`, `jessie`, `stretch`, `buster`, `bullseye`, `bookworm`.
Their apt sources point to `archive.debian.org` where the release is archived.
Sources: [`linux/obsolete/epicmorg/debian`](https://github.com/EpicMorg/docker/tree/master/linux/obsolete/epicmorg/debian).

## Usage

```dockerfile
# runtime image
FROM epicmorg/debian:trixie

# build stage with the prebuilt libraries, then copy the result out
FROM epicmorg/debian:trixie-develop AS builder
RUN ./configure --with-openssl="${OPENSSL_35_DIR}" ... && make && make install

FROM epicmorg/debian:trixie
COPY --from=builder /usr/local/share/epicmorg/myapp /usr/local/share/epicmorg/myapp
```

```sh
docker run --rm -it epicmorg/debian:trixie bash
```

Environment you can rely on:

* `EMG_LOCAL_BASE_DIR=/usr/local/share/epicmorg` (also the default `WORKDIR`)
* `SSL_DHPARAM_FILE=/etc/ssl/dhparam.pem`, `REQUESTS_CA_BUNDLE=/etc/ssl/certs/ca-certificates.crt`
* `EMG_WELCOME_MESSAGE=false` / `EMG_DONATION_MESSAGE=false` silence the interactive shell banner

## Links

* Source: [EpicMorg/docker](https://github.com/EpicMorg/docker) - issues and PRs welcome
* Tags float and are rebuilt weekly; pin by digest for reproducible builds: [Tags, pinning and updates](https://github.com/EpicMorg/docker#tags-pinning-and-updates)
* [CHANGELOG](https://github.com/EpicMorg/docker/blob/master/CHANGELOG.md) - License: MIT
