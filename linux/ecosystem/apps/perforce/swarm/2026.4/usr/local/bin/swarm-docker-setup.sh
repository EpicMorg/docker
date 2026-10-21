#!/bin/bash
#
# epicmorg/swarm entrypoint. Same variables and the same data/ volume layout as
# Perforce's perforce/helix-swarm image (swarm-docker-setup.sh), so its compose
# files and data volumes work unchanged. Swarm itself comes from the filehost
# tarball, which has no sbin/configure-swarm.sh (that one ships only in the
# Ubuntu deb), so the first-start configuration is done here, the same steps:
#   * wait for P4D, log in as the super user;
#   * create the Swarm user (+ password) when missing, long-lived ticket group
#     swarm-group (Timeout: unlimited);
#   * write data/config.php: hostname, P4 port/user/ticket, mail host, log
#     priority, redis, optional WebSocket gateway;
#   * worker token in data/queue/tokens;
#   * install + configure the server-side extension (Perforce::helix-swarm,
#     instance "swarm") unless Swarm triggers are installed.
# Later starts only restore the persisted pieces. Secrets are never printed.
#
# PHP is php-fpm (no mod_php): persisted PHP settings are an overlay ini,
# data/docker/php.ini, linked into the one real conf.d.
# Finally exec's the CMD (the parent image's supervisord: apache2, php-fpm,
# cron, swarm-websocket).
set -uo pipefail

export SWARM_HOME="/opt/perforce/swarm"
export DOCKER_DIR="${SWARM_HOME}/data/docker"
export SWARM_HOST="${SWARM_HOST:-localhost}"
P4D_PORT="${P4D_PORT:-ssl:perforce:1666}"
P4D_SUPER="${P4D_SUPER:-super}"
SWARM_USER="${SWARM_USER:-swarm}"
SWARM_MAILHOST="${SWARM_MAILHOST:-localhost}"
SWARM_REDIS="${SWARM_REDIS:-helix-redis}"
SWARM_REDIS_PORT="${SWARM_REDIS_PORT:-7379}"
CONFIG="${SWARM_HOME}/data/config.php"
EXT_NAME="Perforce::helix-swarm"
EXT_FILE="${SWARM_HOME}/p4-bin/extensions/helix-swarm.p4-extension"
PHP_LOCAL_INI="${PHP_INI_DIR}/conf.d/99-swarm-local.ini"

log() { echo "$(date +"%Y/%m/%d %H:%M:%S") - swarm: $*"; }
die() { log "FATAL: $*"; exit 1; }
mask() { echo "${1//?/X}"; }

# <VAR>_FILE -> <VAR> (docker / compose secrets)
for v in P4D_SUPER_PASSWD SWARM_PASSWD SWARM_REDIS_PASSWD; do
    f="${v}_FILE"
    if [ -n "${!f:-}" ]; then
        [ -r "${!f}" ] || die "${f}=${!f} is not readable"
        printf -v "$v" '%s' "$(< "${!f}")"
    fi
done

# P4 as the super user, with the ticket from `login -p` (no ticket file)
p4s() { p4 -p "${P4D_PORT}" -u "${P4D_SUPER}" -P "${SUPER_TICKET}" "$@"; }

waitForP4D() {
    log "checking P4D '${P4D_PORT}'"
    local attempts=0
    while [ "${attempts}" -lt "${P4D_GRACE:-30}" ]; do
        if [[ "${P4D_PORT}" =~ ^ssl ]]; then
            p4 -p "${P4D_PORT}" trust -fy >/dev/null 2>&1 || log "failed to trust SSL on '${P4D_PORT}'"
        fi
        if p4 -p "${P4D_PORT}" -ztag info -s >/dev/null 2>&1; then
            log "P4D is up"
            return 0
        fi
        attempts=$((attempts + 1))
        log "waiting for P4D (${attempts})"
        sleep 1
    done
    return 1
}

# PHP single-quoted string literal
phpq() { local s="${1//\\/\\\\}"; printf "'%s'" "${s//\'/\\\'}"; }

