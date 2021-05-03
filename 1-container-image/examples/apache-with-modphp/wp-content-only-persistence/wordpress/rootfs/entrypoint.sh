#!/bin/bash

set -o errexit
set -o nounset
set -o pipefail
# set -o xtrace # Uncomment this line for debugging purpose

. /functions.sh

# Aliases for environment variables for compatibility with Bitnami Helm chart
[[ -n "${MARIADB_HOST:-}" && -n "${MARIADB_PORT_NUMBER:-}" ]] && export WORDPRESS_DB_HOST="${MARIADB_HOST:-}:${MARIADB_PORT_NUMBER:-}"
[[ -n "${WORDPRESS_DATABASE_NAME:-}" ]] && export WORDPRESS_DB_NAME="${WORDPRESS_DATABASE_NAME:-}"
[[ -n "${WORDPRESS_DATABASE_USER:-}" ]] && export WORDPRESS_DB_USER="${WORDPRESS_DATABASE_USER:-}"
[[ -n "${WORDPRESS_DATABASE_PASSWORD:-}" ]] && export WORDPRESS_DB_PASSWORD="${WORDPRESS_DATABASE_PASSWORD:-}"

if [[ "$1" = "apachectl" ]]; then
    /setup.sh
    info "Starting WordPress"
fi

exec "$@"
