#!/bin/bash
# epicmorg/openldap entrypoint: a drop-in for bitnami/openldap.
#
# It reads the same LDAP_* variables (+ *_FILE secrets), takes the same mounts
# (/bitnami/openldap, /ldifs, /schemas, /schema/custom.ldif,
# /docker-entrypoint-initdb.d/*.sh) and the same defaults (ports 1389 / 1636,
# suffix dc=example,dc=org, admin cn=admin,<root>, users user01/user02 in
# ou=users + group readers, anonymous bind off, cosine/inetorgperson/nis).
# Native volume: /data (data/ + slapd.d/); /bitnami/openldap is used instead
# when it is mounted, so an existing bitnami volume starts unchanged.
#
# First start (empty data dir): cn=config is created with slapadd, slapd is
# started on ldapi:/// only, configured over ldapi (SASL EXTERNAL) and stopped;
# then the real slapd runs in the foreground. slapd runs as slapd (uid 1001,
# like bitnami) when the container starts as root.
#
# Not covered: bitnami's LDAP_ENABLE_PROXYPROTO listener ports are honoured,
# the rest of the bitnami helper library (debug_execute etc.) is not shipped.
set -euo pipefail

log() { echo "openldap $(date '+%F %T') $*"; }
die() { echo "openldap $(date '+%F %T') FATAL: $*" >&2; exit 1; }
is_yes() { case "${1,,}" in yes|true|1|on) return 0 ;; *) return 1 ;; esac; }

# first argument is a flag (or nothing): run slapd with it;
# anything else (ldapsearch, slapcat, bash, ...) is executed as is
if [ "$#" -gt 0 ] && [ "${1#-}" = "$1" ] && [ "$1" != slapd ] && [ "$1" != /opt/bitnami/scripts/openldap/run.sh ]; then
    exec "$@"
fi
[ "${1:-}" = slapd ] || [ "${1:-}" = /opt/bitnami/scripts/openldap/run.sh ] && shift

# <VAR>_FILE -> <VAR> (docker / compose secrets), as bitnami does
for v in LDAP_ADMIN_PASSWORD LDAP_CONFIG_ADMIN_PASSWORD LDAP_ACCESSLOG_ADMIN_PASSWORD; do
    f="${v}_FILE"
    if [ -n "${!f:-}" ]; then
        [ -r "${!f}" ] || die "${f}=${!f} is not readable"
        printf -v "$v" '%s' "$(< "${!f}")"
        export "${v?}"
    fi
done

# ---- settings (bitnami names and defaults) ----------------------------------
LDAP_BASE_DIR="${EMG_OPENLDAP_DIR}"
LDAP_CONF_DIR="${LDAP_BASE_DIR}/etc/openldap"
LDAP_MODULE_DIR="${LDAP_BASE_DIR}/libexec/openldap"
LDAP_RUN_DIR=/var/lib/openldap/run
LDAP_PID_FILE="${LDAP_RUN_DIR}/slapd.pid"
LDAPI_URI="ldapi:///"
if [ -z "${LDAP_VOLUME_DIR:-}" ]; then
    if [ -d /bitnami/openldap ]; then LDAP_VOLUME_DIR=/bitnami/openldap; else LDAP_VOLUME_DIR=/data; fi
