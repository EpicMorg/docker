all: apache2
apache2:
	docker build --compress -t epicmorg/apache2:php7.2 .
	docker push epicmorg/apache2:php7.2
	docker push epicmorg/websites:php7.2
