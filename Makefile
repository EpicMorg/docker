VERSION                       =  "2025.04.18"
AUTHOR                        =  "EpicMorg"
MODIFIED                      =  "STAM"
DOCKER_SCAN_SUGGEST           = false
PIP_BREAK_SYSTEM_PACKAGES     = 1

VENV_DIR = venv
PYTHON = $(VENV_DIR)/bin/python
PIP = $(VENV_DIR)/bin/pip

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
	@echo "make experimental-images          - build experimental images."
	@echo "make images                       - build all images."

ansible.gen.jira:
	cd `pwd`/bin/ansible			&& ansible-playbook ./generate.jira.yml

ansible.gen.confluence:
	cd `pwd`/bin/ansible			&& ansible-playbook ./generate.confluence.yml

ansible.gen.crowd:
	cd `pwd`/bin/ansible			&& ansible-playbook ./generate.crowd.yml

ansible.gen.crucible:
	cd `pwd`/bin/ansible			&& ansible-playbook ./generate.crucible.yml

ansible.gen.fisheye:
	cd `pwd`/bin/ansible			&& ansible-playbook ./generate.fisheye.yml

ansible.gen.fisheye-crucible:
	cd `pwd`/bin/ansible			&& ansible-playbook ./generate.fisheye-crucible.yml

ansible.gen.bitbucket:
	cd `pwd`/bin/ansible			&& ansible-playbook ./generate.bitbucket.yml

ansible.gen.testrail:
	cd `pwd`/bin/ansible			&& ansible-playbook ./generate.testrail.yml

pip:
	-rm -rfv /usr/lib/python3.6/EXTERNALLY-MANAGED || true
	-rm -rfv /usr/lib/python3.7/EXTERNALLY-MANAGED || true
	-rm -rfv /usr/lib/python3.8/EXTERNALLY-MANAGED || true
	-rm -rfv /usr/lib/python3.9/EXTERNALLY-MANAGED || true
	-rm -rfv /usr/lib/python3.10/EXTERNALLY-MANAGED || true
	-rm -rfv /usr/lib/python3.11/EXTERNALLY-MANAGED || true
	-rm -rfv /usr/lib/python3.12/EXTERNALLY-MANAGED || true
	-rm -rfv /usr/lib/python3.13/EXTERNALLY-MANAGED || true
	-rm -rfv /usr/lib/python3.14/EXTERNALLY-MANAGED || true
	-pip3 install --break-system-packages -r requirements.txt || true
	-pip install --break-system-packages -r requirements.txt || true

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

clean:
	@make buildah-clean
	@make docker-clean

buildah-clean:
	buildah rm -a
	buildah rmi -a

docker-clean:
	docker container prune -f
	docker image prune -f
	docker network prune -f
	docker volume prune -f
	docker system prune -af

images:
	make advanced-images
	make ecosystem-images
	make experimental-images
#	make clean

advanced-images:
	@echo "======================================="
	@echo "===== Building third-party images ====="
	@echo "======================================="
	make advanced-cassandra-images
	make advanced-teamcity-server-images
	make advanced-nextcloud-all-images
	make advanced-zabbix-images
	make advanced-vscode-server-images

advanced-nextcloud-all-images:
	make advanced-nextcloud-all-latest-images
	make advanced-nextcloud-images
	make advanced-nextcloud-patched-images

advanced-nextcloud-all-latest-images:
	make advanced-nextcloud-pure-latest-images
	make advanced-nextcloud-patched-latest-images

advanced-nextcloud-pure-latest-images:
	cd `pwd`/linux/advanced/nextcloud/pure/latest	  && pwd && make build && make deploy
	@make clean

advanced-nextcloud-patched-latest-images:
	cd `pwd`/linux/advanced/nextcloud/patched/latest	  && pwd && make build && make deploy
	@make clean

advanced-teamcity-server-images:
	cd `pwd`/linux/advanced/teamcity/server/latest	       && pwd && make build && make deploy
	@make clean
	cd `pwd`/linux/advanced/teamcity/server/2025.03        && pwd && make build && make deploy
	@make clean
	cd `pwd`/linux/advanced/teamcity/server/2024.12        && pwd && make build && make deploy
	@make clean
	cd `pwd`/linux/advanced/teamcity/server/2024.07.3      && pwd && make build && make deploy
	@make clean
	cd `pwd`/linux/advanced/teamcity/server/2024.03.3      && pwd && make build && make deploy
	@make clean
	cd `pwd`/linux/advanced/teamcity/server/2023.05.6      && pwd && make build && make deploy
	@make clean
	cd `pwd`/linux/advanced/teamcity/server/2022.10.6      && pwd && make build && make deploy
	@make clean
	cd `pwd`/linux/advanced/teamcity/server/2022.04.7      && pwd && make build && make deploy
	@make clean

advanced-cassandra-images:
	cd `pwd`/linux/advanced/cassandra/3.11       && pwd && make build && make deploy

####################################################################################################################

experimental-images:
	@echo "======================================="
	@echo "===== Building experimental images ====="
	@echo "======================================="
	make experimental-redash-images
	make experimental-sentry-images

experimental-redash-images:
	cd `pwd`/linux/experimental/redash				&& pwd && make sync &&  make patch &&  make build && make deploy

experimental-sentry-images:
	cd `pwd`/linux/experimental/sentry/latest				&& pwd && make sync &&  make patch &&  make build && make deploy

####################################################################################################################

advanced-zabbix-images:
	@echo "======================================="
	@echo "===== Building Zabbix images ====="
	@echo "======================================="
	make advanced-zabbix-latest-images
	make advanced-zabbix-30-images
	make advanced-zabbix-40-images
	make advanced-zabbix-50-images
	make advanced-zabbix-52-images
	make advanced-zabbix-54-images
	make advanced-zabbix-60-images
	make advanced-zabbix-62-images
	make advanced-zabbix-64-images
	make advanced-zabbix-70-images
	make advanced-zabbix-72-images
	make advanced-zabbix-trunk-images

advanced-zabbix-trunk-images:
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
	@make clean

advanced-zabbix-latest-images:
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
	@make clean

advanced-zabbix-30-images:
	cd `pwd`/linux/advanced/zabbix/3.0/agent		      && pwd && make build && make deploy 
	cd `pwd`/linux/advanced/zabbix/3.0/java-gateway   && pwd && make build && make deploy
	cd `pwd`/linux/advanced/zabbix/3.0/proxy-mysql		&& pwd && make build && make deploy
	cd `pwd`/linux/advanced/zabbix/3.0/proxy-sqlite3	&& pwd && make build && make deploy
	cd `pwd`/linux/advanced/zabbix/3.0/server-mysql 	&& pwd && make build && make deploy
	cd `pwd`/linux/advanced/zabbix/3.0/server-pgsql 	&& pwd && make build && make deploy
	cd `pwd`/linux/advanced/zabbix/3.0/snmptraps			&& pwd && make build && make deploy
	cd `pwd`/linux/advanced/zabbix/3.0/web-mysql			&& pwd && make build && make deploy
	cd `pwd`/linux/advanced/zabbix/3.0/web-pgsql			&& pwd && make build && make deploy
	@make clean
	
advanced-zabbix-40-images:
	cd `pwd`/linux/advanced/zabbix/4.0/agent		      && pwd && make build && make deploy
	cd `pwd`/linux/advanced/zabbix/4.0/java-gateway   && pwd && make build && make deploy
	cd `pwd`/linux/advanced/zabbix/4.0/proxy-mysql		&& pwd && make build && make deploy
	cd `pwd`/linux/advanced/zabbix/4.0/proxy-sqlite3	&& pwd && make build && make deploy
	cd `pwd`/linux/advanced/zabbix/4.0/server-mysql	  && pwd && make build && make deploy
	cd `pwd`/linux/advanced/zabbix/4.0/server-pgsql	  && pwd && make build && make deploy
	cd `pwd`/linux/advanced/zabbix/4.0/snmptraps			&& pwd && make build && make deploy
	cd `pwd`/linux/advanced/zabbix/4.0/web-mysql			&& pwd && make build && make deploy
	cd `pwd`/linux/advanced/zabbix/4.0/web-pgsql			&& pwd && make build && make deploy
	@make clean

advanced-zabbix-50-images:
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
	@make clean

advanced-zabbix-52-images:
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
	@make clean

advanced-zabbix-54-images:
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
	@make clean

advanced-zabbix-60-images:
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
	@make clean

advanced-zabbix-62-images:
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
	@make clean

advanced-zabbix-64-images:
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
	@make clean

advanced-zabbix-70-images:
	cd `pwd`/linux/advanced/zabbix/7.0/agent		      && pwd && make build && make deploy
	cd `pwd`/linux/advanced/zabbix/7.0/agent2 		    && pwd && make build && make deploy
	cd `pwd`/linux/advanced/zabbix/7.0/java-gateway   && pwd && make build && make deploy
	cd `pwd`/linux/advanced/zabbix/7.0/proxy-mysql		&& pwd && make build && make deploy
	cd `pwd`/linux/advanced/zabbix/7.0/proxy-sqlite3	&& pwd && make build && make deploy
	cd `pwd`/linux/advanced/zabbix/7.0/server-mysql 	&& pwd && make build && make deploy
	cd `pwd`/linux/advanced/zabbix/7.0/server-pgsql 	&& pwd && make build && make deploy
	cd `pwd`/linux/advanced/zabbix/7.0/snmptraps			&& pwd && make build && make deploy
	cd `pwd`/linux/advanced/zabbix/7.0/web-mysql			&& pwd && make build && make deploy
	cd `pwd`/linux/advanced/zabbix/7.0/web-pgsql			&& pwd && make build && make deploy
	@make clean

advanced-zabbix-72-images:
	cd `pwd`/linux/advanced/zabbix/7.2/agent		      && pwd && make build && make deploy
	cd `pwd`/linux/advanced/zabbix/7.2/agent2 		    && pwd && make build && make deploy
	cd `pwd`/linux/advanced/zabbix/7.2/java-gateway   && pwd && make build && make deploy
	cd `pwd`/linux/advanced/zabbix/7.2/proxy-mysql		&& pwd && make build && make deploy
	cd `pwd`/linux/advanced/zabbix/7.2/proxy-sqlite3	&& pwd && make build && make deploy
	cd `pwd`/linux/advanced/zabbix/7.2/server-mysql 	&& pwd && make build && make deploy
	cd `pwd`/linux/advanced/zabbix/7.2/server-pgsql 	&& pwd && make build && make deploy
	cd `pwd`/linux/advanced/zabbix/7.2/snmptraps			&& pwd && make build && make deploy
	cd `pwd`/linux/advanced/zabbix/7.2/web-mysql			&& pwd && make build && make deploy
	cd `pwd`/linux/advanced/zabbix/7.2/web-pgsql			&& pwd && make build && make deploy
	@make clean

####################################################################################################################

advanced-nextcloud-images:
#	cd `pwd`/linux/advanced/nextcloud/pure/14		  && pwd && make build && make deploy
#	cd `pwd`/linux/advanced/nextcloud/pure/15		  && pwd && make build && make deploy
#	cd `pwd`/linux/advanced/nextcloud/pure/16		  && pwd && make build && make deploy
#	cd `pwd`/linux/advanced/nextcloud/pure/17		  && pwd && make build && make deploy
#	cd `pwd`/linux/advanced/nextcloud/pure/18		  && pwd && make build && make deploy
#	cd `pwd`/linux/advanced/nextcloud/pure/19		  && pwd && make build && make deploy
#	cd `pwd`/linux/advanced/nextcloud/pure/20		  && pwd && make build && make deploy
#	cd `pwd`/linux/advanced/nextcloud/pure/21		  && pwd && make build && make deploy
#	cd `pwd`/linux/advanced/nextcloud/pure/22		  && pwd && make build && make deploy
#	cd `pwd`/linux/advanced/nextcloud/pure/23		  && pwd && make build && make deploy
#	cd `pwd`/linux/advanced/nextcloud/pure/24		  && pwd && make build && make deploy
#	cd `pwd`/linux/advanced/nextcloud/pure/25		  && pwd && make build && make deploy
#	cd `pwd`/linux/advanced/nextcloud/pure/26		  && pwd && make build && make deploy
#	cd `pwd`/linux/advanced/nextcloud/pure/27		  && pwd && make build && make deploy
	cd `pwd`/linux/advanced/nextcloud/pure/28		  && pwd && make build && make deploy
	cd `pwd`/linux/advanced/nextcloud/pure/29		  && pwd && make build && make deploy
	cd `pwd`/linux/advanced/nextcloud/pure/30		  && pwd && make build && make deploy
	cd `pwd`/linux/advanced/nextcloud/pure/31		  && pwd && make build && make deploy
	@make clean

advanced-nextcloud-patched-images:
#	cd `pwd`/linux/advanced/nextcloud/patched/14		  && pwd && make build && make deploy
#	cd `pwd`/linux/advanced/nextcloud/patched/15		  && pwd && make build && make deploy
#	cd `pwd`/linux/advanced/nextcloud/patched/16		  && pwd && make build && make deploy
#	cd `pwd`/linux/advanced/nextcloud/patched/17		  && pwd && make build && make deploy
#	cd `pwd`/linux/advanced/nextcloud/patched/18		  && pwd && make build && make deploy
#	cd `pwd`/linux/advanced/nextcloud/patched/19		  && pwd && make build && make deploy
#	cd `pwd`/linux/advanced/nextcloud/patched/20		  && pwd && make build && make deploy
#	cd `pwd`/linux/advanced/nextcloud/patched/21		  && pwd && make build && make deploy
#	cd `pwd`/linux/advanced/nextcloud/patched/22		  && pwd && make build && make deploy
#	cd `pwd`/linux/advanced/nextcloud/patched/23		  && pwd && make build && make deploy
#	cd `pwd`/linux/advanced/nextcloud/patched/24		  && pwd && make build && make deploy
#	cd `pwd`/linux/advanced/nextcloud/patched/25		  && pwd && make build && make deploy
#	cd `pwd`/linux/advanced/nextcloud/patched/26		  && pwd && make build && make deploy
#	cd `pwd`/linux/advanced/nextcloud/patched/27		  && pwd && make build && make deploy
	cd `pwd`/linux/advanced/nextcloud/patched/28		  && pwd && make build && make deploy
	cd `pwd`/linux/advanced/nextcloud/patched/29		  && pwd && make build && make deploy
	cd `pwd`/linux/advanced/nextcloud/patched/30		  && pwd && make build && make deploy
	cd `pwd`/linux/advanced/nextcloud/patched/31		  && pwd && make build && make deploy
	@make clean

####################################################################################################################

ecosystem-images:
	make bundle-base-images
	make ecosystem-php-images
	make ecosystem-apache2-images
	make ecosystem-testrail-images
	make ecosystem-torrserver-images
	make ecosystem-qbittorrent-images
	make ecosystem-vk2discord-images
	make ecosystem-monero-images
	make ecosystem-ninjam-images
	make ecosystem-postgres-images
	make ecosystem-teamcity-agent-images
	make ecosystem-gitlab-runner-images
	make ecosystem-github-runner-images
