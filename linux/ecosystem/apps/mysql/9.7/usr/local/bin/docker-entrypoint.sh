#!/bin/bash
# epicmorg/mysql entrypoint (every line 5.6 .. 26.x): a drop-in for library/mysql
# and bitnami/mysql. Written for this image (not derived from either project).
#
# library/mysql behaviour: `docker run epicmorg/mysql --flag` = `mysqld --flag`, any
# other command runs as is; mysqld runs as mysql (uid 999) when started as root;
# on an empty datadir: MYSQL_ROOT_PASSWORD / MYSQL_ALLOW_EMPTY_PASSWORD /
# MYSQL_RANDOM_ROOT_PASSWORD (+ *_FILE), MYSQL_ROOT_HOST (default %), MYSQL_DATABASE,
# MYSQL_USER / MYSQL_PASSWORD, time zone tables (unless MYSQL_INITDB_SKIP_TZINFO),
# /docker-entrypoint-initdb.d/*.sh|*.sql[.gz|.bz2|.xz|.zst], MYSQL_ONETIME_PASSWORD;
# config /etc/mysql/my.cnf + /etc/mysql/conf.d/*.cnf, data /var/lib/mysql.
#
# bitnami/mysql variables on top: ALLOW_EMPTY_PASSWORD, MYSQL_ROOT_USER (an extra
# <user>@% with all privileges), MYSQL_AUTHENTICATION_PLUGIN, MYSQL_CHARACTER_SET /
# MYSQL_COLLATE (server and MYSQL_DATABASE), MYSQL_PORT_NUMBER, MYSQL_BIND_ADDRESS,
# MYSQL_SQL_MODE, MYSQL_ENABLE_SLOW_QUERY / MYSQL_LONG_QUERY_TIME, MYSQL_EXTRA_FLAGS,
# MYSQL_REPLICATION_MODE master|slave (+ MYSQL_REPLICATION_USER / _PASSWORD,
# MYSQL_MASTER_HOST / _PORT_NUMBER / _ROOT_USER / _ROOT_PASSWORD / _DELAY),
# MYSQL_UPGRADE (AUTO / FORCE / NONE: mysql_upgrade on a newer 5.x binary);
# /bitnami/mysql mounted -> datadir /bitnami/mysql/data;
# /opt/bitnami/mysql/conf/my_custom.cnf -> /etc/mysql/conf.d/zz-bitnami-my_custom.cnf.
set -Eeuo pipefail

log() { echo "mysql-entrypoint $(date -u '+%FT%TZ') $*"; }
die() { log "FATAL: $*" >&2; exit 1; }
is_yes() { case "${1,,}" in yes|true|1|on) return 0 ;; *) return 1 ;; esac; }

# <VAR>_FILE -> <VAR>
for v in MYSQL_ROOT_PASSWORD MYSQL_PASSWORD MYSQL_USER MYSQL_DATABASE MYSQL_ROOT_HOST \
         MYSQL_REPLICATION_PASSWORD MYSQL_MASTER_ROOT_PASSWORD; do
    f="${v}_FILE"
    if [ -n "${!f:-}" ]; then
        [ -r "${!f}" ] || die "${f}=${!f} is not readable"
        printf -v "$v" '%s' "$(< "${!f}")"
        export "${v?}"
        unset "$f"
    fi
done

if [ "${1:0:1}" = '-' ] || [ "$#" -eq 0 ]; then
    set -- mysqld "$@"
fi
if [ "$1" != mysqld ] && [ "$1" != mysqld_safe ]; then
    exec "$@"
fi
shift

args=("$@")
has_arg() { local a; for a in "${args[@]}"; do case "$a" in "$1"|"$1"=*) return 0 ;; esac; done; return 1; }
# help / version: straight to mysqld
for a in "${args[@]}"; do
    case "$a" in -'?'|--help|--print-defaults|-V|--version) exec mysqld "${args[@]}" ;; esac
done

# ---- bitnami variables -> mysqld options --------------------------------------
add_opt() { has_arg "$1" || args+=("$1=$2"); }
[ -n "${MYSQL_PORT_NUMBER:-}" ] && add_opt --port "$MYSQL_PORT_NUMBER"
[ -n "${MYSQL_BIND_ADDRESS:-}" ] && add_opt --bind-address "$MYSQL_BIND_ADDRESS"
[ -n "${MYSQL_CHARACTER_SET:-}" ] && add_opt --character-set-server "$MYSQL_CHARACTER_SET"
[ -n "${MYSQL_COLLATE:-}" ] && add_opt --collation-server "$MYSQL_COLLATE"
[ -n "${MYSQL_SQL_MODE:-}" ] && add_opt --sql-mode "$MYSQL_SQL_MODE"
if [ -n "${MYSQL_ENABLE_SLOW_QUERY:-}" ] && [ "${MYSQL_ENABLE_SLOW_QUERY}" != 0 ]; then
    add_opt --slow-query-log 1
    add_opt --long-query-time "${MYSQL_LONG_QUERY_TIME:-10.0}"
