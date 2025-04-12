FROM hub.epicm.org/epicmorg/teamcity-agent:minimal
LABEL maintainer="EpicMorg DevTeam, developer@epicm.org"
ARG DEBIAN_FRONTEND=noninteractive

##################################################################
#                    Atlassian SDK Setup
##################################################################

ENV ATLASSIAN_SDK_DIR=${EMG_LOCAL_BASE_DIR}/atlassian
ENV ATLASSIAN_SDK_BIN_DIR=${ATLASSIAN_SDK_DIR}/bin
ARG ATLASSIAN_SDK_TEMP=/tmp/atlassian-plugin-sdk.tgz
ARG ATLASSIAN_SDK_URL=https://marketplace.atlassian.com/download/plugins/atlassian-plugin-sdk-tgz

###############################
# https://community.atlassian.com/t5/Continuous-Delivery-questions/The-repository-https-packages-atlassian-com-atlassian-sdk-deb/qaq-p/1334014
#
# https://community.developer.atlassian.com/t/the-repository-https-packages-atlassian-com-atlassian-sdk-deb-stable-release-is-not-signed/36901
###############################
#COPY etc/apt/keyrings/atlassian.asc /etc/apt/keyrings/
#COPY etc/apt/sources.list.d/atlassian-sdk.list /etc/apt/sources.list.d/
#RUN apt-get update  --allow-insecure-repositories && \
#    apt-get install -y --no-install-recommends  --allow-unauthenticated  \
#      atlassian-plugin-sdk
#Install packages
#RUN curl -SL https://packages.atlassian.com/atlassian-sdk-deb/debian/pool/contrib/a/atlassian-plugin-sdk/atlassian-plugin-sdk_8.0.16_all.deb -o /tmp/atlassian-plugin-sdk.deb && \
#    dpkg -i /tmp/atlassian-plugin-sdk.deb

ADD ${ATLASSIAN_SDK_URL} ${ATLASSIAN_SDK_TEMP}

RUN mkdir -p ${ATLASSIAN_SDK_BIN_DIR} && \
    tar -xvzf /tmp/atlassian-plugin-sdk.tgz --strip-components=1 --directory ${ATLASSIAN_SDK_DIR}

ENV PATH=$PATH:${ATLASSIAN_SDK_BIN_DIR}

##################################################################
#                   Version after install
##################################################################
RUN echo "=============================================" && \
    atlas-version && \
    echo "============================================="

##################################################################
#                   cleaninig up
##################################################################
RUN apt-get clean -y && \
    apt-get clean all -y && \
    apt-get autoclean -y && \
    rm -rfv /var/lib/apt/lists/* && \
    rm -rfv /var/cache/apt/archives/*.deb && \
    rm -rfv /root/tmp/* && \
    rm -rfv /tmp/*

RUN updatedb
