# Apache2 + PHP 7.4 (fpm)

`epicmorg/php:7.4` + Debian `apache2` (mpm_event). No mod_php: PHP runs as
`php-fpm`, Apache talks to it through `mod_proxy_fcgi` over
`/run/php/php-fpm.sock`, `supervisord` runs both.

* document root: `/var/www/html`
* PHP handler: `/etc/apache2/conf-enabled/php-fpm.conf` (server-wide, every vhost gets PHP)
* sites: `/etc/apache2/sites-available/` + `a2ensite`/`a2dissite` (default: `localhost`)
* php-fpm pool: `${PHP_INI_DIR}/php-fpm.d/` (`zz-apache.conf` pins the unix socket)
* supervisor: `/etc/supervisor/conf.d/{php-fpm,apache2}.conf` - drop extra programs next to them
  (`supervisorctl -u dummy -p dummy status`; the dummy auth only silences a supervisor warning, the socket is root-only)
* healthcheck: `GET http://127.0.0.1/php-fpm-ping` through Apache (checks Apache and php-fpm at once, local only)
* `FIX_WWW_DATA=true` - `chown -R www-data:www-data /var/www` on start

Downstream images replace the default site:

```dockerfile
FROM epicmorg/apache2:php7.4
COPY etc/apache2/sites-available/mysite.conf /etc/apache2/sites-available/mysite.conf
RUN a2dissite localhost && a2ensite mysite && apachectl configtest
```

# Compose example

```yml
services:
  websites:
    image: epicmorg/apache2:php7.4
    restart: unless-stopped
    environment:
      - FIX_WWW_DATA=false
    ports:
      - "80:80"
    volumes:
      - /etc/localtime:/etc/localtime:ro
      - /etc/timezone:/etc/timezone:ro
      - www:/var/www
    tmpfs:
      - /tmp
volumes:
  www:
    external: true
```
