FROM epicmorg/debian:squeeze
LABEL maintainer="EpicMorg DevTeam, developer@epicm.org"

ARG DEBIAN_FRONTEND=noninteractive

ARG K_NODE_MAJOR_VERSION=6
ARG K_NODE_VERSION=${K_NODE_MAJOR_VERSION}.17.1
ARG K_NODE_URL=https://nodejs.org/dist/v${K_NODE_VERSION}/node-v${K_NODE_VERSION}-linux-x64.tar.gz
ARG K_NODE_HEADERS_URL=https://nodejs.org/dist/v${K_NODE_VERSION}/node-v${K_NODE_VERSION}-headers.tar.gz

##################################################################
#                   Node.js 6.x
##################################################################
RUN groupadd -g 1337 node && \
    useradd  -u 1337 --gid node --shell /bin/bash --create-home node

RUN curl --user-agent "Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101 Firefox/81.0" --location ${K_NODE_URL}?$(date +%s) \
         --header 'Cache-Control: no-cache, no-store' \
         --header 'Pragma: no-cache'  | tar xzv --strip-components=1 --directory /usr/local/ && \
         rm -rfv /usr/local/CHANGELOG.md /usr/local/LICENSE /usr/local/README.md
 
RUN curl --user-agent "Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101 Firefox/81.0" --location ${K_NODE_HEADERS_URL}?$(date +%s) \
         --header 'Cache-Control: no-cache, no-store' \
         --header 'Pragma: no-cache'  | tar xzv --strip-components=1 --directory /usr/local/

#RUN npm install -g pnpm yarn
RUN npm install -g pnpm@2

##################################################################
#                   Version after install
##################################################################
RUN echo "=============================================" && \
    echo node $(node --version) && \
    echo npm $(npm --version) && \
#    echo yarn $(yarn --version) && \
    echo pnpm $(pnpm --version) && \
    echo "============================================="

##################################################################
#                  cleanup
##################################################################
RUN echo "clean up" && \
apt-get clean -y && \
apt-get autoclean -y && \
rm -rfv /var/lib/apt/lists/* && \
rm -rfv /var/cache/apt/archives/*.deb && \
rm -rfv /tmp/*
