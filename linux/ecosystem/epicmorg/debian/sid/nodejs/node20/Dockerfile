FROM epicmorg/debian:sid
LABEL maintainer="EpicMorg DevTeam, developer@epicm.org"

ARG DEBIAN_FRONTEND=noninteractive

ARG K_NODE_MAJOR_VERSION=20
ARG K_NODE_VERSION=${K_NODE_MAJOR_VERSION}.16.0
ARG K_NODE_URL=https://nodejs.org/dist/v${K_NODE_VERSION}/node-v${K_NODE_VERSION}-linux-x64.tar.gz
ARG K_NODE_HEADERS_URL=https://nodejs.org/dist/v${K_NODE_VERSION}/node-v${K_NODE_VERSION}-headers.tar.gz

##################################################################
#                   Node.js 20.x
##################################################################
RUN groupadd -g 1337 node && \
    useradd  -u 1337 --gid node --shell /bin/bash --create-home node

ADD ${K_NODE_URL} /tmp
ADD ${K_NODE_HEADERS_URL} /tmp

RUN tar -xvzf /tmp/node-v${K_NODE_VERSION}-linux-x64.tar.gz --strip-components=1 --directory /usr/local && \
    tar -xvzf /tmp/node-v${K_NODE_VERSION}-headers.tar.gz --strip-components=1 --directory /usr/local && \
    rm -rfv /usr/local/CHANGELOG.md /usr/local/LICENSE /usr/local/README.md

RUN npm install -g pnpm yarn

##################################################################
#                   Version after install
##################################################################
RUN echo "=============================================" && \
    echo node $(node --version) && \
    echo npm $(npm --version) && \
    echo yarn $(yarn --version) && \
    echo pnpm $(pnpm --version) && \
    echo "============================================="

##################################################################
#                  cleanup
##################################################################
RUN echo "clean up" && \
    apt-get clean -y && \
    apt-get autoclean -y && \
    rm -rfv /var/lib/apt/lists/* && \
    rm -rfv /var/cache/apt/* && \
    rm -rfv /root/tmp/* && \
    rm -rfv /tmp/*
