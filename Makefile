VERSION             =  "2022.03.21"
AUTHOR              =  "EpicMorg"
MODIFIED            =  "AlexZ"
DOCKER_SCAN_SUGGEST = false

all: app

app:
	@make -s version
	@make -s help

version:
	@echo "=================================================="
	@echo " docker-scripts, version: ${VERSION}, [` git branch --show-current `]"
	@echo "=================================================="

help:
	@echo "make help                         - show this help."
	@echo "make version                      - show version of this repository."
	@echo "make docker-compose-install       - local install latest version of docker-compose binary."
	@echo "make docker-compose-update        - update local docker-compose binary."
	@echo "make docker-clean                 - cleanup docker kitchen."
	@echo "make chmod                        - find and fix chmod of '*.sh' and '*.py' files."
	@echo "make advanced-images              - build only advanced images."
	@echo "make ecosystem-images             - build ecosystem images."
	@echo "make images                       - build all images."

chmod:
	find . -name '*.sh' -type f | xargs chmod +x
	find . -name '*.py' -type f | xargs chmod +x

docker-compose-install: 
	@make -s docker-compose-update

docker-compose-update:
	@bash ./bin/docker-compose-update.sh

docker-clean:
	docker container prune -f
	docker image prune -f
	docker network prune -f
	docker volume prune -f
	docker system prune -af

images:
	make docker-clean
	make advanced-images
	make docker-clean
	make ecosystem-images
	make docker-clean

advanced-images:
	@echo "======================================="
	@echo "===== Building third-party images ====="
	@echo "======================================="
	make advanced-mattermost-images
	make advanced-nextcloud-latest-images
	make advanced-teamcity-server-images
	make advanced-redash-images
	make advanced-zabbix-images
	make advanced-nextcloud-images
	make advanced-nextcloud-patched-images

advanced-mattermost-images:
	cd `pwd`/linux/advanced/mattermost			&& pwd && make

advanced-nextcloud-latest-images:
	cd `pwd`/linux/advanced/nextcloud/pure/latest	  && pwd && make
	cd `pwd`/linux/advanced/nextcloud/patched/latest	  && pwd && make

advanced-teamcity-server-images:
	cd `pwd`/linux/advanced/teamcity/server	   && pwd && make

advanced-redash-images:
	cd `pwd`/linux/advanced/redash				&& pwd && make

advanced-zabbix-images:
	cd `pwd`/linux/advanced/zabbix/agent		  && pwd && make
	cd `pwd`/linux/advanced/zabbix/java-gateway   && pwd && make
	cd `pwd`/linux/advanced/zabbix/proxy		  && pwd && make
	cd `pwd`/linux/advanced/zabbix/server		 && pwd && make
	cd `pwd`/linux/advanced/zabbix/web			&& pwd && make

advanced-nextcloud-images:
	cd `pwd`/linux/advanced/nextcloud/pure/14		  && pwd && make
	cd `pwd`/linux/advanced/nextcloud/pure/15		  && pwd && make
	cd `pwd`/linux/advanced/nextcloud/pure/16		  && pwd && make
	cd `pwd`/linux/advanced/nextcloud/pure/17		  && pwd && make
	cd `pwd`/linux/advanced/nextcloud/pure/18		  && pwd && make
	cd `pwd`/linux/advanced/nextcloud/pure/19		  && pwd && make
	cd `pwd`/linux/advanced/nextcloud/pure/20		  && pwd && make
	cd `pwd`/linux/advanced/nextcloud/pure/21		  && pwd && make
	cd `pwd`/linux/advanced/nextcloud/pure/22		  && pwd && make
	cd `pwd`/linux/advanced/nextcloud/pure/23		  && pwd && make

advanced-nextcloud-patched-images:
	cd `pwd`/linux/advanced/nextcloud/patched/14		  && pwd && make
	cd `pwd`/linux/advanced/nextcloud/patched/15		  && pwd && make
	cd `pwd`/linux/advanced/nextcloud/patched/16		  && pwd && make
	cd `pwd`/linux/advanced/nextcloud/patched/17		  && pwd && make
	cd `pwd`/linux/advanced/nextcloud/patched/18		  && pwd && make
	cd `pwd`/linux/advanced/nextcloud/patched/19		  && pwd && make
	cd `pwd`/linux/advanced/nextcloud/patched/20		  && pwd && make
	cd `pwd`/linux/advanced/nextcloud/patched/21		  && pwd && make
	cd `pwd`/linux/advanced/nextcloud/patched/22		  && pwd && make
	cd `pwd`/linux/advanced/nextcloud/patched/23		  && pwd && make

