#!/bin/bash
echo "Changing permissions for /var/www path. Dont worry, please wait."
chown www-data:www-data /var/www -R
echo "Done. Starting up"
source /etc/apache2/envvars
tail -F /var/log/apache2/* &
exec apache2 -D FOREGROUND
