## TestRail 8.0.1.1029

* Based on `epicmorg/apache2:php8.1` of our ecosystem: Apache2 + PHP 8.1 (php-fpm over a unix socket), run by supervisor.
* TestRail package: `testrail-8.0.1.1029-ion81.zip` (ionCube loader is part of `epicmorg/php:8.1`).
* Cassandra PHP extension (required by TestRail 7.0+): he4rt/scylladb-php-driver v1.3.12 (PHP 8 fork of the DataStax php-driver) on a baked DataStax/Apache C/C++ driver 2.17.1 (same OpenSSL as PHP). A Cassandra server is still needed, see TestRail docs.
* supervisor programs: `php-fpm`, `apache2`, `testrail-task` (TestRail background task as `www-data`, every `TR_DEFAULT_TASK_EXECUTION` seconds, default `60`).
* On every start the entrypoint re-extracts the TestRail code into `/var/www/testrail`, so a `/var/www` volume always carries the version of the image.
* Variants with the Active Directory / LDAP authentication script: `epicmorg/testrail:auth-ad-8.0.1.1029`, `epicmorg/testrail:auth-ldap-8.0.1.1029`.

# Compose example

```yml
services:
  testrail:
    image: epicmorg/testrail:8.0.1.1029
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
