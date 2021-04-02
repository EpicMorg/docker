all: apache2
apache2:
	docker build --compress -t epicmorg/apache2:php7.4 .
	docker push  epicmorg/apache2:php7.4

	docker tag epicmorg/apache2:php7.4 epicmorg/websites:php7.4
	docker push epicmorg/websites:php7.4

