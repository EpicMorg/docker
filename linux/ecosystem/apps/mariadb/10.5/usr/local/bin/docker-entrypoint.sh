#!/bin/bash
# epicmorg/mariadb entrypoint (every line 5.5 .. 13.x): a drop-in for library/mariadb
# and bitnami/mariadb. Written for this image (not derived from either project).
#
# library/mariadb behaviour: `docker run epicmorg/mariadb --flag` = `mariadbd --flag`, any
# other command runs as is; the server runs as mysql (uid 999) when started as root; on
# an empty datadir: MARIADB_ROOT_PASSWORD / MARIADB_ALLOW_EMPTY_ROOT_PASSWORD /
# MARIADB_RANDOM_ROOT_PASSWORD (+ *_FILE), MARIADB_ROOT_HOST (default %), MARIADB_DATABASE,
# MARIADB_USER / MARIADB_PASSWORD, time zone tables (unless MARIADB_INITDB_SKIP_TZINFO),
# /docker-entrypoint-initdb.d/*.sh|*.sql[.gz|.bz2|.xz|.zst]; every MYSQL_* spelling is
# accepted too (MARIADB_* wins). Config /etc/mysql/my.cnf + conf.d, data /var/lib/mysql.
#
# A datadir written by an older MariaDB is upgraded (system tables, mariadb-upgrade on a
# --skip-grant-tables temporary server, after a dump of the mysql schema next to the
# data) - as bitnami does; MARIADB_AUTO_UPGRADE=0 turns it off.
#
# bitnami/mariadb variables on top: ALLOW_EMPTY_PASSWORD, MARIADB_ROOT_USER (an extra
# <user>@% with all privileges), MARIADB_CHARACTER_SET / MARIADB_COLLATE,
# MARIADB_PORT_NUMBER, MARIADB_BIND_ADDRESS, MARIADB_SQL_MODE, MARIADB_ENABLE_SLOW_QUERY /
# MARIADB_LONG_QUERY_TIME, MARIADB_EXTRA_FLAGS, MARIADB_SKIP_TEST_DB,
# MARIADB_REPLICATION_MODE master|slave (+ MARIADB_REPLICATION_USER / _PASSWORD,
# MARIADB_MASTER_HOST / _PORT_NUMBER / _ROOT_USER / _ROOT_PASSWORD / _DELAY);
# /bitnami/mariadb mounted -> datadir /bitnami/mariadb/data;
# /opt/bitnami/mariadb/conf/my_custom.cnf -> /etc/mysql/conf.d/zz-bitnami-my_custom.cnf.
set -Eeuo pipefail

log() { echo "mariadb-entrypoint $(date -u '+%FT%TZ') $*"; }
die() { log "FATAL: $*" >&2; exit 1; }
is_yes() { case "${1,,}" in yes|true|1|on) return 0 ;; *) return 1 ;; esac; }

# MARIADB_* (library and bitnami) -> one set of names; MYSQL_* are the aliases
for n in ROOT_PASSWORD ROOT_HOST RANDOM_ROOT_PASSWORD DATABASE USER PASSWORD INITDB_SKIP_TZINFO ROOT_USER \
         CHARACTER_SET COLLATE PORT_NUMBER BIND_ADDRESS SQL_MODE ENABLE_SLOW_QUERY LONG_QUERY_TIME EXTRA_FLAGS \
         REPLICATION_MODE REPLICATION_USER REPLICATION_PASSWORD MASTER_HOST MASTER_PORT_NUMBER MASTER_ROOT_USER \
         MASTER_ROOT_PASSWORD MASTER_DELAY ROOT_PASSWORD_FILE PASSWORD_FILE USER_FILE DATABASE_FILE ROOT_HOST_FILE \
         REPLICATION_PASSWORD_FILE MASTER_ROOT_PASSWORD_FILE; do
    m="MARIADB_$n"; y="MYSQL_$n"
    if [ -n "${!m:-}" ]; then printf -v "$y" '%s' "${!m}"; export "${y?}"; fi
done
[ -n "${MARIADB_ALLOW_EMPTY_ROOT_PASSWORD:-}" ] && export MYSQL_ALLOW_EMPTY_PASSWORD="$MARIADB_ALLOW_EMPTY_ROOT_PASSWORD"

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

