## Testrail

* Based on `websites:php7.4` of our ecosystem.

# Compose example

```yml
services:
  testrail:
    image: epicmorg/testrail-ad-:7.5.1.7012
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
