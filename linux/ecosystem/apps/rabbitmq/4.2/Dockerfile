##################################################################
#        Erlang/OTP: our runtime image of the matching major
##################################################################
# All rabbitmq leaves share this file; they differ only in the EMG_RABBITMQ_*
# block and the erlang FROM line (bin/python/rabbitmq-versions-sync.py picks
# the OTP major per line from RabbitMQ's compatibility matrix).
FROM ghcr.io/epicmorg/erlang:27 AS erlang

##################################################################
##################################################################
#                       Final image
##################################################################
##################################################################
FROM ghcr.io/epicmorg/debian:trixie
ARG DEBIAN_FRONTEND=noninteractive

ENV EMG_RABBITMQ_VERSION=4.2
ENV EMG_RABBITMQ_FULL_VERSION=4.2.9
ENV EMG_RABBITMQ_OTP=27
ENV EMG_RABBITMQ_DIR=${EMG_LOCAL_BASE_DIR}/rabbitmq/${EMG_RABBITMQ_VERSION}
# GPG signature (RabbitMQ release key 0x0A9AF2115F4687BD29803A206B73A36E6026DFCA) checked by the sync script, pinned here
ARG EMG_RABBITMQ_SHA256=974df01a83a5c26843925827981603e2f955ba7f38236a7b3f9142e182ad8083
ARG EMG_RABBITMQ_URL=https://github.com/rabbitmq/rabbitmq-server/releases/download/v${EMG_RABBITMQ_FULL_VERSION}/rabbitmq-server-generic-unix-${EMG_RABBITMQ_FULL_VERSION}.tar.xz

LABEL org.opencontainers.image.title="EpicMorg RabbitMQ"
LABEL org.opencontainers.image.description="RabbitMQ on Debian trixie and our Erlang/OTP (baked OpenSSL), management plugin on, library/rabbitmq and bitnami/rabbitmq compatible, by EpicMorg"
LABEL org.opencontainers.image.source="https://github.com/EpicMorg/docker"
LABEL org.opencontainers.image.licenses="MIT"

# Erlang + its OpenSSL (self-contained tree, see epicmorg/erlang)
COPY --from=erlang /emg-export/ /

ENV EMG_ERLANG_DIR=${EMG_LOCAL_BASE_DIR}/erlang/${EMG_RABBITMQ_OTP}
# = library/rabbitmq
ENV RABBITMQ_HOME=/opt/rabbitmq
ENV RABBITMQ_DATA_DIR=/var/lib/rabbitmq
ENV HOME=/var/lib/rabbitmq
ENV PATH="${RABBITMQ_HOME}/sbin:${EMG_ERLANG_DIR}/bin:${PATH}"
ENV LANG=C.UTF-8 LANGUAGE=C.UTF-8 LC_ALL=C.UTF-8
ENV RUNNING_UNDER_SYSTEMD=true

