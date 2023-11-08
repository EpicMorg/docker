VERSION             =  "2023.06.08"
AUTHOR              =  "EpicMorg"
MODIFIED            =  "STAM"
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

git:
	git add .
	git commit -am "make - autocommit"
	git push

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
	make advanced-images
	make ecosystem-images
#	make docker-clean
#	make docker-clean

advanced-images:
	@echo "======================================="
	@echo "===== Building third-party images ====="
	@echo "======================================="
#	make advanced-redash-images
	make advanced-mattermost-images
	make advanced-nextcloud-latest-images
	make advanced-teamcity-server-images
	make advanced-zabbix-images
	make advanced-nextcloud-images
	make advanced-nextcloud-patched-images

advanced-mattermost-images:
	cd `pwd`/linux/advanced/mattermost			&& pwd && make build && make deploy

advanced-nextcloud-latest-images:
	cd `pwd`/linux/advanced/nextcloud/pure/latest	  && pwd && make build && make deploy
	cd `pwd`/linux/advanced/nextcloud/patched/latest	  && pwd && make build && make deploy

advanced-teamcity-server-images:
	cd `pwd`/linux/advanced/teamcity/server	   && pwd && make build && make deploy

advanced-redash-images:
	cd `pwd`/linux/advanced/redash				&& pwd && make sync &&  make patch &&  make build && make deploy

advanced-sentry-images:
	cd `pwd`/linux/advanced/sentry/latest				&& pwd && make sync &&  make patch &&  make build && make deploy

advanced-zabbix-images:
	cd `pwd`/linux/advanced/zabbix/latest/agent		      && pwd && make build && make deploy
	cd `pwd`/linux/advanced/zabbix/latest/agent2		    && pwd && make build && make deploy
	cd `pwd`/linux/advanced/zabbix/latest/java-gateway  && pwd && make build && make deploy
	cd `pwd`/linux/advanced/zabbix/latest/proxy-mysql		&& pwd && make build && make deploy
	cd `pwd`/linux/advanced/zabbix/latest/proxy-sqlite3	&& pwd && make build && make deploy
	cd `pwd`/linux/advanced/zabbix/latest/server-mysql	&& pwd && make build && make deploy
	cd `pwd`/linux/advanced/zabbix/latest/server-pgsql	&& pwd && make build && make deploy
	cd `pwd`/linux/advanced/zabbix/latest/snmptraps			&& pwd && make build && make deploy
	cd `pwd`/linux/advanced/zabbix/latest/web-mysql			&& pwd && make build && make deploy
	cd `pwd`/linux/advanced/zabbix/latest/web-pgsql			&& pwd && make build && make deploy
	cd `pwd`/linux/advanced/zabbix/3.0/agent		      && pwd && make build && make deploy 
	cd `pwd`/linux/advanced/zabbix/3.0/java-gateway   && pwd && make build && make deploy
	cd `pwd`/linux/advanced/zabbix/3.0/proxy-mysql		&& pwd && make build && make deploy
	cd `pwd`/linux/advanced/zabbix/3.0/proxy-sqlite3	&& pwd && make build && make deploy
	cd `pwd`/linux/advanced/zabbix/3.0/server-mysql 	&& pwd && make build && make deploy
	cd `pwd`/linux/advanced/zabbix/3.0/server-pgsql 	&& pwd && make build && make deploy
	cd `pwd`/linux/advanced/zabbix/3.0/snmptraps			&& pwd && make build && make deploy
	cd `pwd`/linux/advanced/zabbix/3.0/web-mysql			&& pwd && make build && make deploy
	cd `pwd`/linux/advanced/zabbix/3.0/web-pgsql			&& pwd && make build && make deploy
	cd `pwd`/linux/advanced/zabbix/4.0/agent		      && pwd && make build && make deploy
	cd `pwd`/linux/advanced/zabbix/4.0/java-gateway   && pwd && make build && make deploy
	cd `pwd`/linux/advanced/zabbix/4.0/proxy-mysql		&& pwd && make build && make deploy
	cd `pwd`/linux/advanced/zabbix/4.0/proxy-sqlite3	&& pwd && make build && make deploy
	cd `pwd`/linux/advanced/zabbix/4.0/server-mysql	  && pwd && make build && make deploy
	cd `pwd`/linux/advanced/zabbix/4.0/server-pgsql	  && pwd && make build && make deploy
	cd `pwd`/linux/advanced/zabbix/4.0/snmptraps			&& pwd && make build && make deploy
	cd `pwd`/linux/advanced/zabbix/4.0/web-mysql			&& pwd && make build && make deploy
	cd `pwd`/linux/advanced/zabbix/4.0/web-pgsql			&& pwd && make build && make deploy
	cd `pwd`/linux/advanced/zabbix/5.0/agent		      && pwd && make build && make deploy
	cd `pwd`/linux/advanced/zabbix/5.0/agent2		      && pwd && make build && make deploy
	cd `pwd`/linux/advanced/zabbix/5.0/java-gateway   && pwd && make build && make deploy
	cd `pwd`/linux/advanced/zabbix/5.0/proxy-mysql		&& pwd && make build && make deploy
	cd `pwd`/linux/advanced/zabbix/5.0/proxy-sqlite3	&& pwd && make build && make deploy
	cd `pwd`/linux/advanced/zabbix/5.0/server-mysql   && pwd && make build && make deploy
	cd `pwd`/linux/advanced/zabbix/5.0/server-pgsql	  && pwd && make build && make deploy
	cd `pwd`/linux/advanced/zabbix/5.0/snmptraps			&& pwd && make build && make deploy
	cd `pwd`/linux/advanced/zabbix/5.0/web-mysql			&& pwd && make build && make deploy
	cd `pwd`/linux/advanced/zabbix/5.0/web-pgsql			&& pwd && make build && make deploy
	cd `pwd`/linux/advanced/zabbix/5.2/agent		      && pwd && make build && make deploy
	cd `pwd`/linux/advanced/zabbix/5.2/agent2		      && pwd && make build && make deploy
	cd `pwd`/linux/advanced/zabbix/5.2/java-gateway   && pwd && make build && make deploy
	cd `pwd`/linux/advanced/zabbix/5.2/proxy-mysql		&& pwd && make build && make deploy
	cd `pwd`/linux/advanced/zabbix/5.2/proxy-sqlite3	&& pwd && make build && make deploy
	cd `pwd`/linux/advanced/zabbix/5.2/server-mysql	  && pwd && make build && make deploy
	cd `pwd`/linux/advanced/zabbix/5.2/server-pgsql  	&& pwd && make build && make deploy
	cd `pwd`/linux/advanced/zabbix/5.2/snmptraps			&& pwd && make build && make deploy
	cd `pwd`/linux/advanced/zabbix/5.2/web-mysql			&& pwd && make build && make deploy
	cd `pwd`/linux/advanced/zabbix/5.2/web-pgsql			&& pwd && make build && make deploy
	cd `pwd`/linux/advanced/zabbix/5.4/agent		      && pwd && make build && make deploy
	cd `pwd`/linux/advanced/zabbix/5.4/agent2		      && pwd && make build && make deploy
	cd `pwd`/linux/advanced/zabbix/5.4/java-gateway   && pwd && make build && make deploy
	cd `pwd`/linux/advanced/zabbix/5.4/proxy-mysql		&& pwd && make build && make deploy
	cd `pwd`/linux/advanced/zabbix/5.4/proxy-sqlite3	&& pwd && make build && make deploy
	cd `pwd`/linux/advanced/zabbix/5.4/server-mysql	  && pwd && make build && make deploy
	cd `pwd`/linux/advanced/zabbix/5.4/server-pgsql	  && pwd && make build && make deploy
	cd `pwd`/linux/advanced/zabbix/5.4/snmptraps			&& pwd && make build && make deploy
	cd `pwd`/linux/advanced/zabbix/5.4/web-mysql			&& pwd && make build && make deploy
	cd `pwd`/linux/advanced/zabbix/5.4/web-pgsql			&& pwd && make build && make deploy
	cd `pwd`/linux/advanced/zabbix/6.0/agent		      && pwd && make build && make deploy
	cd `pwd`/linux/advanced/zabbix/6.0/agent2		      && pwd && make build && make deploy
	cd `pwd`/linux/advanced/zabbix/6.0/java-gateway   && pwd && make build && make deploy
	cd `pwd`/linux/advanced/zabbix/6.0/proxy-mysql		&& pwd && make build && make deploy
	cd `pwd`/linux/advanced/zabbix/6.0/proxy-sqlite3	&& pwd && make build && make deploy
	cd `pwd`/linux/advanced/zabbix/6.0/server-mysql	  && pwd && make build && make deploy
	cd `pwd`/linux/advanced/zabbix/6.0/server-pgsql   && pwd && make build && make deploy
	cd `pwd`/linux/advanced/zabbix/6.0/snmptraps			&& pwd && make build && make deploy
	cd `pwd`/linux/advanced/zabbix/6.0/web-mysql			&& pwd && make build && make deploy
	cd `pwd`/linux/advanced/zabbix/6.0/web-pgsql			&& pwd && make build && make deploy
	cd `pwd`/linux/advanced/zabbix/6.2/agent		      && pwd && make build && make deploy
	cd `pwd`/linux/advanced/zabbix/6.2/agent2 		    && pwd && make build && make deploy
	cd `pwd`/linux/advanced/zabbix/6.2/java-gateway   && pwd && make build && make deploy
	cd `pwd`/linux/advanced/zabbix/6.2/proxy-mysql		&& pwd && make build && make deploy
	cd `pwd`/linux/advanced/zabbix/6.2/proxy-sqlite3	&& pwd && make build && make deploy
	cd `pwd`/linux/advanced/zabbix/6.2/server-mysql 	&& pwd && make build && make deploy
	cd `pwd`/linux/advanced/zabbix/6.2/server-pgsql 	&& pwd && make build && make deploy
	cd `pwd`/linux/advanced/zabbix/6.2/snmptraps			&& pwd && make build && make deploy
	cd `pwd`/linux/advanced/zabbix/6.2/web-mysql			&& pwd && make build && make deploy
	cd `pwd`/linux/advanced/zabbix/6.2/web-pgsql			&& pwd && make build && make deploy
	cd `pwd`/linux/advanced/zabbix/6.4/agent		      && pwd && make build && make deploy
	cd `pwd`/linux/advanced/zabbix/6.4/agent2 		    && pwd && make build && make deploy
	cd `pwd`/linux/advanced/zabbix/6.4/java-gateway   && pwd && make build && make deploy
	cd `pwd`/linux/advanced/zabbix/6.4/proxy-mysql		&& pwd && make build && make deploy
	cd `pwd`/linux/advanced/zabbix/6.4/proxy-sqlite3	&& pwd && make build && make deploy
	cd `pwd`/linux/advanced/zabbix/6.4/server-mysql 	&& pwd && make build && make deploy
	cd `pwd`/linux/advanced/zabbix/6.4/server-pgsql 	&& pwd && make build && make deploy
	cd `pwd`/linux/advanced/zabbix/6.4/snmptraps			&& pwd && make build && make deploy
	cd `pwd`/linux/advanced/zabbix/6.4/web-mysql			&& pwd && make build && make deploy
	cd `pwd`/linux/advanced/zabbix/6.4/web-pgsql			&& pwd && make build && make deploy
	cd `pwd`/linux/advanced/zabbix/trunk/agent		      && pwd && make build && make deploy
	cd `pwd`/linux/advanced/zabbix/trunk/agent2 		    && pwd && make build && make deploy
	cd `pwd`/linux/advanced/zabbix/trunk/java-gateway   && pwd && make build && make deploy
	cd `pwd`/linux/advanced/zabbix/trunk/proxy-mysql		&& pwd && make build && make deploy
	cd `pwd`/linux/advanced/zabbix/trunk/proxy-sqlite3	&& pwd && make build && make deploy
	cd `pwd`/linux/advanced/zabbix/trunk/server-mysql 	&& pwd && make build && make deploy
	cd `pwd`/linux/advanced/zabbix/trunk/server-pgsql 	&& pwd && make build && make deploy
	cd `pwd`/linux/advanced/zabbix/trunk/snmptraps			&& pwd && make build && make deploy
	cd `pwd`/linux/advanced/zabbix/trunk/web-mysql			&& pwd && make build && make deploy
	cd `pwd`/linux/advanced/zabbix/trunk/web-pgsql			&& pwd && make build && make deploy

