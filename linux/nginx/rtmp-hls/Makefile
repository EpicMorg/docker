all: nginx

nginx:
	docker build --compress -t epicmorg/nginx:rtmp-hls .
	docker push epicmorg/nginx:rtmp-hls
	docker push epicmorg/balancer:rtmp-hls