#  [![Activity](https://img.shields.io/github/commit-activity/m/EpicMorg/docker?label=commits&style=flat-square)](https://github.com/EpicMorg/docker/commits) [![GitHub issues](https://img.shields.io/github/issues/EpicMorg/docker.svg?style=popout-square)](https://github.com/EpicMorg/docker/issues) [![GitHub forks](https://img.shields.io/github/forks/EpicMorg/docker.svg?style=popout-square)](https://github.com/EpicMorg/docker/network) [![GitHub stars](https://img.shields.io/github/stars/EpicMorg/docker.svg?style=popout-square)](https://github.com/EpicMorg/docker/stargazers)  [![Size](https://img.shields.io/github/repo-size/EpicMorg/docker?label=size&style=flat-square)](https://github.com/EpicMorg/docker/archive/master.zip) [![Release](https://img.shields.io/github/v/release/EpicMorg/docker?style=flat-square)](https://github.com/EpicMorg/docker/releases) [![CII Best Practices](https://bestpractices.coreinfrastructure.org/projects/3658/badge)](https://bestpractices.coreinfrastructure.org/projects/3658) [![CodeScene System Mastery](https://codescene.io/projects/6535/status-badges/system-mastery)](https://codescene.io/projects/6535) [![GitHub license](https://img.shields.io/github/license/EpicMorg/docker.svg?style=popout-square)](LICENSE.md) [![Changelog](https://img.shields.io/badge/Changelog-yellow.svg?style=popout-square)](CHANGELOG.md)


## Support Document for Docker Image Concepts in Project

| `ru-RU` | `en-US` | 
|:-------------|:-------------|
| [:ru: :bookmark_tabs:](SUPPORT.ru.md) | [:us: :bookmark_tabs:](SUPPORT.md)

 

## Description
A collection of docker images for production use. This repo contains 2 types of images - `advanced` and `ecosystem`. We support `linux x86_64` docker engine (`Win64` is still in the ***testing*** stage).

* `linux/advanced` folder contains improved images like `nextcloud` or `teamcity server`, `zabbix collection`, etc. These images just forked from original developers and patched a bit.
* `linux/ecosystem` folder contains images developed by our team like full `Atlassian Stack`, compilled `nginx`, `php`, `testrail` and othres.

