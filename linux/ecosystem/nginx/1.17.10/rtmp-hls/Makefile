PIP_BREAK_SYSTEM_PACKAGES=1

all: app

app:
	make build
	make deploy
	make clean

build:
	make pip
	kaniko-wrapper --version

dry:
	make dry-run

test:
	make dry-run

dry-run:
	kaniko-wrapper --kaniko-image gcr.io/kaniko-project/executor:v1.23.2-debug --dry-run

pip:
	rm -rf /usr/lib/python3.6/EXTERNALLY-MANAGED
	rm -rf /usr/lib/python3.7/EXTERNALLY-MANAGED
	rm -rf /usr/lib/python3.8/EXTERNALLY-MANAGED
	rm -rf /usr/lib/python3.9/EXTERNALLY-MANAGED
	rm -rf /usr/lib/python3.9/EXTERNALLY-MANAGED
	rm -rf /usr/lib/python3.11/EXTERNALLY-MANAGED
	rm -rf /usr/lib/python3.12/EXTERNALLY-MANAGED
	rm -rf /usr/lib/python3.13/EXTERNALLY-MANAGED
	pip3 install -r requirements.txt
	pip install -r requirements.txt

build-compose:
	docker-compose build --compress --parallel --progress plain

deploy:
	make pip
	kaniko-wrapper --deploy --kaniko-image gcr.io/kaniko-project/executor:v1.23.2-debug

deploy-compose:
	docker-compose push

clean:
	docker container prune -f
	docker image prune -f
	docker network prune -f
	docker volume prune -f
	docker system prune -af