advanced-nextcloud-images:
	cd `pwd`/linux/advanced/nextcloud/pure/14		  && pwd && make build && make deploy
	cd `pwd`/linux/advanced/nextcloud/pure/15		  && pwd && make build && make deploy
	cd `pwd`/linux/advanced/nextcloud/pure/16		  && pwd && make build && make deploy
	cd `pwd`/linux/advanced/nextcloud/pure/17		  && pwd && make build && make deploy
	cd `pwd`/linux/advanced/nextcloud/pure/18		  && pwd && make build && make deploy
	cd `pwd`/linux/advanced/nextcloud/pure/19		  && pwd && make build && make deploy
	cd `pwd`/linux/advanced/nextcloud/pure/20		  && pwd && make build && make deploy
	cd `pwd`/linux/advanced/nextcloud/pure/21		  && pwd && make build && make deploy
	cd `pwd`/linux/advanced/nextcloud/pure/22		  && pwd && make build && make deploy
	cd `pwd`/linux/advanced/nextcloud/pure/23		  && pwd && make build && make deploy
	cd `pwd`/linux/advanced/nextcloud/pure/24		  && pwd && make build && make deploy
	cd `pwd`/linux/advanced/nextcloud/pure/25		  && pwd && make build && make deploy
	cd `pwd`/linux/advanced/nextcloud/pure/26		  && pwd && make build && make deploy