ecosystem-images:
	make bundle-base-images
	make ecosystem-php-images
	make ecosystem-apache2-images
	make ecosystem-testrail-images
	make ecosystem-torrserver-images
	make ecosystem-nodejs-images
	make ecosystem-qbittorrent-images
	make ecosystem-vk2discord-images
	make ecosystem-postgres-images
	make ecosystem-teamcity-agent-images
	make ecosystem-nginx-images
	make ecosystem-vscode-server-images

ecosystem-debian-images:
	make ecosystem-debian-jessie-images
	make ecosystem-debian-stretch-images

ecosystem-debian-jessie-images:
	cd `pwd`/linux/ecosystem/epicmorg/debian/08-jessie/slim    && pwd && make
	cd `pwd`/linux/ecosystem/epicmorg/debian/08-jessie/main    && pwd && make
	cd `pwd`/linux/ecosystem/epicmorg/debian/08-jessie/jdk6    && pwd && make
	cd `pwd`/linux/ecosystem/epicmorg/debian/08-jessie/jdk7    && pwd && make
	cd `pwd`/linux/ecosystem/epicmorg/debian/08-jessie/jdk8    && pwd && make
	cd `pwd`/linux/ecosystem/epicmorg/debian/08-jessie/jdk11    && pwd && make
	cd `pwd`/linux/ecosystem/epicmorg/debian/08-jessie/jdk12    && pwd && make
	cd `pwd`/linux/ecosystem/epicmorg/debian/08-jessie/jdk13    && pwd && make
	cd `pwd`/linux/ecosystem/epicmorg/debian/08-jessie/jdk14    && pwd && make
	cd `pwd`/linux/ecosystem/epicmorg/debian/08-jessie/jdk15    && pwd && make
	cd `pwd`/linux/ecosystem/epicmorg/debian/08-jessie/jdk16    && pwd && make
	cd `pwd`/linux/ecosystem/epicmorg/debian/08-jessie/jdk17    && pwd && make
	cd `pwd`/linux/ecosystem/epicmorg/debian/08-jessie/jdk18    && pwd && make
	cd `pwd`/linux/ecosystem/epicmorg/debian/08-jessie/develop    && pwd && make

ecosystem-debian-stretch-images:
	cd `pwd`/linux/ecosystem/epicmorg/debian/09-stretch/slim    && pwd && make
	cd `pwd`/linux/ecosystem/epicmorg/debian/09-stretch/main    && pwd && make
	cd `pwd`/linux/ecosystem/epicmorg/debian/09-stretch/jdk6    && pwd && make
	cd `pwd`/linux/ecosystem/epicmorg/debian/09-stretch/jdk7    && pwd && make
	cd `pwd`/linux/ecosystem/epicmorg/debian/09-stretch/jdk8    && pwd && make
	cd `pwd`/linux/ecosystem/epicmorg/debian/09-stretch/jdk11    && pwd && make
	cd `pwd`/linux/ecosystem/epicmorg/debian/09-stretch/jdk12    && pwd && make
	cd `pwd`/linux/ecosystem/epicmorg/debian/09-stretch/jdk13    && pwd && make
	cd `pwd`/linux/ecosystem/epicmorg/debian/09-stretch/jdk14    && pwd && make
	cd `pwd`/linux/ecosystem/epicmorg/debian/09-stretch/jdk15    && pwd && make
	cd `pwd`/linux/ecosystem/epicmorg/debian/09-stretch/jdk16    && pwd && make
	cd `pwd`/linux/ecosystem/epicmorg/debian/09-stretch/jdk17    && pwd && make
	cd `pwd`/linux/ecosystem/epicmorg/debian/09-stretch/jdk18    && pwd && make
	cd `pwd`/linux/ecosystem/epicmorg/debian/09-stretch/develop    && pwd && make

