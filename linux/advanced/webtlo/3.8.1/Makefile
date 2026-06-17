all: app

app:
	make pip
	make build
	make deploy
	make clean

build:
	make build-buildah

deploy:
	make deploy-buildah

build-buildah:
	buildah-wrapper --build --squash

deploy-buildah:
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

pip:
	pip3 install --break-system-packages --no-cache-dir kaniko-wrapper buildah-wrapper
	pip install --break-system-packages --no-cache-dir kaniko-wrapper buildah-wrapper