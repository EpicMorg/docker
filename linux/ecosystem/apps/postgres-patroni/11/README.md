  patroni17:
    image: epicmorg/postgres-patroni:17
    container_name: patroni17
    ports:
      - "6432:6432"
      - "8008:8008"
    volumes:
      - /etc/localtime:/etc/localtime:ro
      - /etc/timezone:/etc/timezone:ro
      - /raid/apps/patroni/data/17:/var/lib/postgresql
      - /raid/apps/patroni/config/patroni.yml:/etc/patroni.yml:ro
      - /raid/apps/patroni/logs/patroni:/var/log/patroni
      - /raid/apps/patroni/logs/postgresql:/var/log/postgresql
    environment:
      POSTGRES_USER: postgres
      POSTGRES_PASSWORD: postgres
      POSTGRES_INITDB_ARGS: --data-checksums --locale=en_US.UTF-8 --lc-collate=en_US.UTF-8 --lc-ctype=en_US.UTF-8 --lc-messages=en_US.UTF-8 --lc-monetary=en_US.UTF-8 --lc-numeric=en_US.UTF-8 --lc-time=en_US
      PATRONICTL_CONFIG_FILE: /etc/patroni.yml
    restart: always
    #healthcheck:
    #  test: ["CMD-SHELL", "curl", "-f", "http://localhost:8008/health"]
    #  interval: 10s
    #  timeout: 5s
    #  retries: 5
    depends_on:
      - etcd