createSwarmUser() {
    if p4s users -a "${SWARM_USER}" 2>/dev/null | grep -q "^${SWARM_USER} <"; then
        log "Swarm user [${SWARM_USER}] exists"
    else
        log "creating Swarm user [${SWARM_USER}]"
        p4s user -o "${SWARM_USER}" | sed -e "s/^FullName:.*/FullName: Swarm Admin/" | p4s user -i -f >/dev/null \
            || die "cannot create user [${SWARM_USER}]"
        # Initial passwords are set by the super user, and such a password is
        # expired ("must be changed") on current P4D: the user then re-sets the
        # same password itself, which clears that flag.
        printf '%s\n%s\n' "${SWARM_PASSWD}" "${SWARM_PASSWD}" | p4s passwd "${SWARM_USER}" >/dev/null \
            || die "cannot set the password of [${SWARM_USER}] (an auth-check trigger?)"
        printf '%s\n%s\n%s\n' "${SWARM_PASSWD}" "${SWARM_PASSWD}" "${SWARM_PASSWD}" \
            | p4 -p "${P4D_PORT}" -u "${SWARM_USER}" passwd >/dev/null 2>&1 \
            || log "could not re-set the password as [${SWARM_USER}]; if logins fail with 'password has expired', change it once by hand"
    fi
    # Swarm needs 'admin' (configure-swarm.sh appends the same protections line)
    local access
    access=$(p4s protects -m -u "${SWARM_USER}" 2>/dev/null)
    case "${access}" in
        admin|super) log "Swarm user [${SWARM_USER}] has '${access}' access" ;;
        *)
            log "granting 'admin' to [${SWARM_USER}] (had '${access:-none}'): appending 'admin user ${SWARM_USER} * //...' to the protections table"
            p4s protect -o | sed -e "\$a\\\tadmin user ${SWARM_USER} * //..." | p4s protect -i >/dev/null \
                || die "cannot update the protections table"
            ;;
    esac
    # long-lived ticket group
    if ! p4s groups "${SWARM_USER}" | grep -qx swarm-group; then
        log "adding [${SWARM_USER}] to the long-lived ticket group swarm-group"
        p4s group -o swarm-group | sed 's/^Timeout:.*$/Timeout:\tunlimited/' \
            | awk -v u="${SWARM_USER}" '/^Users:/{print; print "\t" u; next} 1' | p4s group -i >/dev/null \
            || die "cannot update group swarm-group"
    fi
}

writeConfig() {
    local ticket="$1" ws=false
    [ "${SWARM_WS_ENABLED:-n}" = "y" ] && ws=true
    mkdir -p "${SWARM_HOME}/data"
    env TICKET="${ticket}" WS="${ws}" SWARM_HOST="${SWARM_HOST}" P4D_PORT="${P4D_PORT}" SWARM_USER="${SWARM_USER}" SWARM_REDIS="${SWARM_REDIS}" SWARM_REDIS_PORT="${SWARM_REDIS_PORT}" SWARM_MAILHOST="${SWARM_MAILHOST}" SWARM_REDIS_PASSWD="${SWARM_REDIS_PASSWD:-}" SWARM_REDIS_NAMESPACE="${SWARM_REDIS_NAMESPACE:-}" \
    php -r '
        $c = [
            "environment" => ["hostname" => getenv("SWARM_HOST")],
            "p4" => ["port" => getenv("P4D_PORT"), "user" => getenv("SWARM_USER"), "password" => getenv("TICKET")],
            "log" => ["priority" => 7],
            "redis" => ["options" => ["server" => ["host" => getenv("SWARM_REDIS"), "port" => (int) getenv("SWARM_REDIS_PORT")]]],
        ];
        if (strlen(getenv("SWARM_MAILHOST"))) { $c["mail"] = ["transport" => ["host" => getenv("SWARM_MAILHOST")]]; }
        if (strlen((string) getenv("SWARM_REDIS_PASSWD"))) { $c["redis"]["options"]["password"] = getenv("SWARM_REDIS_PASSWD"); }
        if (strlen((string) getenv("SWARM_REDIS_NAMESPACE"))) { $c["redis"]["options"]["namespace"] = getenv("SWARM_REDIS_NAMESPACE"); }
        if (getenv("WS") === "true") { $c["notifications"] = ["websocket" => ["enabled" => true]]; }
        echo "<?php\n/* WARNING: The contents of this file is cached by Swarm. Changes to\n",
             " * it will not be picked up until the cached versions are removed.\n",
             " * See the documentation on the \x27Swarm config cache\x27.\n */\n",
             "return ", var_export($c, true), ";\n";
    ' > "${CONFIG}.new" \
        || die "cannot compose data/config.php"
    php -l "${CONFIG}.new" >/dev/null || die "composed data/config.php is not valid PHP"
    mv "${CONFIG}.new" "${CONFIG}"
    chmod 0640 "${CONFIG}"
}

workerToken() {
    local dir="${SWARM_HOME}/data/queue/tokens" token
    mkdir -p "${dir}" "${SWARM_HOME}/data/queue/workers"
    token=$(find "${dir}" -maxdepth 1 -type f -printf '%f\n' | head -n1)
    if [ -z "${token}" ]; then
        token=$(uuid | tr '[:lower:]' '[:upper:]')
        touch "${dir}/${token}"
    fi
    echo "${token}"
}

