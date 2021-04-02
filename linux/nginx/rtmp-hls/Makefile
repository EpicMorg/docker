all: nginx

nginx:
	docker build --compress -t epicmorg/nginx:rtmp-hls .
	docker push epicmorg/nginx:rtmp-hls

	docker tag epicmorg/nginx:rtmp-hls epicmorg/balancer:rtmp-hls
	docker push epicmorg/balancer:rtmp-hls
