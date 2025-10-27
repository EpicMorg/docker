FROM docker.io/epicmorg/debian:sid
LABEL maintainer="EpicMorg DevTeam, developer@epicm.org"
ARG DEBIAN_FRONTEND=noninteractive

ENV DOTNET_CHANNEL=STS
ENV DOTNET_ROOT=${EMG_LOCAL_BASE_DIR}/dotnet/${DOTNET_CHANNEL}
ARG DOTNET_TOOLS_DIR=${DOTNET_ROOT}/tools
ARG DOTNET_INSTALL_DIR=${DOTNET_ROOT}
ARG DOTNET_INSTALL_SCRIPT_URL=https://dotnet.microsoft.com/download/dotnet/scripts/v1/dotnet-install.sh

ENV DOTNET_CLI_TELEMETRY_OPTOUT=true
ENV DOTNET_SKIP_FIRST_TIME_EXPERIENCE=true

##################################################################
#                    Shared wget args
##################################################################
ARG WGET_ARGS="--continue \
  --quiet \
  --no-check-certificate \
  --retry-connrefused \
  --tries=15 \
  --timeout=30 \
  --waitretry=15 \
  --dns-timeout=30 \
  --connect-timeout=30 \
  --read-timeout=30 \
  --no-clobber"

ARG WGET_USER_AGENT="Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:128.0) Gecko/20100101 Firefox/128.0"

##################################################################
#                   installing dotnet
##################################################################
RUN set -eux; \
    mkdir -p ${DOTNET_ROOT} && \ 
    wget ${WGET_ARGS} --user-agent "${WGET_USER_AGENT}" -P /tmp ${DOTNET_INSTALL_SCRIPT_URL} && \
    chmod +x /tmp/dotnet-install.sh && \
    /tmp/dotnet-install.sh --verbose --no-path --install-dir ${DOTNET_ROOT} --channel ${DOTNET_CHANNEL} --version latest

##################################################################
#                   Setup $PATH
##################################################################
ENV PATH=$PATH:${DOTNET_ROOT}:${DOTNET_TOOLS_DIR}

##################################################################
#                   Version after install
##################################################################
RUN echo "=============================================" && \
    echo $(dotnet --info) && \
    echo $(dotnet --list-sdks) && \
    echo $(dotnet --list-runtimes) && \
    echo "============================================="

