##################################################################
##################################################################
#                          Builder
##################################################################
##################################################################
# All erlang leaves share this file; they differ only in the EMG_ERLANG_*
# block below (bumped by bin/python/erlang-versions-sync.py).
FROM ghcr.io/epicmorg/gcc:14 AS builder

ENV EMG_ERLANG_VERSION=25
ENV EMG_ERLANG_FULL_VERSION=25.3.2.21
# OpenSSL branch the crypto / ssl apps link: 3.5 (LTS) from OTP 25 on; OTP 24
# predates full OpenSSL 3 support ("not yet recommended for production") -> 1.1.1
ENV EMG_ERLANG_OPENSSL=3.5
ENV EMG_ERLANG_DIR=${EMG_LOCAL_BASE_DIR}/erlang/${EMG_ERLANG_VERSION}
# SHA256.txt of the GitHub release
ARG EMG_ERLANG_SHA256=99296fcd97a2053c5fcde7dc0ded2ba261a3baf1491c745fca71bd9804d51443
ARG EMG_ERLANG_URL=https://github.com/erlang/otp/releases/download/OTP-${EMG_ERLANG_FULL_VERSION}/otp_src_${EMG_ERLANG_FULL_VERSION}.tar.gz
ARG EMG_ERLANG_SRC_DIR=/usr/local/src/erlang/${EMG_ERLANG_FULL_VERSION}

RUN set -eux; \
    ssl="${EMG_LOCAL_BASE_DIR}/openssl/${EMG_ERLANG_OPENSSL}"; \
    test -f "$ssl/include/openssl/ssl.h"; \
    apt-get update; \
    apt-get install -y --no-install-recommends libncurses-dev patchelf; \
    rm -rf /var/lib/apt/lists/*

##################################################################
#                    Erlang/OTP from source
##################################################################
# System cc (gcc 14), JIT, crypto / ssl against the baked OpenSSL with a real
# RPATH (--with-ssl-rpath, --disable-new-dtags), nothing in ld.so.conf.
# Left out: GUI / IDE apps (wx, observer, debugger, et), Java (jinterface), ODBC.
RUN set -eux; \
    ssl="${EMG_LOCAL_BASE_DIR}/openssl/${EMG_ERLANG_OPENSSL}"; \
    ssllib="$ssl/lib64"; [ -d "$ssllib" ] || ssllib="$ssl/lib"; \
    mkdir -p "${EMG_ERLANG_SRC_DIR}"; \
    cd "${EMG_ERLANG_SRC_DIR}"; \
    wget -q -O otp.tar.gz "${EMG_ERLANG_URL}"; \
    echo "${EMG_ERLANG_SHA256}  otp.tar.gz" | sha256sum -c -; \
    tar -xzf otp.tar.gz --strip-components=1 --no-same-owner; \
    rm -f otp.tar.gz; \
    CFLAGS="-O2 -g0" LDFLAGS="-Wl,--disable-new-dtags" \
    ./configure --prefix="${EMG_ERLANG_DIR}" \
      --with-ssl="$ssl" --with-ssl-rpath="$ssllib" \
      --enable-jit --enable-kernel-poll \
      --without-javac --without-jinterface --without-odbc \
      --without-wx --without-observer --without-debugger --without-et; \
    # a missing crypto / ssl is only a configure warning (lib/<app>/SKIP) - make it fatal
    if [ -f lib/crypto/SKIP ] || [ -f lib/ssl/SKIP ]; then echo "FATAL: crypto/ssl skipped by configure" >&2; cat lib/crypto/SKIP lib/ssl/SKIP 2>/dev/null >&2; exit 1; fi; \
    make -j"$(nproc)"; \
    make install; \
    # older OTP link the crypto NIFs with their own DED_LD flags (no
    # --disable-new-dtags): RUNPATH -> RPATH, same value, listed in the log
    for f in $(find "${EMG_ERLANG_DIR}" -type f -name '*.so'); do \
      rp="$(readelf -d "$f" | sed -n 's/.*(RUNPATH).*\[\(.*\)\]/\1/p')"; \
      [ -n "$rp" ] || continue; \
      echo "RUNPATH -> RPATH: $f ($rp)"; \
      patchelf --force-rpath --set-rpath "$rp" "$f"; \
    done; \
    cp LICENSE.txt README.md "${EMG_ERLANG_DIR}/" 2>/dev/null || true; \
    cd /; \
    rm -rf "${EMG_ERLANG_SRC_DIR}"

##################################################################
#        Export: erlang + exactly the baked prefixes it links
##################################################################
RUN set -eu; \
    out=/emg-export; \
    elfs="$(find "${EMG_ERLANG_DIR}" -type f \( -perm -u+x -o -name '*.so' \) -exec sh -c 'file -b "$1" | grep -q ELF && echo "$1"' _ {} \;)"; \
    if for b in $elfs; do ldd "$b" 2>/dev/null; done | grep -q 'not found'; then echo "FATAL: unresolved deps in the builder" >&2; for b in $elfs; do ldd "$b" 2>/dev/null | grep 'not found' && echo "  in $b"; done >&2; exit 1; fi; \
    prefixes="$(for b in $elfs; do ldd "$b" 2>/dev/null | awk '$3 ~ /^\// {print $3}'; done | sort -u \
                | grep "^${EMG_LOCAL_BASE_DIR}/" | xargs -r -n1 dirname \
                | sed -E 's#/lib(64)?(/x86_64-linux-gnu)?$##' | grep -v "^${EMG_ERLANG_DIR}" | sort -u)"; \
    echo "baked prefixes:"; echo "$prefixes"; \
    mkdir -p "$out"; \
    cp -a --parents "${EMG_ERLANG_DIR}" "$out/"; \
    for p in $prefixes; do \
      for d in "$p"/lib "$p"/lib64 "$p"/ssl; do \
        [ -d "$d" ] || continue; \
        mkdir -p "$out$d"; \
        if [ "${d##*/}" = ssl ]; then cp -a "$d/." "$out$d/"; \
        else find "$d" -maxdepth 1 \( -name '*.so' -o -name '*.so.*' \) -exec cp -a {} "$out$d/" \; ; \
          for sub in ossl-modules engines-1.1 engines-3; do [ -d "$d/$sub" ] && cp -a "$d/$sub" "$out$d/"; done; true; \
        fi; \
      done; \
    done; \
    du -sh "$out${EMG_LOCAL_BASE_DIR}"/*

