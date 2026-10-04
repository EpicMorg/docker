#!/bin/bash
export PATRONI_LOG_DIR="/var/log/patroni"
export PATRONI_LOG_LEVEL=DEBUG

echo "start patroni"
exec su postgres -c "patroni /etc/patroni.yml"
#patroni /etc/patroni.yml