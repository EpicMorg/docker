all: nginx

nginx:
	docker build --compress -t epicmorg/nginx:latest .
	docker push epicmorg/nginx:latest
	docker push epicmorg/balancer:latest