#!/bin/bash
# epicmorg/mongo entrypoint (every line 1.2 .. 9.x), compatible with library/mongo:
#   * `docker run epicmorg/mongo --flag` = `mongod --flag`; anything else is exec'd as is;
#   * mongod runs as mongodb (uid/gid 999, as library/mongo) when the container starts as root;
#     /data/db and /data/configdb are handed to it;
#   * first start on an empty dbpath: MONGO_INITDB_ROOT_USERNAME / _PASSWORD (+ *_FILE) create the
#     root user, /docker-entrypoint-initdb.d/*.sh|*.js run against MONGO_INITDB_DATABASE (default
#     test) on a temporary localhost-only mongod; then mongod starts with --auth;
# plus the common bitnami/mongodb variables:
#   MONGODB_ROOT_USER (root) / MONGODB_ROOT_PASSWORD   -> MONGO_INITDB_ROOT_*
#   MONGODB_USERNAME / MONGODB_PASSWORD / MONGODB_DATABASE -> readWrite user in that database
#   MONGODB_PORT_NUMBER -> --port, MONGODB_EXTRA_FLAGS -> extra mongod flags,
#   /bitnami/mongodb mounted -> --dbpath /bitnami/mongodb/data/db.
set -Eeuo pipefail

log() { echo "mongo-entrypoint $(date -u '+%FT%TZ') $*"; }
die() { log "FATAL: $*" >&2; exit 1; }

# <VAR>_FILE -> <VAR>
for v in MONGO_INITDB_ROOT_USERNAME MONGO_INITDB_ROOT_PASSWORD MONGODB_ROOT_PASSWORD MONGODB_PASSWORD; do
    f="${v}_FILE"
    if [ -n "${!f:-}" ]; then
        [ -r "${!f}" ] || die "${f}=${!f} is not readable"
        printf -v "$v" '%s' "$(< "${!f}")"
        export "${v?}"
    fi
done

# bitnami -> library
if [ -n "${MONGODB_ROOT_PASSWORD:-}" ] && [ -z "${MONGO_INITDB_ROOT_PASSWORD:-}" ]; then
    export MONGO_INITDB_ROOT_USERNAME="${MONGODB_ROOT_USER:-root}"
    export MONGO_INITDB_ROOT_PASSWORD="${MONGODB_ROOT_PASSWORD}"
fi
if [ -n "${MONGODB_DATABASE:-}" ] && [ -z "${MONGO_INITDB_DATABASE:-}" ]; then
    export MONGO_INITDB_DATABASE="${MONGODB_DATABASE}"
fi

if [ "${1:0:1}" = '-' ] || [ "$#" -eq 0 ]; then
    set -- mongod "$@"
fi
if [ "$1" != mongod ]; then
    exec "$@"
fi
shift

