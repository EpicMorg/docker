#!/bin/bash
# epicmorg/rabbitmq entrypoint: a drop-in for library/rabbitmq and bitnami/rabbitmq.
#
# library mode (default): as library/rabbitmq - RabbitMQ reads RABBITMQ_DEFAULT_USER /
# _PASS / _VHOST itself, config in /etc/rabbitmq (rabbitmq.conf + conf.d/), data in
# /var/lib/rabbitmq, uid 999; the cookie is $HOME/.erlang.cookie.
#
# bitnami mode - on when /bitnami/rabbitmq is mounted or a bitnami-only variable is
# set (RABBITMQ_USERNAME, RABBITMQ_PASSWORD, RABBITMQ_PLUGINS, RABBITMQ_VHOSTS, ...):
# writes /etc/rabbitmq/rabbitmq.conf (unless present), rabbitmq-env.conf and
# enabled_plugins from the bitnami variables as bitnami/rabbitmq does, data in
# /bitnami/rabbitmq/mnesia when mounted (node name rabbit@localhost by default, so an
# existing bitnami volume starts), /bitnami/rabbitmq/conf/* copied over /etc/rabbitmq,
# vhosts / permissions / cluster join / definitions on the first start,
# RABBITMQ_FORCE_BOOT, RABBITMQ_UPDATE_PASSWORD, /docker-entrypoint-initdb.d/*.sh.
#
# Not covered: RABBITMQ_COMMUNITY_PLUGINS downloads, RABBITMQ_CLUSTER_REBALANCE.
set -euo pipefail

log() { echo "rabbitmq-entrypoint $(date -u '+%FT%TZ') $*"; }
die() { log "FATAL: $*" >&2; exit 1; }
is_yes() { case "${1,,}" in yes|true|1|on) return 0 ;; *) return 1 ;; esac; }

# allow the container to be started with `--user`; anything not rabbitmq* is exec'd as is
if [[ "${1:-}" == rabbitmq* ]] && [ "$(id -u)" = 0 ]; then
    if [ "$1" = rabbitmq-server ]; then
        dirs=(/var/lib/rabbitmq /etc/rabbitmq /var/log/rabbitmq)
        [ -d /bitnami/rabbitmq ] && dirs+=(/bitnami/rabbitmq)
        [ -n "${RABBITMQ_MNESIA_BASE:-}" ] && mkdir -p "$RABBITMQ_MNESIA_BASE" && dirs+=("$RABBITMQ_MNESIA_BASE")
        [ -n "${HOME:-}" ] && [ -d "$HOME" ] && dirs+=("$HOME")
        find "${dirs[@]}" \! -user rabbitmq -exec chown rabbitmq '{}' + 2>/dev/null || true
    fi
    exec gosu rabbitmq "${BASH_SOURCE[0]}" "$@"
fi
if [[ "${1:-}" != rabbitmq-server ]]; then
    exec "$@"
fi

# <VAR>_FILE -> <VAR> (docker / compose secrets)
for v in RABBITMQ_DEFAULT_USER RABBITMQ_DEFAULT_PASS RABBITMQ_PASSWORD RABBITMQ_ERL_COOKIE RABBITMQ_ERLANG_COOKIE; do
    f="${v}_FILE"
    if [ -n "${!f:-}" ]; then
        [ -r "${!f}" ] || die "${f}=${!f} is not readable"
        printf -v "$v" '%s' "$(< "${!f}")"
        export "${v?}"
        unset "$f"
    fi
done

# if long and short hostnames are not the same, use long hostnames (= library)
if [ -z "${RABBITMQ_USE_LONGNAME:-}" ] && [ "$(hostname)" != "$(hostname -s)" ]; then
    export RABBITMQ_USE_LONGNAME=true
fi

