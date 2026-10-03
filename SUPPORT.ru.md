# Документ поддержки концепции образов Docker для проекта

`timestamp: 2026/10/03`

| Debian | **codename** | **status** |
|:-------------|:-------------|:-------------|
| [![GHA](https://img.shields.io/github/actions/workflow/status/EpicMorg/docker/base.sid.yml?label=SID&logo=Debian%20sid%20Images&style=flat-square)](https://github.com/EpicMorg/docker/actions/workflows/base.sid.yml) | `sid` | `unstable` | 
| [![GHA](https://img.shields.io/github/actions/workflow/status/EpicMorg/docker/chain.10-base.yml?label=13&logo=Debian%2013%20Images&style=flat-square)](https://github.com/EpicMorg/docker/actions/workflows/chain.10-base.yml) | **`trixie`** | **`stable`**, reference base |
| [![GHA](https://img.shields.io/github/actions/workflow/status/EpicMorg/docker/base.museum.yml?label=12&logo=Debian%2012%20Images&style=flat-square)](https://github.com/EpicMorg/docker/actions/workflows/base.museum.yml) | `bookworm` | `oldstable`, museum |
| [![GHA](https://img.shields.io/github/actions/workflow/status/EpicMorg/docker/base.museum.yml?label=11&logo=Debian%2011%20Images&style=flat-square)](https://github.com/EpicMorg/docker/actions/workflows/base.museum.yml) | `bullseye` | `LTS`, museum |
| [![GHA](https://img.shields.io/github/actions/workflow/status/EpicMorg/docker/base.museum.yml?label=10&logo=Debian%20Legacy%20Images&style=flat-square)](https://github.com/EpicMorg/docker/actions/workflows/base.museum.yml) | `buster` | museum |
| [![GHA](https://img.shields.io/github/actions/workflow/status/EpicMorg/docker/base.museum.yml?label=9&logo=Debian%20Legacy%20Images&style=flat-square)](https://github.com/EpicMorg/docker/actions/workflows/base.museum.yml) | `stretch` | museum |
| [![GHA](https://img.shields.io/github/actions/workflow/status/EpicMorg/docker/base.museum.yml?label=8&logo=Debian%20Legacy%20Images&style=flat-square)](https://github.com/EpicMorg/docker/actions/workflows/base.museum.yml) | `jessie` | museum |
| [![GHA](https://img.shields.io/github/actions/workflow/status/EpicMorg/docker/base.museum.yml?label=7&logo=Debian%20Legacy%20Images&style=flat-square)](https://github.com/EpicMorg/docker/actions/workflows/base.museum.yml) | `wheezy` | museum |
| [![GHA](https://img.shields.io/github/actions/workflow/status/EpicMorg/docker/base.museum.yml?label=6&logo=Debian%20Legacy%20Images&style=flat-square)](https://github.com/EpicMorg/docker/actions/workflows/base.museum.yml) | `squeeze` | museum |


## Введение

`epicmorg/docker` — коллекция OCI-образов на общей слоёной базе: **база → рантайм → приложение**.
Здесь описано, как устроены образы и какие версии поддерживаются.
Теги, пиннинг по digest и анонсы миграций описаны в [README](README.md#tags-pinning-and-updates).

### Базовые образы (`linux/ecosystem/base`)

Для каждого поддерживаемого релиза дистрибутива один и тот же набор:

1. **`light`** — наш облегчённый слой поверх вендорского образа (`debian:<codename>-slim`, `rootfs` у Astra): настройки APT, корневые сертификаты, локали, базовые каталоги. Сжат в один слой.
2. **`main`** (тег без суффикса, например `debian:trixie`) — `light` + базовые утилиты (`mc`, `wget`, `htop`, …). Рантайм-база для всего остального.
3. **`develop-light`** — `main` + тулчейн сборки и `-dev` пакеты.
4. **`develop`** — `develop-light` + библиотеки, которые мы собираем из исходников и кладём в `/usr/local/share/epicmorg` (несколько веток OpenSSL, ICU, curl, libpq, libxml2, …). **Только среда сборки, не база для рантайма.**

Эталонная база — **Debian 13 `trixie`**. Astra Linux 1.7 / 1.8 устроены так же (main у них с тегом `<ver>-main`). `sid` — разведка следующего релиза Debian, регрессии там ожидаемы.

### Рантаймы (`linux/ecosystem/apps`)

Рантаймы живут в **глобальном пуле**, не привязанном к тегу дистрибутива: `epicmorg/php:<x.y>`, `python:<x.y>`, `nodejs:<x>`, `jdk:<x>`, `gcc:<x>`, `nginx:<x.y>`, `go:<x.y>`, `dotnet…`.
PHP, Python и nginx собираются из исходников в стадии-сборщике на `gcc` и копируются на `main`; их зависимости вшиты через RPATH в `/usr/local/share/epicmorg`, поэтому системные библиотеки не подмешиваются. Каждая сборка выполняет фатальные проверки (версии библиотек, линковка, ровно одна копия каждой библиотеки).

### Приложения

Образы конечных продуктов (`apache2`, `nginx-php`, `testrail`, стек Atlassian, `mattermost`, агенты TeamCity, …) наследуются от рантайма или от `main`. В `linux/advanced` лежат доработанные форки апстримных образов (`zabbix`, `nextcloud`, `teamcity-server`, …).

### Музей: Debian 6–12

Старые релизы Debian заморожены в `linux/obsolete`: только ванильные `light` / `main` / `develop`, без рантаймов. Они пересобираются раз в неделю только чтобы оставаться устанавливаемыми; ничего нового в них не добавляется.

### Обновления

* Образы пересобираются по расписанию (раз в неделю) одной цепочкой: база → gcc → рантаймы → приложения. Поэтому теги «плавающие» — для воспроизводимости пиньтесь по digest.
* Когда эталоном становится новый релиз Debian, рантаймы и приложения переезжают на него, а предыдущий релиз уходит в музей. Такие миграции анонсируются примерно за месяц.
