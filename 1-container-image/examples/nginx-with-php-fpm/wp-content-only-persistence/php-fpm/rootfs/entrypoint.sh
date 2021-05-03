#!/bin/bash

set -o errexit
set -o nounset
set -o pipefail
# set -o xtrace # Uncomment this line for debugging purpose

. /functions.sh

if [[ "$1" = "php-fpm" ]]; then
    /setup.sh
    info "Starting WordPress"
fi

exec "$@"
