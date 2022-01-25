VERSION             =  "2021.11.12"
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

	cd `pwd`/linux/advanced/zabbix/agent		  && pwd && make
	cd `pwd`/linux/advanced/zabbix/java-gateway   && pwd && make
	cd `pwd`/linux/advanced/zabbix/proxy		  && pwd && make
	cd `pwd`/linux/advanced/zabbix/server		 && pwd && make
	cd `pwd`/linux/advanced/zabbix/web			&& pwd && make

	cd `pwd`/linux/advanced/mattermost			&& pwd && make
	cd `pwd`/linux/advanced/nextcloud/pure/latest	  && pwd && make
	cd `pwd`/linux/advanced/nextcloud/patched/latest	  && pwd && make
	cd `pwd`/linux/advanced/teamcity/server	   && pwd && make
	cd `pwd`/linux/advanced/redash				&& pwd && make

	cd `pwd`/linux/advanced/nextcloud/pure/14		  && pwd && make
	cd `pwd`/linux/advanced/nextcloud/pure/15		  && pwd && make
	cd `pwd`/linux/advanced/nextcloud/pure/16		  && pwd && make
	cd `pwd`/linux/advanced/nextcloud/pure/17		  && pwd && make
	cd `pwd`/linux/advanced/nextcloud/pure/18		  && pwd && make
	cd `pwd`/linux/advanced/nextcloud/pure/19		  && pwd && make
	cd `pwd`/linux/advanced/nextcloud/pure/20		  && pwd && make
	cd `pwd`/linux/advanced/nextcloud/pure/21		  && pwd && make
	cd `pwd`/linux/advanced/nextcloud/pure/22		  && pwd && make

	cd `pwd`/linux/advanced/nextcloud/patched/14		  && pwd && make
	cd `pwd`/linux/advanced/nextcloud/patched/15		  && pwd && make
	cd `pwd`/linux/advanced/nextcloud/patched/16		  && pwd && make
	cd `pwd`/linux/advanced/nextcloud/patched/17		  && pwd && make
	cd `pwd`/linux/advanced/nextcloud/patched/18		  && pwd && make
	cd `pwd`/linux/advanced/nextcloud/patched/19		  && pwd && make
	cd `pwd`/linux/advanced/nextcloud/patched/20		  && pwd && make
	cd `pwd`/linux/advanced/nextcloud/patched/21		  && pwd && make
	cd `pwd`/linux/advanced/nextcloud/patched/22		  && pwd && make

