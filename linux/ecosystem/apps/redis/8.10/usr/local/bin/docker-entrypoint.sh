#!/bin/bash
# epicmorg/redis entrypoint: a drop-in for bitnami/redis.
#
# It reads the same REDIS_* / ALLOW_EMPTY_PASSWORD variables (+ *_FILE secrets),
# takes the same mounts (/bitnami/redis/data, /opt/bitnami/redis/mounted-etc/
# {redis.conf,overrides.conf}) and the same defaults (AOF on, RDB off, remote
# connections allowed, no password only with ALLOW_EMPTY_PASSWORD=yes).
# Native paths: data /data, config /etc/redis/{redis.conf,overrides.conf}.
#
# Every start renders /run/redis/redis.conf (0600, holds the password) from the
# base config + the variables; redis-server runs as redis (uid 1001, like
# bitnami) when the container starts as root.
#
# Not covered (separate bitnami images / scripts): sentinel and cluster setup.
set -euo pipefail

log() { echo "redis $(date '+%F %T') $*"; }
die() { echo "redis $(date '+%F %T') FATAL: $*" >&2; exit 1; }
is_yes() { case "${1,,}" in yes|true|1|on) return 0 ;; *) return 1 ;; esac; }

# <VAR>_FILE -> <VAR> (docker / compose secrets), as bitnami does
for v in REDIS_PASSWORD REDIS_MASTER_PASSWORD REDIS_TLS_KEY_FILE_PASS; do
    f="${v}_FILE"
    if [ -n "${!f:-}" ]; then
        [ -r "${!f}" ] || die "${f}=${!f} is not readable"
        printf -v "$v" '%s' "$(< "${!f}")"
    fi
done

# first argument is a flag (or nothing): run redis-server with it;
# anything else (redis-cli, bash, ...) is executed as is
if [ "$#" -gt 0 ] && [ "${1#-}" = "$1" ] && [ "$1" != "redis-server" ]; then
    exec "$@"
fi
[ "${1:-}" = "redis-server" ] && shift

: "${REDIS_PORT_NUMBER:=6379}"
: "${REDIS_AOF_ENABLED:=yes}"
: "${REDIS_RDB_POLICY:=}"
: "${REDIS_RDB_POLICY_DISABLED:=no}"
: "${REDIS_ALLOW_REMOTE_CONNECTIONS:=yes}"
: "${REDIS_DISABLE_COMMANDS:=}"
: "${REDIS_EXTRA_FLAGS:=}"
: "${REDIS_PASSWORD:=}"
: "${REDIS_ACLFILE:=}"
: "${REDIS_IO_THREADS:=}"
: "${REDIS_IO_THREADS_DO_READS:=}"
: "${REDIS_REPLICATION_MODE:=}"
: "${REDIS_MASTER_HOST:=}"
: "${REDIS_MASTER_PORT_NUMBER:=6379}"
: "${REDIS_MASTER_PASSWORD:=}"
: "${REDIS_REPLICA_IP:=}"
: "${REDIS_REPLICA_PORT:=}"
: "${REDIS_TLS_ENABLED:=no}"
: "${REDIS_TLS_PORT_NUMBER:=6379}"
: "${REDIS_TLS_CERT_FILE:=}"
: "${REDIS_TLS_KEY_FILE:=}"
: "${REDIS_TLS_KEY_FILE_PASS:=}"
: "${REDIS_TLS_CA_FILE:=}"
: "${REDIS_TLS_CA_DIR:=}"
: "${REDIS_TLS_DH_PARAMS_FILE:=}"
: "${REDIS_TLS_AUTH_CLIENTS:=yes}"
: "${ALLOW_EMPTY_PASSWORD:=no}"

# data dir: explicit REDIS_DATA_DIR, else the bitnami path when it is mounted, else /data
if [ -z "${REDIS_DATA_DIR:-}" ]; then
    if [ -d /bitnami/redis/data ]; then REDIS_DATA_DIR=/bitnami/redis/data; else REDIS_DATA_DIR=/data; fi
fi
# base config and overrides: ours, else bitnami's mounted-etc, else the shipped default
base_conf="${REDIS_CONF_FILE:-}"
if [ -z "$base_conf" ]; then
    for c in /etc/redis/redis.conf /opt/bitnami/redis/mounted-etc/redis.conf; do
        [ -f "$c" ] && { base_conf="$c"; break; }
    done
fi
[ -n "$base_conf" ] || base_conf="${EMG_REDIS_DIR}/etc/redis.conf"
overrides="${REDIS_OVERRIDES_FILE:-}"
if [ -z "$overrides" ]; then
    for c in /etc/redis/overrides.conf /opt/bitnami/redis/mounted-etc/overrides.conf; do
        [ -f "$c" ] && { overrides="$c"; break; }
    done
fi

if [ -z "$REDIS_PASSWORD" ] && [ -z "$REDIS_ACLFILE" ] && ! is_yes "$ALLOW_EMPTY_PASSWORD"; then
    die "REDIS_PASSWORD is empty. Set it (or REDIS_PASSWORD_FILE / REDIS_ACLFILE), or ALLOW_EMPTY_PASSWORD=yes for development only"
fi
if is_yes "$REDIS_TLS_ENABLED"; then
    [ -n "$REDIS_TLS_CERT_FILE" ] && [ -n "$REDIS_TLS_KEY_FILE" ] || die "REDIS_TLS_ENABLED=yes needs REDIS_TLS_CERT_FILE and REDIS_TLS_KEY_FILE"
    [ -n "$REDIS_TLS_CA_FILE" ] || [ -n "$REDIS_TLS_CA_DIR" ] || die "REDIS_TLS_ENABLED=yes needs REDIS_TLS_CA_FILE or REDIS_TLS_CA_DIR"
