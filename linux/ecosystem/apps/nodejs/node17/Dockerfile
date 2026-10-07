FROM ghcr.io/epicmorg/debian:trixie
LABEL maintainer="EpicMorg DevTeam, developer@epicm.org"
ARG DEBIAN_FRONTEND=noninteractive

LABEL org.opencontainers.image.title="EpicMorg NodeJS"
LABEL org.opencontainers.image.description="NodeJS by EpicMorg"

ARG K_NODE_MAJOR_VERSION=17
ARG K_NODE_VERSION=${K_NODE_MAJOR_VERSION}.9.1
ARG K_NODE_URL=https://nodejs.org/dist/v${K_NODE_VERSION}/node-v${K_NODE_VERSION}-linux-x64.tar.gz
ARG K_NODE_HEADERS_URL=https://nodejs.org/dist/v${K_NODE_VERSION}/node-v${K_NODE_VERSION}-headers.tar.gz

# Installed into our own prefix, not straight into /usr/local; node, npm, npx,
# corepack and every global npm bin are symlinked into /usr/local/bin below,
# so downstream images and scripts keep finding them there.
ENV NODE_DIR=${EMG_LOCAL_BASE_DIR}/nodejs/17
ENV PATH=${NODE_DIR}/bin:${PATH}

##################################################################
#                   Node.js 17.x
##################################################################
RUN groupadd -g 1337 node && \
    useradd  -u 1337 --gid node --shell /bin/bash --create-home node

RUN set -eux; \
    aria2c \
        --conf-path=/usr/local/share/epicmorg/aria2/config/aria2.conf \
        --user-agent="$(shuf -n 1 /usr/local/share/epicmorg/user-agents/user-agents.txt)" \
        -d /tmp \
        "${K_NODE_URL}" && \
    aria2c \
        --conf-path=/usr/local/share/epicmorg/aria2/config/aria2.conf \
        --user-agent="$(shuf -n 1 /usr/local/share/epicmorg/user-agents/user-agents.txt)" \
        -d /tmp \
        "${K_NODE_HEADERS_URL}" && \
    mkdir -p ${NODE_DIR} && \
    tar -xzf /tmp/node-v${K_NODE_VERSION}-linux-x64.tar.gz --strip-components=1 --directory ${NODE_DIR} && \
    tar -xzf /tmp/node-v${K_NODE_VERSION}-headers.tar.gz --strip-components=1 --directory ${NODE_DIR} && \
    rm -rfv ${NODE_DIR}/CHANGELOG.md ${NODE_DIR}/LICENSE ${NODE_DIR}/README.md && \
# cleanup
    apt-get clean -y && \
    apt-get clean all -y && \
    apt-get autoclean -y && \
    rm -rfv /var/lib/apt/lists/* && \
    rm -rfv /var/cache/apt/archives/*.deb && \
    rm -rfv /tmp/*    

RUN npm install -g pnpm@latest-7 yarn

# Expose node, npm, npx, corepack and the global npm bins (pnpm, yarn ...)
# in /usr/local/bin. Fatal check: node/npm resolve into ${NODE_DIR}.
RUN set -eu; \
    for b in ${NODE_DIR}/bin/*; do ln -sfn "$b" /usr/local/bin/; done; \
    ls -la /usr/local/bin; \
    [ "$(readlink -f /usr/local/bin/node)" = "${NODE_DIR}/bin/node" ] || { echo "FATAL: /usr/local/bin/node not from ${NODE_DIR}" >&2; exit 1; }; \
    [ "$(node --version)" = "v${K_NODE_VERSION}" ] || { echo "FATAL: node is $(node --version), expected v${K_NODE_VERSION}" >&2; exit 1; }; \
    /usr/local/bin/npm --version

##################################################################
#                   Version after install
##################################################################
RUN echo "=============================================" && \
    echo node $(node --version) && \
    echo npm $(npm --version) && \
    echo yarn $(yarn --version) && \
    echo pnpm $(pnpm --version) && \
    echo "============================================="