# tool names: mariadb-* where the line has them (11.x warns about the mysql* ones)
pick() { local t; for t in "$@"; do command -v "$t" >/dev/null 2>&1 && { echo "$t"; return 0; }; done; return 1; }
SERVER="$(pick mariadbd mysqld)"
CLIENT="$(pick mariadb mysql)"
ADMIN="$(pick mariadb-admin mysqladmin)"
UPGRADE="$(pick mariadb-upgrade mysql_upgrade)"
DUMP="$(pick mariadb-dump mysqldump)"
TZINFO="$(pick mariadb-tzinfo-to-sql mysql_tzinfo_to_sql)"

if [ "${1:0:1}" = '-' ] || [ "$#" -eq 0 ]; then
    set -- mariadbd "$@"
fi
case "$1" in
    mariadbd|mysqld) shift ;;
    *) exec "$@" ;;
esac

args=("$@")
has_arg() { local a; for a in "${args[@]}"; do case "$a" in "$1"|"$1"=*) return 0 ;; esac; done; return 1; }
for a in "${args[@]}"; do
    case "$a" in -'?'|--help|--print-defaults|-V|--version) exec "$SERVER" "${args[@]}" ;; esac
done

# ---- bitnami variables -> server options ------------------------------------------
add_opt() { has_arg "$1" || args+=("$1=$2"); }
if [ -n "${MYSQL_PORT_NUMBER:-}" ]; then add_opt --port "$MYSQL_PORT_NUMBER"; fi
if [ -n "${MYSQL_BIND_ADDRESS:-}" ]; then add_opt --bind-address "$MYSQL_BIND_ADDRESS"; fi
if [ -n "${MYSQL_CHARACTER_SET:-}" ]; then add_opt --character-set-server "$MYSQL_CHARACTER_SET"; fi
if [ -n "${MYSQL_COLLATE:-}" ]; then add_opt --collation-server "$MYSQL_COLLATE"; fi
if [ -n "${MYSQL_SQL_MODE:-}" ]; then add_opt --sql-mode "$MYSQL_SQL_MODE"; fi
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
        fi ;;
    *) die "MARIADB_REPLICATION_MODE must be master or slave" ;;
esac
if [ -n "${MYSQL_EXTRA_FLAGS:-}" ]; then
    read -r -a extra <<< "$MYSQL_EXTRA_FLAGS"
    args+=("${extra[@]}")
fi
if ! has_arg --datadir && [ -d /bitnami/mariadb ]; then
    args+=(--datadir=/bitnami/mariadb/data)
fi

# version of this server: 5005, 10004, 11008, 13000 ...
full="$("$SERVER" --version | sed -nE 's/.*Ver ([0-9]+\.[0-9]+\.[0-9]+).*/\1/p')"
ver="$(echo "$full" | awk -F. '{ printf "%d%03d", $1, $2 }')"

