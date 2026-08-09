# Version Compability

## Status of PHP versions

https://www.php.net/supported-versions.php
https://www.php.net/eol.php
https://openssl-library.org/source/
https://openssl-library.org/source/old/
https://pecl.php.net/
https://www.ioncube.com/loaders.php

| PHP  | OpenSSL                          | ICU      | curl     | libpq | SAPI              | Loaders          | Comments                | Status |
| ---- | -------------------------------- | -------- | -------- | ----- | ----------------- | ---------------- | ----------------------- | ------ |
| 5.3  | 1.0.2u, End Of Life, 20 Dec 2019 | ?        | `8.17.0` | `13`  | `cli` `fpm` `cgi` | `ionCube`        | End Of Life, 2014-08-14 |        |
| 5.4  | 1.0.2u, End Of Life, 20 Dec 2019 | ?        | `8.17.0` | `13`  | `cli` `fpm` `cgi` | `ionCube`        | End Of Life, 2015-09-03 |        |
| 5.5  | 1.0.2u, End Of Life, 20 Dec 2019 | ?        | `8.17.0` | `13`  | `cli` `fpm` `cgi` | `ionCube`        | End Of Life, 2016-07-10 |        |
| 5.6  | 1.0.2u, End Of Life, 20 Dec 2019 | ?        | `8.17.0` | `13`  | `cli` `fpm` `cgi` | `ionCube`        | End Of Life, 2018-12-31 |        |
| 7.0  | 1.1.1w, End Of Life, 11 Sep 2023 | `67.1`   | `8.17.0` | `16`  | `cli` `fpm` `cgi` | `ionCube` `Bolt` | End Of Life, 2019-01-10 | Ready  |
| 7.1  | 1.1.1w, End Of Life, 11 Sep 2023 | `67.1`   | `8.17.0` | `16`  | `cli` `fpm` `cgi` | `ionCube` `Bolt` | End Of Life, 2019-12-01 | Ready  |
| 7.2  | 1.1.1w, End Of Life, 11 Sep 2023 | `67.1`   | `8.17.0` | `16`  | `cli` `fpm` `cgi` | `ionCube` `Bolt` | End Of Life, 2020-11-30 | Ready  |
| 7.3  | 1.1.1w, End Of Life, 11 Sep 2023 | `67.1`   | `8.17.0` | `16`  | `cli` `fpm` `cgi` | `ionCube` `Bolt` | End Of Life, 2021-12-06 | Ready  |
| 7.4  | 1.1.1w, End Of Life, 11 Sep 2023 | `73.2`   | `8.17.0` | `16`  | `cli` `fpm` `cgi` | `ionCube` `Bolt` | End Of Life, 2022-11-28 | Ready  |
| 8.0  | 1.1.1w, End Of Life, 11 Sep 2023 | `73.2`   | `8.17.0` | `16`  | `cli` `fpm` `cgi` | `Bolt`           | End Of Life, 2023-11-26 | Ready  |
| 8.1  | 3.5.x, LTS, 08 Apr 2030          | system   | `8.21.0` | `16`  | `cli` `fpm` `cgi` | `ionCube` `Bolt` | End Of Life, 2025-12-31 | Ready  |
| 8.2  | 3.5.x, LTS, 08 Apr 2030          | system   | `8.21.0` | `16`  | `cli` `fpm` `cgi` | `ionCube` `Bolt` | security, 2026-12       | Ready  |
| 8.3  | 3.5.x, LTS, 08 Apr 2030          | system   | `8.21.0` | `16`  | `cli` `fpm` `cgi` | `ionCube` `Bolt` | security, 2027-12       | Ready  |
| 8.4  | 3.5.x, LTS, 08 Apr 2030          | system   | `8.21.0` | `16`  | `cli` `fpm` `cgi` | `ionCube` `Bolt` | bugfix, 2028-12         | Ready  |
| 8.5  | 3.5.x, LTS, 08 Apr 2030          | system   | `8.21.0` | `16`  | `cli` `fpm` `cgi` | `ionCube` `Bolt` | bugfix, 2029-12         | Ready  |

Only supported versions will be automaticly updated at CI.

### Notes on the matrix

* **OpenSSL 1.1.x support landed in PHP 7.1.** Everything below that is pinned to
  `1.0.2u`. PHP 7.0 builds fine against `1.1.1w` in practice, so it uses that.
