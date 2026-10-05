<!-- hub-description: Perforce Helix server (p4d), graceful 'p4 admin stop' on docker stop, r16.2-r24.2 -->
# `epicmorg/p4d`

The Perforce Helix server (`p4d`) as a container: built `FROM`
[`epicmorg/perforce:<release>`](https://github.com/EpicMorg/docker/tree/master/linux/ecosystem/apps/perforce/base)
on Debian 13 `trixie`, one tag per Helix release. The entrypoint stops the server the way Perforce
recommends: on `docker stop` it runs `p4 admin stop` as a super user, so the journal and `db.*` files
are closed cleanly instead of the process being killed.

## What's inside

* everything from `epicmorg/perforce:<release>` (`p4d`, `p4`, `p4broker`, `p4dctl`, ... of that release);
* entrypoint (under `tini`) that runs `p4d -r ${P4ROOT} -p ${P4PORT} -J ${P4JOURNAL} [-L ${P4LOG}] [-A ${P4AUDITLOG}]
  [-In ${P4NAME}] [-Id ${P4DESCRIPTION}] [-C1] ${P4ARGS} <docker run args>`;
* graceful stop on `SIGTERM` / `SIGINT`: optional `p4 login` (password from `P4ADMIN_PASSWD` or
  `P4ADMIN_PASSWD_FILE`), `p4 admin stop`, wait up to `P4STOP_TIMEOUT` seconds; if the stop is refused or
  times out, `p4d` gets a `SIGTERM` (the old behaviour);
* volumes `/perforce/root`, `/perforce/logs`; port `1666`.

| Variable | Default | Meaning |
| -------- | ------- | ------- |
| `P4PORT` | `1666` | listen port / address (`ssl:1666` for SSL - the stop then runs `p4 trust -y` first) |
| `P4ROOT` | `/perforce/root` | server root (`db.*`, depots, journal) |
| `P4JOURNAL` | `journal` | journal file, relative to `P4ROOT` |
| `P4LOG` | `/perforce/logs/p4d.log` | error log; empty = stderr |
| `P4AUDITLOG` | _(off)_ | audit log |
| `P4NAME` / `P4DESCRIPTION` | _(none)_ | server name (`-In`) / description (`-Id`) |
| `P4CASE` | _(none)_ | `1` = case-insensitive server (`-C1`) |
| `P4ARGS` | _(none)_ | any further `p4d` flags (word-split) |
| `P4ADMIN_USER` | _(none)_ | super user for `p4 admin stop` |
| `P4ADMIN_PASSWD` / `P4ADMIN_PASSWD_FILE` | _(none)_ | its password; the file (Docker secret) wins |
| `P4STOP_TIMEOUT` | `120` | seconds to wait for `p4d` after `admin stop` |

Without `P4ADMIN_USER` / password the stop still works on a server without protections, or when a valid
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

Every tag is pushed to `docker.io`, `quay.io` and `ghcr.io` (`epicmorg/p4d:<tag>` on each) - same digest everywhere.
<!-- readme-sync:tags:end -->

## Usage

```yaml
services:
  p4d:
    image: epicmorg/p4d:r24.2
    restart: unless-stopped
    stop_grace_period: 3m          # longer than P4STOP_TIMEOUT, or docker kills p4d after 10 s
    ports:
      - "1666:1666"
    environment:
      P4NAME: master
      P4ADMIN_USER: admin
      P4ADMIN_PASSWD_FILE: /run/secrets/p4admin
    volumes:
      - ./root:/perforce/root
      - ./logs:/perforce/logs
    secrets:
      - p4admin
secrets:
  p4admin:
    file: ./p4admin.txt
```

`docker run` equivalent: `docker run -d --stop-timeout 180 -p 1666:1666 -v p4root:/perforce/root -v p4logs:/perforce/logs -e P4ADMIN_USER=admin -e P4ADMIN_PASSWD=... epicmorg/p4d:r24.2`.

## Notes

* The default Docker stop timeout is 10 s - always raise it (`stop_grace_period` / `--stop-timeout`) for a
  real server, `p4 admin stop` on a busy server can take longer.
* `p4 admin stop` needs a super user; with security level >= 3 that means a password (or a ticket).
* Checkpoints / backups are not handled by the image - run `p4d -jc` (or `p4 admin checkpoint`) from your
  own schedule, e.g. `docker exec <container> p4 -p localhost:1666 -u admin admin checkpoint`.

## Links

* Source: [EpicMorg/docker](https://github.com/EpicMorg/docker) - issues and PRs welcome
* Tags float and are rebuilt weekly; pin by digest for reproducible builds: [Tags, pinning and updates](https://github.com/EpicMorg/docker#tags-pinning-and-updates)
* [CHANGELOG](https://github.com/EpicMorg/docker/blob/master/CHANGELOG.md) - License: MIT
