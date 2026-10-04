<!-- hub-description: Node.js 0.12-26 (official binaries) on epicmorg/debian:trixie with npm, yarn, pnpm -->
# `epicmorg/nodejs`

Official Node.js linux-x64 binaries (plus headers for native addons) on top of
[`epicmorg/debian:trixie`](https://github.com/EpicMorg/docker/tree/master/linux/ecosystem/base/debian),
one major version per tag - from the museum `0.12` to the current `26`.

## What's inside

| Tag | Node.js | Extra global packages |
| --- | ------- | --------------------- |
| `0.12` | `0.12.18` | - |
| `4` - `6` | `4.9.1`, `5.9.1`, `6.17.1` | `pnpm@2` |
| `7` - `9` | `7.10.1`, `8.17.0`, `9.11.2` | `pnpm@3`, `yarn` |
| `10` - `13` | `10.24.1`, `11.15.0`, `12.22.9`, `13.14.0` | `pnpm@5` / `pnpm@6`, `yarn` |
| `14` - `17` | `14.21.3`, `15.14.0`, `16.20.2`, `17.9.1` | `pnpm@7`, `yarn` |
| `18` - `26` | `18.20.8` ... `24.19.0`, `25.9.0`, `26.6.0` | `pnpm@10`, `yarn` |

* Node in `NODE_DIR=/usr/local/share/epicmorg/nodejs/<major>`, `${NODE_DIR}/bin`
  on `PATH`. `node`, `npm`, `npx`, `corepack` and every global npm binary are
  also symlinked into `/usr/local/bin`, so scripts that hardcode that path keep working.
* A `node` user and group (uid/gid `1337`) with a home directory exist for
  running unprivileged.
* The build fails unless `node --version` matches the expected release.

## Tags

<!-- readme-sync:tags:begin -->
| Tags | Dockerfile |
| ---- | ---------- |
| `0.12` | [`node0.12`](node0.12/Dockerfile) |
| `4` | [`node4`](node4/Dockerfile) |
| `5` | [`node5`](node5/Dockerfile) |
| `6` | [`node6`](node6/Dockerfile) |
| `7` | [`node7`](node7/Dockerfile) |
| `8` | [`node8`](node8/Dockerfile) |
| `9` | [`node9`](node9/Dockerfile) |
| `10` | [`node10`](node10/Dockerfile) |
| `11` | [`node11`](node11/Dockerfile) |
| `12` | [`node12`](node12/Dockerfile) |
| `13` | [`node13`](node13/Dockerfile) |
| `14` | [`node14`](node14/Dockerfile) |
| `15` | [`node15`](node15/Dockerfile) |
| `16` | [`node16`](node16/Dockerfile) |
| `17` | [`node17`](node17/Dockerfile) |
| `18` | [`node18`](node18/Dockerfile) |
| `19` | [`node19`](node19/Dockerfile) |
| `20` | [`node20`](node20/Dockerfile) |
| `21` | [`node21`](node21/Dockerfile) |
| `22` | [`node22`](node22/Dockerfile) |
| `23` | [`node23`](node23/Dockerfile) |
| `24` | [`node24`](node24/Dockerfile) |
| `25` | [`node25`](node25/Dockerfile) |
| `26` | [`node26`](node26/Dockerfile) |

Every tag is pushed to `docker.io`, `quay.io` and `ghcr.io` (`epicmorg/nodejs:<tag>` on each) - same digest everywhere.
<!-- readme-sync:tags:end -->

## Usage

```sh
docker run --rm -it epicmorg/nodejs:24 node --version
docker run --rm -v "$PWD":/app -w /app epicmorg/nodejs:24 npm ci
```

```dockerfile
FROM epicmorg/nodejs:24
WORKDIR /app
COPY package*.json ./
RUN npm ci --omit=dev
COPY . .
USER node
CMD ["node", "server.js"]
```

## Notes

* Most of these majors are end-of-life upstream (see
  [nodejs.org/about/previous-releases](https://nodejs.org/en/about/previous-releases));
  they are kept for legacy builds and get no new Node.js releases.

## Links

* Source: [EpicMorg/docker](https://github.com/EpicMorg/docker) - issues and PRs welcome
* Tags float and are rebuilt weekly; pin by digest for reproducible builds: [Tags, pinning and updates](https://github.com/EpicMorg/docker#tags-pinning-and-updates)
* [CHANGELOG](https://github.com/EpicMorg/docker/blob/master/CHANGELOG.md) - License: MIT
