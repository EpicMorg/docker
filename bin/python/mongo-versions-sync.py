#!/usr/bin/env python3
"""Write linux/ecosystem/apps/mongo/<major.minor> leaves.

MongoDB's own prebuilt binaries (fastdl.mongodb.org - building MongoDB from
source is out of reach for CI) on our trixie base, newest patch of each stable
line 1.2 .. 9.x (+ 4.1, still used downstream; 1.0 has no --fork / --logpath,
which the first-start initialisation needs). Which tarball, and therefore
which TLS stack, depends on the line (FLAVOURS):

  legacy      1.2-2.6   generic "legacy" build: no TLS, libc/libstdc++ only
  openssl102  3.0-3.6   ubuntu1604 build (libssl.so.1.0.0 + Ubuntu's symbol
                        versions): OpenSSL 1.0.2g with xenial's full patch series
                        (version script, security fixes) built in the builder
  openssl111  4.0-5.0   ubuntu1804 / debian10 / debian11 builds: baked OpenSSL
                        1.1.1 + curl 8.17 (trixie-develop) + openldap / cyrus-sasl
                        built against it in the builder
  openssl3    6.0+      ubuntu2204 / debian12 / debian13 builds on Debian's own
                        OpenSSL 3 (trixie)

Baked stacks are wired with `patchelf --force-rpath` (DT_RPATH, transitive) into
the vendor ELF files - never ld.so.conf; exactly one libssl per process is a
fatal check. Shell / tools: the tarball's own up to 4.2 (mongo, mongodump ...),
database-tools for 4.4+, mongosh for 6.0+.

The entrypoint (library/mongo + bitnami env compatible) lives once in
linux/ecosystem/apps/mongo/docker-entrypoint.sh and is copied into every leaf.

Usage: bin/python/mongo-versions-sync.py [--dry-run] [--only 8.2,3.6]
"""
import hashlib
import json
import os
import re
import shutil
import sys
import urllib.request

ROOT = os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
BASE = os.path.join(ROOT, 'linux', 'ecosystem', 'apps', 'mongo')
ENTRYPOINT = os.path.join(BASE, 'docker-entrypoint.sh')
MAKEFILE = os.path.join(ROOT, 'linux', 'ecosystem', 'apps', 'git', '2.56', 'Makefile')
FULL = 'https://downloads.mongodb.org/full.json'
FASTDL = 'https://fastdl.mongodb.org/linux/'

# line -> (flavour, vendor target or None for the generic legacy build)
LINES = {
    '1.2': ('legacy', None), '1.4': ('legacy', None), '1.6': ('legacy', None),
    '1.8': ('legacy', None), '2.0': ('legacy', None), '2.2': ('legacy', None), '2.4': ('legacy', None),
    '2.6': ('legacy', None),
    '3.0': ('openssl102', 'ubuntu1604'), '3.2': ('openssl102', 'ubuntu1604'),
    '3.4': ('openssl102', 'ubuntu1604'), '3.6': ('openssl102', 'ubuntu1604'),
    '4.0': ('openssl111', 'ubuntu1804'), '4.1': ('openssl111', 'ubuntu1804'),
    '4.2': ('openssl111', 'debian10'), '4.4': ('openssl111', 'debian10'), '5.0': ('openssl111', 'debian11'),
    '6.0': ('openssl3', 'ubuntu2204'), '7.0': ('openssl3', 'debian12'), '8.0': ('openssl3', 'debian12'),
    '8.2': ('openssl3', 'debian12'), '9.0': ('openssl3', 'debian13'),
}
# versions without full.json metadata / broken newest patch
PIN = {'1.6': '1.6.5'}   # 1.6.6 is gone from fastdl (403)

TOOLS = ('100.19.1', 'https://fastdl.mongodb.org/tools/db/mongodb-database-tools-debian12-x86_64-100.19.1.tgz',
         '9ba637b2fee9cd5afd83ea93b688a0f6bf3e0e4a614d3b0c55f63fa66ae62e2f')
MONGOSH = ('2.13.0', 'https://github.com/mongodb-js/mongosh/releases/download/v2.13.0/mongosh-2.13.0-linux-x64.tgz',
           'b2089e67641a28aa621476c4d62c69f66b9a41484baba24d8a8b1f5f96e92d0b')
