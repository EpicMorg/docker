<!-- hub-description: Supermicro Management Plugin for VMware vCenter 3.0.0 on JDK 8 -->
# `epicmorg/supermicro-management-plugin`

The Supermicro Management Plugin for VMware vCenter (`3.0.0` build `241210`), packaged as a container
on `epicmorg/jdk:8`. The vendor zip is downloaded from supermicro.com at build time.

## What's inside

* the plugin unpacked to `/usr/local/share/epicmorg/supermicro` (also linked as `/supermicro`)
* `entrypoint.sh` under `tini`: `java -jar app/app.jar` with the security settings below
* HTTPS on port `8443`
* volume: `/usr/local/share/epicmorg/supermicro/config`

## Tags

<!-- readme-sync:tags:begin -->
| Tags | Dockerfile |
| ---- | ---------- |
| `3.0.0.0-0-vcenter` | [`.`](./Dockerfile) |

Every tag is pushed to `docker.io`, `quay.io` and `ghcr.io` (`epicmorg/supermicro-management-plugin:<tag>` on each) - same digest everywhere.
<!-- readme-sync:tags:end -->

## Usage

```sh
docker run -d --name smp \
  -p 8443:8443 \
  -v smp-config:/usr/local/share/epicmorg/supermicro/config \
  -e SMP_USERNAME=admin \
  -e SMP_PASSWORD='<bcrypt hash>' \
  -e SMP_AES_KEY='<random key>' \
  epicmorg/supermicro-management-plugin:3.0.0.0-0-vcenter
```

Then register the plugin in vCenter at `https://<host>:8443` as described in the vendor manual.

| Variable | Default | Passed as |
| --- | --- | --- |
| `SMP_USERNAME` | `admin` | `--app.security.username` |
| `SMP_PASSWORD` | bcrypt hash of `password` | `--app.security.password` (a bcrypt hash, not plain text) |
| `SMP_AES_KEY` | `key` | `--app.security.key` |

## Notes

* **Change all three defaults.** The defaults are public; never run them on a reachable network.
* The plugin is proprietary Supermicro software, distributed under Supermicro's terms; only the build
  files here are MIT.

## Links

* Source: [EpicMorg/docker](https://github.com/EpicMorg/docker) - issues and PRs welcome
* Tags float and are rebuilt weekly; pin by digest for reproducible builds: [Tags, pinning and updates](https://github.com/EpicMorg/docker#tags-pinning-and-updates)
* [CHANGELOG](https://github.com/EpicMorg/docker/blob/master/CHANGELOG.md) - License: MIT
