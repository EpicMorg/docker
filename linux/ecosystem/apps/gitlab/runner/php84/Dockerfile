##################################################################
##################################################################
#        PHP runtime: the prebuilt epicmorg/php image (ADR-045)
##################################################################
##################################################################
# All php* runners share this file; they differ only in the php tag
# below and in the mirrored ENV block of the final stage.
FROM ghcr.io/epicmorg/php:8.4 AS php

# Collect exactly what this PHP needs, derived from the binaries themselves
# (nothing hardcoded per version):
#   - ${PHP_DIR} and the PHP source tree its src/ symlink points to
#     (php-ext-install / phpize builds in the runner need it);
#   - every baked dependency prefix under ${EMG_LOCAL_BASE_DIR} that ldd
#     resolves for php, php-cgi, php-fpm, libphp and every extension .so
#     (openssl, curl, libpq, icu, libzip, libmemcached ... whatever this
#     version links) - the prefix is the lib dir minus /lib, /lib64;
#   - Debian-compat symlinks /etc/php/<ver>, /usr/lib/php/<api>, the apt pin
#     block-php-packages, helper scripts, composer (+ pie), COMPOSER_HOME;
#   - metadata in ${PHP_DIR}/.php-image/: the Debian packages owning every
#     system library ldd resolved (installed in the runner), the
#     update-alternatives links, the php image's ENV and `php -m`.
RUN set -eu; \
    out=/emg-export; \
    meta="${out}${PHP_DIR}/.php-image"; \
    extDir="$(php-config --extension-dir)"; \
    mkdir -p "$meta"; \
    elfs=""; \
    for f in "${PHP_DIR}"/bin/* "${PHP_DIR}"/sbin/* "${PHP_DIR}"/lib/*.so "${extDir}"/*.so; do \
      if [ -f "$f" ] && file -L "$f" | grep -q 'ELF'; then elfs="$elfs $f"; fi; \
    done; \
    libs="$(for f in $elfs; do ldd "$f" | awk '$3 ~ /^\// {print $3}'; done | sort -u)"; \
    if for f in $elfs; do ldd "$f"; done | grep -q 'not found'; then \
      echo "FATAL: php image itself has unresolved deps" >&2; exit 1; \
    fi; \
    prefixes="$(echo "$libs" | grep "^${EMG_LOCAL_BASE_DIR}/" | xargs -r -n1 dirname \
                | sed -E 's#/lib(64)?(/x86_64-linux-gnu)?$##' | grep -v "^${PHP_DIR}\$" | sort -u)"; \
    echo "baked prefixes:"; echo "$prefixes"; \
    for p in "${PHP_DIR}" "$(readlink -f "${PHP_DIR}/src")" $prefixes \
             /etc/php /usr/lib/php /etc/apt/preferences.d/block-php-packages "${COMPOSER_HOME}"; do \
      [ -e "$p" ] || { echo "FATAL: $p missing in the php image" >&2; exit 1; }; \
      cp -a --parents "$p" "$out/"; \
    done; \
    for b in /usr/local/bin/php-* /usr/local/bin/phpenmod /usr/local/bin/phpdismod \
             /usr/local/bin/composer /usr/local/bin/pie; do \
      if [ -e "$b" ] || [ -L "$b" ]; then cp -a --parents "$b" "$out/"; fi; \
    done; \
    echo "$libs" | grep -v "^${EMG_LOCAL_BASE_DIR}/" | while read -r l; do \
      pkg=""; \
      for c in "$l" "$(readlink -f "$l")" "/usr$l" "${l#/usr}"; do \
        pkg="$(dpkg -S "$c" 2>/dev/null | grep -v '^diversion' | head -n1 | cut -d: -f1)"; \
        if [ -n "$pkg" ]; then echo "$pkg"; break; fi; \
      done; \
      if [ -z "$pkg" ]; then echo "MISSING $l"; fi; \
    done > /tmp/apt-packages; \
    if grep '^MISSING ' /tmp/apt-packages >&2; then echo "FATAL: no Debian package owns the libs above" >&2; exit 1; fi; \
    sort -u /tmp/apt-packages > "$meta/apt-packages"; \
    for a in /etc/alternatives/*; do \
      t="$(readlink "$a" || true)"; \
      case "$t" in "${PHP_DIR}"/*) ;; *) continue ;; esac; \
      n="$(basename "$a")"; \
      link="$(update-alternatives --query "$n" | sed -n 's/^Link: //p')"; \
      echo "$link $n $t"; \
    done > "$meta/alternatives"; \
    env | grep -vE '^(PATH|HOSTNAME|HOME|PWD|OLDPWD|SHLVL|TERM|container|_)=' | sort > "$meta/env"; \
    php -m | sort -u > "$meta/modules"; \
    echo "--- apt packages ---"; cat "$meta/apt-packages"; \
    echo "--- alternatives ---"; cat "$meta/alternatives"

##################################################################
##################################################################
#                     GitLab runner + PHP
##################################################################
##################################################################
FROM ghcr.io/epicmorg/gitlab-runner:minimal
ARG DEBIAN_FRONTEND=noninteractive

# Mirrored from the epicmorg/php:8.4 image config (PATH handled below).
# Asserted below against the php image's own env - a drift fails the build.
ENV PHP_VERSION="8.4"
ENV COMPOSER_ALLOW_SUPERUSER="1"
ENV COMPOSER_HOME="/composer"
ENV PHP_CFLAGS="-fstack-protector-strong -fpic -fpie -O2 -D_LARGEFILE_SOURCE -D_FILE_OFFSET_BITS=64"
ENV PHP_CPPFLAGS="-I/usr/local/share/epicmorg/openssl/3.5/include -fstack-protector-strong -fpic -fpie -O2 -D_LARGEFILE_SOURCE -D_FILE_OFFSET_BITS=64"
ENV PHP_DIR="/usr/local/share/epicmorg/php/8.4"
ENV PHP_FULL_VERSION="8.4.24"
ENV PHP_INI_DIR="/usr/local/share/epicmorg/php/8.4/etc"
ENV PHP_INI_SCAN_DIR="/usr/local/share/epicmorg/php/8.4/etc/conf.d"
ENV PHP_LDFLAGS="-L/usr/local/share/epicmorg/openssl/3.5/lib64 -Wl,-rpath,/usr/local/share/epicmorg/openssl/3.5/lib64 -Wl,-O1 -pie -Wl,--disable-new-dtags"
ENV PHP_SSL_DIR="/usr/local/share/epicmorg/openssl/3.5"
ENV PHP_SSL_HDR_MASK="0x30"
ENV PHP_SSL_LIB_DIR="/usr/local/share/epicmorg/openssl/3.5/lib64"
ENV PHP_SSL_VERSION="3.5.7"
ENV P4PHP_RELEASE="r26.1"
ENV PECL_APCU_VERSION="5.1.28"
ENV PECL_IGBINARY_VERSION="3.2.16"
ENV PECL_IMAGICK_VERSION="3.8.1"
ENV PECL_MEMCACHED_VERSION="3.4.0"
ENV PECL_MSGPACK_VERSION="3.0.1"
ENV PECL_REDIS_VERSION="6.3.0"
ENV PECL_TIMEZONEDB_VERSION="2026.3"
ENV PIE_VERSION="1.4.9"
ENV PKG_CONFIG_PATH="/usr/local/share/epicmorg/openssl/3.5/lib64/pkgconfig:"
ENV SSL_CERT_DIR="/etc/ssl/certs"
ENV PATH="${COMPOSER_HOME}/vendor/bin:${PHP_DIR}/bin:${PHP_DIR}/sbin:${PATH}"

COPY --from=php /emg-export/ /

# System libraries the php image resolves from Debian (imagick, onig, sodium,
# tidy, xslt ... as found by ldd there), then the same update-alternatives
# links the php image registers (/usr/bin/php, php-fpm, phpize, pecl ...).
RUN set -eux; \
    meta="${PHP_DIR}/.php-image"; \
    apt-get update; \
    xargs -a "$meta/apt-packages" apt-get install -y --no-install-recommends; \
    while read -r link name target; do \
      update-alternatives --install "$link" "$name" "$target" 1; \
    done < "$meta/alternatives"; \
    mkdir -p /run/php; \
    apt-get clean; \
    rm -rf /var/lib/apt/lists/* /tmp/*

##################################################################
#                       Assertions (fatal)
##################################################################
# Same checks as the php image's final block, re-run in the runner: the runner
# base (trixie-develop) has its own baked libs and ld paths, so linkage must
# be proven again here, not inherited.
RUN set -eu; \
    meta="${PHP_DIR}/.php-image"; \
    php="${PHP_DIR}/bin/php"; \
    extDir="$(php-config --extension-dir)"; \
    echo "--- ENV parity with epicmorg/php:${PHP_VERSION} ---"; \
    while IFS= read -r kv; do \
      k="${kv%%=*}"; v="${kv#*=}"; \
      [ "$(printenv "$k" || true)" = "$v" ] || { echo "FATAL: ENV $k differs from the php image: '$(printenv "$k" || true)' != '$v'" >&2; exit 1; }; \
    done < "$meta/env"; \
    echo "--- versions ---"; \
    [ "$(command -v php)" = "$php" ] || { echo "FATAL: php on PATH is $(command -v php), expected $php" >&2; exit 1; }; \
    [ "$(readlink -f /usr/bin/php)" = "$php" ] || { echo "FATAL: /usr/bin/php does not point at $php" >&2; exit 1; }; \
    php -v; php-cgi -v >/dev/null; php-fpm -v >/dev/null; \
    php -r 'echo PHP_VERSION, PHP_EOL;' | grep -q "^${PHP_FULL_VERSION}\$" || { echo "FATAL: php is not ${PHP_FULL_VERSION}" >&2; exit 1; }; \
    if [ -f "${extDir}/ioncube_loader.so" ]; then \
      php -v | grep -qi 'ionCube' || { echo "FATAL: ionCube loader not active" >&2; exit 1; }; \
    fi; \
    php -v | grep -q 'Zend OPcache' || { echo "FATAL: opcache not loaded" >&2; exit 1; }; \
    echo "--- modules == php image ---"; \
    php -m | sort -u | diff -u "$meta/modules" - || { echo "FATAL: php -m differs from the php image" >&2; exit 1; }; \
    echo "--- OpenSSL ---"; \
    hdr="$("$php" -r 'echo dechex(OPENSSL_VERSION_NUMBER);')"; \
    case "0x${hdr}" in ${PHP_SSL_HDR_MASK}*) ;; *) echo "FATAL: OpenSSL headers 0x${hdr}, expected ${PHP_SSL_HDR_MASK}*" >&2; exit 1 ;; esac; \
    lib="$("$php" -i | sed -n 's/^OpenSSL Library Version => //p')"; \
    case "${lib}" in "OpenSSL ${PHP_SSL_VERSION}"*) ;; *) echo "FATAL: expected OpenSSL ${PHP_SSL_VERSION}, got '${lib}'" >&2; exit 1 ;; esac; \
    cv="$("$php" -r '$v = curl_version(); echo $v["ssl_version"];')"; \
    case "${cv}" in "OpenSSL/${PHP_SSL_VERSION}"*) ;; *) echo "FATAL: curl uses ${cv}, expected OpenSSL/${PHP_SSL_VERSION}" >&2; exit 1 ;; esac; \
    echo "OpenSSL ${lib}, curl ${cv}"; \
    echo "--- linkage: php, php-cgi, php-fpm, every extension ---"; \
    bins="$php ${PHP_DIR}/bin/php-cgi ${PHP_DIR}/sbin/php-fpm $(ls "${extDir}"/*.so)"; \
    for bin in $bins; do \
      if ldd "$bin" | grep -q 'not found'; then echo "FATAL: ${bin} has unresolved deps" >&2; ldd "$bin" >&2; exit 1; fi; \
    done; \
    for l in libssl libcrypto libxml2 libcurl libpq libicuuc libz; do \
      n="$(for bin in $bins; do ldd "$bin" | awk '{print $1}' | grep "^${l}\.so" || true; done | sort -u | wc -l)"; \
      [ "$n" -le 1 ] || { echo "FATAL: ${n} different ${l} SONAMEs across php + extensions (ADR-031)" >&2; \
        for bin in $bins; do ldd "$bin" | grep "${l}\.so" | sed "s|^|$(basename "$bin"): |" >&2 || true; done; exit 1; }; \
    done; \
    stray="$(for bin in $bins; do ldd "$bin" | awk -v b="$(basename "$bin")" -v d="${PHP_SSL_LIB_DIR}/" '$1 ~ /^lib(ssl|crypto)\.so/ && index($3, d) != 1 {print b ": " $1 " => " $3}'; done)"; \
    [ -z "$stray" ] || { echo "FATAL: libssl/libcrypto resolved outside ${PHP_SSL_LIB_DIR}:" >&2; echo "$stray" >&2; exit 1; }; \
    echo "OK: no unresolved deps, one SONAME per lib, libssl/libcrypto only from ${PHP_SSL_LIB_DIR}"; \
    echo "--- php-fpm config ---"; \
    php-fpm -t; \
    if [ -e /usr/local/bin/composer ]; then \
      echo "--- composer ---"; \
      composer --version --no-interaction | grep -q '^Composer version' || { echo "FATAL: composer broken" >&2; exit 1; }; \
      composer --version --no-interaction; \
    fi

##################################################################
#                   final config
##################################################################
WORKDIR ${GITLAB_RUNNER_DIR}