# Ubuntu 16.04 (xenial) OpenSSL source package, sha256 from its .dsc
XENIAL = ('1.0.2g', 'http://archive.ubuntu.com/ubuntu/pool/main/o/openssl/openssl_1.0.2g.orig.tar.gz',
          'b784b1b3907ce39abf4098702dade6365522a253ad1552e267a9a0e89594aa33',
          'http://archive.ubuntu.com/ubuntu/pool/main/o/openssl/openssl_1.0.2g-1ubuntu4.20.debian.tar.xz',
          '3287dd2369824dedcff513913a0e7ebaab25d7f99ddb4eb62d8ba653b3683e9c')
OPENLDAP = ('2.6.15', 'https://www.openldap.org/software/download/OpenLDAP/openldap-release/openldap-2.6.15.tgz',
            'bc91225dbfc50354033b1303bc91d1a7f6ddd1dc32fac950d79c28fe66d6bca8')
SASL = ('2.1.28', 'https://github.com/cyrusimap/cyrus-sasl/releases/download/cyrus-sasl-2.1.28/cyrus-sasl-2.1.28.tar.gz',
        '7ccfc6abd01ed67c1a0924b353e526f1b766b21f42d4562ee635a8ebfc5bb38c')


def vkey(v):
    return tuple(int(x) for x in v.split('.'))


def get(url):
    return urllib.request.urlopen(urllib.request.Request(url, headers={'User-Agent': 'epicmorg-mongo-sync'}),
                                  timeout=600).read()


def newest(full):
    """{line: version} - newest x.y.z of each line in full.json."""
    out = {}
    for v in full['versions']:
        ver = v['version']
        if not re.fullmatch(r'\d+\.\d+\.\d+', ver):
            continue
        mm = '.'.join(ver.split('.')[:2])
        if mm in LINES and (mm not in out or vkey(ver) > vkey(out[mm])):
            out[mm] = ver
    out.update(PIN)
    return out


def tarball(full, ver, target):
    name = 'mongodb-linux-x86_64-%s.tgz' % (ver if target is None else '%s-%s' % (target, ver))
    url = FASTDL + name
    for v in full['versions']:
        if v['version'] == ver:
            for dl in v.get('downloads', []):
                if dl.get('archive', {}).get('url') == url and dl['archive'].get('sha256'):
                    return url, dl['archive']['sha256']
    try:   # sidecar sha256 (2.6+)
        sha = get(url + '.sha256').decode().split()[0]
        if re.fullmatch(r'[0-9a-f]{64}', sha):
            return url, sha
    except Exception:
        pass
    data = get(url)    # oldest releases: md5 sidecar only -> check it, pin our sha256
    try:
        md5 = get(url + '.md5').decode().split()[0]
        assert hashlib.md5(data).hexdigest() == md5, 'md5 mismatch for ' + url
    except urllib.error.HTTPError:
        pass
    return url, hashlib.sha256(data).hexdigest()


HEAD = '''##################################################################
##################################################################
#                          Builder
##################################################################
##################################################################
# All mongo leaves are written by bin/python/mongo-versions-sync.py (flavour
# "{flavour}"); edit the generator, not this file.
FROM ghcr.io/epicmorg/gcc:14 AS builder
ARG DEBIAN_FRONTEND=noninteractive

ENV EMG_MONGO_VERSION={mm}
ENV EMG_MONGO_FULL_VERSION={ver}
ENV EMG_MONGO_DIR=${{EMG_LOCAL_BASE_DIR}}/mongo/${{EMG_MONGO_VERSION}}
ARG EMG_MONGO_URL={url}
ARG EMG_MONGO_SHA256={sha}

RUN set -eux; \\
    apt-get update; \\
    apt-get install -y --no-install-recommends patchelf; \\
    rm -rf /var/lib/apt/lists/*; \\
    mkdir -p "${{EMG_MONGO_DIR}}" /tmp/mongo; \\
    wget -q -O /tmp/mongo.tgz "${{EMG_MONGO_URL}}"; \\
    echo "${{EMG_MONGO_SHA256}}  /tmp/mongo.tgz" | sha256sum -c -; \\
    tar -xzf /tmp/mongo.tgz -C /tmp/mongo --strip-components=1 --no-same-owner; \\
    cp -a /tmp/mongo/bin "${{EMG_MONGO_DIR}}/"; \\
    # install_compass: a GUI installer; mongosniff (1.x-2.4): wants libpcap.so.0.9 from 2010
    rm -f "${{EMG_MONGO_DIR}}/bin/install_compass" "${{EMG_MONGO_DIR}}/bin/mongosniff"; \\
    cp -a /tmp/mongo/[A-Z]* "${{EMG_MONGO_DIR}}/" 2>/dev/null || true; \\
    rm -rf /tmp/mongo /tmp/mongo.tgz
'''

