all: app

app:
	make build
	make deploy
	make clean

build:
	make qbt-latest
	make qbt-unstable
	make qbt-stable

deploy:
	docker-compose push

clean:
	docker container prune -f
	docker image prune -f
	docker network prune -f
	docker volume prune -f
	docker system prune -af

qbt-latest:
	docker-compose build --compress --parallel --progress plain qbt-latest
	docker-compose push qbt-latest


qbt-unstable:
	docker-compose build --compress --parallel --progress plain qbt-unstable
	docker-compose push qbt-unstable

qbt-stable:
	docker-compose build --compress --parallel --progress plain qbt-stable
	docker-compose push qbt-stable