advanced-nextcloud-patched-images:
	cd `pwd`/linux/advanced/nextcloud/patched/14		  && pwd && make build && make deploy
	cd `pwd`/linux/advanced/nextcloud/patched/15		  && pwd && make build && make deploy
	cd `pwd`/linux/advanced/nextcloud/patched/16		  && pwd && make build && make deploy
	cd `pwd`/linux/advanced/nextcloud/patched/17		  && pwd && make build && make deploy
	cd `pwd`/linux/advanced/nextcloud/patched/18		  && pwd && make build && make deploy
	cd `pwd`/linux/advanced/nextcloud/patched/19		  && pwd && make build && make deploy
	cd `pwd`/linux/advanced/nextcloud/patched/20		  && pwd && make build && make deploy
	cd `pwd`/linux/advanced/nextcloud/patched/21		  && pwd && make build && make deploy
	cd `pwd`/linux/advanced/nextcloud/patched/22		  && pwd && make build && make deploy
	cd `pwd`/linux/advanced/nextcloud/patched/23		  && pwd && make build && make deploy
	cd `pwd`/linux/advanced/nextcloud/patched/24		  && pwd && make build && make deploy
	cd `pwd`/linux/advanced/nextcloud/patched/25		  && pwd && make build && make deploy
	cd `pwd`/linux/advanced/nextcloud/patched/26		  && pwd && make build && make deploy

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
	make ecosystem-gitlab-runner-images
	make ecosystem-nginx-images
	make ecosystem-vscode-server-images
	make ecosystem-ninjam-image

advanced-pyhton-images:
	make advanced-pyhton-images-main
	make advanced-pyhton-images-develop

advanced-pyhton-images-main:
	cd `pwd`/linux/advanced/python/main/2.7 && pwd && make build && make deploy
	cd `pwd`/linux/advanced/python/main/3.6 && pwd && make build && make deploy
	cd `pwd`/linux/advanced/python/main/3.7 && pwd && make build && make deploy
	cd `pwd`/linux/advanced/python/main/3.8 && pwd && make build && make deploy
	cd `pwd`/linux/advanced/python/main/3.9 && pwd && make build && make deploy
	cd `pwd`/linux/advanced/python/main/3.10 && pwd && make build && make deploy
	cd `pwd`/linux/advanced/python/main/3.11 && pwd && make build && make deploy
	cd `pwd`/linux/advanced/python/main/3.12 && pwd && make build && make deploy

advanced-pyhton-images-develop:
	cd `pwd`/linux/advanced/python/develop/2.7 && pwd && make build && make deploy
	cd `pwd`/linux/advanced/python/develop/3.6 && pwd && make build && make deploy
	cd `pwd`/linux/advanced/python/develop/3.7 && pwd && make build && make deploy
	cd `pwd`/linux/advanced/python/develop/3.8 && pwd && make build && make deploy
	cd `pwd`/linux/advanced/python/develop/3.9 && pwd && make build && make deploy
	cd `pwd`/linux/advanced/python/develop/3.10 && pwd && make build && make deploy
	cd `pwd`/linux/advanced/python/develop/3.11 && pwd && make build && make deploy
	cd `pwd`/linux/advanced/python/develop/3.12 && pwd && make build && make deploy

ecosystem-debian-images:
	make ecosystem-debian-squeeze-images
	make ecosystem-debian-wheezy-images
	make ecosystem-debian-jessie-images
	make ecosystem-debian-stretch-images
	make ecosystem-debian-buster-images
	make ecosystem-debian-bullseye-images
	make ecosystem-debian-bookworm-images

ecosystem-debian-squeeze-images:
	cd `pwd`/linux/ecosystem/epicmorg/debian/06-squeeze/slim    && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/epicmorg/debian/06-squeeze/main    && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/epicmorg/debian/06-squeeze/develop    && pwd && make build && make deploy

ecosystem-debian-wheezy-images:
	cd `pwd`/linux/ecosystem/epicmorg/debian/07-wheezy/slim    && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/epicmorg/debian/07-wheezy/main    && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/epicmorg/debian/07-wheezy/develop    && pwd && make build && make deploy

ecosystem-debian-jessie-images:
	cd `pwd`/linux/ecosystem/epicmorg/debian/08-jessie/slim    && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/epicmorg/debian/08-jessie/main    && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/epicmorg/debian/08-jessie/develop    && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/epicmorg/debian/08-jessie/jdk6    && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/epicmorg/debian/08-jessie/jdk7    && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/epicmorg/debian/08-jessie/jdk8    && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/epicmorg/debian/08-jessie/jdk11    && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/epicmorg/debian/08-jessie/jdk17    && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/epicmorg/debian/08-jessie/jdk18    && pwd && make build && make deploy

ecosystem-debian-stretch-images:
	cd `pwd`/linux/ecosystem/epicmorg/debian/09-stretch/slim    && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/epicmorg/debian/09-stretch/main    && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/epicmorg/debian/09-stretch/develop    && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/epicmorg/debian/09-stretch/jdk6    && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/epicmorg/debian/09-stretch/jdk7    && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/epicmorg/debian/09-stretch/jdk8    && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/epicmorg/debian/09-stretch/jdk11    && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/epicmorg/debian/09-stretch/jdk17    && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/epicmorg/debian/09-stretch/jdk18    && pwd && make build && make deploy

ecosystem-debian-buster-images:
	cd `pwd`/linux/ecosystem/epicmorg/debian/10-buster/slim    && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/epicmorg/debian/10-buster/main    && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/epicmorg/debian/10-buster/develop    && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/epicmorg/debian/10-buster/jdk6    && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/epicmorg/debian/10-buster/jdk7    && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/epicmorg/debian/10-buster/jdk8    && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/epicmorg/debian/10-buster/jdk11    && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/epicmorg/debian/10-buster/jdk17    && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/epicmorg/debian/10-buster/jdk18    && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/epicmorg/debian/10-buster/jdk19    && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/epicmorg/debian/10-buster/jdk20    && pwd && make build && make deploy

ecosystem-debian-bullseye-images:
	cd `pwd`/linux/ecosystem/epicmorg/debian/11-bullseye/slim    && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/epicmorg/debian/11-bullseye/main    && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/epicmorg/debian/11-bullseye/develop    && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/epicmorg/debian/11-bullseye/jdk6    && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/epicmorg/debian/11-bullseye/jdk7    && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/epicmorg/debian/11-bullseye/jdk8    && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/epicmorg/debian/11-bullseye/jdk11    && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/epicmorg/debian/11-bullseye/jdk17    && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/epicmorg/debian/11-bullseye/jdk18    && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/epicmorg/debian/11-bullseye/jdk19    && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/epicmorg/debian/11-bullseye/jdk20    && pwd && make build && make deploy

ecosystem-debian-bookworm-images:
	cd `pwd`/linux/ecosystem/epicmorg/debian/12-bookworm/slim    && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/epicmorg/debian/12-bookworm/main    && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/epicmorg/debian/12-bookworm/develop    && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/epicmorg/debian/12-bookworm/jdk6    && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/epicmorg/debian/12-bookworm/jdk7    && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/epicmorg/debian/12-bookworm/jdk8    && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/epicmorg/debian/12-bookworm/jdk11    && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/epicmorg/debian/12-bookworm/jdk17    && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/epicmorg/debian/12-bookworm/jdk18    && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/epicmorg/debian/12-bookworm/jdk19    && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/epicmorg/debian/12-bookworm/jdk20    && pwd && make build && make deploy

ecosystem-php-images:
	cd `pwd`/linux/ecosystem/php/php7.0             && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/php/php7.1             && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/php/php7.2             && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/php/php7.3             && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/php/php7.4             && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/php/php8.0             && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/php/php8.1             && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/php/php8.2             && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/php/php8.3             && pwd && make build && make deploy

