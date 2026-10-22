<!-- hub-description: Nextcloud 14-35 on Debian trixie (our PHP + Apache, php-fpm), drop-in for the official image + SMB, IMAP, inotify, ffmpeg -->
# `epicmorg/nextcloud`

[Nextcloud](https://nextcloud.com/) on Debian 13 `trixie` and our own PHP / Apache
(`epicmorg/apache2:php<X.Y>`: php-src build, Apache `mpm_event` + php-fpm under supervisord, no mod_php),
a **drop-in for the official image of the same tag** (`nextcloud:<version>`, apache variant):

* the Nextcloud tree (`/usr/src/nextcloud`), `/entrypoint.sh`, `/cron.sh`, `/upgrade.exclude` and the crontab
  are taken from the official image unchanged - installation, upgrades, hooks
  (`/docker-entrypoint-hooks.d/*`), `NEXTCLOUD_*` / `MYSQL_*` / `POSTGRES_*` / `REDIS_*` / `SQLITE_DATABASE`,
  `*_FILE` secrets, `APACHE_DISABLE_REWRITE_IP`, `APACHE_RUN_USER` work as there;
* same volume (`/var/www/html`), user (`www-data`, 33:33), port `80`, `CMD ["apache2-foreground"]`,
  `STOPSIGNAL SIGWINCH`, no healthcheck; `command: /cron.sh` for a cron container;
* the PHP line of each tag is the one the official image ships (14: 7.2 ... 34 / latest: 8.5), with its
  `php.ini` settings (opcache / JIT, APCu, igbinary sessions and cache serializer, `PHP_MEMORY_LIMIT`,
  `PHP_UPLOAD_LIMIT`, `PHP_OPCACHE_MEMORY_CONSUMPTION`) and its Apache settings (`remoteip`,
  `APACHE_BODY_LIMIT`, `AllowOverride All`); `/usr/local/etc/php/conf.d` is our `conf.d` (the entrypoint's
  `redis-session.ini`, your mounted `*.ini` files land there);
* php-fpm sees the container environment (`clear_env = no`), so `config/*.config.php` (Redis, S3, SMTP, ...)
  read it as under mod_php; pool size `PHP_FPM_PM*` (default `dynamic`, up to 150 workers - the official
  image's `mpm_prefork` limit); FastCGI timeout 3600 s.

Two flavours per major version:

* **`<version>`** ("pure") - the above;
* **`<version>-patched`** - the same image with one source patch: ZIP downloads of folders are
  always created as **ZIP64** (`lib/private/Streamer.php`, `zip64 => true`). Upstream disables
  ZIP64 for some clients (macOS), which limits such archives to 4 GB.

## What's inside

On top of the official image's extensions (apcu, igbinary, imagick, memcached, redis, gd, intl, ldap, gmp,
bcmath, exif, ftp, pcntl, pdo_mysql, pdo_pgsql, sysvsem, zip, opcache, ...):

* **PHP extensions**: `smbclient` and `inotify` (PECL), `imap` (with Kerberos and SSL, on UW IMAP `c-client`
  2007f built with Debian's patches) - all on the line's own OpenSSL, one OpenSSL in the process
  (`libsmbclient`'s `libldap` is the php image's own);
* **SMB/CIFS external storage**: `smbclient`, `libsmbclient` and an `smb.conf` that limits the client
  to SMB2-SMB3;
* **previews and media**: `ffmpeg`, `imagemagick`, `ghostscript` (ImageMagick 7 in imagick: SVG, HEIC, AVIF,
  WebP, PDF, TIFF, PSD);
* **tools**: `sqlite3`, `curl`, `wget`, `aria2`, `htop`, `nload`, `mc`, `nano`, `sudo`, `net-tools`,
  `iputils-ping`; our CA certificates in the system trust store.

Fatal build-time checks: PHP line = the official image's, every extension it loads is loaded, ours too, one
`libssl` / our `libldap` in the PHP process, `clear_env = no`, Apache config and modules, and a smoke test
(install on SQLite through `/entrypoint.sh`, `status.php`, WebDAV `PROPFIND` with basic auth, `cron.php`).

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

Moving from `nextcloud:<version>`: change the image name and keep everything else (volume, environment,
`user:`, cron container) - the data in `/var/www/html` is used as is, no upgrade runs for the same version.

Full reference (environment variables, cron, reverse proxy, upgrades):
[nextcloud/docker](https://github.com/nextcloud/docker) and the
[Nextcloud admin manual](https://docs.nextcloud.com/server/latest/admin_manual/).

## Notes

* Upgrade one major version at a time, as upstream requires.
* Old majors are kept for existing installations; they get no Nextcloud fixes anymore.
* `latest` follows the official image's `latest` (the newest major).
* Not supported (as with the official apache image): running the container as non-root on port 80.

Folders `pure/<tag>` are written by `bin/python/nextcloud-sync.py`.

## Links

* Source: [EpicMorg/docker](https://github.com/EpicMorg/docker) - issues and PRs welcome
* Tags float and are rebuilt weekly; pin by digest for reproducible builds: [Tags, pinning and updates](https://github.com/EpicMorg/docker#tags-pinning-and-updates)
* [CHANGELOG](https://github.com/EpicMorg/docker/blob/master/CHANGELOG.md) - License: MIT