# Erlang cookie from the environment (bitnami: RABBITMQ_ERL_COOKIE; the old library one too)
cookie="${RABBITMQ_ERL_COOKIE:-${RABBITMQ_ERLANG_COOKIE:-}}"
unset RABBITMQ_ERLANG_COOKIE
if [ -n "$cookie" ]; then
    cf="${HOME}/.erlang.cookie"
    if [ ! -f "$cf" ] || [ "$(cat "$cf")" != "$cookie" ]; then
        rm -f "$cf"; printf '%s' "$cookie" > "$cf"
    fi
    chmod 400 "$cf"
fi

# ---- bitnami mode? ----------------------------------------------------------------
bitnami=no
[ -d /bitnami/rabbitmq ] && bitnami=yes
for v in RABBITMQ_USERNAME RABBITMQ_PASSWORD RABBITMQ_PLUGINS RABBITMQ_VHOST RABBITMQ_VHOSTS RABBITMQ_NODE_TYPE \
         RABBITMQ_NODE_NAME RABBITMQ_CLUSTER_NODE_NAME RABBITMQ_LOAD_DEFINITIONS RABBITMQ_SECURE_PASSWORD \
         RABBITMQ_UPDATE_PASSWORD RABBITMQ_FORCE_BOOT RABBITMQ_ERL_COOKIE RABBITMQ_NODE_PORT_NUMBER \
         RABBITMQ_MANAGEMENT_PORT_NUMBER RABBITMQ_MANAGEMENT_BIND_IP RABBITMQ_MANAGEMENT_ALLOW_WEB_ACCESS \
         RABBITMQ_ENABLE_LDAP RABBITMQ_SSL_CERTFILE RABBITMQ_SSL_CERT_FILE RABBITMQ_DISK_FREE_ABSOLUTE_LIMIT \
         RABBITMQ_VM_MEMORY_HIGH_WATERMARK RABBITMQ_NODE_DEFAULT_QUEUE_TYPE RABBITMQ_CLUSTER_PARTITION_HANDLING; do
    [ -n "${!v:-}" ] && { bitnami=yes; break; }
done

if [ "$bitnami" = no ]; then
    exec "$@"
fi

# ---- bitnami mode: settings (names and defaults of bitnami/rabbitmq) -------------------
CONF_DIR=/etc/rabbitmq
CONF_FILE="${RABBITMQ_CONF_FILE:-${RABBITMQ_CONFIG_FILE:-${CONF_DIR}/rabbitmq.conf}}"
ENV_FILE="${CONF_DIR}/rabbitmq-env.conf"
if [ -d /bitnami/rabbitmq ]; then
    : "${RABBITMQ_MNESIA_BASE:=/bitnami/rabbitmq/mnesia}"
    MOUNTED_CONF_DIR=/bitnami/rabbitmq/conf
else
    : "${RABBITMQ_MNESIA_BASE:=/var/lib/rabbitmq/mnesia}"
    MOUNTED_CONF_DIR=/bitnami/rabbitmq/conf