![](https://raw.githubusercontent.com/EpicMorg/docker/master/.github/logo.png)

# CI Status

| `Advanced` | `EcoSystem - Debian Based` | 
|:-------------|:-------------|
| [![GHA](https://img.shields.io/github/actions/workflow/status/EpicMorg/docker/epicmorg.advanced.vscode.images.yml?label=EpicMorg%20Advanced%20Images&logo=EpicMorg%20Advanced%20Images&style=flat-square)](https://github.com/EpicMorg/docker/blob/master/.github/workflows/epicmorg.advanced.images.yml) | [![GHA](https://img.shields.io/github/actions/workflow/status/EpicMorg/docker/epicmorg.base.images.giltab.runners.yml?label=Gitlab%20Runner%20Images&logo=Gitlab%20Runner%20Images&style=flat-square)](https://github.com/EpicMorg/docker/actions/workflows/epicmorg.base.images.giltab.runners.yml)
| [![GHA](https://img.shields.io/github/actions/workflow/status/EpicMorg/docker/epicmorg.advanced.nextcloud.images.yml?label=Nextcloud%20Images&logo=Nextcloud%20Images&style=flat-square)](https://github.com/EpicMorg/docker/actions/workflows/epicmorg.advanced.nextcloud.images.yml) | [![GHA](https://img.shields.io/github/actions/workflow/status/EpicMorg/docker/epicmorg.base.images.debian.11.yml?label=Debian%2011%20Images&logo=Debian%2011%20Images&style=flat-square)](https://github.com/EpicMorg/docker/actions/workflows/epicmorg.base.images.debian.11.yml)
| [![GHA](https://img.shields.io/github/actions/workflow/status/EpicMorg/docker/epicmorg.advanced.python.yml?label=Debian%20Python%20Images&logo=Debian%20Python%20Images&style=flat-square)](https://github.com/EpicMorg/docker/actions/workflows/epicmorg.advanced.python.yml) | [![GHA](https://img.shields.io/github/actions/workflow/status/EpicMorg/docker/epicmorg.base.images.debian.12.yml?label=Debian%2012%20Images&logo=Debian%2012%20Images&style=flat-square)](https://github.com/EpicMorg/docker/actions/workflows/epicmorg.base.images.debian.12.yml)
| [![GHA](https://img.shields.io/github/actions/workflow/status/EpicMorg/docker/epicmorg.advanced.vscode.images.yml?label=Vscode%20Server%20Images&logo=Vscode%20Server%20Images&style=flat-square)](https://github.com/EpicMorg/docker/actions/workflows/epicmorg.advanced.vscode.images.yml) | [![GHA](https://img.shields.io/github/actions/workflow/status/EpicMorg/docker/epicmorg.base.images.debian.legacy.yml?label=Debian%20Legacy%20Images&logo=Debian%20Legacy%20Images&style=flat-square)](https://github.com/EpicMorg/docker/actions/workflows/epicmorg.base.images.debian.legacy.yml) 
| [![GHA](https://img.shields.io/github/actions/workflow/status/EpicMorg/docker/epicmorg.advanced.zabbix.images.yml?label=Debian%20Zabbix%20Images&logo=Debian%20Python%20Images&style=flat-square)](https://github.com/EpicMorg/docker/actions/workflows/epicmorg.advanced.zabbix.images.yml) | [![GHA](https://img.shields.io/github/actions/workflow/status/EpicMorg/docker/epicmorg.ecosysctem.misc.images.yml?label=EcoSystem%20Misc%20Images&logo=EcoSystem%20Misc%20Images&style=flat-square)](https://github.com/EpicMorg/docker/actions/workflows/epicmorg.ecosysctem.misc.images.yml)
| `-` | [![GHA](https://img.shields.io/github/actions/workflow/status/EpicMorg/docker/epicmorg.base.images.current.atlassian.yml?label=Atlassian%20Images&logo=Atlassian%20Images&style=flat-square)](https://github.com/EpicMorg/docker/actions/workflows/epicmorg.base.images.current.atlassian.yml)
| `-` | [![GHA](https://img.shields.io/github/actions/workflow/status/EpicMorg/docker/epicmorg.base.images.nodejs.yml?label=NodeJS%20Images&logo=NodeJS%20Images&style=flat-square)](https://github.com/EpicMorg/docker/actions/workflows/epicmorg.base.images.nodejs.yml)
| `-` | [![GHA](https://img.shields.io/github/actions/workflow/status/EpicMorg/docker/epicmorg.base.images.perforce.yml?label=Perfocre%20Images&logo=Perfocre%20Images&style=flat-square)](https://github.com/EpicMorg/docker/actions/workflows/epicmorg.base.images.perforce.yml)
| `-` | [![GHA](https://img.shields.io/github/actions/workflow/status/EpicMorg/docker/epicmorg.base.images.postgresql.yml?label=PostgreSQL%20Images&logo=PostgreSQL%20Images&style=flat-square)](https://github.com/EpicMorg/docker/actions/workflows/epicmorg.base.images.postgresql.yml)
| `-` | [![GHA](https://img.shields.io/github/actions/workflow/status/EpicMorg/docker/epicmorg.base.images.teamcity.agents.yml?label=TeamCity%20Agents%20Images&logo=TeamCity%20Agents%20Images&style=flat-square)](https://github.com/EpicMorg/docker/actions/workflows/epicmorg.base.images.teamcity.agents.yml)
| `-` | [![GHA](https://img.shields.io/github/actions/workflow/status/EpicMorg/docker/epicmorg.base.images.testrail.yml?label=Testrail%20Images&logo=Testrail%20Images&style=flat-square)](https://github.com/EpicMorg/docker/actions/workflows/epicmorg.base.images.testrail.yml)
| `-` | [![GHA](https://img.shields.io/github/actions/workflow/status/EpicMorg/docker/epicmorg.base.images.web.yml?label=Web%20Images&logo=Web%20Images&style=flat-square)](https://github.com/EpicMorg/docker/actions/workflows/epicmorg.base.images.web.yml)

# Few popular products [![ko-fi](https://www.ko-fi.com/img/githubbutton_sm.svg)](https://ko-fi.com/B0B81CUI4)

| Application   | Pulls | Notes
| ------  | ------ | ------
| [![Atlassian Bitbucket](https://img.shields.io/badge/Atlassian%20Bitbucket--brightgreen.svg?style=popout-square)](https://www.atlassian.com/software/bitbucket/download) | [![](https://img.shields.io/docker/pulls/epicmorg/bitbucket.svg?style=popout-square)](https://hub.docker.com/r/epicmorg/bitbucket/) | `Atlassian Bitbucket` server. You also can install `datacenter` edition.
| [![Atlassian Confluence](https://img.shields.io/badge/Atlassian%20Confluence--brightgreen.svg?style=popout-square)](https://www.atlassian.com/software/confluence/download) |   [![](https://img.shields.io/docker/pulls/epicmorg/confluence.svg?style=popout-square)](https://hub.docker.com/r/epicmorg/confluence/) | `Atlassian Confluence` server. You also can install `datacenter` edition.
| [![Atlassian Jira](https://img.shields.io/badge/Atlassian%20Jira--brightgreen.svg?style=popout-square)](https://www.atlassian.com/software/jira/download) | [![](https://img.shields.io/docker/pulls/epicmorg/jira.svg?style=popout-square)](https://hub.docker.com/r/epicmorg/jira/) | `Atlassian Jira: Softrware` server.  You also can install `servicedesk`, `core` or `datacenter` editions.
| [![Nginx Mainline](https://img.shields.io/badge/Nginx--brightgreen.svg?style=popout-square)](https://nginx.org/en/download.html) |   [![](https://img.shields.io/docker/pulls/epicmorg/nginx.svg?style=popout-square)](https://hub.docker.com/r/epicmorg/nginx/) | Mainline custom build by [EpicMorg Team](https://github.com/EpicMorg) with http2 support and some modules.
| [![Apache2](https://img.shields.io/badge/Apache2--brightgreen.svg?style=popout-square)](https://deb.sury.org/)  |  [![](https://img.shields.io/docker/pulls/epicmorg/apache2.svg?style=popout-square)](https://hub.docker.com/r/epicmorg/apache2/ ) | Latest pure apache2.
| [![php7](https://img.shields.io/badge/php7--brightgreen.svg?style=popout-square)](https://deb.sury.org/) | [![](https://img.shields.io/docker/pulls/epicmorg/apache2.svg?style=popout-square)](https://hub.docker.com/r/epicmorg/apache2/ ) |  php 7.3 custom build by [Ondrej Sury](https://launchpad.net/~ondrej). Component of container above.
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
