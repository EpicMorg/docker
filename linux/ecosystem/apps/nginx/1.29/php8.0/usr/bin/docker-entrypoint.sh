#!/bin/bash

set -e

echo "[nginx+php] Starting up"

case "${FIX_WWW_DATA}" in
  "")
    echo "[nginx+php] env FIX_WWW_DATA is not set. Skipping..."
    ;;
  "false")
    echo "[nginx+php] env FIX_WWW_DATA is set to false. Skipping..."
    ;;
  "true")
    echo "[nginx+php] Changing permissions for /var/www path. Please wait."
    if [ -d "/var/www" ]; then
      chown www-data:www-data /var/www -R
      echo "[nginx+php] Permissions changed successfully."
    else
      echo "[nginx+php] /var/www directory not found. Skipping permission change."
    fi
    ;;
  *)
    echo "[nginx+php] env FIX_WWW_DATA is set to an invalid value. Skipping..."
    ;;
esac

mkdir -p /run/php /run/nginx
chown www-data:www-data /run/php

echo "[nginx+php] Starting php-fpm and nginx under supervisord."
exec /usr/bin/supervisord -n -c /etc/supervisor/supervisord.conf