# Server-side extension, as configure-swarm.sh -X does
configureExtension() {
    # where P4D reaches Swarm (upstream: always http://SWARM_HOST/)
    local token="$1" url="${SWARM_EXT_URL:-http://${SWARM_HOST}/}"
    if p4s triggers -o | grep -q "swarm"; then
        log "Swarm triggers are installed on P4D: extension NOT installed. Keep the triggers pointing at this Swarm, or remove them and restart with SWARM_FORCE_EXT=y"
        return 0
    fi
    if p4s extension --list --type extensions | grep -q "helix-swarm"; then
        if [ "${SWARM_FORCE_EXT:-n}" != "y" ]; then
            log "Swarm extension already installed on P4D: left as is. Re-configure it to point at this Swarm (${url}), or restart with SWARM_FORCE_EXT=y"
            return 0
        fi
        log "SWARM_FORCE_EXT=y: deleting the installed Swarm extension"
        p4s extension --delete "${EXT_NAME}" --yes >/dev/null || die "cannot delete ${EXT_NAME}"
    fi
    log "installing ${EXT_NAME} on P4D"
    p4s extension --yes --install "${EXT_FILE}" >/dev/null || die "cannot install ${EXT_FILE} (P4D 2020.1+, super access, server.extensions.allow.unsigned for unsigned builds?)"
    # global config: the package's defaults + our URL, token, user. ExtConfig
    # fields are "\tName:" with the value on the following "\t\t" line(s).
    p4s extension --configure "${EXT_NAME}" -o \
        | awk -v url="${url}" -v token="${token}" -v user="${P4D_SUPER}" '
            function setval(v) { print "\t\t" v; skip = 1 }
            skip && /^\t\t/ { next }
            { skip = 0 }
            /^ExtP4USER:/ { print "ExtP4USER:\t" user; next }
            /^\tSwarm-URL:/ { print "\tSwarm-URL:"; setval(url); next }
            /^\tSwarm-Token:/ { print "\tSwarm-Token:"; setval(token); next }
            /^\tSwarm-Secure:/ { print "\tSwarm-Secure:"; setval("true"); next }
            { print }' \
        | p4s extension --configure "${EXT_NAME}" -i >/dev/null || die "cannot configure ${EXT_NAME}"
    # instance "swarm" with its defaults
    p4s extension --configure "${EXT_NAME}" --name swarm -o \
        | p4s extension --configure "${EXT_NAME}" --name swarm -i >/dev/null || die "cannot configure the ${EXT_NAME} instance"
    log "extension installed: Swarm-URL ${url} (set it to the URL P4D reaches this Swarm at, if different)"
}

