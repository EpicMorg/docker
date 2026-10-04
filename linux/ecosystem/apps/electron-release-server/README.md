<!-- hub-description: Electron Release Server - update and download server for Electron apps -->
# `epicmorg/electron-release-server`

[Electron Release Server](https://github.com/ArekSredzki/electron-release-server) — a release
management and auto-update server for Electron applications (Squirrel compatible), with a web UI.
Built on `epicmorg/nodejs:19`.

## What's inside

* upstream `master` cloned at build time into `/usr/src/electron-release-server`,
  dependencies installed with `npm` and `bower`, dev dependencies pruned
* `config/docker.js` copied to `config/local.js` — configuration comes from environment variables
* `docker-entrypoint.sh` under `tini` runs `npm start`; healthcheck on port 80
* needs an external PostgreSQL database

## Tags

<!-- readme-sync:tags:begin -->
| Tags | Dockerfile |
| ---- | ---------- |
| `latest` | [`.`](./Dockerfile) |

Every tag is pushed to `docker.io`, `quay.io` and `ghcr.io` (`epicmorg/electron-release-server:<tag>` on each) - same digest everywhere.
<!-- readme-sync:tags:end -->

## Usage

Based on [`docker-compose.yml.example`](https://github.com/EpicMorg/docker/blob/master/linux/ecosystem/apps/electron-release-server/docker-compose.yml.example):

```yaml
services:
  web:
    image: epicmorg/electron-release-server:latest
    environment:
      APP_USERNAME: username
      APP_PASSWORD: password
      DB_HOST: db
      DB_PORT: 5432
      DB_USERNAME: releaseserver
      DB_NAME: releaseserver
      DB_PASSWORD: secret
      TOKEN_SECRET: change_me_in_production
      APP_URL: 'localhost:5000'
      ASSETS_PATH: '/usr/src/electron-release-server/releases'
    depends_on:
      - db
    ports:
      - '5000:80'
    volumes:
      - ./releases:/usr/src/electron-release-server/releases
  db:
    image: postgres:11
    environment:
      POSTGRES_PASSWORD: secret
      POSTGRES_USER: releaseserver
    volumes:
      - ./postgresql:/var/lib/postgresql/data
```

The variables are read by upstream's `config/docker.js`; see the
[upstream docs](https://github.com/ArekSredzki/electron-release-server/tree/master/docs) for the full list.
Change `APP_PASSWORD` and `TOKEN_SECRET` before exposing the server.

## Links

* Source: [EpicMorg/docker](https://github.com/EpicMorg/docker) - issues and PRs welcome
* Tags float and are rebuilt weekly; pin by digest for reproducible builds: [Tags, pinning and updates](https://github.com/EpicMorg/docker#tags-pinning-and-updates)
* [CHANGELOG](https://github.com/EpicMorg/docker/blob/master/CHANGELOG.md) - License: MIT
