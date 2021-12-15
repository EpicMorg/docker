FROM epicmorg/prod
LABEL maintainer="EpicMorg DevTeam, developer@epicm.org"
ARG DEBIAN_FRONTEND=noninteractive

##################################################################
#                   git-lfs official binary
##################################################################
RUN curl -L https://packagecloud.io/github/git-lfs/gpgkey | apt-key add - && \
    rm -rfv /etc/apt/sources.list.d/github_git-lfs.list
COPY github_git-lfs.list /etc/apt/sources.list.d/github_git-lfs.list

##################################################################
#                   bullseye sources list
##################################################################
RUN  rm -rfv /etc/apt/sources.list
COPY sources.list /etc/apt/sources.list
RUN  apt update && \
     apt autoremove -y && \
     apt-get install -y libc6 libxml2-utils && \
     apt upgrade -y && \
     apt dist-upgrade -y && \
     apt autoremove -y

##################################################################
#                   cleaninig up
##################################################################
RUN apt purge policykit-1 -y && \
    apt clean -y && \
    apt autoclean -y && \
    rm -rfv /var/lib/apt/lists/* && \
    rm -rfv /var/cache/apt/archives/*.deb