* **OpenSSL 3.x is only reliable from PHP 8.1.** PHP 8.0 stays on `1.1.1w`.
* **`3.5.x` is chosen because it is the LTS branch** (supported until 08 Apr 2030).
  OpenSSL `3.6` and `4.0` are *not* LTS and are deliberately not used.
* **All builds are NTS (non-thread-safe), non-debug.** This is dictated by the
  proprietary loaders: they ship one blob per `no-debug-non-zts-<API>` combination.
  ZTS would break `ionCube` and `phpBolt`, so `swoole` / `parallel` are out of scope.
* `mod_php` (Apache SAPI) is **not** built. It was removed from php-src in 8.4,
  and Apache/nginx both talk to `php-fpm` over FastCGI instead.
* **ionCube skipped PHP 8.0 entirely** — the vendor treated it as a transitional
  release after 7.4 and resumed with 8.1. There is no 8.0 loader and there never
  will be. `phpBolt` covers 7.0–8.5 and is unaffected.
* Branches on `1.0.2u` are limited to **TLS 1.2** — TLS 1.3 does not exist in that
  OpenSSL branch.

## Baked dependencies

Debian Trixie ships versions that are too new for the older PHP branches, and the
system `libcurl` / `libpq` link the system OpenSSL 3 — which would put two
different `libssl` into one process on the 1.1.1 and 1.0.2 branches. Everything
below is therefore built from source in the **develop** layer and consumed via
`COPY --from=builder`.

### ICU

| ICU    | PHP       | Why this boundary                                                   |
| ------ | --------- | ------------------------------------------------------------------- |
| system 76 | 8.1–8.5 | `ext/intl` compiles as C++17 from 8.1; ICU 74+ headers require C++17 |
| `73.2` | 7.4, 8.0  | last branch whose headers stay C++11-clean                          |
| `67.1` | 7.0–7.3   | ICU 68 changed `operator==` return type `UBool` → `bool`            |
| ?      | 5.x       | not determined yet — see *Known gaps*                               |

* **ICU 68** changed `BreakIterator::operator==` to return `bool`. PHP ≤ 7.3
  overrides it with `UBool`, which C++ rejects as a conflicting return type.
* **ICU 74/75** moved to C++17 in public headers. `ext/intl` uses `-std=c++11`
  until PHP 8.1.
* **ICU 65** disabled the implicit `using namespace icu;`. PHP 7.0 relies on it,
  hence `-DU_USING_ICU_NAMESPACE=1` in `CXXFLAGS` for that branch only.
* **PHP 7.0 detects ICU through `icu-config`**, not pkg-config — `ICU_CFLAGS` /
  `ICU_LIBS` are ignored there. Use `--with-icu-dir=${ICU_67_DIR}` instead.
* The ICU `.pc` files carry **no `-L`**, so on 7.1+ the pkg-config result is
  overridden explicitly:
  ```sh
  export ICU_CFLAGS="-I${ICU_67_INC_DIR}"
  export ICU_LIBS="-L${ICU_67_LIB_DIR} -licui18n -licuuc -licudata -licuio"
  ```
* The system ICU must be hidden from **both** the compiler and the linker inside
  the builder stage: headers (`/usr/include/unicode`) and the unversioned
  `.so` / `.a` symlinks. Otherwise `-licuuc` silently resolves to ICU 76 and the
  link fails with `undefined reference to ..._73`.

### curl

| curl     | OpenSSL | PHP     |
| -------- | ------- | ------- |
| `8.21.0` | 3.5     | 8.1–8.5 |
| `8.17.0` | 1.1.1   | 7.0–8.0 |
| `8.17.0` | 1.0.2   | 5.x     |

* **`8.18.0` removed OpenSSL 1.1.1 support**, so `8.17.0` is the last usable
  release for those branches. That variant is **frozen** — no upstream fix will
  ever land for it again.
* Built **without** `ldap`, `ssh2`, `rtmp`, `gssapi`, `psl`: every one of those
  links the system OpenSSL and would drag `libssl.so.3` back into the process.
  Consequence — this curl speaks `http`/`https`/`ftp`/`ftps`/`file`/`ws`/`wss`
  only. No `ldap://`, `scp://`, `sftp://`, `rtmp://`, no Kerberos auth.
* `--with-ca-bundle=/etc/ssl/certs/ca-certificates.crt` is mandatory, otherwise
  curl bakes in a build-time path and never sees the EpicMorg CA certs.
* `--enable-option-checking=fatal` is **not** curl's default — without it an
  unknown or renamed flag is silently ignored and you end up with ldap inside
  while believing you disabled it.

