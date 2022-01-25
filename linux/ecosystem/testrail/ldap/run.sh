#!/bin/bash
#set -e

function createOptDirectory {
    if [ ! -d $1 ]
    then
        echo "Creating " $1
        mkdir -p $1
    fi

    chown -R www-data:www-data $1
}

/bin/cp -rf /testrail-release/apache-conf/000-default.conf /etc/apache2/sites-enabled/000-default.conf

echo "##############"
echo "Unzipping testrail"
unzip -o /testrail-release/testrail.zip -d /var/www/
unzip -o -j /testrail-release/testrail-auth-ldap-1.4.zip testrail-auth-ldap-1.4/auth.php -d ${TR_CUSTOM_AUTH_DIR} && \
ls -las ${TR_CUSTOM_AUTH_DIR}

createOptDirectory $TR_DEFAULT_LOG_DIR
createOptDirectory $TR_DEFAULT_AUDIT_DIR
createOptDirectory $TR_DEFAULT_REPORT_DIR
createOptDirectory $TR_DEFAULT_ATTACHMENT_DIR

chown -R www-data:www-data /var/www/testrail/config

echo "##############"
echo "Waiting for background task file"
while [ ! -f /var/www/testrail/task.php ]
do
  sleep 2
done

echo "Starting background task"
while /bin/true; do
    php /var/www/testrail/task.php || true
    sleep $TR_DEFAULT_TASK_EXECUTION
done &
echo "##############"

chown www-data:www-data /var/www -R

source /etc/apache2/envvars
tail -F /var/log/apache2/* &
exec apache2 -D FOREGROUND
