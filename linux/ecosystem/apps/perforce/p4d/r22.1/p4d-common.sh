# shellcheck shell=bash
# Shared by docker-entrypoint.sh, p4d-checkpoint and p4d-upgrade: one place that
# turns the environment into p4d arguments and logs the admin in.

: "${P4PORT:=1666}"
: "${P4ROOT:=/perforce/root}"
: "${P4JOURNAL:=/perforce/journals/journal}"
: "${P4LOG:=/perforce/logs/p4d.log}"
: "${P4AUDITLOG:=}"
: "${P4NAME:=}"
: "${P4DESCRIPTION:=}"
: "${P4CASE:=}"
: "${P4ARGS:=}"
: "${P4CHARSET:=}"
: "${P4ADMIN_USER:=}"
: "${P4ADMIN_PASSWD:=}"
: "${P4ADMIN_PASSWD_FILE:=}"
: "${P4BACKUPS:=/perforce/backups}"

# server args shared by p4d (serve), p4d -xu and offline checkpoints
p4d_db_args() {
  P4D_DB_ARGS=(-r "${P4ROOT}" -J "${P4JOURNAL}")
  [[ -n "${P4LOG}" ]] && P4D_DB_ARGS+=(-L "${P4LOG}")
  [[ -n "${P4AUDITLOG}" ]] && P4D_DB_ARGS+=(-A "${P4AUDITLOG}")
  [[ "${P4CASE}" == 1 ]] && P4D_DB_ARGS+=(-C1)
  mkdir -p "${P4ROOT}" "$(dirname "${P4JOURNAL}")" ${P4LOG:+"$(dirname "${P4LOG}")"} ${P4AUDITLOG:+"$(dirname "${P4AUDITLOG}")"}
}

# p4 client pointed at this server on localhost (same protocol, port, charset, user)
p4_local() {
  local port="${P4PORT##*:}" proto=""
  [[ "${P4PORT}" == ssl* ]] && proto="ssl:"
  P4_LOCAL=(p4 -p "${proto}localhost:${port}")
  [[ -n "${P4CHARSET}" ]] && P4_LOCAL+=(-C "${P4CHARSET}")
  [[ -n "${P4ADMIN_USER}" ]] && P4_LOCAL+=(-u "${P4ADMIN_USER}")
  if [[ -n "${proto}" ]]; then "${P4_LOCAL[@]}" trust -y >/dev/null 2>&1 || true; fi
}

# log the admin in when a password is given (else: ticket / unprotected server)
p4_admin_login() {
  local pass="${P4ADMIN_PASSWD}"
  [[ -n "${P4ADMIN_PASSWD_FILE}" && -r "${P4ADMIN_PASSWD_FILE}" ]] && pass="$(<"${P4ADMIN_PASSWD_FILE}")"
  [[ -z "${pass}" ]] && return 0
  printf '%s\n' "${pass}" | "${P4_LOCAL[@]}" login >/dev/null 2>&1 \
    || { echo "[p4d] WARN: login as ${P4ADMIN_USER:-<default user>} failed" >&2; return 1; }
}

p4d_running() {
  pgrep -x p4d >/dev/null 2>&1
}