### libpq

| libpq | OpenSSL     | PHP     |
| ----- | ----------- | ------- |
| `16`  | 3.5 / 1.1.1 | 7.0–8.5 |
| `13`  | 1.0.2       | 5.x     |

* Only `src/interfaces/libpq` + `src/include` + `src/bin/pg_config` are built —
  a full PostgreSQL build takes twenty minutes and pulls in dependencies we do
  not need.
* `pg_config` is required: PHP's `--with-pgsql=DIR` reads the include and lib
  paths from it.
* Unlike Debian's libpq, ours links **neither LDAP nor Kerberos** — `gssencmode`
  and LDAP lookups are unavailable.
* PostgreSQL 16 does build against OpenSSL 1.0.2, but that combination is
  untested upstream; branch 13 is used there instead as a contemporary of that
  OpenSSL.

## Compilers

**PHP is built with the SYSTEM compiler (Debian gcc), not with the one from
`epicmorg/gcc:N`.** PHP's autoconf prefers `cc`, which is Debian's gcc; Python's
`configure` looks for `gcc` first and therefore picks ours. Both behaviours are
intentional and verified.

Setting `CC` explicitly to `${GCC_INSTALL_DIR}/bin/gcc` is possible but currently
breaks the build: that compiler is configured without `--enable-multiarch` and
cannot find headers in `/usr/include/x86_64-linux-gnu` (e.g. `gmp.h`). Fixing it
requires rebuilding the gcc images with multiarch enabled.

The `GCC` column in older revisions of this file described the base image tag,
not the compiler actually used. It has been removed to avoid the confusion.

## Per-branch build workarounds

Applied inside the builder stage. Each one is a symptom of Trixie being far
newer than the PHP branch being built.

| Workaround | Branches | Reason |
| ---------- | -------- | ------ |
| `ac_cv_func_readdir_r=no` | ≤ 7.3 | Modern glibc declares `readdir_r` via `__REDIRECT`; PHP's autoconf test misdetects it and emits a two-argument call |
| `freetype-config` shim | ≤ 7.3 | Debian dropped `freetype-config`; PHP's gd detection still calls it |
| `sed` patch on `main/php_config.h` | 7.0, 7.1 | `zend_sprintf` is declared outside `extern "C"`; `ext/intl` includes the header both inside and outside it, giving conflicting linkage |
| `-Wno-error=incompatible-pointer-types` | ≤ 7.2 | `fopencookie` seeker signature mismatch; gcc 14 turned this into an error |
| `-fpermissive` in `CXXFLAGS` | ≤ 7.1 | C++ strictness in `ext/intl` |
| `-DU_USING_ICU_NAMESPACE=1` | 7.0 | ICU 65 disabled the implicit `using namespace icu;` |
| `--with-icu-dir=` | 7.0 | `ext/intl` uses `icu-config`, not pkg-config |

The `php_config.h` patch runs **after** `./configure` because that header is
generated. A future `make distclean` would regenerate it unpatched.

## Configure flag differences

| Flag | Available from | Note |
| ---- | -------------- | ---- |
| `--enable-json` | ≤ 7.4 | json became always-on in 8.0; the flag no longer exists |
| `--with-sodium` | 7.2+ | libsodium was not bundled before |
| `--with-password-argon2` | 7.2+ | |
| `--enable-phpdbg-readline` | 7.2+ | plain `--enable-phpdbg` exists everywhere |
| `--with-ffi` | 7.4+ | |
| `--enable-gd` + `--with-jpeg` etc. | 7.4+ | |
| `--with-gd` + `--with-jpeg-dir=` etc. | ≤ 7.3 | old-style paths |
| `--with-zip` | 7.4+ | |
| `--enable-zip --with-libzip` | ≤ 7.3 | |
| `--enable-opcache` | ≤ 8.4 | removed in 8.5, opcache is always compiled in |

## PHP module API versions

Each PHP branch has its own `ZEND_MODULE_API_NO`, which defines the extension
directory name and the loader blob to use. It is written to
`${PHP_DIR}/.module-api` at build time — **never hardcode it**, read it:

```sh
api="$(cat ${PHP_DIR}/.module-api)"
cp some_loader.so /usr/lib/php/${api}/
```

