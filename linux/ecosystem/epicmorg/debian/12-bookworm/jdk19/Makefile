all: app

app:
	make build
	make deploy
	make clean

build:
	make pip
	python3 kaniko-build.py --version

dry:
	make dry-run

test:
	make dry-run

dry-run:
	python3 kaniko-build.py --kaniko-image gcr.io/kaniko-project/executor:v1.23.0-debug --dry-run

pip:
	rm -rf /usr/lib/python3.9/EXTERNALLY-MANAGED
	rm -rf /usr/lib/python3.11/EXTERNALLY-MANAGED
	rm -rf /usr/lib/python3.12/EXTERNALLY-MANAGED
	rm -rf /usr/lib/python3.13/EXTERNALLY-MANAGED
	pip install -r requirements.txt

build-compose:
	docker-compose build --compress --parallel --progress plain

deploy:
	python3 kaniko-build.py --deploy --kaniko-image gcr.io/kaniko-project/executor:v1.23.0-debug

deploy-compose:
	docker-compose push

clean:
	docker container prune -f
	docker image prune -f
	docker network prune -f
	docker volume prune -f
	docker system prune -af
