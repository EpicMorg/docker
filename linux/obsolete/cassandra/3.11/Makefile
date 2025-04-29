PIP_BREAK_SYSTEM_PACKAGES=1

all: app

app:
	make build
	make deploy
	make clean

build:
	buildah-wrapper --build --squash

deploy:
	buildah-wrapper --deploy

build-kaniko:
	kaniko-wrapper --kaniko-image gcr.io/kaniko-project/executor:debug --dry-run

deploy-kaniko:
	kaniko-wrapper --deploy --kaniko-image gcr.io/kaniko-project/executor:debug

build-compose:
	docker-compose build --compress --parallel --progress plain

deploy-compose:
	docker-compose push

clean:
	docker container prune -f
	docker image prune -f
	docker network prune -f
	docker volume prune -f
	docker system prune -af
	buildah rm -a
	buildah rmi -a