fi
case "$REDIS_REPLICATION_MODE" in
    ''|master) ;;
    slave|replica) [ -n "$REDIS_MASTER_HOST" ] || die "REDIS_REPLICATION_MODE=$REDIS_REPLICATION_MODE needs REDIS_MASTER_HOST" ;;
    *) die "REDIS_REPLICATION_MODE must be master or replica, not '$REDIS_REPLICATION_MODE'" ;;
esac

# config values go in double quotes; escape what redis would interpret
q() { local s="${1//\\/\\\\}"; s="${s//\"/\\\"}"; printf '"%s"' "$s"; }

mkdir -p /run/redis "$REDIS_DATA_DIR"
conf=/run/redis/redis.conf
(
    umask 077
    {
        echo "# rendered by docker-entrypoint.sh at $(date -u '+%FT%TZ') - edit the variables, not this file"
        echo "include $(q "$base_conf")"
        echo "daemonize no"
        echo "supervised no"
        echo 'logfile ""'
        echo "pidfile /run/redis/redis.pid"
        echo "dir $(q "$REDIS_DATA_DIR")"
        if is_yes "$REDIS_ALLOW_REMOTE_CONNECTIONS"; then
            echo "bind 0.0.0.0"
            echo "protected-mode no"
        fi
        if is_yes "$REDIS_TLS_ENABLED"; then
            if [ "$REDIS_TLS_PORT_NUMBER" = "$REDIS_PORT_NUMBER" ]; then echo "port 0"; else echo "port $REDIS_PORT_NUMBER"; fi
            echo "tls-port $REDIS_TLS_PORT_NUMBER"
            echo "tls-cert-file $(q "$REDIS_TLS_CERT_FILE")"
            echo "tls-key-file $(q "$REDIS_TLS_KEY_FILE")"
            [ -n "$REDIS_TLS_KEY_FILE_PASS" ] && echo "tls-key-file-pass $(q "$REDIS_TLS_KEY_FILE_PASS")"
            if [ -n "$REDIS_TLS_CA_FILE" ]; then echo "tls-ca-cert-file $(q "$REDIS_TLS_CA_FILE")"; else echo "tls-ca-cert-dir $(q "$REDIS_TLS_CA_DIR")"; fi
            [ -n "$REDIS_TLS_DH_PARAMS_FILE" ] && echo "tls-dh-params-file $(q "$REDIS_TLS_DH_PARAMS_FILE")"
            echo "tls-auth-clients $REDIS_TLS_AUTH_CLIENTS"
            [ -n "$REDIS_MASTER_HOST" ] && echo "tls-replication yes"
        else
            echo "port $REDIS_PORT_NUMBER"
        fi
        if is_yes "$REDIS_AOF_ENABLED"; then echo "appendonly yes"; else echo "appendonly no"; fi
        # `save` lines add up: reset whatever the base config has first
        echo 'save ""'
        if ! is_yes "$REDIS_RDB_POLICY_DISABLED"; then
            for p in $REDIS_RDB_POLICY; do echo "save ${p//#/ }"; done
        fi
        [ -n "$REDIS_IO_THREADS" ] && echo "io-threads $REDIS_IO_THREADS"
        [ -n "$REDIS_IO_THREADS_DO_READS" ] && echo "io-threads-do-reads $REDIS_IO_THREADS_DO_READS"
        [ -n "$REDIS_PASSWORD" ] && echo "requirepass $(q "$REDIS_PASSWORD")"
        [ -n "$REDIS_ACLFILE" ] && echo "aclfile $(q "$REDIS_ACLFILE")"
        IFS=',' read -r -a cmds <<< "$REDIS_DISABLE_COMMANDS"
        for c in "${cmds[@]}"; do
            c="${c// /}"; [ -n "$c" ] && echo "rename-command $c \"\""
        done
        case "$REDIS_REPLICATION_MODE" in
            slave|replica)
                echo "replicaof $REDIS_MASTER_HOST $REDIS_MASTER_PORT_NUMBER"
                [ -n "$REDIS_MASTER_PASSWORD" ] && echo "masterauth $(q "$REDIS_MASTER_PASSWORD")"
                [ -n "$REDIS_REPLICA_IP" ] && echo "replica-announce-ip $REDIS_REPLICA_IP"
                [ -n "$REDIS_REPLICA_PORT" ] && echo "replica-announce-port $REDIS_REPLICA_PORT"
                ;;
            master)
                # replicas of this master authenticate with the same password
                [ -n "$REDIS_PASSWORD" ] && echo "masterauth $(q "$REDIS_PASSWORD")"
                ;;
        esac
        if [ -n "$overrides" ]; then echo "include $(q "$overrides")"; fi
    } > "$conf"
)

args=("$conf")
read -r -a extra <<< "$REDIS_EXTRA_FLAGS"
args+=("${extra[@]}" "$@")

log "data: $REDIS_DATA_DIR, base config: $base_conf${overrides:+, overrides: $overrides}"
if [ "$(id -u)" = 0 ]; then
    # data written by bitnami (uid 1001) or by a root-run redis: hand it to redis
    [ "$(stat -c %u "$REDIS_DATA_DIR")" = 1001 ] || chown -R redis:root "$REDIS_DATA_DIR"
    chown -R redis:root /run/redis
    exec gosu redis redis-server "${args[@]}"
fi
exec redis-server "${args[@]}"
