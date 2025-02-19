#!/bin/sh

set -e

echo "Starting entrypoint script..."

# Remove any stale server PID file if it exists
rm -f tmp/pids/server.pid

bundle install

# Then exec the container's main process (what's set as CMD in the Dockerfile).
exec "$@"