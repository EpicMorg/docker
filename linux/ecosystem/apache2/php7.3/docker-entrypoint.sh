#!/bin/bash

if [[ -z "${FIX_WWW_DATA}" ]]; then
  echo "[apache2] env FIX_WWW_DATA is not set. Skipping..."
elif [ "${FIX_WWW_DATA}" == "false" ]; then
  echo "[apache2] env FIX_WWW_DATA is set to false. Skipping..."
elif  [ "${FIX_WWW_DATA}" == "true" ]; then
  echo "[apache2] Changing permissions for /var/www path. Dont worry, please wait."
  chown www-data:www-data /var/www -R
  echo "[apache2] Done"
else
  echo "[apache2] env FIX_WWW_DATA is set to strange value. Skipping..."
fi

echo "[apache2] Starting up"
source /etc/apache2/envvars
tail -F /var/log/apache2/* &
exec apache2 -D FOREGROUND
