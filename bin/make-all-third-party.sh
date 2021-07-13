export SCRIPTPATH="$( cd -- "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"

clear

cd ${SCRIPTPATH}/../linux/zabbix/agent          && pwd && make
cd ${SCRIPTPATH}/../linux/zabbix/java-gateway   && pwd && make
cd ${SCRIPTPATH}/../linux/zabbix/proxy          && pwd && make
cd ${SCRIPTPATH}/../linux/zabbix/server         && pwd && make
cd ${SCRIPTPATH}/../linux/zabbix/web            && pwd && make

exit 1

cd ${SCRIPTPATH}/../linux/mattermost/latest     && pwd && make
cd ${SCRIPTPATH}/../linux/nextcloud/latest      && pwd && make
cd ${SCRIPTPATH}/../linux/teamcity/server       && pwd && make


cd ${SCRIPTPATH}/../linux/nextcloud/14          && pwd && make
cd ${SCRIPTPATH}/../linux/nextcloud/15          && pwd && make
cd ${SCRIPTPATH}/../linux/nextcloud/16          && pwd && make
cd ${SCRIPTPATH}/../linux/nextcloud/17          && pwd && make
cd ${SCRIPTPATH}/../linux/nextcloud/18          && pwd && make
cd ${SCRIPTPATH}/../linux/nextcloud/19          && pwd && make
cd ${SCRIPTPATH}/../linux/nextcloud/20          && pwd && make
cd ${SCRIPTPATH}/../linux/nextcloud/21          && pwd && make
cd ${SCRIPTPATH}/../linux/nextcloud/22          && pwd && make

exit 0
