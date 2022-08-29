VERSION             =  "2022.05.07"
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
#	make docker-clean
	make advanced-images
	make ecosystem-images
#	make docker-clean

advanced-images:
	@echo "======================================="
	@echo "===== Building third-party images ====="
	@echo "======================================="
	make advanced-redash-images
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

advanced-zabbix-images:
	make advanced-zabbix-30-images
	make echo-done
	make advanced-zabbix-40-images
	make echo-done
	make advanced-zabbix-50-images
	make echo-done
	make advanced-zabbix-52-images
	make echo-done
	make advanced-zabbix-54-images
	make echo-done
	make advanced-zabbix-60-images
	make echo-done
	make advanced-zabbix-62-images
	make echo-done
#	make advanced-zabbix-64-images
	make echo-done
	make advanced-zabbix-latest-images
	make echo-done

advanced-zabbix-30-images:
	cd `pwd`/linux/advanced/zabbix/3.0/agent				&& pwd && make build && make deploy
	cd `pwd`/linux/advanced/zabbix/3.0/java-gateway				&& pwd && make build && make deploy
	cd `pwd`/linux/advanced/zabbix/3.0/proxy-mysql				&& pwd && make build && make deploy
	cd `pwd`/linux/advanced/zabbix/3.0/proxy-sqlite3			&& pwd && make build && make deploy
	cd `pwd`/linux/advanced/zabbix/3.0/server-mysql				&& pwd && make build && make deploy
	cd `pwd`/linux/advanced/zabbix/3.0/server-pgsql				&& pwd && make build && make deploy
	cd `pwd`/linux/advanced/zabbix/3.0/snmptraps				&& pwd && make build && make deploy
	cd `pwd`/linux/advanced/zabbix/3.0/web-mysql				&& pwd && make build && make deploy
	cd `pwd`/linux/advanced/zabbix/3.0/web-pgsql				&& pwd && make build && make deploy

advanced-zabbix-40-images:
	cd `pwd`/linux/advanced/zabbix/4.0/agent				&& pwd && make build && make deploy
	cd `pwd`/linux/advanced/zabbix/4.0/java-gateway				&& pwd && make build && make deploy
	cd `pwd`/linux/advanced/zabbix/4.0/proxy-mysql				&& pwd && make build && make deploy
	cd `pwd`/linux/advanced/zabbix/4.0/proxy-sqlite3			&& pwd && make build && make deploy
	cd `pwd`/linux/advanced/zabbix/4.0/server-mysql				&& pwd && make build && make deploy
	cd `pwd`/linux/advanced/zabbix/4.0/server-pgsql				&& pwd && make build && make deploy
	cd `pwd`/linux/advanced/zabbix/4.0/snmptraps				&& pwd && make build && make deploy
	cd `pwd`/linux/advanced/zabbix/4.0/web-mysql				&& pwd && make build && make deploy
	cd `pwd`/linux/advanced/zabbix/4.0/web-pgsql				&& pwd && make build && make deploy

advanced-zabbix-50-images:
	cd `pwd`/linux/advanced/zabbix/5.0/agent				&& pwd && make build && make deploy
	cd `pwd`/linux/advanced/zabbix/5.0/agent2				&& pwd && make build && make deploy
	cd `pwd`/linux/advanced/zabbix/5.0/java-gateway				&& pwd && make build && make deploy
	cd `pwd`/linux/advanced/zabbix/5.0/proxy-mysql				&& pwd && make build && make deploy
	cd `pwd`/linux/advanced/zabbix/5.0/proxy-sqlite3			&& pwd && make build && make deploy
	cd `pwd`/linux/advanced/zabbix/5.0/server-mysql				&& pwd && make build && make deploy
	cd `pwd`/linux/advanced/zabbix/5.0/server-pgsql				&& pwd && make build && make deploy
	cd `pwd`/linux/advanced/zabbix/5.0/snmptraps				&& pwd && make build && make deploy
	cd `pwd`/linux/advanced/zabbix/5.0/web-mysql				&& pwd && make build && make deploy
	cd `pwd`/linux/advanced/zabbix/5.0/web-pgsql				&& pwd && make build && make deploy