ecosystem-apache2-images:
	cd `pwd`/linux/ecosystem/apache2/php7.0         && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/apache2/php7.1         && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/apache2/php7.2         && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/apache2/php7.3         && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/apache2/php7.4         && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/apache2/php8.0         && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/apache2/php8.1         && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/apache2/php8.2         && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/apache2/php8.3         && pwd && make build && make deploy

ecosystem-testrail-images:
	cd `pwd`/linux/ecosystem/cassandra/3.11       && pwd && make build && make deploy

	cd `pwd`/linux/ecosystem/testrail/5.4.1.3669/main       && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/testrail/5.5.0.3727/main       && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/testrail/5.5.0.3731/main       && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/testrail/5.5.0.3735/main       && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/testrail/5.5.1.3746/main       && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/testrail/5.6.0.3853/main       && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/testrail/5.6.0.3856/main       && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/testrail/5.6.0.3861/main       && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/testrail/5.6.0.3862/main       && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/testrail/5.6.0.3865/main       && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/testrail/5.7.0.3938/main       && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/testrail/5.7.0.3942/main       && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/testrail/5.7.0.3951/main       && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/testrail/5.7.1.4026/main       && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/testrail/5.7.1.4028/main       && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/testrail/6.0.0.4140/main       && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/testrail/6.0.1.4163/main       && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/testrail/6.1.0.4367/main       && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/testrail/6.1.0.4369/main       && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/testrail/6.1.1.1020/main       && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/testrail/6.1.1.1021/main       && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/testrail/6.2.0.1085/main       && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/testrail/6.2.1.1003/main       && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/testrail/6.2.1.1005/main       && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/testrail/6.2.2.1107/main       && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/testrail/6.2.3.1114/main       && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/testrail/6.3.0.1120/main       && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/testrail/6.3.1.1004/main       && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/testrail/6.3.1.1006/main       && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/testrail/6.4.0.1284/main       && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/testrail/6.4.0.1293/main       && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/testrail/6.5.0.1298/main       && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/testrail/6.5.1.1002/main       && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/testrail/6.5.3.1001/main       && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/testrail/6.5.4.1002/main       && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/testrail/6.5.4.1007/main       && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/testrail/6.5.5.1009/main       && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/testrail/6.5.6.1014/main       && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/testrail/6.5.7.1000/main       && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/testrail/6.6.0.1156/main       && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/testrail/6.6.1.1166/main       && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/testrail/6.7.1.1020/main       && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/testrail/6.7.2.1037/main       && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/testrail/6.7.2.1043/main       && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/testrail/7.0.0.1057/main       && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/testrail/7.0.1.1002/main       && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/testrail/7.0.1.1013/main       && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/testrail/7.0.2.1014/main       && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/testrail/7.0.2.1015/main       && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/testrail/7.0.2.1016/main       && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/testrail/7.4.1.8079/main       && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/testrail/7.4.1.8091/main       && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/testrail/7.4.1.8092/main       && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/testrail/7.5.1.7010/main       && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/testrail/7.5.1.7012/main       && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/testrail/7.5.1.7013/main       && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/testrail/7.5.2.1002/main       && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/testrail/7.5.3.1000/main       && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/testrail/8.0.0.1089/main       && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/testrail/8.0.1.1029/main       && pwd && make build && make deploy

	cd `pwd`/linux/ecosystem/testrail/5.4.1.3669/ad           && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/testrail/5.5.0.3727/ad           && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/testrail/5.5.0.3731/ad           && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/testrail/5.5.0.3735/ad           && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/testrail/5.5.1.3746/ad           && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/testrail/5.6.0.3853/ad           && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/testrail/5.6.0.3856/ad           && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/testrail/5.6.0.3861/ad           && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/testrail/5.6.0.3862/ad           && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/testrail/5.6.0.3865/ad           && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/testrail/5.7.0.3938/ad           && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/testrail/5.7.0.3942/ad           && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/testrail/5.7.0.3951/ad           && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/testrail/5.7.1.4026/ad           && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/testrail/5.7.1.4028/ad           && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/testrail/6.0.0.4140/ad           && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/testrail/6.0.1.4163/ad           && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/testrail/6.1.0.4367/ad           && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/testrail/6.1.0.4369/ad           && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/testrail/6.1.1.1020/ad           && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/testrail/6.1.1.1021/ad           && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/testrail/6.2.0.1085/ad           && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/testrail/6.2.1.1003/ad           && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/testrail/6.2.1.1005/ad           && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/testrail/6.2.2.1107/ad           && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/testrail/6.2.3.1114/ad           && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/testrail/6.3.0.1120/ad           && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/testrail/6.3.1.1004/ad           && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/testrail/6.3.1.1006/ad           && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/testrail/6.4.0.1284/ad           && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/testrail/6.4.0.1293/ad           && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/testrail/6.5.0.1298/ad           && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/testrail/6.5.1.1002/ad           && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/testrail/6.5.3.1001/ad           && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/testrail/6.5.4.1002/ad           && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/testrail/6.5.4.1007/ad           && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/testrail/6.5.5.1009/ad           && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/testrail/6.5.6.1014/ad           && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/testrail/6.5.7.1000/ad           && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/testrail/6.6.0.1156/ad           && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/testrail/6.6.1.1166/ad           && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/testrail/6.7.1.1020/ad           && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/testrail/6.7.2.1037/ad           && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/testrail/6.7.2.1043/ad           && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/testrail/7.0.0.1057/ad           && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/testrail/7.0.1.1002/ad           && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/testrail/7.0.1.1013/ad           && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/testrail/7.0.2.1014/ad           && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/testrail/7.0.2.1015/ad           && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/testrail/7.0.2.1016/ad           && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/testrail/7.4.1.8079/ad           && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/testrail/7.4.1.8091/ad           && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/testrail/7.4.1.8092/ad           && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/testrail/7.5.1.7010/ad           && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/testrail/7.5.1.7012/ad           && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/testrail/7.5.1.7013/ad           && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/testrail/7.5.2.1002/ad           && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/testrail/7.5.3.1000/ad           && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/testrail/8.0.0.1089/ad           && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/testrail/8.0.1.1029/ad           && pwd && make build && make deploy
    
	cd `pwd`/linux/ecosystem/testrail/5.4.1.3669/ldap         && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/testrail/5.5.0.3727/ldap         && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/testrail/5.5.0.3731/ldap         && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/testrail/5.5.0.3735/ldap         && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/testrail/5.5.1.3746/ldap         && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/testrail/5.6.0.3853/ldap         && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/testrail/5.6.0.3856/ldap         && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/testrail/5.6.0.3861/ldap         && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/testrail/5.6.0.3862/ldap         && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/testrail/5.6.0.3865/ldap         && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/testrail/5.7.0.3938/ldap         && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/testrail/5.7.0.3942/ldap         && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/testrail/5.7.0.3951/ldap         && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/testrail/5.7.1.4026/ldap         && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/testrail/5.7.1.4028/ldap         && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/testrail/6.0.0.4140/ldap         && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/testrail/6.0.1.4163/ldap         && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/testrail/6.1.0.4367/ldap         && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/testrail/6.1.0.4369/ldap         && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/testrail/6.1.1.1020/ldap         && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/testrail/6.1.1.1021/ldap         && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/testrail/6.2.0.1085/ldap         && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/testrail/6.2.1.1003/ldap         && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/testrail/6.2.1.1005/ldap         && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/testrail/6.2.2.1107/ldap         && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/testrail/6.2.3.1114/ldap         && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/testrail/6.3.0.1120/ldap         && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/testrail/6.3.1.1004/ldap         && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/testrail/6.3.1.1006/ldap         && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/testrail/6.4.0.1284/ldap         && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/testrail/6.4.0.1293/ldap         && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/testrail/6.5.0.1298/ldap         && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/testrail/6.5.1.1002/ldap         && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/testrail/6.5.3.1001/ldap         && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/testrail/6.5.4.1002/ldap         && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/testrail/6.5.4.1007/ldap         && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/testrail/6.5.5.1009/ldap         && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/testrail/6.5.6.1014/ldap         && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/testrail/6.5.7.1000/ldap         && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/testrail/6.6.0.1156/ldap         && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/testrail/6.6.1.1166/ldap         && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/testrail/6.7.1.1020/ldap         && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/testrail/6.7.2.1037/ldap         && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/testrail/6.7.2.1043/ldap         && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/testrail/7.0.0.1057/ldap         && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/testrail/7.0.1.1002/ldap         && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/testrail/7.0.1.1013/ldap         && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/testrail/7.0.2.1014/ldap         && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/testrail/7.0.2.1015/ldap         && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/testrail/7.0.2.1016/ldap         && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/testrail/7.4.1.8079/ldap         && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/testrail/7.4.1.8091/ldap         && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/testrail/7.4.1.8092/ldap         && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/testrail/7.5.1.7010/ldap         && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/testrail/7.5.1.7012/ldap         && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/testrail/7.5.1.7013/ldap         && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/testrail/7.5.2.1002/ldap         && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/testrail/7.5.3.1000/ldap         && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/testrail/8.0.0.1089/ldap         && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/testrail/8.0.1.1029/ldap         && pwd && make build && make deploy


