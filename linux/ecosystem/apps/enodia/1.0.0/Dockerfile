# SPDX-License-Identifier: AGPL-3.0-or-later
#
# Runtime image built on the user's own house base
# (ghcr.io/epicmorg/debian:trixie-light). This is now the only Dockerfile
# in this repo — goreleaser's own dockers_v2/docker_signs (and the release
# workflow's docker login/buildx/cosign-for-containers steps) were removed
# entirely; container publishing moved to the user's own epicmorg/docker
# repo instead, on its own schedule, decoupled from this repo's release
# run — see docs/DECISIONS.md D17's "Revisited" entry. This file is meant
# to be relocated there.
#
# Installs the raw binary from the release archive (not the .deb): no
# apt-installed package, no dedicated system user — this image runs as
# root, the house image's own default, by request.
#
# No repo source is needed to build this: everything is fetched over the
# network, so `docker build -f build/docker/Dockerfile build/docker`
# works from an otherwise-empty context.
#
# Release tags are MAJOR.MINOR.PATCH+BUILD, not four dots — confirmed live
# that goreleaser hard-fails on a literal "1.0.0.0" tag (see release.yml's
# own header comment and docs/DECISIONS.md D17's addendum); the real tag
# for a "1.0.0.0"-shaped release is "1.0.0+0".
FROM ghcr.io/epicmorg/debian:trixie-light

# "latest" resolves through GitHub's own /releases/latest/download/ alias,
# which needs no version string at all; pass an exact tag (e.g. "1.0.0+0")
# to pin one instead. TARGETARCH is set automatically by buildx and
# already matches goreleaser's own archive name_template exactly
# ("amd64"/"arm64"), no translation needed.
ARG ENODIA_VERSION=1.0.0+0
ARG TARGETARCH=amd64

RUN set -eux; \
	if [ "${ENODIA_VERSION}" = "latest" ]; then \
		url="https://github.com/EpicMorg/enodia/releases/latest/download/enodia_linux_${TARGETARCH}.tar.gz"; \
	else \
		url="https://github.com/EpicMorg/enodia/releases/download/${ENODIA_VERSION}/enodia_linux_${TARGETARCH}.tar.gz"; \
	fi && \
	aria2c \
        --conf-path="/usr/local/share/epicmorg/aria2/config/aria2.conf" \
        --user-agent="$(shuf -n 1 /usr/local/share/epicmorg/user-agents/user-agents.txt)" \
        -d / \
        -o /tmp/enodia.tar.gz \
        "$url" && \
	tar -xzf /tmp/enodia.tar.gz -C /usr/bin enodia && \
	chmod 0755 /usr/bin/enodia && \
    /usr/bin/enodia about && \
    echo "clean up" && \
    rm -rfv /tmp/*

# Config — enodia.yaml/settings.yaml/credentials.yaml — and the working
# directory for exported reports (inventory.jsonl, HTML exports, the
# resolver's on-disk cache, etc.); neither is created by an installed
# package here, so both are made explicitly. The volumes just make sure
# they survive container recreation and are easy to bind-mount from the
# host.
RUN mkdir -p /opt/enodia /etc/enodia

VOLUME ["/etc/enodia", "/opt/enodia"]
WORKDIR /opt/enodia

ENTRYPOINT ["/usr/bin/enodia"]
