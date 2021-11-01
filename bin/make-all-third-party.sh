export SCRIPTPATH="$( cd -- "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"

clear

cd ${SCRIPTPATH}/../linux/advanced/zabbix/agent          && pwd && make
cd ${SCRIPTPATH}/../linux/advanced/zabbix/java-gateway   && pwd && make
cd ${SCRIPTPATH}/../linux/advanced/zabbix/proxy          && pwd && make
cd ${SCRIPTPATH}/../linux/advanced/zabbix/server         && pwd && make
cd ${SCRIPTPATH}/../linux/advanced/zabbix/web            && pwd && make

exit 1

cd ${SCRIPTPATH}/../linux/advanced/mattermost            && pwd && make
cd ${SCRIPTPATH}/../linux/advanced/nextcloud/latest      && pwd && make
cd ${SCRIPTPATH}/../linux/advanced/teamcity/server       && pwd && make
cd ${SCRIPTPATH}/../linux/advanced/redash                && pwd && make

cd ${SCRIPTPATH}/../linux/advanced/nextcloud/14          && pwd && make
cd ${SCRIPTPATH}/../linux/advanced/nextcloud/15          && pwd && make
cd ${SCRIPTPATH}/../linux/advanced/nextcloud/16          && pwd && make
cd ${SCRIPTPATH}/../linux/advanced/nextcloud/17          && pwd && make
cd ${SCRIPTPATH}/../linux/advanced/nextcloud/18          && pwd && make
cd ${SCRIPTPATH}/../linux/advanced/nextcloud/19          && pwd && make
cd ${SCRIPTPATH}/../linux/advanced/nextcloud/20          && pwd && make
cd ${SCRIPTPATH}/../linux/advanced/nextcloud/21          && pwd && make
cd ${SCRIPTPATH}/../linux/advanced/nextcloud/22          && pwd && make

exit 0