#	make ecosystem-nginx-images
#	make advanced-vscode-server-images
#	make bundle-jira
#	make bundle-atlassian-latest

####################################################################################################################

ecosystem-debian-images:
	make ecosystem-debian-squeeze-images
	make ecosystem-debian-wheezy-images
	make ecosystem-debian-jessie-images
	make ecosystem-debian-stretch-images
	make ecosystem-debian-buster-images
	make ecosystem-debian-bullseye-images
	make ecosystem-debian-bookworm-images
	make ecosystem-debian-trixie-images
	make ecosystem-debian-sid-images

####################################################################################################################

ecosystem-debian-squeeze-images:
	make ecosystem-debian-squeeze-base-images
	make ecosystem-debian-squeeze-jdk-images
	make ecosystem-debian-squeeze-nodejs-images

ecosystem-debian-squeeze-base-images:
	cd `pwd`/linux/ecosystem/epicmorg/debian/06-squeeze/slim    && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/epicmorg/debian/06-squeeze/main    && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/epicmorg/debian/06-squeeze/develop    && pwd && make build && make deploy

ecosystem-debian-squeeze-jdk-images:
	cd `pwd`/linux/ecosystem/epicmorg/debian/06-squeeze/jdk/jdk6    && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/epicmorg/debian/06-squeeze/jdk/jdk7    && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/epicmorg/debian/06-squeeze/jdk/jdk8    && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/epicmorg/debian/06-squeeze/jdk/jdk11    && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/epicmorg/debian/06-squeeze/jdk/jdk16    && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/epicmorg/debian/06-squeeze/jdk/jdk17    && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/epicmorg/debian/06-squeeze/jdk/jdk18    && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/epicmorg/debian/06-squeeze/jdk/jdk19    && pwd && make build && make deploy

ecosystem-debian-squeeze-nodejs-images: 
	cd `pwd`/linux/ecosystem/epicmorg/debian/06-squeeze/nodejs/node0.12       && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/epicmorg/debian/06-squeeze/nodejs/node4          && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/epicmorg/debian/06-squeeze/nodejs/node5          && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/epicmorg/debian/06-squeeze/nodejs/node6          && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/epicmorg/debian/06-squeeze/nodejs/node7          && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/epicmorg/debian/06-squeeze/nodejs/node8          && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/epicmorg/debian/06-squeeze/nodejs/node9          && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/epicmorg/debian/06-squeeze/nodejs/node10         && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/epicmorg/debian/06-squeeze/nodejs/node11         && pwd && make build && make deploy

####################################################################################################################

ecosystem-debian-wheezy-images:
	make ecosystem-debian-wheezy-base-images
	@make clean
	make ecosystem-debian-wheezy-jdk-images
	@make clean
	make ecosystem-debian-wheezy-nodejs-images
	@make clean

ecosystem-debian-wheezy-base-images:
	cd `pwd`/linux/ecosystem/epicmorg/debian/07-wheezy/slim    && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/epicmorg/debian/07-wheezy/main    && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/epicmorg/debian/07-wheezy/develop    && pwd && make build && make deploy
	@make clean

ecosystem-debian-wheezy-jdk-images:
	cd `pwd`/linux/ecosystem/epicmorg/debian/07-wheezy/jdk/jdk6    && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/epicmorg/debian/07-wheezy/jdk/jdk7    && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/epicmorg/debian/07-wheezy/jdk/jdk8    && pwd && make build && make deploy
	@make clean
	cd `pwd`/linux/ecosystem/epicmorg/debian/07-wheezy/jdk/jdk11    && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/epicmorg/debian/07-wheezy/jdk/jdk16    && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/epicmorg/debian/07-wheezy/jdk/jdk17    && pwd && make build && make deploy
	@make clean
	cd `pwd`/linux/ecosystem/epicmorg/debian/07-wheezy/jdk/jdk18    && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/epicmorg/debian/07-wheezy/jdk/jdk19    && pwd && make build && make deploy
	@make clean

ecosystem-debian-wheezy-nodejs-images: 
	cd `pwd`/linux/ecosystem/epicmorg/debian/07-wheezy/nodejs/node0.12       && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/epicmorg/debian/07-wheezy/nodejs/node4          && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/epicmorg/debian/07-wheezy/nodejs/node5          && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/epicmorg/debian/07-wheezy/nodejs/node6          && pwd && make build && make deploy
	@make clean
	cd `pwd`/linux/ecosystem/epicmorg/debian/07-wheezy/nodejs/node7          && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/epicmorg/debian/07-wheezy/nodejs/node8          && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/epicmorg/debian/07-wheezy/nodejs/node9          && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/epicmorg/debian/07-wheezy/nodejs/node10         && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/epicmorg/debian/07-wheezy/nodejs/node11         && pwd && make build && make deploy
	@make clean

####################################################################################################################

ecosystem-debian-jessie-images:
	make ecosystem-debian-jessie-base-images
	@make clean
	make ecosystem-debian-jessie-jdk-images
	@make clean
	make ecosystem-debian-jessie-nodejs-images
	@make clean

ecosystem-debian-jessie-base-images:
	cd `pwd`/linux/ecosystem/epicmorg/debian/08-jessie/slim    && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/epicmorg/debian/08-jessie/main    && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/epicmorg/debian/08-jessie/develop    && pwd && make build && make deploy
	@make clean

ecosystem-debian-jessie-jdk-images:
	cd `pwd`/linux/ecosystem/epicmorg/debian/08-jessie/jdk/jdk6    && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/epicmorg/debian/08-jessie/jdk/jdk7    && pwd && make build && make deploy
	@make clean
	cd `pwd`/linux/ecosystem/epicmorg/debian/08-jessie/jdk/jdk8    && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/epicmorg/debian/08-jessie/jdk/jdk11    && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/epicmorg/debian/08-jessie/jdk/jdk16    && pwd && make build && make deploy
	@make clean
	cd `pwd`/linux/ecosystem/epicmorg/debian/08-jessie/jdk/jdk17    && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/epicmorg/debian/08-jessie/jdk/jdk18    && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/epicmorg/debian/08-jessie/jdk/jdk19    && pwd && make build && make deploy
	@make clean
	cd `pwd`/linux/ecosystem/epicmorg/debian/08-jessie/jdk/jdk20    && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/epicmorg/debian/08-jessie/jdk/jdk21    && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/epicmorg/debian/08-jessie/jdk/jdk22    && pwd && make build && make deploy
	@make clean

ecosystem-debian-jessie-nodejs-images: 
	cd `pwd`/linux/ecosystem/epicmorg/debian/08-jessie/nodejs/node0.12       && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/epicmorg/debian/08-jessie/nodejs/node4          && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/epicmorg/debian/08-jessie/nodejs/node5          && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/epicmorg/debian/08-jessie/nodejs/node6          && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/epicmorg/debian/08-jessie/nodejs/node7          && pwd && make build && make deploy
	@make clean
	cd `pwd`/linux/ecosystem/epicmorg/debian/08-jessie/nodejs/node8          && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/epicmorg/debian/08-jessie/nodejs/node9          && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/epicmorg/debian/08-jessie/nodejs/node10         && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/epicmorg/debian/08-jessie/nodejs/node11         && pwd && make build && make deploy
	@make clean
	cd `pwd`/linux/ecosystem/epicmorg/debian/08-jessie/nodejs/node12         && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/epicmorg/debian/08-jessie/nodejs/node13         && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/epicmorg/debian/08-jessie/nodejs/node14         && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/epicmorg/debian/08-jessie/nodejs/node15         && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/epicmorg/debian/08-jessie/nodejs/node16         && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/epicmorg/debian/08-jessie/nodejs/node17         && pwd && make build && make deploy
	@make clean

####################################################################################################################

ecosystem-debian-stretch-images:
	make ecosystem-debian-stretch-base-images
	@make clean
	make ecosystem-debian-stretch-jdk-images
	@make clean
	make ecosystem-debian-stretch-nodejs-images
	@make clean

ecosystem-debian-stretch-base-images:
	cd `pwd`/linux/ecosystem/epicmorg/debian/09-stretch/slim    && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/epicmorg/debian/09-stretch/main    && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/epicmorg/debian/09-stretch/develop    && pwd && make build && make deploy
	@make clean

ecosystem-debian-stretch-jdk-images:
	cd `pwd`/linux/ecosystem/epicmorg/debian/09-stretch/jdk/jdk6    && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/epicmorg/debian/09-stretch/jdk/jdk7    && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/epicmorg/debian/09-stretch/jdk/jdk8    && pwd && make build && make deploy
	@make clean
	cd `pwd`/linux/ecosystem/epicmorg/debian/09-stretch/jdk/jdk11    && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/epicmorg/debian/09-stretch/jdk/jdk16    && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/epicmorg/debian/09-stretch/jdk/jdk17    && pwd && make build && make deploy
	@make clean
	cd `pwd`/linux/ecosystem/epicmorg/debian/09-stretch/jdk/jdk18    && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/epicmorg/debian/09-stretch/jdk/jdk19    && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/epicmorg/debian/09-stretch/jdk/jdk20    && pwd && make build && make deploy
	@make clean
	cd `pwd`/linux/ecosystem/epicmorg/debian/09-stretch/jdk/jdk21    && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/epicmorg/debian/09-stretch/jdk/jdk22    && pwd && make build && make deploy
	@make clean

ecosystem-debian-stretch-nodejs-images:
	cd `pwd`/linux/ecosystem/epicmorg/debian/09-stretch/nodejs/node0.12       && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/epicmorg/debian/09-stretch/nodejs/node4          && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/epicmorg/debian/09-stretch/nodejs/node5          && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/epicmorg/debian/09-stretch/nodejs/node6          && pwd && make build && make deploy
	@make clean
	cd `pwd`/linux/ecosystem/epicmorg/debian/09-stretch/nodejs/node7          && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/epicmorg/debian/09-stretch/nodejs/node8          && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/epicmorg/debian/09-stretch/nodejs/node9          && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/epicmorg/debian/09-stretch/nodejs/node10         && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/epicmorg/debian/09-stretch/nodejs/node11         && pwd && make build && make deploy
	@make clean
	cd `pwd`/linux/ecosystem/epicmorg/debian/09-stretch/nodejs/node12         && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/epicmorg/debian/09-stretch/nodejs/node13         && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/epicmorg/debian/09-stretch/nodejs/node14         && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/epicmorg/debian/09-stretch/nodejs/node15         && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/epicmorg/debian/09-stretch/nodejs/node16         && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/epicmorg/debian/09-stretch/nodejs/node17         && pwd && make build && make deploy
	@make clean

####################################################################################################################

ecosystem-debian-buster-images:
	make ecosystem-debian-buster-base-images
	@make clean
	make ecosystem-debian-buster-jdk-images
	@make clean
	make ecosystem-debian-buster-nodejs-images
	@make clean

ecosystem-debian-buster-base-images:
	cd `pwd`/linux/ecosystem/epicmorg/debian/10-buster/slim    && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/epicmorg/debian/10-buster/main    && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/epicmorg/debian/10-buster/develop    && pwd && make build && make deploy
	@make clean

ecosystem-debian-buster-jdk-images:
	cd `pwd`/linux/ecosystem/epicmorg/debian/10-buster/jdk/jdk6    && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/epicmorg/debian/10-buster/jdk/jdk7    && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/epicmorg/debian/10-buster/jdk/jdk8    && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/epicmorg/debian/10-buster/jdk/jdk11    && pwd && make build && make deploy
	@make clean
	cd `pwd`/linux/ecosystem/epicmorg/debian/10-buster/jdk/jdk16    && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/epicmorg/debian/10-buster/jdk/jdk17    && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/epicmorg/debian/10-buster/jdk/jdk18    && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/epicmorg/debian/10-buster/jdk/jdk19    && pwd && make build && make deploy
	@make clean
	cd `pwd`/linux/ecosystem/epicmorg/debian/10-buster/jdk/jdk20    && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/epicmorg/debian/10-buster/jdk/jdk21    && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/epicmorg/debian/10-buster/jdk/jdk22    && pwd && make build && make deploy
	@make clean

ecosystem-debian-buster-nodejs-images: 
	cd `pwd`/linux/ecosystem/epicmorg/debian/10-buster/nodejs/node0.12       && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/epicmorg/debian/10-buster/nodejs/node4          && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/epicmorg/debian/10-buster/nodejs/node5          && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/epicmorg/debian/10-buster/nodejs/node6          && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/epicmorg/debian/10-buster/nodejs/node7          && pwd && make build && make deploy
	@make clean
	cd `pwd`/linux/ecosystem/epicmorg/debian/10-buster/nodejs/node8          && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/epicmorg/debian/10-buster/nodejs/node9          && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/epicmorg/debian/10-buster/nodejs/node10         && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/epicmorg/debian/10-buster/nodejs/node11         && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/epicmorg/debian/10-buster/nodejs/node12         && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/epicmorg/debian/10-buster/nodejs/node13         && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/epicmorg/debian/10-buster/nodejs/node14         && pwd && make build && make deploy
	@make clean
	cd `pwd`/linux/ecosystem/epicmorg/debian/10-buster/nodejs/node15         && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/epicmorg/debian/10-buster/nodejs/node16         && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/epicmorg/debian/10-buster/nodejs/node17         && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/epicmorg/debian/10-buster/nodejs/node18         && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/epicmorg/debian/10-buster/nodejs/node19         && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/epicmorg/debian/10-buster/nodejs/node20         && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/epicmorg/debian/10-buster/nodejs/node21         && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/epicmorg/debian/10-buster/nodejs/node22         && pwd && make build && make deploy
	@make clean

####################################################################################################################

ecosystem-debian-bullseye-images:
	make ecosystem-debian-bullseye-base-images
	@make clean
	make ecosystem-debian-bullseye-python-images
	@make clean
	make ecosystem-debian-bullseye-dotnet-images
	@make clean
	make ecosystem-debian-bullseye-jdk-images
	@make clean
	make ecosystem-debian-bullseye-nodejs-images
	@make clean

ecosystem-debian-bullseye-base-images:
	cd `pwd`/linux/ecosystem/epicmorg/debian/11-bullseye/slim    && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/epicmorg/debian/11-bullseye/main    && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/epicmorg/debian/11-bullseye/develop    && pwd && make build && make deploy
	@make clean

ecosystem-debian-bullseye-python-images:
	cd `pwd`/linux/ecosystem/epicmorg/debian/11-bullseye/python/2.6  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/epicmorg/debian/11-bullseye/python/2.7  && pwd && make build && make deploy
