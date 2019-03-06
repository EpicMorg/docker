# docker-scripts

[![GitHub issues](https://img.shields.io/github/issues/EpicMorg/docker-scripts.svg?style=popout-square)](https://github.com/EpicMorg/docker-scripts/issues) [![GitHub forks](https://img.shields.io/github/forks/EpicMorg/docker-scripts.svg?style=popout-square)](https://github.com/EpicMorg/docker-scripts/network) [![GitHub stars](https://img.shields.io/github/stars/EpicMorg/docker-scripts.svg?style=popout-square)](https://github.com/EpicMorg/docker-scripts/stargazers) [![GitHub license](https://img.shields.io/github/license/EpicMorg/docker-scripts.svg?style=popout-square)](https://github.com/EpicMorg/docker-scripts/blob/master/LICENSE)

# Products

| Application  | Version | Pulls | Notes
| ------ | ------ | ------ | ------
| [![Atlassian Bitbucket](https://img.shields.io/badge/Atlassian-Bitbucket-brightgreen.svg?style=popout-square)](https://www.atlassian.com/software/bitbucket/download) | [![Atlassian Bitbucket](https://img.shields.io/badge/6.1.0-ff69b4.svg?style=popout-square)](https://github.com/EpicMorg/docker-scripts/tree/master/bitbucket/latest) |   [![](https://img.shields.io/docker/pulls/epicmorg/bitbucket.svg?style=popout-square)](https://hub.docker.com/r/epicmorg/bitbucket/) | Just generic `Jira Software` server. You can install servicedesk\core.
| [![Atlassian Confluence](https://img.shields.io/badge/Atlassian-Confluence-brightgreen.svg?style=popout-square)](https://www.atlassian.com/software/confluence/download) | [![Atlassian Confluence](https://img.shields.io/badge/6.14.1-ff69b4.svg?style=popout-square)](https://github.com/EpicMorg/docker-scripts/tree/master/confluence/latest) |   [![](https://img.shields.io/docker/pulls/epicmorg/confluence.svg?style=popout-square)](https://hub.docker.com/r/epicmorg/confluence/) | Additionaly have [![Atlassian Bitbucket](https://img.shields.io/badge/5.6.4-ff69b4.svg?style=popout-square)](https://github.com/EpicMorg/docker-scripts/tree/master/confluence/5.6.4) and  [![Atlassian Bitbucket](https://img.shields.io/badge/5.10.8-ff69b4.svg?style=popout-square)](https://github.com/EpicMorg/docker-scripts/tree/master/confluence/5.10.4) versions.
| [![Atlassian Jira](https://img.shields.io/badge/Atlassian-Jira-brightgreen.svg?style=popout-square)](https://www.atlassian.com/software/bitbucket/download) | [![Atlassian Jira](https://img.shields.io/badge/8.0.2-ff69b4.svg?style=popout-square)](https://github.com/EpicMorg/docker-scripts/tree/master/jira/latest) |  [![](https://img.shields.io/docker/pulls/epicmorg/jira.svg?style=popout-square)](https://hub.docker.com/r/epicmorg/jira/) |  Additionaly have [![Atlassian Bitbucket](https://img.shields.io/badge/7.10.0-ff69b4.svg?style=popout-square)](https://github.com/EpicMorg/docker-scripts/tree/master/jira/7.10.0)  version. 
| [![Nginx Mainline](https://img.shields.io/badge/Nginx%20Mainline-brightgreen.svg?style=popout-square)](https://deb.sury.org/) | [![Nginx Mainline](https://img.shields.io/badge/1.15.8-ff69b4.svg?style=popout-square)](https://github.com/EpicMorg/docker-scripts/tree/master/balancer) |  [![](https://img.shields.io/docker/pulls/epicmorg/balancer.svg?style=popout-square)](https://hub.docker.com/r/epicmorg/balancer/) | Nginx mainline custom build by [Ondrej Sury](https://launchpad.net/~ondrej) with http2 support and some modules.
| [![Apache2](https://img.shields.io/badge/Apache2-brightgreen.svg?style=popout-square)](https://deb.sury.org/) | [![Apache2](https://img.shields.io/badge/2.4.38-ff69b4.svg?style=popout-square)](https://github.com/EpicMorg/docker-scripts/tree/master/websites) |  [![](https://img.shields.io/docker/pulls/epicmorg/websites.svg?style=popout-square)](https://hub.docker.com/r/epicmorg/websites/ ) | Latest pure apache2.
| [![php7](https://img.shields.io/badge/php7-brightgreen.svg?style=popout-square)](https://deb.sury.org/) | [![PHP7](https://img.shields.io/badge/7.3-ff69b4.svg?style=popout-square)](https://github.com/EpicMorg/docker-scripts/tree/master/websites) |  [![](https://img.shields.io/docker/pulls/epicmorg/websites.svg?style=popout-square)](https://hub.docker.com/r/epicmorg/websites/ ) |  php 7.3 custom build by [Ondrej Sury](https://launchpad.net/~ondrej). Component of container above.

## Changelog
* 03/06/2019
    * bitbucket `6.1.0`
    * jira `8.0.2`
    * migrating from `alpine` to `debian` contaiers:
        * jira
* 03/04/2019
    * nginx-full -> nginx-extras `1.15.9`
    * bitbucket `6.0.1`
    * jira `8.0.1` (bugs!)
    * various script fixes
* 02/19/2019
    * jira `8.0.0`
* 02/14/2019
    * bitbucket `5.16.0` -> `6.0.0`
    * confluence `6.14.0` -> `6.14.1`
* 02/12/2019
    * added curl binary to `balancer` and `websites` containers.
    * added support for ioncube for php7.3 (enabled by default) in `websites` container.
* 02/11/2019 - updated *balancer* and *websites* images.
    * moved from `ubuntu:bionic` to `debian:buster` images. anyone can safely update.
    * php `7.2` -> `7.3`
    * apache `2.4.34` -> `2.4.38`
    * nginx `1.15.8` -> `nginx-full` `1.15.8` (`nginx-extras` is still broken)
    * default preinstalled packages to `balancer` and `websites` containers: `ca-certificates`, `apt-transport-https`, `mc`, `iputils-ping` and some other.
    * added support for additional locales to `balancer` and `websites` containers (default is `en_US.UTF-8`).
    * apt sources switched to `Yandex-Mirror`.
* 01/01/1970 - see commit history. sorry.
