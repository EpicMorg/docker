# Compose example

```yml
version: '3.7'
services:
  balancer:
    image: epicmorg/balancer
    restart: unless-stopped
    ports:
      - "0.0.0.0:80:80"
      - "0.0.0.0:443:443"
    volumes:
      - /etc/localtime:/etc/localtime
      - /etc/timezone:/etc/timezone
      - /etc/letsencrypt:/etc/letsencrypt
      - nginx:/etc/nginx
      - nginx-usr:/usr/share/nginx/html
      - /var/lib/nginx
#    extra_hosts:
#      - "example.com:192.168.0.11"
    depends_on:
      - websites
    tmpfs:
      - /tmp
volumes:
  nginx:
    external: true
  nginx-usr:
    external: true
```