#	cd `pwd`/linux/ecosystem/epicmorg/debian/11-bullseye/python/3.0  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/epicmorg/debian/11-bullseye/python/3.1  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/epicmorg/debian/11-bullseye/python/3.2  && pwd && make build && make deploy
	@make clean
	cd `pwd`/linux/ecosystem/epicmorg/debian/11-bullseye/python/3.3  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/epicmorg/debian/11-bullseye/python/3.4  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/epicmorg/debian/11-bullseye/python/3.5  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/epicmorg/debian/11-bullseye/python/3.6  && pwd && make build && make deploy
	@make clean
	cd `pwd`/linux/ecosystem/epicmorg/debian/11-bullseye/python/3.7  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/epicmorg/debian/11-bullseye/python/3.8  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/epicmorg/debian/11-bullseye/python/3.9  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/epicmorg/debian/11-bullseye/python/3.10  && pwd && make build && make deploy
	@make clean
	cd `pwd`/linux/ecosystem/epicmorg/debian/11-bullseye/python/3.11  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/epicmorg/debian/11-bullseye/python/3.12  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/epicmorg/debian/11-bullseye/python/3.13  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/epicmorg/debian/11-bullseye/python/3.14  && pwd && make build && make deploy
	@make clean

ecosystem-debian-bullseye-dotnet-images:
	cd `pwd`/linux/ecosystem/epicmorg/debian/11-bullseye/dotnet/lts    && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/epicmorg/debian/11-bullseye/dotnet/sts    && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/epicmorg/debian/11-bullseye/dotnet/dotnet5    && pwd && make build && make deploy
	@make clean
	cd `pwd`/linux/ecosystem/epicmorg/debian/11-bullseye/dotnet/dotnet6    && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/epicmorg/debian/11-bullseye/dotnet/dotnet7    && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/epicmorg/debian/11-bullseye/dotnet/dotnet8    && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/epicmorg/debian/11-bullseye/dotnet/dotnet9    && pwd && make build && make deploy
	@make clean

ecosystem-debian-bullseye-jdk-images:
	cd `pwd`/linux/ecosystem/epicmorg/debian/11-bullseye/jdk/jdk6    && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/epicmorg/debian/11-bullseye/jdk/jdk7    && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/epicmorg/debian/11-bullseye/jdk/jdk8    && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/epicmorg/debian/11-bullseye/jdk/jdk11    && pwd && make build && make deploy
	@make clean
	cd `pwd`/linux/ecosystem/epicmorg/debian/11-bullseye/jdk/jdk16    && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/epicmorg/debian/11-bullseye/jdk/jdk17    && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/epicmorg/debian/11-bullseye/jdk/jdk18    && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/epicmorg/debian/11-bullseye/jdk/jdk19    && pwd && make build && make deploy
	@make clean
	cd `pwd`/linux/ecosystem/epicmorg/debian/11-bullseye/jdk/jdk20    && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/epicmorg/debian/11-bullseye/jdk/jdk21    && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/epicmorg/debian/11-bullseye/jdk/jdk22    && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/epicmorg/debian/11-bullseye/jdk/jdk23    && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/epicmorg/debian/11-bullseye/jdk/jdk24    && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/epicmorg/debian/11-bullseye/jdk/jdk25    && pwd && make build && make deploy
	@make clean

ecosystem-debian-bullseye-nodejs-images: 
	cd `pwd`/linux/ecosystem/epicmorg/debian/11-bullseye/nodejs/node0.12       && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/epicmorg/debian/11-bullseye/nodejs/node4          && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/epicmorg/debian/11-bullseye/nodejs/node5          && pwd && make build && make deploy
	@make clean
	cd `pwd`/linux/ecosystem/epicmorg/debian/11-bullseye/nodejs/node6          && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/epicmorg/debian/11-bullseye/nodejs/node7          && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/epicmorg/debian/11-bullseye/nodejs/node8          && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/epicmorg/debian/11-bullseye/nodejs/node9          && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/epicmorg/debian/11-bullseye/nodejs/node10         && pwd && make build && make deploy
	@make clean
	cd `pwd`/linux/ecosystem/epicmorg/debian/11-bullseye/nodejs/node11         && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/epicmorg/debian/11-bullseye/nodejs/node12         && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/epicmorg/debian/11-bullseye/nodejs/node13         && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/epicmorg/debian/11-bullseye/nodejs/node14         && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/epicmorg/debian/11-bullseye/nodejs/node15         && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/epicmorg/debian/11-bullseye/nodejs/node16         && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/epicmorg/debian/11-bullseye/nodejs/node17         && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/epicmorg/debian/11-bullseye/nodejs/node18         && pwd && make build && make deploy
	@make clean
	cd `pwd`/linux/ecosystem/epicmorg/debian/11-bullseye/nodejs/node19         && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/epicmorg/debian/11-bullseye/nodejs/node20         && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/epicmorg/debian/11-bullseye/nodejs/node21         && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/epicmorg/debian/11-bullseye/nodejs/node22         && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/epicmorg/debian/11-bullseye/nodejs/node23         && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/epicmorg/debian/11-bullseye/nodejs/node24         && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/epicmorg/debian/11-bullseye/nodejs/node25         && pwd && make build && make deploy
	@make clean

####################################################################################################################

ecosystem-debian-bookworm-images:
	make ecosystem-debian-bookworm-base-images
	@make clean
	make ecosystem-debian-bookworm-python-images
	@make clean
	make ecosystem-debian-bookworm-dotnet-images
	@make clean
	make ecosystem-debian-bookworm-jdk-images
	@make clean
	make ecosystem-debian-bookworm-nodejs-images
	@make clean

ecosystem-debian-bookworm-base-images:
	cd `pwd`/linux/ecosystem/epicmorg/debian/12-bookworm/slim    && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/epicmorg/debian/12-bookworm/main    && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/epicmorg/debian/12-bookworm/develop    && pwd && make build && make deploy
	@make clean

ecosystem-debian-bookworm-python-images:
	cd `pwd`/linux/ecosystem/epicmorg/debian/12-bookworm/python/2.6  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/epicmorg/debian/12-bookworm/python/2.7  && pwd && make build && make deploy
#	cd `pwd`/linux/ecosystem/epicmorg/debian/12-bookworm/python/3.0  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/epicmorg/debian/12-bookworm/python/3.1  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/epicmorg/debian/12-bookworm/python/3.2  && pwd && make build && make deploy
	@make clean
	cd `pwd`/linux/ecosystem/epicmorg/debian/12-bookworm/python/3.3  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/epicmorg/debian/12-bookworm/python/3.4  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/epicmorg/debian/12-bookworm/python/3.5  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/epicmorg/debian/12-bookworm/python/3.6  && pwd && make build && make deploy
	@make clean
	cd `pwd`/linux/ecosystem/epicmorg/debian/12-bookworm/python/3.7  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/epicmorg/debian/12-bookworm/python/3.8  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/epicmorg/debian/12-bookworm/python/3.9  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/epicmorg/debian/12-bookworm/python/3.10  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/epicmorg/debian/12-bookworm/python/3.11  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/epicmorg/debian/12-bookworm/python/3.12  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/epicmorg/debian/12-bookworm/python/3.13  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/epicmorg/debian/12-bookworm/python/3.14  && pwd && make build && make deploy
	@make clean

ecosystem-debian-bookworm-dotnet-images:
	cd `pwd`/linux/ecosystem/epicmorg/debian/12-bookworm/dotnet/lts    && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/epicmorg/debian/12-bookworm/dotnet/sts    && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/epicmorg/debian/12-bookworm/dotnet/dotnet5    && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/epicmorg/debian/12-bookworm/dotnet/dotnet6    && pwd && make build && make deploy
	@make clean
	cd `pwd`/linux/ecosystem/epicmorg/debian/12-bookworm/dotnet/dotnet7    && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/epicmorg/debian/12-bookworm/dotnet/dotnet8    && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/epicmorg/debian/12-bookworm/dotnet/dotnet9    && pwd && make build && make deploy
	@make clean

ecosystem-debian-bookworm-jdk-images:
	cd `pwd`/linux/ecosystem/epicmorg/debian/12-bookworm/jdk/jdk6    && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/epicmorg/debian/12-bookworm/jdk/jdk7    && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/epicmorg/debian/12-bookworm/jdk/jdk8    && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/epicmorg/debian/12-bookworm/jdk/jdk11    && pwd && make build && make deploy
	@make clean
	cd `pwd`/linux/ecosystem/epicmorg/debian/12-bookworm/jdk/jdk16    && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/epicmorg/debian/12-bookworm/jdk/jdk17    && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/epicmorg/debian/12-bookworm/jdk/jdk18    && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/epicmorg/debian/12-bookworm/jdk/jdk19    && pwd && make build && make deploy
	@make clean
	cd `pwd`/linux/ecosystem/epicmorg/debian/12-bookworm/jdk/jdk20    && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/epicmorg/debian/12-bookworm/jdk/jdk21    && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/epicmorg/debian/12-bookworm/jdk/jdk22    && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/epicmorg/debian/12-bookworm/jdk/jdk23    && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/epicmorg/debian/12-bookworm/jdk/jdk24    && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/epicmorg/debian/12-bookworm/jdk/jdk25    && pwd && make build && make deploy
	@make clean
	cd `pwd`/linux/ecosystem/epicmorg/debian/12-bookworm/atlassian-sdk  && pwd && make build && make deploy
	@make clean

ecosystem-debian-bookworm-nodejs-images: 
	cd `pwd`/linux/ecosystem/epicmorg/debian/12-bookworm/nodejs/current        && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/epicmorg/debian/12-bookworm/nodejs/lts            && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/epicmorg/debian/12-bookworm/nodejs/node0.12       && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/epicmorg/debian/12-bookworm/nodejs/node4          && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/epicmorg/debian/12-bookworm/nodejs/node5          && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/epicmorg/debian/12-bookworm/nodejs/node6          && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/epicmorg/debian/12-bookworm/nodejs/node7          && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/epicmorg/debian/12-bookworm/nodejs/node8          && pwd && make build && make deploy
	@make clean
	cd `pwd`/linux/ecosystem/epicmorg/debian/12-bookworm/nodejs/node9          && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/epicmorg/debian/12-bookworm/nodejs/node10         && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/epicmorg/debian/12-bookworm/nodejs/node11         && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/epicmorg/debian/12-bookworm/nodejs/node12         && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/epicmorg/debian/12-bookworm/nodejs/node13         && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/epicmorg/debian/12-bookworm/nodejs/node14         && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/epicmorg/debian/12-bookworm/nodejs/node15         && pwd && make build && make deploy
	@make clean
	cd `pwd`/linux/ecosystem/epicmorg/debian/12-bookworm/nodejs/node16         && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/epicmorg/debian/12-bookworm/nodejs/node17         && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/epicmorg/debian/12-bookworm/nodejs/node18         && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/epicmorg/debian/12-bookworm/nodejs/node19         && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/epicmorg/debian/12-bookworm/nodejs/node20         && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/epicmorg/debian/12-bookworm/nodejs/node21         && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/epicmorg/debian/12-bookworm/nodejs/node22         && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/epicmorg/debian/12-bookworm/nodejs/node23         && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/epicmorg/debian/12-bookworm/nodejs/node24         && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/epicmorg/debian/12-bookworm/nodejs/node25         && pwd && make build && make deploy
	@make clean

####################################################################################################################

ecosystem-debian-trixie-images:
	make ecosystem-debian-trixie-base-images
	@make clean
	make ecosystem-debian-trixie-python-images
	@make clean
	make ecosystem-debian-trixie-dotnet-images
	@make clean
	make ecosystem-debian-trixie-jdk-images
	@make clean
	make ecosystem-debian-trixie-nodejs-images
	@make clean

ecosystem-debian-trixie-base-images:
	cd `pwd`/linux/ecosystem/epicmorg/debian/13-trixie/slim    && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/epicmorg/debian/13-trixie/main    && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/epicmorg/debian/13-trixie/develop    && pwd && make build && make deploy
	@make clean

ecosystem-debian-trixie-python-images:
	cd `pwd`/linux/ecosystem/epicmorg/debian/13-trixie/python/3.2  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/epicmorg/debian/13-trixie/python/3.3  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/epicmorg/debian/13-trixie/python/3.4  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/epicmorg/debian/13-trixie/python/3.5  && pwd && make build && make deploy
	@make clean
	cd `pwd`/linux/ecosystem/epicmorg/debian/13-trixie/python/3.6  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/epicmorg/debian/13-trixie/python/3.7  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/epicmorg/debian/13-trixie/python/3.8  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/epicmorg/debian/13-trixie/python/3.9  && pwd && make build && make deploy
	@make clean
	cd `pwd`/linux/ecosystem/epicmorg/debian/13-trixie/python/3.10  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/epicmorg/debian/13-trixie/python/3.11  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/epicmorg/debian/13-trixie/python/3.12  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/epicmorg/debian/13-trixie/python/3.13  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/epicmorg/debian/13-trixie/python/3.14  && pwd && make build && make deploy
	@make clean

ecosystem-debian-trixie-dotnet-images:
	cd `pwd`/linux/ecosystem/epicmorg/debian/13-trixie/dotnet/lts    && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/epicmorg/debian/13-trixie/dotnet/sts    && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/epicmorg/debian/13-trixie/dotnet/dotnet5    && pwd && make build && make deploy
	@make clean
	cd `pwd`/linux/ecosystem/epicmorg/debian/13-trixie/dotnet/dotnet6    && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/epicmorg/debian/13-trixie/dotnet/dotnet7    && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/epicmorg/debian/13-trixie/dotnet/dotnet8    && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/epicmorg/debian/13-trixie/dotnet/dotnet9    && pwd && make build && make deploy
	@make clean

ecosystem-debian-trixie-jdk-images:
	cd `pwd`/linux/ecosystem/epicmorg/debian/13-trixie/jdk/jdk6    && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/epicmorg/debian/13-trixie/jdk/jdk7    && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/epicmorg/debian/13-trixie/jdk/jdk8    && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/epicmorg/debian/13-trixie/jdk/jdk11    && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/epicmorg/debian/13-trixie/jdk/jdk16    && pwd && make build && make deploy
	@make clean
	cd `pwd`/linux/ecosystem/epicmorg/debian/13-trixie/jdk/jdk17    && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/epicmorg/debian/13-trixie/jdk/jdk18    && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/epicmorg/debian/13-trixie/jdk/jdk19    && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/epicmorg/debian/13-trixie/jdk/jdk20    && pwd && make build && make deploy
	@make clean
	cd `pwd`/linux/ecosystem/epicmorg/debian/13-trixie/jdk/jdk21    && pwd && make build && make deploy
		cd `pwd`/linux/ecosystem/epicmorg/debian/13-trixie/jdk/jdk22    && pwd && make build && make deploy
		cd `pwd`/linux/ecosystem/epicmorg/debian/13-trixie/jdk/jdk23    && pwd && make build && make deploy
		cd `pwd`/linux/ecosystem/epicmorg/debian/13-trixie/jdk/jdk24    && pwd && make build && make deploy
		cd `pwd`/linux/ecosystem/epicmorg/debian/13-trixie/jdk/jdk25    && pwd && make build && make deploy
	@make clean

