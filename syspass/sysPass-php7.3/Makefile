all: spphp
spphp:
	docker build --compress -t epicmorg/syspass:php7.3 .
	docker push epicmorg/syspass:php7.3

	docker build --compress -t epicmorg/syspass:latest .
	docker push epicmorg/syspass:latest