configureSwarm() {
    log "no data/config.php: configuring a new Swarm instance against '${P4D_PORT}'"
    [ -n "${SWARM_PASSWD:-}" ] || die "SWARM_PASSWD is not set"
    [ -n "${P4D_SUPER_PASSWD:-}" ] || die "P4D_SUPER_PASSWD is not set"
    log "super user [${P4D_SUPER}] with [$(mask "${P4D_SUPER_PASSWD}")], Swarm user [${SWARM_USER}] with [$(mask "${SWARM_PASSWD}")]"

    waitForP4D || die "cannot reach P4D at '${P4D_PORT}'"
    p4 -p "${P4D_PORT}" -ztag info | grep -q "unicode enabled" \
        || log "*** P4D at '${P4D_PORT}' is not unicode enabled. Perforce STRONGLY recommends a Unicode server for Swarm ***"

    SUPER_TICKET=$(echo "${P4D_SUPER_PASSWD}" | p4 -p "${P4D_PORT}" -u "${P4D_SUPER}" login -p 2>/dev/null | tail -n1)
    [ -n "${SUPER_TICKET}" ] && p4s login -s >/dev/null 2>&1 \
        || die "cannot log in to '${P4D_PORT}' as [${P4D_SUPER}] (check P4D_SUPER_PASSWD)"

    createSwarmUser

    # a ticket that stays valid when the container restarts (-a: all hosts)
    local ticket
    ticket=$(echo "${SWARM_PASSWD}" | p4 -p "${P4D_PORT}" -u "${SWARM_USER}" login -ap 2>/dev/null | tail -n1)
    [ -n "${ticket}" ] && [ "${ticket}" = "${ticket//[^0-9A-F]/}" ] || die "cannot get a ticket for [${SWARM_USER}]"

    writeConfig "${ticket}"
    local token
    token=$(workerToken)
    configureExtension "${token}"

    rm -f "${SWARM_HOME}"/data/cache/* "${SWARM_HOME}/data/p4trust"
    log "Swarm configured"
}

# Persisted PHP settings: data/docker/php.ini, an overlay on the image's php.ini
persistPhpIni() {
    if [ ! -f "${DOCKER_DIR}/php.ini" ] || ! grep -q '^; Local PHP settings for Swarm' "${DOCKER_DIR}/php.ini"; then
        # a php.ini from Perforce's image is a whole Ubuntu php.ini: keep it aside
        [ -f "${DOCKER_DIR}/php.ini" ] && mv "${DOCKER_DIR}/php.ini" "${DOCKER_DIR}/php.ini.upstream"
        cat > "${DOCKER_DIR}/php.ini" << '__INI__'
; Local PHP settings for Swarm, kept in the data volume (data/docker/php.ini).
; Loaded last (conf.d/99-swarm-local.ini) by php-fpm and the CLI; restart the
; container after editing. Overrides only - the base php.ini is the image's.
;memory_limit = 2048M
;upload_max_filesize = 64M
;post_max_size = 64M
__INI__
    fi
    ln -fs "${DOCKER_DIR}/php.ini" "${PHP_LOCAL_INI}"
}

# Vhosts persisted by Perforce's image (data/docker/sites-available) win over the
# image's perforce-swarm-site.conf; a file bind-mounted over the latter works too.
enableSites() {
    rm -f /etc/apache2/sites-enabled/*
    if compgen -G "${DOCKER_DIR}/sites-available/*.conf" >/dev/null; then
        log "using the vhosts in data/docker/sites-available"
        for c in "${DOCKER_DIR}"/sites-available/*.conf; do
            sed -i "s#APACHE_LOG_DIR#/var/log/apache2#g" "$c"
            ln -s "$c" "/etc/apache2/sites-enabled/$(basename "$c")"
        done
    else
        ln -s ../sites-available/perforce-swarm-site.conf /etc/apache2/sites-enabled/perforce-swarm-site.conf
    fi
}

log "starting (Swarm $(sed -n 's/^RELEASE = \(.*\) ;/\1/p' "${SWARM_HOME}/Version" | tr ' ' '.'), P4D ${P4D_PORT})"
mkdir -p "${DOCKER_DIR}"

if [ -f "${CONFIG}" ]; then
    log "data/config.php found: using the persisted configuration"
    [ -d "${SWARM_HOME}/data/cache" ] && rm -f "${SWARM_HOME}"/data/cache/*.php   # module cache, in case of an upgrade
else
    configureSwarm
fi

# cron hosts (who swarm-cron.sh pokes for workers)
[ -f "${DOCKER_DIR}/swarm-cron-hosts.conf" ] || echo "http://localhost:80" > "${DOCKER_DIR}/swarm-cron-hosts.conf"
ln -fs "${DOCKER_DIR}/swarm-cron-hosts.conf" /opt/perforce/etc/swarm-cron-hosts.conf

# public/custom (site customisations) lives in the volume
mkdir -p "${DOCKER_DIR}/custom"
rm -rf "${SWARM_HOME}/public/custom"
ln -sfn "${DOCKER_DIR}/custom" "${SWARM_HOME}/public/custom"

persistPhpIni
enableSites

# Versions next to the data
cp /opt/perforce/etc/Docker-Version "${SWARM_HOME}/Version" "${DOCKER_DIR}/"

# ownership; queue + tokens readable by the swarm-cron user (Perforce SW-14926)
mkdir -p "${SWARM_HOME}/data/queue/tokens" "${SWARM_HOME}/data/queue/workers"
chown -R www-data:www-data "${SWARM_HOME}/data"
chmod -R o= "${SWARM_HOME}/data"
chmod o+x "${SWARM_HOME}/data"
chgrp swarm-cron "${SWARM_HOME}/data/queue" "${SWARM_HOME}/data/queue/tokens"
chmod g+rx "${SWARM_HOME}/data/queue" "${SWARM_HOME}/data/queue/tokens"
if [ -d "${SWARM_HOME}/data/servers" ]; then   # multi-P4D
    chmod o+x "${SWARM_HOME}/data/servers"
    for d in "${SWARM_HOME}"/data/servers/*/; do
        [ -d "${d}queue/tokens" ] || continue
        chmod o+x "$d"
        chgrp swarm-cron "${d}queue" "${d}queue/tokens"
        chmod g+rx "${d}queue" "${d}queue/tokens"
    done
fi

apachectl configtest >/dev/null 2>&1 || { apachectl configtest; die "Apache configuration test failed"; }
log "setup finished"
exec "$@"