ecosystem-debian-trixie-nodejs-images: 
	cd `pwd`/linux/ecosystem/epicmorg/debian/13-trixie/nodejs/current        && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/epicmorg/debian/13-trixie/nodejs/lts            && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/epicmorg/debian/13-trixie/nodejs/node0.12       && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/epicmorg/debian/13-trixie/nodejs/node4          && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/epicmorg/debian/13-trixie/nodejs/node5          && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/epicmorg/debian/13-trixie/nodejs/node6          && pwd && make build && make deploy
	@make clean
	cd `pwd`/linux/ecosystem/epicmorg/debian/13-trixie/nodejs/node7          && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/epicmorg/debian/13-trixie/nodejs/node8          && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/epicmorg/debian/13-trixie/nodejs/node9          && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/epicmorg/debian/13-trixie/nodejs/node10         && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/epicmorg/debian/13-trixie/nodejs/node11         && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/epicmorg/debian/13-trixie/nodejs/node12         && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/epicmorg/debian/13-trixie/nodejs/node13         && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/epicmorg/debian/13-trixie/nodejs/node14         && pwd && make build && make deploy
	@make clean
	cd `pwd`/linux/ecosystem/epicmorg/debian/13-trixie/nodejs/node15         && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/epicmorg/debian/13-trixie/nodejs/node16         && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/epicmorg/debian/13-trixie/nodejs/node17         && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/epicmorg/debian/13-trixie/nodejs/node18         && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/epicmorg/debian/13-trixie/nodejs/node19         && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/epicmorg/debian/13-trixie/nodejs/node20         && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/epicmorg/debian/13-trixie/nodejs/node21         && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/epicmorg/debian/13-trixie/nodejs/node22         && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/epicmorg/debian/13-trixie/nodejs/node23         && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/epicmorg/debian/13-trixie/nodejs/node24         && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/epicmorg/debian/13-trixie/nodejs/node25         && pwd && make build && make deploy
	@make clean

####################################################################################################################

ecosystem-debian-sid-images:
	make ecosystem-debian-sid-base-images
	@make clean
	make ecosystem-debian-sid-python-images
	@make clean
	make ecosystem-debian-sid-dotnet-images
	@make clean
	make ecosystem-debian-sid-jdk-images
	@make clean
	make ecosystem-debian-sid-nodejs-images
	@make clean

ecosystem-debian-sid-base-images:
	cd `pwd`/linux/ecosystem/epicmorg/debian/sid/slim    && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/epicmorg/debian/sid/main    && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/epicmorg/debian/sid/develop    && pwd && make build && make deploy
	@make clean

ecosystem-debian-sid-python-images:
	cd `pwd`/linux/ecosystem/epicmorg/debian/sid/python/3.2  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/epicmorg/debian/sid/python/3.3  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/epicmorg/debian/sid/python/3.4  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/epicmorg/debian/sid/python/3.5  && pwd && make build && make deploy
	@make clean
	cd `pwd`/linux/ecosystem/epicmorg/debian/sid/python/3.6  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/epicmorg/debian/sid/python/3.7  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/epicmorg/debian/sid/python/3.8  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/epicmorg/debian/sid/python/3.9  && pwd && make build && make deploy
	@make clean
	cd `pwd`/linux/ecosystem/epicmorg/debian/sid/python/3.10  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/epicmorg/debian/sid/python/3.11  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/epicmorg/debian/sid/python/3.12  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/epicmorg/debian/sid/python/3.13  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/epicmorg/debian/sid/python/3.14  && pwd && make build && make deploy
	@make clean

ecosystem-debian-sid-dotnet-images:
	cd `pwd`/linux/ecosystem/epicmorg/debian/sid/dotnet/lts    && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/epicmorg/debian/sid/dotnet/sts    && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/epicmorg/debian/sid/dotnet/dotnet5    && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/epicmorg/debian/sid/dotnet/dotnet6    && pwd && make build && make deploy
	@make clean
	cd `pwd`/linux/ecosystem/epicmorg/debian/sid/dotnet/dotnet7    && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/epicmorg/debian/sid/dotnet/dotnet8    && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/epicmorg/debian/sid/dotnet/dotnet9    && pwd && make build && make deploy
	@make clean

ecosystem-debian-sid-jdk-images:
	cd `pwd`/linux/ecosystem/epicmorg/debian/sid/jdk/jdk6    && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/epicmorg/debian/sid/jdk/jdk7    && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/epicmorg/debian/sid/jdk/jdk8    && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/epicmorg/debian/sid/jdk/jdk11    && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/epicmorg/debian/sid/jdk/jdk16    && pwd && make build && make deploy
	@make clean
	cd `pwd`/linux/ecosystem/epicmorg/debian/sid/jdk/jdk17    && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/epicmorg/debian/sid/jdk/jdk18    && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/epicmorg/debian/sid/jdk/jdk19    && pwd && make build && make deploy
	@make clean
	cd `pwd`/linux/ecosystem/epicmorg/debian/sid/jdk/jdk20    && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/epicmorg/debian/sid/jdk/jdk21    && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/epicmorg/debian/sid/jdk/jdk22    && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/epicmorg/debian/sid/jdk/jdk23    && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/epicmorg/debian/sid/jdk/jdk24    && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/epicmorg/debian/sid/jdk/jdk25    && pwd && make build && make deploy
	@make clean

ecosystem-debian-sid-nodejs-images: 
	cd `pwd`/linux/ecosystem/epicmorg/debian/sid/nodejs/current        && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/epicmorg/debian/sid/nodejs/lts            && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/epicmorg/debian/sid/nodejs/node0.12       && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/epicmorg/debian/sid/nodejs/node4          && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/epicmorg/debian/sid/nodejs/node5          && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/epicmorg/debian/sid/nodejs/node6          && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/epicmorg/debian/sid/nodejs/node7          && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/epicmorg/debian/sid/nodejs/node8          && pwd && make build && make deploy
	@make clean
	cd `pwd`/linux/ecosystem/epicmorg/debian/sid/nodejs/node9          && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/epicmorg/debian/sid/nodejs/node10         && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/epicmorg/debian/sid/nodejs/node11         && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/epicmorg/debian/sid/nodejs/node12         && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/epicmorg/debian/sid/nodejs/node13         && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/epicmorg/debian/sid/nodejs/node14         && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/epicmorg/debian/sid/nodejs/node15         && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/epicmorg/debian/sid/nodejs/node16         && pwd && make build && make deploy
	@make clean
	cd `pwd`/linux/ecosystem/epicmorg/debian/sid/nodejs/node17         && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/epicmorg/debian/sid/nodejs/node18         && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/epicmorg/debian/sid/nodejs/node19         && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/epicmorg/debian/sid/nodejs/node20         && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/epicmorg/debian/sid/nodejs/node21         && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/epicmorg/debian/sid/nodejs/node22         && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/epicmorg/debian/sid/nodejs/node23         && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/epicmorg/debian/sid/nodejs/node24         && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/epicmorg/debian/sid/nodejs/node25         && pwd && make build && make deploy

	@make clean

####################################################################################################################

ecosystem-php-images:
	cd `pwd`/linux/ecosystem/epicmorg/debian/12-bookworm/php/php5.6             && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/epicmorg/debian/12-bookworm/php/php7.0             && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/epicmorg/debian/12-bookworm/php/php7.1             && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/epicmorg/debian/12-bookworm/php/php7.2             && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/epicmorg/debian/12-bookworm/php/php7.3             && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/epicmorg/debian/12-bookworm/php/php7.4             && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/epicmorg/debian/12-bookworm/php/php8.0             && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/epicmorg/debian/12-bookworm/php/php8.1             && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/epicmorg/debian/12-bookworm/php/php8.2             && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/epicmorg/debian/12-bookworm/php/php8.3             && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/epicmorg/debian/12-bookworm/php/php8.4             && pwd && make build && make deploy
	@make clean

testrail-prod:
	cd `pwd`/linux/ecosystem/testrail/5.7.1.4028/main       && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/testrail/5.7.1.4028/ad           && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/testrail/5.7.1.4028/ldap         && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/testrail/6.7.2.1043/main       && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/testrail/6.7.2.1043/ad           && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/testrail/6.7.2.1043/ldap         && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/testrail/7.0.2.1016/main       && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/testrail/7.0.2.1016/ldap       && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/testrail/7.0.2.1016/ad       && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/testrail/7.4.1.8092/main       && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/testrail/7.4.1.8092/ad       && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/testrail/7.4.1.8092/ldap       && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/testrail/7.5.3.1000/main       && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/testrail/7.5.3.1000/ad           && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/testrail/7.5.3.1000/ldap         && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/testrail/8.0.1.1029/main       && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/testrail/8.0.1.1029/ad           && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/testrail/8.0.1.1029/ldap         && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/testrail/8.0.4.7036/main       && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/testrail/8.0.4.7036/ad       && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/testrail/8.0.4.7036/ldap       && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/testrail/8.0.6.1019/main       && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/testrail/8.0.6.1019/ad       && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/testrail/8.0.6.1019/ldap       && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/testrail/8.1.0.6186/main       && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/testrail/8.1.0.6186/ad       && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/testrail/8.1.0.6186/ldap       && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/testrail/9.0.0.1057/main       && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/testrail/9.0.0.1057/ad           && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/testrail/9.0.0.1057/ldap         && pwd && make build && make deploy
	@make clean


ecosystem-apache2-images:
	cd `pwd`/linux/ecosystem/apache2/php5.6         && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/apache2/php7.0         && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/apache2/php7.1         && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/apache2/php7.2         && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/apache2/php7.3         && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/apache2/php7.4         && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/apache2/php8.0         && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/apache2/php8.1         && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/apache2/php8.2         && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/apache2/php8.3         && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/apache2/php8.4         && pwd && make build && make deploy
	@make clean

ecosystem-testrail-images:
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
	cd `pwd`/linux/ecosystem/testrail/8.0.4.7036/main       && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/testrail/8.0.6.1019/main       && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/testrail/8.1.0.6186/main       && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/testrail/9.0.0.1057/main       && pwd && make build && make deploy
	@make clean

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
	cd `pwd`/linux/ecosystem/testrail/8.0.4.7036/ad           && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/testrail/8.0.6.1019/ad           && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/testrail/8.1.0.6186/ad           && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/testrail/9.0.0.1057/ad           && pwd && make build && make deploy
	@make clean
    
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
	cd `pwd`/linux/ecosystem/testrail/8.0.4.7036/ldap         && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/testrail/8.0.6.1019/ldap         && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/testrail/8.1.0.6186/ldap         && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/testrail/9.0.0.1057/ldap         && pwd && make build && make deploy
	@make clean

ecosystem-torrserver-images:
	cd `pwd`/linux/ecosystem/torrserver            && pwd && make build && make deploy

ecosystem-electron-release-server-images:
	cd `pwd`/linux/ecosystem/electron-release-server  && pwd && make build && make deploy

ecosystem-ninjam-images: 
	cd `pwd`/linux/ecosystem/ninjam/latest     && pwd && make build && make deploy

ecosystem-vk2discord-images: 
	cd `pwd`/linux/ecosystem/vk2discord     && pwd && make build && make deploy

ecosystem-qbittorrent-images: 
	cd `pwd`/linux/ecosystem/qbittorrent/4.4.0    && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/qbittorrent/4.4.1    && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/qbittorrent/4.4.2    && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/qbittorrent/4.4.3.1  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/qbittorrent/4.4.4    && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/qbittorrent/4.4.5    && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/qbittorrent/4.5.0    && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/qbittorrent/4.5.1    && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/qbittorrent/4.5.2    && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/qbittorrent/4.5.3    && pwd && make build && make deploy
	@make clean
	cd `pwd`/linux/ecosystem/qbittorrent/4.5.4    && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/qbittorrent/4.5.5    && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/qbittorrent/4.6.0    && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/qbittorrent/4.6.1    && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/qbittorrent/4.6.2    && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/qbittorrent/4.6.3    && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/qbittorrent/4.6.4    && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/qbittorrent/4.6.5    && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/qbittorrent/4.6.6    && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/qbittorrent/4.6.7    && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/qbittorrent/5.0.0    && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/qbittorrent/5.0.1    && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/qbittorrent/5.0.2    && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/qbittorrent/5.0.3    && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/qbittorrent/5.0.4    && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/qbittorrent/5.0.5    && pwd && make build && make deploy
	@make clean
	cd `pwd`/linux/ecosystem/qbittorrent/5.1.0    && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/qbittorrent/5.1.1    && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/qbittorrent/5.1.2    && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/qbittorrent/testing  && pwd && make build && make deploy
	@make clean

ecosystem-retracker-images: 
	cd `pwd`/linux/ecosystem/retracker    && pwd && make build && make deploy

ecosystem-opentracker-images: 
	cd `pwd`/linux/ecosystem/opentracker    && pwd && make build && make deploy

experimental-torrust-tracker-images: 
	cd `pwd`/linux/experimental/torrust-tracker    && pwd && make build && make deploy
	cd `pwd`/linux/experimental/torrust-index    && pwd && make build && make deploy

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
	@make clean
	cd `pwd`/linux/ecosystem/postgres/9.4          && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/postgres/9.5          && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/postgres/9.6          && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/postgres/10           && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/postgres/11           && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/postgres/12           && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/postgres/13           && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/postgres/14           && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/postgres/15           && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/postgres/16           && pwd && make build && make deploy
#	cd `pwd`/linux/ecosystem/postgres/17           && pwd && make build && make deploy
#	cd `pwd`/linux/ecosystem/postgres/18           && pwd && make build && make deploy
	@make clean