advanced-zabbix-52-images:
	cd `pwd`/linux/advanced/zabbix/5.2/agent				&& pwd && make build && make deploy
	cd `pwd`/linux/advanced/zabbix/5.2/agent2				&& pwd && make build && make deploy
	cd `pwd`/linux/advanced/zabbix/5.2/java-gateway				&& pwd && make build && make deploy
	cd `pwd`/linux/advanced/zabbix/5.2/proxy-mysql				&& pwd && make build && make deploy
	cd `pwd`/linux/advanced/zabbix/5.2/proxy-sqlite3			&& pwd && make build && make deploy
	cd `pwd`/linux/advanced/zabbix/5.2/server-mysql				&& pwd && make build && make deploy
	cd `pwd`/linux/advanced/zabbix/5.2/server-pgsql				&& pwd && make build && make deploy
	cd `pwd`/linux/advanced/zabbix/5.2/snmptraps				&& pwd && make build && make deploy
	cd `pwd`/linux/advanced/zabbix/5.2/web-mysql				&& pwd && make build && make deploy
	cd `pwd`/linux/advanced/zabbix/5.2/web-pgsql				&& pwd && make build && make deploy

advanced-zabbix-54-images:
	cd `pwd`/linux/advanced/zabbix/5.4/agent				&& pwd && make build && make deploy
	cd `pwd`/linux/advanced/zabbix/5.4/agent2				&& pwd && make build && make deploy
	cd `pwd`/linux/advanced/zabbix/5.4/java-gateway				&& pwd && make build && make deploy
	cd `pwd`/linux/advanced/zabbix/5.4/proxy-mysql				&& pwd && make build && make deploy
	cd `pwd`/linux/advanced/zabbix/5.4/proxy-sqlite3			&& pwd && make build && make deploy
	cd `pwd`/linux/advanced/zabbix/5.4/server-mysql				&& pwd && make build && make deploy
	cd `pwd`/linux/advanced/zabbix/5.4/server-pgsql				&& pwd && make build && make deploy
	cd `pwd`/linux/advanced/zabbix/5.4/snmptraps				&& pwd && make build && make deploy
	cd `pwd`/linux/advanced/zabbix/5.4/web-mysql				&& pwd && make build && make deploy
	cd `pwd`/linux/advanced/zabbix/5.4/web-pgsql				&& pwd && make build && make deploy

advanced-zabbix-60-images:
	cd `pwd`/linux/advanced/zabbix/6.0/agent				&& pwd && make build && make deploy
	cd `pwd`/linux/advanced/zabbix/6.0/agent2				&& pwd && make build && make deploy
	cd `pwd`/linux/advanced/zabbix/6.0/java-gateway				&& pwd && make build && make deploy
	cd `pwd`/linux/advanced/zabbix/6.0/proxy-mysql				&& pwd && make build && make deploy
	cd `pwd`/linux/advanced/zabbix/6.0/proxy-sqlite3			&& pwd && make build && make deploy
	cd `pwd`/linux/advanced/zabbix/6.0/server-mysql				&& pwd && make build && make deploy
	cd `pwd`/linux/advanced/zabbix/6.0/server-pgsql				&& pwd && make build && make deploy
	cd `pwd`/linux/advanced/zabbix/6.0/snmptraps				&& pwd && make build && make deploy
	cd `pwd`/linux/advanced/zabbix/6.0/web-mysql				&& pwd && make build && make deploy
	cd `pwd`/linux/advanced/zabbix/6.0/web-pgsql				&& pwd && make build && make deploy

advanced-zabbix-62-images:
	cd `pwd`/linux/advanced/zabbix/6.2/agent				&& pwd && make build && make deploy
	cd `pwd`/linux/advanced/zabbix/6.2/agent2				&& pwd && make build && make deploy
	cd `pwd`/linux/advanced/zabbix/6.2/java-gateway				&& pwd && make build && make deploy
	cd `pwd`/linux/advanced/zabbix/6.2/proxy-mysql				&& pwd && make build && make deploy
	cd `pwd`/linux/advanced/zabbix/6.2/proxy-sqlite3			&& pwd && make build && make deploy
	cd `pwd`/linux/advanced/zabbix/6.2/server-mysql				&& pwd && make build && make deploy
	cd `pwd`/linux/advanced/zabbix/6.2/server-pgsql				&& pwd && make build && make deploy
	cd `pwd`/linux/advanced/zabbix/6.2/snmptraps				&& pwd && make build && make deploy
	cd `pwd`/linux/advanced/zabbix/6.2/web-mysql				&& pwd && make build && make deploy
	cd `pwd`/linux/advanced/zabbix/6.2/web-pgsql				&& pwd && make build && make deploy

