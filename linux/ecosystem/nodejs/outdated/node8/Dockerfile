FROM epicmorg/debian:buster
LABEL maintainer="EpicMorg DevTeam, developer@epicm.org"
ARG DEBIAN_FRONTEND=noninteractive

##################################################################
#                   Node.js 8.x
##################################################################
RUN groupadd node && \
    useradd --gid node --shell /bin/bash --create-home node

RUN curl -fsSL https://deb.nodesource.com/setup_8.x | bash - && \
    curl -fsSL https://dl.yarnpkg.com/debian/pubkey.gpg | sudo gpg --dearmor -o /etc/apt/keyrings/yarnpkg.gpg && \
    echo "deb [signed-by=/etc/apt/keyrings/yarnpkg.gpg] https://nightly.yarnpkg.com/debian/ nightly main" > /etc/apt/sources.list.d/yarn.list && \
    apt-get update && \
    apt-cache policy nodejs && \
    apt-get install -y nodejs=8.17.0-1nodesource1 yarn

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
    rm -rfv /tmp/*
