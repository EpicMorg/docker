all: emgqb
emgqb:
	docker build --compress -t epicmorg/qbittorrent:latest .
	docker push epicmorg/qbittorrent:latest
	docker build --compress -t epicmorg/qbittorrent:unstable .
	docker push epicmorg/qbittorrent:unstable
