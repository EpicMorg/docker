<!-- hub-description: Helix Swarm (P4 Code Review) on Apache + PHP-FPM, drop-in for perforce/helix-swarm -->
# `epicmorg/swarm`

Perforce Helix Swarm (P4 Code Review) on Debian 13 `trixie`, built `FROM`
[`epicmorg/apache2:php8.4`](https://github.com/EpicMorg/docker/tree/master/linux/ecosystem/apps/apache2)
(Apache + PHP-FPM, no `mod_php`). A **drop-in for `perforce/helix-swarm`**: the same variables, the same
data volume layout (`/opt/perforce/swarm/data`), the same vhost file name - change the `image:` line and keep the
environment, volumes and a bind-mounted `perforce-swarm-site.conf`. Pair it with
[`epicmorg/redis`](https://github.com/EpicMorg/docker/tree/master/linux/ecosystem/apps/redis) (drop-in for
`bitnami/redis`) and [`epicmorg/p4d`](https://github.com/EpicMorg/docker/tree/master/linux/ecosystem/apps/perforce/p4d).

## What's inside

* Swarm from Perforce's filehost tarball (`r<yy.n>/bin.multiarch/swarm.tgz`, sha256-checked against their
  `SHA256SUMS`) in `/opt/perforce/swarm` - the same source as our `p4` binaries; `p4` of the matching Helix
  release from [`epicmorg/perforce`](https://github.com/EpicMorg/docker/tree/master/linux/ecosystem/apps/perforce/base);
* the pieces that ship only in Perforce's Ubuntu package (vhost, cron job, logrotate rules, WebSocket gateway
  wrapper, extension config template) taken from the `helix-swarm` deb of the same build at build time
  (sha256-checked, unpacked - not installed);
* PHP 8.4 with Swarm's own P4PHP build (`p4-bin/bin.linux26x86_64/perforce-php84-ssl3.so`, sharing PHP's baked
  OpenSSL 3.5), redis (igbinary), imagick, gd, mbstring, xml, xsl; `memory_limit 2048M`;
* LibreOffice (calc / draw / impress / writer) for office document previews (= `helix-swarm-optional`);
* supervisord: `apache2`, `php-fpm`, `cron` (Swarm workers via `swarm-cron.sh`), `swarm-websocket` (opt-in);
* volume `/opt/perforce/swarm/data`, ports `80` / `443`; `HEALTHCHECK` = php-fpm ping through Apache.

Fatal build-time checks: Swarm release and build, P4PHP is Swarm's and the only one, one `libssl` in a PHP
process and it is the baked one, the PHP extensions Swarm needs, no `mod_php`, the Swarm vhost is the only site,
bundled Node present.

### Deviations from Perforce's image

* PHP is php-fpm: Swarm's `public/.htaccess` guards (`<IfModule mod_php.c>`) are switched to
  `mod_proxy_fcgi`, its `php_value` lines moved to `conf.d/30-swarm.ini`; `CGIPassAuth On` for the Swarm
  directory so the API sees HTTP basic auth.
* First-start configuration is done by our entrypoint (the tarball has no `configure-swarm.sh`), the same steps:
  Swarm user + password (super-set, then re-set by the user - a super-set password is "expired" on current P4D),
  `admin` protections line, long-lived ticket group `swarm-group`, `data/config.php`, worker token, server-side
  extension (global + instance config). Secrets are never printed.
* Persisted PHP settings are `data/docker/php.ini` as an *overlay* ini (an upstream volume's whole Ubuntu
  `php.ini` is kept aside as `php.ini.upstream`).
* cron's `pam_loginuid` is optional - required, it silently drops every job in a container.

## Variables

