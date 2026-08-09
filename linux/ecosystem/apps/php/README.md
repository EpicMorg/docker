# Version Compability

## Status of PHP versions

https://www.php.net/supported-versions.php
https://www.php.net/eol.php
https://openssl-library.org/source/
https://openssl-library.org/source/old/
https://pecl.php.net/
https://www.ioncube.com/loaders.php

| PHP  | OpenSSL                          | GCC  | SAPI              | Loaders           | Comments                | Status |
| ---- | -------------------------------- | ---- | ----------------- | ----------------- | ----------------------- | ------ |
| 5.3  | 1.0.2u, End Of Life, 20 Dec 2019 | `7`  | `cli` `fpm` `cgi` | `ionCube`         | End Of Life, 2016-07-10 |        |
| 5.4  | 1.0.2u, End Of Life, 20 Dec 2019 | `7`  | `cli` `fpm` `cgi` | `ionCube`         | End Of Life, 2016-07-10 |        |
| 5.5  | 1.0.2u, End Of Life, 20 Dec 2019 | `7`  | `cli` `fpm` `cgi` | `ionCube`         | End Of Life, 2016-07-10 |        |
| 5.6  | 1.0.2u, End Of Life, 20 Dec 2019 | `7`  | `cli` `fpm` `cgi` | `ionCube`         | End Of Life, 2018-12-31 |        |
| 7.0  | 1.0.2u, End Of Life, 20 Dec 2019 | `10` | `cli` `fpm` `cgi` | `ionCube` `Bolt`  | End Of Life, 2019-01-10 |        |
| 7.1  | 1.1.1w, End Of Life, 11 Sep 2023 | `10` | `cli` `fpm` `cgi` | `ionCube` `Bolt`  | End Of Life, 2019-12-01 |        |
| 7.2  | 1.1.1w, End Of Life, 11 Sep 2023 | `10` | `cli` `fpm` `cgi` | `ionCube` `Bolt`  | End Of Life, 2020-11-30 |        |
| 7.3  | 1.1.1w, End Of Life, 11 Sep 2023 | `10` | `cli` `fpm` `cgi` | `ionCube` `Bolt`  | End Of Life, 2021-12-06 |        |
| 7.4  | 1.1.1w, End Of Life, 11 Sep 2023 | `11` | `cli` `fpm` `cgi` | `ionCube` `Bolt`  | End Of Life, 2022-11-28 |        |
| 8.0  | 1.1.1w, End Of Life, 11 Sep 2023 | `11` | `cli` `fpm` `cgi` | `ionCube` `Bolt`  | End Of Life, 2023-11-26 |        |
| 8.1  | 3.5.x, LTS, 08 Apr 2030          | `13` | `cli` `fpm` `cgi` | `ionCube` `Bolt`  | End Of Life, 2025-12-31 |        |
| 8.2  | 3.5.x, LTS, 08 Apr 2030          | `14` | `cli` `fpm` `cgi` | `ionCube` `Bolt`  | security, 2026-12       | Ready  |
| 8.3  | 3.5.x, LTS, 08 Apr 2030          | `14` | `cli` `fpm` `cgi` | `ionCube` `Bolt`  | security, 2027-12       | Ready  |
| 8.4  | 3.5.x, LTS, 08 Apr 2030          | `15` | `cli` `fpm` `cgi` | `ionCube` `Bolt`  | bugfix, 2028-12         | Ready  |
| 8.5  | 3.5.x, LTS, 08 Apr 2030          | `15` | `cli` `fpm` `cgi` | `ionCube` `Bolt`  | bugfix, 2029-12         | Ready  |

Only supported versions will be automaticly updated at CI.

### Notes on the matrix

* **OpenSSL 1.1.x support landed in PHP 7.1.** Everything below that is pinned to `1.0.2u`.
* **OpenSSL 3.x is only reliable from PHP 8.1.** PHP 8.0 stays on `1.1.1w`.
* **`3.5.x` is chosen because it is the LTS branch** (supported until 08 Apr 2030).
  OpenSSL `3.6` and `4.0` are *not* LTS and are deliberately not used.
* **All builds are NTS (non-thread-safe), non-debug.** This is dictated by the
  proprietary loaders: they ship one blob per `no-debug-non-zts-<API>` combination.
  ZTS would break `ionCube` and `phpBolt`, so `swoole` / `parallel` are out of scope.
* `mod_php` (Apache SAPI) is **not** built. It was removed from php-src in 8.4,
  and Apache/nginx both talk to `php-fpm` over FastCGI instead.

## PHP module API versions