| PHP | API        |
| --- | ---------- |
| 5.5 | `20121212` |
| 5.6 | `20131226` |
| 7.0 | `20151012` |
| 7.1 | `20160303` |
| 7.2 | `20170718` |
| 7.3 | `20180731` |
| 7.4 | `20190902` |
| 8.0 | `20200930` |
| 8.1 | `20210902` |
| 8.2 | `20220829` |
| 8.3 | `20230831` |
| 8.4 | `20240924` |
| 8.5 | `20250925` |

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

PHP 8.5 additionally ships `lexbor` (HTML5 parser) and `uri`.

Anything not in this list can be added on top — see *Helper scripts* below.

## PECL extensions

Versions are **pinned** in the Dockerfile. `pecl install <ext>` without a version
resolves to "latest at build time" and makes builds non-reproducible.

Newer releases keep dropping old PHP branches, so the pinned set differs per
branch. When `pecl` refuses to install, check the extension's page for the last
release that still lists that PHP version.

| Extension    | 8.5        | 8.1–8.4  | 7.2–8.0  | 7.0–7.1  | Priority |
| ------------ | ---------- | -------- | -------- | -------- | -------- |
| `igbinary`   | `3.2.17RC1`| `3.2.16` | `3.2.16` | `3.2.16` | `15`     |
| `msgpack`    | `3.0.1`    | `3.0.1`  | `2.2.0`  | `2.2.0`  | `15`     |
| `apcu`       | `5.1.28`   | `5.1.28` | `5.1.24` | `5.1.24` | `20`     |
| `redis`      | `6.3.0`    | `6.3.0`  | `6.0.2`  | `5.3.7`  | `20`     |
| `memcached`  | `3.4.0`    | `3.4.0`  | `3.2.0`  | `3.2.0`  | `20`     |
| `imagick`    | `3.8.1`    | `3.8.1`  | `3.7.0`  | `3.7.0`  | `20`     |
| `timezonedb` | `2026.3`   | `2026.3` | `2026.3` | `2026.3` | `30`     |

* **`igbinary 3.2.17RC1` on 8.5 is temporary.** 3.2.16 does not build against
  PHP 8.5 (`php_smart_string.h` moved). Move back to a stable release once
  3.2.17 final ships.
* **Build order matters.** `igbinary` and `msgpack` must be installed *before*
  `redis` and `memcached`, otherwise those are compiled without serializer
  support and silently fall back to the native PHP serializer — which breaks
  reading existing cache data written with `igbinary`.
* `redis` and `memcached` are built via `pecl download` + explicit `./configure`
  rather than `pecl install`, because pecl's interactive prompts change order
  between releases and silently produce wrong flags
  (observed: `--with-libmemcached-dir=no`, `--with-system-fastlz`).
