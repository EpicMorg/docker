# `bin/python` — repository tools

Small, dependency-free Python 3 scripts (standard library only) that keep the tree consistent and
build it. Every script has a full description in its docstring: `bin/python/<script>.py --help`
(or read the top of the file). Run them from anywhere — they locate the repository root themselves.

| Script | What it does | Typical run |
| ------ | ------------ | ----------- |
| [`cascade.py`](cascade.py) | Builds and publishes every image under the given folders (`make build && make deploy` per leaf), in version order; lanes in parallel via marker files; status file + per-leaf logs; retry of failures; disk cleanup | `bin/python/cascade.py linux/ecosystem/apps/git --order desc` |
| [`readme-sync.py`](readme-sync.py) | One root README per registry repository: regenerates the tag tables between `readme-sync:tags` markers, writes the short generated READMEs of version folders, prints the repo → README map used for registry descriptions | `bin/python/readme-sync.py` · `--check` · `--map` |
| [`git-versions-sync.py`](git-versions-sync.py) | `linux/ecosystem/apps/git/<major.minor>`: one folder per git branch at its newest patch (kernel.org `sha256sums.asc`); new folders copy the reference leaf; moves the floating `latest` tag | `bin/python/git-versions-sync.py` · `--refresh` · `--dry-run` |
| [`git-lfs-versions-sync.py`](git-lfs-versions-sync.py) | Same for `linux/ecosystem/apps/git-lfs/<major.minor>` from GitHub releases (asset digest / `sha256sums.asc`) | `GITHUB_TOKEN=$(gh auth token) bin/python/git-lfs-versions-sync.py` |
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
