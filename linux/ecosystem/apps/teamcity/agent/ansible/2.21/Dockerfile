##################################################################
#        TeamCity agent + ansible runtime (ghcr.io/epicmorg/ansible:2.21)
##################################################################
# All ansible agents share this file; they differ only in the version.
# The runtime (venv + collections) is taken as-is from the ansible image.
FROM ghcr.io/epicmorg/ansible:2.21 AS ansible

FROM ghcr.io/epicmorg/teamcity-agent:minimal
ARG DEBIAN_FRONTEND=noninteractive

ENV EMG_ANSIBLE_VERSION=2.21
ENV EMG_ANSIBLE_CORE_VERSION=2.21.5
ENV EMG_ANSIBLE_DIR=${EMG_LOCAL_BASE_DIR}/ansible/${EMG_ANSIBLE_VERSION}
ENV ANSIBLE_COLLECTIONS_PATH=${EMG_ANSIBLE_DIR}/collections
ENV ANSIBLE_FORCE_COLOR=0
ENV PATH=${EMG_ANSIBLE_DIR}/venv/bin:${PATH}

COPY --from=ansible ${EMG_ANSIBLE_DIR}/ ${EMG_ANSIBLE_DIR}/

RUN set -eux; \
    apt-get update; \
    apt-get install -y --no-install-recommends --no-install-suggests \
        python3 \
        sshpass \
        openssh-client \
        rsync; \
    for b in ${EMG_ANSIBLE_DIR}/venv/bin/ansible* ${EMG_ANSIBLE_DIR}/venv/bin/yamllint; do ln -sfn "$b" /usr/local/bin/; done; \
    apt-get clean; \
    rm -rf /var/lib/apt/lists/* /var/cache/apt/archives/*.deb /tmp/*

##################################################################
#                       Assertions (fatal)
##################################################################
RUN set -eu; \
    [ "$(readlink -f "$(command -v ansible)")" = "$(readlink -f ${EMG_ANSIBLE_DIR}/venv/bin/ansible)" ] \
      || { echo "FATAL: ansible on PATH is $(command -v ansible)" >&2; exit 1; }; \
    ansible --version | head -n1 | grep -q "core ${EMG_ANSIBLE_CORE_VERSION}\]" \
      || { echo "FATAL: not ansible-core ${EMG_ANSIBLE_CORE_VERSION}" >&2; ansible --version >&2; exit 1; }; \
    ansible --version; \
    ansible-lint --version; \
    ansible-galaxy collection list -p ${ANSIBLE_COLLECTIONS_PATH}; \
    ansible localhost -c local -m ansible.builtin.ping

LABEL dockerImage.teamcity.version="latest" \
      dockerImage.teamcity.buildNumber="latest"

WORKDIR ${AGENT_DIST}