advanced-zabbix-64-images:
	cd `pwd`/linux/advanced/zabbix/6.4/agent				&& pwd && make build && make deploy
	cd `pwd`/linux/advanced/zabbix/6.4/agent2				&& pwd && make build && make deploy
	cd `pwd`/linux/advanced/zabbix/6.4/java-gateway				&& pwd && make build && make deploy
	cd `pwd`/linux/advanced/zabbix/6.4/proxy-mysql				&& pwd && make build && make deploy
	cd `pwd`/linux/advanced/zabbix/6.4/proxy-sqlite3			&& pwd && make build && make deploy
	cd `pwd`/linux/advanced/zabbix/6.4/server-mysql				&& pwd && make build && make deploy
	cd `pwd`/linux/advanced/zabbix/6.4/server-pgsql				&& pwd && make build && make deploy
	cd `pwd`/linux/advanced/zabbix/6.4/snmptraps				&& pwd && make build && make deploy
	cd `pwd`/linux/advanced/zabbix/6.4/web-mysql				&& pwd && make build && make deploy
	cd `pwd`/linux/advanced/zabbix/6.4/web-pgsql				&& pwd && make build && make deploy

advanced-zabbix-latest-images:
	cd `pwd`/linux/advanced/zabbix/latest/agent				&& pwd && make build && make deploy
	cd `pwd`/linux/advanced/zabbix/latest/agent2				&& pwd && make build && make deploy
	cd `pwd`/linux/advanced/zabbix/latest/java-gateway			&& pwd && make build && make deploy
	cd `pwd`/linux/advanced/zabbix/latest/proxy-mysql			&& pwd && make build && make deploy
	cd `pwd`/linux/advanced/zabbix/latest/proxy-sqlite3			&& pwd && make build && make deploy
	cd `pwd`/linux/advanced/zabbix/latest/server-mysql			&& pwd && make build && make deploy
	cd `pwd`/linux/advanced/zabbix/latest/server-pgsql			&& pwd && make build && make deploy
	cd `pwd`/linux/advanced/zabbix/latest/snmptraps				&& pwd && make build && make deploy
	cd `pwd`/linux/advanced/zabbix/latest/web-mysql				&& pwd && make build && make deploy
	cd `pwd`/linux/advanced/zabbix/latest/web-pgsql				&& pwd && make build && make deploy

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

ecosystem-images:
	make bundle-base-images
	make buldle-perforce
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

ecosystem-pyhton-images:
	make ecosystem-pyhton-images-main
	make ecosystem-pyhton-images-develop

ecosystem-pyhton-images-main:
	cd `pwd`/linux/ecosystem/epicmorg/python/main/2.7 && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/epicmorg/python/main/3.6 && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/epicmorg/python/main/3.7 && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/epicmorg/python/main/3.8 && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/epicmorg/python/main/3.9 && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/epicmorg/python/main/3.10 && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/epicmorg/python/main/3.11 && pwd && make build && make deploy

ecosystem-pyhton-images-develop:
	cd `pwd`/linux/ecosystem/epicmorg/python/develop/2.7 && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/epicmorg/python/develop/3.6 && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/epicmorg/python/develop/3.7 && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/epicmorg/python/develop/3.8 && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/epicmorg/python/develop/3.9 && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/epicmorg/python/develop/3.10 && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/epicmorg/python/develop/3.11 && pwd && make build && make deploy

ecosystem-debian-images:
	make ecosystem-debian-jessie-images
	make ecosystem-debian-stretch-images
	make ecosystem-debian-buster-images
	make ecosystem-debian-bullseye-images
	make ecosystem-debian-bookworm-images

ecosystem-debian-jessie-images:
	cd `pwd`/linux/ecosystem/epicmorg/debian/08-jessie/slim    && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/epicmorg/debian/08-jessie/main    && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/epicmorg/debian/08-jessie/develop    && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/epicmorg/debian/08-jessie/jdk6    && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/epicmorg/debian/08-jessie/jdk7    && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/epicmorg/debian/08-jessie/jdk8    && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/epicmorg/debian/08-jessie/jdk11    && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/epicmorg/debian/08-jessie/jdk12    && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/epicmorg/debian/08-jessie/jdk13    && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/epicmorg/debian/08-jessie/jdk14    && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/epicmorg/debian/08-jessie/jdk15    && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/epicmorg/debian/08-jessie/jdk16    && pwd && make build && make deploy
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
	cd `pwd`/linux/ecosystem/epicmorg/debian/09-stretch/jdk12    && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/epicmorg/debian/09-stretch/jdk13    && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/epicmorg/debian/09-stretch/jdk14    && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/epicmorg/debian/09-stretch/jdk15    && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/epicmorg/debian/09-stretch/jdk16    && pwd && make build && make deploy
