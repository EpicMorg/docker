## Build info

The [Qbittorrent](https://www.qbittorrent.org/) project aims to provide an open-source software alternative to µTorrent. qBittorrent is based on the Qt toolkit and libtorrent-rasterbar library.

[![qbittorrent](https://github.com/EpicMorg/docker-scripts/raw/master/qbittorrent/qbittorrent-icon.png)](https://www.qbittorrent.org/)


All presented images avalible on our repo in docker hub.

* qbittorrent `latest`, `stable` and `unstable` images are also avalible here.

### Environments

`````
QBT_PROFILES_DIR=/opt/qbittorrent/profiles
QBT_PROFILE_NAME=docker
QBT_PORT_WEBUI=8282
QBT_PORT_NAT=1337
QBT_PORT_TRACKER=9000
`````

### Exampe

``` yaml
version: '3.9'
services:
  qbittorrent:
    image: epicmorg/qbittorrent:latest
    container_name: qbittorrent
    hostname: qbittorrent
    restart: always
    ports:
      - "8282:8282"
      - "1337:1337/udp"
      - "1337:1337/tcp"
      - "9000:9000/udp"
      - "9000:9000/tcp"
    cap_add:
      - ALL
    volumes:
      - /etc/letsencrypt:/etc/letsencrypt
      - /opt/docker/data/qbt/profiles:/opt/qbittorrent/profiles
    environment:
      - QBT_PROFILE_NAME=docker
      - QBT_PORT_WEBUI=8282
      - QBT_PORT_NAT=1337
      - QBT_PORT_TRACKER=9000
    tmpfs:
      - /tmp
```


### Ngnix

```
server {

        listen 443 ssl http2;
        
        server_name torrent.domain.tld;
        
        ssl_certificate /etc/ssl/torrent.domain.tld.fullchain.crt;
        ssl_certificate_key /etc/ssl/torrent.domain.tld.key;

        location / {

            proxy_pass http://qbittorrent:8282;
            proxy_http_version 1.1;

            proxy_set_header   Host               127.0.0.1:8282;
            proxy_set_header   X-Forwarded-Host   $http_host;
            proxy_set_header   X-Forwarded-For    $remote_addr;
            proxy_cookie_path  /                  "/; Secure";

            client_max_body_size        0;

        }
}

```
