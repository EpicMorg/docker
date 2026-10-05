<!-- hub-description: Perforce Helix server (p4d) r16.2-r26.1: graceful stop, checkpoint + db upgrade helpers -->
# `epicmorg/p4d`

The Perforce Helix server (`p4d`) as a container: built `FROM`
[`epicmorg/perforce:<release>`](https://github.com/EpicMorg/docker/tree/master/linux/ecosystem/apps/perforce/base)
on Debian 13 `trixie`, one tag per Helix release. The entrypoint stops the server the way Perforce
recommends: on `docker stop` it runs `p4 admin stop` as a super user, so the journal and `db.*` files
are closed cleanly instead of the process being killed.

## What's inside

* everything from `epicmorg/perforce:<release>` (`p4d`, `p4`, `p4broker`, `p4dctl`, ... of that release);
* entrypoint (under `tini`) that runs `p4d -r ${P4ROOT} -J ${P4JOURNAL} [-L ${P4LOG}] [-A ${P4AUDITLOG}] [-C1]
  -p ${P4PORT} [-In ${P4NAME}] [-Id ${P4DESCRIPTION}] ${P4ARGS} <docker run args>`;
* graceful stop on `SIGTERM` / `SIGINT`: optional `p4 login` (password from `P4ADMIN_PASSWD` or
  `P4ADMIN_PASSWD_FILE`), `p4 admin stop`, wait up to `P4STOP_TIMEOUT` seconds; if the stop is refused or
  times out, `p4d` gets a `SIGTERM` (the old behaviour);
* `p4d-checkpoint` - online checkpoint for `docker exec`, `p4d-upgrade` - offline db upgrade (`p4d -xu`) for a
  one-off container, like `pg_upgrade` (see below);
* volumes `/perforce/root`, `/perforce/journals`, `/perforce/logs`, `/perforce/archives`, `/perforce/backups`;
  port `1666`.

| Variable | Default | Meaning |
| -------- | ------- | ------- |
| `P4PORT` | `1666` | listen port / address (`ssl:1666` for SSL - `p4 trust -y` is run before talking to it) |
| `P4ROOT` | `/perforce/root` | server root (`db.*`, depots unless their `Map` points elsewhere, e.g. `/perforce/archives`) |
| `P4JOURNAL` | `/perforce/journals/journal` | journal file |
| `P4LOG` | `/perforce/logs/p4d.log` | error log; empty = stderr |
| `P4AUDITLOG` | _(off)_ | audit log, e.g. `/perforce/logs/auditlog` |
| `P4NAME` / `P4DESCRIPTION` | _(none)_ | server name (`-In`) / description (`-Id`); `P4NAME` also names the backups |
| `P4CASE` | _(none)_ | `1` = case-insensitive server (`-C1`) |
| `P4CHARSET` | _(none)_ | client charset for the helpers, `utf8` for a unicode-mode server |
| `P4ARGS` | _(none)_ | any further `p4d` flags (word-split), e.g. `-z` |
| `P4ADMIN_USER` | _(none)_ | super user for `admin stop` / `admin checkpoint` |
| `P4ADMIN_PASSWD` / `P4ADMIN_PASSWD_FILE` | _(none)_ | its password; the file (Docker secret) wins |
| `P4STOP_TIMEOUT` | `120` | seconds to wait for `p4d` after `admin stop` |
| `P4BACKUPS` | `/perforce/backups` | where the helpers write checkpoints |
| `P4BACKUP_KEEP` | _(all)_ | `p4d-checkpoint` keeps only the newest N backup directories |

Without `P4ADMIN_USER` / password the helpers still work on a server without protections, or when a valid
ticket is available (`P4TICKETS`, `~/.p4tickets` in a volume).

## Tags

<!-- readme-sync:tags:begin -->
| Tags | Dockerfile |
| ---- | ---------- |
| `r16.2` | [`r16.2`](r16.2/Dockerfile) |
| `r17.1` | [`r17.1`](r17.1/Dockerfile) |
| `r17.2` | [`r17.2`](r17.2/Dockerfile) |
| `r18.1` | [`r18.1`](r18.1/Dockerfile) |
| `r18.2` | [`r18.2`](r18.2/Dockerfile) |
| `r19.1` | [`r19.1`](r19.1/Dockerfile) |
| `r19.2` | [`r19.2`](r19.2/Dockerfile) |
| `r20.1` | [`r20.1`](r20.1/Dockerfile) |
| `r20.2` | [`r20.2`](r20.2/Dockerfile) |
| `r21.1` | [`r21.1`](r21.1/Dockerfile) |
| `r21.2` | [`r21.2`](r21.2/Dockerfile) |
| `r22.1` | [`r22.1`](r22.1/Dockerfile) |
| `r23.1` | [`r23.1`](r23.1/Dockerfile) |
| `r23.2` | [`r23.2`](r23.2/Dockerfile) |
| `r24.1` | [`r24.1`](r24.1/Dockerfile) |
| `r24.2` | [`r24.2`](r24.2/Dockerfile) |
| `r25.1` | [`r25.1`](r25.1/Dockerfile) |
| `r25.2` | [`r25.2`](r25.2/Dockerfile) |
| `r26.1` | [`r26.1`](r26.1/Dockerfile) |

Every tag is pushed to `docker.io`, `quay.io` and `ghcr.io` (`epicmorg/p4d:<tag>` on each) - same digest everywhere.
<!-- readme-sync:tags:end -->

## Usage

```yaml
services:
  p4d:
    image: epicmorg/p4d:r25.1
    restart: unless-stopped
    stop_grace_period: 3m          # longer than P4STOP_TIMEOUT, or docker kills p4d after 10 s
    ports:
      - "1666:1666"
    environment:
      P4NAME: p4main
      P4DESCRIPTION: Main P4 server
      P4CASE: "1"
      P4CHARSET: utf8
      P4AUDITLOG: /perforce/logs/auditlog
      P4ADMIN_USER: root
      P4ADMIN_PASSWD_FILE: /run/secrets/p4admin
      P4BACKUP_KEEP: "14"
    volumes:
      - ./root:/perforce/root
      - ./journals:/perforce/journals
      - ./logs:/perforce/logs
      - ./archives:/perforce/archives
      - ./backups:/perforce/backups
    secrets:
      - p4admin
secrets:
  p4admin:
    file: ./p4admin.txt
```

**Checkpoint** (online, server keeps running; journal rotated as usual) - e.g. from cron on the host:

```sh
docker exec p4d p4d-checkpoint      # -> /perforce/backups/<P4NAME>-<date>/<P4NAME>.ckp.N.gz (+ .md5)
```

**Upgrade to a new release** (offline, like `pg_upgrade`): stop the server, run the new image once with the
same volumes and environment but without the entrypoint, then start the server on the new tag:

```sh
docker compose stop p4d
docker run --rm -it --entrypoint p4d-upgrade --env-file p4d.env \
  -v ./root:/perforce/root -v ./journals:/perforce/journals -v ./logs:/perforce/logs -v ./backups:/perforce/backups \
  epicmorg/p4d:r25.2            # offline checkpoint into /perforce/backups, then p4d -xu (--no-checkpoint to skip)
# set image: epicmorg/p4d:r25.2 in compose, then
docker compose up -d p4d
```

## Notes

* The default Docker stop timeout is 10 s - always raise it (`stop_grace_period` / `--stop-timeout`).
* `p4 admin stop` / `admin checkpoint` need a super user; with security level >= 3 that means a password (or a ticket).
* Restore = `p4d -r /perforce/root -jr -z <checkpoint>` in a one-off container (`--entrypoint p4d`) on an empty root.

## Links

* Source: [EpicMorg/docker](https://github.com/EpicMorg/docker) - issues and PRs welcome
* Tags float and are rebuilt weekly; pin by digest for reproducible builds: [Tags, pinning and updates](https://github.com/EpicMorg/docker#tags-pinning-and-updates)
* [CHANGELOG](https://github.com/EpicMorg/docker/blob/master/CHANGELOG.md) - License: MIT
