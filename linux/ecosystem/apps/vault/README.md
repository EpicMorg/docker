<!-- hub-description: HashiCorp Vault 1.13-2.x (release binaries), drop-in for hashicorp/vault -->
# `epicmorg/vault`

HashiCorp Vault from the release binaries (`releases.hashicorp.com`; the release's `SHA256SUMS` checked against
HashiCorp's signature, the zip pinned by sha256) on Debian 13 `trixie`, one tag per release line at its newest
Community Edition release, from `1.13` (the last MPL release) to `2.2`. A **drop-in for `hashicorp/vault`**: the same
`/vault/{config,file,logs}` layout, `VAULT_LOCAL_CONFIG`, `VAULT_DEV_ROOT_TOKEN_ID` / `VAULT_DEV_LISTEN_ADDRESS`,
`VAULT_REDIRECT_INTERFACE` / `VAULT_CLUSTER_INTERFACE`, `SKIP_SETCAP` / `SKIP_CHOWN`, the `vault` user, and
`server -dev` as the default command.

## What's inside

* `vault` in `/usr/local/share/epicmorg/vault/<major.minor>/bin` (also `/bin/vault`), on `PATH`; the release's
  licence / notice files next to it; `/emg-export` for `COPY --from`;
* entrypoint under `tini`: flags or a vault subcommand become `vault ...`; `vault server` gets
  `-config=/vault/config` (+ `local.json` from `VAULT_LOCAL_CONFIG`), the dev flags from the variables, the
  addresses from the interfaces; `/vault/*` handed to `vault`, `cap_ipc_lock` set on the binary (memory locking needs
  `--cap-add IPC_LOCK`, otherwise set `disable_mlock` or `SKIP_SETCAP`), then it runs as `vault`;
* `jq`, `ip` (iproute2), `setcap` in the image; volumes `/vault/logs`, `/vault/file`; port `8200`.

Fatal build-time checks: exact version, and a smoke test on random ports - a dev server (root token, kv put / get,
runs as `vault`) and a server with file storage from `VAULT_LOCAL_CONFIG` (`operator init`, `unseal`, kv v2).

## Tags

<!-- readme-sync:tags:begin -->
| Tags | Dockerfile |
| ---- | ---------- |
| `1.13`, `1.13.13` | [`1.13`](1.13/Dockerfile) |
| `1.14`, `1.14.10` | [`1.14`](1.14/Dockerfile) |
| `1.15`, `1.15.6` | [`1.15`](1.15/Dockerfile) |
| `1.16`, `1.16.3` | [`1.16`](1.16/Dockerfile) |
| `1.17`, `1.17.6` | [`1.17`](1.17/Dockerfile) |
| `1.18`, `1.18.5` | [`1.18`](1.18/Dockerfile) |
| `1.19`, `1.19.5` | [`1.19`](1.19/Dockerfile) |
| `1.20`, `1.20.4` | [`1.20`](1.20/Dockerfile) |
| `1.21`, `1.21.4`, `1` | [`1.21`](1.21/Dockerfile) |
| `2.0`, `2.0.4` | [`2.0`](2.0/Dockerfile) |
| `2.1`, `2.1.2` | [`2.1`](2.1/Dockerfile) |
| `2.2`, `2.2.0`, `2`, `latest` | [`2.2`](2.2/Dockerfile) |

Every tag is pushed to `docker.io`, `quay.io` and `ghcr.io` (`epicmorg/vault:<tag>` on each) - same digest everywhere.
<!-- readme-sync:tags:end -->

## Usage

```yaml
services:
  vault:
    image: epicmorg/vault:2.2          # was: hashicorp/vault:2.2
    restart: always
    cap_add: [IPC_LOCK]
    command: ["server"]
    ports:
      - "8200:8200"
    environment:
      VAULT_LOCAL_CONFIG: >-
        {"storage": {"file": {"path": "/vault/file"}},
         "listener": [{"tcp": {"address": "0.0.0.0:8200", "tls_disable": true}}],
         "api_addr": "http://vault.example.org:8200", "ui": true}
    volumes:
      - ./vault-file:/vault/file
      - ./vault-logs:/vault/logs
```

## Notes

* Licences: Vault up to 1.13 is MPL 2.0, 1.14 and later the Business Source License (BUSL 1.1) - the binaries are
  HashiCorp's, unchanged; the image recipe is MIT.
* Enterprise builds (`+ent`) are not packaged.

Folders are written by `bin/python/vault-versions-sync.py`.

## Links

* Source: [EpicMorg/docker](https://github.com/EpicMorg/docker) - issues and PRs welcome
* Tags float and are rebuilt weekly; pin by digest for reproducible builds: [Tags, pinning and updates](https://github.com/EpicMorg/docker#tags-pinning-and-updates)
* [CHANGELOG](https://github.com/EpicMorg/docker/blob/master/CHANGELOG.md) - License: MIT
