#!/usr/bin/env bash
set -eEo pipefail

wget --no-check-certificate -c https://gitlab-runner-downloads.s3.amazonaws.com/latest/deb/gitlab-runner_amd64.deb --random-wait -O /tmp/gitlab-runner.deb

dpkg -i "/tmp/gitlab-runner.deb"
apt-get update
apt-get -f install -y
rm -rfv /var/lib/apt/lists/*
rm -rfv "/tmp/gitlab-runner.deb"
