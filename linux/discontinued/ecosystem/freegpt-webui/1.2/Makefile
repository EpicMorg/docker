PIP_BREAK_SYSTEM_PACKAGES=1

all: app

app:
	make build
	make deploy
	make clean

build:
	docker-compose build --compress --no-cache  --progress plain

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
