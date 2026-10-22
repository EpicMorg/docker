# `bin/python` — repository tools

Small, dependency-free Python 3 scripts (standard library only) that keep the tree consistent and
build it. Every script has a full description in its docstring: `bin/python/<script>.py --help`
(or read the top of the file). Run them from anywhere — they locate the repository root themselves.

| Script | What it does | Typical run |
| ------ | ------------ | ----------- |
| [`cascade.py`](cascade.py) | Builds and publishes every image under the given folders (`make build && make deploy` per leaf), in version order; lanes in parallel via marker files; status file + per-leaf logs; retry of failures; disk cleanup | `bin/python/cascade.py linux/ecosystem/apps/git --order desc` |
| [`readme-sync.py`](readme-sync.py) | One root README per registry repository: regenerates the tag tables between `readme-sync:tags` markers, writes the short generated READMEs of version folders, prints the repo → README map used for registry descriptions | `bin/python/readme-sync.py [FOLDER]` · `--check` · `--map` |
| [`git-versions-sync.py`](git-versions-sync.py) | `linux/ecosystem/apps/git/<major.minor>`: one folder per git branch at its newest patch (kernel.org `sha256sums.asc`); new folders copy the reference leaf; moves the floating `latest` tag | `bin/python/git-versions-sync.py` · `--refresh` · `--dry-run` |
| [`git-lfs-versions-sync.py`](git-lfs-versions-sync.py) | Same for `linux/ecosystem/apps/git-lfs/<major.minor>` from GitHub releases (asset digest / `sha256sums.asc`) | `GITHUB_TOKEN=$(gh auth token) bin/python/git-lfs-versions-sync.py` |
| [`mongo-versions-sync.py`](mongo-versions-sync.py) | `linux/ecosystem/apps/mongo/<major.minor>`: every Dockerfile from templates per TLS flavour (legacy / OpenSSL 1.0.2g-ubuntu / 1.1.1 / 3), newest patch per line from `downloads.mongodb.org/full.json` (sha256 from it, the `.sha256` sidecar or md5-checked download); copies the shared entrypoint; moves `<major>` / `latest` | `bin/python/mongo-versions-sync.py` · `--only 8.2` · `--dry-run` |
| [`redis-versions-sync.py`](redis-versions-sync.py) | `linux/ecosystem/apps/redis/<major.minor>`: one folder per maintained Redis line (a release in the last 400 days) at its newest patch (GitHub releases + `redis-hashes` sha256); new folders copy the reference `8.10`; moves `<major>` / `latest` | `GITHUB_TOKEN=$(gh auth token) bin/python/redis-versions-sync.py` · `--refresh` · `--dry-run` |
| [`php-env-mirror-sync.py`](php-env-mirror-sync.py) | the mirrored php ENV blocks of `teamcity/agent/php*`, `github/runner/php*`, `gitlab/runner/php*` (asserted against the php image's env at build time): every `PHP_*` / `PEAR_*` / `PECL_*` / `P4PHP_*` / `PIE_*` / `COMPOSER_*` ENV of `apps/php/<ver>`'s final stage, resolved, updated or added - run after every php bump | `bin/python/php-env-mirror-sync.py` · `--dry-run` |
| [`openldap-versions-sync.py`](openldap-versions-sync.py) | `linux/ecosystem/apps/openldap/<major.minor>`: one folder per line `2.4`-`2.7` at its newest patch (openldap.org release dir; tarball checked against its sha3-512 / sha1 file, pinned as sha256); new folders copy the reference `2.6`; `2` / `latest` = the LTS line | `bin/python/openldap-versions-sync.py` · `--refresh` · `--dry-run` |
| [`erlang-versions-sync.py`](erlang-versions-sync.py) | `linux/ecosystem/apps/erlang/<otp major>`: one folder per OTP major `24`-`29` at its newest patch (erlang/otp releases, `SHA256.txt`); OpenSSL branch per major (24: 1.1.1, else 3.5); new folders copy the reference `27`; `latest` = newest major | `GITHUB_TOKEN=$(gh auth token) bin/python/erlang-versions-sync.py` · `--refresh` · `--dry-run` |
| [`rabbitmq-versions-sync.py`](rabbitmq-versions-sync.py) | `linux/ecosystem/apps/rabbitmq/<major.minor>`: one folder per line `3.9`-`4.4` at its newest patch (rabbitmq-server releases; generic-unix tarball GPG-verified with the release key, pinned sha256); OTP major per line (table in the script) in the erlang `FROM`; `-management` aliases, `<major>` / `latest` | `GITHUB_TOKEN=$(gh auth token) bin/python/rabbitmq-versions-sync.py` · `--refresh` · `--dry-run` (needs `gpg`) |
| [`mysql-versions-sync.py`](mysql-versions-sync.py) | `linux/ecosystem/apps/mysql/<line>`: 5.6 / 5.7 (final), 8.0, 8.4, 9.7 and the current Innovation line at their newest patch (dev.mysql.com downloads pages); Oracle generic tarballs GPG-verified with the MySQL Release Engineering keys, pinned sha256; new folders copy the reference `8.4`; reports an outdated Innovation folder | `bin/python/mysql-versions-sync.py` · `--refresh` · `--dry-run` (needs `gpg`) |
| [`mariadb-versions-sync.py`](mariadb-versions-sync.py) | `linux/ecosystem/apps/mariadb/<line>`: 5.5, 10.0-10.6, 10.11, 11.4, 11.8, 12.3, 13.0 at their newest patch (archive.mariadb.org; glibc_214 bintar up to 10.4, systemd from 10.5), GPG-verified with the MariaDB signing keys, pinned sha256; new folders copy the reference `11.8` | `bin/python/mariadb-versions-sync.py` · `--refresh` · `--dry-run` (needs `gpg`) |
| [`freeradius-versions-sync.py`](freeradius-versions-sync.py) | `linux/ecosystem/apps/freeradius/<major.minor>`: 3.0 and 3.2 at their newest patch (release tags of FreeRADIUS/freeradius-server; freeradius.org tarballs GPG-verified with the package signing key, pinned sha256); new folders copy the reference `3.2`; `3` / `latest` = newest line | `GITHUB_TOKEN=$(gh auth token) bin/python/freeradius-versions-sync.py` · `--refresh` · `--dry-run` (needs `gpg`) |
| [`ansible-versions-sync.py`](ansible-versions-sync.py) | `linux/ecosystem/apps/ansible/<major.minor>` + `teamcity/agent/ansible/<major.minor>`: newest `ansible-core` patch per line from PyPI; new lines copy the newest folder; moves `latest` / `ansible` | `bin/python/ansible-versions-sync.py` · `--add 2.18` · `--dry-run` |
| [`teamcity-server-sync.py`](teamcity-server-sync.py) | `linux/ecosystem/apps/teamcity/server/<release>`: writes every folder's Dockerfile (our `epicmorg/jdk:<N>` + `COPY --from jetbrains/teamcity-server:<release>`) and compose; JDK major per release line from a table | `bin/python/teamcity-server-sync.py` · `--add 2026.3 [--jdk 21]` |
| [`atlassian-versions-update.py`](atlassian-versions-update.py) | Refreshes the Atlassian version lists in `bin/ansible` from the vendor feeds (via `atlassian-downloader`) | `bin/python/atlassian-versions-update.py --dry-run` |
| [`atlassian-makefile-sync.py`](atlassian-makefile-sync.py) | Regenerates the Atlassian targets of the root `Makefile` from the tree | `bin/python/atlassian-makefile-sync.py` · `--check` |

CI helpers that only workflows use live in [`.github/scripts`](../../.github/scripts)
(`leaves.py` — matrix discovery, `registry-descriptions.py` — Docker Hub / Quay descriptions).

## Common workflows

**Add a new version of an image** — create the folder (Dockerfile, `docker-compose.yml`, `Makefile`), then
regenerate the READMEs and check them:

```sh
bin/python/readme-sync.py && bin/python/readme-sync.py --check
```

The `docs.registry-descriptions.yml` workflow runs `--check` on pull requests and publishes the root READMEs to
Docker Hub / Quay after a push to `master`.

**New git / git-lfs releases**

```sh
bin/python/git-versions-sync.py                                    # new branches + patch bumps
GITHUB_TOKEN=$(gh auth token) bin/python/git-lfs-versions-sync.py
bin/python/readme-sync.py
```

A change to the build recipe goes into the reference leaf (`git/2.56`, `git-lfs/3.8`) and is copied to every
folder with `--refresh`.

**New Atlassian releases**

```sh
bin/python/atlassian-versions-update.py      # update the version lists
make ansible.gen.all                         # regenerate the image folders (bin/ansible)
bin/python/atlassian-makefile-sync.py        # regenerate the Makefile targets
```

**Build a cascade locally** — a leaf is built from the files in the working tree, so run long cascades from
a separate worktree if you keep editing:

```sh
git worktree add --detach /tmp/cascade-wt develop && cd /tmp/cascade-wt
mkdir -p /tmp/c
# lane A: base, then compilers (stops on the first failure, marks gcc as done)
bin/python/cascade.py linux/ecosystem/base/debian/13-trixie/main \
    linux/ecosystem/base/debian/13-trixie/develop-light linux/ecosystem/base/debian/13-trixie/develop \
    linux/ecosystem/apps/gcc --stop-on-fail --done-file /tmp/c/gcc.done \
    --status /tmp/c/a.txt --logs /tmp/c/logs-a &
# lane B: runtimes, after lane A has finished gcc
bin/python/cascade.py linux/ecosystem/apps/python linux/ecosystem/apps/java/jdk linux/ecosystem/apps/nodejs \
    --wait-for /tmp/c/gcc.done --status /tmp/c/b.txt --logs /tmp/c/logs-b &
# afterwards: rebuild only what failed
bin/python/cascade.py --retry /tmp/c/b.txt --status /tmp/c/b-retry.txt
```

Build order matters: base → `gcc` → runtimes (`php`, `python`, `jdk`, `git`, ...) → applications. The
weekly CI chain (`chain.10-base` → `chain.20-gcc` → `chain.30-runtimes` → `chain.40-apps`) follows the same order.