fi
case "${MYSQL_REPLICATION_MODE:-}" in
    '') ;;
    master|slave)
        add_opt --server-id "$(( $(od -An -N2 -tu2 /dev/urandom) % 4294967 + 1 ))"
        add_opt --log-bin mysql-bin
        add_opt --sync-binlog 1
        if [ "$MYSQL_REPLICATION_MODE" = slave ]; then
            add_opt --relay-log mysql-relay-bin
            add_opt --log-slave-updates 1
            add_opt --read-only 1
        else
            add_opt --innodb-flush-log-at-trx-commit 1
        fi ;;
    *) die "MYSQL_REPLICATION_MODE must be master or slave" ;;
esac
if [ -n "${MYSQL_EXTRA_FLAGS:-}" ]; then
    read -r -a extra <<< "$MYSQL_EXTRA_FLAGS"
    args+=("${extra[@]}")
fi
if ! has_arg --datadir && [ -d /bitnami/mysql ]; then
    args+=(--datadir=/bitnami/mysql/data)
fi

# version of this mysqld: 5006, 5007, 8000, 8004, 9007, 26010 ...
full="$(mysqld --version | sed -nE 's/.*Ver ([0-9]+\.[0-9]+\.[0-9]+).*/\1/p')"
ver="$(echo "$full" | awk -F. '{ printf "%d%03d", $1, $2 }')"
patch="${full##*.}"

if [ -n "${MYSQL_AUTHENTICATION_PLUGIN:-}" ]; then
    if [ "$ver" -lt 8004 ]; then add_opt --default-authentication-plugin "$MYSQL_AUTHENTICATION_PLUGIN"
    else log "MYSQL_AUTHENTICATION_PLUGIN: no --default-authentication-plugin in MySQL $full, used for the created users only"; fi
fi

# ---- root: hand the datadir over to mysql, re-exec as it ------------------------
cfg() {   # cfg <option>: effective value (my.cnf + arguments), from the variables table of --verbose --help
    mysqld "${args[@]}" --verbose --help 2>/dev/null \
        | awk -v o="$1" '/^-+ +-+$/ { t = 1; next } t && $1 == o { $1 = ""; sub(/^ /, ""); print; exit }'
}
datadir="$(cfg datadir)"; datadir="${datadir%/}"
socket="$(cfg socket)"
[ -n "$datadir" ] || die "cannot read datadir from the mysqld configuration (bad option?): $(mysqld "${args[@]}" --verbose --help 2>&1 >/dev/null | head -3)"

