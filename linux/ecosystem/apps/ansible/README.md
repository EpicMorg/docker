<!-- hub-description: ansible-core (newest patch of each line) + ansible-lint + collections in a venv, for COPY --from -->
# `epicmorg/ansible`

One image per ansible-core line (`2.16`, `2.17`, `2.21`), each at the newest patch release of that line
(folder = `major.minor`, image = `major.minor.patch`, also tagged), on
[`epicmorg/debian:trixie`](https://github.com/EpicMorg/docker/tree/master/linux/ecosystem/base/debian).
The point of the image is to be a **source for `COPY --from`**: the runtime is a self-contained tree in
`/usr/local/share/epicmorg/ansible/<major.minor>` (it is used that way by `epicmorg/teamcity-agent:ansible-<ver>`).

## What's inside

* venv `/usr/local/share/epicmorg/ansible/<major.minor>/venv` (Debian's `python3` 3.13) with `ansible-core`, `ansible-lint`,
  `yamllint`, `netaddr`, `jmespath`, `hvac`, `pyvmomi`, `pywinrm` + `pyspnego` (`requirements.txt` in the version folder);
* collections in `/usr/local/share/epicmorg/ansible/<major.minor>/collections` (`ANSIBLE_COLLECTIONS_PATH`, `collections.yml`):
  `ansible.posix`, `ansible.windows`, `community.windows`, `community.general`, `community.crypto`, `community.docker`,
  `community.hashi_vault`, `community.vmware`, `vmware.vmware`, `chocolatey.chocolatey`;
* `ansible*` and `yamllint` symlinked into `/usr/local/bin`; `sshpass`, `openssh-client`, `rsync` from Debian.

Fatal build-time checks: `ansible` on `PATH` is the venv one, exact `ansible [core <version>]`, `ansible-lint --version`,
collection list, `ansible localhost -m ping`.

Environment: `EMG_ANSIBLE_VERSION` (line), `EMG_ANSIBLE_CORE_VERSION`, `EMG_ANSIBLE_DIR`, `ANSIBLE_COLLECTIONS_PATH`.

## Tags

<!-- readme-sync:tags:begin -->
| Tags | Dockerfile |
| ---- | ---------- |
| `2.16`, `2.16.19` | [`2.16`](2.16/Dockerfile) |
| `2.17`, `2.17.14` | [`2.17`](2.17/Dockerfile) |
| `2.21`, `2.21.5`, `latest` | [`2.21`](2.21/Dockerfile) |

Every tag is pushed to `docker.io`, `quay.io` and `ghcr.io` (`epicmorg/ansible:<tag>` on each) - same digest everywhere.
<!-- readme-sync:tags:end -->

## Usage

```dockerfile
FROM ghcr.io/epicmorg/ansible:2.21 AS ansible
FROM ghcr.io/epicmorg/debian:trixie
ENV EMG_ANSIBLE_DIR=/usr/local/share/epicmorg/ansible/2.21
ENV ANSIBLE_COLLECTIONS_PATH=${EMG_ANSIBLE_DIR}/collections PATH=${EMG_ANSIBLE_DIR}/venv/bin:${PATH}
COPY --from=ansible ${EMG_ANSIBLE_DIR}/ ${EMG_ANSIBLE_DIR}/
RUN apt-get update && apt-get install -y --no-install-recommends python3 sshpass openssh-client rsync
```

The venv points at `/usr/bin/python3`, so the consumer must be Debian 13 (`trixie`) as well.

```bash
docker run --rm ghcr.io/epicmorg/ansible:2.21 ansible --version
```

## Links

* Source: [EpicMorg/docker](https://github.com/EpicMorg/docker) - issues and PRs welcome
* Tags float and are rebuilt weekly; pin by digest for reproducible builds: [Tags, pinning and updates](https://github.com/EpicMorg/docker#tags-pinning-and-updates)
* [CHANGELOG](https://github.com/EpicMorg/docker/blob/master/CHANGELOG.md) - License: MIT
