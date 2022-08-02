## Changelog
### 2022
* `aug`:
	* added basic support of perforce images. `p4p` already added. versions: `r16.2`, `r17.1`, `r17.2`, `r18.1`, `r18.2`, `r19.1`, `r19.2`, `r20.1`, `r20.2`, `r21.1`, `r21.2`, `r22.1`.
* `july`:
	* splited `zabbix` versions from `3.0` to `6.4` and `latest`.
* `june`:
	* new `python` base images. supported `2.7`, `3.6`, `3.7`, `3.8`, `3.9`, `3.10`, `3.11`
	* added some soft to `debian` base images.
* `april, may` - :x: `BREAKING CHANGES` :x:
	* deprecating `epicmorg/prod`, `epicmorg/edge`, `epicmorg/develop` images.
	* legacy images are replaced by new base images. see `epicmorg/debian` section.
	* added `nodejs18`
	* updated `jira8`, `bitbucket`, `vscode`
	* updated `apache2`, `zabbix`, `nextcloud`
	* added `retracker` by [vvampirius/retracker](https://github.com/vvampirius/retracker).
* `february, march`
	* new `nextcloud` images, updated `atlassian` images.
	* new `nodejs` iamges.
* `january`
	* fixed `apache2`
	* added `php8` support
	* extended `testrail` releases with `active directory` and `ldap` auth support.
### 2021
* `december`
	* added `git-lfs`, `lazygit`, bumped versions of nginx, jira, conflunce and bitbucket.
	* added another git addons
	* added `gh` - `github-cli` support
* `october-november`
	* added `nginx:quic` image. UNSTABLE.
	* added `redash:latest` image in to `advanced` pack.
	* improved `Makefile`s.
	* fixed `nextcloud` images.
		* splited `nextcloud` images to `pure` and `patched` (`zipstreamer`) tags.
	* added `torrserver` by @Aleks-Z :v:
	* added `advanced` image of `vcsode server`. original image by [linuxserver/docker-code-server](https://github.com/linuxserver/docker-code-server).
* `september`
	* added [ArekSredzki/electron-release-server](https://github.com/ArekSredzki/electron-release-server/) support.
	* fully reworked `teamcity-agent` images.
	* added `java 16` support to base images.
	* moved images to `advanced` and `ecosystem` folders.
	* migrated from `country code` to `httpredir` (more stable) official `debian` mirror.
	* `nginx 1.21.3`.
* `august`
	* splited `tc-agents` with `nodejs`
	* fixed `PostgreSQL` images
	* added `PostgreSQL 13` and  `PostgreSQL 14`. `latest` tag symlinked to `14`.
* `july`
	* nothing
* `june`
	* migrated to `docker-compose` build-system.
	* added older versions of `nginx`.
* `may`
	* @kasthack was wrote docker-template generator for atlassian products
		* was regenerated and updated *all* `jira` images with `5`, `6`, `7` and `8` versions.
		*  was regenerated and updated *all* `fisheye-crucible` images with `2`, `3` and `4` versions.
		* all actual download links was get from [EpicMorg/atlassian-json](https://github.com/EpicMorg/atlassian-json) repo.
	* asap will be updated and added all additional `atlassian` images.
* `april`
	* updated `nextcloud` images
	* `[BREAKING CHANGES]` reorganized space - `linux` and `win32` folders
	* `[BREAKING CHANGES]` images `balancer` and `websites` was renamed to `nginx` and `apache2`.
		* support of old repos will be unlin `jan/2022`. please usen new instead.
	* updated `atlassian` images
	* fixed scripts by `find . -name '*.sh' -type f | xargs chmod +x` by [sof](https://stackoverflow.com/questions/13377606/chmod-recursively).
	* added suport of `win32` images. just experemental.
* `march`
	* `apache2`, `nginx`, `php` - fixed php versions, fixed dependency hell. code updated.
	* `nginx` 1.19.8
	* `testrail` v7+ migrated to `php 7.4`
	* updated `atlassian` images, `nextcloud`
* `february`
	* hm.. nothing
* `january`
	* splitted `php` from `websites` images. all versions - `7.2-7.4`.
	* updated `ioncube loader` for `php7.4`. enabled by degault.
	* added support of `p4php` module. for all versions. enabled by degault.
	* updated `atlassian` images.
	* deprecated `syspass` iamge. sorry.
	* updated `nginx`. and reworked `php` image, now it based in splitted php-image. yay.
	* updated `teamcity agent` image.
-------------------------------------------------------------------
### 2020
* `december`
	* added mattermost
	* fixed some images
* `november`
	* fixes and updated images
	* migrated to github actions
* `October`
	* fixes and updated images
* `September`
	* fixes
	* updated `base images`, `apache2`, `testrail`, `TeamCity Agnet`, `nginx`, `bitbucket`, `jira`, `confluence`
* `August`
	* added `testrail` based on `websites:php7.2` image. always `latest` version
	* added `balancer:rtmp-hls` image, based on `balancer:latest` and [TareqAlqutami/rtmp-hls-server](https://github.com/TareqAlqutami/rtmp-hls-server) configs. `TareqAlqutami`, thank you for it.
* `May-july 2020`
	* Upgraded `TeamCity Agnet`
	* upgraded `nginx`
	* Fixed `Nextcloud`
	* Fixed `qBittorrent`
	* Added `websites:php7.3`
	* Updated `atlassian` versions
	* Added `testrail` (beta release)
	* Fixed bugs
* `March-Apr 2020`
	* Added new atlassian versions
	* Fixed bugs
	* Upgraded nginx
* `February 2020`
	* **Big rework of repositories on github**. Containers was Splited to another sub-repositories. Now current repo will be contain only fresh and latest versions of images. All older versions will be appeared in sub-repos. More fater building, less bad load to CI.
	* `fixed` all `*.sh` chmods. (sorry)
	* fixed `balancer` final container with `edge`.
	* `websites` migrated to `edge`. why not?
	* added `jdk6` and `jdk7` base images
	* addded `PostgresSQL 9-12`
* `January 2020` (01/13/2020 - 01/30/2020)
    * separated `base` images to `prod`, `prod:jdk8`, `prod:jdk11`, `devel`, `devel:jdk8`, `devel:jdk11` 
	* teamcity -  `devel:jdk11`
	* updated current atlassian contaners: 
		* `bitbucket` all current versions (`6.2`-`latest`) - `prod:jdk11`,
		* `confluence` before `7.1` - `prod:jdk8`, after - `7.1` - `prod:jdk11`,
		* `jira` before `8.2` - `prod:jdk8`, after - `8.2` - `prod:jdk11`
	* updated `Atlassian` stack:
		* added `Jira 8.x`: `8.0.3`, `8.1.2`, `8.1.3`, `8.2.5`, `8.2.6`, `8.3.5`, `8.4.3` , `8.6.0` , `8.6.1`
		* added `Jira 7.0.x`: `7.0.0`, `7.0.2`, `7.0.5`, `7.0.10`, `7.0.11`
		* added `Jira 7.1.x`: `7.1.0`, `7.1.1`, `7.1.2`, `7.1.4`, `7.1.6`, `7.1.7`, `7.1.8`, `7.1.9`, `7.1.10`
		* added `Jira 7.2.x`: `7.2.0`, `7.2.1`, `7.2.2`, `7.2.3`, `7.2.4`, `7.2.6`, `7.2.7`, `7.2.8`, `7.2.9`, `7.2.10`, `7.2.11`, `7.2.12`, `7.2.13`, `7.2.14`, `7.2.15`
		* added `Jira 7.3.x`: `7.3.0`, `7.3.1`, `7.3.2`, `7.3.3`, `7.3.4`, `7.3.5`, `7.3.6`, `7.3.7`, `7.3.8`, `7. 3.9`
		* added `Jira 7.4.x`: `7.4.0`, `7.4.1`, `7.4.2`, `7.4.3`, `7.4.4`, `7.4.5`, `7.4.6`
		* added `Jira 7.5.x`: `7.5.0`, `7.5.1`, `7.5.2`, `7.5.3`, `7.5.4`
		* added `Jira 7.6.x`: `7.6.0`, `7.6.1`, `7.6.2`, `7.6.3`, `7.6.4`, `7.6.6`, `7.6.7`, `7.6.8`, `7.6.9`, `7.6.10`, `7.6.11`, `7.6.12`, `7.6.13`, `7.6.14`, `7.6.15`, `7.6.16`, `7.6.17`
		* added `Jira 7.7.x`: `7.7.0`, `7.7.1`, `7.7.2`, `7.7.4`
		* added `Jira 7.8.x`: `7.8.0`, `7.8.1`, `7.8.2`, `7.8.4`
		* added `Jira 7.9.x`: `7.9.0`, `7.9.2`
		* added `Bitbucket 6.0.x`: `6.0.0`, `6.0.1`, `6.0.2`, `6.0.3`, `6.0.4`, `6.0.5`, `6.0.6`, `6.0.7`, `6.0.9`, `6.0.10`, `6.0.11`
		* added `Bitbucket 6.1.x`: `6.1.0`, `6.1.1`, `6.1.2`, `6.1.3`, `6.1.4`, `6.1.5`, `6.1.6`, `6.1.7`, `6.1.8`, `6.1.9`
		* added `Bitbucket 6.2.x`: `6.2.2`, `6.2.3`, `6.2.4`, `6.2.5`, `6.2.6`, `6.2.7`
		* added `Bitbucket 6.3.x`: `6.3.3`, `6.3.4`, `6.3.5`, `6.3.6`
		* added `Bitbucket 6.4.x`: `6.4.2`, `6.4.3`, `6.4.4`
		* added `Bitbucket 6.5.x`: `6.5.3`
		* added `Bitbucket 6.6.x`: `6.6.3`
		* added `Bitbucket 6.7.x`: `6.7.3`
		* added `Bitbucket 6.8.x`: `6.8.2`
		* added `Bitbucket 6.9.x`: `6.9.0`, `6.9.1`
		* added `Bitbucket 6.10.x`: `6.10.0`
		* added `Confluence 6.0.x`: `6.0.1`, `6.0.2`, `6.0.3`, `6.0.4`, `6.0.5`, `6.0.6`, `6.0.7`
		* added `Confluence 6.1.x`: `6.1.0`, `6.1.1`, `6.1.2`, `6.1.3`, `6.1.4`
		* added `Confluence 6.2.x`: `6.2.0`, `6.2.1`, `6.2.3`, `6.2.4`
		* added `Confluence 6.3.x`: `6.3.1`, `6.3.2`, `6.3.3`, `6.3.4`
		* added `Confluence 6.4.x`: `6.4.0`, `6.4.1`, `6.4.2`, `6.4.3`
		* added `Confluence 6.5.x`: `6.5.0`, `6.5.1`, `6.5.2`, `6.5.3`
		* added `Confluence 6.6.x`: `6.6.0`, `6.6.1`, `6.6.2`, `6.6.3`, `6.6.4`, `6.6.5`, `6.6.6`, `6.6.7`, `6.6.8`, `6.6.9`, `6.6.10`, `6.6.11`, `6.6.12`, `6.6.13`, `6.6.14`, `6.6.15`, `6.6.17`
		* added `Confluence 6.7.x`: `6.7.0`, `6.7.1`, `6.7.2`, `6.7.3`
		* added `Confluence 6.8.x`: `6.8.0`, `6.8.1`, `6.8.2`, `6.8.3`, `6.8.5`
		* added `Confluence 6.10.x`: `6.10.3`
		* added `Confluence 6.13.x`: `6.10.5`, `6.10.6`, `6.10.7`, `6.10.8`, `6.10.9`, `6.10.10`, 
		* added `Confluence 6.13.x`: `6.15.10`
		* added `Confluence 7.0.x`: `7.0.5`
		* added `Confluence 7.2.x`: `7.2.1`
	* `Atlassian` stack separated to 2 branches:
		* jdk8-based (default for all images)
		* jdk11-based for new images (by  special `-jdk11` tag)
	* optimized final containers which uses `devel` base
	* updated REAMDE.md
	* separated `nextcloud` to `latest`, `16`, `17`, `18` tags
	* `TeamCity Agent`:
		* switched back  to `jdk8`
 		* added to `TeamCity Agent` `atlassian adk` support
		* updated docker binary
		* moved back `valve` and `steam-runtime` in to image from `devel`
	* added `edge` image. 
		* switched `qbittorrent` images to `edge`
		* switched final `balancer` image to `edge`
	* reduced containers size by switching to `debian-slim` base-image.
* 12/13/2019
    * updated `teamcity agent`. added `php 7.3` support.
    * fixed `nginx` image.
    * removed `7.12.2` and `8.0.1` of Jira.
* 12/02/2019
    * updated `atlassian` stack.
* 11/28/2019
    * updated `atlassian` stack.
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