EXTRA_TOOLS = '''
# database tools (mongodump, mongorestore, ...) ship separately since 4.4
ARG EMG_MONGO_TOOLS_URL={turl}
ARG EMG_MONGO_TOOLS_SHA256={tsha}
RUN set -eux; \\
    wget -q -O /tmp/tools.tgz "${{EMG_MONGO_TOOLS_URL}}"; \\
    echo "${{EMG_MONGO_TOOLS_SHA256}}  /tmp/tools.tgz" | sha256sum -c -; \\
    mkdir -p /tmp/tools "${{EMG_LOCAL_BASE_DIR}}/mongo-tools/{tver}"; \\
    tar -xzf /tmp/tools.tgz -C /tmp/tools --strip-components=1 --no-same-owner; \\
    cp -a /tmp/tools/bin "${{EMG_LOCAL_BASE_DIR}}/mongo-tools/{tver}/"; \\
    rm -rf /tmp/tools /tmp/tools.tgz
'''

EXTRA_MONGOSH = '''
# mongosh (the legacy `mongo` shell is gone since 6.0)
ARG EMG_MONGOSH_URL={surl}
ARG EMG_MONGOSH_SHA256={ssha}
RUN set -eux; \\
    wget -q -O /tmp/mongosh.tgz "${{EMG_MONGOSH_URL}}"; \\
    echo "${{EMG_MONGOSH_SHA256}}  /tmp/mongosh.tgz" | sha256sum -c -; \\
    mkdir -p /tmp/mongosh "${{EMG_LOCAL_BASE_DIR}}/mongosh/{sver}"; \\
    tar -xzf /tmp/mongosh.tgz -C /tmp/mongosh --strip-components=1 --no-same-owner; \\
    cp -a /tmp/mongosh/bin "${{EMG_LOCAL_BASE_DIR}}/mongosh/{sver}/"; \\
    rm -rf /tmp/mongosh /tmp/mongosh.tgz
'''

STACK_102 = '''
##################################################################
#    OpenSSL 1.0.2g as Ubuntu 16.04 ships it (for the ubuntu1604 build)
##################################################################
# MongoDB's ubuntu1604 binaries want libssl.so.1.0.0 with Ubuntu's symbol
# versions (OPENSSL_1.0.0 .. 1.0.2g, debian/patches/version-script.patch): the
# xenial source package with its whole patch series (incl. security fixes),
# built with the system compiler into its own prefix (named consumer: mongo 3.x).
ENV EMG_MONGO_SSL_DIR=${{EMG_LOCAL_BASE_DIR}}/openssl/1.0.2g-ubuntu
ARG XENIAL_ORIG_URL={xurl}
ARG XENIAL_ORIG_SHA256={xsha}
ARG XENIAL_DEBIAN_URL={xdurl}
ARG XENIAL_DEBIAN_SHA256={xdsha}
RUN set -eux; \\
    mkdir -p /usr/local/src/openssl-xenial; cd /usr/local/src/openssl-xenial; \\
    wget -q -O orig.tgz "${{XENIAL_ORIG_URL}}"; echo "${{XENIAL_ORIG_SHA256}}  orig.tgz" | sha256sum -c -; \\
    wget -q -O debian.txz "${{XENIAL_DEBIAN_URL}}"; echo "${{XENIAL_DEBIAN_SHA256}}  debian.txz" | sha256sum -c -; \\
    tar -xzf orig.tgz --strip-components=1 --no-same-owner; tar -xJf debian.txz --no-same-owner; \\
    while read -r p; do \\
      case "$p" in ''|'#'*) continue ;; esac; \\
      patch -p1 --forward --silent < "debian/patches/$p"; \\
    done < debian/patches/series; \\
    ./Configure shared no-idea no-mdc2 no-rc5 no-zlib enable-tlsext no-ssl2 no-ssl3 enable-ec_nistp_64_gcc_128 \\
      --prefix="${{EMG_MONGO_SSL_DIR}}" --openssldir="${{EMG_MONGO_SSL_DIR}}/ssl" \\
      -Wl,-rpath,"${{EMG_MONGO_SSL_DIR}}/lib" -Wl,--disable-new-dtags linux-x86_64; \\
    make depend >/dev/null; \\
    make -j1; \\
    make install_sw; \\
    rmdir "${{EMG_MONGO_SSL_DIR}}/ssl/certs" 2>/dev/null || true; \\
    ln -sfn /etc/ssl/certs "${{EMG_MONGO_SSL_DIR}}/ssl/certs"; \\
    objdump -T "${{EMG_MONGO_SSL_DIR}}/lib/libssl.so.1.0.0" | grep -q 'OPENSSL_1.0.2 ' || {{ echo "FATAL: no Ubuntu symbol versions" >&2; exit 1; }}; \\
    cd /; rm -rf /usr/local/src/openssl-xenial

ENV EMG_MONGO_RPATH=${{EMG_MONGO_SSL_DIR}}/lib
'''

