<!-- hub-description: FreeRADIUS 3.0 / 3.2 from source (SQL, LDAP, REST, Redis, EAP), drop-in for freeradius/freeradius-server -->
# `epicmorg/freeradius`

FreeRADIUS built from the freeradius.org source tarballs (GPG signature checked with the FreeRADIUS package signing
key) on Debian 13 `trixie`, one tag per release line at its newest patch: `3.2` (current) and `3.0` (legacy, still
gets security releases). A **drop-in for `freeradius/freeradius-server`**: the configuration lives in
`/etc/freeradius` (also `/etc/raddb`), `freeradius` / `radiusd` start in the foreground, flags go to the server, any
other command (`radtest`, `radclient`, `sh`) runs as is.

## What's inside

* `radiusd` (also `freeradius`), `radclient`, `radtest`, `radmin`, `radwho` & co. in
  `/usr/local/share/epicmorg/freeradius/<major.minor>`, on `PATH`; dictionaries there too;
* modules: SQL (MySQL / MariaDB, PostgreSQL, SQLite, unixODBC, FreeTDS), LDAP, Kerberos, PAM, REST, Redis,
  memcached / rbtree / redis cache, Perl, EAP (TLS, TTLS, PEAP, MSCHAPv2, FAST, PWD, SIM / AKA, ...), unbound, YubiKey,
  winbind; `3.2` also Python 3, JSON and Kafka (3.0's Python module is Python 2 only - not built);
* OpenSSL is Debian's (trixie ships the 3.5 LTS branch): the modules' own libraries (libmariadb, libpq, libldap,
  libcurl, FreeTDS, librdkafka) all link it, so there is one OpenSSL in the process; the Debian runtime packages are
  derived from the binaries at build time (`.apt-packages`);
* the server starts as root and drops to `freerad` (as Debian); test EAP certificates are generated at build time
  like the Debian package does - **replace them for production** (`/etc/freeradius/certs`, `mods-available/eap`);
* ports `1812/udp`, `1813/udp`; logs go to `/var/log/freeradius/radius.log` (`-X` for debug output on stdout).

Not built: EAP-IKEv2 / TNC, Oracle / DB2 / Firebird / iODBC, Couchbase (no trixie libraries).

Fatal build-time checks: exact version, no unresolved libraries, no `RUNPATH`, at most one `libssl` per ELF and no
baked OpenSSL, the modules above exist, `radiusd -C` accepts the default configuration, and a smoke test on random
ports: PAP Access-Accept, Access-Reject for a wrong password, Accounting-Response, the server runs as `freerad`.

## Tags

<!-- readme-sync:tags:begin -->
| Tags | Dockerfile |
| ---- | ---------- |
| `3.0`, `3.0.28` | [`3.0`](3.0/Dockerfile) |
| `3.2`, `3.2.10`, `3`, `latest` | [`3.2`](3.2/Dockerfile) |

Every tag is pushed to `docker.io`, `quay.io` and `ghcr.io` (`epicmorg/freeradius:<tag>` on each) - same digest everywhere.
<!-- readme-sync:tags:end -->

## Usage

```yaml
services:
  radius:
    image: epicmorg/freeradius:3.2          # was: freeradius/freeradius-server:3.2.x
    restart: always
    ports:
      - "1812:1812/udp"
      - "1813:1813/udp"
    volumes:
      - ./clients.conf:/etc/freeradius/clients.conf:ro
      - ./authorize:/etc/freeradius/mods-config/files/authorize:ro
    # command: ["-X"]   # debug output
```

```sh
docker exec radius radtest alice wonderland 127.0.0.1 0 testing123
```

## Notes

* Licence: FreeRADIUS is GPLv2; the image recipe is MIT.

Folders are written by `bin/python/freeradius-versions-sync.py`.

## Links

* Source: [EpicMorg/docker](https://github.com/EpicMorg/docker) - issues and PRs welcome
* Tags float and are rebuilt weekly; pin by digest for reproducible builds: [Tags, pinning and updates](https://github.com/EpicMorg/docker#tags-pinning-and-updates)
* [CHANGELOG](https://github.com/EpicMorg/docker/blob/master/CHANGELOG.md) - License: MIT