Each PHP branch has its own `ZEND_MODULE_API_NO`, which defines the extension
directory name and the loader blob to use. It is written to
`${PHP_DIR}/.module-api` at build time — **never hardcode it**, read it:

```sh
api="$(cat ${PHP_DIR}/.module-api)"
cp some_loader.so /usr/lib/php/${api}/
```

| PHP | API        | Extension dir suffix          |
| --- | ---------- | ----------------------------- |
| 5.5 | `20121212` | `no-debug-non-zts-20121212`   |
| 5.6 | `20131226` | `no-debug-non-zts-20131226`   |
| 7.0 | `20151012` | `no-debug-non-zts-20151012`   |
| 7.1 | `20160303` | `no-debug-non-zts-20160303`   |
| 7.2 | `20170718` | `no-debug-non-zts-20170718`   |
| 7.3 | `20180731` | `no-debug-non-zts-20180731`   |
| 7.4 | `20190902` | `no-debug-non-zts-20190902`   |
| 8.0 | `20200930` | `no-debug-non-zts-20200930`   |
| 8.1 | `20210902` | `no-debug-non-zts-20210902`   |
| 8.2 | `20220829` | `no-debug-non-zts-20220829`   |
| 8.3 | `20230831` | `no-debug-non-zts-20230831`   |
| 8.4 | `20240924` | `no-debug-non-zts-20240924`   |
| 8.5 | `20250101` | `no-debug-non-zts-20250101`   |

## Bundled extensions

Compiled into PHP at `./configure` time. Availability varies between branches —
where an extension does not exist for a given PHP version, it is simply absent.

```
bcmath   bz2      calendar ctype    curl     date     dba      dom
exif     ffi      fileinfo filter   ftp      gd       gettext  gmp
hash     iconv    intl     json     libxml   mbstring mysqli   mysqlnd
opcache  openssl  pcntl    pcre     pdo      pdo_mysql pdo_pgsql pdo_sqlite
pgsql    phar     posix    random   readline reflection session shmop
simplexml soap    sockets  sodium   spl      sqlite3  standard sysvmsg
sysvsem  sysvshm  tidy     tokenizer xml     xmlreader xmlwriter xsl
zip      zlib
```

Anything not in this list can be added on top — see *Helper scripts* below.

## PECL extensions

Versions are **pinned** in the Dockerfile. `pecl install <ext>` without a version
resolves to "latest at build time" and makes builds non-reproducible.

| Extension    | Purpose                              | Priority |
| ------------ | ------------------------------------ | -------- |
| `igbinary`   | binary serializer                    | `15`     |
| `msgpack`    | MessagePack serializer               | `15`     |
| `apcu`       | userland cache                       | `20`     |
| `redis`      | phpredis client                      | `20`     |
| `memcached`  | libmemcached client                  | `20`     |
| `imagick`    | ImageMagick bindings                 | `20`     |
| `timezonedb` | up-to-date IANA timezone database    | `30`     |

**Build order matters.** `igbinary` and `msgpack` must be installed *before*
`redis` and `memcached`, otherwise those are compiled without serializer support
and silently fall back to the native PHP serializer — which breaks reading
existing cache data written with `igbinary`.

`redis` and `memcached` are built via `pecl download` + explicit `./configure`
rather than `pecl install`, because pecl's interactive prompts change order
between releases and silently produce wrong flags
(observed: `--with-libmemcached-dir=no`, `--with-system-fastlz`).

## Proprietary loaders

Both are vendor binaries with no source available.

| Loader     | Load type        | Priority | PHP range | Source                              |
| ---------- | ---------------- | -------- | --------- | ----------------------------------- |
| `ionCube`  | `zend_extension` | `05`     | 4.1 – 8.5 | downloaded from ioncube.com at build |
| `phpBolt`  | `extension`      | `06`     | 7.0 – 8.5 | shipped in-repo under `usr/local/lib/php/` |

* **`ionCube` is a Zend extension, `phpBolt` is a regular one** — despite both
  being bytecode loaders. Enabling `phpBolt` as `zend_extension` loads nothing.
* Always use the **non-`_ts`** blob. `_ts` is the ZTS variant and will not load.
* `ionCube` must be loaded before OPcache, hence priority `05`.
* `phpBolt` archive filenames are inconsistent upstream
  (`linux 64 - php7.3`, `linux 64-php8.2`, `linux-php8.5`), so the blob name is an
  explicit `ARG` per image rather than derived from `PHP_VERSION`.

## Layout

Vanilla PHP has a single ini scan dir. Debian has per-SAPI `conf.d` plus
`mods-available`. We keep **one real `conf.d`** and point every Debian path at it,
so existing configs and scripts keep working.