STACK_111 = '''
##################################################################
#    OpenSSL 1.1.1 stack: baked OpenSSL + curl, openldap / cyrus-sasl
##################################################################
# The 1.1-era builds link libssl.so.1.1, libcurl (CURL_OPENSSL_4), libldap and
# libsasl2. Debian trixie's libldap / libsasl2 / libcurl use OpenSSL 3 - two
# OpenSSLs in mongod. So: trixie-develop's OpenSSL 1.1.1 + curl 8.17 built on it,
# and openldap (client libs) + cyrus-sasl built here against the same OpenSSL,
# each with a real RPATH (named consumer: mongo 4.x / 5.0).
ENV EMG_MONGO_SSL_DIR=${{OPENSSL_111_DIR}}
ENV EMG_MONGO_CURL_DIR=${{CURL_817_111_DIR}}
ENV EMG_MONGO_SASL_DIR=${{EMG_LOCAL_BASE_DIR}}/cyrus-sasl/{saslver}/openssl111
ENV EMG_MONGO_LDAP_DIR=${{EMG_LOCAL_BASE_DIR}}/openldap/{ldapver}/openssl111
ARG SASL_URL={saslurl}
ARG SASL_SHA256={saslsha}
ARG LDAP_URL={ldapurl}
ARG LDAP_SHA256={ldapsha}
RUN set -eux; \\
    test -f "${{EMG_MONGO_SSL_DIR}}/include/openssl/ssl.h"; test -x "${{EMG_MONGO_CURL_DIR}}/bin/curl-config"; \\
    mkdir -p /usr/local/src/sasl; cd /usr/local/src/sasl; \\
    wget -q -O sasl.tgz "${{SASL_URL}}"; echo "${{SASL_SHA256}}  sasl.tgz" | sha256sum -c -; \\
    tar -xzf sasl.tgz --strip-components=1 --no-same-owner; \\
    # 2.1.28 misses <time.h> in saslutil.c: an error by gcc 14's defaults
    CFLAGS="-O2 -g0 -Wno-error=implicit-function-declaration" \\
    CPPFLAGS="-I${{EMG_MONGO_SSL_DIR}}/include" \\
    LDFLAGS="-L${{OPENSSL_111_LIB_DIR}} -Wl,-rpath,${{OPENSSL_111_LIB_DIR}}:${{EMG_MONGO_SASL_DIR}}/lib -Wl,--disable-new-dtags" \\
    ./configure --prefix="${{EMG_MONGO_SASL_DIR}}" --with-openssl="${{EMG_MONGO_SSL_DIR}}" \\
      --disable-gssapi --disable-otp --disable-krb4 --disable-sql --disable-ldapdb --without-saslauthd \\
      --without-authdaemond --without-pwcheck --disable-sample --disable-static \\
      --with-plugindir="${{EMG_MONGO_SASL_DIR}}/lib/sasl2" --with-configdir="${{EMG_MONGO_SASL_DIR}}/lib/sasl2:/etc/sasl2"; \\
    make -j"$(nproc)"; make install; \\
    mkdir -p /usr/local/src/ldap; cd /usr/local/src/ldap; \\
    wget -q -O ldap.tgz "${{LDAP_URL}}"; echo "${{LDAP_SHA256}}  ldap.tgz" | sha256sum -c -; \\
    tar -xzf ldap.tgz --strip-components=1 --no-same-owner; \\
    CPPFLAGS="-I${{EMG_MONGO_SSL_DIR}}/include -I${{EMG_MONGO_SASL_DIR}}/include" \\
    LDFLAGS="-L${{OPENSSL_111_LIB_DIR}} -L${{EMG_MONGO_SASL_DIR}}/lib -Wl,-rpath,${{OPENSSL_111_LIB_DIR}}:${{EMG_MONGO_SASL_DIR}}/lib:${{EMG_MONGO_LDAP_DIR}}/lib -Wl,--disable-new-dtags" \\
    ./configure --prefix="${{EMG_MONGO_LDAP_DIR}}" --disable-slapd --disable-static --with-tls=openssl --with-cyrus-sasl \\
      --sysconfdir=/etc; \\
    make -j"$(nproc)" depend; make -j"$(nproc)"; make install; \\
    cd /; rm -rf /usr/local/src/sasl /usr/local/src/ldap

ENV EMG_MONGO_RPATH=${{OPENSSL_111_LIB_DIR}}:${{CURL_817_111_LIB_DIR}}:${{EMG_MONGO_LDAP_DIR}}/lib:${{EMG_MONGO_SASL_DIR}}/lib:${{ZLIB_LIB_DIR}}:${{ZSTD_LIB_DIR}}
'''