ecosystem-torrserver-images:
	cd `pwd`/linux/ecosystem/torrserver            && pwd && make build && make deploy

ecosystem-electron-release-server-images:
	cd `pwd`/linux/ecosystem/electron-release-server  && pwd && make build && make deploy

ecosystem-nodejs-images: 
	cd `pwd`/linux/ecosystem/nodejs/current        && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/nodejs/lts            && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/nodejs/node4          && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/nodejs/node6          && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/nodejs/node8          && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/nodejs/node10         && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/nodejs/node11         && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/nodejs/node12         && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/nodejs/node13         && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/nodejs/node14         && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/nodejs/node15         && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/nodejs/node16         && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/nodejs/node17         && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/nodejs/node18         && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/nodejs/node19         && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/nodejs/node20         && pwd && make build && make deploy

ecosystem-ninjam-image: 
	cd `pwd`/linux/ecosystem/ninjam/latest     && pwd && make build && make deploy

ecosystem-vk2discord-images: 
	cd `pwd`/linux/ecosystem/vk2discord     && pwd && make build && make deploy

ecosystem-qbittorrent-images: 
	cd `pwd`/linux/ecosystem/qbittorrent    && pwd && make build && make deploy

ecosystem-retracker-images: 
	cd `pwd`/linux/ecosystem/retracker    && pwd && make build && make deploy

ecosystem-opentracker-images: 
	cd `pwd`/linux/ecosystem/opentracker    && pwd && make build && make deploy

ecosystem-torrust-tracker-images: 
	cd `pwd`/linux/ecosystem/torrust-tracker    && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/torrust-index    && pwd && make build && make deploy

ecosystem-monero-images: 
	cd `pwd`/linux/ecosystem/monero/monerod    && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/monero/p2pool    && pwd && make build && make deploy

ecosystem-postgres-images:
	cd `pwd`/linux/ecosystem/postgres/latest       && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/postgres/8.2          && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/postgres/8.3          && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/postgres/8.4          && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/postgres/9.0          && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/postgres/9.1          && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/postgres/9.2          && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/postgres/9.3          && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/postgres/9.4          && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/postgres/9.5          && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/postgres/9.6          && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/postgres/10           && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/postgres/11           && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/postgres/12           && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/postgres/13           && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/postgres/14           && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/postgres/15           && pwd && make build && make deploy
#	cd `pwd`/linux/ecosystem/postgres/16           && pwd && make build && make deploy

ecosystem-teamcity-agent-images:
	cd `pwd`/linux/ecosystem/teamcity/agent/latest/jdk11         && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/teamcity/agent/latest/jdk17         && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/teamcity/agent/amxx-sdk/1.9   && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/teamcity/agent/amxx-sdk/1.10  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/teamcity/agent/android-sdk/jdk11    && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/teamcity/agent/android-sdk/jdk17    && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/teamcity/agent/atlassian-sdk  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/teamcity/agent/dotnet-sdk     && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/teamcity/agent/node10         && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/teamcity/agent/node12         && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/teamcity/agent/node14         && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/teamcity/agent/node15         && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/teamcity/agent/node16         && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/teamcity/agent/node17         && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/teamcity/agent/node18         && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/teamcity/agent/node19         && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/teamcity/agent/node20         && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/teamcity/agent/php7.2         && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/teamcity/agent/php7.3         && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/teamcity/agent/php7.4         && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/teamcity/agent/php8.0         && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/teamcity/agent/php8.1         && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/teamcity/agent/steam-sdk      && pwd && make build && make deploy

ecosystem-gitlab-runner-images:
	cd `pwd`/linux/ecosystem/gitlab/runner/latest         && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/gitlab/runner/amxx-sdk/1.9   && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/gitlab/runner/amxx-sdk/1.10  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/gitlab/runner/android-sdk/jdk11    && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/gitlab/runner/android-sdk/jdk17    && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/gitlab/runner/atlassian-sdk  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/gitlab/runner/dotnet-sdk     && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/gitlab/runner/node10         && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/gitlab/runner/node12         && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/gitlab/runner/node14         && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/gitlab/runner/node15         && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/gitlab/runner/node16         && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/gitlab/runner/node17         && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/gitlab/runner/node18         && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/gitlab/runner/node19         && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/gitlab/runner/node20         && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/gitlab/runner/php7.2         && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/gitlab/runner/php7.3         && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/gitlab/runner/php7.4         && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/gitlab/runner/php8.1         && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/gitlab/runner/steam-sdk      && pwd && make build && make deploy

ecosystem-nginx-images:
	cd `pwd`/linux/ecosystem/nginx/latest/mainline/main      && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/nginx/latest/mainline/php       && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/nginx/latest/mainline/rtmp-hls  && pwd && make build && make deploy