cfg() {   # cfg <option>: effective value, from the variables table of --verbose --help
    "$SERVER" "${args[@]}" --verbose --help 2>/dev/null \
        | awk -v o="$1" '/^-+ +-+$/ { t = 1; next } t && $1 == o { $1 = ""; sub(/^ /, ""); print; exit }'
}
datadir="$(cfg datadir)"; datadir="${datadir%/}"
socket="$(cfg socket)"
case "$datadir" in /?*) ;; *) die "datadir '$datadir' is not an absolute path (bad option? $("$SERVER" "${args[@]}" --verbose --help 2>&1 >/dev/null | head -2))" ;; esac
case "$socket" in /?*/*) ;; *) die "socket '$socket' is not an absolute path below a directory" ;; esac

# ---- root: hand the datadir over to mysql, re-exec as it ------------------------------
if [ "$(id -u)" = 0 ]; then
    sockdir="$(dirname "$socket")"
    mkdir -p "$datadir" "$sockdir"
    if [ -d /bitnami/mariadb ]; then chown mysql:mysql /bitnami/mariadb; fi
    # owner AND group: library images use 999:999, our mysql group is not gid 999
    # (systemd-journal on the base) - the server copies both when rewriting files
    find "$datadir" \( \! -user mysql -o \! -group mysql \) -exec chown mysql:mysql '{}' + 2>/dev/null || true
    [ "$(stat -c %U "$sockdir")" = mysql ] || [ "$(stat -c %a "$sockdir")" = 1777 ] || chown mysql:mysql "$sockdir"
    if [ -f /opt/bitnami/mariadb/conf/my_custom.cnf ]; then
        cp /opt/bitnami/mariadb/conf/my_custom.cnf /etc/mysql/conf.d/zz-bitnami-my_custom.cnf
    fi
    exec gosu mysql "${BASH_SOURCE[0]}" mariadbd "${args[@]}"
fi
if [ -f /opt/bitnami/mariadb/conf/my_custom.cnf ] && [ -w /etc/mysql/conf.d ]; then
    cp /opt/bitnami/mariadb/conf/my_custom.cnf /etc/mysql/conf.d/zz-bitnami-my_custom.cnf
fi

# ---- helpers ---------------------------------------------------------------------------
sql_str() { local s="${1//\\/\\\\}"; s="${s//\'/\\\'}"; printf "'%s'" "$s"; }
tmpsock=""
cnf=""
client() { "$CLIENT" --defaults-extra-file="$cnf" --protocol=socket --socket="$tmpsock" "$@"; }
write_cnf() {
    cnf="$(mktemp)"; chmod 600 "$cnf"
    printf '[client]\nuser=root\n' > "$cnf"
    if [ -n "${1:-}" ]; then printf 'password="%s"\n' "${1//\"/\\\"}" >> "$cnf"; fi
}
tmp_pid=""
temp_start() {   # temp_start [extra server options]
    tmpsock="$(mktemp -u /tmp/mariadbd.XXXXXX).sock"
    log "temporary server ($full) on a socket only"
    "$SERVER" "${args[@]}" --skip-networking --socket="$tmpsock" --pid-file="${tmpsock%.sock}.pid" \
        --skip-slave-start "$@" > /tmp/mariadbd-init.log 2>&1 &
    tmp_pid=$!
    for i in $(seq 1 180); do
        "$ADMIN" --protocol=socket --socket="$tmpsock" ping >/dev/null 2>&1 && return 0
        kill -0 "$tmp_pid" 2>/dev/null || { cat /tmp/mariadbd-init.log >&2; die "temporary server exited"; }
        sleep 1
    done
    cat /tmp/mariadbd-init.log >&2; die "temporary server did not start"
}
temp_stop() {
    [ -n "$tmp_pid" ] || return 0
    "$ADMIN" --defaults-extra-file="$cnf" --protocol=socket --socket="$tmpsock" shutdown >/dev/null 2>&1 || kill "$tmp_pid" 2>/dev/null || true
    wait "$tmp_pid" 2>/dev/null || true
    tmp_pid=""
}
trap 'temp_stop; rm -f "$cnf"' EXIT

# ---- first start -----------------------------------------------------------------------
if [ ! -d "$datadir/mysql" ]; then
    root_pw="${MYSQL_ROOT_PASSWORD:-}"
    if [ "${MYSQL_REPLICATION_MODE:-}" = slave ] && [ -z "$root_pw" ]; then root_pw="${MYSQL_MASTER_ROOT_PASSWORD:-}"; fi
    if [ -z "$root_pw" ] && ! is_yes "${MYSQL_ALLOW_EMPTY_PASSWORD:-}" && ! is_yes "${ALLOW_EMPTY_PASSWORD:-}" && ! is_yes "${MYSQL_RANDOM_ROOT_PASSWORD:-}"; then
        die "database is uninitialized and password option is not specified
    You need to specify one of MARIADB_ROOT_PASSWORD, MARIADB_ALLOW_EMPTY_ROOT_PASSWORD (ALLOW_EMPTY_PASSWORD) or MARIADB_RANDOM_ROOT_PASSWORD"
    fi
    if is_yes "${MYSQL_RANDOM_ROOT_PASSWORD:-}" && [ -z "$root_pw" ]; then
        root_pw="$(head -c 256 /dev/urandom | tr -dc 'A-Za-z0-9' | head -c 32)"
        log "GENERATED ROOT PASSWORD: $root_pw"
    fi
    [ "${MYSQL_USER:-}" = root ] && die "MARIADB_USER=root is not allowed (use MARIADB_ROOT_PASSWORD)"

    log "initializing database files in $datadir (MariaDB $full)"
    mkdir -p "$datadir"
    inst="$EMG_MARIADB_DIR/scripts/mariadb-install-db"; [ -x "$inst" ] || inst="$EMG_MARIADB_DIR/scripts/mysql_install_db"
    iopts=(--defaults-file=/etc/mysql/my.cnf --basedir="$EMG_MARIADB_DIR" --datadir="$datadir" --skip-name-resolve)
    [ "$ver" -ge 10004 ] && iopts+=(--auth-root-authentication-method=normal)
    [ "$ver" -ge 10005 ] && iopts+=(--skip-test-db)
    (cd "$EMG_MARIADB_DIR" && "$inst" "${iopts[@]}" > /tmp/mariadb-install-db.log 2>&1) \
        || { cat /tmp/mariadb-install-db.log >&2; die "$(basename "$inst") failed"; }
    write_cnf ""
    temp_start

    if ! is_yes "${MYSQL_INITDB_SKIP_TZINFO:-}"; then
        { echo "SET @@SESSION.SQL_LOG_BIN=0;"; "$TZINFO" /usr/share/zoneinfo 2>/dev/null; } \
            | client mysql || die "loading time zone tables failed"
    fi

    root_host="${MYSQL_ROOT_HOST:-%}"
    {
        echo "SET @@SESSION.SQL_LOG_BIN=0;"
        if [ "$ver" -lt 10004 ]; then
            echo "DELETE FROM mysql.user WHERE user NOT IN ('root') OR host NOT IN ('localhost');"
        else
            # mysql.user is a view from 10.4 on: drop the accounts instead
            client -N -B -e "SELECT CONCAT('DROP USER IF EXISTS ', QUOTE(user), '@', QUOTE(host), ';') FROM mysql.global_priv
                              WHERE NOT (host = 'localhost' AND user IN ('root', 'mariadb.sys', 'mysql')) AND user <> 'PUBLIC'"
        fi
        echo "DROP DATABASE IF EXISTS test;"
        echo "SET PASSWORD FOR 'root'@'localhost' = PASSWORD($(sql_str "$root_pw"));"
        if [ "$root_host" != localhost ]; then
            echo "CREATE USER 'root'@$(sql_str "$root_host") IDENTIFIED BY $(sql_str "$root_pw");"
            echo "GRANT ALL ON *.* TO 'root'@$(sql_str "$root_host") WITH GRANT OPTION;"
        fi
        echo "FLUSH PRIVILEGES;"
    } | client || die "setting up root failed"
    write_cnf "$root_pw"

    {
        if [ -n "${MYSQL_ROOT_USER:-}" ] && [ "$MYSQL_ROOT_USER" != root ]; then
            echo "CREATE USER $(sql_str "$MYSQL_ROOT_USER")@'%' IDENTIFIED BY $(sql_str "$root_pw");"
            echo "GRANT ALL ON *.* TO $(sql_str "$MYSQL_ROOT_USER")@'%' WITH GRANT OPTION;"
        fi
        if [ -n "${MYSQL_DATABASE:-}" ]; then
            cs=""
            if [ -n "${MYSQL_CHARACTER_SET:-}" ]; then cs=" CHARACTER SET ${MYSQL_CHARACTER_SET}"; fi
            if [ -n "${MYSQL_COLLATE:-}" ]; then cs="$cs COLLATE ${MYSQL_COLLATE}"; fi
            echo "CREATE DATABASE IF NOT EXISTS \`${MYSQL_DATABASE//\`/\`\`}\`$cs;"
        fi
        if [ -n "${MYSQL_USER:-}" ]; then
            [ -n "${MYSQL_PASSWORD:-}" ] || is_yes "${ALLOW_EMPTY_PASSWORD:-}" || die "MARIADB_USER needs MARIADB_PASSWORD"
            echo "CREATE USER $(sql_str "$MYSQL_USER")@'%' IDENTIFIED BY $(sql_str "${MYSQL_PASSWORD:-}");"
            if [ -n "${MYSQL_DATABASE:-}" ]; then echo "GRANT ALL ON \`${MYSQL_DATABASE//\`/\`\`}\`.* TO $(sql_str "$MYSQL_USER")@'%';"; fi
        fi
        if [ "${MYSQL_REPLICATION_MODE:-}" = master ] && [ -n "${MYSQL_REPLICATION_USER:-}" ]; then
            echo "CREATE USER $(sql_str "$MYSQL_REPLICATION_USER")@'%' IDENTIFIED BY $(sql_str "${MYSQL_REPLICATION_PASSWORD:-}");"
            echo "GRANT REPLICATION SLAVE ON *.* TO $(sql_str "$MYSQL_REPLICATION_USER")@'%';"
        fi
        echo "FLUSH PRIVILEGES;"
    } | client || die "creating database / users failed"
    if [ -n "${MYSQL_DATABASE:-}" ]; then log "database [$MYSQL_DATABASE] created"; fi
    if [ -n "${MYSQL_USER:-}" ]; then log "user [$MYSQL_USER] created"; fi

    if [ "${MYSQL_REPLICATION_MODE:-}" = slave ]; then
        [ -n "${MYSQL_MASTER_HOST:-}" ] || die "slave mode needs MARIADB_MASTER_HOST"
        mport="${MYSQL_MASTER_PORT_NUMBER:-3306}"
        log "waiting for the replication master ${MYSQL_MASTER_HOST}:${mport}"
        for i in $(seq 1 300); do
            "$CLIENT" --protocol=tcp -h"$MYSQL_MASTER_HOST" -P"$mport" -u"${MYSQL_MASTER_ROOT_USER:-root}" -p"${MYSQL_MASTER_ROOT_PASSWORD:-}" -e 'SELECT 1' >/dev/null 2>&1 && break
            sleep 1
        done
        delay=""; [ "$ver" -ge 10002 ] && delay=", MASTER_DELAY=${MYSQL_MASTER_DELAY:-0}"
        echo "CHANGE MASTER TO MASTER_HOST=$(sql_str "$MYSQL_MASTER_HOST"), MASTER_PORT=${mport}, MASTER_USER=$(sql_str "${MYSQL_REPLICATION_USER:-}"), MASTER_PASSWORD=$(sql_str "${MYSQL_REPLICATION_PASSWORD:-}"), MASTER_CONNECT_RETRY=10${delay};" | client mysql
        log "replication source set to ${MYSQL_MASTER_HOST}:${mport}"
    fi

    for f in /docker-entrypoint-initdb.d/*; do
        [ -e "$f" ] || continue
        db=(); if [ -n "${MYSQL_DATABASE:-}" ]; then db=("$MYSQL_DATABASE"); fi
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
    temp_stop
    echo "$full" > "$datadir/.epicmorg-mariadb-version"
    log "initialization done"
else
    # MariaDB never upgrades its system tables by itself
    was="$( { cat "$datadir/mysql_upgrade_info" "$datadir/mariadb_upgrade_info" "$datadir/.epicmorg-mariadb-version" 2>/dev/null || true; } \
            | sed -nE 's/^([0-9]+\.[0-9]+\.[0-9]+).*/\1/p' | sort -V | tail -1)"
    if [ -n "$was" ] && [ "$was" != "$full" ] && [ "${MARIADB_AUTO_UPGRADE:-1}" != 0 ] && ! [[ "${MARIADB_AUTO_UPGRADE:-}" =~ ^(no|false|off)$ ]]; then
        log "data from MariaDB $was: backing up the mysql schema, then the system tables upgrade"
        write_cnf ""
        temp_start --skip-grant-tables --loose-innodb-buffer-pool-dump-at-shutdown=0
        bk="$datadir/system_mysql_backup_${was}.sql.zst"
        "$DUMP" --defaults-extra-file="$cnf" --protocol=socket --socket="$tmpsock" --skip-lock-tables --databases mysql \
            | zstd -q -o "$bk" || die "backup of the mysql schema failed"
        "$UPGRADE" --defaults-extra-file="$cnf" --protocol=socket --socket="$tmpsock" --upgrade-system-tables \
            || die "$(basename "$UPGRADE") failed (backup: $bk)"
        temp_stop
        echo "$full" > "$datadir/.epicmorg-mariadb-version"
        log "upgrade to $full done (backup: $bk)"
    fi
fi
trap - EXIT
rm -f "$cnf"

log "starting $(basename "$SERVER") $full"
exec "$SERVER" "${args[@]}"
