<!-- hub-description: Every git-lfs release branch (1.0 - latest), upstream binaries, for COPY --from -->
# `epicmorg/git-lfs`

Every [Git LFS](https://git-lfs.com) release branch from `1.0` to the latest, each at its newest patch
release - the upstream static `linux-amd64` binary (sha256-pinned), not rebuilt. Like
[`epicmorg/git`](https://github.com/EpicMorg/docker/tree/master/linux/ecosystem/apps/git), the image is a
**source for `COPY --from`**: an application image takes exactly the git-lfs it needs. The newest branch is
also tagged `latest`, and that is the git-lfs of the Debian base images (`epicmorg/debian:trixie` and children).

## What's inside

* `git-lfs` in `/usr/local/share/epicmorg/git-lfs/<major.minor>/bin` (on `PATH`) + its man pages
  (`share/man`, when the release ships them);
* `/emg-export` - the same tree, self-contained, for `COPY --from`;
* `git` = the base image's (`epicmorg/git:latest`, built from source).

Build-time checks (fatal): exact `git-lfs version`, and an isolated smoke test (own `HOME`, no system
config) that tracks and commits a file through LFS.

Environment: `EMG_GIT_LFS_VERSION` (branch), `EMG_GIT_LFS_FULL_VERSION`, `EMG_GIT_LFS_DIR`.

## Tags

<!-- readme-sync:tags:begin -->
| Tags | Dockerfile |
| ---- | ---------- |
| `1.0` | [`1.0`](1.0/Dockerfile) |
| `1.1` | [`1.1`](1.1/Dockerfile) |
| `1.2` | [`1.2`](1.2/Dockerfile) |
| `1.3` | [`1.3`](1.3/Dockerfile) |
| `1.4` | [`1.4`](1.4/Dockerfile) |
| `1.5` | [`1.5`](1.5/Dockerfile) |
| `2.0` | [`2.0`](2.0/Dockerfile) |
| `2.1` | [`2.1`](2.1/Dockerfile) |
| `2.2` | [`2.2`](2.2/Dockerfile) |
| `2.3` | [`2.3`](2.3/Dockerfile) |
| `2.4` | [`2.4`](2.4/Dockerfile) |
| `2.5` | [`2.5`](2.5/Dockerfile) |
| `2.6` | [`2.6`](2.6/Dockerfile) |
| `2.7` | [`2.7`](2.7/Dockerfile) |
| `2.8` | [`2.8`](2.8/Dockerfile) |
| `2.9` | [`2.9`](2.9/Dockerfile) |
| `2.10` | [`2.10`](2.10/Dockerfile) |
| `2.11` | [`2.11`](2.11/Dockerfile) |
| `2.12` | [`2.12`](2.12/Dockerfile) |
| `2.13` | [`2.13`](2.13/Dockerfile) |
| `3.0` | [`3.0`](3.0/Dockerfile) |
| `3.1` | [`3.1`](3.1/Dockerfile) |
| `3.2` | [`3.2`](3.2/Dockerfile) |
| `3.3` | [`3.3`](3.3/Dockerfile) |
| `3.4` | [`3.4`](3.4/Dockerfile) |
| `3.5` | [`3.5`](3.5/Dockerfile) |
| `3.6` | [`3.6`](3.6/Dockerfile) |
| `3.7` | [`3.7`](3.7/Dockerfile) |
| `3.8`, `latest` | [`3.8`](3.8/Dockerfile) |

Every tag is pushed to `docker.io`, `quay.io` and `ghcr.io` (`epicmorg/git-lfs:<tag>` on each) - same digest everywhere.
<!-- readme-sync:tags:end -->

## Usage

```dockerfile
FROM ghcr.io/epicmorg/debian:trixie
COPY --from=ghcr.io/epicmorg/git-lfs:2.13 /emg-export/ /
ENV PATH="/usr/local/share/epicmorg/git-lfs/2.13/bin:${PATH}"
RUN git lfs install --system --skip-repo && git lfs version
```

## Notes

* `0.x` (git-media / hawser era) is not built.
* Releases before `2.5` publish no checksums: their sha256 was computed once from the GitHub download and
  is pinned from then on. Newer ones are checked against the GitHub asset digest or `sha256sums.asc`.
* `1.0` has `git lfs init` instead of `install`; old releases do not understand config written by new ones
  (`filter.lfs.process`), so run `git lfs install` (or `init`) with the version you copied.
* New branches / patch bumps: `bin/python/git-lfs-versions-sync.py`.

## Links

* Source: [EpicMorg/docker](https://github.com/EpicMorg/docker) - issues and PRs welcome
* Tags float and are rebuilt weekly; pin by digest for reproducible builds: [Tags, pinning and updates](https://github.com/EpicMorg/docker#tags-pinning-and-updates)
* [CHANGELOG](https://github.com/EpicMorg/docker/blob/master/CHANGELOG.md) - License: MIT