fi
export RABBITMQ_MNESIA_BASE
: "${RABBITMQ_USERNAME:=user}"
: "${RABBITMQ_PASSWORD:=bitnami}"
: "${RABBITMQ_VHOST:=/}"
: "${RABBITMQ_VHOSTS:=}"
: "${RABBITMQ_NODE_TYPE:=stats}"
: "${RABBITMQ_NODE_NAME:=rabbit@localhost}"
: "${RABBITMQ_NODE_PORT_NUMBER:=5672}"
: "${RABBITMQ_NODE_SSL_PORT_NUMBER:=5671}"
: "${RABBITMQ_NODE_DEFAULT_QUEUE_TYPE:=}"
: "${RABBITMQ_CLUSTER_NODE_NAME:=}"
: "${RABBITMQ_CLUSTER_PARTITION_HANDLING:=ignore}"
: "${RABBITMQ_DISK_FREE_RELATIVE_LIMIT:=1.0}"
: "${RABBITMQ_DISK_FREE_ABSOLUTE_LIMIT:=}"
: "${RABBITMQ_VM_MEMORY_HIGH_WATERMARK:=}"
: "${RABBITMQ_LOAD_DEFINITIONS:=no}"
: "${RABBITMQ_DEFINITIONS_FILE:=/app/load_definition.json}"
: "${RABBITMQ_SECURE_PASSWORD:=no}"
: "${RABBITMQ_UPDATE_PASSWORD:=no}"
: "${RABBITMQ_FORCE_BOOT:=no}"
: "${RABBITMQ_MANAGEMENT_BIND_IP:=0.0.0.0}"
: "${RABBITMQ_MANAGEMENT_PORT_NUMBER:=15672}"
: "${RABBITMQ_MANAGEMENT_SSL_PORT_NUMBER:=15671}"
: "${RABBITMQ_MANAGEMENT_ALLOW_WEB_ACCESS:=false}"
: "${RABBITMQ_ENABLE_LDAP:=no}"
: "${RABBITMQ_LDAP_TLS:=no}"
: "${RABBITMQ_LDAP_SERVERS:=}"
: "${RABBITMQ_LDAP_SERVERS_PORT:=389}"
: "${RABBITMQ_LDAP_USER_DN_PATTERN:=}"
RABBITMQ_SSL_CACERTFILE="${RABBITMQ_SSL_CACERTFILE:-${RABBITMQ_SSL_CACERT_FILE:-}}"
RABBITMQ_SSL_CERTFILE="${RABBITMQ_SSL_CERTFILE:-${RABBITMQ_SSL_CERT_FILE:-}}"
RABBITMQ_SSL_KEYFILE="${RABBITMQ_SSL_KEYFILE:-${RABBITMQ_SSL_KEY_FILE:-}}"
: "${RABBITMQ_SSL_PASSWORD:=}"
: "${RABBITMQ_SSL_DEPTH:=}"
: "${RABBITMQ_SSL_FAIL_IF_NO_PEER_CERT:=no}"
: "${RABBITMQ_SSL_VERIFY:=verify_none}"
: "${RABBITMQ_MANAGEMENT_SSL_CACERTFILE:=$RABBITMQ_SSL_CACERTFILE}"
: "${RABBITMQ_MANAGEMENT_SSL_CERTFILE:=$RABBITMQ_SSL_CERTFILE}"
: "${RABBITMQ_MANAGEMENT_SSL_KEYFILE:=$RABBITMQ_SSL_KEYFILE}"
: "${RABBITMQ_MANAGEMENT_SSL_PASSWORD:=$RABBITMQ_SSL_PASSWORD}"
: "${RABBITMQ_MANAGEMENT_SSL_DEPTH:=}"
: "${RABBITMQ_MANAGEMENT_SSL_FAIL_IF_NO_PEER_CERT:=yes}"
: "${RABBITMQ_MANAGEMENT_SSL_VERIFY:=verify_peer}"
export RABBITMQ_NODENAME="${RABBITMQ_NODE_NAME}"
# RabbitMQ itself would also act on these - the generated config is the source here
unset RABBITMQ_DEFAULT_USER RABBITMQ_DEFAULT_PASS RABBITMQ_DEFAULT_VHOST

ctl() { rabbitmqctl -n "$RABBITMQ_NODENAME" "$@"; }

