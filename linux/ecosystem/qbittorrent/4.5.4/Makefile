PIP_BREAK_SYSTEM_PACKAGES=1

all: app

app:
	make build
	make deploy
	make clean

build:
	make qbt-libtorrent2
	make qbt
	make qbt-libtorrent1

deploy:
	make pip
	python3 kaniko-build.py --deploy --kaniko-image gcr.io/kaniko-project/executor:v1.23.2-debug

deploy-compose:
	docker-compose push

clean:
	docker container prune -f
	docker image prune -f
	docker network prune -f
	docker volume prune -f
	docker system prune -af

qbt:
	docker-compose build --compress --parallel --progress plain qbt
	docker-compose push qbt

qbt-libtorrent2:
	docker-compose build --compress --parallel --progress plain qbt-libtorrent2
	docker-compose push qbt-libtorrent2

qbt-libtorrent1:
	docker-compose build --compress --parallel --progress plain qbt-libtorrent1
	docker-compose push qbt-libtorrent1
