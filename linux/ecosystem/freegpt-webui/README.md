# FreeGPT WebUI by Neurogen

* Improved docker images.
* Original repo here: [Em1tSan/freegpt-webui-ru](https://github.com/Em1tSan/freegpt-webui-ru)

## Ready docker-compose example

### Normal WebUI (All versions)

```yml
version: "3.9"
services:
  freegpt-webui:
    image: epicmorg/freegpt-webui:latest #1.3.2, 1.3.1, etc
    container_name: freegpt-webui
    hostname: freegpt-webui
    restart: always
    ports:
       - 1338:1338
```

### Endpoint API (v1.3+ only)

```yml
version: "3.9"
services:
  freegpt-webui:
    image: epicmorg/freegpt-webui:latest-endpoint # 1.3, 1.3.1, 1.3.2, 1.4, etc
    container_name: freegpt-webui
    hostname: freegpt-webui
    restart: always
    ports:
       - 1337:1337
```
