FROM quay.io/epicmorg/prod
LABEL maintainer="EpicMorg DevTeam, developer@epicm.org"
ARG DEBIAN_FRONTEND=noninteractive

##################################################################
#                   git-lfs official binary
##################################################################
RUN rm -rfv /etc/apt/sources.list.d/github_git-lfs.list
COPY sources.list.d/github_git-lfs.list /etc/apt/sources.list.d/github_git-lfs.list

##################################################################
#                   bullseye sources list
##################################################################
RUN  rm -rfv /etc/apt/sources.list
COPY sources.list.d/sources.list /etc/apt/sources.list
RUN  apt-get update && \
     apt autoremove -y && \
     apt-get install -y libc6 libxml2-utils && \
     apt-get upgrade -y && \
     apt-get dist-upgrade -y && \
     apt autoremove -y

##################################################################
#                   cleaninig up
##################################################################
RUN apt-get clean -y && \
    apt-get autoclean -y && \
    rm -rfv /var/lib/apt/lists/* && \
    rm -rfv /var/cache/apt/archives/*.deb
