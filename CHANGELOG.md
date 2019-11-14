## Changelog
* 11/14/2019
    * updated `atlassian` stack.
* 10/22/2019
    * updated `atlassian` stack.
    * fixed `staytus` Dockerfile.
* 10/02/2019
    * added custom fork of `staytus` dockerfile. original code [here](https://github.com/adamcooke/staytus).
* 10/01/2019
    * added `nmap` and `telnet` to `zabbix-*`. sorry.
    * added `nmap` and `telnet` to base image.
* 09/27/2019
    * updated confluence `latest` tag to `7.0.1`.
* 09/26/2019
    * Atlassian images fully migrated to new base.
    * All images will be CI with TravisCI. Not only `latest` and `lts`. Yay!
* 09/25/2019
    * added `Travis CI` like a builds validator. Only for stable `latest` releases.
    * `jira`, `bitbucket`, `confluence` mgrated to new base images.
    * nginx updated to `1.17.4`.
* 09/22-24/2019
    * added our base images - `epicmorg/prod` for our production containers and `epicmorg/devel` for `TeamCity Agent` and temp images for builds.
    * our custom teamcity contaner migrated to `epicmorg/devel` base image.
    * fully reworked `nginx:latest` contaner + added php support (`nginx:php`). now it building by us. and old custom contaner moved to `nginx:legacy` tag.
    * `jira` updated.
    * `bitbucket` updated.
    * `confluence` updated. `latest` tag is still using 6.15.x version. not 7.x. it is temprorary.
    * added `Travis CI` like a builds validator. Only for stable `latest` releases.
* 09/01-22/2019
    * added custom build of `TeamCity Agent`. additionally added support on SourceSDK out of the box.
    * fixed `nextcloud` image.
* 08/16/2019
    * zabbix, added  anget, java gw
* 08/15/2019
    * zabbix, fixed version. web and server.
* 08/05/2019
    * `bitbucket` updated.
    * `jira` updated.
* 07/16/2019
    * `confluence` updated.
* 07/14/2019
    * `jira` updated.
* 07/05/2019
    * `jira` updated.
    * `bitbucket` updated.
    * `confluence` updated.
* 06/03/2019
    * `jira` updated.
    * `bitbucket` updated.
* 05/21/2019
    * `jira` updated.
    * fixed missed `locale.gen`
* 05/14/2019
    * added another versions of `bitbucket` between `6.2` and `6.3`.
    * bugs fixed
* 05/17/2019
    * added another versions of `confluence` between `6.9` and `6.15`.
    * bugs fixed
* 05/13/2019
    * added another versions of `jira` between `7.10` and `8.1`.
* 04/17/2019
    * bitbucket `6.2.0` + adoptopenjdk8
    * jira `8.1.0` + adoptopenjdk8
    * confluence `6.15.2` + adoptopenjdk8
* 04/10/2019
    * fixed some scripts. added php7.2 tag for `websites`.
    * added zabbix containers. why not.
* 04/08/2019
    * added fixed (for us) `nextcloud` script. its a `nextcloud:latest` fork.
* 04/01/2019
    * added missing files to some of scripts
    * deleted very old versions on confluence, now only 6.x
    * confluence `6.15.1`
    * bitbucket `6.1.2`
* 03/07/2019
    * atlassian scripts fixed
    * java switched from `openjdk` to `oracle` for `jira` and `confluence` containers
* 03/06/2019
    * bitbucket `6.1.0`
    * jira `8.0.2`
    * confluence `6.14.2`
    * migrated from `alpine` to `debian` contaiers:
        * jira
        * confluence
        * bitbucket
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
