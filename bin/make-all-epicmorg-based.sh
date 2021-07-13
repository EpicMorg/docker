export SCRIPTPATH="$( cd -- "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"

clear

cd ${SCRIPTPATH}/../linux/epicmorg/prod/main    && pwd && make
cd ${SCRIPTPATH}/../linux/epicmorg/prod/jdk6    && pwd && make
cd ${SCRIPTPATH}/../linux/epicmorg/prod/jdk7    && pwd && make
cd ${SCRIPTPATH}/../linux/epicmorg/prod/jdk8    && pwd && make
cd ${SCRIPTPATH}/../linux/epicmorg/prod/jdk11   && pwd && make

cd ${SCRIPTPATH}/../linux/epicmorg/edge/main    && pwd && make
cd ${SCRIPTPATH}/../linux/epicmorg/edge/jdk6    && pwd && make
cd ${SCRIPTPATH}/../linux/epicmorg/edge/jdk7    && pwd && make
cd ${SCRIPTPATH}/../linux/epicmorg/edge/jdk8    && pwd && make
cd ${SCRIPTPATH}/../linux/epicmorg/edge/jdk11   && pwd && make

cd ${SCRIPTPATH}/../linux/epicmorg/devel/main    && pwd && make
cd ${SCRIPTPATH}/../linux/epicmorg/devel/jdk6    && pwd && make
cd ${SCRIPTPATH}/../linux/epicmorg/devel/jdk7    && pwd && make
cd ${SCRIPTPATH}/../linux/epicmorg/devel/jdk8    && pwd && make
cd ${SCRIPTPATH}/../linux/epicmorg/devel/jdk11   && pwd && make

cd ${SCRIPTPATH}/../linux/php/latest             && pwd && make
cd ${SCRIPTPATH}/../linux/php/php7.2             && pwd && make
cd ${SCRIPTPATH}/../linux/php/php7.3             && pwd && make
cd ${SCRIPTPATH}/../linux/php/php7.4             && pwd && make

cd ${SCRIPTPATH}/../linux/apache2/latest         && pwd && make
cd ${SCRIPTPATH}/../linux/apache2/php7.2         && pwd && make
cd ${SCRIPTPATH}/../linux/apache2/php7.3         && pwd && make
cd ${SCRIPTPATH}/../linux/apache2/php7.4         && pwd && make

cd ${SCRIPTPATH}/../linux/testrail/latest        && pwd && make

cd ${SCRIPTPATH}/../linux/nginx/latest/main      && pwd && make
cd ${SCRIPTPATH}/../linux/nginx/latest/php       && pwd && make
cd ${SCRIPTPATH}/../linux/nginx/latest/rtmp-hls  && pwd && make

exit 0
