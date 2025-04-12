FROM hub.epicm.org/epicmorg/gitlab-runner:minimal
LABEL maintainer="EpicMorg DevTeam, developer@epicm.org"
ARG DEBIAN_FRONTEND=noninteractive

##################################################################
#                   Version after install
##################################################################
RUN echo "=============================================" && \
    echo $(dotnet --info) && \
    echo $(dotnet --list-sdks) && \
    echo $(dotnet --list-runtimes) && \
    echo "============================================="

##################################################################
#                  Cleanup
##################################################################
RUN echo "clean up" && \
    apt-get clean -y && \
    apt-get autoclean -y && \
    rm -rfv /var/lib/apt/lists/* && \
    rm -rfv /var/cache/apt/archives/*.deb && \
    rm -rfv /root/tmp/* && \
    rm -rfv /tmp/*

RUN updatedb
