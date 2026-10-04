<!-- hub-description: Official Zabbix 3.0-7.4 images (Ubuntu) + admin tools, extra CA certs, locales -->
# EpicMorg Zabbix images

Every component of the official [Zabbix](https://www.zabbix.com/) container images, rebuilt on top
of the upstream `zabbix/<component>:<version>-ubuntu-latest` tags with a few additions for
day-to-day administration. The Zabbix software itself, its entrypoints and all configuration
variables are **unchanged** - this README lists only what we add.

| Repository | Upstream image | What it is |
| ---------- | -------------- | ---------- |
| `epicmorg/zabbix-server-mysql` | `zabbix/zabbix-server-mysql` | Zabbix server, MySQL/MariaDB backend |
| `epicmorg/zabbix-server-pgsql` | `zabbix/zabbix-server-pgsql` | Zabbix server, PostgreSQL backend |
| `epicmorg/zabbix-proxy-mysql` | `zabbix/zabbix-proxy-mysql` | Zabbix proxy, MySQL backend |
| `epicmorg/zabbix-proxy-sqlite3` | `zabbix/zabbix-proxy-sqlite3` | Zabbix proxy, SQLite3 backend |
| `epicmorg/zabbix-web-apache-mysql` | `zabbix/zabbix-web-apache-mysql` | Web frontend (Apache), MySQL |
| `epicmorg/zabbix-web-apache-pgsql` | `zabbix/zabbix-web-apache-pgsql` | Web frontend (Apache), PostgreSQL |
| `epicmorg/zabbix-agent` | `zabbix/zabbix-agent` | Zabbix agent |
| `epicmorg/zabbix-agent2` | `zabbix/zabbix-agent2` | Zabbix agent 2 (no `3.0` / `4.0` tags) |
| `epicmorg/zabbix-java-gateway` | `zabbix/zabbix-java-gateway` | Java gateway (JMX monitoring) |
| `epicmorg/zabbix-snmptraps` | `zabbix/zabbix-snmptraps` | SNMP traps receiver |

Version tags follow the upstream release lines (`3.0` ... `7.4`); `latest` follows upstream
`ubuntu-latest`, `trunk` follows upstream `ubuntu-trunk` (development builds).

## What's inside

On top of the upstream image:

* **apt sources** replaced with full Ubuntu repositories (`main restricted universe multiverse`) for the
  Ubuntu release of that line;
* **admin / troubleshooting tools**: `curl`, `wget`, `jq`, `nmap`, `telnet`, `iputils-ping`,
  `iperf` / `iperf3`, `iftop`, `iotop`, `htop`, `lsof`, `procps`, `smbclient`, `lynx`, `mc`, `nano`,
  `tmux`, `dos2unix`, `logrotate`, `acl`, `openssl`, `php-cli` + `php-curl` (for PHP-based external
  checks and alert scripts);
* **sudo for `nmap`**: the `zabbix` user may run `/usr/bin/nmap` via `sudo` without a password
  (`/etc/sudoers.d/zabbix`) - for scans that need raw sockets;
* **locales** `en_US`, `en_GB`, `ru_RU`, `ru_UA` (UTF-8 plus legacy 8-bit charsets) and `console-cyrillic`;
* **extra CA certificates** in the system trust store: EpicMorg root / intermediate CAs and the
  Russian Trusted Root / Sub CAs.

## Tags

<!-- readme-sync:tags:begin -->
### `epicmorg/zabbix-agent`


| Tags | Dockerfile |
| ---- | ---------- |
| `3.0` | [`3.0/agent`](3.0/agent/Dockerfile) |
| `4.0` | [`4.0/agent`](4.0/agent/Dockerfile) |
| `5.0` | [`5.0/agent`](5.0/agent/Dockerfile) |
| `5.2` | [`5.2/agent`](5.2/agent/Dockerfile) |
| `5.4` | [`5.4/agent`](5.4/agent/Dockerfile) |
| `6.0` | [`6.0/agent`](6.0/agent/Dockerfile) |
| `6.2` | [`6.2/agent`](6.2/agent/Dockerfile) |
| `6.4` | [`6.4/agent`](6.4/agent/Dockerfile) |
| `7.0` | [`7.0/agent`](7.0/agent/Dockerfile) |
| `7.2` | [`7.2/agent`](7.2/agent/Dockerfile) |
| `7.4` | [`7.4/agent`](7.4/agent/Dockerfile) |
| `latest` | [`latest/agent`](latest/agent/Dockerfile) |
| `trunk` | [`trunk/agent`](trunk/agent/Dockerfile) |

Every tag is pushed to `docker.io`, `quay.io` and `ghcr.io` (`epicmorg/zabbix-agent:<tag>` on each) - same digest everywhere.


### `epicmorg/zabbix-agent2`


| Tags | Dockerfile |
| ---- | ---------- |
| `5.0` | [`5.0/agent2`](5.0/agent2/Dockerfile) |
| `5.2` | [`5.2/agent2`](5.2/agent2/Dockerfile) |
| `5.4` | [`5.4/agent2`](5.4/agent2/Dockerfile) |
| `6.0` | [`6.0/agent2`](6.0/agent2/Dockerfile) |
| `6.2` | [`6.2/agent2`](6.2/agent2/Dockerfile) |
| `6.4` | [`6.4/agent2`](6.4/agent2/Dockerfile) |
| `7.0` | [`7.0/agent2`](7.0/agent2/Dockerfile) |
| `7.2` | [`7.2/agent2`](7.2/agent2/Dockerfile) |
| `7.4` | [`7.4/agent2`](7.4/agent2/Dockerfile) |
| `latest` | [`latest/agent2`](latest/agent2/Dockerfile) |
| `trunk` | [`trunk/agent2`](trunk/agent2/Dockerfile) |

Every tag is pushed to `docker.io`, `quay.io` and `ghcr.io` (`epicmorg/zabbix-agent2:<tag>` on each) - same digest everywhere.


### `epicmorg/zabbix-java-gateway`


| Tags | Dockerfile |
| ---- | ---------- |
| `3.0` | [`3.0/java-gateway`](3.0/java-gateway/Dockerfile) |
| `4.0` | [`4.0/java-gateway`](4.0/java-gateway/Dockerfile) |
| `5.0` | [`5.0/java-gateway`](5.0/java-gateway/Dockerfile) |
| `5.2` | [`5.2/java-gateway`](5.2/java-gateway/Dockerfile) |
| `5.4` | [`5.4/java-gateway`](5.4/java-gateway/Dockerfile) |
| `6.0` | [`6.0/java-gateway`](6.0/java-gateway/Dockerfile) |
| `6.2` | [`6.2/java-gateway`](6.2/java-gateway/Dockerfile) |
| `6.4` | [`6.4/java-gateway`](6.4/java-gateway/Dockerfile) |
| `7.0` | [`7.0/java-gateway`](7.0/java-gateway/Dockerfile) |
| `7.2` | [`7.2/java-gateway`](7.2/java-gateway/Dockerfile) |
| `7.4` | [`7.4/java-gateway`](7.4/java-gateway/Dockerfile) |
| `latest` | [`latest/java-gateway`](latest/java-gateway/Dockerfile) |
| `trunk` | [`trunk/java-gateway`](trunk/java-gateway/Dockerfile) |

Every tag is pushed to `docker.io`, `quay.io` and `ghcr.io` (`epicmorg/zabbix-java-gateway:<tag>` on each) - same digest everywhere.


### `epicmorg/zabbix-proxy-mysql`


| Tags | Dockerfile |
| ---- | ---------- |
| `3.0` | [`3.0/proxy-mysql`](3.0/proxy-mysql/Dockerfile) |
| `4.0` | [`4.0/proxy-mysql`](4.0/proxy-mysql/Dockerfile) |
| `5.0` | [`5.0/proxy-mysql`](5.0/proxy-mysql/Dockerfile) |
| `5.2` | [`5.2/proxy-mysql`](5.2/proxy-mysql/Dockerfile) |
| `5.4` | [`5.4/proxy-mysql`](5.4/proxy-mysql/Dockerfile) |
| `6.0` | [`6.0/proxy-mysql`](6.0/proxy-mysql/Dockerfile) |
| `6.2` | [`6.2/proxy-mysql`](6.2/proxy-mysql/Dockerfile) |
| `6.4` | [`6.4/proxy-mysql`](6.4/proxy-mysql/Dockerfile) |
| `7.0` | [`7.0/proxy-mysql`](7.0/proxy-mysql/Dockerfile) |
| `7.2` | [`7.2/proxy-mysql`](7.2/proxy-mysql/Dockerfile) |
| `7.4` | [`7.4/proxy-mysql`](7.4/proxy-mysql/Dockerfile) |
| `latest` | [`latest/proxy-mysql`](latest/proxy-mysql/Dockerfile) |
| `trunk` | [`trunk/proxy-mysql`](trunk/proxy-mysql/Dockerfile) |

Every tag is pushed to `docker.io`, `quay.io` and `ghcr.io` (`epicmorg/zabbix-proxy-mysql:<tag>` on each) - same digest everywhere.


### `epicmorg/zabbix-proxy-sqlite3`


| Tags | Dockerfile |
| ---- | ---------- |
| `3.0` | [`3.0/proxy-sqlite3`](3.0/proxy-sqlite3/Dockerfile) |
| `4.0` | [`4.0/proxy-sqlite3`](4.0/proxy-sqlite3/Dockerfile) |
| `5.0` | [`5.0/proxy-sqlite3`](5.0/proxy-sqlite3/Dockerfile) |
| `5.2` | [`5.2/proxy-sqlite3`](5.2/proxy-sqlite3/Dockerfile) |
| `5.4` | [`5.4/proxy-sqlite3`](5.4/proxy-sqlite3/Dockerfile) |
| `6.0` | [`6.0/proxy-sqlite3`](6.0/proxy-sqlite3/Dockerfile) |
| `6.2` | [`6.2/proxy-sqlite3`](6.2/proxy-sqlite3/Dockerfile) |
| `6.4` | [`6.4/proxy-sqlite3`](6.4/proxy-sqlite3/Dockerfile) |
| `7.0` | [`7.0/proxy-sqlite3`](7.0/proxy-sqlite3/Dockerfile) |
| `7.2` | [`7.2/proxy-sqlite3`](7.2/proxy-sqlite3/Dockerfile) |
| `7.4` | [`7.4/proxy-sqlite3`](7.4/proxy-sqlite3/Dockerfile) |
| `latest` | [`latest/proxy-sqlite3`](latest/proxy-sqlite3/Dockerfile) |
| `trunk` | [`trunk/proxy-sqlite3`](trunk/proxy-sqlite3/Dockerfile) |

Every tag is pushed to `docker.io`, `quay.io` and `ghcr.io` (`epicmorg/zabbix-proxy-sqlite3:<tag>` on each) - same digest everywhere.


### `epicmorg/zabbix-server-mysql`


| Tags | Dockerfile |
| ---- | ---------- |
| `3.0` | [`3.0/server-mysql`](3.0/server-mysql/Dockerfile) |
| `4.0` | [`4.0/server-mysql`](4.0/server-mysql/Dockerfile) |
| `5.0` | [`5.0/server-mysql`](5.0/server-mysql/Dockerfile) |
| `5.2` | [`5.2/server-mysql`](5.2/server-mysql/Dockerfile) |
| `5.4` | [`5.4/server-mysql`](5.4/server-mysql/Dockerfile) |
| `6.0` | [`6.0/server-mysql`](6.0/server-mysql/Dockerfile) |
| `6.2` | [`6.2/server-mysql`](6.2/server-mysql/Dockerfile) |
| `6.4` | [`6.4/server-mysql`](6.4/server-mysql/Dockerfile) |
| `7.0` | [`7.0/server-mysql`](7.0/server-mysql/Dockerfile) |
| `7.2` | [`7.2/server-mysql`](7.2/server-mysql/Dockerfile) |
| `7.4` | [`7.4/server-mysql`](7.4/server-mysql/Dockerfile) |
| `latest` | [`latest/server-mysql`](latest/server-mysql/Dockerfile) |
| `trunk` | [`trunk/server-mysql`](trunk/server-mysql/Dockerfile) |

Every tag is pushed to `docker.io`, `quay.io` and `ghcr.io` (`epicmorg/zabbix-server-mysql:<tag>` on each) - same digest everywhere.


### `epicmorg/zabbix-server-pgsql`


| Tags | Dockerfile |
| ---- | ---------- |
| `3.0` | [`3.0/server-pgsql`](3.0/server-pgsql/Dockerfile) |
| `4.0` | [`4.0/server-pgsql`](4.0/server-pgsql/Dockerfile) |
| `5.0` | [`5.0/server-pgsql`](5.0/server-pgsql/Dockerfile) |
| `5.2` | [`5.2/server-pgsql`](5.2/server-pgsql/Dockerfile) |
| `5.4` | [`5.4/server-pgsql`](5.4/server-pgsql/Dockerfile) |
| `6.0` | [`6.0/server-pgsql`](6.0/server-pgsql/Dockerfile) |
| `6.2` | [`6.2/server-pgsql`](6.2/server-pgsql/Dockerfile) |
| `6.4` | [`6.4/server-pgsql`](6.4/server-pgsql/Dockerfile) |
| `7.0` | [`7.0/server-pgsql`](7.0/server-pgsql/Dockerfile) |
| `7.2` | [`7.2/server-pgsql`](7.2/server-pgsql/Dockerfile) |
| `7.4` | [`7.4/server-pgsql`](7.4/server-pgsql/Dockerfile) |
| `latest` | [`latest/server-pgsql`](latest/server-pgsql/Dockerfile) |
| `trunk` | [`trunk/server-pgsql`](trunk/server-pgsql/Dockerfile) |

Every tag is pushed to `docker.io`, `quay.io` and `ghcr.io` (`epicmorg/zabbix-server-pgsql:<tag>` on each) - same digest everywhere.


### `epicmorg/zabbix-snmptraps`


| Tags | Dockerfile |
| ---- | ---------- |
| `3.0` | [`3.0/snmptraps`](3.0/snmptraps/Dockerfile) |
| `4.0` | [`4.0/snmptraps`](4.0/snmptraps/Dockerfile) |
| `5.0` | [`5.0/snmptraps`](5.0/snmptraps/Dockerfile) |
| `5.2` | [`5.2/snmptraps`](5.2/snmptraps/Dockerfile) |
| `5.4` | [`5.4/snmptraps`](5.4/snmptraps/Dockerfile) |
| `6.0` | [`6.0/snmptraps`](6.0/snmptraps/Dockerfile) |
| `6.2` | [`6.2/snmptraps`](6.2/snmptraps/Dockerfile) |
| `6.4` | [`6.4/snmptraps`](6.4/snmptraps/Dockerfile) |
| `7.0` | [`7.0/snmptraps`](7.0/snmptraps/Dockerfile) |
| `7.2` | [`7.2/snmptraps`](7.2/snmptraps/Dockerfile) |
| `7.4` | [`7.4/snmptraps`](7.4/snmptraps/Dockerfile) |
| `latest` | [`latest/snmptraps`](latest/snmptraps/Dockerfile) |
| `trunk` | [`trunk/snmptraps`](trunk/snmptraps/Dockerfile) |

Every tag is pushed to `docker.io`, `quay.io` and `ghcr.io` (`epicmorg/zabbix-snmptraps:<tag>` on each) - same digest everywhere.


### `epicmorg/zabbix-web-apache-mysql`


| Tags | Dockerfile |
| ---- | ---------- |
| `3.0` | [`3.0/web-mysql`](3.0/web-mysql/Dockerfile) |
| `4.0` | [`4.0/web-mysql`](4.0/web-mysql/Dockerfile) |
| `5.0` | [`5.0/web-mysql`](5.0/web-mysql/Dockerfile) |
| `5.2` | [`5.2/web-mysql`](5.2/web-mysql/Dockerfile) |
| `5.4` | [`5.4/web-mysql`](5.4/web-mysql/Dockerfile) |
| `6.0` | [`6.0/web-mysql`](6.0/web-mysql/Dockerfile) |
| `6.2` | [`6.2/web-mysql`](6.2/web-mysql/Dockerfile) |
| `6.4` | [`6.4/web-mysql`](6.4/web-mysql/Dockerfile) |
| `7.0` | [`7.0/web-mysql`](7.0/web-mysql/Dockerfile) |
| `7.2` | [`7.2/web-mysql`](7.2/web-mysql/Dockerfile) |
| `7.4` | [`7.4/web-mysql`](7.4/web-mysql/Dockerfile) |
| `latest` | [`latest/web-mysql`](latest/web-mysql/Dockerfile) |
| `trunk` | [`trunk/web-mysql`](trunk/web-mysql/Dockerfile) |

Every tag is pushed to `docker.io`, `quay.io` and `ghcr.io` (`epicmorg/zabbix-web-apache-mysql:<tag>` on each) - same digest everywhere.


### `epicmorg/zabbix-web-apache-pgsql`


| Tags | Dockerfile |
| ---- | ---------- |
| `3.0` | [`3.0/web-pgsql`](3.0/web-pgsql/Dockerfile) |
| `4.0` | [`4.0/web-pgsql`](4.0/web-pgsql/Dockerfile) |
| `5.0` | [`5.0/web-pgsql`](5.0/web-pgsql/Dockerfile) |
| `5.2` | [`5.2/web-pgsql`](5.2/web-pgsql/Dockerfile) |
| `5.4` | [`5.4/web-pgsql`](5.4/web-pgsql/Dockerfile) |
| `6.0` | [`6.0/web-pgsql`](6.0/web-pgsql/Dockerfile) |
| `6.2` | [`6.2/web-pgsql`](6.2/web-pgsql/Dockerfile) |
| `6.4` | [`6.4/web-pgsql`](6.4/web-pgsql/Dockerfile) |
| `7.0` | [`7.0/web-pgsql`](7.0/web-pgsql/Dockerfile) |
| `7.2` | [`7.2/web-pgsql`](7.2/web-pgsql/Dockerfile) |
| `7.4` | [`7.4/web-pgsql`](7.4/web-pgsql/Dockerfile) |
| `latest` | [`latest/web-pgsql`](latest/web-pgsql/Dockerfile) |
| `trunk` | [`trunk/web-pgsql`](trunk/web-pgsql/Dockerfile) |

Every tag is pushed to `docker.io`, `quay.io` and `ghcr.io` (`epicmorg/zabbix-web-apache-pgsql:<tag>` on each) - same digest everywhere.
<!-- readme-sync:tags:end -->

## Usage

The images are drop-in replacements for the upstream ones: same ports, volumes and environment
variables. Swap the image name in your existing deployment, e.g.:

```yml
services:
  zabbix-server:
    image: epicmorg/zabbix-server-pgsql:7.0
    environment:
      DB_SERVER_HOST: postgres
      POSTGRES_USER: zabbix
      POSTGRES_PASSWORD: zabbix
    ports:
      - "10051:10051"

  zabbix-web:
    image: epicmorg/zabbix-web-apache-pgsql:7.0
    environment:
      ZBX_SERVER_HOST: zabbix-server
      DB_SERVER_HOST: postgres
      POSTGRES_USER: zabbix
      POSTGRES_PASSWORD: zabbix
    ports:
      - "8080:8080"

  zabbix-agent:
    image: epicmorg/zabbix-agent2:7.0
    environment:
      ZBX_SERVER_HOST: zabbix-server
```

For the full list of environment variables, ports and volumes of every component see the upstream
documentation: [Zabbix in Docker](https://www.zabbix.com/documentation/current/en/manual/installation/containers)
and [zabbix/zabbix-docker](https://github.com/zabbix/zabbix-docker).

## Notes

* Keep the server, proxy, web and agent tags on the same release line.
* Runtime user: `7.0`, `7.2`, `7.4`, `latest` and `trunk` switch back to the upstream `zabbix` user;
  the older lines (`3.0` ... `6.4`) are left as `root` after our additions.
* `trunk` is upstream's development branch - not for production.
* Old lines (`3.0`, `4.0`, ...) are kept for existing installations; they get no new upstream fixes.

## Links

* Source: [EpicMorg/docker](https://github.com/EpicMorg/docker) - issues and PRs welcome
* Tags float and are rebuilt weekly; pin by digest for reproducible builds: [Tags, pinning and updates](https://github.com/EpicMorg/docker#tags-pinning-and-updates)
* [CHANGELOG](https://github.com/EpicMorg/docker/blob/master/CHANGELOG.md) - License: MIT
