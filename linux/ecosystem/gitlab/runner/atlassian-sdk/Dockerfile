FROM epicmorg/gitlab-runner:latest
LABEL maintainer="EpicMorg DevTeam, developer@epicm.org"
ARG DEBIAN_FRONTEND=noninteractive

##################################################################
#                    teamcity atlassian-sdk setup
##################################################################

#Install packages
#RUN curl -SL https://packages.atlassian.com/atlassian-sdk-deb/debian/pool/contrib/a/atlassian-plugin-sdk/atlassian-plugin-sdk_8.0.16_all.deb -o /tmp/atlassian-plugin-sdk.deb && \
#    dpkg -i /tmp/atlassian-plugin-sdk.deb

###############################
# https://community.atlassian.com/t5/Continuous-Delivery-questions/The-repository-https-packages-atlassian-com-atlassian-sdk-deb/qaq-p/1334014
#
# https://community.developer.atlassian.com/t/the-repository-https-packages-atlassian-com-atlassian-sdk-deb-stable-release-is-not-signed/36901
###############################
RUN curl -fsSL https://packages.atlassian.com/api/gpg/key/public | apt-key add - && \
    echo 'deb [trusted=yes] https://packages.atlassian.com/atlassian-sdk-deb stable contrib' > /etc/apt/sources.list.d/atlassian-sdk.list  && \
    apt update  --allow-insecure-repositories && \
    apt install -y --no-install-recommends  --allow-unauthenticated  \
      atlassian-plugin-sdk

##################################################################
#                   cleaninig up
##################################################################
RUN apt clean -y && \
    apt-get clean all && \
    apt autoclean -y && \
    rm -rfv /var/lib/apt/lists/* && \
    rm -rfv /var/cache/apt/archives/*.deb && \
    rm -rfv /tmp/*