fi
LDAP_DATA_DIR="${LDAP_VOLUME_DIR}/data"
LDAP_ACCESSLOG_DATA_DIR="${LDAP_DATA_DIR}/accesslog"
LDAP_ONLINE_CONF_DIR="${LDAP_VOLUME_DIR}/slapd.d"
: "${LDAP_CUSTOM_LDIF_DIR:=/ldifs}"
: "${LDAP_CUSTOM_SCHEMA_FILE:=/schema/custom.ldif}"
: "${LDAP_CUSTOM_SCHEMA_DIR:=/schemas}"
: "${LDAP_TLS_CERT_FILE:=}"
: "${LDAP_TLS_KEY_FILE:=}"
: "${LDAP_TLS_CA_FILE:=}"
: "${LDAP_TLS_VERIFY_CLIENTS:=never}"
: "${LDAP_TLS_DH_PARAMS_FILE:=}"
: "${LDAP_PORT_NUMBER:=1389}"
: "${LDAP_LDAPS_PORT_NUMBER:=1636}"
: "${LDAP_ENABLE_PROXYPROTO:=no}"
: "${LDAP_PROXYPROTO_PORT_NUMBER:=${LDAP_PORT_NUMBER}}"
: "${LDAP_PROXYPROTO_LDAPS_PORT_NUMBER:=${LDAP_LDAPS_PORT_NUMBER}}"
: "${LDAP_ROOT:=dc=example,dc=org}"
[ -n "${LDAP_SUFFIX+x}" ] || LDAP_SUFFIX="${LDAP_ROOT}"
: "${LDAP_ADMIN_USERNAME:=admin}"
LDAP_ADMIN_DN="cn=${LDAP_ADMIN_USERNAME},${LDAP_ROOT}"
: "${LDAP_ADMIN_PASSWORD:=}"
: "${LDAP_CONFIG_ADMIN_ENABLED:=no}"
: "${LDAP_CONFIG_ADMIN_USERNAME:=admin}"
LDAP_CONFIG_ADMIN_DN="cn=${LDAP_CONFIG_ADMIN_USERNAME},cn=config"
: "${LDAP_CONFIG_ADMIN_PASSWORD:=}"
: "${LDAP_ADD_SCHEMAS:=yes}"
: "${LDAP_EXTRA_SCHEMAS:=cosine,inetorgperson,nis}"
: "${LDAP_SKIP_DEFAULT_TREE:=no}"
: "${LDAP_USERS:=user01,user02}"
: "${LDAP_PASSWORDS:=bitnami1,bitnami2}"
: "${LDAP_USER_DC:=}"
: "${LDAP_USER_OU:=${LDAP_USER_DC:-users}}"
: "${LDAP_GROUP_OU:=${LDAP_USER_DC:-groups}}"
: "${LDAP_GROUP:=readers}"
: "${LDAP_ENABLE_TLS:=no}"
: "${LDAP_REQUIRE_TLS:=no}"
: "${LDAP_ULIMIT_NOFILES:=1024}"
: "${LDAP_ALLOW_ANON_BINDING:=no}"
: "${LDAP_LOGLEVEL:=256}"
[ -n "${LDAP_PASSWORD_HASH:-}" ] || LDAP_PASSWORD_HASH='{SSHA}'
: "${LDAP_CONFIGURE_PPOLICY:=no}"
: "${LDAP_PPOLICY_USE_LOCKOUT:=no}"
: "${LDAP_PPOLICY_HASH_CLEARTEXT:=no}"
: "${LDAP_ENABLE_ACCESSLOG:=no}"
: "${LDAP_ACCESSLOG_DB:=cn=accesslog}"
: "${LDAP_ACCESSLOG_LOGOPS:=writes}"
: "${LDAP_ACCESSLOG_LOGSUCCESS:=TRUE}"
: "${LDAP_ACCESSLOG_LOGPURGE:=07+00:00 01+00:00}"
: "${LDAP_ACCESSLOG_LOGOLD:=(objectClass=*)}"
: "${LDAP_ACCESSLOG_LOGOLDATTR:=objectClass}"
: "${LDAP_ACCESSLOG_ADMIN_USERNAME:=admin}"
LDAP_ACCESSLOG_ADMIN_DN="cn=${LDAP_ACCESSLOG_ADMIN_USERNAME},${LDAP_ACCESSLOG_DB}"
: "${LDAP_ACCESSLOG_ADMIN_PASSWORD:=}"
: "${LDAP_ENABLE_SYNCPROV:=no}"
: "${LDAP_SYNCPROV_CHECKPPOINT:=100 10}"
: "${LDAP_SYNCPROV_SESSIONLOG:=100}"

# ---- root: hand the volume over to slapd, re-exec as it ---------------------
if [ "$(id -u)" = 0 ]; then
    mkdir -p "$LDAP_DATA_DIR" "$LDAP_ONLINE_CONF_DIR" "$LDAP_RUN_DIR"
    for d in "$LDAP_VOLUME_DIR" "$LDAP_RUN_DIR"; do
        [ "$(stat -c %u "$d")" = 1001 ] || chown -R slapd:root "$d"
    done
    export LDAP_VOLUME_DIR
    exec gosu slapd "${BASH_SOURCE[0]}" slapd "$@"
