<!-- hub-description: nginx 1.25-1.31 built from source with 20+ dynamic modules, plus nginx + PHP-FPM bundles -->
# `epicmorg/nginx`

nginx built from the official `nginx.org` source tarballs with
[`epicmorg/gcc:14`](https://github.com/EpicMorg/docker/tree/master/linux/ecosystem/apps/gcc)
against our own OpenSSL `3.5` (LTS) and libraries from `trixie-develop`, linked with
a real `RPATH`, running on
[`epicmorg/debian:trixie`](https://github.com/EpicMorg/docker/tree/master/linux/ecosystem/base/debian).
Every nginx branch also comes bundled with each PHP version.

## What's inside

Two kinds of tags per nginx branch:

| Tag | Image |
| --- | ----- |
| `<nginx>` (e.g. `1.29`) | plain nginx, `CMD nginx -g 'daemon off;'` |
| `<nginx>-php<ver>` (e.g. `1.29-php8.3`) | [`epicmorg/php:<ver>`](https://github.com/EpicMorg/docker/tree/master/linux/ecosystem/apps/php) with that nginx copied on top; nginx and `php-fpm` under `supervisord`, talking over `/run/php/php-fpm.sock` |

nginx releases: `1.25.5`, `1.26.3`, `1.27.5`, `1.28.3`, `1.29.8`, `1.30.4`, `1.31.3`.
PHP in bundles: `5.3` ... `8.5`.

**Built in:** threads, HTTP/2 and HTTP/3, SSL, `stream` (ssl, realip, preread, geoip),
`mail`, `realip`, `sub`, `gunzip`, `gzip_static`, `auth_request`, `secure_link`,
`slice`, `dav`, `flv` / `mp4`, `image_filter`, `xslt`, `perl`, `geoip`, `stub_status`,
google perftools.

**Dynamic modules** (pinned versions, `.so` files in `/etc/nginx/modules`):
`njs` (with QuickJS), `lua` + `ndk` (OpenResty, LuaJIT2 + `lua-resty-core` / `lrucache`),
`headers-more`, `echo`, `set-misc`, `xss`, `subs_filter`, `geoip2`, `ip2location`,
`fancyindex`, `dav-ext`, `auth-pam`, `spnego` (Kerberos), `upload-progress`,
`upstream-fair`, `upstream-check`, `nchan`, `rtmp`, `mod_zip`, `unzip`, `webp`,
`user-agent`.

Layout:

* binary and html in `NGINX_DIR=/usr/local/share/epicmorg/nginx/<branch>`; config in `/etc/nginx`
* `nginx.conf` includes `/etc/nginx/modules-enabled/*.conf`, `conf.d/*.conf` and `sites-enabled/*`
* cache `/var/cache/nginx` (a `VOLUME`), logs `/var/log/nginx`
* `/etc/nginx/dhparam.pem` -> the base image's 4096-bit `/etc/ssl/dhparam.pem`

## Tags

<!-- readme-sync:tags:begin -->
| Directory | Tags |
| --------- | ---- |
| [`1.25`](1.25) | `1.25`, `1.25-php5.3`, `1.25-php5.4`, `1.25-php5.5`, `1.25-php5.6`, `1.25-php7.0`, `1.25-php7.1`, `1.25-php7.2`, `1.25-php7.3`, `1.25-php7.4`, `1.25-php8.0`, `1.25-php8.1`, `1.25-php8.2`, `1.25-php8.3`, `1.25-php8.4`, `1.25-php8.5` |
| [`1.26`](1.26) | `1.26`, `1.26-php5.3`, `1.26-php5.4`, `1.26-php5.5`, `1.26-php5.6`, `1.26-php7.0`, `1.26-php7.1`, `1.26-php7.2`, `1.26-php7.3`, `1.26-php7.4`, `1.26-php8.0`, `1.26-php8.1`, `1.26-php8.2`, `1.26-php8.3`, `1.26-php8.4`, `1.26-php8.5` |
| [`1.27`](1.27) | `1.27`, `1.27-php5.3`, `1.27-php5.4`, `1.27-php5.5`, `1.27-php5.6`, `1.27-php7.0`, `1.27-php7.1`, `1.27-php7.2`, `1.27-php7.3`, `1.27-php7.4`, `1.27-php8.0`, `1.27-php8.1`, `1.27-php8.2`, `1.27-php8.3`, `1.27-php8.4`, `1.27-php8.5` |
| [`1.28`](1.28) | `1.28`, `1.28-php5.3`, `1.28-php5.4`, `1.28-php5.5`, `1.28-php5.6`, `1.28-php7.0`, `1.28-php7.1`, `1.28-php7.2`, `1.28-php7.3`, `1.28-php7.4`, `1.28-php8.0`, `1.28-php8.1`, `1.28-php8.2`, `1.28-php8.3`, `1.28-php8.4`, `1.28-php8.5` |
| [`1.29`](1.29) | `1.29`, `1.29-php5.3`, `1.29-php5.4`, `1.29-php5.5`, `1.29-php5.6`, `1.29-php7.0`, `1.29-php7.1`, `1.29-php7.2`, `1.29-php7.3`, `1.29-php7.4`, `1.29-php8.0`, `1.29-php8.1`, `1.29-php8.2`, `1.29-php8.3`, `1.29-php8.4`, `1.29-php8.5` |
| [`1.30`](1.30) | `1.30`, `1.30-php5.3`, `1.30-php5.4`, `1.30-php5.5`, `1.30-php5.6`, `1.30-php7.0`, `1.30-php7.1`, `1.30-php7.2`, `1.30-php7.3`, `1.30-php7.4`, `1.30-php8.0`, `1.30-php8.1`, `1.30-php8.2`, `1.30-php8.3`, `1.30-php8.4`, `1.30-php8.5`, `stable` |
| [`1.31`](1.31) | `1.31`, `1.31-php5.3`, `1.31-php5.4`, `1.31-php5.5`, `1.31-php5.6`, `1.31-php7.0`, `1.31-php7.1`, `1.31-php7.2`, `1.31-php7.3`, `1.31-php7.4`, `1.31-php8.0`, `1.31-php8.1`, `1.31-php8.2`, `1.31-php8.3`, `1.31-php8.4`, `1.31-php8.5`, `latest`, `mainline` |

Every tag is pushed to `docker.io`, `quay.io` and `ghcr.io` (`epicmorg/nginx:<tag>` on each) - same digest everywhere.
<!-- readme-sync:tags:end -->

## Usage

Plain nginx (ports `80`, `443`):

```sh
docker run -d -p 80:80 -p 443:443 \
  -v ./sites-enabled:/etc/nginx/sites-enabled:ro \
  epicmorg/nginx:1.29
```

Load a dynamic module by dropping a file into `modules-enabled`:

```nginx
# /etc/nginx/modules-enabled/50-headers-more.conf
load_module /etc/nginx/modules/ngx_http_headers_more_filter_module.so;
```

nginx + PHP bundle (document root `/var/www/html`, `HEALTHCHECK` on
`http://127.0.0.1/php-fpm-ping` covers nginx and php-fpm at once):

```yml
services:
  websites:
    image: epicmorg/nginx:1.29-php8.3
    restart: unless-stopped
    environment:
      - FIX_WWW_DATA=false   # true: chown -R www-data:www-data /var/www on start
    ports:
      - "80:80"
    volumes:
      - www:/var/www
      - ./sites-enabled:/etc/nginx/sites-enabled
    tmpfs:
      - /tmp
volumes:
  www:
```

Each bundle directory has its own README, e.g.
[`1.29/php8.3`](https://github.com/EpicMorg/docker/tree/master/linux/ecosystem/apps/nginx/1.29/php8.3).

## Links

* Source: [EpicMorg/docker](https://github.com/EpicMorg/docker) - issues and PRs welcome
* Tags float and are rebuilt weekly; pin by digest for reproducible builds: [Tags, pinning and updates](https://github.com/EpicMorg/docker#tags-pinning-and-updates)
* [CHANGELOG](https://github.com/EpicMorg/docker/blob/master/CHANGELOG.md) - License: MIT
