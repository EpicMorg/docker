all: apache2
apache2:
	docker build --compress -t epicmorg/apache2:php7.3 .
	docker push epicmorg/apache2:php7.3

	docker tag epicmorg/apache2:php7.3 epicmorg/websites:php7.3
	docker push epicmorg/websites:php7.3

