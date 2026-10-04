<!-- hub-description: Monero node (monerod) and p2pool mining node on Debian trixie -->
# `epicmorg/monero`

Monero daemon and [p2pool](https://github.com/SChernykh/p2pool) on `epicmorg/debian:trixie`, from the
official release binaries. Derived from sethforprivacy's
[simple-monerod](https://github.com/sethforprivacy/simple-monerod-docker) and
[p2pool-docker](https://github.com/sethsimmons/p2pool-docker).

## What's inside

| Tag | Content |
| --- | --- |
| `latest` | `monerod` and the other Monero CLI tools (release tarball, version in `MONERO_VERSION`) in `/monero/bin` (on `PATH`); entrypoint runs `monerod --non-interactive` (under `numactl --interleave=all` when available); healthcheck on `http://localhost:18081/get_info` |
| `p2pool` | `p2pool` release binary (version in `P2POOL_VERSION`) in `/bin`; entrypoint `p2pool` |

Ports: `monerod` exposes `18080` (p2p) and `18089` (restricted RPC); `p2pool` exposes `3333`
(stratum), `37888` and `37889` (p2p).

## Tags

<!-- readme-sync:tags:begin -->
| Tags | Dockerfile |
| ---- | ---------- |
| `latest` | [`monerod`](monerod/Dockerfile) |
| `p2pool` | [`p2pool`](p2pool/Dockerfile) |

Every tag is pushed to `docker.io`, `quay.io` and `ghcr.io` (`epicmorg/monero:<tag>` on each) - same digest everywhere.
<!-- readme-sync:tags:end -->

## Usage

### monerod

The default command starts a node with a restricted RPC on `0.0.0.0:18089`
(`--rpc-restricted-bind-ip=0.0.0.0 --rpc-restricted-bind-port=18089 --no-igd --no-zmq --enable-dns-blocklist`).
Arguments passed to the container replace that default command and go straight to `monerod`.
The image declares `/monero/data` as a volume; point the blockchain there explicitly:

```sh
docker run -d --restart unless-stopped --name monerod \
  -p 18080:18080 -p 18089:18089 \
  -v monero-data:/monero/data \
  epicmorg/monero:latest \
  --data-dir=/monero/data \
  --rpc-restricted-bind-ip=0.0.0.0 --rpc-restricted-bind-port=18089 \
  --no-igd --no-zmq --enable-dns-blocklist
```

Add `--public-node` to advertise the restricted RPC, `--prune-blockchain` for a pruned node.

### p2pool

Always pass your own arguments — at least the node to use and your wallet:

```sh
docker run -d --restart unless-stopped --name p2pool \
  -p 3333:3333 -p 37889:37889 \
  epicmorg/monero:p2pool \
  --host <monerod-host> --rpc-port 18089 \
  --wallet <your-monero-address> \
  --stratum 0.0.0.0:3333 --p2p 0.0.0.0:37889
```

p2pool needs a monerod with ZMQ enabled (do not use `--no-zmq` on that node); see the
[p2pool documentation](https://github.com/SChernykh/p2pool#readme).

Example compose files: [`monerod/examples`](https://github.com/EpicMorg/docker/tree/master/linux/ecosystem/apps/monero/monerod/examples),
[`p2pool/examples`](https://github.com/EpicMorg/docker/tree/master/linux/ecosystem/apps/monero/p2pool/examples).

## Links

* Source: [EpicMorg/docker](https://github.com/EpicMorg/docker) - issues and PRs welcome
* Tags float and are rebuilt weekly; pin by digest for reproducible builds: [Tags, pinning and updates](https://github.com/EpicMorg/docker#tags-pinning-and-updates)
* [CHANGELOG](https://github.com/EpicMorg/docker/blob/master/CHANGELOG.md) - License: MIT