PATCH = '''
##################################################################
#     Wire the baked stack into the vendor binaries (DT_RPATH)
##################################################################
# --force-rpath = DT_RPATH (not RUNPATH; it replaces the vendor's RUNPATH): it also applies to the libraries the
# binary loads (libldap -> libsasl2 -> libssl), so nothing falls back to Debian's.
RUN set -eux; \\
    for b in "${{EMG_MONGO_DIR}}"/bin/*; do \\
      file -b "$b" | grep -q ELF || continue; \\
      ldd "$b" | grep -qE 'lib(ssl|crypto|curl|ldap|lber|sasl2)\\.so' || continue; \\
      patchelf --force-rpath --set-rpath "${{EMG_MONGO_RPATH}}" "$b"; \\
    done
'''

EXPORT = '''
##################################################################
#        Export: mongo + exactly the baked prefixes it links
##################################################################
RUN set -eu; \\
    out=/emg-export; \\
    trees="${{EMG_MONGO_DIR}} $(ls -d "${{EMG_LOCAL_BASE_DIR}}"/mongo-tools/* "${{EMG_LOCAL_BASE_DIR}}"/mongosh/* 2>/dev/null || true)"; \\
    elfs="$(for t in $trees; do find "$t" -type f -perm -u+x -exec sh -c 'file -b "$1" | grep -q ELF && echo "$1"' _ {{}} \\; ; done)"; \\
    prefixes="$(for b in $elfs; do ldd "$b" 2>/dev/null | awk '$3 ~ /^\\// {{print $3}}'; done | sort -u \\
                | grep "^${{EMG_LOCAL_BASE_DIR}}/" | xargs -r -n1 dirname \\
                | sed -E 's#/lib(64)?(/x86_64-linux-gnu)?$##' | sort -u)"; \\
    echo "baked prefixes:"; echo "$prefixes"; \\
    mkdir -p "$out"; \\
    for t in $trees; do cp -a --parents "$t" "$out/"; done; \\
    for p in $prefixes; do \\
      case " $trees " in *" $p "*) continue ;; esac; \\
      for d in "$p"/lib "$p"/lib64 "$p"/ssl "$p"/etc; do \\
        [ -e "$d" ] || continue; \\
        mkdir -p "$out$(dirname "$d")"; \\
        if [ "${{d##*/}}" = lib ] || [ "${{d##*/}}" = lib64 ]; then \\
          mkdir -p "$out$d"; \\
          find "$d" -maxdepth 1 \\( -name '*.so' -o -name '*.so.*' \\) -exec cp -a {{}} "$out$d/" \\; ; \\
          for sub in sasl2 ossl-modules engines; do [ -d "$d/$sub" ] && cp -a "$d/$sub" "$out$d/"; done; true; \\
        else cp -a "$d" "$out$(dirname "$d")/"; fi; \\
      done; \\
    done; \\
    du -sh "$out${{EMG_LOCAL_BASE_DIR}}"/*
'''

