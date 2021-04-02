all: nginx

nginx:
	docker build --compress -t epicmorg/nginx:php .
	docker push epicmorg/nginx:php

	docker tag epicmorg/nginx:php epicmorg/balancer:php
	docker push epicmorg/balancer:php
