#!/bin/sh
# Credit for the bulk of this entrypoint script goes to cornfeedhobo
# Source is https://github.com/cornfeedhobo/docker-monero/blob/master/entrypoint.sh
set -e

# --non-interactive is required in a container; keep the blockchain in the
# declared volume (${MONERO_DATA}) unless the user passes their own --data-dir
case " $* " in
    *" --data-dir"*) set -- monerod --non-interactive "$@" ;;
    *) set -- monerod --non-interactive --data-dir="${MONERO_DATA}" "$@" ;;
esac

# Configure NUMA if present for improved performance
if command -v numactl >/dev/null 2>&1; then
    set -- numactl --interleave=all "$@"
fi

exec "$@"