ecosystem-teamcity-agent-images:
	cd `pwd`/linux/ecosystem/teamcity/agent/minimal         && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/teamcity/agent/latest         && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/teamcity/agent/amxx-sdk/1.9         && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/teamcity/agent/amxx-sdk/1.10         && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/teamcity/agent/android-sdk         && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/teamcity/agent/atlassian-sdk         && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/teamcity/agent/node0.12         && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/teamcity/agent/node4         && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/teamcity/agent/node5         && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/teamcity/agent/node6         && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/teamcity/agent/node7         && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/teamcity/agent/node8         && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/teamcity/agent/node9         && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/teamcity/agent/node10         && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/teamcity/agent/node11         && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/teamcity/agent/node12         && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/teamcity/agent/node13         && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/teamcity/agent/node14         && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/teamcity/agent/node15         && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/teamcity/agent/node16         && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/teamcity/agent/node17         && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/teamcity/agent/node18         && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/teamcity/agent/node19         && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/teamcity/agent/node20         && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/teamcity/agent/node21         && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/teamcity/agent/node22         && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/teamcity/agent/node23         && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/teamcity/agent/php56         && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/teamcity/agent/php70         && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/teamcity/agent/php71         && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/teamcity/agent/php72         && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/teamcity/agent/php73         && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/teamcity/agent/php74         && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/teamcity/agent/php80         && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/teamcity/agent/php81         && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/teamcity/agent/php82         && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/teamcity/agent/php83         && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/teamcity/agent/php84         && pwd && make build && make deploy

ecosystem-github-runner-images:
	cd `pwd`/linux/ecosystem/github/runner/minimal         && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/github/runner/latest         && pwd && make build && make deploy

ecosystem-gitlab-runner-images:
	cd `pwd`/linux/ecosystem/gitlab/runner/minimal         && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/gitlab/runner/latest         && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/gitlab/runner/amxx-sdk/1.9         && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/gitlab/runner/amxx-sdk/1.10         && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/gitlab/runner/android-sdk         && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/gitlab/runner/atlassian-sdk         && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/gitlab/runner/dotnet-sdk         && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/gitlab/runner/node0.12         && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/gitlab/runner/node4         && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/gitlab/runner/node5         && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/gitlab/runner/node6         && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/gitlab/runner/node7         && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/gitlab/runner/node8         && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/gitlab/runner/node9         && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/gitlab/runner/node10         && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/gitlab/runner/node11         && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/gitlab/runner/node12         && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/gitlab/runner/node13         && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/gitlab/runner/node14         && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/gitlab/runner/node15         && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/gitlab/runner/node16         && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/gitlab/runner/node17         && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/gitlab/runner/node18         && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/gitlab/runner/node19         && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/gitlab/runner/node20         && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/gitlab/runner/node21         && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/gitlab/runner/node22         && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/gitlab/runner/node23         && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/gitlab/runner/php56         && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/gitlab/runner/php70         && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/gitlab/runner/php71         && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/gitlab/runner/php72         && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/gitlab/runner/php73         && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/gitlab/runner/php74         && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/gitlab/runner/php80         && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/gitlab/runner/php81         && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/gitlab/runner/php82         && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/gitlab/runner/php83         && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/gitlab/runner/php84         && pwd && make build && make deploy

ecosystem-nginx-images:
	cd `pwd`/linux/ecosystem/nginx/latest/mainline/main      && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/nginx/latest/mainline/php       && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/nginx/latest/mainline/rtmp-hls  && pwd && make build && make deploy

advanced-vscode-server-images:
	cd `pwd`/linux/advanced/vscode-server/latest         && pwd && make build && make deploy
	cd `pwd`/linux/advanced/vscode-server/amxx/1.9       && pwd && make build && make deploy
	cd `pwd`/linux/advanced/vscode-server/amxx/1.10      && pwd && make build && make deploy
	cd `pwd`/linux/advanced/vscode-server/android        && pwd && make build && make deploy
	@make clean
	cd `pwd`/linux/advanced/vscode-server/cpp            && pwd && make build && make deploy
	cd `pwd`/linux/advanced/vscode-server/nodejs         && pwd && make build && make deploy
	cd `pwd`/linux/advanced/vscode-server/docker         && pwd && make build && make deploy
	cd `pwd`/linux/advanced/vscode-server/dotnet         && pwd && make build && make deploy
	cd `pwd`/linux/advanced/vscode-server/dotnet-full    && pwd && make build && make deploy
	@make clean
	cd `pwd`/linux/advanced/vscode-server/mono           && pwd && make build && make deploy
	cd `pwd`/linux/advanced/vscode-server/devops         && pwd && make build && make deploy
	@make clean

ecosystem-perforce-base-images:
	cd `pwd`/linuxecosystem/perforce/base/r16.2    && pwd && make build && make deploy
	cd `pwd`/linuxecosystem/perforce/base/r17.1    && pwd && make build && make deploy
	cd `pwd`/linuxecosystem/perforce/base/r17.2    && pwd && make build && make deploy
	cd `pwd`/linuxecosystem/perforce/base/r18.1    && pwd && make build && make deploy
	cd `pwd`/linuxecosystem/perforce/base/r18.2    && pwd && make build && make deploy
	@make clean
	cd `pwd`/linuxecosystem/perforce/base/r19.1    && pwd && make build && make deploy
	cd `pwd`/linuxecosystem/perforce/base/r19.2    && pwd && make build && make deploy
	cd `pwd`/linuxecosystem/perforce/base/r20.1    && pwd && make build && make deploy
	cd `pwd`/linuxecosystem/perforce/base/r20.2    && pwd && make build && make deploy
	cd `pwd`/linuxecosystem/perforce/base/r21.1    && pwd && make build && make deploy
	cd `pwd`/linuxecosystem/perforce/base/r21.2    && pwd && make build && make deploy
	@make clean
	cd `pwd`/linuxecosystem/perforce/base/r22.1    && pwd && make build && make deploy
	cd `pwd`/linuxecosystem/perforce/base/r23.1    && pwd && make build && make deploy
	cd `pwd`/linuxecosystem/perforce/base/r23.2    && pwd && make build && make deploy
	cd `pwd`/linuxecosystem/perforce/base/r24.2    && pwd && make build && make deploy
	@make clean

ecosystem-perforce-proxy-images:
	cd `pwd`/linuxecosystem/perforce/p4p/r16.2    && pwd && make build && make deploy
	cd `pwd`/linuxecosystem/perforce/p4p/r17.1    && pwd && make build && make deploy
	cd `pwd`/linuxecosystem/perforce/p4p/r17.2    && pwd && make build && make deploy
	cd `pwd`/linuxecosystem/perforce/p4p/r18.1    && pwd && make build && make deploy
	cd `pwd`/linuxecosystem/perforce/p4p/r18.2    && pwd && make build && make deploy
	cd `pwd`/linuxecosystem/perforce/p4p/r19.1    && pwd && make build && make deploy
	cd `pwd`/linuxecosystem/perforce/p4p/r19.2    && pwd && make build && make deploy
	cd `pwd`/linuxecosystem/perforce/p4p/r20.1    && pwd && make build && make deploy
	@make clean
	cd `pwd`/linuxecosystem/perforce/p4p/r20.2    && pwd && make build && make deploy
	cd `pwd`/linuxecosystem/perforce/p4p/r21.1    && pwd && make build && make deploy
	cd `pwd`/linuxecosystem/perforce/p4p/r21.2    && pwd && make build && make deploy
	cd `pwd`/linuxecosystem/perforce/p4p/r22.1    && pwd && make build && make deploy
	cd `pwd`/linuxecosystem/perforce/p4p/r23.1    && pwd && make build && make deploy
	cd `pwd`/linuxecosystem/perforce/p4p/r23.2    && pwd && make build && make deploy
	cd `pwd`/linuxecosystem/perforce/p4p/r24.2    && pwd && make build && make deploy
	@make clean

ecosystem-bitbucket-1-images:
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/1/1.0.3                && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/1/1.1.2                && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/1/1.2.1                && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/1/1.2.4                && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/1/1.3.1                && pwd && make build && make deploy
	@make clean

ecosystem-bitbucket-2-images:
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/2/2.0.3                 && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/2/2.1.2                 && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/2/2.2.0                 && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/2/2.3.1                 && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/2/2.4.2                 && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/2/2.5.4                 && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/2/2.6.5                 && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/2/2.7.6                 && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/2/2.8.4                 && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/2/2.8.5                 && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/2/2.9.1                 && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/2/2.9.2                 && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/2/2.9.3                 && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/2/2.9.4                 && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/2/2.9.5                 && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/2/2.10.0                && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/2/2.10.1                && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/2/2.10.2                && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/2/2.10.3                && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/2/2.10.4                && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/2/2.10.5                && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/2/2.11.3                && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/2/2.11.4                && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/2/2.11.5                && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/2/2.11.6                && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/2/2.11.7                && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/2/2.11.8                && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/2/2.11.9                && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/2/2.12.0                && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/2/2.12.1                && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/2/2.12.2                && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/2/2.12.3                && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/2/2.12.4                && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/2/2.12.5                && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/2/2.12.6                && pwd && make build && make deploy
	@make clean

ecosystem-bitbucket-3-images:
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/3/3.0.1                 && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/3/3.0.4                 && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/3/3.0.5                 && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/3/3.0.6                 && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/3/3.0.7                 && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/3/3.0.8                 && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/3/3.1.0                 && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/3/3.1.1                 && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/3/3.1.3                 && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/3/3.1.4                 && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/3/3.1.5                 && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/3/3.1.7                 && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/3/3.2.0                 && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/3/3.2.2                 && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/3/3.2.4                 && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/3/3.2.5                 && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/3/3.2.7                 && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/3/3.3.0                 && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/3/3.3.1                 && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/3/3.3.2                 && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/3/3.3.3                 && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/3/3.3.5                 && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/3/3.4.0                 && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/3/3.4.1                 && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/3/3.4.3                 && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/3/3.4.5                 && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/3/3.5.0                 && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/3/3.5.1                 && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/3/3.6.0                 && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/3/3.6.1                 && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/3/3.7.0                 && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/3/3.7.1                 && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/3/3.7.2                 && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/3/3.7.3                 && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/3/3.7.4                 && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/3/3.8.0                 && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/3/3.8.1                 && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/3/3.9.1                 && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/3/3.9.2                 && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/3/3.10.0                && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/3/3.10.2                && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/3/3.10.3                && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/3/3.10.4                && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/3/3.11.0                && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/3/3.11.1                && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/3/3.11.2                && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/3/3.11.3                && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/3/3.11.4                && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/3/3.11.6                && pwd && make build && make deploy
	@make clean

ecosystem-bitbucket-4-images:
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/4/4.0.1                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/4/4.0.2                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/4/4.0.3                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/4/4.0.4                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/4/4.0.6                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/4/4.0.7                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/4/4.0.8                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/4/4.1.0                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/4/4.1.3                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/4/4.1.4                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/4/4.1.6                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/4/4.2.0                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/4/4.2.1                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/4/4.2.2                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/4/4.2.3                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/4/4.3.0                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/4/4.3.1                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/4/4.3.2                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/4/4.3.3                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/4/4.4.0                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/4/4.4.1                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/4/4.4.2                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/4/4.4.4                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/4/4.5.1                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/4/4.5.2                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/4/4.5.3                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/4/4.6.0                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/4/4.6.1                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/4/4.6.2                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/4/4.6.3                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/4/4.6.4                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/4/4.7.1                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/4/4.7.2                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/4/4.8.0                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/4/4.8.1                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/4/4.8.2                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/4/4.8.3                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/4/4.8.4                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/4/4.8.5                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/4/4.8.6                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/4/4.9.0                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/4/4.9.1                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/4/4.10.0                 && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/4/4.10.1                 && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/4/4.10.2                 && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/4/4.11.1                 && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/4/4.11.2                 && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/4/4.12.0                 && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/4/4.12.1                 && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/4/4.13.0                 && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/4/4.13.1                 && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/4/4.14.0                 && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/4/4.14.1                 && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/4/4.14.2                 && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/4/4.14.3                 && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/4/4.14.4                 && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/4/4.14.5                 && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/4/4.14.6                 && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/4/4.14.7                 && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/4/4.14.8                 && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/4/4.14.9                 && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/4/4.14.10                && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/4/4.14.11                && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/4/4.14.12                && pwd && make build && make deploy
	@make clean

ecosystem-bitbucket-5-images:
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/5/5.0.2                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/5/5.0.4                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/5/5.0.5                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/5/5.0.6                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/5/5.0.7                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/5/5.0.8                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/5/5.0.9                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/5/5.0.10                 && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/5/5.1.1                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/5/5.1.2                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/5/5.1.3                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/5/5.1.4                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/5/5.1.5                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/5/5.1.6                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/5/5.1.7                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/5/5.1.8                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/5/5.1.9                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/5/5.2.0                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/5/5.2.1                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/5/5.2.2                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/5/5.2.3                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/5/5.2.4                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/5/5.2.5                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/5/5.2.6                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/5/5.2.7                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/5/5.2.8                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/5/5.3.0                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/5/5.3.1                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/5/5.3.2                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/5/5.3.3                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/5/5.3.4                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/5/5.3.5                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/5/5.3.6                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/5/5.3.7                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/5/5.4.0                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/5/5.4.1                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/5/5.4.2                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/5/5.4.3                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/5/5.4.4                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/5/5.4.6                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/5/5.4.7                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/5/5.4.8                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/5/5.4.9                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/5/5.5.0                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/5/5.5.1                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/5/5.5.2                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/5/5.5.3                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/5/5.5.4                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/5/5.5.5                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/5/5.5.6                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/5/5.5.7                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/5/5.5.8                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/5/5.5.9                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/5/5.6.1                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/5/5.6.2                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/5/5.6.3                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/5/5.6.4                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/5/5.6.5                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/5/5.6.6                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/5/5.7.0                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/5/5.7.1                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/5/5.7.2                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/5/5.7.3                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/5/5.7.4                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/5/5.8.0                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/5/5.8.1                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/5/5.8.2                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/5/5.8.3                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/5/5.8.4                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/5/5.9.0                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/5/5.9.1                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/5/5.9.2                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/5/5.10.0                 && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/5/5.10.1                 && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/5/5.10.2                 && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/5/5.10.3                 && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/5/5.10.4                 && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/5/5.11.1                 && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/5/5.11.2                 && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/5/5.11.3                 && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/5/5.11.4                 && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/5/5.12.0                 && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/5/5.12.1                 && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/5/5.12.2                 && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/5/5.12.3                 && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/5/5.12.4                 && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/5/5.13.0                 && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/5/5.13.1                 && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/5/5.13.3                 && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/5/5.13.4                 && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/5/5.13.5                 && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/5/5.13.6                 && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/5/5.14.0                 && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/5/5.14.1                 && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/5/5.14.2                 && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/5/5.14.3                 && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/5/5.14.4                 && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/5/5.15.0                 && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/5/5.15.1                 && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/5/5.15.2                 && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/5/5.15.3                 && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/5/5.16.0                 && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/5/5.16.1                 && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/5/5.16.2                 && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/5/5.16.3                 && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/5/5.16.4                 && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/5/5.16.5                 && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/5/5.16.6                 && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/5/5.16.7                 && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/5/5.16.8                 && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/5/5.16.9                 && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/5/5.16.10                && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/5/5.16.11                && pwd && make build && make deploy
	@make clean

