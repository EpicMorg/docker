##################################################################
#        ansible runtime (venv + collections) for COPY --from
##################################################################
# All ansible leaves share this file; they differ only in the EMG_ANSIBLE_*
# block below and in requirements.txt (ansible-core pin). Folder = major.minor,
# image = newest patch of that line.
# Consumers (e.g. teamcity-agent:ansible-<ver>):
#   COPY --from=ghcr.io/epicmorg/ansible:<ver> ${EMG_ANSIBLE_DIR}/ ${EMG_ANSIBLE_DIR}/
# The venv points at Debian's /usr/bin/python3: the consumer must be Debian 13 too.
FROM ghcr.io/epicmorg/debian:trixie
ARG DEBIAN_FRONTEND=noninteractive

ENV EMG_ANSIBLE_VERSION=2.17
ENV EMG_ANSIBLE_CORE_VERSION=2.17.14
ENV EMG_ANSIBLE_DIR=${EMG_LOCAL_BASE_DIR}/ansible/${EMG_ANSIBLE_VERSION}
ENV ANSIBLE_COLLECTIONS_PATH=${EMG_ANSIBLE_DIR}/collections
ENV ANSIBLE_FORCE_COLOR=0
ENV PATH=${EMG_ANSIBLE_DIR}/venv/bin:${PATH}

COPY requirements.txt collections.yml ${EMG_ANSIBLE_DIR}/

RUN set -eux; \
    apt-get update; \
    apt-get install -y --no-install-recommends --no-install-suggests \
        python3 \
        python3-venv \
        sshpass \
        openssh-client \
        rsync; \
    python3 -m venv ${EMG_ANSIBLE_DIR}/venv; \
    ${EMG_ANSIBLE_DIR}/venv/bin/pip install --no-cache-dir --upgrade pip; \
    ${EMG_ANSIBLE_DIR}/venv/bin/pip install --no-cache-dir -r ${EMG_ANSIBLE_DIR}/requirements.txt; \
    ansible-galaxy collection install -r ${EMG_ANSIBLE_DIR}/collections.yml -p ${ANSIBLE_COLLECTIONS_PATH}; \
    for b in ${EMG_ANSIBLE_DIR}/venv/bin/ansible* ${EMG_ANSIBLE_DIR}/venv/bin/yamllint; do ln -sfn "$b" /usr/local/bin/; done; \
    apt-get clean; \
    rm -rf /var/lib/apt/lists/* /var/cache/apt/archives/*.deb /root/.cache /tmp/*

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
