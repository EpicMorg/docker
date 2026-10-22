#!/bin/sh
# epicmorg/freeradius entrypoint: a drop-in for freeradius/freeradius-server.
#   no arguments or flags only  -> freeradius -f <flags>
#   freeradius / radiusd [args] -> freeradius -f [args]  (foreground: the container lives with it)
#   anything else (radtest, radclient, sh ...) is executed as is.
# Configuration: /etc/freeradius (also /etc/raddb); mount clients.conf, mods-enabled/*,
# sites-enabled/*, certs/ there. radiusd starts as root and drops to freerad.
set -e

if [ "$#" -eq 0 ] || [ "${1#-}" != "$1" ]; then
    set -- freeradius "$@"
fi
case "$1" in
    freeradius|radiusd)
        shift
        exec radiusd -f "$@"
        ;;
esac
exec "$@"