fi

# ---- validation (as bitnami's ldap_validate) ----------------------------------
err=0
verr() { echo "openldap $(date '+%F %T') ERROR: $*" >&2; err=1; }
for v in LDAP_SKIP_DEFAULT_TREE LDAP_ENABLE_TLS LDAP_ENABLE_PROXYPROTO; do
    case "${!v,,}" in yes|no|true|false) ;; *) verr "The allowed values for $v are: yes or no" ;; esac
done
if is_yes "$LDAP_ENABLE_TLS"; then
    for v in LDAP_TLS_CERT_FILE LDAP_TLS_KEY_FILE LDAP_TLS_CA_FILE; do
        [ -n "${!v}" ] || { verr "$v is required with LDAP_ENABLE_TLS=yes"; continue; }
        [ -f "${!v}" ] || verr "$v=${!v} does not exist"
    done
fi
[ -n "$LDAP_ADMIN_PASSWORD" ] || verr "The LDAP_ADMIN_PASSWORD environment variable is empty or not set."
is_yes "$LDAP_CONFIG_ADMIN_ENABLED" && [ -z "$LDAP_CONFIG_ADMIN_PASSWORD" ] && verr "LDAP_CONFIG_ADMIN_PASSWORD is empty"
is_yes "$LDAP_ENABLE_ACCESSLOG" && [ -z "$LDAP_ACCESSLOG_ADMIN_PASSWORD" ] && verr "LDAP_ACCESSLOG_ADMIN_PASSWORD is empty"
read -r -a users <<< "$(tr ',;' ' ' <<< "${LDAP_USERS}")"
read -r -a passwords <<< "$(tr ',;' ' ' <<< "${LDAP_PASSWORDS}")"
[ "${#users[@]}" -eq "${#passwords[@]}" ] || verr "Specify the same number of passwords on LDAP_PASSWORDS as the number of users on LDAP_USERS!"
for v in LDAP_PORT_NUMBER LDAP_LDAPS_PORT_NUMBER LDAP_PROXYPROTO_PORT_NUMBER LDAP_PROXYPROTO_LDAPS_PORT_NUMBER; do
    [[ "${!v}" =~ ^[1-9][0-9]*$ ]] || verr "The value for $v must be positive integer!"
done
[ "$LDAP_PORT_NUMBER" != "$LDAP_LDAPS_PORT_NUMBER" ] || verr "LDAP_PORT_NUMBER and LDAP_LDAPS_PORT_NUMBER are bound to the same port!"
[ "$err" = 0 ] || exit 1

ulimit -n "$LDAP_ULIMIT_NOFILES" 2>/dev/null || true

# ---- helpers ------------------------------------------------------------------
work="$(mktemp -d)"
trap 'rm -rf "$work"' EXIT
pbkdf2() { slappasswd -n -T /dev/stdin -h '{PBKDF2-SHA512}' -o module-load=pw-pbkdf2 -o "module-path=${LDAP_MODULE_DIR}"; }
hash_of() { printf '%s' "$1" | pbkdf2; }
ldif() {   # ldif <file>: ldapmodify over ldapi as the slapd user (SASL EXTERNAL)
    ldapmodify -Q -Y EXTERNAL -H "$LDAPI_URI" -f "$1" >/dev/null || die "ldapmodify $(basename "$1") failed"
}
ldif_add() {
    ldapadd -Q -Y EXTERNAL -H "$LDAPI_URI" -f "$1" >/dev/null || die "ldapadd $(basename "$1") failed"
}
ldap_ready() { ldapsearch -Q -Y EXTERNAL -H "$LDAPI_URI" -b cn=config -s base dn >/dev/null 2>&1; }
running_pid() { [ -s "$LDAP_PID_FILE" ] && kill -0 "$(cat "$LDAP_PID_FILE")" 2>/dev/null && cat "$LDAP_PID_FILE"; }
start_bg() {
    running_pid >/dev/null && return 0
    log "starting slapd in background (ldapi only)"
    slapd -h "$LDAPI_URI" -F "$LDAP_ONLINE_CONF_DIR" -d 0 >"$work/slapd.log" 2>&1 &
    for i in $(seq 1 60); do ldap_ready && return 0; sleep 0.5; done
    cat "$work/slapd.log" >&2; die "OpenLDAP failed to start"
}
stop_bg() {
    local pid; pid="$(running_pid)" || return 0
    kill "$pid"
    for i in $(seq 1 60); do kill -0 "$pid" 2>/dev/null || return 0; sleep 0.5; done
    die "OpenLDAP failed to stop"
}
load_module() {   # load_module <file.so>
    cat > "$work/mod.ldif" << EOF
dn: cn=module,cn=config
cn: module
objectClass: olcModuleList
olcModulePath: ${LDAP_MODULE_DIR}
olcModuleLoad: $1
EOF
    ldif_add "$work/mod.ldif"
}

