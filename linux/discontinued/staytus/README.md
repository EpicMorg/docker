## Info
This is a custom improved image from this [original repository](https://github.com/adamcooke/staytus).

## How to
* Install databese and setup user
* Install container and connect to database
* dont forget about static files! `/opt/staytus/public/assets`

## Compose example

```yml
services:
  mysql:
    container_name: mysql
    image: mysql:5.7
    restart: always
  staytus:
    container_name: staytus
    image: epicmorg/staytus
    restart: always
    ports:
      - "5000:5000"
    volumes:
      - staytus-persisted:/opt/staytus/persisted
    environment:
      - DB_USER=root
      - DB_PASSWORD=password
      - DB_HOST=mysql #(dns or ip)
    depends_on:
      - mysql
    tmpfs:
      - /tmp
volumes:
  staytus-persisted:
    external: true
```