| Variable | Default | Meaning |
| -------- | ------- | ------- |
| `P4D_PORT` | `ssl:perforce:1666` | P4D address (`ssl:` = `p4 trust -y` first) |
| `P4D_SUPER` / `P4D_SUPER_PASSWD` (`_FILE`) | `super` / _(none)_ | super user, first start only |
| `P4D_GRACE` | `30` | seconds to wait for P4D |
| `SWARM_USER` / `SWARM_PASSWD` (`_FILE`) | `swarm` / _(none)_ | Swarm's P4D user (created if missing), first start only |
| `SWARM_HOST` | `helix-swarm` | `environment.hostname`, vhost `ServerName` |
| `SWARM_EXT_URL` | `http://${SWARM_HOST}/` | Swarm URL written into the extension (where P4D reaches Swarm) |
| `SWARM_MAILHOST` | `localhost` | mail relay |
| `SWARM_REDIS` / `SWARM_REDIS_PORT` | `helix-redis` / `7379` | redis server |
| `SWARM_REDIS_PASSWD` (`_FILE`) / `SWARM_REDIS_NAMESPACE` | _(none)_ | redis password / key namespace |
| `SWARM_FORCE_EXT` | `n` | `y` = replace an already installed Swarm extension |
| `SWARM_WS_ENABLED` | `n` | `y` = WebSocket live updates (fresh install only) |
| `SWARM_WS_ALLOWED_ORIGINS` | _(derived)_ | gateway's allowed origins |

Configuration happens once, when `data/config.php` does not exist; later starts only restore the persisted
pieces (cron hosts, `public/custom`, PHP overlay, vhosts in `data/docker/sites-available` if an upstream volume
has them). Edit `data/config.php` for anything else and restart.

## Tags

<!-- readme-sync:tags:begin -->
| Tags | Dockerfile |
| ---- | ---------- |
| `2026.3`, `2026.3.3030911`, `latest` | [`2026.3`](2026.3/Dockerfile) |

Every tag is pushed to `docker.io`, `quay.io` and `ghcr.io` (`epicmorg/swarm:<tag>` on each) - same digest everywhere.
<!-- readme-sync:tags:end -->

## Usage

```yaml
services:
  swarm:
    image: epicmorg/swarm:2026.3
    restart: always
    stop_grace_period: 30s
    ports:
      - "80:80"
      - "443:443"
    environment:
      P4D_PORT: ssl:p4.example.com:1666
      P4D_SUPER: super
      P4D_SUPER_PASSWD_FILE: /run/secrets/p4super
      SWARM_USER: swarm
      SWARM_PASSWD_FILE: /run/secrets/swarm
      SWARM_HOST: swarm.example.com
      SWARM_MAILHOST: mail.example.com
      SWARM_REDIS: helix-redis
      SWARM_REDIS_PORT: "6379"
    volumes:
      - ./swarm:/opt/perforce/swarm/data
      # HTTPS: your own vhost (the shipped one is plain :80)
      # - ./perforce-swarm-site.conf:/etc/apache2/sites-available/perforce-swarm-site.conf:ro
      # - ./certs:/etc/apache2/ssl:ro
    secrets: [p4super, swarm]
    depends_on: [helix-redis]
  helix-redis:
    image: epicmorg/redis:8
    restart: always
    environment:
      ALLOW_EMPTY_PASSWORD: "yes"     # or REDIS_PASSWORD + SWARM_REDIS_PASSWD
    volumes:
      - ./redis:/data
secrets:
  p4super:
    file: ./p4super.txt
  swarm:
    file: ./swarm.txt
```

## Notes

* Swarm-URL in the extension must be reachable **from P4D**; set `SWARM_EXT_URL` when that differs from
  `http://SWARM_HOST/` (e.g. HTTPS). Later: `p4 extension --configure Perforce::helix-swarm`.
* Perforce strongly recommends a Unicode-mode P4D for Swarm (logged at first start if it is not).

## Links

* Source: [EpicMorg/docker](https://github.com/EpicMorg/docker) - issues and PRs welcome
* Tags float and are rebuilt weekly; pin by digest for reproducible builds: [Tags, pinning and updates](https://github.com/EpicMorg/docker#tags-pinning-and-updates)
* [CHANGELOG](https://github.com/EpicMorg/docker/blob/master/CHANGELOG.md) - License: MIT (the image recipe; Swarm
  itself is Perforce software under its own licence)