# ---- first start --------------------------------------------------------------
initialize() {
    local me="gidNumber=$(id -g)+uidNumber=$(id -u),cn=peercred,cn=external,cn=auth"
    local root="gidNumber=0+uidNumber=0,cn=peercred,cn=external,cn=auth"
    log "creating cn=config in $LDAP_ONLINE_CONF_DIR"
    cat > "$work/slapd.ldif" << EOF
dn: cn=config
objectClass: olcGlobal
cn: config
olcArgsFile: ${LDAP_RUN_DIR}/slapd.args
olcPidFile: ${LDAP_PID_FILE}

dn: cn=module,cn=config
cn: module
objectClass: olcModuleList
olcModulePath: ${LDAP_MODULE_DIR}
olcModuleLoad: pw-sha2.so
olcModuleLoad: pw-pbkdf2.so

dn: cn=schema,cn=config
objectClass: olcSchemaConfig
cn: schema

include: file://${LDAP_CONF_DIR}/schema/core.ldif

dn: olcDatabase=frontend,cn=config
objectClass: olcDatabaseConfig
objectClass: olcFrontendConfig
olcDatabase: frontend

dn: olcDatabase=config,cn=config
objectClass: olcDatabaseConfig
olcDatabase: config
olcAccess: to * by dn.base="${root}" manage by dn.base="${me}" manage by * none

dn: olcDatabase=monitor,cn=config
objectClass: olcDatabaseConfig
olcDatabase: monitor
olcAccess: to * by dn.base="${root}" read by dn.base="${me}" read by dn.base="${LDAP_ADMIN_DN}" read by * none

dn: olcDatabase=mdb,cn=config
objectClass: olcDatabaseConfig
objectClass: olcMdbConfig
olcDatabase: mdb
olcDbMaxSize: 1073741824
olcSuffix: ${LDAP_SUFFIX}
olcRootDN: ${LDAP_ADMIN_DN}
olcRootPW: $(hash_of "$LDAP_ADMIN_PASSWORD")
olcMonitoring: FALSE
olcDbDirectory: ${LDAP_DATA_DIR}
olcDbIndex: objectClass eq,pres
olcDbIndex: ou,cn,mail,surname,givenname eq,pres,sub
olcAccess: to attrs=userPassword by self write by anonymous auth by * none
olcAccess: to * by self read by users read by * none
EOF
    if is_yes "$LDAP_CONFIG_ADMIN_ENABLED"; then
        sed -i "/^olcDatabase: config\$/a olcRootDN: ${LDAP_CONFIG_ADMIN_DN}\nolcRootPW: $(hash_of "$LDAP_CONFIG_ADMIN_PASSWORD")" "$work/slapd.ldif"
    fi
    slapadd -F "$LDAP_ONLINE_CONF_DIR" -n 0 -l "$work/slapd.ldif" >/dev/null || die "slapadd cn=config failed"
    start_bg

    if ! is_yes "$LDAP_ALLOW_ANON_BINDING"; then
        log "disabling anonymous binding"
        printf 'dn: cn=config\nchangetype: modify\nadd: olcDisallows\nolcDisallows: bind_anon\n\ndn: cn=config\nchangetype: modify\nadd: olcRequires\nolcRequires: authc\n' > "$work/anon.ldif"
        ldif "$work/anon.ldif"
    fi
    if is_yes "$LDAP_ADD_SCHEMAS"; then
        read -r -a schemas <<< "$(tr ',;' ' ' <<< "${LDAP_EXTRA_SCHEMAS}")"
        for s in "${schemas[@]}"; do
            log "adding schema $s"
            ldif_add "${LDAP_CONF_DIR}/schema/${s}.ldif"
        done
    fi
    if [ -f "$LDAP_CUSTOM_SCHEMA_FILE" ]; then
        log "adding custom schema $LDAP_CUSTOM_SCHEMA_FILE"
        stop_bg
        slapadd -F "$LDAP_ONLINE_CONF_DIR" -n 0 -l "$LDAP_CUSTOM_SCHEMA_FILE" >/dev/null || die "custom schema failed"
        start_bg
    fi
    if [ -d "$LDAP_CUSTOM_SCHEMA_DIR" ] && [ -n "$(ls -A "$LDAP_CUSTOM_SCHEMA_DIR" 2>/dev/null)" ]; then
        while IFS= read -r -d '' f; do
            log "adding custom schema $f"
            ldif_add "$f"
        done < <(find "$LDAP_CUSTOM_SCHEMA_DIR" -maxdepth 1 \( -type f -o -type l \) -iname '*.ldif' -print0 | sort -z)
    fi
    if [ "$LDAP_PASSWORD_HASH" != "{SSHA}" ]; then
        log "olcPasswordHash $LDAP_PASSWORD_HASH"
        printf 'dn: olcDatabase={-1}frontend,cn=config\nchangetype: modify\nadd: olcPasswordHash\nolcPasswordHash: %s\n' "$LDAP_PASSWORD_HASH" > "$work/hash.ldif"
        ldif "$work/hash.ldif"
    fi
    if is_yes "$LDAP_CONFIGURE_PPOLICY"; then
        log "configuring ppolicy"
        # 2.4 ships the ppolicy schema separately (built in since 2.5)
        [ -f "${LDAP_CONF_DIR}/schema/ppolicy.ldif" ] && ldif_add "${LDAP_CONF_DIR}/schema/ppolicy.ldif"
        load_module ppolicy.so
        printf 'dn: olcOverlay={0}ppolicy,olcDatabase={2}mdb,cn=config\nobjectClass: olcOverlayConfig\nobjectClass: olcPPolicyConfig\nolcOverlay: {0}ppolicy\n' > "$work/pp.ldif"
        is_yes "$LDAP_PPOLICY_HASH_CLEARTEXT" && echo 'olcPPolicyHashCleartext: TRUE' >> "$work/pp.ldif"
        is_yes "$LDAP_PPOLICY_USE_LOCKOUT" && echo 'olcPPolicyUseLockout: TRUE' >> "$work/pp.ldif"
        ldif_add "$work/pp.ldif"
    fi
    if is_yes "$LDAP_ENABLE_ACCESSLOG"; then
        log "configuring access logging"
        printf 'dn: olcDatabase={2}mdb,cn=config\nchangetype: modify\nadd: olcDbIndex\nolcDbIndex: entryCSN eq\n-\nadd: olcDbIndex\nolcDbIndex: entryUUID eq\n' > "$work/al1.ldif"
        ldif "$work/al1.ldif"
        load_module accesslog.so
        mkdir -p "$LDAP_ACCESSLOG_DATA_DIR"
        cat > "$work/al2.ldif" << EOF
dn: olcDatabase={3}mdb,cn=config
objectClass: olcDatabaseConfig
objectClass: olcMdbConfig
olcDatabase: {3}mdb
olcDbDirectory: ${LDAP_ACCESSLOG_DATA_DIR}
olcSuffix: ${LDAP_ACCESSLOG_DB}
olcRootDN: ${LDAP_ACCESSLOG_ADMIN_DN}
olcRootPW: $(hash_of "$LDAP_ACCESSLOG_ADMIN_PASSWORD")
olcDbIndex: default eq
olcDbIndex: entryCSN,objectClass,reqEnd,reqResult,reqStart
EOF
        ldif_add "$work/al2.ldif"
        cat > "$work/al3.ldif" << EOF
dn: olcOverlay=accesslog,olcDatabase={2}mdb,cn=config
objectClass: olcOverlayConfig
objectClass: olcAccessLogConfig
olcOverlay: accesslog
olcAccessLogDB: ${LDAP_ACCESSLOG_DB}
olcAccessLogOps: ${LDAP_ACCESSLOG_LOGOPS}
olcAccessLogSuccess: ${LDAP_ACCESSLOG_LOGSUCCESS}
olcAccessLogPurge: ${LDAP_ACCESSLOG_LOGPURGE}
olcAccessLogOld: ${LDAP_ACCESSLOG_LOGOLD}
olcAccessLogOldAttr: ${LDAP_ACCESSLOG_LOGOLDATTR}
EOF
        ldif_add "$work/al3.ldif"
    fi
    if is_yes "$LDAP_ENABLE_SYNCPROV"; then
        log "configuring the sync provider"
        load_module syncprov.so
        printf 'dn: olcOverlay=syncprov,olcDatabase={2}mdb,cn=config\nobjectClass: olcOverlayConfig\nobjectClass: olcSyncProvConfig\nolcOverlay: syncprov\nolcSpCheckpoint: %s\nolcSpSessionLog: %s\n' \
            "$LDAP_SYNCPROV_CHECKPPOINT" "$LDAP_SYNCPROV_SESSIONLOG" > "$work/sp.ldif"
        ldif_add "$work/sp.ldif"
    fi

    if [ -d "$LDAP_CUSTOM_LDIF_DIR" ] && [ -n "$(ls -A "$LDAP_CUSTOM_LDIF_DIR" 2>/dev/null)" ]; then
        log "loading custom LDIF files from $LDAP_CUSTOM_LDIF_DIR (LDAP_USERS / LDAP_GROUP ignored)"
        while IFS= read -r -d '' f; do
            ldapadd -x -H "$LDAPI_URI" -D "$LDAP_ADMIN_DN" -w "$LDAP_ADMIN_PASSWORD" -f "$f" >/dev/null || die "ldapadd $f failed"
        done < <(find "$LDAP_CUSTOM_LDIF_DIR" -maxdepth 1 \( -type f -o -type l \) -iname '*.ldif' -print0 | sort -z)
    elif ! is_yes "$LDAP_SKIP_DEFAULT_TREE"; then
        log "creating the default tree under $LDAP_ROOT"
        local dc="" o=example attr i=0
        read -r -a rootparts <<< "$(tr ',;' ' ' <<< "${LDAP_ROOT}")"
        for attr in "${rootparts[@]}"; do
            if [[ $attr = dc=* ]] && [ -z "$dc" ]; then dc="${attr:3}"
            elif [[ $attr = o=* ]] && [ "$o" = example ]; then o="${attr:2}"; fi
        done
        {
            printf 'dn: %s\nobjectClass: dcObject\nobjectClass: organization\ndc: %s\no: %s\n\n' "$LDAP_ROOT" "$dc" "$o"
            printf 'dn: ou=%s,%s\nobjectClass: organizationalUnit\nou: users\n\n' "$LDAP_USER_OU" "$LDAP_ROOT"
            printf 'dn: ou=%s,%s\nobjectClass: organizationalUnit\nou: groups\n\n' "$LDAP_GROUP_OU" "$LDAP_ROOT"
            for u in "${users[@]}"; do
                printf 'dn: cn=%s,ou=%s,%s\ncn: User%d\nsn: Bar%d\nobjectClass: inetOrgPerson\nobjectClass: posixAccount\nobjectClass: shadowAccount\nuserPassword: %s\nuid: %s\nuidNumber: %d\ngidNumber: %d\nhomeDirectory: /home/%s\n\n' \
                    "$u" "$LDAP_USER_OU" "$LDAP_ROOT" $((i + 1)) $((i + 1)) "$(hash_of "${passwords[$i]}")" "$u" $((i + 1000)) $((i + 1000)) "$u"
                i=$((i + 1))
            done
            printf 'dn: cn=%s,ou=%s,%s\ncn: %s\nobjectClass: groupOfNames\n' "$LDAP_GROUP" "$LDAP_GROUP_OU" "$LDAP_ROOT" "$LDAP_GROUP"
            for u in "${users[@]}"; do printf 'member: cn=%s,ou=%s,%s\n' "$u" "$LDAP_USER_OU" "$LDAP_ROOT"; done
        } > "$work/tree.ldif"
        ldapadd -x -H "$LDAPI_URI" -D "$LDAP_ADMIN_DN" -w "$LDAP_ADMIN_PASSWORD" -f "$work/tree.ldif" >/dev/null || die "default tree failed"
    else
        log "skipping the default tree"
    fi

    if is_yes "$LDAP_ENABLE_TLS"; then
        log "configuring TLS"
        {
            printf 'dn: cn=config\nchangetype: modify\nreplace: olcTLSCACertificateFile\nolcTLSCACertificateFile: %s\n-\n' "$LDAP_TLS_CA_FILE"
            printf 'replace: olcTLSCertificateFile\nolcTLSCertificateFile: %s\n-\n' "$LDAP_TLS_CERT_FILE"
            printf 'replace: olcTLSCertificateKeyFile\nolcTLSCertificateKeyFile: %s\n-\n' "$LDAP_TLS_KEY_FILE"
            printf 'replace: olcTLSVerifyClient\nolcTLSVerifyClient: %s\n' "$LDAP_TLS_VERIFY_CLIENTS"
            [ -f "$LDAP_TLS_DH_PARAMS_FILE" ] && printf -- '-\nreplace: olcTLSDHParamFile\nolcTLSDHParamFile: %s\n' "$LDAP_TLS_DH_PARAMS_FILE"
        } > "$work/tls.ldif"
        ldif "$work/tls.ldif"
        if is_yes "$LDAP_REQUIRE_TLS"; then
            printf 'dn: cn=config\nchangetype: modify\nadd: olcSecurity\nolcSecurity: tls=1\n' > "$work/tlsreq.ldif"
            ldif "$work/tlsreq.ldif"
        fi
    fi
    stop_bg
}

