<!-- hub-description: EXPERIMENTAL: legacy self-hosted Sentry image with LDAP auth (sentry-ldap-auth) -->
# `epicmorg/sentry`

> **Experimental — not for production.** This lives under `linux/experimental`: it is not part of the
> weekly build chain, is not maintained to the standards of the other images and may be removed.

The legacy official `sentry` image (Debian stretch based) plus the
[`sentry-ldap-auth`](https://github.com/Banno/getsentry-ldap-auth) backend.

## What's inside

* base: `docker.io/sentry` (the deprecated single-image Sentry; modern Sentry is installed with
  [getsentry/self-hosted](https://github.com/getsentry/self-hosted))
* apt sources switched to `archive.debian.org` (stretch is archived)
* build deps for LDAP (`gcc`, `libsasl2-dev`, `libldap2-dev`, `libssl-dev`) and `sentry-ldap-auth`
  installed with `pip`, both for root and for the `sentry` user
* [`sentry.conf.py`](https://github.com/EpicMorg/docker/blob/master/linux/experimental/sentry/latest/sentry.conf.py)
  in the repository — an example LDAP (FreeIPA) configuration with placeholder values; it is **not**
  copied into the image

## Tags

<!-- readme-sync:tags:begin -->
| Tags | Dockerfile |
| ---- | ---------- |
| `latest` | [`.`](./Dockerfile) |

Every tag is pushed to `docker.io`, `quay.io` and `ghcr.io` (`epicmorg/sentry:<tag>` on each) - same digest everywhere.
<!-- readme-sync:tags:end -->

## Usage

Use it exactly like the legacy `sentry` image (Postgres + Redis, `sentry upgrade`, web/worker/cron
containers), and mount your own `sentry.conf.py` with the LDAP block adapted from the example:

```sh
docker run -d --name sentry \
  -v "$PWD/sentry.conf.py":/etc/sentry/sentry.conf.py:ro \
  epicmorg/sentry:latest
```

Adjust `AUTH_LDAP_SERVER_URI`, `AUTH_LDAP_BIND_DN`, `AUTH_LDAP_BIND_PASSWORD` and the search bases;
the example's password and hosts are placeholders.

## Links

* Source: [EpicMorg/docker](https://github.com/EpicMorg/docker) - issues and PRs welcome
* Tags float and are rebuilt weekly; pin by digest for reproducible builds: [Tags, pinning and updates](https://github.com/EpicMorg/docker#tags-pinning-and-updates)
* [CHANGELOG](https://github.com/EpicMorg/docker/blob/master/CHANGELOG.md) - License: MIT
