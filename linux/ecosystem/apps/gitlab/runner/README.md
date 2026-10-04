<!-- hub-description: GitLab Runner images on Debian 13 trixie: docker/buildah, php, node, .NET, SDKs -->
# `epicmorg/gitlab-runner`

[GitLab](https://docs.gitlab.com/runner/) self-hosted runner images built by EpicMorg on our own
[`epicmorg/debian:trixie-develop`](https://github.com/EpicMorg/docker/tree/master/linux/ecosystem/base/debian)
base (full build toolchain, prebuilt OpenSSL / ICU / curl / libpq under `/usr/local/share/epicmorg`).
Same set of variants as [`epicmorg/teamcity-agent`](https://github.com/EpicMorg/docker/tree/master/linux/ecosystem/apps/teamcity/agent).

## What's inside

| Tag | Built from | Adds |
| --- | --- | --- |
| `minimal` | `epicmorg/debian:trixie-develop` | `gitlab-runner` (latest binary from GitLab's S3), `supervisord` |
| `latest` | `minimal` | Docker CE (`docker-ce`, `containerd.io`, buildx and compose plugins) from the trixie Docker repo, `buildah`, `podman`, `podman-compose`, `fuse-overlayfs`, `buildah-wrapper` / `kaniko-wrapper`; .NET SDK (`STS` channel); Debian `mono-complete` |
| `php56` … `php84` | `minimal` | PHP from [`epicmorg/php:<ver>`](https://github.com/EpicMorg/docker/tree/master/linux/ecosystem/apps/php) via `COPY --from` (php, php-fpm, php-cgi, composer, the baked OpenSSL / curl / libpq / ICU it links) - same Dockerfile as the TeamCity php agents, with the same fatal linkage assertions |
| `node0.12` … `node23` | `minimal` | Node.js release tarball from nodejs.org |
| `dotnet-sdk` | `minimal` | .NET SDK (`STS` channel), Debian `mono-complete` |
| `android-sdk` | `minimal` | Temurin JDK 17, Debian `android-sdk` + `sdkmanager` packages |
| `atlassian-sdk` | `minimal` | Temurin JDK 8, [Atlassian Plugin SDK](https://developer.atlassian.com/server/framework/atlassian-sdk/) |
| `amxx-sdk`, `amxx-sdk-rc` | `minimal` | [AMX Mod X](https://www.amxmodx.org/) 1.9 / 1.10 compiler |

Everything the project installs lives under `/usr/local/share/epicmorg`.

## Tags

<!-- readme-sync:tags:begin -->
| Tags | Dockerfile |
| ---- | ---------- |
| `amxx-sdk` | [`amxx-sdk/1.9`](amxx-sdk/1.9/Dockerfile) |
| `amxx-sdk-rc` | [`amxx-sdk/1.10`](amxx-sdk/1.10/Dockerfile) |
| `android-sdk` | [`android-sdk`](android-sdk/Dockerfile) |
| `atlassian-sdk` | [`atlassian-sdk`](atlassian-sdk/Dockerfile) |
| `dotnet-sdk` | [`dotnet-sdk`](dotnet-sdk/Dockerfile) |
| `latest` | [`latest`](latest/Dockerfile) |
| `minimal` | [`minimal`](minimal/Dockerfile) |
| `node0.12` | [`node0.12`](node0.12/Dockerfile) |
| `node4` | [`node4`](node4/Dockerfile) |
| `node5` | [`node5`](node5/Dockerfile) |
| `node6` | [`node6`](node6/Dockerfile) |
| `node7` | [`node7`](node7/Dockerfile) |
| `node8` | [`node8`](node8/Dockerfile) |
| `node9` | [`node9`](node9/Dockerfile) |
| `node10` | [`node10`](node10/Dockerfile) |
| `node11` | [`node11`](node11/Dockerfile) |
| `node12` | [`node12`](node12/Dockerfile) |
| `node13` | [`node13`](node13/Dockerfile) |
| `node14` | [`node14`](node14/Dockerfile) |
| `node15` | [`node15`](node15/Dockerfile) |
| `node16` | [`node16`](node16/Dockerfile) |
| `node17` | [`node17`](node17/Dockerfile) |
| `node18` | [`node18`](node18/Dockerfile) |
| `node19` | [`node19`](node19/Dockerfile) |
| `node20` | [`node20`](node20/Dockerfile) |
| `node21` | [`node21`](node21/Dockerfile) |
| `node22` | [`node22`](node22/Dockerfile) |
| `node23` | [`node23`](node23/Dockerfile) |
| `php5.6` | [`php56`](php56/Dockerfile) |
| `php7.0` | [`php70`](php70/Dockerfile) |
| `php7.1` | [`php71`](php71/Dockerfile) |
| `php7.2` | [`php72`](php72/Dockerfile) |
| `php7.3` | [`php73`](php73/Dockerfile) |
| `php7.4` | [`php74`](php74/Dockerfile) |
| `php8.0` | [`php80`](php80/Dockerfile) |
| `php8.1` | [`php81`](php81/Dockerfile) |
| `php8.2` | [`php82`](php82/Dockerfile) |
| `php8.3` | [`php83`](php83/Dockerfile) |
| `php8.4` | [`php84`](php84/Dockerfile) |

Every tag is pushed to `docker.io`, `quay.io` and `ghcr.io` (`epicmorg/gitlab-runner:<tag>` on each) - same digest everywhere.
<!-- readme-sync:tags:end -->

## Usage

`supervisord` runs `gitlab-runner run` as `root` with the configuration in
`/usr/local/share/epicmorg/gitlab/runner/etc/gitlab-runner/config.toml` (also reachable as
`/etc/gitlab-runner`) and the work directory `/usr/local/share/epicmorg/gitlab/runner/worker`.
The image does not register itself: keep `config.toml` in the volume and register once.

```yaml
services:
  gitlab-runner:
    image: epicmorg/gitlab-runner:minimal
    restart: unless-stopped
    volumes:
      - runner-config:/usr/local/share/epicmorg/gitlab/runner/etc/gitlab-runner
      - runner-worker:/usr/local/share/epicmorg/gitlab/runner/worker
volumes:
  runner-config:
  runner-worker:
```

```sh
docker compose exec gitlab-runner gitlab-runner register \
  --url https://gitlab.example.com --token <runner authentication token> --executor shell
```

Volumes declared by the image: the config directory, the worker directory and `/var/log/supervisor`.

### `latest`: building containers inside the runner

`latest` starts its own `dockerd` under `supervisord` (`unix:///var/run/docker.sock`,
`--iptables=false --bridge=none`) and ships `buildah` / `podman` configured for `fuse-overlayfs`
(`BUILDAH_FORMAT=docker`, `BUILDAH_ISOLATION=docker`). Run it privileged; `/var/lib/docker`,
`/var/lib/containers` and `/var/tmp` are declared as volumes.

## Notes

* PHP inside the `php*` runners is the same build as `epicmorg/php` (NTS, php-fpm, no `mod_php`); see the
  [php README](https://github.com/EpicMorg/docker/tree/master/linux/ecosystem/apps/php) for the OpenSSL / ICU / curl
  matrix per version. Debian `php*` packages are apt-pinned out.
* Unlike the TeamCity agents, `minimal` here has no JDK; `android-sdk` and `atlassian-sdk` bring their own.

## Links

* Source: [EpicMorg/docker](https://github.com/EpicMorg/docker) - issues and PRs welcome
* Tags float and are rebuilt weekly; pin by digest for reproducible builds: [Tags, pinning and updates](https://github.com/EpicMorg/docker#tags-pinning-and-updates)
* [CHANGELOG](https://github.com/EpicMorg/docker/blob/master/CHANGELOG.md) - License: MIT