if [ -n "$(ls -A "$LDAP_DATA_DIR" 2>/dev/null)" ]; then
    log "Using persisted data in $LDAP_VOLUME_DIR"
else
    log "empty $LDAP_DATA_DIR: initialising OpenLDAP ${EMG_OPENLDAP_FULL_VERSION}"
    initialize
    log "initialisation done"
fi

# /docker-entrypoint-initdb.d/*.sh once per volume (with slapd up on ldapi)
if compgen -G '/docker-entrypoint-initdb.d/*.sh' >/dev/null && [ ! -f "$LDAP_DATA_DIR/.user_scripts_initialized" ]; then
    start_bg
    for f in /docker-entrypoint-initdb.d/*.sh; do
        log "running $f"
        if [ -x "$f" ]; then "$f" || die "$f failed"; else . "$f"; fi
    done
    touch "$LDAP_DATA_DIR/.user_scripts_initialized"
    stop_bg
fi

# ---- foreground slapd ---------------------------------------------------------
urls="$LDAPI_URI"
if ! is_yes "$LDAP_ENABLE_PROXYPROTO" || [ "$LDAP_PORT_NUMBER" != "$LDAP_PROXYPROTO_PORT_NUMBER" ]; then
    urls="$urls ldap://:${LDAP_PORT_NUMBER}/"
fi
if is_yes "$LDAP_ENABLE_TLS" && { ! is_yes "$LDAP_ENABLE_PROXYPROTO" || [ "$LDAP_LDAPS_PORT_NUMBER" != "$LDAP_PROXYPROTO_LDAPS_PORT_NUMBER" ]; }; then
    urls="$urls ldaps://:${LDAP_LDAPS_PORT_NUMBER}/"
fi
if is_yes "$LDAP_ENABLE_PROXYPROTO"; then
    urls="$urls pldap://:${LDAP_PROXYPROTO_PORT_NUMBER}/"
    is_yes "$LDAP_ENABLE_TLS" && urls="$urls pldaps://:${LDAP_PROXYPROTO_LDAPS_PORT_NUMBER}/"
fi
rm -rf "$work"
trap - EXIT
log "starting slapd ${EMG_OPENLDAP_FULL_VERSION}: $urls"
exec slapd -h "$urls" -F "$LDAP_ONLINE_CONF_DIR" -d "$LDAP_LOGLEVEL" "$@"
