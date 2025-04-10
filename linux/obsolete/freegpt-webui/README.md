# FreeGPT WebUI by Neurogen

* Improved docker images.
* Original repo here: [Em1tSan/freegpt-webui-ru](https://github.com/Em1tSan/freegpt-webui-ru)

* All versions now running by `supervisord` instead of direct `CMD python3 ./run.py`
* Since `v1.3+` image contain **both** applications in background - `webui` chat (via port `1338`) and `endpoint` api (via port `1337`).

# Ready docker-compose example

```yml
services:
  freegpt-webui:
    image: epicmorg/freegpt-webui:latest #1.3.2, <...>, 1.0, etc
    container_name: freegpt-webui
    hostname: freegpt-webui
    restart: always
    ports:
       - 1337:1337
       - 1338:1338
```

