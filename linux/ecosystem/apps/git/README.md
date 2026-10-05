<!-- hub-description: Every git release branch (1.8 - latest) built from source, for COPY --from -->
# `epicmorg/git`

Every git release branch from `1.8` to the latest, each at its newest patch release, built from the
kernel.org source tarballs (sha256-checked) on Debian 13 `trixie`. The point of the image is to be a
**source for `COPY --from`**: an application image picks exactly the git it needs instead of whatever
the distro or a PPA ships today. The newest branch is also tagged `latest`, and that is the git of the
Debian base images (`epicmorg/debian:trixie` and children).

## What's inside

* `git` in `/usr/local/share/epicmorg/git/<major.minor>` (`bin/`, `libexec/git-core/`, `share/`), on `PATH`;
* man pages (`share/man`) and `/emg-export` - git + its libraries as a self-contained tree for `COPY --from`;
* `git-lfs` = the base image's ([`epicmorg/git-lfs:latest`](https://github.com/EpicMorg/docker/tree/master/linux/ecosystem/apps/git-lfs)), not part of `/emg-export`;
* only the baked libraries git links, under `/usr/local/share/epicmorg/`: curl `8.21` + OpenSSL `3.5` (LTS),
  zlib, zstd, pcre2 - linked with a real `RPATH`, nothing in `ld.so.conf`;
* system libs from Debian: `libexpat1` (http push), `perl` (send-email, svn, ... scripts).

Built with the system compiler (gcc 14) from `epicmorg/gcc:14`. Fatal build-time checks: exact
`git --version`, no unresolved libraries in any git binary, no `RUNPATH`, one `libssl`/`libcurl`/`libz` across
all binaries, `git-remote-https` on the baked curl and OpenSSL, and an `init` + `commit` smoke test.

Environment: `EMG_GIT_VERSION` (branch), `EMG_GIT_FULL_VERSION`, `EMG_GIT_DIR`. System config is `/etc/gitconfig`
(built with `sysconfdir=/etc`, like Debian's git).
They are deliberately not named `GIT_*` - git itself reads `GIT_DIR`, `GIT_PREFIX`, ... from the environment.

## Tags

<!-- readme-sync:tags:begin -->
| Tags | Dockerfile |
| ---- | ---------- |
| `1.8` | [`1.8`](1.8/Dockerfile) |
| `1.9` | [`1.9`](1.9/Dockerfile) |
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
| `2.14` | [`2.14`](2.14/Dockerfile) |
| `2.15` | [`2.15`](2.15/Dockerfile) |
| `2.16` | [`2.16`](2.16/Dockerfile) |
| `2.17` | [`2.17`](2.17/Dockerfile) |
| `2.18` | [`2.18`](2.18/Dockerfile) |
| `2.19` | [`2.19`](2.19/Dockerfile) |
| `2.20` | [`2.20`](2.20/Dockerfile) |
| `2.21` | [`2.21`](2.21/Dockerfile) |
| `2.22` | [`2.22`](2.22/Dockerfile) |
| `2.23` | [`2.23`](2.23/Dockerfile) |
| `2.24` | [`2.24`](2.24/Dockerfile) |
| `2.25` | [`2.25`](2.25/Dockerfile) |
| `2.26` | [`2.26`](2.26/Dockerfile) |
| `2.27` | [`2.27`](2.27/Dockerfile) |
| `2.28` | [`2.28`](2.28/Dockerfile) |
| `2.29` | [`2.29`](2.29/Dockerfile) |
| `2.30` | [`2.30`](2.30/Dockerfile) |
| `2.31` | [`2.31`](2.31/Dockerfile) |
| `2.32` | [`2.32`](2.32/Dockerfile) |
| `2.33` | [`2.33`](2.33/Dockerfile) |
| `2.34` | [`2.34`](2.34/Dockerfile) |
| `2.35` | [`2.35`](2.35/Dockerfile) |
| `2.36` | [`2.36`](2.36/Dockerfile) |
| `2.37` | [`2.37`](2.37/Dockerfile) |
| `2.38` | [`2.38`](2.38/Dockerfile) |
| `2.39` | [`2.39`](2.39/Dockerfile) |
| `2.40` | [`2.40`](2.40/Dockerfile) |
| `2.41` | [`2.41`](2.41/Dockerfile) |
| `2.42` | [`2.42`](2.42/Dockerfile) |
| `2.43` | [`2.43`](2.43/Dockerfile) |
| `2.44` | [`2.44`](2.44/Dockerfile) |
| `2.45` | [`2.45`](2.45/Dockerfile) |
| `2.46` | [`2.46`](2.46/Dockerfile) |
| `2.47` | [`2.47`](2.47/Dockerfile) |
| `2.48` | [`2.48`](2.48/Dockerfile) |
| `2.49` | [`2.49`](2.49/Dockerfile) |
| `2.50` | [`2.50`](2.50/Dockerfile) |
| `2.51` | [`2.51`](2.51/Dockerfile) |
| `2.52` | [`2.52`](2.52/Dockerfile) |
| `2.53` | [`2.53`](2.53/Dockerfile) |
| `2.54` | [`2.54`](2.54/Dockerfile) |
| `2.55` | [`2.55`](2.55/Dockerfile) |
| `2.56`, `latest` | [`2.56`](2.56/Dockerfile) |

Every tag is pushed to `docker.io`, `quay.io` and `ghcr.io` (`epicmorg/git:<tag>` on each) - same digest everywhere.
<!-- readme-sync:tags:end -->

## Usage

Copy one git into your image (`/emg-export` = git + exactly the libraries it links; `libexpat1` and `perl`
are already in the epicmorg Debian bases):

```dockerfile
FROM docker.io/epicmorg/debian:trixie
COPY --from=docker.io/epicmorg/git:2.47 /emg-export/ /
ENV PATH="/usr/local/share/epicmorg/git/2.47/bin:${PATH}"
RUN git --version
```

Or just run it:

```sh
docker run --rm -v "$PWD:/work" -w /work docker.io/epicmorg/git:2.56 git log --oneline -5
```

## Notes

* Old branches build from the original tarballs with two build-only adjustments: below `2.34` a broken
  curl "compat" define in `http.h` is disabled (modern curl has `CURLOPT_USE_SSL` as an enum), and the
  oldest trees (`HMAC_CTX` on the stack in `imap-send`) are built `NO_OPENSSL` - only `git imap-send` loses
  its own TLS; https still goes through the baked curl + OpenSSL 3.5.
* Old git versions carry their old bugs and security issues - use them only where a consumer needs that
  exact version (e.g. a tool version range), and prefer the newest branch otherwise.
* New branches and patch bumps: `bin/git-versions-sync` (reads kernel.org `sha256sums.asc`).

## Links

* Source: [EpicMorg/docker](https://github.com/EpicMorg/docker) - issues and PRs welcome
* Tags float and are rebuilt weekly; pin by digest for reproducible builds: [Tags, pinning and updates](https://github.com/EpicMorg/docker#tags-pinning-and-updates)
* [CHANGELOG](https://github.com/EpicMorg/docker/blob/master/CHANGELOG.md) - License: MIT