##################################################################
##################################################################
#                       Final image
##################################################################
##################################################################
FROM ghcr.io/epicmorg/debian:trixie
ARG DEBIAN_FRONTEND=noninteractive

ENV EMG_ERLANG_VERSION=25
ENV EMG_ERLANG_FULL_VERSION=25.3.2.21
ENV EMG_ERLANG_OPENSSL=3.5
ENV EMG_ERLANG_DIR=${EMG_LOCAL_BASE_DIR}/erlang/${EMG_ERLANG_VERSION}

LABEL org.opencontainers.image.title="EpicMorg Erlang/OTP"
LABEL org.opencontainers.image.description="Erlang/OTP built from source on Debian trixie (JIT, crypto/ssl on baked OpenSSL), by EpicMorg"
LABEL org.opencontainers.image.source="https://github.com/EpicMorg/docker"
LABEL org.opencontainers.image.licenses="MIT"

# erlang + the baked OpenSSL, installed here and kept as a self-contained tree
# in /emg-export for consumers (rabbitmq, ...):
#   COPY --from=ghcr.io/epicmorg/erlang:<otp> /emg-export/ /
COPY --from=builder /emg-export/ /
COPY --from=builder /emg-export/ /emg-export/

ENV PATH="${EMG_ERLANG_DIR}/bin:${PATH}"
ENV LANG=C.UTF-8

