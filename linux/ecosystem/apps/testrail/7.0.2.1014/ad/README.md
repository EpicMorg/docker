## TestRail 7.0.2.1014 with the Active Directory authentication script

* Based on `epicmorg/testrail:7.0.2.1014` (Apache2 + PHP 7.4 via php-fpm, supervisor).
* Adds the PHP `ldap` extension (built against a baked OpenLDAP 2.6 client library that uses the same OpenSSL as PHP).
* Adds the TestRail `testrail-auth-ad-1.4` script, unpacked to `/testrail-release/testrail-auth-ad-1.4/`.
  Set the `AUTH_*` constants in a copy of `auth.php` and mount it as `/var/www/testrail/custom/auth/auth.php`
  (see the bundled `readme.txt` and the TestRail docs on authentication scripts).

# Compose example

```yml
services:
  testrail:
    image: epicmorg/testrail:auth-ad-7.0.2.1014
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
      - ./auth.php:/var/www/testrail/custom/auth/auth.php:ro
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
