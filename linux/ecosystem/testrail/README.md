## Testrail

# Compose example

```yml
  testrail-latest-core:
    container_name: testrail-latest-core
    hostname: testrail-latest-core
    image: epicmorg/testrail:latest
    restart: always
    ports:
        - "80:80"
    volumes:
      - /mnt/lvm/apps/testrail-latest/core/custom/auth/auth.php:/var/www/testrail/custom/auth/auth.php:ro
      - /mnt/lvm/apps/testrail-latest/core/attachments:/opt/testrail/attachments
      - /mnt/lvm/apps/testrail-latest/core/audit:/opt/testrail/audit
      - /mnt/lvm/apps/testrail-latest/core/logs:/opt/testrail/logs
      - /mnt/lvm/apps/testrail-latest/core/reports:/opt/testrail/reports
      - /mnt/lvm/apps/testrail-latest/core/www/config:/var/www/testrail/config
    depends_on:
      - testrail-latest-mysql
      - testrail-latest-rabbitmq
      - testrail-latest-cassandra
    environment:
      - TR_DEFAULT_TASK_EXECUTION=5

  testrail-latest-mysql:
    container_name: testrail-latest-mysql
    hostname: testrail-latest-mysql
    image: mysql:8
    ports:
        - "3306:3306"
    volumes:
      - /mnt/lvm/apps/testrail-latest/mysql8.0/etc/mysql/my.cnf:/etc/mysql/my.cnf
      - /mnt/lvm/apps/testrail-latest/mysql8.0/var/lib/mysql:/var/lib/mysql
      - /mnt/lvm/apps/testrail-latest/mysql8.0/var/lib/mysql-files:/var/lib/mysql-files
      - /mnt/lvm/apps/testrail-latest/mysql8.0/var/log/mysql:/var/log/mysql
    restart: always
    environment:
      INIT_TOKUDB: 1
      MYSQL_ROOT_PASSWORD: password

  testrail-latest-cassandra:
    container_name: testrail-latest-cassandra
    hostname: cassandra
    image: epicmorg/cassandra:3.11
    ulimits:
      memlock: -1
      nproc: 1048575
      nofile: 100000
    volumes:
      - /etc/localtime:/etc/localtime:ro
      - /etc/timezone:/etc/timezone:ro
      - /mnt/lvm/apps/testrail-latest/cassandra/bitnami:/bitnami
    environment:
      - CASSANDRA_SEEDS=user
      - CASSANDRA_PASSWORD_SEEDER=yes
      - CASSANDRA_PASSWORD=password
    restart: always

  testrail-latest-rabbitmq:
    image: rabbitmq:3-management
    container_name: testrail-latest-rabbitmq
    hostname: testrail-latest-rabbitmq
    ports:
        - 15671:15671
        - 15672:15672
    restart: always
    environment:
      - RABBITMQ_DEFAULT_USER=testrail
      - RABBITMQ_DEFAULT_PASS=testrail
    volumes:
      - /etc/localtime:/etc/localtime:ro
      - /etc/timezone:/etc/timezone:ro
      - /mnt/lvm/apps/testrail-latest/rabbitmq:/var/lib/rabbitmq

```
