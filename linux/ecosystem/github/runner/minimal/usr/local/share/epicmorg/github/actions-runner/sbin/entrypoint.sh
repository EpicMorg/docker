#!/bin/bash
set -e

if [[ -z "$GITHUB_URL" || -z "$GITHUB_TOKEN" || -z "$RUNNER_NAME" ]]; then
  echo "❌ Required variables: GITHUB_URL, GITHUB_TOKEN, RUNNER_NAME"
  exit 1
fi

if [ -f ".runner" ]; then
  echo "⚠️ Runner already configured, removing..."
  "$RUNNER_DIST_DIR/config.sh" remove --unattended --token "$GITHUB_TOKEN"
fi

cleanup() {
  echo "Removing runner..."
  "$RUNNER_DIST_DIR/config.sh" remove --unattended --token "$GITHUB_TOKEN"
}
trap 'cleanup; exit 130' INT TERM

"$RUNNER_DIST_DIR/config.sh" --unattended --replace \
  --url "$GITHUB_URL" \
  --token "$GITHUB_TOKEN" \
  --name "$RUNNER_NAME" \
  --work "$RUNNER_WORK_DIR"

"$RUNNER_DIST_DIR/run.sh"
