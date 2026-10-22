<!-- hub-description: Official Nextcloud 14-34 images + SMB/CIFS, IMAP, inotify, ffmpeg, extra CA certs -->
# `epicmorg/nextcloud`

The official [Nextcloud](https://nextcloud.com/) image (`nextcloud:<version>`, Apache + mod_php)
extended with the PHP extensions and tools needed for external storage, mail and previews.
Nextcloud itself, its entrypoint and its environment variables are unchanged.

Two flavours per major version:

* **`<version>`** ("pure") - `nextcloud:<version>` + the additions below;
* **`<version>-patched`** - the same image with one source patch: ZIP downloads of folders are
  always created as **ZIP64** (`lib/private/Streamer.php`, `zip64 => true`). Upstream disables
  ZIP64 for some clients (macOS), which limits such archives to 4 GB.

## What's inside

On top of `nextcloud:<version>`:

* **PHP extensions**: `smbclient` and `inotify` (PECL), `imap` (with Kerberos and SSL; the UW IMAP
  `c-client` library is shipped in the image), `fileinfo`, `bz2`, `intl`, `ftp`, `pdo_sqlite`;
* **SMB/CIFS external storage**: `smbclient`, `libsmbclient` and an `smb.conf` that limits the client
  to SMB2-SMB3;
* **previews and media**: `ffmpeg`, `imagemagick`, `ghostscript`;
* **tools**: `sqlite3`, `curl`, `wget`, `aria2`, `htop`, `nload`, `mc`, `nano`, `sudo`, `net-tools`,
  `iputils-ping`;
* **apt sources** for the Debian release of the upstream image (`buster` and `bullseye` ones point to
  `archive.debian.org`), deb-multimedia and, on newer releases, Debian backports; extra CA certificates in the system
  trust store; `dist-upgrade` at build time.

## Tags

<!-- readme-sync:tags:begin -->
| Tags | Dockerfile |
| ---- | ---------- |
| `14-patched` | [`patched/14`](patched/14/Dockerfile) |
| `15-patched` | [`patched/15`](patched/15/Dockerfile) |
| `16-patched` | [`patched/16`](patched/16/Dockerfile) |
| `17-patched` | [`patched/17`](patched/17/Dockerfile) |
| `18-patched` | [`patched/18`](patched/18/Dockerfile) |
| `19-patched` | [`patched/19`](patched/19/Dockerfile) |
| `20-patched` | [`patched/20`](patched/20/Dockerfile) |
| `21-patched` | [`patched/21`](patched/21/Dockerfile) |
| `22-patched` | [`patched/22`](patched/22/Dockerfile) |
| `23-patched` | [`patched/23`](patched/23/Dockerfile) |
| `24-patched` | [`patched/24`](patched/24/Dockerfile) |
| `25-patched` | [`patched/25`](patched/25/Dockerfile) |
| `26-patched` | [`patched/26`](patched/26/Dockerfile) |
| `27-patched` | [`patched/27`](patched/27/Dockerfile) |
| `28-patched` | [`patched/28`](patched/28/Dockerfile) |
| `29-patched` | [`patched/29`](patched/29/Dockerfile) |
| `30-patched` | [`patched/30`](patched/30/Dockerfile) |
| `31-patched` | [`patched/31`](patched/31/Dockerfile) |
| `32-patched` | [`patched/32`](patched/32/Dockerfile) |
| `33-patched` | [`patched/33`](patched/33/Dockerfile) |
| `34-patched` | [`patched/34`](patched/34/Dockerfile) |
| `latest-patched` | [`patched/latest`](patched/latest/Dockerfile) |
| `14` | [`pure/14`](pure/14/Dockerfile) |
| `15` | [`pure/15`](pure/15/Dockerfile) |
| `16` | [`pure/16`](pure/16/Dockerfile) |
| `17` | [`pure/17`](pure/17/Dockerfile) |
| `18` | [`pure/18`](pure/18/Dockerfile) |
| `19` | [`pure/19`](pure/19/Dockerfile) |
| `20` | [`pure/20`](pure/20/Dockerfile) |
| `21` | [`pure/21`](pure/21/Dockerfile) |
| `22` | [`pure/22`](pure/22/Dockerfile) |
| `23` | [`pure/23`](pure/23/Dockerfile) |
| `24` | [`pure/24`](pure/24/Dockerfile) |
| `25` | [`pure/25`](pure/25/Dockerfile) |
| `26` | [`pure/26`](pure/26/Dockerfile) |
| `27` | [`pure/27`](pure/27/Dockerfile) |
| `28` | [`pure/28`](pure/28/Dockerfile) |
| `29` | [`pure/29`](pure/29/Dockerfile) |
| `30` | [`pure/30`](pure/30/Dockerfile) |
| `31` | [`pure/31`](pure/31/Dockerfile) |
| `32` | [`pure/32`](pure/32/Dockerfile) |
| `33` | [`pure/33`](pure/33/Dockerfile) |
| `34` | [`pure/34`](pure/34/Dockerfile) |
| `latest` | [`pure/latest`](pure/latest/Dockerfile) |

Every tag is pushed to `docker.io`, `quay.io` and `ghcr.io` (`epicmorg/nextcloud:<tag>` on each) - same digest everywhere.
<!-- readme-sync:tags:end -->

## Usage

Same ports, volumes and environment variables as the official image - replace the image name:

```yml
services:
  nextcloud:
    image: epicmorg/nextcloud:32
    restart: unless-stopped
    ports:
      - "8080:80"
    volumes:
      - nextcloud:/var/www/html
    environment:
      MYSQL_HOST: db
      MYSQL_DATABASE: nextcloud
      MYSQL_USER: nextcloud
      MYSQL_PASSWORD: nextcloud
volumes:
  nextcloud:
```

Full reference (environment variables, cron, reverse proxy, upgrades):
[nextcloud/docker](https://github.com/nextcloud/docker) and the
[Nextcloud admin manual](https://docs.nextcloud.com/server/latest/admin_manual/).

## Notes

* Upgrade one major version at a time, as upstream requires.
* Old majors are kept for existing installations; they get no Nextcloud fixes anymore.

## Links

* Source: [EpicMorg/docker](https://github.com/EpicMorg/docker) - issues and PRs welcome
* Tags float and are rebuilt weekly; pin by digest for reproducible builds: [Tags, pinning and updates](https://github.com/EpicMorg/docker#tags-pinning-and-updates)
* [CHANGELOG](https://github.com/EpicMorg/docker/blob/master/CHANGELOG.md) - License: MIT