ecosystem-bitbucket-6-images:
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/6/6.0.0                    && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/6/6.0.1                    && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/6/6.0.2                    && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/6/6.0.3                    && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/6/6.0.4                    && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/6/6.0.5                    && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/6/6.0.6                    && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/6/6.0.7                    && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/6/6.0.9                    && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/6/6.0.10                   && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/6/6.0.11                   && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/6/6.1.0                    && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/6/6.1.1                    && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/6/6.1.2                    && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/6/6.1.3                    && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/6/6.1.4                    && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/6/6.1.5                    && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/6/6.1.6                    && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/6/6.1.7                    && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/6/6.1.8                    && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/6/6.1.9                    && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/6/6.2.0                    && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/6/6.2.1                    && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/6/6.2.2                    && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/6/6.2.3                    && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/6/6.2.4                    && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/6/6.2.5                    && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/6/6.2.6                    && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/6/6.2.7                    && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/6/6.3.0                    && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/6/6.3.1                    && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/6/6.3.2                    && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/6/6.3.3                    && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/6/6.3.4                    && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/6/6.3.5                    && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/6/6.3.6                    && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/6/6.4.0                    && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/6/6.4.1                    && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/6/6.4.2                    && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/6/6.4.3                    && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/6/6.4.4                    && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/6/6.5.1                    && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/6/6.5.2                    && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/6/6.5.3                    && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/6/6.6.0                    && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/6/6.6.1                    && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/6/6.6.2                    && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/6/6.6.3                    && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/6/6.6.4                    && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/6/6.7.0                    && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/6/6.7.1                    && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/6/6.7.2                    && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/6/6.7.3                    && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/6/6.7.4                    && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/6/6.7.5                    && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/6/6.8.0                    && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/6/6.8.1                    && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/6/6.8.2                    && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/6/6.8.3                    && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/6/6.8.4                    && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/6/6.9.0                    && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/6/6.9.1                    && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/6/6.9.2                    && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/6/6.9.3                    && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/6/6.10.0                   && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/6/6.10.1                   && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/6/6.10.2                   && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/6/6.10.3                   && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/6/6.10.4                   && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/6/6.10.5                   && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/6/6.10.7                   && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/6/6.10.8                   && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/6/6.10.9                   && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/6/6.10.10                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/6/6.10.11                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/6/6.10.12                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/6/6.10.13                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/6/6.10.14                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/6/6.10.15                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/6/6.10.16                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/6/6.10.17                  && pwd && make build && make deploy
	@make clean

ecosystem-bitbucket-7-images:
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/7/7.0.0                   && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/7/7.0.1                   && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/7/7.0.2                   && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/7/7.0.3                   && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/7/7.0.4                   && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/7/7.0.5                   && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/7/7.1.0                   && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/7/7.1.1                   && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/7/7.1.2                   && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/7/7.1.3                   && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/7/7.1.4                   && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/7/7.2.0                   && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/7/7.2.1                   && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/7/7.2.2                   && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/7/7.2.3                   && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/7/7.2.4                   && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/7/7.2.5                   && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/7/7.2.6                   && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/7/7.3.0                   && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/7/7.3.1                   && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/7/7.3.2                   && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/7/7.4.0                   && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/7/7.4.1                   && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/7/7.4.2                   && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/7/7.5.0                   && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/7/7.5.1                   && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/7/7.5.2                   && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/7/7.6.0                   && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/7/7.6.1                   && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/7/7.6.2                   && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/7/7.6.3                   && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/7/7.6.4                   && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/7/7.6.5                   && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/7/7.6.6                   && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/7/7.6.7                   && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/7/7.6.8                   && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/7/7.6.9                   && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/7/7.6.10                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/7/7.6.11                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/7/7.6.12                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/7/7.6.13                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/7/7.6.14                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/7/7.6.15                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/7/7.6.16                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/7/7.6.17                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/7/7.6.19                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/7/7.6.20                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/7/7.6.21                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/7/7.6.22                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/7/7.6.23                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/7/7.7.0                   && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/7/7.7.1                   && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/7/7.8.0                   && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/7/7.8.1                   && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/7/7.9.0                   && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/7/7.9.1                   && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/7/7.10.0                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/7/7.10.1                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/7/7.11.1                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/7/7.11.2                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/7/7.12.0                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/7/7.12.1                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/7/7.13.0                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/7/7.13.1                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/7/7.14.0                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/7/7.14.1                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/7/7.14.2                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/7/7.15.0                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/7/7.15.1                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/7/7.15.2                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/7/7.15.3                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/7/7.16.0                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/7/7.16.1                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/7/7.16.2                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/7/7.16.3                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/7/7.17.0                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/7/7.17.1                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/7/7.17.2                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/7/7.17.3                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/7/7.17.4                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/7/7.17.5                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/7/7.17.6                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/7/7.17.7                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/7/7.17.8                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/7/7.17.9                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/7/7.17.10                 && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/7/7.17.11                 && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/7/7.17.12                 && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/7/7.17.13                 && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/7/7.17.14                 && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/7/7.17.15                 && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/7/7.17.16                 && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/7/7.17.17                 && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/7/7.17.18                 && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/7/7.17.19                 && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/7/7.17.20                 && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/7/7.17.21                 && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/7/7.18.0                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/7/7.18.1                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/7/7.18.2                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/7/7.18.3                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/7/7.18.4                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/7/7.19.2                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/7/7.19.3                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/7/7.19.4                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/7/7.19.5                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/7/7.20.0                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/7/7.20.1                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/7/7.20.2                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/7/7.20.3                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/7/7.21.0                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/7/7.21.1                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/7/7.21.2                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/7/7.21.3                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/7/7.21.4                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/7/7.21.5                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/7/7.21.6                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/7/7.21.7                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/7/7.21.8                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/7/7.21.9                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/7/7.21.10                 && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/7/7.21.11                 && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/7/7.21.12                 && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/7/7.21.13                 && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/7/7.21.14                 && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/7/7.21.15                 && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/7/7.21.16                 && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/7/7.21.17                 && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/7/7.21.18                 && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/7/7.21.19                 && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/7/7.21.20                 && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/7/7.21.21                 && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/7/7.21.22                 && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/7/7.21.23                 && pwd && make build && make deploy
	@make clean

ecosystem-bitbucket-8-images:
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/8/8.0.0                   && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/8/8.0.1                   && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/8/8.0.2                   && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/8/8.0.3                   && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/8/8.0.4                   && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/8/8.0.5                   && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/8/8.1.0                   && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/8/8.1.1                   && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/8/8.1.2                   && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/8/8.1.3                   && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/8/8.1.4                   && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/8/8.1.5                   && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/8/8.2.0                   && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/8/8.2.1                   && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/8/8.2.2                   && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/8/8.2.3                   && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/8/8.2.4                   && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/8/8.3.0                   && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/8/8.3.1                   && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/8/8.3.2                   && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/8/8.3.3                   && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/8/8.3.4                   && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/8/8.4.0                   && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/8/8.4.1                   && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/8/8.4.2                   && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/8/8.4.3                   && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/8/8.4.4                   && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/8/8.5.0                   && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/8/8.5.1                   && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/8/8.5.2                   && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/8/8.5.3                   && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/8/8.5.4                   && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/8/8.6.0                   && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/8/8.6.1                   && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/8/8.6.2                   && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/8/8.6.3                   && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/8/8.6.4                   && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/8/8.7.0                   && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/8/8.7.1                   && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/8/8.7.2                   && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/8/8.7.3                   && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/8/8.7.4                   && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/8/8.7.5                   && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/8/8.8.0                   && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/8/8.8.1                   && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/8/8.8.2                   && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/8/8.8.3                   && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/8/8.8.4                   && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/8/8.8.5                   && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/8/8.8.6                   && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/8/8.8.7                   && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/8/8.9.0                   && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/8/8.9.1                   && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/8/8.9.2                   && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/8/8.9.3                   && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/8/8.9.4                   && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/8/8.9.5                   && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/8/8.9.6                   && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/8/8.9.7                   && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/8/8.9.8                   && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/8/8.9.9                   && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/8/8.9.10                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/8/8.9.11                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/8/8.9.12                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/8/8.9.13                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/8/8.9.14                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/8/8.9.15                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/8/8.9.16                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/8/8.9.17                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/8/8.9.18                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/8/8.9.19                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/8/8.9.20                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/8/8.9.21                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/8/8.9.22                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/8/8.10.0                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/8/8.10.1                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/8/8.10.2                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/8/8.10.3                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/8/8.10.4                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/8/8.10.5                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/8/8.10.6                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/8/8.11.0                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/8/8.11.1                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/8/8.11.2                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/8/8.11.3                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/8/8.11.4                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/8/8.11.5                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/8/8.11.6                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/8/8.12.0                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/8/8.12.1                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/8/8.12.2                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/8/8.12.3                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/8/8.12.4                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/8/8.12.5                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/8/8.12.6                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/8/8.13.0                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/8/8.13.1                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/8/8.13.2                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/8/8.13.3                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/8/8.13.4                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/8/8.13.5                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/8/8.13.6                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/8/8.14.0                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/8/8.14.1                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/8/8.14.2                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/8/8.14.3                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/8/8.14.4                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/8/8.14.5                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/8/8.14.6                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/8/8.15.0                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/8/8.15.1                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/8/8.15.2                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/8/8.15.3                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/8/8.15.4                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/8/8.15.5                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/8/8.16.0                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/8/8.16.1                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/8/8.16.2                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/8/8.16.3                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/8/8.16.4                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/8/8.17.0                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/8/8.17.1                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/8/8.17.2                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/8/8.18.0                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/8/8.18.1                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/8/8.19.0                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/8/8.19.1                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/8/8.19.2                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/8/8.19.3                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/8/8.19.4                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/8/8.19.5                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/8/8.19.6                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/8/8.19.7                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/8/8.19.8                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/8/8.19.9                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/8/8.19.10                 && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/8/8.19.11                 && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/8/8.19.12                 && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/8/8.19.13                 && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/8/8.19.14                 && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/8/8.19.15                 && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/8/8.19.16                 && pwd && make build && make deploy
	@make clean

ecosystem-bitbucket-9-images:
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/9/9.0.0                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/9/9.0.1                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/9/9.1.0                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/9/9.1.1                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/9/9.2.0                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/9/9.2.1                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/9/9.3.0                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/9/9.3.1                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/9/9.3.2                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/9/9.4.0                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/9/9.4.1                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/9/9.4.2                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/9/9.4.3                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/9/9.4.4                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/9/9.5.0                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/9/9.5.1                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/9/9.5.2                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/bitbucket/9/9.6.0                  && pwd && make build && make deploy
	@make clean

ecosystem-confluence-4-images:
	cd `pwd`/linux/ecosystem/atlassian/confluence/4/4.0                    && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/confluence/4/4.0.3                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/confluence/4/4.0.4                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/confluence/4/4.0.5                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/confluence/4/4.0.7                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/confluence/4/4.1                    && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/confluence/4/4.1.10                 && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/confluence/4/4.1.2                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/confluence/4/4.1.3                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/confluence/4/4.1.4                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/confluence/4/4.1.5                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/confluence/4/4.1.6                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/confluence/4/4.1.7                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/confluence/4/4.1.9                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/confluence/4/4.2                    && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/confluence/4/4.2.1                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/confluence/4/4.2.11                 && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/confluence/4/4.2.12                 && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/confluence/4/4.2.13                 && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/confluence/4/4.2.2                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/confluence/4/4.2.3                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/confluence/4/4.2.4                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/confluence/4/4.2.5                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/confluence/4/4.2.6                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/confluence/4/4.2.7                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/confluence/4/4.2.8                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/confluence/4/4.3                    && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/confluence/4/4.3.1                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/confluence/4/4.3.2                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/confluence/4/4.3.3                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/confluence/4/4.3.5                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/confluence/4/4.3.6                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/confluence/4/4.3.7                  && pwd && make build && make deploy
	@make clean

ecosystem-confluence-5-images:
	cd `pwd`/linux/ecosystem/atlassian/confluence/5/5.0                    && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/confluence/5/5.0.1                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/confluence/5/5.0.2                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/confluence/5/5.0.3                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/confluence/5/5.1                    && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/confluence/5/5.10.0                 && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/confluence/5/5.10.1                 && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/confluence/5/5.10.2                 && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/confluence/5/5.10.3                 && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/confluence/5/5.10.4                 && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/confluence/5/5.10.6                 && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/confluence/5/5.10.7                 && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/confluence/5/5.10.8                 && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/confluence/5/5.10.9                 && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/confluence/5/5.1.1                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/confluence/5/5.1.2                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/confluence/5/5.1.3                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/confluence/5/5.1.4                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/confluence/5/5.1.5                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/confluence/5/5.2.3                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/confluence/5/5.2.5                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/confluence/5/5.3                    && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/confluence/5/5.3.1                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/confluence/5/5.3.4                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/confluence/5/5.4                    && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/confluence/5/5.4.1                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/confluence/5/5.4.2                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/confluence/5/5.4.3                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/confluence/5/5.4.4                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/confluence/5/5.5                    && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/confluence/5/5.5.1                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/confluence/5/5.5.2                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/confluence/5/5.5.3                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/confluence/5/5.5.6                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/confluence/5/5.5-OD-31-009          && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/confluence/5/5.6.1                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/confluence/5/5.6.3                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/confluence/5/5.6.4                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/confluence/5/5.6.5                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/confluence/5/5.6.6                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/confluence/5/5.7                    && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/confluence/5/5.7.1                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/confluence/5/5.7.3                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/confluence/5/5.7.4                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/confluence/5/5.7.5                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/confluence/5/5.7.6                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/confluence/5/5.8.10                 && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/confluence/5/5.8.13                 && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/confluence/5/5.8.14                 && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/confluence/5/5.8.15                 && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/confluence/5/5.8.16                 && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/confluence/5/5.8.17                 && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/confluence/5/5.8.18                 && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/confluence/5/5.8.2                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/confluence/5/5.8.4                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/confluence/5/5.8.5                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/confluence/5/5.8.6                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/confluence/5/5.8.8                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/confluence/5/5.8.9                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/confluence/5/5.9.1                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/confluence/5/5.9.10                 && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/confluence/5/5.9.11                 && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/confluence/5/5.9.12                 && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/confluence/5/5.9.14                 && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/confluence/5/5.9.1-beta11           && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/confluence/5/5.9.2                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/confluence/5/5.9.3                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/confluence/5/5.9.4                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/confluence/5/5.9.5                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/confluence/5/5.9.6                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/confluence/5/5.9.7                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/confluence/5/5.9.8                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/confluence/5/5.9.9                  && pwd && make build && make deploy
	@make clean

