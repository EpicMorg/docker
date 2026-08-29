# 0. Запускаем докера контейнер
```
docker run --rm -it \
  -v /path/to/old/pg11_data:/var/lib/postgresql/11/data \
  -v /path/to/new/pg16_data:/var/lib/postgresql/16/data \
  -u postgres \
  epicmorg/pg-upgrade-tool:latest
```

# 1. Инициализируем новую пустую базу 16
`/usr/lib/postgresql/16/bin/initdb -D /var/lib/postgresql/16/data --locale=en_US.UTF-8 -A md5`

# 2. (Опционально) Проверка. Если тут ОК - значит расширения на месте.

```
/usr/lib/postgresql/16/bin/pg_upgrade \
  -b /usr/lib/postgresql/11/bin \
  -B /usr/lib/postgresql/16/bin \
  -d /var/lib/postgresql/11/data \
  -D /var/lib/postgresql/16/data \
  --check
```


# 3. ПОЕХАЛИ (без --link)
/usr/lib/postgresql/16/bin/pg_upgrade \
  -b /usr/lib/postgresql/11/bin \
  -B /usr/lib/postgresql/16/bin \
  -d /var/lib/postgresql/11/data \
  -D /var/lib/postgresql/16/data
```

# 4. Post-upgdae in new pure 16 container
`docker exec -d postgres-16 vacuumdb --all --analyze-in-stages -U postgres`