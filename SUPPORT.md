# Support Document for Docker Image Concepts in Project

`timestamp: 2026/10/03`

| Debian | **codename** | **status** |
|:-------------|:-------------|:-------------|
| [![GHA](https://img.shields.io/github/actions/workflow/status/EpicMorg/docker/base.sid.yml?label=SID&logo=Debian%20sid%20Images&style=flat-square)](https://github.com/EpicMorg/docker/actions/workflows/base.sid.yml) | `sid` | `unstable` | 
| [![GHA](https://img.shields.io/github/actions/workflow/status/EpicMorg/docker/chain.10-base.yml?label=13&logo=Debian%2013%20Images&style=flat-square)](https://github.com/EpicMorg/docker/actions/workflows/chain.10-base.yml) | **`trixie`** | **`stable`**, reference base |
| [![GHA](https://img.shields.io/github/actions/workflow/status/EpicMorg/docker/base.museum.yml?label=12&logo=Debian%2012%20Images&style=flat-square)](https://github.com/EpicMorg/docker/actions/workflows/base.museum.yml) | `bookworm` | `oldstable`, museum |
| [![GHA](https://img.shields.io/github/actions/workflow/status/EpicMorg/docker/base.museum.yml?label=11&logo=Debian%2011%20Images&style=flat-square)](https://github.com/EpicMorg/docker/actions/workflows/base.museum.yml) | `bullseye` | `LTS`, museum |
| [![GHA](https://img.shields.io/github/actions/workflow/status/EpicMorg/docker/base.museum.yml?label=10&logo=Debian%20Legacy%20Images&style=flat-square)](https://github.com/EpicMorg/docker/actions/workflows/base.museum.yml) | `buster` | museum |
| [![GHA](https://img.shields.io/github/actions/workflow/status/EpicMorg/docker/base.museum.yml?label=9&logo=Debian%20Legacy%20Images&style=flat-square)](https://github.com/EpicMorg/docker/actions/workflows/base.museum.yml) | `stretch` | museum |
| [![GHA](https://img.shields.io/github/actions/workflow/status/EpicMorg/docker/base.museum.yml?label=8&logo=Debian%20Legacy%20Images&style=flat-square)](https://github.com/EpicMorg/docker/actions/workflows/base.museum.yml) | `jessie` | museum |
| [![GHA](https://img.shields.io/github/actions/workflow/status/EpicMorg/docker/base.museum.yml?label=7&logo=Debian%20Legacy%20Images&style=flat-square)](https://github.com/EpicMorg/docker/actions/workflows/base.museum.yml) | `wheezy` | museum |
| [![GHA](https://img.shields.io/github/actions/workflow/status/EpicMorg/docker/base.museum.yml?label=6&logo=Debian%20Legacy%20Images&style=flat-square)](https://github.com/EpicMorg/docker/actions/workflows/base.museum.yml) | `squeeze` | museum |

## Introduction

`epicmorg/docker` is a collection of OCI images on a shared, layered base: **base → runtime → application**.
This document describes how the images are organised and which versions are supported.
Tags, digest pinning and migration announcements are described in the [README](README.md#tags-pinning-and-updates).

### Base images (`linux/ecosystem/base`)

Every supported distribution release has the same set:

1. **`light`** — our own slim layer on top of the vendor image (`debian:<codename>-slim`, Astra `rootfs`): APT configuration, root certificates, locales, base folders. Squashed into a single layer.
2. **`main`** (bare tag, e.g. `debian:trixie`) — `light` + a basic tool set (`mc`, `wget`, `htop`, …). Runtime base for everything else.
3. **`develop-light`** — `main` + build toolchain and `-dev` packages.
4. **`develop`** — `develop-light` + libraries we build from source and bake under `/usr/local/share/epicmorg` (several OpenSSL branches, ICU, curl, libpq, libxml2, …). **A build environment only — never a runtime base.**

Reference base: **Debian 13 `trixie`**. Astra Linux 1.7 / 1.8 follow the same structure (main is tagged `<ver>-main` there). `sid` is a scouting ground for the next Debian release; regressions there are expected.

### Runtimes (`linux/ecosystem/apps`)

Runtimes live in a **global pool** independent of the distribution tag: `epicmorg/php:<x.y>`, `python:<x.y>`, `nodejs:<x>`, `jdk:<x>`, `gcc:<x>`, `nginx:<x.y>`, `go:<x.y>`, `dotnet…`.
PHP, Python and nginx are compiled from source in a `gcc` builder stage and copied onto `main`; their dependencies are baked with an RPATH under `/usr/local/share/epicmorg`, so system libraries are never mixed in. Every build runs fatal checks (library versions, linkage, one copy of each library).

### Applications

Images for end products (`apache2`, `nginx-php`, `testrail`, the Atlassian stack, `mattermost`, TeamCity agents, …) inherit from a runtime or from `main`. `linux/advanced` contains patched forks of upstream images (`zabbix`, `nextcloud`, `teamcity-server`, …).

### Museum: Debian 6–12

Old Debian releases are frozen in `linux/obsolete`: vanilla `light` / `main` / `develop` only, no runtimes. They are rebuilt weekly just to stay installable; nothing new is added to them.

### Updates

* Images are rebuilt on a schedule (weekly) in one chain: base → gcc → runtimes → applications. Tags therefore float — pin by digest if you need reproducibility.
* When a new Debian release becomes the reference, runtimes and applications move to it; the previous release goes to the museum. Such migrations are announced about a month in advance.
