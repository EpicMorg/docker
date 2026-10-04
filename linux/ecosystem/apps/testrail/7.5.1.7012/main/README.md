## TestRail 7.5.1.7012

* Based on `epicmorg/apache2:php7.4` of our ecosystem: Apache2 + PHP 7.4 (php-fpm over a unix socket), run by supervisor.
* TestRail package: `testrail-7.5.1.7012-ion72.zip` (ionCube loader is part of `epicmorg/php:7.4`).
* Cassandra PHP extension (required by TestRail 7.0+): Gurock's prebuilt DataStax php-driver for PHP 7.4 on a baked DataStax/Apache C/C++ driver 2.17.1 (same OpenSSL as PHP). A Cassandra server is still needed, see TestRail docs.
* supervisor programs: `php-fpm`, `apache2`, `testrail-task` (TestRail background task as `www-data`, every `TR_DEFAULT_TASK_EXECUTION` seconds, default `60`).
* On every start the entrypoint re-extracts the TestRail code into `/var/www/testrail`, so a `/var/www` volume always carries the version of the image.
* Variants with the Active Directory / LDAP authentication script: `epicmorg/testrail:auth-ad-7.5.1.7012`, `epicmorg/testrail:auth-ldap-7.5.1.7012`.

# Compose example

```yml
services:
  testrail:
    image: epicmorg/testrail:7.5.1.7012
#    depends_on:
#      - mysql
    restart: unless-stopped
    ports:
      - "80:80"
    environment:
      - TR_DEFAULT_TASK_EXECUTION=60
    volumes:
      - /etc/localtime:/etc/localtime:ro
      - /etc/timezone:/etc/timezone:ro
      - config:/var/www/testrail/config
      - attachments:/opt/testrail/attachments
      - audit:/opt/testrail/audit
      - logs:/opt/testrail/logs
      - reports:/opt/testrail/reports
    tmpfs:
      - /tmp
volumes:
  config:
  attachments:
  audit:
  logs:
  reports:
```
