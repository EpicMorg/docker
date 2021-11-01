export SCRIPTPATH="$( cd -- "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"

clear

cd ${SCRIPTPATH}/../linux/ecosystem/epicmorg/prod/main    && pwd && make
cd ${SCRIPTPATH}/../linux/ecosystem/epicmorg/prod/jdk6    && pwd && make
cd ${SCRIPTPATH}/../linux/ecosystem/epicmorg/prod/jdk7    && pwd && make
cd ${SCRIPTPATH}/../linux/ecosystem/epicmorg/prod/jdk8    && pwd && make
cd ${SCRIPTPATH}/../linux/ecosystem/epicmorg/prod/jdk11   && pwd && make
cd ${SCRIPTPATH}/../linux/ecosystem/epicmorg/prod/jdk16   && pwd && make

cd ${SCRIPTPATH}/../linux/ecosystem/epicmorg/edge/main    && pwd && make
cd ${SCRIPTPATH}/../linux/ecosystem/epicmorg/edge/jdk6    && pwd && make
cd ${SCRIPTPATH}/../linux/ecosystem/epicmorg/edge/jdk7    && pwd && make
cd ${SCRIPTPATH}/../linux/ecosystem/epicmorg/edge/jdk8    && pwd && make
cd ${SCRIPTPATH}/../linux/ecosystem/epicmorg/edge/jdk11   && pwd && make
cd ${SCRIPTPATH}/../linux/ecosystem/epicmorg/edge/jdk16   && pwd && make

cd ${SCRIPTPATH}/../linux/ecosystem/epicmorg/devel/main    && pwd && make
cd ${SCRIPTPATH}/../linux/ecosystem/epicmorg/devel/jdk6    && pwd && make
cd ${SCRIPTPATH}/../linux/ecosystem/epicmorg/devel/jdk7    && pwd && make
cd ${SCRIPTPATH}/../linux/ecosystem/epicmorg/devel/jdk8    && pwd && make
cd ${SCRIPTPATH}/../linux/ecosystem/epicmorg/devel/jdk11   && pwd && make
cd ${SCRIPTPATH}/../linux/ecosystem/epicmorg/devel/jdk16   && pwd && make

cd ${SCRIPTPATH}/../linux/ecosystem/php/latest             && pwd && make
cd ${SCRIPTPATH}/../linux/ecosystem/php/php7.2             && pwd && make
cd ${SCRIPTPATH}/../linux/ecosystem/php/php7.3             && pwd && make
cd ${SCRIPTPATH}/../linux/ecosystem/php/php7.4             && pwd && make

cd ${SCRIPTPATH}/../linux/ecosystem/apache2/latest         && pwd && make
cd ${SCRIPTPATH}/../linux/ecosystem/apache2/php7.2         && pwd && make
cd ${SCRIPTPATH}/../linux/ecosystem/apache2/php7.3         && pwd && make
cd ${SCRIPTPATH}/../linux/ecosystem/apache2/php7.4         && pwd && make

cd ${SCRIPTPATH}/../linux/ecosystem/testrail/latest        && pwd && make

cd ${SCRIPTPATH}/../linux/ecosystem/postgres/latest       && pwd && make
cd ${SCRIPTPATH}/../linux/ecosystem/postgres/8.2          && pwd && make
cd ${SCRIPTPATH}/../linux/ecosystem/postgres/8.3          && pwd && make
cd ${SCRIPTPATH}/../linux/ecosystem/postgres/8.4          && pwd && make
cd ${SCRIPTPATH}/../linux/ecosystem/postgres/9.0          && pwd && make
cd ${SCRIPTPATH}/../linux/ecosystem/postgres/9.1          && pwd && make
cd ${SCRIPTPATH}/../linux/ecosystem/postgres/9.2          && pwd && make
cd ${SCRIPTPATH}/../linux/ecosystem/postgres/9.3          && pwd && make
cd ${SCRIPTPATH}/../linux/ecosystem/postgres/9.4          && pwd && make
cd ${SCRIPTPATH}/../linux/ecosystem/postgres/9.5          && pwd && make
cd ${SCRIPTPATH}/../linux/ecosystem/postgres/9.6          && pwd && make
cd ${SCRIPTPATH}/../linux/ecosystem/postgres/10           && pwd && make
cd ${SCRIPTPATH}/../linux/ecosystem/postgres/11           && pwd && make
cd ${SCRIPTPATH}/../linux/ecosystem/postgres/12           && pwd && make
cd ${SCRIPTPATH}/../linux/ecosystem/postgres/13           && pwd && make
cd ${SCRIPTPATH}/../linux/ecosystem/postgres/14           && pwd && make

cd ${SCRIPTPATH}/../linux/ecosystem/qbittorrent/latest    && pwd && make
cd ${SCRIPTPATH}/../linux/ecosystem/qbittorrent/stable    && pwd && make

cd ${SCRIPTPATH}/../linux/ecosystem/vk2discord/latest     && pwd && make

cd ${SCRIPTPATH}/../linux/ecosystem/teamcity/agent/latest         && pwd && make

cd ${SCRIPTPATH}/../linux/ecosystem/teamcity/agent/amxx-sdk       && pwd && make
cd ${SCRIPTPATH}/../linux/ecosystem/teamcity/agent/android-sdk    && pwd && make
cd ${SCRIPTPATH}/../linux/ecosystem/teamcity/agent/atlassian-sdk  && pwd && make
cd ${SCRIPTPATH}/../linux/ecosystem/teamcity/agent/dotnet-sdk     && pwd && make
cd ${SCRIPTPATH}/../linux/ecosystem/teamcity/agent/node12         && pwd && make
cd ${SCRIPTPATH}/../linux/ecosystem/teamcity/agent/node14         && pwd && make
cd ${SCRIPTPATH}/../linux/ecosystem/teamcity/agent/node15         && pwd && make
cd ${SCRIPTPATH}/../linux/ecosystem/teamcity/agent/node16         && pwd && make
cd ${SCRIPTPATH}/../linux/ecosystem/teamcity/agent/php7.2         && pwd && make
cd ${SCRIPTPATH}/../linux/ecosystem/teamcity/agent/php7.3         && pwd && make
cd ${SCRIPTPATH}/../linux/ecosystem/teamcity/agent/php7.4         && pwd && make
cd ${SCRIPTPATH}/../linux/ecosystem/teamcity/agent/steam-sdk      && pwd && make

cd ${SCRIPTPATH}/../linux/ecosystem/nginx/latest/main      && pwd && make
cd ${SCRIPTPATH}/../linux/ecosystem/nginx/latest/php       && pwd && make
cd ${SCRIPTPATH}/../linux/ecosystem/nginx/latest/rtmp-hls  && pwd && make
cd ${SCRIPTPATH}/../linux/ecosystem/nginx/latest/quic      && pwd && make

exit 0
