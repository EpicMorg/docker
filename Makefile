VERSION                       =  "2026.10.23"
AUTHOR                        =  "EpicMorg"
MODIFIED                      =  "STAM"
DOCKER_SCAN_SUGGEST           = false
PIP_BREAK_SYSTEM_PACKAGES     = 1

# Image builds go through bin/python/cascade.py: every leaf (Dockerfile + docker-compose.yml)
# under the given folders, `make build && make deploy` in its own directory, in version order.
# Groups follow the CI chains (base -> gcc -> runtimes -> apps); a group expects the previous
# ones to be published. linux/obsolete is never built from here, mattermost is the owner's.
#
#   make apps DRY=1                       - only list the leaves
#   make apps NO_DEPLOY=1                 - build without pushing
#   make build P=linux/ecosystem/apps/git - any folder or leaf
#   make apps CASCADE_ARGS='--stop-on-fail --exclude /9\.'
CASCADE       = bin/python/cascade.py
CASCADE_ARGS ?=
CASCADE_FLAGS = --exclude '^linux/ecosystem/apps/mattermost(/|$$)' \
                $(if $(DRY),--dry-run) $(if $(NO_DEPLOY),--no-deploy) $(CASCADE_ARGS)
APPS_DIR      = linux/ecosystem/apps

# base images of one codename, parents first
base-order    = $(wildcard $(addprefix $(1)/,rootfs light main develop-light develop))

BASE_TRIXIE   = $(call base-order,linux/ecosystem/base/debian/13-trixie)
BASE_SID      = $(call base-order,linux/ecosystem/base/debian/sid)
BASE_ASTRA    = $(foreach d,$(sort $(wildcard linux/ecosystem/base/astra/*-alse)),$(call base-order,$(d)))
GCC           = $(APPS_DIR)/gcc
# chain.30-runtimes; nginx/<ver>/main only (the php combos are apps)
RUNTIMES      = $(addprefix $(APPS_DIR)/,python php) $(sort $(wildcard $(APPS_DIR)/nginx/*/main)) \
                $(addprefix $(APPS_DIR)/,java/jdk nodejs dotnet go git git-lfs ansible redis openldap erlang)
# chain.40-apps; parents listed first (cascade.py builds a leaf once, where it first appears)
APPS          = $(APPS_DIR)/nginx $(APPS_DIR)/apache2 \
                $(sort $(wildcard $(APPS_DIR)/testrail/*/main)) $(APPS_DIR)/testrail \
                $(APPS_DIR)/perforce/base $(APPS_DIR)/perforce \
                $(addprefix $(APPS_DIR)/,mongo rabbitmq mysql mariadb freeradius vault postgres postgres-patroni \
                  qbittorrent cassandra) \
                $(APPS_DIR)/teamcity/agent/minimal $(APPS_DIR)/teamcity/agent \
                $(APPS_DIR)/github/runner/minimal $(APPS_DIR)/github/runner \
                $(APPS_DIR)/gitlab/runner/minimal $(APPS_DIR)/gitlab/runner \
                $(addprefix $(APPS_DIR)/,torrserver electron-release-server vk2discord opentracker monero ninjam \
                  telegram pg-upgrade-tool valve enodia supermicro retracker)
# workflows of their own (after the apps chain)
ADVANCED      = $(APPS_DIR)/nextcloud $(APPS_DIR)/teamcity/server \
                linux/advanced/vscode-server linux/advanced/webtlo linux/advanced/zabbix
ATLASSIAN     = $(APPS_DIR)/atlassian
GAMES         = linux/ecosystem/games

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
	@echo "make base                         - build debian 13 trixie: light, main, develop-light, develop."
	@echo "make base-sid | base-astra        - build the sid / Astra Linux bases."
	@echo "make gcc                          - build the gcc toolchains (needs base)."
	@echo "make runtimes                     - build python, php, nginx, jdk, nodejs, dotnet, go, git(-lfs), ansible, redis, openldap, erlang (needs gcc)."
	@echo "make apps                         - build the apps on top of the runtimes (nginx+php, apache2, testrail, perforce, databases, agents, runners, misc)."
	@echo "make advanced                     - build nextcloud, teamcity server, vscode-server, webtlo, zabbix."
	@echo "make atlassian                    - build every Atlassian image (thousands - prefer the atlassian.* workflows)."
	@echo "make games                        - build the game servers."
	@echo "make images                       - base, gcc, runtimes, apps, advanced, games in order."
	@echo "make build P=<folder>             - build every leaf under a folder (or one leaf)."
	@echo "                                    DRY=1 lists the leaves, NO_DEPLOY=1 skips the push, CASCADE_ARGS=... passes options to cascade.py."
	@echo "make experimental                 - build redash and sentry (sync + patch first)."
	@echo "make ansible.gen.all              - regenerate the Atlassian / TestRail images from bin/ansible (ansible.gen.<product> for one)."
	@echo "make docker-compose-install       - local install latest version of docker-compose binary."
	@echo "make docker-compose-update        - update local docker-compose binary."
	@echo "make clean                        - cleanup buildah and docker kitchen."
	@echo "make chmod                        - find and fix chmod of '*.sh' and '*.py' files."

images: base gcc runtimes apps advanced games

base:
	$(CASCADE) $(BASE_TRIXIE) $(CASCADE_FLAGS)

base-sid:
	$(CASCADE) $(BASE_SID) $(CASCADE_FLAGS)

base-astra:
	$(CASCADE) $(BASE_ASTRA) $(CASCADE_FLAGS)

gcc:
	$(CASCADE) $(GCC) $(CASCADE_FLAGS)

runtimes:
	$(CASCADE) $(RUNTIMES) $(CASCADE_FLAGS)

apps:
	$(CASCADE) $(APPS) --exclude '^$(APPS_DIR)/nginx/[^/]+/main$$' $(CASCADE_FLAGS)

advanced:
	$(CASCADE) $(ADVANCED) $(CASCADE_FLAGS)

atlassian:
	$(CASCADE) $(ATLASSIAN) $(CASCADE_FLAGS)

games:
	$(CASCADE) $(GAMES) $(CASCADE_FLAGS)

build:
	@test -n "$(P)" || { echo "usage: make build P=<folder> [DRY=1] [NO_DEPLOY=1]" >&2; exit 2; }
	$(CASCADE) $(P) $(CASCADE_FLAGS)

####################################################################################################################

experimental: experimental-redash experimental-sentry

experimental-redash:
	cd `pwd`/linux/experimental/redash				&& pwd && make sync &&  make patch &&  make build && make deploy

experimental-sentry:
	cd `pwd`/linux/experimental/sentry/latest				&& pwd && make build && make deploy

####################################################################################################################

ANSIBLE_GEN = $(addprefix ansible.gen.,jira confluence crowd crucible fisheye fisheye-crucible bitbucket bamboo mesh testrail)

ansible.gen.all: $(ANSIBLE_GEN)

.PHONY: $(ANSIBLE_GEN)
.PHONY: app version help images base base-sid base-astra gcc runtimes apps advanced atlassian games \
        build experimental experimental-redash experimental-sentry \
        ansible.gen.all

$(ANSIBLE_GEN): ansible.gen.%:
	cd `pwd`/bin/ansible			&& ansible-playbook ./generate.$*.yml

####################################################################################################################

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
	-rm -rfv /usr/lib/python3.15/EXTERNALLY-MANAGED || true
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
