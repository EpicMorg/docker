#  [![Activity](https://img.shields.io/github/commit-activity/m/EpicMorg/docker?label=commits&style=flat-square)](https://github.com/EpicMorg/docker/commits) [![GitHub issues](https://img.shields.io/github/issues/EpicMorg/docker.svg?style=popout-square)](https://github.com/EpicMorg/docker/issues) [![GitHub forks](https://img.shields.io/github/forks/EpicMorg/docker.svg?style=popout-square)](https://github.com/EpicMorg/docker/network) [![GitHub stars](https://img.shields.io/github/stars/EpicMorg/docker.svg?style=popout-square)](https://github.com/EpicMorg/docker/stargazers)  [![Size](https://img.shields.io/github/repo-size/EpicMorg/docker?label=size&style=flat-square)](https://github.com/EpicMorg/docker/archive/master.zip) [![Release](https://img.shields.io/github/v/release/EpicMorg/docker?style=flat-square)](https://github.com/EpicMorg/docker/releases) [![CII Best Practices](https://bestpractices.coreinfrastructure.org/projects/3658/badge)](https://bestpractices.coreinfrastructure.org/projects/3658)  [![GitHub license](https://img.shields.io/github/license/EpicMorg/docker.svg?style=popout-square)](LICENSE.md) [![Changelog](https://img.shields.io/badge/Changelog-yellow.svg?style=popout-square)](CHANGELOG.md) [![CodeScene System Mastery](https://codescene.io/projects/6535/status-badges/system-mastery)](https://codescene.io/projects/6535)

## Description
A collection of docker images for production use. This repo contains 2 types of images - `advanced` and `ecosystem`. We support `linux x86_64` docker engine (`Win64` is still in the ***testing*** stage).

* `linux/advanced` folder contains improved images like `nextcloud` or `teamcity server`, `zabbix collection`, etc. These images just forked from original developers and patched a bit.
* `linux/ecosystem` folder contains images developed by our team like full `Atlassian Stack`, compilled `nginx`, `php`, `testrail` and othres.