ecosystem-confluence-6-images:
	cd `pwd`/linux/ecosystem/atlassian/confluence/6/6.0.1                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/confluence/6/6.0.2                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/confluence/6/6.0.3                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/confluence/6/6.0.4                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/confluence/6/6.0.5                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/confluence/6/6.0.6                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/confluence/6/6.0.7                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/confluence/6/6.1.0                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/confluence/6/6.10.0                 && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/confluence/6/6.10.1                 && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/confluence/6/6.10.2                 && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/confluence/6/6.10.3                 && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/confluence/6/6.1.1                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/confluence/6/6.11.0                 && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/confluence/6/6.11.1                 && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/confluence/6/6.11.2                 && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/confluence/6/6.1.2                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/confluence/6/6.12.0                 && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/confluence/6/6.12.1                 && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/confluence/6/6.12.2                 && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/confluence/6/6.12.3                 && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/confluence/6/6.12.4                 && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/confluence/6/6.1.3                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/confluence/6/6.13.0                 && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/confluence/6/6.13.1                 && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/confluence/6/6.13.10                && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/confluence/6/6.13.11                && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/confluence/6/6.13.12                && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/confluence/6/6.13.13                && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/confluence/6/6.13.15                && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/confluence/6/6.13.17                && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/confluence/6/6.13.18                && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/confluence/6/6.13.19                && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/confluence/6/6.13.2                 && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/confluence/6/6.13.20                && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/confluence/6/6.13.21                && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/confluence/6/6.13.23                && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/confluence/6/6.13.3                 && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/confluence/6/6.13.4                 && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/confluence/6/6.13.5                 && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/confluence/6/6.13.6                 && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/confluence/6/6.13.7                 && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/confluence/6/6.13.8                 && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/confluence/6/6.13.9                 && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/confluence/6/6.1.4                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/confluence/6/6.14.0                 && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/confluence/6/6.14.1                 && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/confluence/6/6.14.2                 && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/confluence/6/6.14.3                 && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/confluence/6/6.15.1                 && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/confluence/6/6.15.10                && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/confluence/6/6.15.2                 && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/confluence/6/6.15.4                 && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/confluence/6/6.15.6                 && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/confluence/6/6.15.7                 && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/confluence/6/6.15.8                 && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/confluence/6/6.15.9                 && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/confluence/6/6.2.0                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/confluence/6/6.2.1                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/confluence/6/6.2.2                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/confluence/6/6.2.3                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/confluence/6/6.2.4                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/confluence/6/6.3.1                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/confluence/6/6.3.2                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/confluence/6/6.3.3                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/confluence/6/6.3.4                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/confluence/6/6.4.0                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/confluence/6/6.4.1                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/confluence/6/6.4.2                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/confluence/6/6.4.3                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/confluence/6/6.5.0                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/confluence/6/6.5.1                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/confluence/6/6.5.2                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/confluence/6/6.5.3                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/confluence/6/6.6.0                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/confluence/6/6.6.1                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/confluence/6/6.6.10                 && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/confluence/6/6.6.11                 && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/confluence/6/6.6.12                 && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/confluence/6/6.6.13                 && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/confluence/6/6.6.14                 && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/confluence/6/6.6.15                 && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/confluence/6/6.6.16                 && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/confluence/6/6.6.17                 && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/confluence/6/6.6.2                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/confluence/6/6.6.3                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/confluence/6/6.6.4                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/confluence/6/6.6.5                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/confluence/6/6.6.6                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/confluence/6/6.6.7                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/confluence/6/6.6.8                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/confluence/6/6.6.9                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/confluence/6/6.7.0                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/confluence/6/6.7.1                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/confluence/6/6.7.2                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/confluence/6/6.7.3                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/confluence/6/6.8.0                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/confluence/6/6.8.1                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/confluence/6/6.8.2                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/confluence/6/6.8.3                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/confluence/6/6.8.5                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/confluence/6/6.9.0                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/confluence/6/6.9.1                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/confluence/6/6.9.3                  && pwd && make build && make deploy
	@make clean

ecosystem-confluence-7-images:
	cd `pwd`/linux/ecosystem/atlassian/confluence/7/7.0.1                 && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/confluence/7/7.0.2                 && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/confluence/7/7.0.3                 && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/confluence/7/7.0.4                 && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/confluence/7/7.0.5                 && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/confluence/7/7.1.0                 && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/confluence/7/7.10.0                && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/confluence/7/7.10.1                && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/confluence/7/7.10.2                && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/confluence/7/7.1.1                 && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/confluence/7/7.11.0                && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/confluence/7/7.11.1                && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/confluence/7/7.11.2                && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/confluence/7/7.11.3                && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/confluence/7/7.11.6                && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/confluence/7/7.1.2                 && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/confluence/7/7.12.0                && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/confluence/7/7.12.1                && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/confluence/7/7.12.2                && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/confluence/7/7.12.3                && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/confluence/7/7.12.4                && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/confluence/7/7.12.5                && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/confluence/7/7.13.0                && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/confluence/7/7.13.1                && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/confluence/7/7.13.11               && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/confluence/7/7.13.12               && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/confluence/7/7.13.13               && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/confluence/7/7.13.14               && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/confluence/7/7.13.15               && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/confluence/7/7.13.16               && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/confluence/7/7.13.17               && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/confluence/7/7.13.18               && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/confluence/7/7.13.19               && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/confluence/7/7.13.2                && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/confluence/7/7.13.20               && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/confluence/7/7.13.3                && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/confluence/7/7.13.4                && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/confluence/7/7.13.5                && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/confluence/7/7.13.6                && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/confluence/7/7.13.7                && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/confluence/7/7.13.8                && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/confluence/7/7.13.9                && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/confluence/7/7.14.0                && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/confluence/7/7.14.1                && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/confluence/7/7.14.2                && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/confluence/7/7.14.3                && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/confluence/7/7.14.4                && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/confluence/7/7.15.0                && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/confluence/7/7.15.1                && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/confluence/7/7.15.2                && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/confluence/7/7.15.3                && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/confluence/7/7.16.0                && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/confluence/7/7.16.1                && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/confluence/7/7.16.2                && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/confluence/7/7.16.3                && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/confluence/7/7.16.4                && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/confluence/7/7.16.5                && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/confluence/7/7.17.0                && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/confluence/7/7.17.1                && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/confluence/7/7.17.2                && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/confluence/7/7.17.3                && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/confluence/7/7.17.4                && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/confluence/7/7.17.5                && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/confluence/7/7.18.0                && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/confluence/7/7.18.1                && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/confluence/7/7.18.2                && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/confluence/7/7.18.3                && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/confluence/7/7.19.0                && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/confluence/7/7.19.1                && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/confluence/7/7.19.10               && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/confluence/7/7.19.11               && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/confluence/7/7.19.12               && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/confluence/7/7.19.14               && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/confluence/7/7.19.15               && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/confluence/7/7.19.16               && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/confluence/7/7.19.17               && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/confluence/7/7.19.18               && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/confluence/7/7.19.19               && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/confluence/7/7.19.2                && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/confluence/7/7.19.20               && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/confluence/7/7.19.21               && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/confluence/7/7.19.22               && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/confluence/7/7.19.23               && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/confluence/7/7.19.24               && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/confluence/7/7.19.25               && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/confluence/7/7.19.26               && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/confluence/7/7.19.27               && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/confluence/7/7.19.28               && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/confluence/7/7.19.29               && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/confluence/7/7.19.3                && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/confluence/7/7.19.30               && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/confluence/7/7.19.4                && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/confluence/7/7.19.5                && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/confluence/7/7.19.6                && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/confluence/7/7.19.7                && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/confluence/7/7.19.8                && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/confluence/7/7.19.9                && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/confluence/7/7.2.0                 && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/confluence/7/7.20.0                && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/confluence/7/7.20.1                && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/confluence/7/7.20.2                && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/confluence/7/7.20.3                && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/confluence/7/7.2.1                 && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/confluence/7/7.2.2                 && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/confluence/7/7.3.1                 && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/confluence/7/7.3.2                 && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/confluence/7/7.3.3                 && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/confluence/7/7.3.4                 && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/confluence/7/7.3.5                 && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/confluence/7/7.4.0                 && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/confluence/7/7.4.1                 && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/confluence/7/7.4.10                && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/confluence/7/7.4.11                && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/confluence/7/7.4.12                && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/confluence/7/7.4.13                && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/confluence/7/7.4.14                && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/confluence/7/7.4.15                && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/confluence/7/7.4.16                && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/confluence/7/7.4.17                && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/confluence/7/7.4.18                && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/confluence/7/7.4.3                 && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/confluence/7/7.4.4                 && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/confluence/7/7.4.5                 && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/confluence/7/7.4.6                 && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/confluence/7/7.4.7                 && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/confluence/7/7.4.8                 && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/confluence/7/7.4.9                 && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/confluence/7/7.5.0                 && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/confluence/7/7.5.1                 && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/confluence/7/7.5.2                 && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/confluence/7/7.6.0                 && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/confluence/7/7.6.1                 && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/confluence/7/7.6.2                 && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/confluence/7/7.6.3                 && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/confluence/7/7.7.2                 && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/confluence/7/7.7.3                 && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/confluence/7/7.7.4                 && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/confluence/7/7.8.0                 && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/confluence/7/7.8.1                 && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/confluence/7/7.8.3                 && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/confluence/7/7.9.0                 && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/confluence/7/7.9.1                 && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/confluence/7/7.9.3                 && pwd && make build && make deploy
	@make clean

ecosystem-confluence-8-images:
	cd `pwd`/linux/ecosystem/atlassian/confluence/8/8.0.0                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/confluence/8/8.0.1                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/confluence/8/8.0.2                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/confluence/8/8.0.3                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/confluence/8/8.0.4                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/confluence/8/8.1.0                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/confluence/8/8.1.1                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/confluence/8/8.1.3                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/confluence/8/8.1.4                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/confluence/8/8.2.0                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/confluence/8/8.2.1                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/confluence/8/8.2.2                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/confluence/8/8.2.3                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/confluence/8/8.3.0                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/confluence/8/8.3.1                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/confluence/8/8.3.2                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/confluence/8/8.3.3                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/confluence/8/8.3.4                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/confluence/8/8.4.0                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/confluence/8/8.4.1                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/confluence/8/8.4.2                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/confluence/8/8.4.3                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/confluence/8/8.4.4                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/confluence/8/8.4.5                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/confluence/8/8.5.0                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/confluence/8/8.5.1                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/confluence/8/8.5.10                 && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/confluence/8/8.5.11                 && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/confluence/8/8.5.12                 && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/confluence/8/8.5.14                 && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/confluence/8/8.5.15                 && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/confluence/8/8.5.16                 && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/confluence/8/8.5.17                 && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/confluence/8/8.5.18                 && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/confluence/8/8.5.19                 && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/confluence/8/8.5.2                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/confluence/8/8.5.20                 && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/confluence/8/8.5.3                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/confluence/8/8.5.4                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/confluence/8/8.5.5                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/confluence/8/8.5.6                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/confluence/8/8.5.7                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/confluence/8/8.5.8                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/confluence/8/8.5.9                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/confluence/8/8.6.0                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/confluence/8/8.6.1                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/confluence/8/8.6.2                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/confluence/8/8.7.1                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/confluence/8/8.7.2                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/confluence/8/8.8.0                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/confluence/8/8.8.1                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/confluence/8/8.9.0                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/confluence/8/8.9.1                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/confluence/8/8.9.2                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/confluence/8/8.9.3                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/confluence/8/8.9.4                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/confluence/8/8.9.5                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/confluence/8/8.9.6                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/confluence/8/8.9.7                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/confluence/8/8.9.8                  && pwd && make build && make deploy
	@make clean

ecosystem-confluence-9-images:
	cd `pwd`/linux/ecosystem/atlassian/confluence/9/9.0.0                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/confluence/9/9.0.1                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/confluence/9/9.0.2                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/confluence/9/9.0.3                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/confluence/9/9.1.0                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/confluence/9/9.1.1                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/confluence/9/9.2.0                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/confluence/9/9.2.1                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/confluence/9/9.2.2                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/confluence/9/9.3.1                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/confluence/9/9.3.2                  && pwd && make build && make deploy
	@make clean

ecosystem-crowd-0-images:
	cd `pwd`/linux/ecosystem/atlassian/crowd/0/0.3.1                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/crowd/0/0.3.2                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/crowd/0/0.3.3                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/crowd/0/0.4                    && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/crowd/0/0.4.1                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/crowd/0/0.4.2                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/crowd/0/0.4.3                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/crowd/0/0.4.4                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/crowd/0/0.4.5                  && pwd && make build && make deploy
	@make clean

ecosystem-crowd-1-images:
	cd `pwd`/linux/ecosystem/atlassian/crowd/1.0.0                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/crowd/1.0.1                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/crowd/1.0.2                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/crowd/1.0.3                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/crowd/1.0.4                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/crowd/1.0.5                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/crowd/1.0.6                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/crowd/1.0.7                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/crowd/1.1.0                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/crowd/1.1.1                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/crowd/1.1.2                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/crowd/1.2.0                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/crowd/1.2.1                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/crowd/1.2.2                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/crowd/1.2.4                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/crowd/1.3                    && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/crowd/1.3.2                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/crowd/1.3.3                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/crowd/1.4                    && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/crowd/1.4.2                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/crowd/1.4.3                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/crowd/1.4.4                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/crowd/1.4.7                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/crowd/1.4.8                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/crowd/1.5                    && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/crowd/1.5.1                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/crowd/1.5.2                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/crowd/1.5.3                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/crowd/1.6                    && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/crowd/1.6.1                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/crowd/1.6.3                  && pwd && make build && make deploy
	@make clean


