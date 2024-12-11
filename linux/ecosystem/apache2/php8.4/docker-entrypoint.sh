#!/bin/bash

set -e

echo "[apache2] Starting up"

case "${FIX_WWW_DATA}" in
  "")
    echo "[apache2] env FIX_WWW_DATA is not set. Skipping..."
    ;;
  "false")
    echo "[apache2] env FIX_WWW_DATA is set to false. Skipping..."
    ;;
  "true")
    echo "[apache2] Changing permissions for /var/www path. Please wait."
    if [ -d "/var/www" ]; then
      chown www-data:www-data /var/www -R
      if [ $? -eq 0 ]; then
        echo "[apache2] Permissions changed successfully."
      else
        echo "[apache2] Error changing permissions for /var/www."
        exit 1
      fi
    else
      echo "[apache2] /var/www directory not found. Skipping permission change."
    fi
    ;;
  *)
    echo "[apache2] env FIX_WWW_DATA is set to an invalid value. Skipping..."
    ;;
esac

if [ -f /etc/apache2/envvars ]; then
  source /etc/apache2/envvars
else
  echo "[apache2] Warning: /etc/apache2/envvars not found."
fi

tail -F /var/log/apache2/* &

echo "[apache2] Starting Apache in the foreground."
exec apache2 -D FOREGROUND
