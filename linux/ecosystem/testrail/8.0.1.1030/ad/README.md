## Testrail

* Based on `websites:php8.1` of our ecosystem.

# Compose example

```yml
version: '3.7'
services:
  testrail:
    image: epicmorg/testrail-ad-:8.0.1.1030
#    depends_on:
#      - mysql
#      - memcached
    restart: unless-stopped
    volumes:
      - /etc/localtime:/etc/localtime
      - /etc/timezone:/etc/timezone
#      - /etc/letsencrypt:/etc/letsencrypt
      - www:/var/www
      - apache2:/etc/apache2
      - php:/etc/php
    restart: unless-stopped
#    extra_hosts:
#      - "example.com:192.168.0.11"
    tmpfs:
      - /tmp
      - /var/lib/php/sessions
volumes:
  www:
    external: true
  apache2:
    external: true
  php:
    external: true
```