##################################################################
#                       Assertions (fatal)
##################################################################
RUN set -eu; \
    [ "$(command -v erl)" = "${EMG_ERLANG_DIR}/bin/erl" ] || { echo "FATAL: erl on PATH is $(command -v erl)" >&2; exit 1; }; \
    rel="$(cat "${EMG_ERLANG_DIR}"/lib/erlang/releases/*/OTP_VERSION | head -1)"; \
    [ "$rel" = "${EMG_ERLANG_FULL_VERSION}" ] || { echo "FATAL: OTP_VERSION is $rel, expected ${EMG_ERLANG_FULL_VERSION}" >&2; exit 1; }; \
    test -x "/emg-export${EMG_ERLANG_DIR}/bin/erl" || { echo "FATAL: /emg-export has no erl" >&2; exit 1; }; \
    for b in $(find "${EMG_ERLANG_DIR}" -type f \( -perm -u+x -o -name '*.so' \) -exec sh -c 'file -b "$1" | grep -q ELF && echo "$1"' _ {} \;); do \
      if ldd "$b" 2>/dev/null | grep -q 'not found'; then echo "FATAL: $b has unresolved deps" >&2; ldd "$b" >&2; exit 1; fi; \
      ! readelf -d "$b" | grep -q '(RUNPATH)' || { echo "FATAL: RUNPATH in $b" >&2; exit 1; }; \
      if ldd "$b" 2>/dev/null | grep -qE 'lib(ssl|crypto)\.so'; then \
        [ "$(ldd "$b" | grep -c 'libcrypto\.so')" = 1 ] || { echo "FATAL: not exactly one libcrypto in $b" >&2; ldd "$b" >&2; exit 1; }; \
        ! ldd "$b" | awk '$1 ~ /^lib(ssl|crypto)\.so/ {print $3}' | grep -vq "^${EMG_LOCAL_BASE_DIR}/openssl/${EMG_ERLANG_OPENSSL}/" \
          || { echo "FATAL: $b: OpenSSL is not the baked ${EMG_ERLANG_OPENSSL}" >&2; ldd "$b" >&2; exit 1; }; \
      fi; \
    done; \
    crypto="$(find "${EMG_ERLANG_DIR}" -name crypto.so -path '*/priv/lib/*' | head -1)"; \
    [ -n "$crypto" ] || { echo "FATAL: no crypto NIF" >&2; exit 1; }; \
    ldd "$crypto" | grep -q "${EMG_LOCAL_BASE_DIR}/openssl/${EMG_ERLANG_OPENSSL}/.*libcrypto" || { echo "FATAL: crypto NIF without the baked libcrypto" >&2; exit 1; }; \
    erl -noshell -eval ' \
      jit = erlang:system_info(emu_flavor), \
      {ok, _} = application:ensure_all_started(ssl), \
      [{<<"OpenSSL">>, _, Lib}] = crypto:info_lib(), \
      <<_:256/bits>> = crypto:hash(sha256, <<"epicmorg">>), \
      true = lists:member(aes_256_gcm, crypto:supports(ciphers)), \
      io:format("OTP ~s, ~s, ~s~n", [erlang:system_info(otp_release), jit, Lib]), halt(0).' \
      || { echo "FATAL: erlang runtime check (JIT / crypto / ssl) failed" >&2; exit 1; }; \
    erl -noshell -eval 'io:format("~s~n", [erlang:system_info(otp_release)]), halt().' | grep -qx "${EMG_ERLANG_VERSION}" \
      || { echo "FATAL: otp_release is not ${EMG_ERLANG_VERSION}" >&2; exit 1; }; \
    erl -noshell -eval '[{_, _, L}] = crypto:info_lib(), io:format("~s~n", [L]), halt().' | grep -q "^OpenSSL ${EMG_ERLANG_OPENSSL}" \
      || { echo "FATAL: crypto does not report OpenSSL ${EMG_ERLANG_OPENSSL}" >&2; exit 1; }
