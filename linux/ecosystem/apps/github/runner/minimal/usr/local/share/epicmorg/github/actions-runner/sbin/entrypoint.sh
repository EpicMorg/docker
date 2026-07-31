#!/bin/bash
set -e  # Exit immediately on any error

# Validate required environment variables
if [[ -z "${GITHUB_URL}" || -z "${GITHUB_TOKEN}" || -z "${RUNNER_NAME}" ]]; then
  echo "❌ Error: Missing required variables - GITHUB_URL, GITHUB_TOKEN, RUNNER_NAME" >&2
  exit 1
fi

# Navigate to runner directory (fail fast if missing)
cd "${RUNNER_DIST_DIR}" || {
  echo "❌ Error: Runner directory not found" >&2
  exit 1
}

# Register/replace the runner (--replace handles existing configurations)
echo "🚀 Registering GitHub runner with --replace flag..."
./config.sh \
  --unattended \
  --replace \
  --url "${GITHUB_URL}" \
  --token "${GITHUB_TOKEN}" \
  --name "${RUNNER_NAME}" \
  --work "${RUNNER_WORK_DIR:-_work}" || {
    echo "❌ Error: Runner registration failed" >&2
    exit 1
  }

# Start the runner (exec replaces shell process for proper signal handling)
echo "🏃 Runner started successfully - waiting for jobs..."
exec ./run.sh
