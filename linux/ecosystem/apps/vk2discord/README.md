<!-- hub-description: VK2Discord - reposts VK community and user wall posts to Discord via webhooks -->
# `epicmorg/vk2discord`

[VK2Discord](https://github.com/MrZillaGold/VK2Discord) by MrZillaGold — forwards new posts from VK
communities and user walls to Discord channels (attachments, reposts, keyword filters, several
communities and channels in one process). Built on `epicmorg/nodejs:23`.

## What's inside

* upstream `master` cloned at build time into `/usr/src/vk2discord`, dependencies installed with
  `npm install`
* default command: `npm start`
* configuration is upstream's `config.json` in `/usr/src/vk2discord` — see
  [`CONFIG_FIELDS.md`](https://github.com/MrZillaGold/VK2Discord/blob/master/CONFIG_FIELDS.md) and the
  [setup guide](https://github.com/MrZillaGold/VK2Discord/wiki) (in Russian)

## Tags

<!-- readme-sync:tags:begin -->
| Tags | Dockerfile |
| ---- | ---------- |
| `latest` | [`.`](./Dockerfile) |

Every tag is pushed to `docker.io`, `quay.io` and `ghcr.io` (`epicmorg/vk2discord:<tag>` on each) - same digest everywhere.
<!-- readme-sync:tags:end -->

## Usage

Start from upstream's
[`config_example.json`](https://github.com/MrZillaGold/VK2Discord/blob/master/config_example.json),
fill in the VK token, groups and Discord webhooks, and mount it over the bundled `config.json`:

```yaml
services:
  vk2discord:
    image: epicmorg/vk2discord:latest
    restart: unless-stopped
    volumes:
      - ./config.json:/usr/src/vk2discord/config.json
```

The image tracks upstream `master` at build time; a weekly rebuild picks up upstream changes.

## Links

* Source: [EpicMorg/docker](https://github.com/EpicMorg/docker) - issues and PRs welcome
* Tags float and are rebuilt weekly; pin by digest for reproducible builds: [Tags, pinning and updates](https://github.com/EpicMorg/docker#tags-pinning-and-updates)
* [CHANGELOG](https://github.com/EpicMorg/docker/blob/master/CHANGELOG.md) - License: MIT
