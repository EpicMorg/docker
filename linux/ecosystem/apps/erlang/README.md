<!-- hub-description: Erlang/OTP 24-29 from source (JIT, crypto/ssl on baked OpenSSL), runtime for COPY --from -->
# `epicmorg/erlang`

Erlang/OTP built from the erlang/otp release tarballs (sha256 from the release's `SHA256.txt`) on Debian 13
`trixie`, one tag per OTP major at its newest patch. A runtime / base image like `epicmorg/python`: no
`ENTRYPOINT` / `CMD`; RabbitMQ (`epicmorg/rabbitmq`) takes it with `COPY --from`.

## What's inside

| OTP | OpenSSL | Used by |
| --- | ------- | ------- |
| `29` (`latest`) | 3.5 | RabbitMQ 4.4 |
| `28` | 3.5 | |
| `27` | 3.5 | RabbitMQ 4.0 - 4.3 |
| `26` | 3.5 | RabbitMQ 3.12, 3.13 |
| `25` | 3.5 | RabbitMQ 3.10, 3.11 |
| `24` | 1.1.1 | RabbitMQ 3.9 (OTP 24 predates full OpenSSL 3 support) |

* `erl`, `erlc`, `escript` & co. in `/usr/local/share/epicmorg/erlang/<major>/bin`, on `PATH`; JIT (`emu_flavor`
  `jit`), kernel poll;
* `crypto` / `ssl` / `ssh` / `public_key` against the baked OpenSSL with a real `RPATH` (nothing in
  `ld.so.conf`); the GUI / IDE apps (wx, observer, debugger, et), jinterface and ODBC are not built;
* `/emg-export` - Erlang + the OpenSSL it links as a self-contained tree:
  `COPY --from=ghcr.io/epicmorg/erlang:27 /emg-export/ /`.

Fatal build-time checks: the exact `OTP_VERSION`, `otp_release`, JIT, no unresolved libraries, no `RUNPATH`,
exactly one `libcrypto` per ELF and it is the baked branch, `crypto:info_lib()` reports it, `ssl` starts,
sha256 / AES-GCM work.

## Tags

<!-- readme-sync:tags:begin -->
| Tags | Dockerfile |
| ---- | ---------- |
| `24`, `24.3.4.17` | [`24`](24/Dockerfile) |
| `25`, `25.3.2.21` | [`25`](25/Dockerfile) |
| `26`, `26.2.5.21` | [`26`](26/Dockerfile) |
| `27`, `27.3.4.19` | [`27`](27/Dockerfile) |
| `28`, `28.5.0.8` | [`28`](28/Dockerfile) |
| `29`, `29.1.2`, `latest` | [`29`](29/Dockerfile) |

Every tag is pushed to `docker.io`, `quay.io` and `ghcr.io` (`epicmorg/erlang:<tag>` on each) - same digest everywhere.
<!-- readme-sync:tags:end -->

## Notes

* OTP 24 - 27 link their crypto NIFs with their own linker flags (`RUNPATH`); the image rewrites that to
  `RPATH` with the same value at build time (`patchelf --force-rpath`), as the build log lists.
* Licence: Erlang/OTP is Apache 2.0; the image recipe is MIT.

Folders are written by `bin/python/erlang-versions-sync.py`.

## Links

* Source: [EpicMorg/docker](https://github.com/EpicMorg/docker) - issues and PRs welcome
* Tags float and are rebuilt weekly; pin by digest for reproducible builds: [Tags, pinning and updates](https://github.com/EpicMorg/docker#tags-pinning-and-updates)
* [CHANGELOG](https://github.com/EpicMorg/docker/blob/master/CHANGELOG.md) - License: MIT