##################################################################
#                RabbitMQ (generic-unix tarball)
##################################################################
# rabbitmq = uid 999 as in library/rabbitmq (gid 999 is systemd-journal on our
# base, so the group gets a free system gid). /opt/rabbitmq -> the versioned
# tree, /opt/bitnami/rabbitmq too (bitnami scripts and docs point there);
# /plugins as library. Data / config dirs are world-writable for --user runs
# (as library/rabbitmq does).
RUN set -eux; \
    apt-get update; \
    apt-get install -y --no-install-recommends xz-utils; \
    rm -rf /var/lib/apt/lists/*; \
    groupadd -r rabbitmq; \
    useradd -r -u 999 -g rabbitmq -d "${RABBITMQ_DATA_DIR}" -s /usr/sbin/nologin rabbitmq; \
    mkdir -p "${EMG_RABBITMQ_DIR}" /opt/bitnami; \
    curl -fsSL -o /tmp/rabbitmq.tar.xz "${EMG_RABBITMQ_URL}"; \
    echo "${EMG_RABBITMQ_SHA256}  /tmp/rabbitmq.tar.xz" | sha256sum -c -; \
    tar -xJf /tmp/rabbitmq.tar.xz -C "${EMG_RABBITMQ_DIR}" --strip-components=1 --no-same-owner; \
    rm -f /tmp/rabbitmq.tar.xz; \
    # the tarball defaults to $RABBITMQ_HOME/var/{lib,log}; use the library paths
    sed -i -E 's!^SYS_PREFIX=.*$!SYS_PREFIX=!' "${EMG_RABBITMQ_DIR}/sbin/rabbitmq-defaults"; \
    grep -q '^SYS_PREFIX=$' "${EMG_RABBITMQ_DIR}/sbin/rabbitmq-defaults"; \
    ln -s "${EMG_RABBITMQ_DIR}" "${RABBITMQ_HOME}"; \
    ln -s "${EMG_RABBITMQ_DIR}" /opt/bitnami/rabbitmq; \
    ln -s "${RABBITMQ_HOME}/plugins" /plugins; \
    mkdir -p "${RABBITMQ_DATA_DIR}" /etc/rabbitmq/conf.d /tmp/rabbitmq-ssl /var/log/rabbitmq /docker-entrypoint-initdb.d; \
    chown -R rabbitmq:rabbitmq "${RABBITMQ_DATA_DIR}" /etc/rabbitmq /tmp/rabbitmq-ssl /var/log/rabbitmq; \
    chmod 1777 "${RABBITMQ_DATA_DIR}" /etc/rabbitmq /etc/rabbitmq/conf.d /tmp/rabbitmq-ssl /var/log/rabbitmq; \
    ln -sf "${RABBITMQ_DATA_DIR}/.erlang.cookie" /root/.erlang.cookie

# library/rabbitmq defaults (guest allowed from anywhere, logs to stdout);
# management on by default (= the :<ver>-management images, bitnami's default)
COPY etc/rabbitmq/conf.d/ /etc/rabbitmq/conf.d/
RUN set -eux; \
    chown rabbitmq:rabbitmq /etc/rabbitmq/conf.d/*; \
    gosu rabbitmq rabbitmq-plugins enable --offline rabbitmq_management rabbitmq_prometheus; \
    test -s /etc/rabbitmq/enabled_plugins; \
    rm -rf "${RABBITMQ_DATA_DIR}"/* "${RABBITMQ_DATA_DIR}"/.erlang.cookie

COPY usr/local/bin/docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh
RUN chmod 0755 /usr/local/bin/docker-entrypoint.sh

##################################################################
#                       Assertions (fatal)
##################################################################
RUN set -eu; \
    [ "$(command -v rabbitmq-server)" = "${RABBITMQ_HOME}/sbin/rabbitmq-server" ] || { echo "FATAL: rabbitmq-server on PATH is $(command -v rabbitmq-server)" >&2; exit 1; }; \
    [ "$(command -v erl)" = "${EMG_ERLANG_DIR}/bin/erl" ] || { echo "FATAL: erl on PATH is $(command -v erl)" >&2; exit 1; }; \
    erl -noshell -eval 'io:format("~s~n", [erlang:system_info(otp_release)]), halt().' | grep -qx "${EMG_RABBITMQ_OTP}" \
      || { echo "FATAL: Erlang is not OTP ${EMG_RABBITMQ_OTP}" >&2; exit 1; }; \
    ls "${RABBITMQ_HOME}/plugins" | grep -q "^rabbit-${EMG_RABBITMQ_FULL_VERSION}" || { echo "FATAL: not RabbitMQ ${EMG_RABBITMQ_FULL_VERSION}" >&2; ls "${RABBITMQ_HOME}/plugins" | head >&2; exit 1; }; \
    echo "--- smoke test: library mode (RABBITMQ_DEFAULT_*), bitnami mode (RABBITMQ_USERNAME, vhosts), management API, restart ---"; \
    port_free() { ! grep -qi "^ *[0-9]*: [0-9A-F]*:$(printf %04X "$1") " /proc/net/tcp /proc/net/tcp6 2>/dev/null; }; \
    pick() { q=0; while [ "$q" = 0 ] || ! port_free "$q" || ! port_free $((q + 20000)); do q="$(shuf -i 20000-40000 -n 1)"; done; echo "$q"; }; \
    # gosu sets HOME=/var/lib/rabbitmq: node and CLI share the cookie there (removed at the end)
    t="$(mktemp -d)"; chown rabbitmq:rabbitmq "$t"; chmod 0777 "$t"; \
    export ERL_EPMD_PORT="$(pick)"; \
    run() { node="smoke$1@localhost"; p="$(pick)"; mp="$(pick)"; pp="$(pick)"; \
      printf 'listeners.tcp.default = %s\nmanagement.tcp.port = %s\nmanagement.tcp.ip = 127.0.0.1\nprometheus.tcp.port = %s\nprometheus.tcp.ip = 127.0.0.1\n' "$p" "$mp" "$pp" > /etc/rabbitmq/conf.d/90-smoke.conf; \
      BN=; shift; case "$*" in *BN_PORTS=1*) BN=1; set -- "$@" RABBITMQ_NODE_PORT_NUMBER="$p" RABBITMQ_MANAGEMENT_PORT_NUMBER="$mp" RABBITMQ_MANAGEMENT_BIND_IP=127.0.0.1 RABBITMQ_NODE_NAME="$node" ;; esac; \
      env RABBITMQ_NODENAME="$node" RABBITMQ_MNESIA_BASE="$t/mnesia" RABBITMQ_LOG_BASE="$t/log" "$@" docker-entrypoint.sh rabbitmq-server > "$t/out" 2>&1 & \
      # bitnami mode: the init node answers too - wait for the final start
      for i in $(seq 1 120); do \
        { [ -z "${BN:-}" ] || grep -q 'starting RabbitMQ (' "$t/out"; } && curl -fs -u "$user:$pass" "http://127.0.0.1:$mp/api/overview" >/dev/null 2>&1 && return 0; \
        sleep 1; \
      done; \
      cat "$t/out" >&2; return 1; }; \
    beams() { for c in $(grep -lx 'beam.smp' /proc/[0-9]*/comm 2>/dev/null); do d="${c%/comm}"; echo "${d#/proc/}"; done; }; \
    stop() { gosu rabbitmq rabbitmqctl -n "$node" stop >/dev/null 2>&1 || true; \
      for i in $(seq 1 60); do [ -z "$(beams)" ] && return 0; sleep 1; done; \
      echo "rabbitmqctl stop did not stop $node - killing it" >&2; kill $(beams) 2>/dev/null || true; sleep 3; }; \
    user=lib; pass=libpw; \
    run A RABBITMQ_DEFAULT_USER=lib RABBITMQ_DEFAULT_PASS=libpw || { echo "FATAL: library mode: management API does not answer" >&2; exit 1; }; \
    curl -fs -u lib:libpw "http://127.0.0.1:$mp/api/overview" | grep -q "\"rabbitmq_version\":\"${EMG_RABBITMQ_FULL_VERSION}\"" || { echo "FATAL: API reports another version" >&2; exit 1; }; \
    beam="$(grep -lx 'beam.smp' /proc/[0-9]*/comm 2>/dev/null | head -1)"; \
    [ -n "$beam" ] && [ "$(stat -c %U "${beam%/comm}")" = rabbitmq ] || { echo "FATAL: RabbitMQ does not run as rabbitmq" >&2; exit 1; }; \
    stop; rm -rf "$t/mnesia"; \
    user=bn; pass=bnpw; \
    run B RABBITMQ_USERNAME=bn RABBITMQ_PASSWORD=bnpw RABBITMQ_MANAGEMENT_ALLOW_WEB_ACCESS=true RABBITMQ_VHOSTS="v1 v2" BN_PORTS=1 || { echo "FATAL: bitnami mode: management API does not answer" >&2; exit 1; }; \
    curl -fs -u bn:bnpw "http://127.0.0.1:$mp/api/vhosts" | grep -q '"name":"v2"' || { echo "FATAL: RABBITMQ_VHOSTS not declared" >&2; curl -s -u bn:bnpw "http://127.0.0.1:$mp/api/vhosts" >&2; grep rabbitmq-entrypoint "$t/out" >&2; exit 1; }; \
    curl -fs -u bn:bnpw "http://127.0.0.1:$mp/api/permissions/v1/bn" >/dev/null || { echo "FATAL: no permissions on v1" >&2; exit 1; }; \
    stop; \
    run B RABBITMQ_USERNAME=bn RABBITMQ_PASSWORD=bnpw RABBITMQ_MANAGEMENT_ALLOW_WEB_ACCESS=true BN_PORTS=1 || { echo "FATAL: restart on persisted data failed" >&2; exit 1; }; \
    grep -q 'persisted data' "$t/out" || { echo "FATAL: second start did not detect persisted data" >&2; cat "$t/out" >&2; exit 1; }; \
    stop; \
    rm -rf "$t" /etc/rabbitmq/conf.d/90-smoke.conf /etc/rabbitmq/rabbitmq.conf /etc/rabbitmq/rabbitmq-env.conf "${RABBITMQ_DATA_DIR}"/.erlang.cookie "${RABBITMQ_DATA_DIR}"/*; \
    test -s /etc/rabbitmq/enabled_plugins; \
    echo "RabbitMQ ${EMG_RABBITMQ_FULL_VERSION} on OTP $(erl -noshell -eval 'io:format("~s", [erlang:system_info(otp_release)]), halt().')"

VOLUME ["/var/lib/rabbitmq"]
EXPOSE 4369 5671 5672 15671 15672 15691 15692 25672

HEALTHCHECK --interval=30s --timeout=10s --start-period=60s \
        CMD rabbitmq-diagnostics -q ping || exit 1

STOPSIGNAL SIGTERM
ENTRYPOINT ["tini", "--", "docker-entrypoint.sh"]
CMD ["rabbitmq-server"]