ecosystem-debian-buster-images:
	cd `pwd`/linux/ecosystem/epicmorg/debian/10-buster/slim    && pwd && make
	cd `pwd`/linux/ecosystem/epicmorg/debian/10-buster/main    && pwd && make
	cd `pwd`/linux/ecosystem/epicmorg/debian/10-buster/jdk6    && pwd && make
	cd `pwd`/linux/ecosystem/epicmorg/debian/10-buster/jdk7    && pwd && make
	cd `pwd`/linux/ecosystem/epicmorg/debian/10-buster/jdk8    && pwd && make
	cd `pwd`/linux/ecosystem/epicmorg/debian/10-buster/jdk11    && pwd && make
	cd `pwd`/linux/ecosystem/epicmorg/debian/10-buster/jdk12    && pwd && make
	cd `pwd`/linux/ecosystem/epicmorg/debian/10-buster/jdk13    && pwd && make
	cd `pwd`/linux/ecosystem/epicmorg/debian/10-buster/jdk14    && pwd && make
	cd `pwd`/linux/ecosystem/epicmorg/debian/10-buster/jdk15    && pwd && make
	cd `pwd`/linux/ecosystem/epicmorg/debian/10-buster/jdk16    && pwd && make
	cd `pwd`/linux/ecosystem/epicmorg/debian/10-buster/jdk17    && pwd && make
	cd `pwd`/linux/ecosystem/epicmorg/debian/10-buster/jdk18    && pwd && make
	cd `pwd`/linux/ecosystem/epicmorg/debian/10-buster/develop    && pwd && make

ecosystem-php-images:
	cd `pwd`/linux/ecosystem/php/latest             && pwd && make
	cd `pwd`/linux/ecosystem/php/php7.2             && pwd && make
	cd `pwd`/linux/ecosystem/php/php7.3             && pwd && make
	cd `pwd`/linux/ecosystem/php/php7.4             && pwd && make
	cd `pwd`/linux/ecosystem/php/php8.0             && pwd && make

ecosystem-apache2-images:
	cd `pwd`/linux/ecosystem/apache2/latest         && pwd && make
	cd `pwd`/linux/ecosystem/apache2/php7.2         && pwd && make
	cd `pwd`/linux/ecosystem/apache2/php7.3         && pwd && make
	cd `pwd`/linux/ecosystem/apache2/php7.4         && pwd && make
	cd `pwd`/linux/ecosystem/apache2/php8.0         && pwd && make

ecosystem-testrail-images:
	cd `pwd`/linux/ecosystem/testrail/latest       && pwd && make
	cd `pwd`/linux/ecosystem/testrail/ad           && pwd && make
	cd `pwd`/linux/ecosystem/testrail/ldap         && pwd && make

ecosystem-torrserver-images:
	cd `pwd`/linux/ecosystem/torrserver            && pwd && make

ecosystem-electron-release-server-images:
	cd `pwd`/linux/ecosystem/electron-release-server  && pwd && make

ecosystem-nodejs-images: 
	cd `pwd`/linux/ecosystem/nodejs/current        && pwd && make
	cd `pwd`/linux/ecosystem/nodejs/lts            && pwd && make
	cd `pwd`/linux/ecosystem/nodejs/node10         && pwd && make
	cd `pwd`/linux/ecosystem/nodejs/node11         && pwd && make
	cd `pwd`/linux/ecosystem/nodejs/node12         && pwd && make
	cd `pwd`/linux/ecosystem/nodejs/node13         && pwd && make
	cd `pwd`/linux/ecosystem/nodejs/node14         && pwd && make
	cd `pwd`/linux/ecosystem/nodejs/node15         && pwd && make
	cd `pwd`/linux/ecosystem/nodejs/node16         && pwd && make
	cd `pwd`/linux/ecosystem/nodejs/node17         && pwd && make

ecosystem-vk2discord-images: 
	cd `pwd`/linux/ecosystem/vk2discord     && pwd && make

ecosystem-qbittorrent-images: 
	cd `pwd`/linux/ecosystem/qbittorrent/latest    && pwd && make
	cd `pwd`/linux/ecosystem/qbittorrent/stable    && pwd && make

ecosystem-postgres-images:
	cd `pwd`/linux/ecosystem/postgres/latest       && pwd && make
	cd `pwd`/linux/ecosystem/postgres/8.2          && pwd && make
	cd `pwd`/linux/ecosystem/postgres/8.3          && pwd && make
	cd `pwd`/linux/ecosystem/postgres/8.4          && pwd && make
	cd `pwd`/linux/ecosystem/postgres/9.0          && pwd && make
	cd `pwd`/linux/ecosystem/postgres/9.1          && pwd && make
	cd `pwd`/linux/ecosystem/postgres/9.2          && pwd && make
	cd `pwd`/linux/ecosystem/postgres/9.3          && pwd && make
	cd `pwd`/linux/ecosystem/postgres/9.4          && pwd && make
	cd `pwd`/linux/ecosystem/postgres/9.5          && pwd && make
	cd `pwd`/linux/ecosystem/postgres/9.6          && pwd && make
	cd `pwd`/linux/ecosystem/postgres/10           && pwd && make
	cd `pwd`/linux/ecosystem/postgres/11           && pwd && make
	cd `pwd`/linux/ecosystem/postgres/12           && pwd && make
	cd `pwd`/linux/ecosystem/postgres/13           && pwd && make
	cd `pwd`/linux/ecosystem/postgres/14           && pwd && make

