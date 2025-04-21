FROM quay.io/epicmorg/debian:bookworm
LABEL maintainer="EpicMorg DevTeam, developer@epicm.org"
ARG DEBIAN_FRONTEND=noninteractive

##################################################################
#                   perforce default envs
##################################################################
ENV P4_VERSION=r19.1
ENV P4_CDN_URL=http://filehost.perforce.com/perforce/${P4_VERSION}/bin.linux26x86_64
ENV P4_DOWNLOAD_URL=${P4_CDN_URL}/p4
ENV P4BROKER_DOWNLOAD_URL=${P4_CDN_URL}/p4broker
ENV P4D_DOWNLOAD_URL=${P4_CDN_URL}/p4d
ENV P4DCTL_DOWNLOAD_URL=${P4_CDN_URL}/p4dctl
ENV P4MIGRATE_DOWNLOAD_URL=${P4_CDN_URL}/p4migrate
ENV P4P_DOWNLOAD_URL=${P4_CDN_URL}/p4p
ENV PERFMERGE_DOWNLOAD_URL=${P4_CDN_URL}/perfmerge
ENV PERFSPLIT_DOWNLOAD_URL=${P4_CDN_URL}/perfsplit

ENV P4DEBUG=
ENV P4PROOT=
ENV P4PCACHE=/perforce/cache
ENV P4LOG=/perforce/logs/p4p.log
ENV P4TARGET=
ENV P4PORT=1666
ENV P4ARGS=

ENV P4_BIN=/usr/bin/p4
ENV P4BROKER_BIN=/usr/bin/p4broker
ENV P4D_BIN=/usr/bin/p4d
ENV P4DCTL_BIN=/usr/bin/p4dctl
ENV P4MIGRATE_BIN=/usr/bin/p4migrate
ENV P4P_BIN=/usr/bin/p4p
ENV PERFMERGE_BIN=/usr/bin/perfmerge
ENV PERFSPLIT_BIN=/usr/bin/perfsplit

##################################################################
#                   Install perforce binaries
##################################################################
RUN rm -rfv \
        ${P4_BIN} \
        ${P4BROKER_BIN} \
        ${P4D_BIN} \
        ${P4DCTL_BIN} \
        ${P4MIGRATE_BIN} \
        ${P4P_BIN} \
        ${PERFMERGE_BIN} \
        ${PERFSPLIT_BIN}

RUN wget --no-check-certificate -nv --random-wait --retry-connrefused --continue -P /usr/bin \
        ${P4_DOWNLOAD_URL} \
        ${P4BROKER_DOWNLOAD_URL} \
        ${P4D_DOWNLOAD_URL} \
        ${P4DCTL_DOWNLOAD_URL} \
        ${P4MIGRATE_DOWNLOAD_URL} \
        ${P4P_DOWNLOAD_URL} \
        ${PERFMERGE_DOWNLOAD_URL} \
        ${PERFSPLIT_DOWNLOAD_URL}

RUN chmod +x \
        ${P4_BIN} \
        ${P4BROKER_BIN} \
        ${P4D_BIN} \
        ${P4DCTL_BIN} \
        ${P4MIGRATE_BIN} \
        ${P4P_BIN} \
        ${PERFMERGE_BIN} \
        ${PERFSPLIT_BIN}

# RUN echo "##################################################################" && \
#         ${P4_BIN} -V &&  \
#     echo "##################################################################" && \
#         ${P4BROKER_BIN} -V &&  \
#     echo "##################################################################" && \
#         ${P4D_BIN} -V &&  \
#     echo "##################################################################" && \
#         ${P4DCTL_BIN} -V &&  \
#     echo "##################################################################" && \
#         ${P4MIGRATE_BIN} -V &&  \
#     echo "##################################################################" && \
#         ${P4P_BIN}  -V && \
#     echo "##################################################################" && \
#         ${PERFMERGE_BIN} -V && \
#     echo "##################################################################" && \
#         ${PERFSPLIT_BIN} -V && \
#     echo "##################################################################"

WORKDIR /perforce