ecosystem-vscode-server-images:
	cd `pwd`/linux/advanced/vscode-server/latest         && pwd && make build && make deploy
	cd `pwd`/linux/advanced/vscode-server/devops         && pwd && make build && make deploy
	cd `pwd`/linux/advanced/vscode-server/amxx/1.9       && pwd && make build && make deploy
	cd `pwd`/linux/advanced/vscode-server/amxx/1.10      && pwd && make build && make deploy
	cd `pwd`/linux/advanced/vscode-server/android        && pwd && make build && make deploy
	cd `pwd`/linux/advanced/vscode-server/cpp            && pwd && make build && make deploy
	cd `pwd`/linux/advanced/vscode-server/docker         && pwd && make build && make deploy
	cd `pwd`/linux/advanced/vscode-server/dotnet-full    && pwd && make build && make deploy
	cd `pwd`/linux/advanced/vscode-server/dotnet         && pwd && make build && make deploy
	cd `pwd`/linux/advanced/vscode-server/mono           && pwd && make build && make deploy

ecosystem-perforce-base-images:
	cd `pwd`/linuxecosystem/perforce/base/r16.2    && pwd && make build && make deploy
	cd `pwd`/linuxecosystem/perforce/base/r17.1    && pwd && make build && make deploy
	cd `pwd`/linuxecosystem/perforce/base/r17.2    && pwd && make build && make deploy
	cd `pwd`/linuxecosystem/perforce/base/r18.1    && pwd && make build && make deploy
	cd `pwd`/linuxecosystem/perforce/base/r18.2    && pwd && make build && make deploy
	cd `pwd`/linuxecosystem/perforce/base/r19.1    && pwd && make build && make deploy
	cd `pwd`/linuxecosystem/perforce/base/r19.2    && pwd && make build && make deploy
	cd `pwd`/linuxecosystem/perforce/base/r20.1    && pwd && make build && make deploy
	cd `pwd`/linuxecosystem/perforce/base/r20.2    && pwd && make build && make deploy
	cd `pwd`/linuxecosystem/perforce/base/r21.1    && pwd && make build && make deploy
	cd `pwd`/linuxecosystem/perforce/base/r21.2    && pwd && make build && make deploy
	cd `pwd`/linuxecosystem/perforce/base/r22.1    && pwd && make build && make deploy

ecosystem-perforce-proxy-images:
	cd `pwd`/linuxecosystem/perforce/p4p/r16.2    && pwd && make build && make deploy
	cd `pwd`/linuxecosystem/perforce/p4p/r17.1    && pwd && make build && make deploy
	cd `pwd`/linuxecosystem/perforce/p4p/r17.2    && pwd && make build && make deploy
	cd `pwd`/linuxecosystem/perforce/p4p/r18.1    && pwd && make build && make deploy
	cd `pwd`/linuxecosystem/perforce/p4p/r18.2    && pwd && make build && make deploy
	cd `pwd`/linuxecosystem/perforce/p4p/r19.1    && pwd && make build && make deploy
	cd `pwd`/linuxecosystem/perforce/p4p/r19.2    && pwd && make build && make deploy
	cd `pwd`/linuxecosystem/perforce/p4p/r20.1    && pwd && make build && make deploy
	cd `pwd`/linuxecosystem/perforce/p4p/r20.2    && pwd && make build && make deploy
	cd `pwd`/linuxecosystem/perforce/p4p/r21.1    && pwd && make build && make deploy
	cd `pwd`/linuxecosystem/perforce/p4p/r21.2    && pwd && make build && make deploy
	cd `pwd`/linuxecosystem/perforce/p4p/r22.1    && pwd && make build && make deploy

ecosystem-jira-4-images:
	cd `pwd`/linux/ecosystem/atlassian/jira/4/4.1.1                && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/jira/4/4.1.2                && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/jira/4/4.2                && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/jira/4/4.2.1                && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/jira/4/4.2.2                && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/jira/4/4.2.3                && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/jira/4/4.2.4                && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/jira/4/4.3                && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/jira/4/4.3.1                && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/jira/4/4.3.2                && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/jira/4/4.3.3                && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/jira/4/4.3.4                && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/jira/4/4.4                && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/jira/4/4.4.1                && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/jira/4/4.4.3                && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/jira/4/4.4.4                && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/jira/4/4.4.5                && pwd && make build && make deploy

ecosystem-jira-5-images:
	cd `pwd`/linux/ecosystem/atlassian/jira/5/5.0                && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/jira/5/5.0.1                && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/jira/5/5.0.2                && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/jira/5/5.0.3                && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/jira/5/5.0.4                && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/jira/5/5.0.5                && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/jira/5/5.0.6                && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/jira/5/5.0.7                && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/jira/5/5.1                && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/jira/5/5.1.1                && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/jira/5/5.1.2                && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/jira/5/5.1.3                && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/jira/5/5.1.4                && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/jira/5/5.1.5                && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/jira/5/5.1.6                && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/jira/5/5.1.7                && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/jira/5/5.1.8                && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/jira/5/5.2                && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/jira/5/5.2.1                && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/jira/5/5.2.10                && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/jira/5/5.2.11                && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/jira/5/5.2.2                && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/jira/5/5.2.3                && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/jira/5/5.2.4                && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/jira/5/5.2.4.1                && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/jira/5/5.2.5                && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/jira/5/5.2.6                && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/jira/5/5.2.7                && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/jira/5/5.2.8                && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/jira/5/5.2.9                && pwd && make build && make deploy

ecosystem-jira-6-images:
	cd `pwd`/linux/ecosystem/atlassian/jira/6/6.0                && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/jira/6/6.0.1                && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/jira/6/6.0.2                && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/jira/6/6.0.3                && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/jira/6/6.0.4                && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/jira/6/6.0.5                && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/jira/6/6.0.6                && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/jira/6/6.0.7                && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/jira/6/6.0.8                && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/jira/6/6.1                && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/jira/6/6.1.1                && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/jira/6/6.1.2                && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/jira/6/6.1.3                && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/jira/6/6.1.4                && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/jira/6/6.1.5                && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/jira/6/6.1.6                && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/jira/6/6.1.7                && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/jira/6/6.1.8                && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/jira/6/6.1.9                && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/jira/6/6.2                && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/jira/6/6.2.1                && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/jira/6/6.2.2                && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/jira/6/6.2.3                && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/jira/6/6.2.4                && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/jira/6/6.2.5                && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/jira/6/6.2.6                && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/jira/6/6.2.7                && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/jira/6/6.3                && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/jira/6/6.3.1                && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/jira/6/6.3.3                && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/jira/6/6.3.4                && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/jira/6/6.3.5                && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/jira/6/6.3.6                && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/jira/6/6.3.7                && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/jira/6/6.3.8                && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/jira/6/6.3.9                && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/jira/6/6.3.10                && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/jira/6/6.3.11                && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/jira/6/6.3.12                && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/jira/6/6.3.13                && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/jira/6/6.3.14                && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/jira/6/6.3.15                && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/jira/6/6.4                && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/jira/6/6.4.1                && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/jira/6/6.4.2                && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/jira/6/6.4.3                && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/jira/6/6.4.4                && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/jira/6/6.4.5                && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/jira/6/6.4.6                && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/jira/6/6.4.7                && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/jira/6/6.4.8                && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/jira/6/6.4.9                && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/jira/6/6.4.10                && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/jira/6/6.4.11                && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/jira/6/6.4.12                && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/jira/6/6.4.13                && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/jira/6/6.4.14                && pwd && make build && make deploy

