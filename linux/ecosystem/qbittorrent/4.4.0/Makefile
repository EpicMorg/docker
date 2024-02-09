all: app

app:
	make build
	make deploy
	make clean

build:
	make qbt-libtorrent2
	make qbt-libtorrent1

deploy:
	docker-compose push

clean:
	docker container prune -f
	docker image prune -f
	docker network prune -f
	docker volume prune -f
	docker system prune -af

qbt-libtorrent2:
	docker-compose build --compress --parallel --progress plain qbt-libtorrent2
	docker-compose push qbt-libtorrent2

qbt-libtorrent1:
	docker-compose build --compress --parallel --progress plain qbt-libtorrent1
	docker-compose push qbt-libtorrent1
