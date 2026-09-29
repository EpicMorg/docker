## TestRail 5.6.0.3862

* Based on `epicmorg/apache2:php7.0` of our ecosystem: Apache2 + PHP 7.0 (php-fpm over a unix socket), run by supervisor.
* TestRail package: `testrail-5.6.0.3862-ion70.zip` (ionCube loader is part of `epicmorg/php:7.0`).
* supervisor programs: `php-fpm`, `apache2`, `testrail-task` (TestRail background task as `www-data`, every `TR_DEFAULT_TASK_EXECUTION` seconds, default `60`).
* On every start the entrypoint re-extracts the TestRail code into `/var/www/testrail`, so a `/var/www` volume always carries the version of the image.
* Variants with the Active Directory / LDAP authentication script: `epicmorg/testrail:auth-ad-5.6.0.3862`, `epicmorg/testrail:auth-ldap-5.6.0.3862`.

# Compose example

```yml
services:
  testrail:
    image: epicmorg/testrail:5.6.0.3862
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
