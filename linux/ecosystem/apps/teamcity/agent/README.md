<!-- hub-description: TeamCity build agents on Debian 13 trixie: JDK 21, docker/buildah, php, node, SDKs -->
# `epicmorg/teamcity-agent`

[JetBrains TeamCity](https://www.jetbrains.com/teamcity/) build agents built by EpicMorg on our own
[`epicmorg/debian:trixie-develop`](https://github.com/EpicMorg/docker/tree/master/linux/ecosystem/base/debian)
base (full build toolchain, prebuilt OpenSSL / ICU / curl / libpq under `/usr/local/share/epicmorg`).
These are **not** the JetBrains `teamcity-agent` / `teamcity-minimal-agent` images: one family of
tags on one base, every runtime taken from our own prebuilt images.

## What's inside

| Tag | Built from | Adds |
| --- | --- | --- |
| `minimal` | `epicmorg/debian:trixie-develop` | TeamCity agent (`buildAgent.zip` from teamcity.jetbrains.com), `supervisord`; **JDK 21** + Maven, Gradle, Kotlin copied from [`epicmorg/jdk:21`](https://github.com/EpicMorg/docker/tree/master/linux/ecosystem/apps/java/jdk) |
| `latest` | `minimal` | Docker CE (`docker-ce`, `containerd.io`, buildx and compose plugins) from the trixie Docker repo, `buildah`, `podman`, `podman-compose`, `fuse-overlayfs`, `buildah-wrapper` / `kaniko-wrapper`; .NET SDK (`STS` channel); Debian `mono-complete` |
| `php56` … `php85` | `minimal` | PHP from [`epicmorg/php:<ver>`](https://github.com/EpicMorg/docker/tree/master/linux/ecosystem/apps/php) via `COPY --from` (php, php-fpm, php-cgi, composer, the baked OpenSSL / curl / libpq / ICU it links) |
| `node0.12` … `node26` | `minimal` | Node.js from [`epicmorg/nodejs:<ver>`](https://github.com/EpicMorg/docker/tree/master/linux/ecosystem/apps/nodejs) via `COPY --from` (node, npm, npx, plus pnpm / yarn where that image has them) |
| `android-sdk` | `minimal` | JDK 17 (from `epicmorg/jdk:17`, set as `JAVA_HOME`), Debian `android-sdk` + `sdkmanager`, platform 35, build-tools 35.0.0, cmake 3.22.1 |
| `atlassian-sdk` | `minimal` | [Atlassian Plugin SDK](https://developer.atlassian.com/server/framework/atlassian-sdk/) (`atlas-*` on `PATH`) |
| `amxx-sdk`, `amxx-sdk-rc` | `minimal` | [AMX Mod X](https://www.amxmodx.org/) 1.9 / 1.10 compiler (`amxxpc`, `compile.sh`, includes) |

Every runtime is checked while the image is built: the PHP agents re-run the linkage assertions of
the php image (no unresolved libraries, one SONAME per library, `libssl` / `libcrypto` only from the
baked OpenSSL, `php -m` identical to the php image) and the node agents fail the build if `node` on
`PATH` is not the copied one. Everything the project builds lives under `/usr/local/share/epicmorg`
(the agent itself in `/usr/local/share/epicmorg/teamcity/agent`).

## Tags

<!-- readme-sync:tags:begin -->
| Tags | Dockerfile |
| ---- | ---------- |
| `amxx-sdk` | [`amxx-sdk/1.9`](amxx-sdk/1.9/Dockerfile) |
| `amxx-sdk-rc` | [`amxx-sdk/1.10`](amxx-sdk/1.10/Dockerfile) |
| `android-sdk` | [`android-sdk`](android-sdk/Dockerfile) |
| `ansible-2.16`, `ansible-2.16.19` | [`ansible/2.16`](ansible/2.16/Dockerfile) |
| `ansible-2.17`, `ansible-2.17.14` | [`ansible/2.17`](ansible/2.17/Dockerfile) |
| `ansible-2.21`, `ansible-2.21.5`, `ansible` | [`ansible/2.21`](ansible/2.21/Dockerfile) |
| `atlassian-sdk` | [`atlassian-sdk`](atlassian-sdk/Dockerfile) |
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
| `node24` | [`node24`](node24/Dockerfile) |
| `node25` | [`node25`](node25/Dockerfile) |
| `node26` | [`node26`](node26/Dockerfile) |
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
| `php8.5` | [`php85`](php85/Dockerfile) |

Every tag is pushed to `docker.io`, `quay.io` and `ghcr.io` (`epicmorg/teamcity-agent:<tag>` on each) - same digest everywhere.
<!-- readme-sync:tags:end -->

## Usage

The agent runs under `supervisord` as `root`. On the first start it creates
`buildAgent.properties` from the environment; later starts reuse the file from the `conf` volume.

| Variable | Meaning |
| --- | --- |
| `SERVER_URL` | TeamCity server URL - **required** on the first start |
| `AGENT_TOKEN` | agent authentication token (`--auth-token`) |
| `AGENT_NAME` | agent name |
| `OWN_ADDRESS`, `OWN_PORT` | address / port the server uses to reach the agent |
| `AGENT_OPTS` | space-separated `key=value` lines appended to `buildAgent.properties` |

```yaml
services:
  teamcity-agent:
    image: epicmorg/teamcity-agent:minimal
    restart: unless-stopped
    environment:
      SERVER_URL: "https://teamcity.example.com"
      AGENT_NAME: "agent-01"
    volumes:
      - agent-conf:/usr/local/share/epicmorg/teamcity/agent/conf
      - agent-work:/usr/local/share/epicmorg/teamcity/agent/work
      - agent-logs:/usr/local/share/epicmorg/teamcity/agent/logs
volumes:
  agent-conf:
  agent-work:
  agent-logs:
```

Volumes declared by the image: `.../teamcity/agent/conf`, `.../work`, `.../logs` and
`/var/log/supervisor`.

### `latest`: building containers inside the agent

`latest` starts its own `dockerd` under `supervisord` (`unix:///var/run/docker.sock`,
`--iptables=false --bridge=none`) and ships `buildah` / `podman` configured for `fuse-overlayfs`
(`BUILDAH_FORMAT=docker`, `BUILDAH_ISOLATION=docker`). It needs a privileged container; the
storage directories are declared as volumes:

```sh
docker run -d --privileged \
  -e SERVER_URL=https://teamcity.example.com -e AGENT_NAME=agent-oci \
  -v agent-conf:/usr/local/share/epicmorg/teamcity/agent/conf \
  -v agent-docker:/var/lib/docker -v agent-containers:/var/lib/containers \
  epicmorg/teamcity-agent:latest
```

### Extending

Use a tag as a base and add what your builds need:

```dockerfile
FROM epicmorg/teamcity-agent:php83
RUN php-ext-install -j"$(nproc)" ldap
```

## Notes

* PHP inside the `php*` agents is the same build as `epicmorg/php` (NTS, php-fpm, no `mod_php`);
  see the [php README](https://github.com/EpicMorg/docker/tree/master/linux/ecosystem/apps/php) for
  the OpenSSL / ICU / curl matrix per version. Debian `php*` packages are apt-pinned out.
* The `minimal` agent always runs JDK 21. `android-sdk` switches `JAVA_HOME` to JDK 17.
* GitHub / GitLab runners with the same set of variants:
  [`epicmorg/github-runner`](https://github.com/EpicMorg/docker/tree/master/linux/ecosystem/apps/github/runner),
  [`epicmorg/gitlab-runner`](https://github.com/EpicMorg/docker/tree/master/linux/ecosystem/apps/gitlab/runner).
* The server: [`epicmorg/teamcity-server`](https://github.com/EpicMorg/docker/tree/master/linux/advanced/teamcity/server).

## Links

* Source: [EpicMorg/docker](https://github.com/EpicMorg/docker) - issues and PRs welcome
* Tags float and are rebuilt weekly; pin by digest for reproducible builds: [Tags, pinning and updates](https://github.com/EpicMorg/docker#tags-pinning-and-updates)
* [CHANGELOG](https://github.com/EpicMorg/docker/blob/master/CHANGELOG.md) - License: MIT