ecosystem-jira-7-images:
	cd `pwd`/linux/ecosystem/atlassian/jira/7/7.0.0                && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/jira/7/7.0.2                && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/jira/7/7.0.4                && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/jira/7/7.0.5                && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/jira/7/7.0.10                && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/jira/7/7.0.11                && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/jira/7/7.1.0                && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/jira/7/7.1.1                && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/jira/7/7.1.2                && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/jira/7/7.1.4                && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/jira/7/7.1.6                && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/jira/7/7.1.7                && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/jira/7/7.1.8                && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/jira/7/7.1.9                && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/jira/7/7.1.10                && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/jira/7/7.2.0                && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/jira/7/7.2.1                && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/jira/7/7.2.2                && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/jira/7/7.2.3                && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/jira/7/7.2.4                && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/jira/7/7.2.6                && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/jira/7/7.2.7                && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/jira/7/7.2.8                && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/jira/7/7.2.9                && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/jira/7/7.2.10                && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/jira/7/7.2.11                && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/jira/7/7.2.12                && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/jira/7/7.2.13                && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/jira/7/7.2.14                && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/jira/7/7.2.15                && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/jira/7/7.3.0                && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/jira/7/7.3.1                && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/jira/7/7.3.2                && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/jira/7/7.3.3                && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/jira/7/7.3.4                && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/jira/7/7.3.5                && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/jira/7/7.3.6                && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/jira/7/7.3.7                && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/jira/7/7.3.8                && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/jira/7/7.3.9                && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/jira/7/7.4.0                && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/jira/7/7.4.1                && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/jira/7/7.4.2                && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/jira/7/7.4.3                && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/jira/7/7.4.4                && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/jira/7/7.4.5                && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/jira/7/7.4.6                && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/jira/7/7.5.0                && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/jira/7/7.5.1                && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/jira/7/7.5.2                && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/jira/7/7.5.3                && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/jira/7/7.5.4                && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/jira/7/7.6.0                && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/jira/7/7.6.1                && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/jira/7/7.6.2                && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/jira/7/7.6.3                && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/jira/7/7.6.4                && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/jira/7/7.6.6                && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/jira/7/7.6.7                && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/jira/7/7.6.8                && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/jira/7/7.6.9                && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/jira/7/7.6.10                && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/jira/7/7.6.11                && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/jira/7/7.6.12                && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/jira/7/7.6.13                && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/jira/7/7.6.14                && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/jira/7/7.6.15                && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/jira/7/7.6.16                && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/jira/7/7.6.17                && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/jira/7/7.7.0                && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/jira/7/7.7.1                && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/jira/7/7.7.2                && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/jira/7/7.7.4                && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/jira/7/7.8.0                && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/jira/7/7.8.1                && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/jira/7/7.8.2                && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/jira/7/7.8.4                && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/jira/7/7.9.0                && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/jira/7/7.9.2                && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/jira/7/7.10.0                && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/jira/7/7.10.1                && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/jira/7/7.10.2                && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/jira/7/7.11.0                && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/jira/7/7.11.1                && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/jira/7/7.11.2                && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/jira/7/7.12.0                && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/jira/7/7.12.1                && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/jira/7/7.12.3                && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/jira/7/7.13.0                && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/jira/7/7.13.1                && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/jira/7/7.13.2                && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/jira/7/7.13.3                && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/jira/7/7.13.4                && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/jira/7/7.13.5                && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/jira/7/7.13.6                && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/jira/7/7.13.8                && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/jira/7/7.13.9                && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/jira/7/7.13.11                && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/jira/7/7.13.12                && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/jira/7/7.13.13                && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/jira/7/7.13.14                && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/jira/7/7.13.15                && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/jira/7/7.13.16                && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/jira/7/7.13.17                && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/jira/7/7.13.18                && pwd && make build && make deploy

ecosystem-jira-8-images:
	cd `pwd`/linux/ecosystem/atlassian/jira/8/8.0.0                && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/jira/8/8.0.2                && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/jira/8/8.0.3                && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/jira/8/8.1.0                && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/jira/8/8.1.1                && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/jira/8/8.1.2                && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/jira/8/8.1.3                && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/jira/8/8.2.0                && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/jira/8/8.2.1                && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/jira/8/8.2.2                && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/jira/8/8.2.3                && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/jira/8/8.2.4                && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/jira/8/8.2.5                && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/jira/8/8.2.6                && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/jira/8/8.3.0                && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/jira/8/8.3.1                && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/jira/8/8.3.2                && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/jira/8/8.3.3                && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/jira/8/8.3.4                && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/jira/8/8.3.5                && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/jira/8/8.4.0                && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/jira/8/8.4.1                && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/jira/8/8.4.2                && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/jira/8/8.4.3                && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/jira/8/8.5.0                && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/jira/8/8.5.1                && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/jira/8/8.5.2                && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/jira/8/8.5.3                && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/jira/8/8.5.4                && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/jira/8/8.5.5                && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/jira/8/8.5.6                && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/jira/8/8.5.7                && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/jira/8/8.5.8                && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/jira/8/8.5.9                && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/jira/8/8.5.10                && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/jira/8/8.5.11                && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/jira/8/8.5.12                && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/jira/8/8.5.13                && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/jira/8/8.5.14                && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/jira/8/8.5.15                && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/jira/8/8.5.16                && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/jira/8/8.5.17                && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/jira/8/8.5.18                && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/jira/8/8.5.19                && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/jira/8/8.6.0                && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/jira/8/8.6.1                && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/jira/8/8.7.0                && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/jira/8/8.7.1                && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/jira/8/8.8.0                && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/jira/8/8.8.1                && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/jira/8/8.9.0                && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/jira/8/8.9.1                && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/jira/8/8.10.0                && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/jira/8/8.10.1                && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/jira/8/8.11.0                && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/jira/8/8.11.1                && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/jira/8/8.12.0                && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/jira/8/8.12.1                && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/jira/8/8.12.2                && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/jira/8/8.12.3                && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/jira/8/8.13.0                && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/jira/8/8.13.1                && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/jira/8/8.13.2                && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/jira/8/8.13.3                && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/jira/8/8.13.4                && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/jira/8/8.13.5                && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/jira/8/8.13.6                && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/jira/8/8.13.7                && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/jira/8/8.13.8                && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/jira/8/8.13.9                && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/jira/8/8.13.10                && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/jira/8/8.13.11                && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/jira/8/8.13.12                && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/jira/8/8.13.13                && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/jira/8/8.13.14                && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/jira/8/8.13.15                && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/jira/8/8.13.16                && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/jira/8/8.13.17                && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/jira/8/8.13.18                && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/jira/8/8.13.19                && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/jira/8/8.13.20                && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/jira/8/8.13.21                && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/jira/8/8.13.22                && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/jira/8/8.13.24                && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/jira/8/8.13.25                && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/jira/8/8.13.26                && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/jira/8/8.13.27                && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/jira/8/8.14.0                && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/jira/8/8.14.1                && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/jira/8/8.15.0                && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/jira/8/8.15.1                && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/jira/8/8.16.0                && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/jira/8/8.16.1                && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/jira/8/8.16.2                && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/jira/8/8.17.0                && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/jira/8/8.17.1                && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/jira/8/8.18.1                && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/jira/8/8.18.2                && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/jira/8/8.19.0                && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/jira/8/8.19.1                && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/jira/8/8.20.0                && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/jira/8/8.20.1                && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/jira/8/8.20.2                && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/jira/8/8.20.3                && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/jira/8/8.20.4                && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/jira/8/8.20.5                && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/jira/8/8.20.6                && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/jira/8/8.20.7                && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/jira/8/8.20.8                && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/jira/8/8.20.9                && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/jira/8/8.20.10                && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/jira/8/8.20.11                && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/jira/8/8.20.12                && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/jira/8/8.20.13                && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/jira/8/8.20.14                && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/jira/8/8.20.15                && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/jira/8/8.20.16                && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/jira/8/8.20.17                && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/jira/8/8.20.19                && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/jira/8/8.20.20                && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/jira/8/8.20.21                && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/jira/8/8.20.22                && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/jira/8/8.20.23                && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/jira/8/8.20.24                && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/jira/8/8.21.0                && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/jira/8/8.21.1                && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/jira/8/8.22.0                && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/jira/8/8.22.1                && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/jira/8/8.22.2                && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/jira/8/8.22.3                && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/jira/8/8.22.4                && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/jira/8/8.22.6                && pwd && make build && make deploy