FINAL = '''
##################################################################
##################################################################
#                       Final image
##################################################################
##################################################################
FROM ghcr.io/epicmorg/debian:trixie
ARG DEBIAN_FRONTEND=noninteractive

ENV EMG_MONGO_VERSION={mm}
ENV EMG_MONGO_FULL_VERSION={ver}
ENV EMG_MONGO_DIR=${{EMG_LOCAL_BASE_DIR}}/mongo/${{EMG_MONGO_VERSION}}
ENV EMG_MONGO_TLS={tls}

LABEL org.opencontainers.image.title="EpicMorg MongoDB"
LABEL org.opencontainers.image.description="MongoDB {ver} (vendor binaries, {tlsdesc}) on Debian trixie, library/mongo + bitnami compatible entrypoint, by EpicMorg"
LABEL org.opencontainers.image.source="https://github.com/EpicMorg/docker"
LABEL org.opencontainers.image.licenses="MIT"

COPY --from=builder /emg-export/ /
COPY --from=builder /emg-export/ /emg-export/

ENV PATH="${{EMG_MONGO_DIR}}/bin{toolpath}:${{PATH}}"

# runtime libraries the vendor build expects from the OS (none of them links OpenSSL
# on the baked flavours - checked below); mongodb = uid 999 as in library/mongo
# (gid 999 is systemd-journal on our base, so the group gets a free system gid;
# the entrypoint only looks at the uid of existing data)
RUN set -eux; \\
    apt-get update; \\
    apt-get install -y --no-install-recommends gosu numactl procps {debs}; \\
    rm -rf /var/lib/apt/lists/*; \\
    groupadd -r mongodb; \\
    useradd -r -u 999 -g mongodb -d /data/db -s /usr/sbin/nologin mongodb; \\
    mkdir -p /data/db /data/configdb /docker-entrypoint-initdb.d; \\
    chown mongodb:mongodb /data/db /data/configdb

COPY usr/local/bin/docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh
RUN chmod 0755 /usr/local/bin/docker-entrypoint.sh

##################################################################
#                       Assertions (fatal)
##################################################################
RUN set -eu; \\
    [ "$(command -v mongod)" = "${{EMG_MONGO_DIR}}/bin/mongod" ] || {{ echo "FATAL: mongod on PATH is $(command -v mongod)" >&2; exit 1; }}; \\
    # 1.0 has no --version: its shell reports the release
    mongod --version 2>&1 | grep -q "${{EMG_MONGO_FULL_VERSION}}" \\
      || mongo --version 2>&1 | grep -q "${{EMG_MONGO_FULL_VERSION}}" \\
      || {{ echo "FATAL: not mongod ${{EMG_MONGO_FULL_VERSION}}" >&2; mongod --version >&2 || true; exit 1; }}; \\
    for d in "${{EMG_MONGO_DIR}}/bin" $(ls -d "${{EMG_LOCAL_BASE_DIR}}"/mongo-tools/*/bin "${{EMG_LOCAL_BASE_DIR}}"/mongosh/*/bin 2>/dev/null || true); do \\
      for b in "$d"/*; do \\
        file -b "$b" | grep -q ELF || continue; \\
        if ldd "$b" | grep -q 'not found'; then echo "FATAL: $b has unresolved deps" >&2; ldd "$b" >&2; exit 1; fi; \\
        case "${{EMG_MONGO_TLS}}" in openssl-*) ! readelf -d "$b" | grep -q '(RUNPATH)' || {{ echo "FATAL: RUNPATH in $b" >&2; exit 1; }} ;; esac; \\
        n="$(ldd "$b" | awk '$1 ~ /^libssl\\.so/ {{print $3}}' | sort -u | wc -l)"; \\
        [ "$n" -le 1 ] || {{ echo "FATAL: $n libssl in $b" >&2; ldd "$b" >&2; exit 1; }}; \\
      done; \\
    done; \\
    ssl="$(ldd "${{EMG_MONGO_DIR}}/bin/mongod" | awk '$1 ~ /^libssl\\.so/ {{print $3}}')"; \\
    case "${{EMG_MONGO_TLS}}" in \\
      none) [ -z "$ssl" ] || {{ echo "FATAL: legacy mongod links $ssl" >&2; exit 1; }} ;; \\
      openssl3) echo "$ssl" | grep -q '^/lib/x86_64-linux-gnu/libssl.so.3$\\|^/usr/lib/x86_64-linux-gnu/libssl.so.3$' || {{ echo "FATAL: mongod libssl is '$ssl'" >&2; exit 1; }} ;; \\
      *) echo "$ssl" | grep -q "^${{EMG_LOCAL_BASE_DIR}}/openssl/" || {{ echo "FATAL: mongod libssl is '$ssl', not the baked one" >&2; exit 1; }}; \\
         ! ldd "${{EMG_MONGO_DIR}}/bin/mongod" | grep -q 'libssl.so.3' || {{ echo "FATAL: OpenSSL 3 in the 1.x mongod" >&2; exit 1; }} ;; \\
    esac; \\
    echo "--- smoke test: entrypoint, root user, auth{tlstest_title} ---"; \\
    vnum="$(echo "${{EMG_MONGO_VERSION}}" | awk -F. '{{ printf "%d%03d", $1, $2 }}')"; \\
    q=--quiet; [ "$vnum" -ge 1004 ] || q=; \\
    auth="-u root -p smoke --authenticationDatabase admin"; [ "$vnum" -ge 2004 ] || auth="-u root -p smoke"; \\
    probe='print("PROBE_" + db.runCommand({{listDatabases: 1}}).ok)'; \\
    t="$(mktemp -d)"; chown mongodb:mongodb "$t"; \\
    MONGO_INITDB_ROOT_USERNAME=root MONGO_INITDB_ROOT_PASSWORD=smoke \\
      docker-entrypoint.sh mongod --dbpath "$t" --port 27999 {smallfiles}> "$t.log" 2>&1 & \\
    shell="$(command -v mongosh || command -v mongo)"; \\
    ok=no; for i in $(seq 1 90); do \\
      "$shell" $q --port 27999 $auth --eval "$probe" admin 2>/dev/null | grep -q PROBE_1 && {{ ok=yes; break; }}; \\
      sleep 1; \\
    done; \\
    [ "$ok" = yes ] || {{ echo "FATAL: no authenticated listDatabases" >&2; cat "$t.log" >&2; exit 1; }}; \\
    ! "$shell" $q --port 27999 --eval "$probe" admin 2>&1 | grep -q PROBE_1 \\
      || {{ echo "FATAL: unauthenticated listDatabases allowed" >&2; exit 1; }}; \\
    "$shell" $q --port 27999 $auth --eval 'db.shutdownServer()' admin >/dev/null 2>&1 || true; \\
    sleep 3;{tlstest} \\
    rm -rf "$t" "$t.log"; \\
    mongod --version 2>&1 | head -3 || true; \\
    ldd "${{EMG_MONGO_DIR}}/bin/mongod" | grep -E 'ssl|crypto|curl|ldap|sasl' || true

VOLUME ["/data/db", "/data/configdb"]
WORKDIR /data
EXPOSE 27017

STOPSIGNAL SIGTERM
ENTRYPOINT ["tini", "--", "docker-entrypoint.sh"]
CMD ["mongod"]
'''