ecosystem-teamcity-agent-images:
	cd `pwd`/linux/ecosystem/teamcity/agent/latest         && pwd && make
	cd `pwd`/linux/ecosystem/teamcity/agent/amxx-sdk       && pwd && make
	cd `pwd`/linux/ecosystem/teamcity/agent/android-sdk    && pwd && make
	cd `pwd`/linux/ecosystem/teamcity/agent/atlassian-sdk  && pwd && make
	cd `pwd`/linux/ecosystem/teamcity/agent/dotnet-sdk     && pwd && make
	cd `pwd`/linux/ecosystem/teamcity/agent/node12         && pwd && make
	cd `pwd`/linux/ecosystem/teamcity/agent/node14         && pwd && make
	cd `pwd`/linux/ecosystem/teamcity/agent/node15         && pwd && make
	cd `pwd`/linux/ecosystem/teamcity/agent/node16         && pwd && make
	cd `pwd`/linux/ecosystem/teamcity/agent/node17         && pwd && make
	cd `pwd`/linux/ecosystem/teamcity/agent/php7.2         && pwd && make
	cd `pwd`/linux/ecosystem/teamcity/agent/php7.3         && pwd && make
	cd `pwd`/linux/ecosystem/teamcity/agent/php7.4         && pwd && make
	cd `pwd`/linux/ecosystem/teamcity/agent/php8.0         && pwd && make
	cd `pwd`/linux/ecosystem/teamcity/agent/steam-sdk      && pwd && make

ecosystem-nginx-images:
	cd `pwd`/linux/ecosystem/nginx/latest/main      && pwd && make
	cd `pwd`/linux/ecosystem/nginx/latest/php       && pwd && make
	cd `pwd`/linux/ecosystem/nginx/latest/rtmp-hls  && pwd && make

ecosystem-vscode-server-images:
	cd `pwd`/linux/advanced/vscode-server/latest         && pwd && make build && make deploy
	cd `pwd`/linux/advanced/vscode-server/devops         && pwd && make build && make deploy
	cd `pwd`/linux/advanced/vscode-server/amxx           && pwd && make build && make deploy
	cd `pwd`/linux/advanced/vscode-server/android        && pwd && make build && make deploy
	cd `pwd`/linux/advanced/vscode-server/cpp            && pwd && make build && make deploy
	cd `pwd`/linux/advanced/vscode-server/docker         && pwd && make build && make deploy
	cd `pwd`/linux/advanced/vscode-server/dotnet-full    && pwd && make build && make deploy
	cd `pwd`/linux/advanced/vscode-server/dotnet         && pwd && make build && make deploy
	cd `pwd`/linux/advanced/vscode-server/mono           && pwd && make build && make deploy

bundle-base-images:
	@echo "======================================="
	@echo "===== Building  EpicMorg   images ====="
	@echo "======================================="
	make ecosystem-prod-images
	make ecosystem-edge-images
	make ecosystem-devel-images

bundle-teamcity:
	@echo "======================================="
	@echo "===== Building  TeamCity   images ====="
	@echo "======================================="
	make advanced-teamcity-server-images
	make ecosystem-teamcity-agent-images

bundle-atlassian:
	@echo "======================================="
	@echo "===== Building  Atlassian  images ====="
	@echo "======================================="
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/latest           && pwd && make
	cd `pwd`/linux/ecosystem/atlassian/confluence/latest          && pwd && make
	cd `pwd`/linux/ecosystem/atlassian/crucible/latest            && pwd && make
	cd `pwd`/linux/ecosystem/atlassian/fisheye/latest             && pwd && make
	cd `pwd`/linux/ecosystem/atlassian/fisheye-crucible/latest    && pwd && make
	cd `pwd`/linux/ecosystem/atlassian/jira/latest                && pwd && make

bundle-web:
	@echo "======================================="
	@echo "=====   Building    web    images ====="
	@echo "======================================="
	make ecosystem-php-images
	make ecosystem-apache2-images
	make ecosystem-nginx-images
	