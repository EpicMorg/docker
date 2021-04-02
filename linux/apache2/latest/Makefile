all: apache2
apache2:
	docker build --compress -t epicmorg/apache2:latest .
	docker push  epicmorg/apache2:latest

	docker tag epicmorg/apache2:latest epicmorg/websites:latest
	docker push epicmorg/websites:latest