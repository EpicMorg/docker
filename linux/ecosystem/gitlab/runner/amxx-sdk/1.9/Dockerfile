FROM epicmorg/gitlab-runner:latest
LABEL maintainer="EpicMorg DevTeam, developer@epicm.org"
ARG DEBIAN_FRONTEND=noninteractive

##################################################################
#                    teamcity AMXXModX setup
##################################################################
#
# Reserved for future
#    export AMXX_CSTRIKE_LATEST_VERSION=`curl -s https://www.amxmodx.org/amxxdrop/1.9/amxmodx-latest-cstrike-linux` && \
#    export AMXX_DOD_LATEST_VERSION=`curl -s https://www.amxmodx.org/amxxdrop/1.9/amxmodx-latest-dod-linux` && \
#    export AMXX_ESF_LATEST_VERSION=`curl -s https://www.amxmodx.org/amxxdrop/1.9/amxmodx-latest-esf-linux` && \
#    export AMXX_NS_LATEST_VERSION=`curl -s https://www.amxmodx.org/amxxdrop/1.9/amxmodx-latest-ns-linux` && \
#    export AMXX_TFC_LATEST_VERSION=`curl -s https://www.amxmodx.org/amxxdrop/1.9/amxmodx-latest-tfc-linux` && \
#    export AMXX_TS_LATEST_VERSION=`curl -s https://www.amxmodx.org/amxxdrop/1.9/amxmodx-latest-base-linux` && \

# Install packages
ENV AMXX_VERSION=1.9
ENV AMXX_INSTALL_PATH=/opt/amxmodx/$AMXX_VERSION
ENV AMXX_BIN_PATH=$AMXX_INSTALL_PATH/scripting
ENV AMXX_INC_PATH=$AMXX_BIN_PATH/include
ENV PATH=$PATH:$AMXX_BIN_PATH
ENV LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$AMXX_BIN_PATH

COPY inc.tar /tmp

RUN export AMXX_BASE_LATEST_VERSION=`curl -s https://www.amxmodx.org/amxxdrop/1.9/amxmodx-latest-base-linux` && \
    mkdir -p $AMXX_INSTALL_PATH && \
    curl -SL https://www.amxmodx.org/amxxdrop/{$AMXX_VERSION}/{$AMXX_BASE_LATEST_VERSION} -o /tmp/amxx_base_latest.tar.gz && \
    cd /tmp && tar -zxf /tmp/amxx_base_latest.tar.gz && cd / && \
    mv -f /tmp/addons/amxmodx/* $AMXX_INSTALL_PATH && \
    chmod +x $AMXX_BIN_PATH/amxxpc && \
    chmod +x $AMXX_BIN_PATH/compile.sh && \
    tar -C $AMXX_INC_PATH -xvf /tmp/inc.tar && \
    chown -R gitlab-runner:gitlab-runner $AMXX_INC_PATH && \
    chmod -R 700 $AMXX_INC_PATH && \
    amxxpc --help 2>&1 | head -n 1

##################################################################
#                   cleaninig up
##################################################################
RUN apt clean -y && \
    apt-get clean all && \
    apt autoclean -y && \
    rm -rfv /var/lib/apt/lists/* && \
    rm -rfv /root/.cache/* && \
    rm -rfv /var/cache/apt/* && \
    rm -rfv /root/tmp/* && \
    rm -rfv /tmp/*

RUN updatedb