ecosystem-crowd-2-images:
	cd `pwd`/linux/ecosystem/atlassian/crowd/2/2.0.0                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/crowd/2/2.0.1                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/crowd/2/2.0.2                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/crowd/2/2.0.3                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/crowd/2/2.0.4                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/crowd/2/2.0.5                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/crowd/2/2.0.6                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/crowd/2/2.0.7                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/crowd/2/2.0.9                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/crowd/2/2.1.0                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/crowd/2/2.1.0-beta4            && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/crowd/2/2.1.1                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/crowd/2/2.1.2                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/crowd/2/2.2.2                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/crowd/2/2.2.4                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/crowd/2/2.2.7                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/crowd/2/2.2.9                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/crowd/2/2.3.1                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/crowd/2/2.3.2                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/crowd/2/2.3.3                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/crowd/2/2.3.4                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/crowd/2/2.3.6                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/crowd/2/2.3.7                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/crowd/2/2.3.9                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/crowd/2/2.4.0                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/crowd/2/2.4.1                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/crowd/2/2.4.2                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/crowd/2/2.4.1                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/crowd/2/2.5.0                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/crowd/2/2.5.1                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/crowd/2/2.5.2                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/crowd/2/2.5.3                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/crowd/2/2.5.4                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/crowd/2/2.5.5                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/crowd/2/2.5.7                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/crowd/2/2.6.0                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/crowd/2/2.6.1                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/crowd/2/2.6.2                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/crowd/2/2.6.3                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/crowd/2/2.6.4                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/crowd/2/2.6.5                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/crowd/2/2.6.7                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/crowd/2/2.7.0                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/crowd/2/2.7.1                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/crowd/2/2.7.2                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/crowd/2/2.8.0                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/crowd/2/2.8.2                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/crowd/2/2.8.3                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/crowd/2/2.8.4                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/crowd/2/2.8.8                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/crowd/2/2.9.1                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/crowd/2/2.9.5                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/crowd/2/2.9.7                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/crowd/2/2.10.1                 && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/crowd/2/2.10.2                 && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/crowd/2/2.10.3                 && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/crowd/2/2.11.0                 && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/crowd/2/2.11.1                 && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/crowd/2/2.11.2                 && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/crowd/2/2.12.0                 && pwd && make build && make deploy
	@make clean


ecosystem-crowd-3-images:
	cd `pwd`/linux/ecosystem/atlassian/crowd/3/3.0.0                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/crowd/3/3.0.1                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/crowd/3/3.0.2                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/crowd/3/3.0.3                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/crowd/3/3.0.5                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/crowd/3/3.1.1                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/crowd/3/3.1.2                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/crowd/3/3.1.3                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/crowd/3/3.1.4                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/crowd/3/3.1.5                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/crowd/3/3.1.6                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/crowd/3/3.2.0                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/crowd/3/3.2.1                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/crowd/3/3.2.2                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/crowd/3/3.2.3                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/crowd/3/3.2.5                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/crowd/3/3.2.6                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/crowd/3/3.2.7                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/crowd/3/3.2.8                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/crowd/3/3.2.11                 && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/crowd/3/3.3.0                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/crowd/3/3.3.2                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/crowd/3/3.3.3                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/crowd/3/3.3.4                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/crowd/3/3.3.5                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/crowd/3/3.3.6                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/crowd/3/3.3.7                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/crowd/3/3.4.0                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/crowd/3/3.4.3                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/crowd/3/3.4.4                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/crowd/3/3.4.5                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/crowd/3/3.4.6                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/crowd/3/3.5.0                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/crowd/3/3.5.1                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/crowd/3/3.6.0                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/crowd/3/3.6.2                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/crowd/3/3.7.0                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/crowd/3/3.7.1                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/crowd/3/3.7.2                  && pwd && make build && make deploy
	@make clean


ecosystem-crowd-4-images:
	cd `pwd`/linux/ecosystem/atlassian/crowd/4/4.0.0                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/crowd/4/4.0.2                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/crowd/4/4.0.3                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/crowd/4/4.0.4                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/crowd/4/4.0.5                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/crowd/4/4.1.0                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/crowd/4/4.1.1                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/crowd/4/4.1.2                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/crowd/4/4.1.3                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/crowd/4/4.1.5                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/crowd/4/4.1.6                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/crowd/4/4.1.8                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/crowd/4/4.1.9                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/crowd/4/4.1.10                 && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/crowd/4/4.2.0                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/crowd/4/4.2.1                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/crowd/4/4.2.2                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/crowd/4/4.2.3                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/crowd/4/4.2.4                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/crowd/4/4.2.5                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/crowd/4/4.3.0                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/crowd/4/4.3.5                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/crowd/4/4.3.7                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/crowd/4/4.3.8                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/crowd/4/4.3.9                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/crowd/4/4.3.10                 && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/crowd/4/4.3.11                 && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/crowd/4/4.4.0                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/crowd/4/4.4.1                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/crowd/4/4.4.2                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/crowd/4/4.4.3                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/crowd/4/4.4.4                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/crowd/4/4.4.5                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/crowd/4/4.4.6                  && pwd && make build && make deploy
	@make clean

ecosystem-crowd-5-images:
	cd `pwd`/linux/ecosystem/atlassian/crowd/5/5.0.0                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/crowd/5/5.0.1                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/crowd/5/5.0.2                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/crowd/5/5.0.3                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/crowd/5/5.0.4                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/crowd/5/5.0.5                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/crowd/5/5.0.6                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/crowd/5/5.0.7                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/crowd/5/5.0.8                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/crowd/5/5.0.9                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/crowd/5/5.0.10                 && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/crowd/5/5.0.11                 && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/crowd/5/5.1.0                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/crowd/5/5.1.1                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/crowd/5/5.1.2                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/crowd/5/5.1.3                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/crowd/5/5.1.4                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/crowd/5/5.1.5                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/crowd/5/5.1.6                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/crowd/5/5.1.7                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/crowd/5/5.1.8                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/crowd/5/5.1.9                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/crowd/5/5.1.11                 && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/crowd/5/5.1.12                 && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/crowd/5/5.1.13                 && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/crowd/5/5.2.0                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/crowd/5/5.2.1                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/crowd/5/5.2.2                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/crowd/5/5.2.3                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/crowd/5/5.2.4                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/crowd/5/5.2.6                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/crowd/5/5.2.7                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/crowd/5/5.2.8                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/crowd/5/5.2.9                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/crowd/5/5.2.10                 && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/crowd/5/5.3.0                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/crowd/5/5.3.1                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/crowd/5/5.3.2                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/crowd/5/5.3.3                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/crowd/5/5.3.4                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/crowd/5/5.3.5                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/crowd/5/5.3.6                  && pwd && make build && make deploy
	@make clean

ecosystem-crowd-6-images:
	cd `pwd`/linux/ecosystem/atlassian/crowd/6/6.0.0                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/crowd/6/6.0.1                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/crowd/6/6.0.2                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/crowd/6/6.0.3                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/crowd/6/6.0.4                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/crowd/6/6.0.6                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/crowd/6/6.0.7                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/crowd/6/6.1.0                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/crowd/6/6.1.1                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/crowd/6/6.1.2                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/crowd/6/6.1.3                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/crowd/6/6.1.4                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/crowd/6/6.2.0                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/crowd/6/6.2.2                  && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/crowd/6/6.2.3                  && pwd && make build && make deploy
	@make clean

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
	@make clean

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
	@make clean

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
	@make clean

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
	@make clean

ecosystem-jira-7-lts-images:
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
	@make clean

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
	cd `pwd`/linux/ecosystem/atlassian/jira/8/8.21.0                && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/jira/8/8.21.1                && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/jira/8/8.22.0                && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/jira/8/8.22.1                && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/jira/8/8.22.2                && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/jira/8/8.22.3                && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/jira/8/8.22.4                && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/jira/8/8.22.6                && pwd && make build && make deploy
	@make clean

ecosystem-jira-8-lts-images:
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
	cd `pwd`/linux/ecosystem/atlassian/jira/8/8.20.25                && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/jira/8/8.20.26                && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/jira/8/8.20.27                && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/jira/8/8.20.28                && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/jira/8/8.20.29                && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/jira/8/8.20.30                && pwd && make build && make deploy
	@make clean


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
	cd `pwd`/linux/ecosystem/atlassian/jira/9/9.10.1                && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/jira/9/9.10.2                && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/jira/9/9.11.0                && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/jira/9/9.11.1                && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/jira/9/9.11.2                && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/jira/9/9.11.3                && pwd && make build && make deploy
	@make clean

ecosystem-jira-9-lts-images:
	cd `pwd`/linux/ecosystem/atlassian/jira/9/9.4.0                && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/jira/9/9.4.1                && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/jira/9/9.4.2                && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/jira/9/9.4.3                && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/jira/9/9.4.4                && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/jira/9/9.4.5                && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/jira/9/9.4.6                && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/jira/9/9.4.7                && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/jira/9/9.4.8                && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/jira/9/9.4.9                && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/jira/9/9.4.10                && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/jira/9/9.4.11                && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/jira/9/9.4.12                && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/jira/9/9.4.14                && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/jira/9/9.4.15                && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/jira/9/9.4.16                && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/jira/9/9.4.17                && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/jira/9/9.4.18                && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/jira/9/9.4.19                && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/jira/9/9.4.20                && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/jira/9/9.4.21                && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/jira/9/9.4.22                && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/jira/9/9.4.23                && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/jira/9/9.4.24                && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/jira/9/9.4.25                && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/jira/9/9.4.26                && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/jira/9/9.4.27                && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/jira/9/9.4.28                && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/jira/9/9.4.29                && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/jira/9/9.4.30                && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/jira/9/9.12.0                && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/jira/9/9.12.1                && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/jira/9/9.12.2                && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/jira/9/9.12.3                && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/jira/9/9.12.4                && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/jira/9/9.12.5                && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/jira/9/9.12.6                && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/jira/9/9.12.7                && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/jira/9/9.12.8                && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/jira/9/9.12.9                && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/jira/9/9.12.10               && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/jira/9/9.12.11               && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/jira/9/9.12.12               && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/jira/9/9.12.13               && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/jira/9/9.12.14               && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/jira/9/9.12.15               && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/jira/9/9.12.16               && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/jira/9/9.12.17               && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/jira/9/9.12.18               && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/jira/9/9.12.19               && pwd && make build && make deploy
	@make clean

ecosystem-jira-10-images:
	cd `pwd`/linux/ecosystem/atlassian/jira/10/10.0.0             && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/jira/10/10.0.1             && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/jira/10/10.1.1             && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/jira/10/10.1.2             && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/jira/10/10.2.0             && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/jira/10/10.2.1             && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/jira/10/10.3.0             && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/jira/10/10.3.1             && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/jira/10/10.3.2             && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/jira/10/10.3.3             && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/jira/10/10.3.4             && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/jira/10/10.4.0             && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/jira/10/10.4.1             && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/atlassian/jira/10/10.5.0             && pwd && make build && make deploy
	@make clean


ecosystem-mattermost-images:
	make ecosystem-mattermost-images-11
	@make clean
	make ecosystem-mattermost-images-10
	@make clean

ecosystem-mattermost-images-11:
	cd `pwd`/linux/ecosystem/mattermost/11/11-stable	&& pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/mattermost/11/11.1			&& pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/mattermost/11/11.0			&& pwd && make build && make deploy

ecosystem-mattermost-images-10:
	cd `pwd`/linux/ecosystem/mattermost/10/10-stable	&& pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/mattermost/10/10.12		&& pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/mattermost/10/10.11		&& pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/mattermost/10/10.10		&& pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/mattermost/10/10.9			&& pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/mattermost/10/10.8			&& pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/mattermost/10/10.7			&& pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/mattermost/10/10.6			&& pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/mattermost/10/10.5			&& pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/mattermost/10/10.4			&& pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/mattermost/10/10.3			&& pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/mattermost/10/10.2			&& pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/mattermost/10/10.1			&& pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/mattermost/10/10.0			&& pwd && make build && make deploy


bundle-base-images:
	@echo "======================================="
	@echo "===== Building  EpicMorg   images ====="
	@echo "======================================="
#	make advanced-pyhton-images
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

bundle-confluence:
	@echo "======================================="
	@echo "===== Building  All Confluence  images  ====="
	@echo "======================================="
#	make ecosystem-confluence-1-images
#	make ecosystem-confluence-2-images
#	make ecosystem-confluence-3-images
	make ecosystem-confluence-4-images
	make ecosystem-confluence-5-images
	make ecosystem-confluence-6-images
	make ecosystem-confluence-7-images
	make ecosystem-confluence-8-images
	make ecosystem-confluence-9-images

bundle-crowd:
	@echo "======================================="
	@echo "===== Building  All Crowd  images  ====="
	@echo "======================================="
	make ecosystem-crowd-0-images
	make ecosystem-crowd-1-images
	make ecosystem-crowd-2-images
	make ecosystem-crowd-3-images
	make ecosystem-crowd-4-images
	make ecosystem-crowd-5-images
	make ecosystem-crowd-6-images

bundle-bitbucket:
	@echo "======================================="
	@echo "===== Building  All Bitbucket  images  ====="
	@echo "======================================="
	make ecosystem-bitbucket-1-images
	make ecosystem-bitbucket-2-images
	make ecosystem-bitbucket-3-images
	make ecosystem-bitbucket-4-images
	make ecosystem-bitbucket-5-images
	make ecosystem-bitbucket-6-images
	make ecosystem-bitbucket-7-images
	make ecosystem-bitbucket-8-images
	make ecosystem-bitbucket-9-images

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
	make ecosystem-jira-10-images

bundle-atlassian-latest:
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
	make bundle-bitbucket
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
 
bundle-python:
	@echo "=============================================="
	@echo "===== Building  EpicMorg Python images  ====="
	@echo "=============================================="
#	make ecosystem-debian-bullseye-python-images
#	make ecosystem-debian-bookworm-python-images
	make ecosystem-debian-trixie-python-images
	make ecosystem-debian-sid-python-images

develop:
	cd `pwd`/linux/ecosystem/epicmorg/debian/11-bullseye/develop    && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/epicmorg/debian/12-bookworm/develop    && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/epicmorg/debian/13-trixie/develop    && pwd && make build && make deploy
	cd `pwd`/linux/ecosystem/epicmorg/debian/sid/develop    && pwd && make build && make deploy