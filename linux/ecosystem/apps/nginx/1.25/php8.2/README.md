# nginx 1.25 + PHP 8.2 (fpm)

`epicmorg/php:8.2` with `epicmorg/nginx:1.25` copied on top. Both run under
`supervisord`; nginx talks to php-fpm over `/run/php/php-fpm.sock`.

* document root: `/var/www/html`
* vhosts: `/etc/nginx/sites-enabled/` (default: `sites-available/default.conf`)
* php-fpm pool: `${PHP_INI_DIR}/php-fpm.d/` (`zz-nginx.conf` pins the socket)
* healthcheck: `GET http://127.0.0.1/php-fpm-ping` (checks nginx and php-fpm at once)
* `FIX_WWW_DATA=true` - `chown -R www-data:www-data /var/www` on start

# Compose example

```yml
services:
  websites:
    image: epicmorg/nginx:1.25-php8.2
    restart: unless-stopped
    environment:
      - FIX_WWW_DATA=false
    ports:
      - "80:80"
    volumes:
      - /etc/localtime:/etc/localtime:ro
      - /etc/timezone:/etc/timezone:ro
      - www:/var/www
      - ./sites-enabled:/etc/nginx/sites-enabled
    tmpfs:
      - /tmp
volumes:
  www:
    external: true
```