* **PECL is deprecated upstream** in favour of [PIE](https://github.com/php/pie).
  PIE requires PHP 8.1+ and does not yet cover every extension here, so PECL
  remains the primary mechanism. `pie` is installed on 8.1+ for forward
  compatibility.

## Proprietary loaders

Vendor binaries, no source available.

| Loader     | Load type        | Priority | PHP range          | Source |
| ---------- | ---------------- | -------- | ------------------ | ------ |
| `ionCube`  | `zend_extension` | `05`     | 4.1 – 8.5, **no 8.0** | downloaded from ioncube.com at build |
| `phpBolt`  | `extension`      | `06`     | 7.0 – 8.5          | shipped in-repo under `usr/local/lib/php/` |
| `perforce` | `extension`      | `20`     | 7.0 – 8.5          | downloaded from ftp.perforce.com at build |

* **`ionCube` is a Zend extension, `phpBolt` is a regular one** — despite both
  being bytecode loaders. Enabling `phpBolt` as `zend_extension` loads nothing.
* Always use the **non-`_ts`** blob. `_ts` is the ZTS variant and will not load.
* `ionCube` must be loaded before OPcache, hence priority `05`.
* `phpBolt` archive filenames are inconsistent upstream
  (`linux 64 - php7.3`, `linux 64-php8.2`, `linux-php8.5`), so the blob name is an
  explicit `ARG` per image rather than derived from `PHP_VERSION`.
* `phpBolt` registers itself as `Bolt` on 7.x and `bolt` on 8.x — match
  case-insensitively.

### Perforce releases

The p4php blob lives in a different Perforce release per PHP branch, and the
OpenSSL variant must match the branch:

| PHP     | Release | Blob                            |
| ------- | ------- | ------------------------------- |
| 7.0–7.1 | `r20.1` | `perforce_php7N-ssl1.1.1.so`    |
| 7.2–8.0 | `r24.1` | `perforce_php7N-ssl1.1.1.so`    |
| 8.1     | `r25.2` | `perforce_php81-ssl3.so`        |
| 8.2–8.5 | `r26.1` | `perforce_php8N-ssl3.so`        |

OpenSSL is **statically linked inside the blob**, so it does not add a second
`libssl` to the process. The r24.1+ blobs are ~77 MB for that reason — do not
strip them.

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
├── src/                        -> /usr/local/src/php/<version>
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
pecl install redis-6.3.0 && php-ext-enable redis

# vendor blob
api="$(cat ${PHP_DIR}/.module-api)"
cp loader.so /usr/lib/php/${api}/
php-ext-enable --zend --priority 05 loader

# turn something off
php-dismod xdebug
```

`php-ext-enable` decides `extension=` vs `zend_extension=` from an explicit list
inside the script — autodetection would silently produce a module that loads but
misbehaves, which is worse than a hard error. Use `--zend` to override.

## php-fpm defaults

Two upstream defaults are dangerous in a container and are overridden:

* **`pm.max_requests = 500`** — upstream default is `0`, meaning a worker lives
  forever. A slow leak then turns into an OOM after a few days of uptime.
* **`request_terminate_timeout = 300s`** — upstream default is `0`. One
  unresponsive backend blocks every worker, `max_children` is exhausted and the
  site is down while nothing has technically crashed. This also covers time spent
  in blocking I/O, which `max_execution_time` does not.
* **`clear_env = no`** — otherwise container environment variables never reach
  `getenv()`, silently breaking anything reading credentials from the
  environment.

`pm.max_children = 16` is a placeholder. Compute it from the container memory
limit: `max_children = (memory_limit * 0.8) / worker_rss`.

`php-fpm -t` runs at build time, so a typo in these files fails the build rather
than the container.

## Build-time assertions

Every image fails the build unless all of the following hold:

1. **Header version** — `OPENSSL_VERSION_NUMBER` matches the expected branch mask
   (`0x1000` / `0x1010` / `0x30`). Catches "compiled against system headers".
2. **Library version** — `php -i | OpenSSL Library Version` matches the expected
   version. Catches "linked against the wrong library".
3. **Linkage** — `ldd` of the `php` binary resolves `libssl` from our prefix and
   reports no `not found`. Catches a lost `rpath` after `COPY --from=builder`.
4. **Single libssl** — exactly one `libssl` in the binary. Catches a system
   `libpq` / `libcurl` dragging OpenSSL 3 back in.
5. **ICU version** — `ext/intl` reports the ICU it was built against.
6. **curl ssl_version** — `ext/curl` reports our OpenSSL, not the system one.
7. **Serializers** — `redis` and `memcached` report `igbinary` support.
8. **Loaders** — `ionCube`, `phpBolt` and `perforce` are present in `php -m`.

Checks 1 and 2 disagreeing means ABI drift: compiled against one OpenSSL,
linked against another.

System OpenSSL headers are moved aside (`/usr/include/openssl.disabled`) inside
the builder stage **after** `apt-get install`, because several `-dev` packages
depend on `libssl-dev` and would restore them. `libcurl4-openssl-dev`,
`libpq-dev` and `libicu-dev` are not installed at all.

A `lib` vs `lib64` guard runs right after the `COPY --from=builder` block so a
layout mismatch fails immediately instead of twenty steps later. Note that our
OpenSSL 3.5 installs into `lib64` while 1.1.1 and 1.0.2 use `lib` — never
hardcode either, always go through the `*_LIB_DIR` variables.

**Do not add `-Wl,--enable-new-dtags`.** `RUNPATH` is not inherited by transitive
dependencies, which breaks `libicuuc` → `libicudata` resolution at runtime.

## Known gaps

* **PHP 5.x is not built yet.** It needs OpenSSL `1.0.2`, an ICU older than 67
  (boundary not yet determined), and possibly its own `libxml2` — Trixie ships
  2.14+, whose API changes may be too new. `ext/mysql` (the pre-7.0 procedural
  API) also only exists there.
* `cassandra` (DataStax PHP driver) is not built — upstream is abandoned and
  only ships prebuilt blobs. Needed only by TestRail; add as a separate layer.
* HTTP/2 support in curl depends on `libnghttp2-dev` being present in the builder
  stage. Verify it is installed for every branch, otherwise some images get
  HTTP/2 and others do not.
* The `gcc` images are configured without `--enable-multiarch`, so their compiler
  cannot find Debian's multiarch headers. Until that is fixed, PHP is built with
  the system compiler.