TLSTEST = ''' \\
    echo "--- TLS listener ---"; \\
    openssl req -x509 -newkey rsa:2048 -nodes -days 1 -subj /CN=localhost -keyout "$t/k.pem" -out "$t/c.pem" 2>/dev/null; \\
    cat "$t/k.pem" "$t/c.pem" > "$t/pem"; chown -R mongodb:mongodb "$t"; \\
    mkdir -p "$t/tls"; chown mongodb:mongodb "$t/tls"; \\
    gosu mongodb mongod --dbpath "$t/tls" --port 27998 --bind_ip 127.0.0.1 {tlsflags} > "$t.tls.log" 2>&1 & \\
    ok=no; for i in $(seq 1 60); do \\
      "$shell" $q --port 27998 {tlsclient} --eval "$probe" admin 2>/dev/null | grep -q PROBE_1 && {{ ok=yes; break; }}; \\
      sleep 1; \\
    done; \\
    [ "$ok" = yes ] || {{ echo "FATAL: no ping over TLS" >&2; cat "$t.tls.log" >&2; exit 1; }}; \\
    "$shell" $q --port 27998 {tlsclient} --eval 'db.shutdownServer()' admin >/dev/null 2>&1 || true; \\
    sleep 3; rm -f "$t.tls.log";'''


