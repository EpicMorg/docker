FROM epicmorg/teamcity-agent:latest
LABEL maintainer="EpicMorg DevTeam, developer@epicm.org"
ARG DEBIAN_FRONTEND=noninteractive

##################################################################
#                   Node.js 14.x
##################################################################
RUN groupadd --gid 1000 node \
  && useradd --uid 1000 --gid node --shell /bin/bash --create-home node

RUN curl -sL https://deb.nodesource.com/setup_14.x | bash - && \
    curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add - && \
    echo "deb https://nightly.yarnpkg.com/debian/ nightly main" > /etc/apt/sources.list.d/yarn.list && \
    apt-get update && \
    apt-get install -y nodejs yarn

#   curl -L https://www.npmjs.com/install.sh | sh
#   npm install -g npm

RUN echo "=============================================" && \
    echo node $(node --version) && \
    echo npm $(npm --version) && \
    echo yarn $(yarn --version) && \
    echo "============================================="

##################################################################
#                   cleaninig up
##################################################################
RUN apt clean -y && \
    apt-get clean all && \
    apt autoclean -y && \
    rm -rfv /var/lib/apt/lists/* && \
    rm -rfv /var/cache/apt/archives/*.deb && \
    rm -rfv /tmp/deb/* && \
    rm -rfv /tmp/composer-setup.php && \
    rm -rfv /tmp/amxx_base_latest.tar.gz && \
    rm -rfv /tmp/atlassian-plugin-sdk.deb && \
    rm -rfv /tmp/addons