![](https://raw.githubusercontent.com/EpicMorg/docker/master/.github/logo.png)


## Official Mirrors and Hubs

| Name | Homepage |
|:-------------|-------------:|
| `DockerHub` (Default) | https://hub.docker.com/r/epicmorg |
| `Quai.io` (Mirror) | https://quay.io/organization/epicmorg | 
| `Harbor` (Mirror)  | [https://hub.epicm.org/epicmorg](https://hub.epicm.org/account/sign-in?globalSearch=epicmorg) | 

## Docker and Podman support:
| Docker | Podman |
|:-------------|-------------:|
|  `docker pull epicmorg/debian:boowkorm` |  `podman pull epicmorg/debian:boowkorm` |
|  `docker pull quay.io/epicmorg/debian:boowkorm` |  `podman pull quay.io/epicmorg/debian:boowkorm` |
|  `docker pull hub.epicm.org/epicmorg/debian:boowkorm` |  `podman pull hub.epicm.org/epicmorg/ debian:boowkorm` |

## Support Document for Docker Image Concepts in Project

| `ru-RU` | `en-US` | 
|:-------------|:-------------|
| [:ru: :bookmark_tabs:](SUPPORT.ru.md) | [:us: :bookmark_tabs:](SUPPORT.md)


## Debian CI Status

| Debian | **codename** | **status** | **End of life date (with LTS, not ELTS)**
|:-------------|:-------------|:-------------|:-------------|
| [![GHA](https://img.shields.io/github/actions/workflow/status/EpicMorg/docker/base.sid.yml?label=SID&logo=Debian%20sid%20Images&style=flat-square)](https://github.com/EpicMorg/docker/actions/workflows/base.sid.yml) | `sid` | `unstable` | `none` |
| [![GHA](https://img.shields.io/github/actions/workflow/status/EpicMorg/docker/chain.10-base.yml?label=13&logo=Debian%2013%20Images&style=flat-square)](https://github.com/EpicMorg/docker/actions/workflows/chain.10-base.yml) | `trixie` | `testing` | `none yet` |
| [![GHA](https://img.shields.io/github/actions/workflow/status/EpicMorg/docker/base.museum.yml?label=12&logo=Debian%2012%20Images&style=flat-square)](https://github.com/EpicMorg/docker/actions/workflows/base.museum.yml) | **`bookworm`** | **`Stable`**  | `2028-06-30` |
| [![GHA](https://img.shields.io/github/actions/workflow/status/EpicMorg/docker/base.museum.yml?label=11&logo=Debian%2011%20Images&style=flat-square)](https://github.com/EpicMorg/docker/actions/workflows/base.museum.yml) | **`bullseye`**  | **`LTS`**, `oldstable`| `2026-08-31` |
| [![GHA](https://img.shields.io/github/actions/workflow/status/EpicMorg/docker/base.museum.yml?label=10&logo=Debian%20Legacy%20Images&style=flat-square)](https://github.com/EpicMorg/docker/actions/workflows/base.museum.yml) | `buster` | `deprecated`, `oldoldstable `| `2024-06-30` |
| [![GHA](https://img.shields.io/github/actions/workflow/status/EpicMorg/docker/base.museum.yml?label=09&logo=Debian%20Legacy%20Images&style=flat-square)](https://github.com/EpicMorg/docker/actions/workflows/base.museum.yml) | `stretch` | `deprecated` | `2022-07-01` |
| [![GHA](https://img.shields.io/github/actions/workflow/status/EpicMorg/docker/base.museum.yml?label=08&logo=Debian%20Legacy%20Images&style=flat-square)](https://github.com/EpicMorg/docker/actions/workflows/base.museum.yml) | `jessie` | `deprecated` | `2020-06-30` |
| [![GHA](https://img.shields.io/github/actions/workflow/status/EpicMorg/docker/base.museum.yml?label=07&logo=Debian%20Legacy%20Images&style=flat-square)](https://github.com/EpicMorg/docker/actions/workflows/base.museum.yml) | `wheezy` | `deprecated` | `2018-05-31` |
| [![GHA](https://img.shields.io/github/actions/workflow/status/EpicMorg/docker/base.museum.yml?label=06&logo=Debian%20Legacy%20Images&style=flat-square)](https://github.com/EpicMorg/docker/actions/workflows/base.museum.yml) | `squeeze` | `deprecated` | `2016-02-29` |

### Atlassian CI Status

| # | Bitbucket | Confluence | Jira | Crowd |Crucible + Fisheye | Bamboo | Bitbucket Mesh |
|:-------------:|:-------------:|:-------------:|:-------------:|:-------------:|:-------------:|:-------------:|:-------------:|
| `00` | :no_entry_sign: | :no_entry_sign: | :no_entry_sign: | [![GHA](https://img.shields.io/github/actions/workflow/status/EpicMorg/docker/atlassian.crowd.00.yml?label=Status&logo=01&style=flat-square)](https://github.com/EpicMorg/docker/actions/workflows/atlassian.crowd.00.yml) | :no_entry_sign: | :no_entry_sign: | :no_entry_sign: |
| `01` | [![GHA](https://img.shields.io/github/actions/workflow/status/EpicMorg/docker/atlassian.bitbucket.01.yml?label=Status&logo=01&style=flat-square)](https://github.com/EpicMorg/docker/actions/workflows/atlassian.bitbucket.01.yml) | :no_entry_sign: | :no_entry_sign: | [![GHA](https://img.shields.io/github/actions/workflow/status/EpicMorg/docker/atlassian.crowd.01.yml?label=Status&logo=01&style=flat-square)](https://github.com/EpicMorg/docker/actions/workflows/atlassian.crowd.01.yml) | [![GHA](https://img.shields.io/github/actions/workflow/status/EpicMorg/docker/atlassian.crucible.01.yml?label=Status&logo=01&style=flat-square)](https://github.com/EpicMorg/docker/actions/workflows/atlassian.crucible.01.yml) [![GHA](https://img.shields.io/github/actions/workflow/status/EpicMorg/docker/atlassian.fisheye.01.yml?label=Status&logo=01&style=flat-square)](https://github.com/EpicMorg/docker/actions/workflows/atlassian.fisheye.01.yml) | :no_entry_sign: | [![GHA](https://img.shields.io/github/actions/workflow/status/EpicMorg/docker/atlassian.mesh.01.yml?label=Status&logo=01&style=flat-square)](https://github.com/EpicMorg/docker/actions/workflows/atlassian.mesh.01.yml) |
| `02` | [![GHA](https://img.shields.io/github/actions/workflow/status/EpicMorg/docker/atlassian.bitbucket.02.yml?label=Status&logo=02&style=flat-square)](https://github.com/EpicMorg/docker/actions/workflows/atlassian.bitbucket.02.yml) | :no_entry_sign: | :no_entry_sign: | [![GHA](https://img.shields.io/github/actions/workflow/status/EpicMorg/docker/atlassian.crowd.02.yml?label=Status&logo=01&style=flat-square)](https://github.com/EpicMorg/docker/actions/workflows/atlassian.crowd.02.yml) | [![GHA](https://img.shields.io/github/actions/workflow/status/EpicMorg/docker/atlassian.fisheye.02.yml?label=Status&logo=01&style=flat-square)](https://github.com/EpicMorg/docker/actions/workflows/atlassian.fisheye.02.yml) | :no_entry_sign: | [![GHA](https://img.shields.io/github/actions/workflow/status/EpicMorg/docker/atlassian.mesh.02.yml?label=Status&logo=01&style=flat-square)](https://github.com/EpicMorg/docker/actions/workflows/atlassian.mesh.02.yml) |
| `03` | [![GHA](https://img.shields.io/github/actions/workflow/status/EpicMorg/docker/atlassian.bitbucket.03.yml?label=Status&logo=03&style=flat-square)](https://github.com/EpicMorg/docker/actions/workflows/atlassian.bitbucket.03.yml) | :no_entry_sign: | :no_entry_sign: | [![GHA](https://img.shields.io/github/actions/workflow/status/EpicMorg/docker/atlassian.crowd.03.yml?label=Status&logo=01&style=flat-square)](https://github.com/EpicMorg/docker/actions/workflows/atlassian.crowd.03.yml) | [![GHA](https://img.shields.io/github/actions/workflow/status/EpicMorg/docker/atlassian.fisheye.03.yml?label=Status&logo=01&style=flat-square)](https://github.com/EpicMorg/docker/actions/workflows/atlassian.fisheye.03.yml) | :no_entry_sign: | [![GHA](https://img.shields.io/github/actions/workflow/status/EpicMorg/docker/atlassian.mesh.03.yml?label=Status&logo=01&style=flat-square)](https://github.com/EpicMorg/docker/actions/workflows/atlassian.mesh.03.yml) |
| `04` | [![GHA](https://img.shields.io/github/actions/workflow/status/EpicMorg/docker/atlassian.bitbucket.04.yml?label=Status&logo=04&style=flat-square)](https://github.com/EpicMorg/docker/actions/workflows/atlassian.bitbucket.04.yml) | [![GHA](https://img.shields.io/github/actions/workflow/status/EpicMorg/docker/atlassian.confluence.04.yml?label=Status&logo=01&style=flat-square)](https://github.com/EpicMorg/docker/actions/workflows/atlassian.confluence.04.yml) | [![GHA](https://img.shields.io/github/actions/workflow/status/EpicMorg/docker/atlassian.jira.04.yml?label=Status&logo=01&style=flat-square)](https://github.com/EpicMorg/docker/actions/workflows/atlassian.jira.04.yml) | [![GHA](https://img.shields.io/github/actions/workflow/status/EpicMorg/docker/atlassian.crowd.04.yml?label=Status&logo=01&style=flat-square)](https://github.com/EpicMorg/docker/actions/workflows/atlassian.crowd.04.yml) | [![GHA](https://img.shields.io/github/actions/workflow/status/EpicMorg/docker/atlassian.fisheye.04.yml?label=Status&logo=01&style=flat-square)](https://github.com/EpicMorg/docker/actions/workflows/atlassian.fisheye.04.yml) | :no_entry_sign: | [![GHA](https://img.shields.io/github/actions/workflow/status/EpicMorg/docker/atlassian.mesh.04.yml?label=Status&logo=01&style=flat-square)](https://github.com/EpicMorg/docker/actions/workflows/atlassian.mesh.04.yml) |
| `05` | [![GHA](https://img.shields.io/github/actions/workflow/status/EpicMorg/docker/atlassian.bitbucket.05.yml?label=Status&logo=05&style=flat-square)](https://github.com/EpicMorg/docker/actions/workflows/atlassian.bitbucket.05.yml) | [![GHA](https://img.shields.io/github/actions/workflow/status/EpicMorg/docker/atlassian.confluence.05.yml?label=Status&logo=01&style=flat-square)](https://github.com/EpicMorg/docker/actions/workflows/atlassian.confluence.05.yml) | [![GHA](https://img.shields.io/github/actions/workflow/status/EpicMorg/docker/atlassian.jira.05.yml?label=Status&logo=01&style=flat-square)](https://github.com/EpicMorg/docker/actions/workflows/atlassian.jira.05.yml) | [![GHA](https://img.shields.io/github/actions/workflow/status/EpicMorg/docker/atlassian.crowd.05.yml?label=Status&logo=01&style=flat-square)](https://github.com/EpicMorg/docker/actions/workflows/atlassian.crowd.05.yml) | :no_entry_sign: | :no_entry_sign: | :no_entry_sign: |
| `06` | [![GHA](https://img.shields.io/github/actions/workflow/status/EpicMorg/docker/atlassian.bitbucket.06.yml?label=Status&logo=06&style=flat-square)](https://github.com/EpicMorg/docker/actions/workflows/atlassian.bitbucket.06.yml) | [![GHA](https://img.shields.io/github/actions/workflow/status/EpicMorg/docker/atlassian.confluence.06.yml?label=Status&logo=01&style=flat-square)](https://github.com/EpicMorg/docker/actions/workflows/atlassian.confluence.06.yml) | [![GHA](https://img.shields.io/github/actions/workflow/status/EpicMorg/docker/atlassian.jira.06.yml?label=Status&logo=01&style=flat-square)](https://github.com/EpicMorg/docker/actions/workflows/atlassian.jira.06.yml) | [![GHA](https://img.shields.io/github/actions/workflow/status/EpicMorg/docker/atlassian.crowd.06.yml?label=Status&logo=01&style=flat-square)](https://github.com/EpicMorg/docker/actions/workflows/atlassian.crowd.06.yml) | :no_entry_sign: | [![GHA](https://img.shields.io/github/actions/workflow/status/EpicMorg/docker/atlassian.bamboo.06.yml?label=Status&logo=01&style=flat-square)](https://github.com/EpicMorg/docker/actions/workflows/atlassian.bamboo.06.yml) | :no_entry_sign: |
| `07` | [![GHA](https://img.shields.io/github/actions/workflow/status/EpicMorg/docker/atlassian.bitbucket.07.yml?label=Status&logo=07&style=flat-square)](https://github.com/EpicMorg/docker/actions/workflows/atlassian.bitbucket.07.yml) | [![GHA](https://img.shields.io/github/actions/workflow/status/EpicMorg/docker/atlassian.confluence.07.yml?label=Status&logo=01&style=flat-square)](https://github.com/EpicMorg/docker/actions/workflows/atlassian.confluence.07.yml) | [![GHA](https://img.shields.io/github/actions/workflow/status/EpicMorg/docker/atlassian.jira.07.yml?label=Status&logo=01&style=flat-square)](https://github.com/EpicMorg/docker/actions/workflows/atlassian.jira.07.yml) | [![GHA](https://img.shields.io/github/actions/workflow/status/EpicMorg/docker/atlassian.crowd.07.yml?label=Status&logo=01&style=flat-square)](https://github.com/EpicMorg/docker/actions/workflows/atlassian.crowd.07.yml) | :no_entry_sign: | [![GHA](https://img.shields.io/github/actions/workflow/status/EpicMorg/docker/atlassian.bamboo.07.yml?label=Status&logo=01&style=flat-square)](https://github.com/EpicMorg/docker/actions/workflows/atlassian.bamboo.07.yml) | :no_entry_sign: |
| `08` | [![GHA](https://img.shields.io/github/actions/workflow/status/EpicMorg/docker/atlassian.bitbucket.08.yml?label=Status&logo=08&style=flat-square)](https://github.com/EpicMorg/docker/actions/workflows/atlassian.bitbucket.08.yml) | [![GHA](https://img.shields.io/github/actions/workflow/status/EpicMorg/docker/atlassian.confluence.08.yml?label=Status&logo=01&style=flat-square)](https://github.com/EpicMorg/docker/actions/workflows/atlassian.confluence.08.yml) | [![GHA](https://img.shields.io/github/actions/workflow/status/EpicMorg/docker/atlassian.jira.08.yml?label=Status&logo=01&style=flat-square)](https://github.com/EpicMorg/docker/actions/workflows/atlassian.jira.08.yml) | :no_entry_sign: | :no_entry_sign: | [![GHA](https://img.shields.io/github/actions/workflow/status/EpicMorg/docker/atlassian.bamboo.08.yml?label=Status&logo=01&style=flat-square)](https://github.com/EpicMorg/docker/actions/workflows/atlassian.bamboo.08.yml) | :no_entry_sign: |
| `09` | [![GHA](https://img.shields.io/github/actions/workflow/status/EpicMorg/docker/atlassian.bitbucket.09.yml?label=Status&logo=09&style=flat-square)](https://github.com/EpicMorg/docker/actions/workflows/atlassian.bitbucket.09.yml) | [![GHA](https://img.shields.io/github/actions/workflow/status/EpicMorg/docker/atlassian.confluence.09.yml?label=Status&logo=01&style=flat-square)](https://github.com/EpicMorg/docker/actions/workflows/atlassian.confluence.09.yml) | [![GHA](https://img.shields.io/github/actions/workflow/status/EpicMorg/docker/atlassian.jira.09.yml?label=Status&logo=01&style=flat-square)](https://github.com/EpicMorg/docker/actions/workflows/atlassian.jira.09.yml) | :no_entry_sign: | :no_entry_sign: | [![GHA](https://img.shields.io/github/actions/workflow/status/EpicMorg/docker/atlassian.bamboo.09.yml?label=Status&logo=01&style=flat-square)](https://github.com/EpicMorg/docker/actions/workflows/atlassian.bamboo.09.yml) | :no_entry_sign: |
| `10` | [![GHA](https://img.shields.io/github/actions/workflow/status/EpicMorg/docker/atlassian.bitbucket.10.yml?label=Status&logo=01&style=flat-square)](https://github.com/EpicMorg/docker/actions/workflows/atlassian.bitbucket.10.yml) | [![GHA](https://img.shields.io/github/actions/workflow/status/EpicMorg/docker/atlassian.confluence.10.yml?label=Status&logo=01&style=flat-square)](https://github.com/EpicMorg/docker/actions/workflows/atlassian.confluence.10.yml) | [![GHA](https://img.shields.io/github/actions/workflow/status/EpicMorg/docker/atlassian.jira.10.yml?label=Status&logo=01&style=flat-square)](https://github.com/EpicMorg/docker/actions/workflows/atlassian.jira.10.yml) | :no_entry_sign: | :no_entry_sign: | [![GHA](https://img.shields.io/github/actions/workflow/status/EpicMorg/docker/atlassian.bamboo.10.yml?label=Status&logo=01&style=flat-square)](https://github.com/EpicMorg/docker/actions/workflows/atlassian.bamboo.10.yml) | :no_entry_sign: |
| `11` | :no_entry_sign: | :no_entry_sign: | [![GHA](https://img.shields.io/github/actions/workflow/status/EpicMorg/docker/atlassian.jira.11.yml?label=Status&logo=01&style=flat-square)](https://github.com/EpicMorg/docker/actions/workflows/atlassian.jira.11.yml) | :no_entry_sign: | :no_entry_sign: | [![GHA](https://img.shields.io/github/actions/workflow/status/EpicMorg/docker/atlassian.bamboo.11.yml?label=Status&logo=01&style=flat-square)](https://github.com/EpicMorg/docker/actions/workflows/atlassian.bamboo.11.yml) | :no_entry_sign: |
| `12` | :no_entry_sign: | :no_entry_sign: | :no_entry_sign: | :no_entry_sign: | :no_entry_sign: | [![GHA](https://img.shields.io/github/actions/workflow/status/EpicMorg/docker/atlassian.bamboo.12.yml?label=Status&logo=01&style=flat-square)](https://github.com/EpicMorg/docker/actions/workflows/atlassian.bamboo.12.yml) | :no_entry_sign: |

> [!WARNING]
> **DEPRECATION WARNING**
> 
> **At 1st of October 2024 all deprecated tags and images were deleted from Hubs (DockerHub, Quay, etc):**

* `epicmorg/nodejs` - image, migrated to `epicmorg/debian:bookworm-nodejs<version>`. Look at `linux/ecosystem/epicmorg/debian/12-bookworm/nodejs`.
* `epicmorg/php` - image, migrated to `epicmorg/debian:bookworm-php<version>`. Look at `linux/ecosystem/epicmorg/debian/12-bookworm/php`.
* `epicmorg/python` - image, migrated to `epicmorg/debian:bookworm-python<version>`. Look at `linux/ecosystem/epicmorg/debian/12-bookworm/python`.
* `epicmorg/apache2:latest` - ONLY `latest` tag.
* `epicmorg/nginx:<version>.<build>` - deprecated tags with build-version. at now - all versions are only `<major>.<minor>`. Example: `1.27.1` -> `1.27`.
* `epicmorg/torrust-index` - deprecated, deleted as abadoned. Sorry.
* `epicmorg/torrust-tracker` - deprecated, deleted as abadoned. Sorry.
* `epicmorg/staytus` - deprecated, deleted as abadoned. Sorry.
* `epicmorg/freegpt-webui` - deprecated, deleted as abadoned. Sorry.
* `epicmorg/syspass` - deprecated, deleted as abadoned. Sorry.

> [!IMPORTANT]  
> **At 1st of May 2025 this images will be\were renamed and old images and tags will be\were deleted from Hubs (DockerHub, Quay, etc):**

* `epicmorg/linux-steamcmd` -> `epicmorg/games:steamcmd` - Base iamge for various games images.
* `epicmorg/linux-csgo` -> `epicmorg/games:csgo`.
* `epicmorg/linux-7d2d` -> `epicmorg/games:7d2d`.
* `epicmorg/win32` -> `epicmorg/windows` - Base `windows` images like a `epicmorg/debian`.


> [!IMPORTANT]  
> **At 1st of May 2025 this images will be\were archived at Hubs (DockerHub, Quay, etc):**

* `epicmorg/astralinux` - I am not shure to support this images.

For more information - look at `Support Document` to replace this tags and images.

# Secondary CI Status

| `Advanced` | `EcoSystem` | 
|:-------------|:-------------|
| [![GHA](https://img.shields.io/github/actions/workflow/status/EpicMorg/docker/chain.40-apps.yml?label=Mattermost&logo=Mattermost&style=flat-square)](https://github.com/EpicMorg/docker/actions/workflows/chain.40-apps.yml) | [![GHA](https://img.shields.io/github/actions/workflow/status/EpicMorg/docker/chain.40-apps.yml?label=PostgreSQL%20Images&logo=PostgreSQL%20Images&style=flat-square)](https://github.com/EpicMorg/docker/actions/workflows/chain.40-apps.yml) 
| [![GHA](https://img.shields.io/github/actions/workflow/status/EpicMorg/docker/advanced.nextcloud.yml?label=Nextcloud%20Images&logo=Nextcloud%20Images&style=flat-square)](https://github.com/EpicMorg/docker/actions/workflows/advanced.nextcloud.yml) | [![GHA](https://img.shields.io/github/actions/workflow/status/EpicMorg/docker/chain.40-apps.yml?label=Apache2&logo=Apache2&style=flat-square)](https://github.com/EpicMorg/docker/actions/workflows/chain.40-apps.yml)
| [![GHA](https://img.shields.io/github/actions/workflow/status/EpicMorg/docker/advanced.zabbix.yml?label=Zabbix%20Images&logo=Zabbix%20Images&style=flat-square)](https://github.com/EpicMorg/docker/actions/workflows/advanced.zabbix.yml)  | [![GHA](https://img.shields.io/github/actions/workflow/status/EpicMorg/docker/chain.40-apps.yml?label=Testrail%20Images&logo=Testrail%20Images&style=flat-square)](https://github.com/EpicMorg/docker/actions/workflows/chain.40-apps.yml)
| [![GHA](https://img.shields.io/github/actions/workflow/status/EpicMorg/docker/advanced.vscode.yml?label=Vscode%20Server%20Images&logo=Vscode%20Server%20Images&style=flat-square)](https://github.com/EpicMorg/docker/actions/workflows/advanced.vscode.yml) | [![GHA](https://img.shields.io/github/actions/workflow/status/EpicMorg/docker/chain.40-apps.yml?label=TeamCity%20Agents%20Images&logo=TeamCity%20Agents%20Images&style=flat-square)](https://github.com/EpicMorg/docker/actions/workflows/chain.40-apps.yml)
| [![GHA](https://img.shields.io/github/actions/workflow/status/EpicMorg/docker/advanced.teamcity-server.yml?label=TeamCity%20Servers&logo=EpicMorg%20TeamCity%20Servers&style=flat-square)](https://github.com/EpicMorg/docker/actions/workflows/advanced.teamcity-server.yml) | [![GHA](https://img.shields.io/github/actions/workflow/status/EpicMorg/docker/chain.40-apps.yml?label=EcoSystem%20Misc%20Images&logo=EcoSystem%20Misc%20Images&style=flat-square)](https://github.com/EpicMorg/docker/actions/workflows/chain.40-apps.yml)
| [![GHA](https://img.shields.io/github/actions/workflow/status/EpicMorg/docker/chain.40-apps.yml?label=Cassandra&logo=Cassandra&style=flat-square)](https://github.com/EpicMorg/docker/actions/workflows/chain.40-apps.yml) | [![GHA](https://img.shields.io/github/actions/workflow/status/EpicMorg/docker/atlassian.latest.yml?label=Atlassian%20Latest%20Images&logo=Atlassian%20Latest%20Images&style=flat-square)](https://github.com/EpicMorg/docker/actions/workflows/atlassian.latest.yml)
| :no_entry_sign: | [![GHA](https://img.shields.io/github/actions/workflow/status/EpicMorg/docker/chain.40-apps.yml?label=Perfocre%20Images&logo=Perfocre%20Images&style=flat-square)](https://github.com/EpicMorg/docker/actions/workflows/chain.40-apps.yml)
| :no_entry_sign: | [![GHA](https://img.shields.io/github/actions/workflow/status/EpicMorg/docker/chain.40-apps.yml?label=Gitlab%20Runner%20Images&logo=Gitlab%20Runner%20Images&style=flat-square)](https://github.com/EpicMorg/docker/actions/workflows/chain.40-apps.yml)
| :no_entry_sign: | [![GHA](https://img.shields.io/github/actions/workflow/status/EpicMorg/docker/chain.40-apps.yml?label=GitHub%20Runner%20Images&logo=GitHub%20Runner%20Images&style=flat-square)](https://github.com/EpicMorg/docker/actions/workflows/chain.40-apps.yml)
| :no_entry_sign: | [![GHA](https://img.shields.io/github/actions/workflow/status/EpicMorg/docker/chain.40-apps.yml?label=qBittorrent%20Images&logo=qBittorrent%20Images&style=flat-square)](https://github.com/EpicMorg/docker/actions/workflows/chain.40-apps.yml)
| :no_entry_sign: | [![GHA](https://img.shields.io/github/actions/workflow/status/EpicMorg/docker/chain.30-runtimes.yml?label=nginx&logo=nginx&style=flat-square)](https://github.com/EpicMorg/docker/actions/workflows/chain.30-runtimes.yml)
| :no_entry_sign: | [![GHA](https://img.shields.io/github/actions/workflow/status/EpicMorg/docker/base.astra.yml?label=astra%20rootfs&logo=astra%20rootfs&style=flat-square)](https://github.com/EpicMorg/docker/actions/workflows/base.astra.yml)
| :no_entry_sign: | [![GHA](https://img.shields.io/github/actions/workflow/status/EpicMorg/docker/base.astra.yml?label=astra%201.7&logo=astra%201.7&style=flat-square)](https://github.com/EpicMorg/docker/actions/workflows/base.astra.yml)
| :no_entry_sign: | [![GHA](https://img.shields.io/github/actions/workflow/status/EpicMorg/docker/base.astra.yml?label=astra%201.8&logo=astra%201.8&style=flat-square)](https://github.com/EpicMorg/docker/actions/workflows/base.astra.yml)

# Few popular products [![ko-fi](https://www.ko-fi.com/img/githubbutton_sm.svg)](https://ko-fi.com/B0B81CUI4)

| Application   | Pulls | Notes
| ------  | ------ | ------
| [![Atlassian Bitbucket](https://img.shields.io/badge/Atlassian%20Bitbucket--brightgreen.svg?style=popout-square)](https://www.atlassian.com/software/bitbucket/download) | [![](https://img.shields.io/docker/pulls/epicmorg/bitbucket.svg?style=popout-square)](https://hub.docker.com/r/epicmorg/bitbucket/) | `Atlassian Bitbucket` server. You also can install `datacenter` edition.
| [![Atlassian Confluence](https://img.shields.io/badge/Atlassian%20Confluence--brightgreen.svg?style=popout-square)](https://www.atlassian.com/software/confluence/download) |   [![](https://img.shields.io/docker/pulls/epicmorg/confluence.svg?style=popout-square)](https://hub.docker.com/r/epicmorg/confluence/) | `Atlassian Confluence` server. You also can install `datacenter` edition.
| [![Atlassian Jira](https://img.shields.io/badge/Atlassian%20Jira--brightgreen.svg?style=popout-square)](https://www.atlassian.com/software/jira/download) | [![](https://img.shields.io/docker/pulls/epicmorg/jira.svg?style=popout-square)](https://hub.docker.com/r/epicmorg/jira/) | `Atlassian Jira: Softrware` server.  You also can install `servicedesk`, `core` or `datacenter` editions.
| [![Nginx Mainline](https://img.shields.io/badge/Nginx--brightgreen.svg?style=popout-square)](https://nginx.org/en/download.html) |   [![](https://img.shields.io/docker/pulls/epicmorg/nginx.svg?style=popout-square)](https://hub.docker.com/r/epicmorg/nginx/) | Mainline custom build by [EpicMorg Team](https://github.com/EpicMorg) with http2 support and some modules.
| [![Apache2](https://img.shields.io/badge/Apache2--brightgreen.svg?style=popout-square)](https://deb.sury.su/)  |  [![](https://img.shields.io/docker/pulls/epicmorg/apache2.svg?style=popout-square)](https://hub.docker.com/r/epicmorg/apache2/ ) | Latest pure apache2.
| [![php7](https://img.shields.io/badge/php7--brightgreen.svg?style=popout-square)](https://deb.sury.su/) | [![](https://img.shields.io/docker/pulls/epicmorg/apache2.svg?style=popout-square)](https://hub.docker.com/r/epicmorg/apache2/ ) |  php 7.3 custom build by [Ondrej Sury](https://launchpad.net/~ondrej). Component of container above.
| [![nc](https://img.shields.io/badge/NextCloud--brightgreen.svg?style=popout-square)](https://hub.docker.com/_/nextcloud)  |  [![](https://img.shields.io/docker/pulls/epicmorg/nextcloud.svg?style=popout-square)](https://hub.docker.com/r/epicmorg/nextcloud/ ) | Fixed `nextcloud:latest` build by [EpicMorg Team](https://github.com/EpicMorg) with benefits.
| [![zabbix-agent](https://img.shields.io/badge/Zabbix%20Agent--brightgreen.svg?style=popout-square)](https://github.com/zabbix/zabbix-docker)  | [![](https://img.shields.io/docker/pulls/epicmorg/zabbix-agent.svg?style=popout-square)](https://hub.docker.com/r/epicmorg/zabbix-agent/ ) | Fixed `zabbix/zabbix-agent:ubuntu-latest` build by [EpicMorg Team](https://github.com/EpicMorg) with benefits.
| [![zabbix-server](https://img.shields.io/badge/Zabbix%20Server--brightgreen.svg?style=popout-square)](https://github.com/zabbix/zabbix-docker)  | [![](https://img.shields.io/docker/pulls/epicmorg/zabbix-server-mysql.svg?style=popout-square)](https://hub.docker.com/r/epicmorg/zabbix-server-mysql/ ) | Fixed `zabbix/zabbix-server-mysql:ubuntu-latest` build by [EpicMorg Team](https://github.com/EpicMorg) with benefits.
| [![zabbix-web](https://img.shields.io/badge/Zabbix%20Web--brightgreen.svg?style=popout-square)](https://github.com/zabbix/zabbix-docker)  | [![](https://img.shields.io/docker/pulls/epicmorg/zabbix-web-apache-mysql.svg?style=popout-square)](https://hub.docker.com/r/epicmorg/zabbix-web-apache-mysql/ ) | Fixed `zabbix/zabbix-web-apache-mysql:ubuntu-latest` build by [EpicMorg Team](https://github.com/EpicMorg) with benefits.
| [![zabbix-java-gateway](https://img.shields.io/badge/Zabbix%20JavaGW--brightgreen.svg?style=popout-square)](https://github.com/zabbix/zabbix-docker)  | [![](https://img.shields.io/docker/pulls/epicmorg/zabbix-java-gateway.svg?style=popout-square)](https://hub.docker.com/r/epicmorg/zabbix-java-gateway/ ) | Fixed `zabbix/zabbix-java-gateway:ubuntu-latest` build by [EpicMorg Team](https://github.com/EpicMorg) with benefits.
| [![teamcity-agent](https://img.shields.io/badge/TeamCity%20Agent--brightgreen.svg?style=popout-square)](https://github.com/JetBrains/teamcity-docker-agent)  | [![](https://img.shields.io/docker/pulls/epicmorg/teamcity-agent.svg?style=popout-square)](https://hub.docker.com/r/epicmorg/teamcity-agent/ ) | Custom build by [EpicMorg Team](https://github.com/EpicMorg) with benefits.
| [![qbittorrent](https://img.shields.io/badge/qBittorrent--brightgreen.svg?style=popout-square)](https://github.com/qbittorrent/qBittorrent)  | [![](https://img.shields.io/docker/pulls/epicmorg/qbittorrent.svg?style=popout-square)](https://hub.docker.com/r/epicmorg/qbittorrent/ ) | Custom build by [EpicMorg Team](https://github.com/EpicMorg) with benefits.


# [Stargazers](https://github.com/EpicMorg/docker/stargazers)

# [Forkers](https://github.com/EpicMorg/docker/network/members)

# &#8627; Special Thanks:

* [@Aleks-Z](https://github.com/Aleks-Z)
* [@alex4rks](https://github.com/alex4rks)
* [@kasthack](https://github.com/kasthack)
* [@Em1tSan](https://github.com/Em1tSan)

# :money_with_wings: Donate

You could support us if you want.

| Adress   | Name | Coin 
| ------  | ------ | ------ 
| `EQDvHXRK-K1ZieJhgTD9JZQk7xCnWzRbctYnUkWq1lZq1bUg` | Toncoin | TON
| `0x26a8443a694f08cdfec966aa6fd72c45068753ec` | Ethereum | ETH
| `bc1querz8ug9asjmsuy6yn4a94a2athgprnu7e5zq2` | Bitcoin | BTC	
| `ltc1qtwwacq8f0n76fer2y83wxu540hddnmf8cdrlvg` | Litecoin | LTC	
| `4SbMynYETyhmKdggu8f38ULU6yQKiJPuo6` | Novacoin | NVC 
| `DHyfE1CZzWtyaQiaMmv6g4KvXVQRUgrYE6` | Dogecoin | DOGE	
| `pQWArPzYoLppNe7ew3QPfto1k1eq66BYUB` | Peercoin | PPC	
| `R9t2LKeLhDSZBKNgUzSDZAossA3UqNvbV3` | Ravencoin | RVN	
| `t1KRMMmwMSZth8vJcd2ZHtPEFKTQ74yVixE` | ZCash | ZEC	
| `884PqZ1gDjWW7fKxtbaeRoBeSh9EGZbkqUyLriWmuKbwLZrAJdYUs4wQxoVfEJoW7LBhdQMP9cFhZQpJr6xvg7esHLdCbb1` | Monero | XMR	
