################################################################################
# https://github.com/linuxserver/docker-code-server/pkgs/container/code-server
################################################################################
FROM docker.io/epicmorg/vscode-server:latest

LABEL maintainer="EpicMorg DevTeam, developer@epicm.org"
ARG DEBIAN_FRONTEND=noninteractive

##################################################################
#                   ARGuments
##################################################################
ENV BuildDocker=true

##################################################################
#                    Mono
##################################################################
# Ubuntu's own mono (universe). download.mono-project.com is unmaintained
# (mono moved to WineHQ) and its newest Ubuntu suite is focal; apt-key is
# deprecated. Not in noble and dropped: mono-llvm-support,
# referenceassemblies-pcl (mono-project only).
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
      mono-complete \
      mono-devel \
      mono-dbg \
      ca-certificates-mono \
      mono-xsp4 && \
    mono --version && \
    apt-get clean -y && \
    rm -rf /var/lib/apt/lists/* /var/cache/apt/archives/*.deb /tmp/*

