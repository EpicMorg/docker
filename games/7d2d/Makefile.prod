build: 
	docker build --tag "7d2d_ds:latest" .

run:
	docker run -itd --name "7d2d-docker" -p 26900-26903:26900-26903/udp -p 26900:26900/tcp -p 8080-8081:8080-8081 -v 7d2dvol:/valve/volume 7d2d_ds:latest

start:
	docker start 7d2d_ds

stop:
	docker stop 7d2d_ds
    
showlog:
	tail -f `find /var/lib/docker/volumes/7d2dvol/_data -name *log -printf "%T+\t%p\n" | sort`
    
showvol:
	ls -laht /var/lib/docker/volumes/7d2dvol/_data
    

