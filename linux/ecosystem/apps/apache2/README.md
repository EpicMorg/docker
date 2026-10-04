<!-- hub-description: Apache2 (mpm_event) + PHP 7.0-8.5 via php-fpm over a unix socket, under supervisord -->
# `epicmorg/apache2`

Debian's Apache2 in front of our [`epicmorg/php`](https://github.com/EpicMorg/docker/tree/master/linux/ecosystem/apps/php)
images. **No `mod_php`:** PHP runs as `php-fpm`, Apache talks to it through
`mod_proxy_fcgi` over the unix socket `/run/php/php-fpm.sock`, and
`supervisord` keeps both processes running.

## What's inside

* `FROM epicmorg/php:<ver>` - one tag per PHP branch, `php7.0` ... `php8.5`. All
  PHP extensions, `ionCube` / `phpBolt` loaders and helper scripts
  (`php-ext-enable`, `phpenmod`, ...) of the PHP image are there.
* Apache with `mpm_event` (prefork and worker disabled) and `proxy_fcgi`, `ssl`,
  `rewrite`, `headers`, `ldap` / `authnz_ldap`, `lua` and friends enabled; extra
  modules `fcgid`, `xsendfile`, `encoding` installed.
* The PHP handler is server-wide (`/etc/apache2/conf-enabled/php-fpm.conf`), so every
  vhost gets PHP. Default site: `localhost`, document root `/var/www/html`.
* php-fpm pool overrides in `${PHP_INI_DIR}/php-fpm.d/` (`zz-apache.conf` pins the socket).
* Supervisor programs in `/etc/supervisor/conf.d/{php-fpm,apache2}.conf` - drop
  your own `.conf` next to them to run more processes.
* `HEALTHCHECK`: `GET http://127.0.0.1/php-fpm-ping` through Apache - checks
  Apache and php-fpm at once.

## Tags

<!-- readme-sync:tags:begin -->
| Tags | Dockerfile |
| ---- | ---------- |
| `php7.0` | [`php7.0`](php7.0/Dockerfile) |
| `php7.1` | [`php7.1`](php7.1/Dockerfile) |
| `php7.2` | [`php7.2`](php7.2/Dockerfile) |
| `php7.3` | [`php7.3`](php7.3/Dockerfile) |
| `php7.4` | [`php7.4`](php7.4/Dockerfile) |
| `php8.0` | [`php8.0`](php8.0/Dockerfile) |
| `php8.1` | [`php8.1`](php8.1/Dockerfile) |
| `php8.2` | [`php8.2`](php8.2/Dockerfile) |
| `php8.3` | [`php8.3`](php8.3/Dockerfile) |
| `php8.4` | [`php8.4`](php8.4/Dockerfile) |
| `php8.5` | [`php8.5`](php8.5/Dockerfile) |

Every tag is pushed to `docker.io`, `quay.io` and `ghcr.io` (`epicmorg/apache2:<tag>` on each) - same digest everywhere.
<!-- readme-sync:tags:end -->

## Usage

Ports `80` and `443` are exposed; the container runs `supervisord -n`.

```yml
services:
  websites:
    image: epicmorg/apache2:php8.4
    restart: unless-stopped
    environment:
      - FIX_WWW_DATA=false   # true: chown -R www-data:www-data /var/www on start
    ports:
      - "80:80"
    volumes:
      - www:/var/www
    tmpfs:
      - /tmp
volumes:
  www:
```

Downstream images replace the default site:

```dockerfile
FROM epicmorg/apache2:php8.4
COPY etc/apache2/sites-available/mysite.conf /etc/apache2/sites-available/mysite.conf
RUN a2dissite localhost && a2ensite mysite && apachectl configtest
```

Each tag directory has its own README with the exact layout:
[`php8.4`](https://github.com/EpicMorg/docker/tree/master/linux/ecosystem/apps/apache2/php8.4).

## Links

* Source: [EpicMorg/docker](https://github.com/EpicMorg/docker) - issues and PRs welcome
* Tags float and are rebuilt weekly; pin by digest for reproducible builds: [Tags, pinning and updates](https://github.com/EpicMorg/docker#tags-pinning-and-updates)
* [CHANGELOG](https://github.com/EpicMorg/docker/blob/master/CHANGELOG.md) - License: MIT