[ -d "$MOUNTED_CONF_DIR" ] && [ -n "$(ls -A "$MOUNTED_CONF_DIR" 2>/dev/null)" ] && cp -Lr "$MOUNTED_CONF_DIR"/* "$CONF_DIR"/

ssl_on() {   # ssl_on <ENV PREFIX>: any of the three files given
    local k v
    for k in CACERTFILE CERTFILE KEYFILE; do v="RABBITMQ_${1}_${k}"; [ -n "${!v:-}" ] && return 0; done
    return 1
}
ssl_conf() {   # ssl_conf <ENV PREFIX> <conf prefix>
    local k v val
    for k in cacertfile certfile keyfile password depth fail_if_no_peer_cert verify; do
        v="RABBITMQ_${1}_${k^^}"; val="${!v:-}"
        [ -n "$val" ] || continue
        if [ "$k" = fail_if_no_peer_cert ]; then is_yes "$val" && val=true || val=false; fi
        echo "$2.$k = $val"
    done
}

if [ ! -f "$CONF_FILE" ]; then
    log "writing $CONF_FILE (bitnami variables)"
    {
        echo "## generated by epicmorg/rabbitmq from the bitnami/rabbitmq variables on the first start"
        echo "cluster_partition_handling = ${RABBITMQ_CLUSTER_PARTITION_HANDLING}"
        echo "default_permissions.configure = .*"
        echo "default_permissions.read = .*"
        echo "default_permissions.write = .*"
        echo "log.console = true"
        [ -n "$RABBITMQ_NODE_DEFAULT_QUEUE_TYPE" ] && echo "default_queue_type = ${RABBITMQ_NODE_DEFAULT_QUEUE_TYPE}"
        if is_yes "$RABBITMQ_LOAD_DEFINITIONS"; then
            echo "load_definitions = ${RABBITMQ_DEFINITIONS_FILE}"
        else
            echo "default_vhost = ${RABBITMQ_VHOST}"
            echo "default_user = ${RABBITMQ_USERNAME}"
            is_yes "$RABBITMQ_SECURE_PASSWORD" || echo "default_pass = ${RABBITMQ_PASSWORD}"
        fi
        if ssl_on SSL; then
            echo "listeners.ssl.default = ${RABBITMQ_NODE_SSL_PORT_NUMBER}"
            ssl_conf SSL ssl_options
        else
            echo "listeners.tcp.default = ${RABBITMQ_NODE_PORT_NUMBER}"
        fi
        if ssl_on MANAGEMENT_SSL; then
            echo "management.ssl.ip = ${RABBITMQ_MANAGEMENT_BIND_IP}"
            echo "management.ssl.port = ${RABBITMQ_MANAGEMENT_SSL_PORT_NUMBER}"
            ssl_conf MANAGEMENT_SSL management.ssl
        else
            echo "management.tcp.ip = ${RABBITMQ_MANAGEMENT_BIND_IP}"
            echo "management.tcp.port = ${RABBITMQ_MANAGEMENT_PORT_NUMBER}"
        fi
        if is_yes "$RABBITMQ_MANAGEMENT_ALLOW_WEB_ACCESS"; then
            echo "loopback_users.${RABBITMQ_USERNAME} = false"
        else
            echo "loopback_users.${RABBITMQ_USERNAME} = true"
        fi
        if is_yes "$RABBITMQ_ENABLE_LDAP"; then
            echo "auth_backends.1 = rabbit_auth_backend_ldap"
            echo "auth_backends.2 = internal"
            echo "auth_ldap.port = ${RABBITMQ_LDAP_SERVERS_PORT}"
            echo "auth_ldap.user_dn_pattern = ${RABBITMQ_LDAP_USER_DN_PATTERN}"
            i=1
            for s in $(tr ',;' '  ' <<< "$RABBITMQ_LDAP_SERVERS"); do echo "auth_ldap.servers.$i = $s"; i=$((i + 1)); done
            is_yes "$RABBITMQ_LDAP_TLS" && echo "auth_ldap.use_ssl = true"
        fi
        m="$RABBITMQ_VM_MEMORY_HIGH_WATERMARK"
        if [ -n "$m" ]; then
            if [[ "$m" =~ ^[0-9]+([kKmMgGtTpP]B?|[kKmMgGtTpP]iB)?$ ]] && ! [[ "$m" =~ ^0*[01](\.[0-9]+)?$ ]]; then
                echo "vm_memory_high_watermark.absolute = $m"
            else
                [[ "$m" =~ %$ ]] && m="$(awk '{ print $1 / 100 }' <<< "${m%\%}")"
                printf 'vm_memory_high_watermark.relative = %.03f\n' "$m"
            fi
        fi
        if [ -n "$RABBITMQ_DISK_FREE_ABSOLUTE_LIMIT" ]; then
            echo "disk_free_limit.absolute = ${RABBITMQ_DISK_FREE_ABSOLUTE_LIMIT}"
        else
            echo "disk_free_limit.relative = ${RABBITMQ_DISK_FREE_RELATIVE_LIMIT}"
        fi
    } > "$CONF_FILE"
    # inject custom.conf (bitnami: key = value lines override the generated ones)
    if [ -f "${CONF_DIR}/custom.conf" ]; then
        while IFS='=' read -r k v || [ -n "$k" ]; do
            k="$(echo "$k" | xargs)"; v="$(echo "$v" | xargs)"
            [ -n "$k" ] || continue
            grep -v "^${k//./\\.} *=" "$CONF_FILE" > "$CONF_FILE.tmp" || true
            echo "$k = $v" >> "$CONF_FILE.tmp"; mv "$CONF_FILE.tmp" "$CONF_FILE"
        done < <(grep -E '^\w.*\s?=\s?.*' "${CONF_DIR}/custom.conf")
        rm -f "${CONF_DIR}/custom.conf"
    fi
fi
[ -f "$ENV_FILE" ] || printf 'NODE_PORT=%s\nNODENAME=%s\n' "$RABBITMQ_NODE_PORT_NUMBER" "$RABBITMQ_NODENAME" > "$ENV_FILE"

# enabled_plugins (bitnami rules) - unless a mounted one is there
if [ -n "${RABBITMQ_PLUGINS:-}" ] || is_yes "$RABBITMQ_ENABLE_LDAP" || [ "$RABBITMQ_NODE_TYPE" != stats ]; then
    if [ -n "${RABBITMQ_PLUGINS:-}" ]; then
        plugins=(rabbitmq_management_agent rabbitmq_prometheus $(tr ',;' '  ' <<< "$RABBITMQ_PLUGINS"))
    else
        plugins=()
        [ "$RABBITMQ_NODE_TYPE" = stats ] && plugins=(rabbitmq_management rabbitmq_prometheus)
        [ "$RABBITMQ_NODE_TYPE" != stats ] && plugins=(rabbitmq_management_agent rabbitmq_prometheus)
        is_yes "$RABBITMQ_ENABLE_LDAP" && plugins+=(rabbitmq_auth_backend_ldap)
    fi
    [ -f /bitnami/rabbitmq/conf/enabled_plugins ] || echo "[$(IFS=,; echo "${plugins[*]}")]." > "${CONF_DIR}/enabled_plugins"
fi

# cookie: bitnami generates a random one when none is given
if [ ! -f "${HOME}/.erlang.cookie" ]; then
    head -c 256 /dev/urandom | tr -dc A-Za-z0-9 | head -c 32 > "${HOME}/.erlang.cookie"
    chmod 400 "${HOME}/.erlang.cookie"
fi

pid=
start_bg() {
    log "starting RabbitMQ in the background ($RABBITMQ_NODENAME)"
    rabbitmq-server > /tmp/rabbitmq-init.log 2>&1 &
    pid=$!
    ctl wait --pid "$pid" --timeout 120 >/dev/null 2>&1 || { cat /tmp/rabbitmq-init.log >&2; die "RabbitMQ did not start"; }
}
stop_bg() {
    [ -n "$pid" ] || return 0
    log "stopping the background RabbitMQ"
    ctl stop >/dev/null 2>&1 || kill "$pid" 2>/dev/null || true
    wait "$pid" 2>/dev/null || true
    pid=
}
trap stop_bg EXIT

node_dir="${RABBITMQ_MNESIA_BASE}/${RABBITMQ_NODENAME}"
if [ -n "$(ls -A "$RABBITMQ_MNESIA_BASE" 2>/dev/null)" ]; then
    log "persisted data detected in $RABBITMQ_MNESIA_BASE"
    if is_yes "$RABBITMQ_FORCE_BOOT" && [ -n "$(ls -A "$node_dir" 2>/dev/null)" ]; then
        log "forcing the node to boot"
        ctl force_boot >/dev/null
    fi
    if is_yes "$RABBITMQ_UPDATE_PASSWORD" && { is_yes "$RABBITMQ_SECURE_PASSWORD" || is_yes "$RABBITMQ_LOAD_DEFINITIONS"; }; then
        start_bg
        if ! is_yes "$RABBITMQ_LOAD_DEFINITIONS" || ! grep -q '"users"' "$RABBITMQ_DEFINITIONS_FILE"; then
            log "updating the password of $RABBITMQ_USERNAME"
            ctl change_password -- "$RABBITMQ_USERNAME" "$RABBITMQ_PASSWORD" >/dev/null
        fi
    fi
else
    start_bg
    if is_yes "$RABBITMQ_LOAD_DEFINITIONS"; then
        if ! grep -q '"users"' "$RABBITMQ_DEFINITIONS_FILE"; then
            ctl add_user -- "$RABBITMQ_USERNAME" "$RABBITMQ_PASSWORD" >/dev/null
            ctl set_user_tags "$RABBITMQ_USERNAME" administrator >/dev/null
        fi
    elif is_yes "$RABBITMQ_SECURE_PASSWORD"; then
        ctl change_password -- "$RABBITMQ_USERNAME" "$RABBITMQ_PASSWORD" >/dev/null
    fi
    for vh in $RABBITMQ_VHOSTS; do
        IFS=':' read -r name qtype <<< "$vh"
        log "declaring vhost $name"
        if [ -n "${qtype:-}" ]; then ctl add_vhost --default-queue-type "$qtype" -- "$name" >/dev/null
        else ctl add_vhost -- "$name" >/dev/null; fi
        ctl set_permissions --vhost "$name" -- "$RABBITMQ_USERNAME" '.*' '.*' '.*' >/dev/null
    done
    if [ "$RABBITMQ_NODE_TYPE" != stats ] && [ -n "$RABBITMQ_CLUSTER_NODE_NAME" ]; then
        log "joining the cluster of $RABBITMQ_CLUSTER_NODE_NAME"
        ctl stop_app >/dev/null
        for i in $(seq 1 120); do rabbitmq-plugins --node "$RABBITMQ_CLUSTER_NODE_NAME" is_enabled rabbitmq_management >/dev/null 2>&1 && break; sleep 1; done
        args=("$RABBITMQ_CLUSTER_NODE_NAME"); [ "$RABBITMQ_NODE_TYPE" = queue-ram ] && args+=(--ram)
        ctl join_cluster "${args[@]}" >/dev/null || die "cannot cluster with $RABBITMQ_CLUSTER_NODE_NAME"
        ctl start_app >/dev/null
    fi
fi

if compgen -G '/docker-entrypoint-initdb.d/*.sh' >/dev/null; then
    [ -n "$pid" ] || start_bg
    for f in /docker-entrypoint-initdb.d/*.sh; do
        log "running $f"
        if [ -x "$f" ]; then "$f" || die "$f failed"; else . "$f"; fi
    done
fi
stop_bg
trap - EXIT

if [ -n "${RABBITMQ_ULIMIT_NOFILES:-}" ] && [ "$(ulimit -n)" != unlimited ] && [ "$RABBITMQ_ULIMIT_NOFILES" -gt "$(ulimit -n)" ]; then
    ulimit -n "$RABBITMQ_ULIMIT_NOFILES" || true
fi
log "starting RabbitMQ ($RABBITMQ_NODENAME, bitnami variables)"
exec "$@"