#	cd `pwd`/linux/ecosystem/epicmorg/debian/09-stretch/jdk17    && pwd && make build && make deploy
#	cd `pwd`/linux/ecosystem/epicmorg/debian/09-stretch/jdk18    && pwd && make build && make deploy

ecosystem-debian-buster-images:
	cd `pwd`/linux/ecosystem/epicmorg/debian/10-buster/slim    && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/epicmorg/debian/10-buster/main    && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/epicmorg/debian/10-buster/develop    && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/epicmorg/debian/10-buster/jdk6    && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/epicmorg/debian/10-buster/jdk7    && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/epicmorg/debian/10-buster/jdk8    && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/epicmorg/debian/10-buster/jdk11    && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/epicmorg/debian/10-buster/jdk12    && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/epicmorg/debian/10-buster/jdk13    && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/epicmorg/debian/10-buster/jdk14    && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/epicmorg/debian/10-buster/jdk15    && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/epicmorg/debian/10-buster/jdk16    && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/epicmorg/debian/10-buster/jdk17    && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/epicmorg/debian/10-buster/jdk18    && pwd && make build && make deploy

ecosystem-debian-bullseye-images:
	cd `pwd`/linux/ecosystem/epicmorg/debian/11-bullseye/slim    && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/epicmorg/debian/11-bullseye/main    && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/epicmorg/debian/11-bullseye/develop    && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/epicmorg/debian/11-bullseye/jdk6    && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/epicmorg/debian/11-bullseye/jdk7    && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/epicmorg/debian/11-bullseye/jdk8    && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/epicmorg/debian/11-bullseye/jdk11    && pwd && make build && make deploy
#	cd `pwd`/linux/ecosystem/epicmorg/debian/11-bullseye/jdk12    && pwd && make build && make deploy
#	cd `pwd`/linux/ecosystem/epicmorg/debian/11-bullseye/jdk13    && pwd && make build && make deploy
#	cd `pwd`/linux/ecosystem/epicmorg/debian/11-bullseye/jdk14    && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/epicmorg/debian/11-bullseye/jdk15    && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/epicmorg/debian/11-bullseye/jdk16    && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/epicmorg/debian/11-bullseye/jdk17    && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/epicmorg/debian/11-bullseye/jdk18    && pwd && make build && make deploy

ecosystem-debian-bookworm-images:
	cd `pwd`/linux/ecosystem/epicmorg/debian/12-bookworm/slim    && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/epicmorg/debian/12-bookworm/main    && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/epicmorg/debian/12-bookworm/develop    && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/epicmorg/debian/12-bookworm/jdk6    && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/epicmorg/debian/12-bookworm/jdk7    && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/epicmorg/debian/12-bookworm/jdk8    && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/epicmorg/debian/12-bookworm/jdk11    && pwd && make build && make deploy
#	cd `pwd`/linux/ecosystem/epicmorg/debian/12-bookworm/jdk12    && pwd && make build && make deploy
#	cd `pwd`/linux/ecosystem/epicmorg/debian/12-bookworm/jdk13    && pwd && make build && make deploy
#	cd `pwd`/linux/ecosystem/epicmorg/debian/12-bookworm/jdk14    && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/epicmorg/debian/12-bookworm/jdk15    && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/epicmorg/debian/12-bookworm/jdk16    && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/epicmorg/debian/12-bookworm/jdk17    && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/epicmorg/debian/12-bookworm/jdk18    && pwd && make build && make deploy

ecosystem-perforce-base-images:
	cd `pwd`/linux/ecosystem/perforce/base/r16.2     && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/perforce/base/r17.1     && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/perforce/base/r17.2     && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/perforce/base/r18.1     && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/perforce/base/r18.2     && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/perforce/base/r19.1     && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/perforce/base/r19.2     && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/perforce/base/r20.1     && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/perforce/base/r20.2     && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/perforce/base/r21.1     && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/perforce/base/r21.2     && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/perforce/base/r22.1     && pwd && make build && make deploy


