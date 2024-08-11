PIP_BREAK_SYSTEM_PACKAGES=1

all: app

app:
	make build
	make deploy
#	make clean

build:
	kaniko-wrapper --version

dry:
	make dry-run

test:
	make dry-run

dry-run:
	kaniko-wrapper --kaniko-image gcr.io/kaniko-project/executor:v1.23.2-debug --dry-run

build-compose:
	docker-compose build --compress --parallel --progress plain

deploy:
	kaniko-wrapper --deploy --kaniko-image gcr.io/kaniko-project/executor:v1.23.2-debug

deploy-compose:
	docker-compose push

#clean:
#	docker container prune -f
#	docker image prune -f
#	docker network prune -f
#	docker volume prune -f
#	docker system prune -af