ecosystem-images:
	@echo "======================================="
	@echo "===== Building  EpicMorg   images ====="
	@echo "======================================="

	cd `pwd`/linux/ecosystem/epicmorg/prod/main    && pwd && make
	cd `pwd`/linux/ecosystem/epicmorg/prod/jdk6    && pwd && make
	cd `pwd`/linux/ecosystem/epicmorg/prod/jdk7    && pwd && make
	cd `pwd`/linux/ecosystem/epicmorg/prod/jdk8    && pwd && make
	cd `pwd`/linux/ecosystem/epicmorg/prod/jdk11   && pwd && make
	cd `pwd`/linux/ecosystem/epicmorg/prod/jdk16   && pwd && make

	cd `pwd`/linux/ecosystem/epicmorg/edge/main    && pwd && make
	cd `pwd`/linux/ecosystem/epicmorg/edge/jdk6    && pwd && make
	cd `pwd`/linux/ecosystem/epicmorg/edge/jdk7    && pwd && make
	cd `pwd`/linux/ecosystem/epicmorg/edge/jdk8    && pwd && make
	cd `pwd`/linux/ecosystem/epicmorg/edge/jdk11   && pwd && make
	cd `pwd`/linux/ecosystem/epicmorg/edge/jdk16   && pwd && make

	cd `pwd`/linux/ecosystem/epicmorg/devel/main    && pwd && make
	cd `pwd`/linux/ecosystem/epicmorg/devel/jdk6    && pwd && make
	cd `pwd`/linux/ecosystem/epicmorg/devel/jdk7    && pwd && make
	cd `pwd`/linux/ecosystem/epicmorg/devel/jdk8    && pwd && make
	cd `pwd`/linux/ecosystem/epicmorg/devel/jdk11   && pwd && make
	cd `pwd`/linux/ecosystem/epicmorg/devel/jdk16   && pwd && make

	cd `pwd`/linux/ecosystem/php/latest             && pwd && make
	cd `pwd`/linux/ecosystem/php/php7.2             && pwd && make
	cd `pwd`/linux/ecosystem/php/php7.3             && pwd && make
	cd `pwd`/linux/ecosystem/php/php7.4             && pwd && make

	cd `pwd`/linux/ecosystem/apache2/latest         && pwd && make
	cd `pwd`/linux/ecosystem/apache2/php7.2         && pwd && make
	cd `pwd`/linux/ecosystem/apache2/php7.3         && pwd && make
	cd `pwd`/linux/ecosystem/apache2/php7.4         && pwd && make

	cd `pwd`/linux/ecosystem/testrail/latest       && pwd && make
	cd `pwd`/linux/ecosystem/testrail/ad           && pwd && make
	cd `pwd`/linux/ecosystem/testrail/ldap         && pwd && make
	
	cd `pwd`/linux/ecosystem/torrserver            && pwd && make

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

	cd `pwd`/linux/ecosystem/qbittorrent/latest    && pwd && make
	cd `pwd`/linux/ecosystem/qbittorrent/stable    && pwd && make

	cd `pwd`/linux/ecosystem/vk2discord     && pwd && make

	cd `pwd`/linux/ecosystem/teamcity/agent/latest         && pwd && make

	cd `pwd`/linux/ecosystem/teamcity/agent/amxx-sdk       && pwd && make
	cd `pwd`/linux/ecosystem/teamcity/agent/android-sdk    && pwd && make
	cd `pwd`/linux/ecosystem/teamcity/agent/atlassian-sdk  && pwd && make
	cd `pwd`/linux/ecosystem/teamcity/agent/dotnet-sdk     && pwd && make
	cd `pwd`/linux/ecosystem/teamcity/agent/node12         && pwd && make
	cd `pwd`/linux/ecosystem/teamcity/agent/node14         && pwd && make
	cd `pwd`/linux/ecosystem/teamcity/agent/node15         && pwd && make
	cd `pwd`/linux/ecosystem/teamcity/agent/node16         && pwd && make
	cd `pwd`/linux/ecosystem/teamcity/agent/php7.2         && pwd && make
	cd `pwd`/linux/ecosystem/teamcity/agent/php7.3         && pwd && make
	cd `pwd`/linux/ecosystem/teamcity/agent/php7.4         && pwd && make
	cd `pwd`/linux/ecosystem/teamcity/agent/steam-sdk      && pwd && make

	cd `pwd`/linux/ecosystem/nginx/latest/main      && pwd && make
	cd `pwd`/linux/ecosystem/nginx/latest/php       && pwd && make
	cd `pwd`/linux/ecosystem/nginx/latest/rtmp-hls  && pwd && make

	cd `pwd`/linux/advanced/vscode-server/latest         && pwd && make build && make deploy
	cd `pwd`/linux/advanced/vscode-server/devops         && pwd && make build && make deploy
	cd `pwd`/linux/advanced/vscode-server/amxx           && pwd && make build && make deploy
	cd `pwd`/linux/advanced/vscode-server/android        && pwd && make build && make deploy
	cd `pwd`/linux/advanced/vscode-server/cpp            && pwd && make build && make deploy
	cd `pwd`/linux/advanced/vscode-server/docker         && pwd && make build && make deploy
	cd `pwd`/linux/advanced/vscode-server/dotnet-full    && pwd && make build && make deploy
	cd `pwd`/linux/advanced/vscode-server/dotnet         && pwd && make build && make deploy
	cd `pwd`/linux/advanced/vscode-server/mono           && pwd && make build && make deploy