```
${EMG_LOCAL_BASE_DIR}/php/<ver>/
├── bin/                        php, php-cgi, php-config, phpize, pear, pecl, phpdbg
├── sbin/                       php-fpm
├── etc/
│   ├── php.ini
│   ├── php-fpm.conf, php-fpm.d/
│   ├── mods-available/         real .ini files
│   ├── conf.d/                 symlinks: NN-<mod>.ini -> ../mods-available/<mod>.ini
│   ├── cli/  conf.d -> ../conf.d,  php.ini -> ../php.ini
│   ├── fpm/  conf.d -> ../conf.d,  php.ini -> ../php.ini
│   └── cgi/  conf.d -> ../conf.d,  php.ini -> ../php.ini
├── lib/php/extensions/no-debug-non-zts-<API>/
├── include/php/
├── src/                        -> /usr/local/src/php/<full-version>
└── .module-api                 <API>
```

Compatibility symlinks:

```
/etc/php/<ver>          -> ${EMG_LOCAL_BASE_DIR}/php/<ver>/etc
/usr/lib/php/<API>      -> ${EMG_LOCAL_BASE_DIR}/php/<ver>/lib/php/extensions/no-debug-non-zts-<API>
```

**Deliberate difference from Debian:** extensions are enabled for *all* SAPIs at
once. Per-SAPI extension sets (e.g. xdebug only for cli) are not supported —
use a separate container for that.

### Load priorities

```
05  ionCube          must precede OPcache
06  phpBolt
10  OPcache          and other zend_extensions
15  serializers      igbinary, msgpack
20  regular extensions (default)
30  timezonedb       overrides the built-in tz database, load last
```

## Helper scripts

Derived from [docker-library/php](https://github.com/docker-library/php) (MIT)
and Debian `php-common` conventions.

| Script              | Purpose                                                        |
| ------------------- | -------------------------------------------------------------- |
| `php-ext-install`   | build + install + enable a **bundled** extension from source    |
| `php-ext-configure` | `phpize` + `./configure` for a bundled extension                |
| `php-ext-enable`    | write `mods-available/<mod>.ini` for a built `.so` and enable it |
| `php-enmod`         | link `mods-available/<mod>.ini` into `conf.d/NN-<mod>.ini`      |
| `php-dismod`        | remove the `conf.d` symlink (ini stays in `mods-available`)     |

`phpenmod` / `phpdismod` exist as aliases for drop-in compatibility with
Debian-era Dockerfiles.

```sh
# bundled extension, from the source tree shipped in the image
php-ext-install ldap snmp

# PECL
pecl install redis-6.2.0 && php-ext-enable redis

# vendor blob
api="$(cat ${PHP_DIR}/.module-api)"
cp loader.so /usr/lib/php/${api}/
php-ext-enable --zend --priority 05 loader

# turn something off
php-dismod xdebug
```

## Build-time assertions

Every image fails the build unless all of the following hold:

1. **Header version** — `OPENSSL_VERSION_NUMBER` matches the expected branch mask
   (`0x1000` / `0x1010` / `0x30`). Catches "compiled against system headers".
2. **Library version** — `php -i | OpenSSL Library Version` matches the expected
   version. Catches "linked against the wrong library".
3. **Linkage** — `ldd` of the `php` binary resolves `libssl` from our prefix and
   reports no `not found`. Catches a lost `rpath` after `COPY --from=builder`.
4. **Serializers** — `redis` and `memcached` report `igbinary` support.
5. **Loaders** — `ionCube` and `phpBolt` are actually present in `php -m`.

Checks 1 and 2 disagreeing means ABI drift: compiled against one OpenSSL,
linked against another.

System OpenSSL headers are moved aside (`/usr/include/openssl.disabled`) inside
the builder stage **after** `apt-get install`, because several `-dev` packages
(`libpq-dev`, `libcurl4-openssl-dev`) depend on `libssl-dev` and would restore them.

## Known gaps

* `cassandra` (DataStax PHP driver) is not built — upstream is abandoned and
  only ships prebuilt blobs. Needed only by TestRail; add as a separate layer.
* `pgsql` / `pdo_pgsql` and `curl` link against the **system** OpenSSL through
  `libpq` / `libcurl`. On 8.1+ this is harmless (same `libssl.so.3` SONAME, ours
  wins via rpath). On 7.1–8.0 the SONAMEs differ (`libssl.so.1.1` vs `libssl.so.3`)
  and both get loaded — those branches need `curl` built against our OpenSSL.
* PHP 5.x additionally needs its own `libxml2` and `ICU`; the versions shipped in
  Debian Trixie are too new for it.

  