ecosystem-jira-9-images:
	cd `pwd`/linux/ecosystem/atlassian/jira/9/9.0.0                && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/jira/9/9.1.0                && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/jira/9/9.1.1                && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/jira/9/9.2.0                && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/jira/9/9.2.1                && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/jira/9/9.3.0                && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/jira/9/9.3.1                && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/jira/9/9.3.2                && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/jira/9/9.3.3                && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/jira/9/9.4.0                && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/jira/9/9.4.1                && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/jira/9/9.4.2                && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/jira/9/9.4.3                && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/jira/9/9.4.4                && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/jira/9/9.4.5                && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/jira/9/9.4.6                && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/jira/9/9.4.7                && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/jira/9/9.4.8                && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/jira/9/9.5.0                && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/jira/9/9.5.1                && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/jira/9/9.6.0                && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/jira/9/9.7.0                && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/jira/9/9.7.1                && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/jira/9/9.8.0                && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/jira/9/9.8.1                && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/jira/9/9.9.0                && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/jira/9/9.9.1                && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/jira/9/9.10.0                && pwd && make build && make deploy

bundle-base-images:
	@echo "======================================="
	@echo "===== Building  EpicMorg   images ====="
	@echo "======================================="
	make advanced-pyhton-images
	make ecosystem-debian-images

bundle-teamcity:
	@echo "======================================="
	@echo "===== Building  TeamCity   images ====="
	@echo "======================================="
	make advanced-teamcity-server-images

bundle-gitlab:
	@echo "======================================="
	@echo "===== Building  GitLab     images ====="
	@echo "======================================="
	make ecosystem-gitlab-runner-images

bundle-jira:
	@echo "======================================="
	@echo "===== Building  All Jira  images  ====="
	@echo "======================================="
	make ecosystem-jira-4-images
	make ecosystem-jira-5-images
	make ecosystem-jira-6-images
	make ecosystem-jira-7-images
	make ecosystem-jira-8-images
	make ecosystem-jira-9-images

bundle-atlassian-altest:
	@echo "=============================================="
	@echo "===== Building  Atlassian Latest images  ====="
	@echo "=============================================="
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/latest           && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/confluence/latest          && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/crowd/latest               && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/crucible/latest            && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/fisheye/latest             && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/fisheye-crucible/latest    && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/jira/latest                && pwd && make build && make deploy


bundle-atlassian:
	@echo "======================================="
	@echo "===== Building  Atlassian  images ====="
	@echo "======================================="
	make bundle-jira

bundle-web:
	@echo "======================================="
	@echo "=====   Building    web    images ====="
	@echo "======================================="
	make ecosystem-php-images
	make ecosystem-apache2-images
	make ecosystem-nginx-images
	
bundle-p4:
	@echo "======================================="
	@echo "=====   Building    p4    images ====="
	@echo "======================================="
	make ecosystem-perforce-base-images
	make ecosystem-perforce-proxy-images
 
 
bundle-debug-base6:
	cd `pwd`/linux/ecosystem/epicmorg/debian/06-squeeze/slim    && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/epicmorg/debian/06-squeeze/main    && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/epicmorg/debian/06-squeeze/develop    && pwd && make build && make deploy
bundle-debug-base7:
	cd `pwd`/linux/ecosystem/epicmorg/debian/07-wheezy/slim    && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/epicmorg/debian/07-wheezy/main    && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/epicmorg/debian/07-wheezy/develop    && pwd && make build && make deploy
bundle-debug-base8:
	cd `pwd`/linux/ecosystem/epicmorg/debian/08-jessie/slim    && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/epicmorg/debian/08-jessie/main    && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/epicmorg/debian/08-jessie/develop    && pwd && make build && make deploy
bundle-debug-base9:
	cd `pwd`/linux/ecosystem/epicmorg/debian/09-stretch/slim    && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/epicmorg/debian/09-stretch/main    && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/epicmorg/debian/09-stretch/develop    && pwd && make build && make deploy
bundle-debug-base10:
	cd `pwd`/linux/ecosystem/epicmorg/debian/10-buster/slim    && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/epicmorg/debian/10-buster/main    && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/epicmorg/debian/10-buster/develop    && pwd && make build && make deploy


bundle-cve:
	cd `pwd`/linux/ecosystem/epicmorg/debian/11-bullseye/slim    && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/epicmorg/debian/11-bullseye/main    && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/epicmorg/debian/11-bullseye/develop    && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/epicmorg/debian/12-bookworm/slim    && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/epicmorg/debian/12-bookworm/main    && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/epicmorg/debian/12-bookworm/develop    && pwd && make build && make deploy 
	cd `pwd`/linux/ecosystem/epicmorg/debian/11-bullseye/jdk8     && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/epicmorg/debian/11-bullseye/jdk11     && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/epicmorg/debian/11-bullseye/jdk17     && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/epicmorg/debian/12-bookworm/jdk8     && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/epicmorg/debian/12-bookworm/jdk11     && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/epicmorg/debian/12-bookworm/jdk17     && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/confluence/8/8.6.1          && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/confluence/8/8.5.3         && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/confluence/7.19.16          && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/confluence/latest          && pwd && make build && make deploy
