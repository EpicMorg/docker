#!/bin/sh
# epicmorg/vault entrypoint: a drop-in for hashicorp/vault (written for this image).
#   flags or a vault subcommand -> vault <args>;  anything else runs as is
#   vault server: -config=/vault/config (VAULT_LOCAL_CONFIG is written there as
#     local.json), -dev gets VAULT_DEV_ROOT_TOKEN_ID / VAULT_DEV_LISTEN_ADDRESS,
#     VAULT_REDIRECT_INTERFACE / VAULT_CLUSTER_INTERFACE -> VAULT_API_ADDR /
#     VAULT_CLUSTER_ADDR from that interface's address; /vault/{config,file,logs}
#     handed to vault, cap_ipc_lock set on the binary (SKIP_SETCAP / SKIP_CHOWN to
#     opt out), then vault runs as the vault user.
set -e

VAULT_CONFIG_DIR=/vault/config

if [ "${1#-}" != "$1" ]; then
    set -- vault "$@"
fi
# a vault subcommand without the leading "vault"
if [ -n "$1" ] && [ "$1" != vault ] && vault --help "$1" 2>&1 | grep -q "vault $1"; then
    set -- vault "$@"
fi

get_addr() {   # get_addr <interface> <port>
    ip addr show dev "$1" 2>/dev/null | awk -v p="$2" '$1 == "inet" { split($2, a, "/"); print a[1] ":" p; exit }'
}

if [ "$1" = vault ] && [ "$2" = server ]; then
    if [ -n "${VAULT_REDIRECT_INTERFACE:-}" ]; then
        export VAULT_API_ADDR="http://$(get_addr "$VAULT_REDIRECT_INTERFACE" "${VAULT_PORT:-8200}")"
    fi
    if [ -n "${VAULT_CLUSTER_INTERFACE:-}" ]; then
        export VAULT_CLUSTER_ADDR="https://$(get_addr "$VAULT_CLUSTER_INTERFACE" "${VAULT_CLUSTER_PORT:-8201}")"
    fi
    if [ -n "${VAULT_LOCAL_CONFIG:-}" ]; then
        echo "$VAULT_LOCAL_CONFIG" > "$VAULT_CONFIG_DIR/local.json"
    fi
    shift 2
    case " $* " in
        *" -dev "*|*" -dev="*|*" --dev "*)
            if [ -n "${VAULT_DEV_ROOT_TOKEN_ID:-}" ]; then set -- "$@" -dev-root-token-id="$VAULT_DEV_ROOT_TOKEN_ID"; fi
            set -- "$@" -dev-listen-address="${VAULT_DEV_LISTEN_ADDRESS:-0.0.0.0:8200}" ;;
    esac
    set -- vault server -config="$VAULT_CONFIG_DIR" "$@"
fi

if [ "$1" = vault ] && [ "$(id -u)" = 0 ]; then
    if [ -z "${SKIP_CHOWN:-}" ]; then
        for d in /vault/config /vault/file /vault/logs; do
            [ "$(stat -c %U "$d")" = vault ] || chown -R vault:vault "$d"
        done
    fi
    if [ -z "${SKIP_SETCAP:-}" ]; then
        # memory locking needs IPC_LOCK in the container (--cap-add IPC_LOCK)
        if ! setcap cap_ipc_lock=+ep "$(readlink -f "$(command -v vault)")" 2>/dev/null \
           || ! vault -version >/dev/null 2>&1; then
            setcap -r "$(readlink -f "$(command -v vault)")" 2>/dev/null || true
            echo "vault-entrypoint: could not enable mlock (add --cap-add IPC_LOCK, or set disable_mlock / SKIP_SETCAP)" >&2
        fi
    fi
    exec gosu vault "$@"
fi
exec "$@"
