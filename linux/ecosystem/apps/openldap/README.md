<!-- hub-description: OpenLDAP 2.4-2.7 from source (baked OpenSSL + Cyrus SASL), drop-in for bitnami/openldap -->
# `epicmorg/openldap`

OpenLDAP `slapd` built from the openldap.org source tarballs (checked against openldap.org's own checksums) on
Debian 13 `trixie`, one tag per release line at its newest patch. The entrypoint is a **drop-in for
`bitnami/openldap`**: the same `LDAP_*` variables, the same mounts (`/bitnami/openldap`, `/ldifs`, `/schemas`,
`/docker-entrypoint-initdb.d`), the same ports (`1389` / `1636`) and the same uid (`1001`) - switch the `image:`
line of an existing bitnami compose service and keep its environment and volume.

## What's inside

| Line | Status upstream | Notes |
| ---- | --------------- | ----- |
| `2.7` | feature release | |
| `2.6` | **LTS** - tags `2`, `latest` | |
| `2.5` | previous LTS | |
| `2.4` | legacy | `back-bdb` / `back-hdb` (Berkeley DB 5.3) for reading and migrating old databases; no argon2 |

* `slapd` and the `slap*` tools, the `ldap*` clients in `/usr/local/share/epicmorg/openldap/<major.minor>`, on
  `PATH`; `mdb` and `monitor` built in, every overlay, `back-ldap` / `meta` / `null` / `relay` / `dnssrv`, `argon2`
  and the contrib password modules `pw-sha2` / `pw-pbkdf2` as modules;
* TLS on the baked OpenSSL `3.5` (LTS); SASL on a Cyrus SASL `2.1.28` built against the same OpenSSL (Debian's
  `libsasl2` and its plugins link the system `libcrypto`) with GSSAPI from Debian's MIT Kerberos - real `RPATH`,
  nothing in `ld.so.conf`, exactly one OpenSSL in the process;
* `/emg-export` - openldap + OpenSSL + Cyrus SASL as a self-contained tree for `COPY --from`;
* entrypoint under `tini`; `slapd` runs as `slapd` (uid `1001`, group `root`) when the container starts as root;
  `ldapi:///` (SASL `EXTERNAL`) works for `root` and `slapd` in `docker exec`;
* volume `/data` (native: `data/` + `slapd.d/`) - `/bitnami/openldap` is used instead when it is mounted;
  `/opt/bitnami/openldap/{libexec,lib/openldap,etc,var/run}` point at this image, so a `cn=config` written by
  bitnami (module path, pid file) starts unchanged; `HEALTHCHECK` = a rootDSE search.

Fatal build-time checks: exact version of `slapd` and the clients, no unresolved libraries, no `RUNPATH`, every
`libssl` / `libcrypto` / `libsasl2` is the baked one, the overlays / backends / password modules / SASL plugins are
there, PBKDF2 hashing works, and an entrypoint smoke test: first start, admin bind, default tree, user bind with its
PBKDF2 password, `ldaps`, anonymous bind refused, ppolicy, restart on the persisted volume, refusal to start
without `LDAP_ADMIN_PASSWORD`.

## Variables

As in `bitnami/openldap`; they are read on the first start (empty data directory) - later starts use the
persisted `cn=config`.

| Variable | Default | Meaning |
| -------- | ------- | ------- |
| `LDAP_ROOT` | `dc=example,dc=org` | suffix of the database (`LDAP_SUFFIX` overrides the suffix alone) |
| `LDAP_ADMIN_USERNAME` | `admin` | root DN `cn=<name>,<root>` |
| `LDAP_ADMIN_PASSWORD` (`_FILE`) | _(required)_ | root DN password (stored as `{PBKDF2-SHA512}`) |
| `LDAP_CONFIG_ADMIN_ENABLED` / `_USERNAME` / `_PASSWORD` (`_FILE`) | `no` / `admin` | a root DN for `cn=config` |
| `LDAP_USERS` / `LDAP_PASSWORDS` | `user01,user02` / `bitnami1,bitnami2` | default tree users |
| `LDAP_USER_OU` / `LDAP_GROUP_OU` / `LDAP_GROUP` | `users` / `groups` / `readers` | default tree |
| `LDAP_SKIP_DEFAULT_TREE` | `no` | `yes` = no default tree |
| `LDAP_ADD_SCHEMAS` / `LDAP_EXTRA_SCHEMAS` | `yes` / `cosine,inetorgperson,nis` | schemas from `etc/openldap/schema` |
| `LDAP_CUSTOM_LDIF_DIR` | `/ldifs` | `*.ldif` loaded instead of the default tree |
| `LDAP_CUSTOM_SCHEMA_FILE` / `LDAP_CUSTOM_SCHEMA_DIR` | `/schema/custom.ldif` / `/schemas` | extra schemas |
| `LDAP_PORT_NUMBER` / `LDAP_LDAPS_PORT_NUMBER` | `1389` / `1636` | listeners |
| `LDAP_ENABLE_TLS` / `LDAP_REQUIRE_TLS` | `no` / `no` | `ldaps://` + StartTLS; `olcSecurity: tls=1` |
| `LDAP_TLS_CERT_FILE` / `_KEY_FILE` / `_CA_FILE` / `_DH_PARAMS_FILE` | | TLS files |
| `LDAP_TLS_VERIFY_CLIENTS` | `never` | `olcTLSVerifyClient` |
| `LDAP_ENABLE_PROXYPROTO` / `LDAP_PROXYPROTO_PORT_NUMBER` / `_LDAPS_PORT_NUMBER` | `no` | PROXY protocol listeners (`pldap://`, `pldaps://`) |
| `LDAP_ALLOW_ANON_BINDING` | `no` | `yes` = keep anonymous bind |
| `LDAP_PASSWORD_HASH` | `{SSHA}` | `olcPasswordHash` |
| `LDAP_CONFIGURE_PPOLICY` / `LDAP_PPOLICY_USE_LOCKOUT` / `LDAP_PPOLICY_HASH_CLEARTEXT` | `no` | ppolicy overlay |
| `LDAP_ENABLE_ACCESSLOG` + `LDAP_ACCESSLOG_*` | `no` | accesslog database + overlay |
| `LDAP_ENABLE_SYNCPROV` / `LDAP_SYNCPROV_CHECKPPOINT` / `_SESSIONLOG` | `no` / `100 10` / `100` | syncprov overlay (replication provider) |
| `LDAP_LOGLEVEL` | `256` | `slapd -d` |
| `LDAP_ULIMIT_NOFILES` | `1024` | `ulimit -n` |

`/docker-entrypoint-initdb.d/*.sh` run once per volume, with `slapd` up on `ldapi:///`. Arguments starting with `-`
go to `slapd`; any other command (`ldapsearch`, `slapcat`, `bash`) runs as is.

## Tags

<!-- readme-sync:tags:begin -->
| Tags | Dockerfile |
| ---- | ---------- |
| `2.4`, `2.4.59` | [`2.4`](2.4/Dockerfile) |
| `2.5`, `2.5.20` | [`2.5`](2.5/Dockerfile) |
| `2.6`, `2.6.15`, `2`, `latest` | [`2.6`](2.6/Dockerfile) |
| `2.7`, `2.7.1` | [`2.7`](2.7/Dockerfile) |

Every tag is pushed to `docker.io`, `quay.io` and `ghcr.io` (`epicmorg/openldap:<tag>` on each) - same digest everywhere.
<!-- readme-sync:tags:end -->

## Usage

```yaml
services:
  openldap:
    image: epicmorg/openldap:2.6          # was: bitnami/openldap:2.6 - environment and volume unchanged
    restart: always
    ports:
      - "389:1389"
      - "636:1636"
    environment:
      LDAP_ROOT: dc=example,dc=org
      LDAP_ADMIN_PASSWORD_FILE: /run/secrets/ldap-admin
      LDAP_SKIP_DEFAULT_TREE: "yes"
    volumes:
      - ./openldap:/bitnami/openldap
      - ./ldifs:/ldifs:ro
    secrets: [ldap-admin]
secrets:
  ldap-admin:
    file: ./ldap-admin.txt
```

```sh
docker exec openldap ldapsearch -Q -Y EXTERNAL -H ldapi:/// -b cn=config dn    # cn=config as root, no password
```

On a volume initialised by `bitnami/openldap` itself, `cn=config` grants `ldapi` access to uid `1001` only (bitnami's
ACL, kept as is): use `docker exec -u 1001 ...` there.

## Notes

* A data directory moves between lines with `slapcat` / `slapadd`, not by mounting it into a newer `slapd`
  (2.4 `bdb` / `hdb` databases do not open in 2.5+ at all).
* 2.4 is end-of-life upstream; it is here for data that has to be read or migrated.
* Licences: OpenLDAP is under the OpenLDAP Public License, Cyrus SASL under a BSD-style licence; the image recipe is
  MIT.

Folders are written by `bin/python/openldap-versions-sync.py`.

## Links

* Source: [EpicMorg/docker](https://github.com/EpicMorg/docker) - issues and PRs welcome
* Tags float and are rebuilt weekly; pin by digest for reproducible builds: [Tags, pinning and updates](https://github.com/EpicMorg/docker#tags-pinning-and-updates)
* [CHANGELOG](https://github.com/EpicMorg/docker/blob/master/CHANGELOG.md) - License: MIT