def dockerfile(mm, ver, url, sha):
    flavour, target = LINES[mm]
    v = vkey(mm)
    s = HEAD.format(flavour=flavour, mm=mm, ver=ver, url=url, sha=sha)
    toolpath = ''
    if v >= (4, 4):
        s += EXTRA_TOOLS.format(turl=TOOLS[1], tsha=TOOLS[2], tver=TOOLS[0])
        toolpath += ':${EMG_LOCAL_BASE_DIR}/mongo-tools/%s/bin' % TOOLS[0]
    if v >= (6, 0):
        s += EXTRA_MONGOSH.format(surl=MONGOSH[1], ssha=MONGOSH[2], sver=MONGOSH[0])
        toolpath += ':${EMG_LOCAL_BASE_DIR}/mongosh/%s/bin' % MONGOSH[0]
    if flavour == 'openssl102':
        s += STACK_102.format(xurl=XENIAL[1], xsha=XENIAL[2], xdurl=XENIAL[3], xdsha=XENIAL[4]) + PATCH.format()
    elif flavour == 'openssl111':
        s += STACK_111.format(saslver=SASL[0], saslurl=SASL[1], saslsha=SASL[2],
                              ldapver=OPENLDAP[0], ldapurl=OPENLDAP[1], ldapsha=OPENLDAP[2]) + PATCH.format()
    s += EXPORT.format()
    debs = {
        'legacy': '',
        'openssl102': '',
        'openssl111': 'libgssapi-krb5-2 liblzma5 libnghttp2-14 libbrotli1',
        'openssl3': 'libcurl4t64 libgssapi-krb5-2 libldap2 libsasl2-2 liblzma5 libssl3t64',
    }[flavour]
    tls, tlsdesc = {
        'legacy': ('none', 'no TLS'),
        'openssl102': ('openssl-1.0.2g-ubuntu', 'TLS on a baked OpenSSL 1.0.2g'),
        'openssl111': ('openssl-1.1.1', 'TLS on a baked OpenSSL 1.1.1'),
        'openssl3': ('openssl3', 'TLS on Debian OpenSSL 3'),
    }[flavour]
    tlstest = ''
    if flavour != 'legacy':
        if v >= (4, 2):
            flags = '--tlsMode requireTLS --tlsCertificateKeyFile "$t/pem" --tlsCAFile "$t/c.pem" --tlsAllowConnectionsWithoutCertificates'
            client = '--tls --tlsAllowInvalidCertificates'
        else:
            flags = '--sslMode requireSSL --sslPEMKeyFile "$t/pem" --sslCAFile "$t/c.pem" --sslAllowConnectionsWithoutCertificates'
            client = '--ssl --sslAllowInvalidCertificates'
        tlstest = TLSTEST.format(tlsflags=flags + (' --smallfiles' if v < (3, 2) else ''), tlsclient=client)
    # MMAPv1 (default before 3.2) preallocates GBs per database: keep the smoke test small
    smallfiles = '--smallfiles ' if (2, 0) <= v < (3, 2) else ''
    s += FINAL.format(mm=mm, ver=ver, tls=tls, tlsdesc=tlsdesc, toolpath=toolpath, debs=debs,
                      tlstest_title=', TLS' if tlstest else '', tlstest=tlstest, smallfiles=smallfiles)
    return s


def compose(mm, ver, extra):
    out = ['services:', '  app:', '    image: "epicmorg/mongo:%s"' % mm, '    build:', '      context: .',
           '    x-squash: false', '    x-mirrors:']
    for t in [mm, ver] + extra:
        out += ['      - %s/epicmorg/mongo:%s' % (reg, t) for reg in ('quay.io', 'ghcr.io', 'docker.io')]
    return '\n'.join(out) + '\n'


def main():
    dry = '--dry-run' in sys.argv
    argv = [a for a in sys.argv[1:] if a != '--dry-run']
    args = dict(zip(argv[::2], argv[1::2]))
    only = set(filter(None, args.get('--only', '').split(',')))
    full = json.loads(get(FULL))
    vers = newest(full)
    lines = sorted(LINES, key=vkey)
    top_of_major = {}
    for mm in lines:
        top_of_major[mm.split('.')[0]] = mm
    newest_line = lines[-1]
    for mm in lines:
        if only and mm not in only:
            continue
        ver = vers[mm]
        flavour, target = LINES[mm]
        extra = ([mm.split('.')[0]] if top_of_major[mm.split('.')[0]] == mm else []) + (['latest'] if mm == newest_line else [])
        print('%-4s %-8s %-11s %-10s %s' % (mm, ver, flavour, target or 'generic', ' '.join(extra)))
        if dry:
            continue
        url, sha = tarball(full, ver, target)
        leaf = os.path.join(BASE, mm)
        os.makedirs(os.path.join(leaf, 'usr', 'local', 'bin'), exist_ok=True)
        if not os.path.isfile(os.path.join(leaf, 'Makefile')):
            shutil.copy(MAKEFILE, leaf)
        shutil.copy2(ENTRYPOINT, os.path.join(leaf, 'usr', 'local', 'bin', 'docker-entrypoint.sh'))
        open(os.path.join(leaf, 'Dockerfile'), 'w').write(dockerfile(mm, ver, url, sha))
        open(os.path.join(leaf, 'docker-compose.yml'), 'w').write(compose(mm, ver, extra))


if __name__ == '__main__':
    main()
