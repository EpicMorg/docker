FROM epicmorg/debian:bullseye
LABEL maintainer="original by sethforprivacy; EpicMorg DevTeam, developer@epicm.org"
ARG DEBIAN_FRONTEND=noninteractive


##################################################################
#                   ARGuments
##################################################################
ENV P2POOL_DIR=/p2pool
ENV P2POOL_VERSION=4.1
ENV P2POOL_DOWNLOAD_URL=https://github.com/SChernykh/p2pool/releases/download/v${P2POOL_VERSION}/p2pool-v${P2POOL_VERSION}-linux-x64.tar.gz

##################################################################
#                   Installing
##################################################################
RUN mkdir -p ${P2POOL_DIR}

# Install remaining dependencies
RUN apt-get update \
    && apt-get upgrade -y \
    && apt-get install --no-install-recommends -y libuv1-dev libzmq3-dev libsodium-dev \
    libpgm-dev libnorm-dev libgss-dev libcurl4-openssl-dev libidn2-0-dev \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

RUN wget -qO-  ${P2POOL_DOWNLOAD_URL} | tar -xvz --strip-components=1 -C /tmp

RUN mv /tmp/p2pool /bin

RUN p2pool --help

# Switch to home directory and install newly built p2pool binary
WORKDIR ${P2POOL_DIR}

# Expose p2p and restricted RPC ports
EXPOSE 3333
EXPOSE 37889
EXPOSE 37888

# Start p2pool with required --non-interactive flag and sane defaults that are overridden by user input (if applicable)
ENTRYPOINT ["p2pool"]
CMD ["--host p2pool", "--stratum 0.0.0.0:3333", "--p2p 0.0.0.0:37889", "--addpeers 65.21.227.114:37889", "--addpeers node.sethforprivacy.com:37889"]

##################################################################
#                  cleanup
##################################################################
RUN echo "clean up" && \
    apt-get clean -y && \
    apt-get autoclean -y && \
    rm -rfv /var/lib/apt/lists/* && \
    rm -rfv /tmp/* && \
    rm -rfv /var/cache/apt/archives/*.deb

RUN updatedb