# --- mongod: options -------------------------------------------------------------
args=("$@")
has_arg() { local a; for a in "${args[@]}"; do case "$a" in "$1"|"$1"=*) return 0 ;; esac; done; return 1; }
arg_val() {   # value of --opt / --opt=value from the command line
    local i a
    for ((i = 0; i < ${#args[@]}; i++)); do
        a="${args[$i]}"
        case "$a" in
            "$1"=*) echo "${a#*=}"; return 0 ;;
            "$1") echo "${args[$((i + 1))]:-}"; return 0 ;;
        esac
    done
    return 1
}
if [ -n "${MONGODB_EXTRA_FLAGS:-}" ]; then
    read -r -a extra <<< "${MONGODB_EXTRA_FLAGS}"
    args+=("${extra[@]}")
fi
if [ -n "${MONGODB_PORT_NUMBER:-}" ] && ! has_arg --port; then
    args+=(--port "${MONGODB_PORT_NUMBER}")
fi
if ! has_arg --dbpath && ! has_arg --config && ! has_arg -f && [ -d /bitnami/mongodb ]; then
    mkdir -p /bitnami/mongodb/data/db
    args+=(--dbpath /bitnami/mongodb/data/db)
fi
dbpath="$(arg_val --dbpath || echo /data/db)"
version="$(mongod --version 2>/dev/null | sed -nE 's/^db version v?([0-9]+\.[0-9]+).*/\1/p' | head -n1)"
[ -n "$version" ] || version="$(mongod --version 2>&1 | grep -oE '[0-9]+\.[0-9]+\.[0-9]+' | head -n1 | cut -d. -f1,2)"
vnum() { echo "$1" | awk -F. '{ printf "%d%03d", $1, $2 }'; }
ver="$(vnum "${version:-0.0}")"

# 3.6+ binds localhost only by default; library/mongo listens everywhere
if [ "$ver" -ge 3006 ] && ! has_arg --bind_ip && ! has_arg --bind_ip_all && ! has_arg --config && ! has_arg -f; then
    args+=(--bind_ip_all)
fi

# --- root: hand data over to mongodb, re-exec as it ----------------------------------
if [ "$(id -u)" = 0 ]; then
    mkdir -p "$dbpath" /data/configdb
    for d in "$dbpath" /data/configdb; do
        [ "$(stat -c %u "$d")" = 999 ] || chown -R mongodb:mongodb "$d"
    done
    exec gosu mongodb "${BASH_SOURCE[0]}" mongod "${args[@]}"
fi

# --- first start on an empty dbpath ------------------------------------------------
shell=()
if command -v mongosh >/dev/null 2>&1 && [ "$ver" -ge 4002 ]; then shell=(mongosh --quiet)
elif command -v mongo >/dev/null 2>&1; then shell=(mongo); [ "$ver" -ge 1004 ] && shell+=(--quiet)
fi

fresh=no
[ -z "$(ls -A "$dbpath" 2>/dev/null | grep -vE '^(lost\+found|\.keep)$' || true)" ] && fresh=yes
initdb_files=no
compgen -G '/docker-entrypoint-initdb.d/*' >/dev/null && initdb_files=yes

if [ "$fresh" = yes ] && { [ -n "${MONGO_INITDB_ROOT_USERNAME:-}" ] || [ "$initdb_files" = yes ] || [ -n "${MONGODB_USERNAME:-}" ]; }; then
    if [ -n "${MONGO_INITDB_ROOT_USERNAME:-}" ] && [ -z "${MONGO_INITDB_ROOT_PASSWORD:-}" ]; then
        die "MONGO_INITDB_ROOT_USERNAME is set but MONGO_INITDB_ROOT_PASSWORD is not"
    fi
    [ "${#shell[@]}" -gt 0 ] || die "no mongo shell in the image for the first-start initialisation"
    log "empty dbpath $dbpath: initialising (mongod $version)"
    port=27017
    tmplog="$(mktemp)"
    # temporary mongod: localhost only, no --auth, same storage flags as the real one
    tmp_args=(--port "$port" --bind_ip 127.0.0.1 --dbpath "$dbpath")
    for a in "${args[@]}"; do
        case "$a" in --auth|--keyFile*|--replSet*|--bind_ip*|--port*|--config*|-f) ;; *) : ;; esac
    done
    mongod "${tmp_args[@]}" --logpath "$tmplog" --fork >/dev/null 2>&1 \
        || mongod "${tmp_args[@]}" --logpath "$tmplog" > /dev/null 2>&1 &
    # readiness: listDatabases + a marker (works from the 1.2 shell to mongosh)
    up() { "${shell[@]}" --port "$port" --eval 'print("UP_" + db.runCommand({listDatabases: 1}).ok)' admin 2>/dev/null | grep -q UP_1; }
    for i in $(seq 1 60); do up && break; sleep 1; done
    up || { cat "$tmplog" >&2; die "temporary mongod did not start"; }

    js_str() { local s="${1//\\/\\\\}"; s="${s//\'/\\\'}"; printf "'%s'" "$s"; }
    create_user() {   # db user password role
        local fn=createUser
        [ "$ver" -lt 2006 ] && fn=addUser
        if [ "$fn" = createUser ]; then
            "${shell[@]}" --port "$port" "$1" --eval "db.createUser({user: $(js_str "$2"), pwd: $(js_str "$3"), roles: [{role: $(js_str "$4"), db: $(js_str "$1")}]})" >/dev/null
        else
            "${shell[@]}" --port "$port" "$1" --eval "db.addUser($(js_str "$2"), $(js_str "$3"))" >/dev/null
        fi
    }
    if [ -n "${MONGO_INITDB_ROOT_USERNAME:-}" ]; then
        create_user admin "$MONGO_INITDB_ROOT_USERNAME" "$MONGO_INITDB_ROOT_PASSWORD" root \
            || die "cannot create the root user"
        log "root user [$MONGO_INITDB_ROOT_USERNAME] created"
    fi
    if [ -n "${MONGODB_USERNAME:-}" ]; then
        [ -n "${MONGODB_PASSWORD:-}" ] || die "MONGODB_USERNAME needs MONGODB_PASSWORD"
        create_user "${MONGODB_DATABASE:-test}" "$MONGODB_USERNAME" "$MONGODB_PASSWORD" readWrite \
            || die "cannot create user [$MONGODB_USERNAME]"
        log "user [$MONGODB_USERNAME] created in [${MONGODB_DATABASE:-test}]"
    fi
    export MONGO_INITDB_DATABASE="${MONGO_INITDB_DATABASE:-test}"
    for f in /docker-entrypoint-initdb.d/*; do
        case "$f" in
            *.sh) log "running $f"; . "$f" ;;
            *.js) log "running $f"; "${shell[@]}" --port "$port" "$MONGO_INITDB_DATABASE" "$f" ;;
            *) [ -e "$f" ] && log "ignoring $f" ;;
        esac
    done
    "${shell[@]}" --port "$port" admin --eval 'db.shutdownServer()' >/dev/null 2>&1 || true
    for i in $(seq 1 60); do pgrep -x mongod >/dev/null || break; sleep 1; done
    rm -f "$tmplog"
    log "initialisation done"
fi

# auth on when a root user was configured (library/mongo behaviour)
if [ -n "${MONGO_INITDB_ROOT_USERNAME:-}" ] && ! has_arg --auth && ! has_arg --noauth && ! has_arg --config && ! has_arg -f; then
    args+=(--auth)
fi

numa=()
if command -v numactl >/dev/null 2>&1 && numactl --interleave=all true >/dev/null 2>&1; then
    numa=(numactl --interleave=all)
fi
exec "${numa[@]}" mongod "${args[@]}"