ecosystem-p4p-images:
	cd `pwd`/linux/ecosystem/perforce/p4p/r16.2     && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/perforce/p4p/r17.1     && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/perforce/p4p/r17.2     && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/perforce/p4p/r18.1     && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/perforce/p4p/r18.2     && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/perforce/p4p/r19.1     && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/perforce/p4p/r19.2     && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/perforce/p4p/r20.1     && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/perforce/p4p/r20.2     && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/perforce/p4p/r21.1     && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/perforce/p4p/r21.2     && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/perforce/p4p/r22.1     && pwd && make build && make deploy

ecosystem-php-images:
	cd `pwd`/linux/ecosystem/php/latest             && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/php/php7.2             && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/php/php7.3             && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/php/php7.4             && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/php/php8.0             && pwd && make build && make deploy

ecosystem-apache2-images:
	cd `pwd`/linux/ecosystem/apache2/latest         && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/apache2/php7.2         && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/apache2/php7.3         && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/apache2/php7.4         && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/apache2/php8.0         && pwd && make build && make deploy

ecosystem-testrail-images:
	cd `pwd`/linux/ecosystem/testrail/latest       && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/testrail/ad           && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/testrail/ldap         && pwd && make build && make deploy

ecosystem-torrserver-images:
	cd `pwd`/linux/ecosystem/torrserver            && pwd && make build && make deploy

ecosystem-electron-release-server-images:
	cd `pwd`/linux/ecosystem/electron-release-server  && pwd && make build && make deploy

ecosystem-nodejs-images: 
	cd `pwd`/linux/ecosystem/nodejs/current        && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/nodejs/lts            && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/nodejs/node10         && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/nodejs/node11         && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/nodejs/node12         && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/nodejs/node13         && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/nodejs/node14         && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/nodejs/node15         && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/nodejs/node16         && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/nodejs/node17         && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/nodejs/node18         && pwd && make build && make deploy

ecosystem-vk2discord-images: 
	cd `pwd`/linux/ecosystem/vk2discord     && pwd && make build && make deploy

ecosystem-qbittorrent-images: 
	cd `pwd`/linux/ecosystem/qbittorrent    && pwd && make build && make deploy

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

ecosystem-teamcity-agent-images:
	cd `pwd`/linux/ecosystem/teamcity/agent/latest         && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/teamcity/agent/amxx-sdk       && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/teamcity/agent/android-sdk    && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/teamcity/agent/atlassian-sdk  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/teamcity/agent/dotnet-sdk     && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/teamcity/agent/node12         && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/teamcity/agent/node14         && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/teamcity/agent/node15         && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/teamcity/agent/node16         && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/teamcity/agent/node17         && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/teamcity/agent/node18         && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/teamcity/agent/php7.2         && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/teamcity/agent/php7.3         && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/teamcity/agent/php7.4         && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/teamcity/agent/php8.0         && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/teamcity/agent/steam-sdk      && pwd && make build && make deploy

ecosystem-nginx-images:
	cd `pwd`/linux/ecosystem/nginx/latest/main      && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/nginx/latest/php       && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/nginx/latest/rtmp-hls  && pwd && make build && make deploy

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
	make ecosystem-pyhton-images
	make ecosystem-debian-images

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
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/latest           && pwd && make build && make deploy
#	cd `pwd`/linux/ecosystem/atlassian/confluence/latest          && pwd && make build && make deploy
##	cd `pwd`/linux/ecosystem/atlassian/crucible/latest            && pwd && make build && make deploy
##	cd `pwd`/linux/ecosystem/atlassian/fisheye/latest             && pwd && make build && make deploy
#	cd `pwd`/linux/ecosystem/atlassian/fisheye-crucible/latest    && pwd && make build && make deploy
#	cd `pwd`/linux/ecosystem/atlassian/jira/latest                && pwd && make build && make deploy

	cd `pwd`/linux/ecosystem/atlassian/bitbucket/8/8.0.0    && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/8/8.0.3    && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/8/8.1.0    && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/8/8.1.3    && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/8/8.2.0    && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/8/8.2.2    && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/8/8.3.0    && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/8/8.3.1    && pwd && make build && make deploy



bundle-web:
	@echo "======================================="
	@echo "=====   Building    web    images ====="
	@echo "======================================="
	make ecosystem-php-images
	make ecosystem-apache2-images
	make ecosystem-nginx-images

buldle-perforce:
	@echo "======================================="
	@echo "=====   Building  Perforce images ====="
	@echo "======================================="
	make ecosystem-perforce-base-images
	make ecosystem-p4p-images

echo-done:
	@echo "======================================="
	@echo "=====           D O N E           ====="
	@echo "======================================="