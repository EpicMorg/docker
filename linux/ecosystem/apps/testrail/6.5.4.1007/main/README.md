## TestRail 6.5.4.1007

* Based on `epicmorg/apache2:php7.2` of our ecosystem: Apache2 + PHP 7.2 (php-fpm over a unix socket), run by supervisor.
* TestRail package: `testrail-6.5.4.1007-ion72.zip` (ionCube loader is part of `epicmorg/php:7.2`).
* supervisor programs: `php-fpm`, `apache2`, `testrail-task` (TestRail background task as `www-data`, every `TR_DEFAULT_TASK_EXECUTION` seconds, default `60`).
* On every start the entrypoint re-extracts the TestRail code into `/var/www/testrail`, so a `/var/www` volume always carries the version of the image.
* Variants with the Active Directory / LDAP authentication script: `epicmorg/testrail:auth-ad-6.5.4.1007`, `epicmorg/testrail:auth-ldap-6.5.4.1007`.

# Compose example

```yml
services:
  testrail:
    image: epicmorg/testrail:6.5.4.1007
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
