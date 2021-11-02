all: app

app:
	make sync
	make patch
	make build
	make push
	make clean

sync:
	rm -rfv redash-repo
	git submodule init
	git submodule update --init --recursive
	git submodule sync --recursive

patch:
	sed -i -e 's/# ldap3==2.2.4/ldap3==2.2.4/g' ./redash-repo/requirements.txt

build:
	docker-compose build --compress --parallel

push:
	docker-compose push

clean:
	rm -rfv redash-repo
	docker container prune -f
	docker image prune -f
	docker network prune -f
	docker volume prune -f
	docker system prune -af