case "$datadir" in /?*) ;; *) die "datadir '$datadir' is not an absolute path" ;; esac
case "$socket" in /?*/*) ;; *) die "socket '$socket' is not an absolute path below a directory" ;; esac
if [ "$(id -u)" = 0 ]; then
    sockdir="$(dirname "$socket")"
    mkdir -p "$datadir" "$sockdir"
    [ -d /bitnami/mysql ] && chown mysql:mysql /bitnami/mysql
    find "$datadir" \! -user mysql -exec chown mysql:mysql '{}' + 2>/dev/null || true
    [ "$(stat -c %U "$sockdir")" = mysql ] || [ "$(stat -c %a "$sockdir")" = 1777 ] || chown mysql:mysql "$sockdir"
    if [ -f /opt/bitnami/mysql/conf/my_custom.cnf ]; then
        cp /opt/bitnami/mysql/conf/my_custom.cnf /etc/mysql/conf.d/zz-bitnami-my_custom.cnf
    fi
    exec gosu mysql "${BASH_SOURCE[0]}" mysqld "${args[@]}"
fi
if [ -f /opt/bitnami/mysql/conf/my_custom.cnf ] && [ -w /etc/mysql/conf.d ]; then
    cp /opt/bitnami/mysql/conf/my_custom.cnf /etc/mysql/conf.d/zz-bitnami-my_custom.cnf
fi

# ---- helpers ------------------------------------------------------------------------
sql_str() { local s="${1//\\/\\\\}"; s="${s//\'/\\\'}"; printf "'%s'" "$s"; }
tmpsock=""
cnf=""
client() { mysql --defaults-extra-file="$cnf" --protocol=socket --socket="$tmpsock" "$@"; }
write_cnf() {   # client credentials file for the temporary server
    cnf="$(mktemp)"; chmod 600 "$cnf"
    printf '[client]\nuser=root\n' > "$cnf"
    if [ -n "${1:-}" ]; then printf 'password="%s"\n' "${1//\"/\\\"}" >> "$cnf"; fi
}
tmp_pid=""
temp_start() {
    tmpsock="$(mktemp -u /tmp/mysqld.XXXXXX).sock"
    log "temporary server ($full) on a socket only"
    mysqld "${args[@]}" --skip-networking --socket="$tmpsock" --pid-file="${tmpsock%.sock}.pid" \
        $( [ "$ver" -ge 8000 ] && echo --mysqlx=OFF ) > /tmp/mysqld-init.log 2>&1 &
    tmp_pid=$!
    for i in $(seq 1 120); do
        mysqladmin --protocol=socket --socket="$tmpsock" ping >/dev/null 2>&1 && return 0
        kill -0 "$tmp_pid" 2>/dev/null || { cat /tmp/mysqld-init.log >&2; die "temporary server exited"; }
        sleep 1
    done
    cat /tmp/mysqld-init.log >&2; die "temporary server did not start"
}
temp_stop() {
    [ -n "$tmp_pid" ] || return 0
    mysqladmin --defaults-extra-file="$cnf" --protocol=socket --socket="$tmpsock" shutdown >/dev/null 2>&1 || kill "$tmp_pid" 2>/dev/null || true
    wait "$tmp_pid" 2>/dev/null || true
    tmp_pid=""
}
trap 'temp_stop; rm -f "$cnf"' EXIT

# ---- first start ----------------------------------------------------------------------
if [ ! -d "$datadir/mysql" ]; then
    root_pw="${MYSQL_ROOT_PASSWORD:-}"
    if [ "${MYSQL_REPLICATION_MODE:-}" = slave ] && [ -z "$root_pw" ]; then root_pw="${MYSQL_MASTER_ROOT_PASSWORD:-}"; fi
    if [ -z "$root_pw" ] && ! is_yes "${MYSQL_ALLOW_EMPTY_PASSWORD:-}" && ! is_yes "${ALLOW_EMPTY_PASSWORD:-}" && ! is_yes "${MYSQL_RANDOM_ROOT_PASSWORD:-}"; then
        die "database is uninitialized and password option is not specified
    You need to specify one of MYSQL_ROOT_PASSWORD, MYSQL_ALLOW_EMPTY_PASSWORD (ALLOW_EMPTY_PASSWORD) or MYSQL_RANDOM_ROOT_PASSWORD"
    fi
    if is_yes "${MYSQL_RANDOM_ROOT_PASSWORD:-}" && [ -z "$root_pw" ]; then
        root_pw="$(head -c 256 /dev/urandom | tr -dc 'A-Za-z0-9' | head -c 32)"
        log "GENERATED ROOT PASSWORD: $root_pw"
    fi
    [ "${MYSQL_USER:-}" = root ] && die "MYSQL_USER=root is not allowed (use MYSQL_ROOT_PASSWORD)"

    log "initializing database files in $datadir (MySQL $full)"
    mkdir -p "$datadir"
    if [ "$ver" -ge 5007 ]; then
        mysqld "${args[@]}" --initialize-insecure --default-time-zone=SYSTEM > /tmp/mysqld-initialize.log 2>&1 \
            || { cat /tmp/mysqld-initialize.log >&2; die "mysqld --initialize-insecure failed"; }
    else
        (cd "$EMG_MYSQL_DIR" && ./scripts/mysql_install_db --defaults-file=/etc/mysql/my.cnf --basedir="$EMG_MYSQL_DIR" \
            --datadir="$datadir" --skip-name-resolve --keep-my-cnf > /tmp/mysqld-initialize.log 2>&1) \
            || { cat /tmp/mysqld-initialize.log >&2; die "mysql_install_db failed"; }
    fi
    write_cnf ""
    temp_start

    if ! is_yes "${MYSQL_INITDB_SKIP_TZINFO:-}"; then
        mysql_tzinfo_to_sql /usr/share/zoneinfo 2>/dev/null | sed 's/Local time zone must be set--see zic manual page/FCTY/' \
            | client mysql || die "loading time zone tables failed"
    fi

    root_host="${MYSQL_ROOT_HOST:-%}"
    {
        echo "SET @@SESSION.SQL_LOG_BIN=0;"
        if [ "$ver" -lt 5007 ]; then
            echo "DELETE FROM mysql.user WHERE user NOT IN ('root') OR host NOT IN ('localhost');"
            echo "SET PASSWORD FOR 'root'@'localhost'=PASSWORD($(sql_str "$root_pw"));"
            echo "DROP DATABASE IF EXISTS test;"
            if [ "$root_host" != localhost ]; then
                echo "GRANT ALL ON *.* TO 'root'@$(sql_str "$root_host") IDENTIFIED BY $(sql_str "$root_pw") WITH GRANT OPTION;"
            fi
        else
            echo "DELETE FROM mysql.user WHERE user NOT IN ('mysql.sys', 'mysql.session', 'mysql.infoschema', 'mysqlxsys', 'root') OR host NOT IN ('localhost');"
            echo "ALTER USER 'root'@'localhost' IDENTIFIED BY $(sql_str "$root_pw");"
            if [ "$root_host" != localhost ]; then
                echo "CREATE USER 'root'@$(sql_str "$root_host") IDENTIFIED BY $(sql_str "$root_pw");"
                echo "GRANT ALL ON *.* TO 'root'@$(sql_str "$root_host") WITH GRANT OPTION;"
            fi
        fi
        echo "FLUSH PRIVILEGES;"
    } | client || die "setting up root failed"
    write_cnf "$root_pw"

    with_plugin=""
    [ -n "${MYSQL_AUTHENTICATION_PLUGIN:-}" ] && [ "$ver" -ge 5007 ] && with_plugin="WITH ${MYSQL_AUTHENTICATION_PLUGIN} "
    create_user() {   # create_user <user> <host> <password>
        if [ "$ver" -lt 5007 ]; then
            echo "CREATE USER $(sql_str "$1")@$(sql_str "$2") IDENTIFIED BY $(sql_str "$3");"
        else
            echo "CREATE USER $(sql_str "$1")@$(sql_str "$2") IDENTIFIED ${with_plugin}BY $(sql_str "$3");"
        fi
    }
    {
        if [ -n "${MYSQL_ROOT_USER:-}" ] && [ "$MYSQL_ROOT_USER" != root ]; then
            create_user "$MYSQL_ROOT_USER" % "$root_pw"
            echo "GRANT ALL ON *.* TO $(sql_str "$MYSQL_ROOT_USER")@'%' WITH GRANT OPTION;"
        fi
        if [ -n "${MYSQL_DATABASE:-}" ]; then
            cs=""; [ -n "${MYSQL_CHARACTER_SET:-}" ] && cs=" CHARACTER SET ${MYSQL_CHARACTER_SET}"
            [ -n "${MYSQL_COLLATE:-}" ] && cs="$cs COLLATE ${MYSQL_COLLATE}"
            echo "CREATE DATABASE IF NOT EXISTS \`${MYSQL_DATABASE//\`/\`\`}\`$cs;"
        fi
        if [ -n "${MYSQL_USER:-}" ]; then
            [ -n "${MYSQL_PASSWORD:-}" ] || is_yes "${ALLOW_EMPTY_PASSWORD:-}" || die "MYSQL_USER needs MYSQL_PASSWORD"
            create_user "$MYSQL_USER" % "${MYSQL_PASSWORD:-}"
            [ -n "${MYSQL_DATABASE:-}" ] && echo "GRANT ALL ON \`${MYSQL_DATABASE//\`/\`\`}\`.* TO $(sql_str "$MYSQL_USER")@'%';"
        fi
        if [ "${MYSQL_REPLICATION_MODE:-}" = master ] && [ -n "${MYSQL_REPLICATION_USER:-}" ]; then
            create_user "$MYSQL_REPLICATION_USER" % "${MYSQL_REPLICATION_PASSWORD:-}"
            echo "GRANT REPLICATION SLAVE ON *.* TO $(sql_str "$MYSQL_REPLICATION_USER")@'%';"
        fi
        echo "FLUSH PRIVILEGES;"
    } | client || die "creating database / users failed"
    [ -n "${MYSQL_DATABASE:-}" ] && log "database [$MYSQL_DATABASE] created"
    [ -n "${MYSQL_USER:-}" ] && log "user [$MYSQL_USER] created"

    if [ "${MYSQL_REPLICATION_MODE:-}" = slave ]; then
        [ -n "${MYSQL_MASTER_HOST:-}" ] || die "slave mode needs MYSQL_MASTER_HOST"
        mport="${MYSQL_MASTER_PORT_NUMBER:-3306}"
        log "waiting for the replication master ${MYSQL_MASTER_HOST}:${mport}"
        for i in $(seq 1 300); do
            mysql --protocol=tcp -h"$MYSQL_MASTER_HOST" -P"$mport" -u"${MYSQL_MASTER_ROOT_USER:-root}" -p"${MYSQL_MASTER_ROOT_PASSWORD:-}" -e 'SELECT 1' >/dev/null 2>&1 && break
            sleep 1
        done
        if [ "$ver" -gt 8000 ] || { [ "$ver" -eq 8000 ] && [ "$patch" -ge 23 ]; }; then
            echo "CHANGE REPLICATION SOURCE TO SOURCE_HOST=$(sql_str "$MYSQL_MASTER_HOST"), SOURCE_PORT=${mport}, SOURCE_USER=$(sql_str "${MYSQL_REPLICATION_USER:-}"), SOURCE_PASSWORD=$(sql_str "${MYSQL_REPLICATION_PASSWORD:-}"), SOURCE_DELAY=${MYSQL_MASTER_DELAY:-0}, SOURCE_CONNECT_RETRY=10, GET_SOURCE_PUBLIC_KEY=1;" | client mysql
        else
            echo "CHANGE MASTER TO MASTER_HOST=$(sql_str "$MYSQL_MASTER_HOST"), MASTER_PORT=${mport}, MASTER_USER=$(sql_str "${MYSQL_REPLICATION_USER:-}"), MASTER_PASSWORD=$(sql_str "${MYSQL_REPLICATION_PASSWORD:-}"), MASTER_DELAY=${MYSQL_MASTER_DELAY:-0}, MASTER_CONNECT_RETRY=10;" | client mysql
        fi
        log "replication source set to ${MYSQL_MASTER_HOST}:${mport}"
    fi

    for f in /docker-entrypoint-initdb.d/*; do
        [ -e "$f" ] || continue
        db=(); [ -n "${MYSQL_DATABASE:-}" ] && db=("$MYSQL_DATABASE")
        case "$f" in
            *.sh) log "running $f"; if [ -x "$f" ]; then "$f"; else . "$f"; fi ;;
            *.sql) log "running $f"; client "${db[@]}" < "$f" ;;
            *.sql.gz) log "running $f"; gunzip -c "$f" | client "${db[@]}" ;;
            *.sql.bz2) log "running $f"; bunzip2 -c "$f" | client "${db[@]}" ;;
            *.sql.xz) log "running $f"; xzcat "$f" | client "${db[@]}" ;;
            *.sql.zst) log "running $f"; zstd -dc "$f" | client "${db[@]}" ;;
            *) log "ignoring $f" ;;
        esac
    done

    if is_yes "${MYSQL_ONETIME_PASSWORD:-}" && [ "$ver" -ge 5007 ]; then
        echo "ALTER USER 'root'@$(sql_str "$root_host") PASSWORD EXPIRE;" | client
    fi
    temp_stop
    echo "$full" > "$datadir/.epicmorg-mysql-version"
    log "initialization done"
elif [ "$ver" -lt 8000 ] || { [ "$ver" -eq 8000 ] && [ "$patch" -lt 16 ]; }; then
    # 5.x and 8.0 < 8.0.16 do not upgrade the system tables themselves (bitnami MYSQL_UPGRADE)
    mode="${MYSQL_UPGRADE:-AUTO}"
    was="$( { cat "$datadir/mysql_upgrade_info" "$datadir/.epicmorg-mysql-version" 2>/dev/null || true; } | sed -nE 's/^([0-9]+\.[0-9]+\.[0-9]+).*/\1/p' | sort -V | tail -1)"
    if [ "${mode^^}" = FORCE ] || { [ "${mode^^}" = AUTO ] && [ -n "$was" ] && [ "$was" != "$full" ]; }; then
        if [ -n "${MYSQL_ROOT_PASSWORD:-}" ] || is_yes "${MYSQL_ALLOW_EMPTY_PASSWORD:-}${ALLOW_EMPTY_PASSWORD:-}"; then
            log "data from MySQL ${was:-?}: running mysql_upgrade"
            write_cnf "${MYSQL_ROOT_PASSWORD:-}"
            temp_start
            mysql_upgrade --defaults-extra-file="$cnf" --protocol=socket --socket="$tmpsock" || die "mysql_upgrade failed"
            temp_stop
            echo "$full" > "$datadir/.epicmorg-mysql-version"
        else
            log "data from MySQL ${was}: mysql_upgrade needs MYSQL_ROOT_PASSWORD - skipped"
        fi
    fi
fi
trap - EXIT
rm -f "$cnf"

log "starting mysqld $full"
exec mysqld "${args[@]}"
