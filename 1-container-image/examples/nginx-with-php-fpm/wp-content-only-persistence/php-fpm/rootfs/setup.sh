#!/bin/bash

# Strict mode
set -o errexit
set -o nounset
set -o pipefail
# set -o xtrace # Uncomment for debugging purposes

. /functions.sh

## Validate environment variables / inputs
# Database credentials
assert_not_empty WORDPRESS_DB_HOST
assert_not_empty WORDPRESS_DB_NAME
assert_not_empty WORDPRESS_DB_USER
if is_boolean_yes "${ALLOW_EMPTY_PASSWORD:-no}"; then
    warn "ALLOW_EMPTY_PASSWORD is enabled, never use in production!"
else
    assert_not_empty WORDPRESS_DB_PASSWORD
fi
# Throw error if any error occured
assert_check

# Initialize the application
if is_mounted_dir_empty /wp-content; then
    info "Persisting WordPress content"
    cp -r /wordpress/wp-content/. /wp-content
else
    info "Deploying WordPress with persisted content"
fi

# The wp-content folder will leave in a persisted volume
rm -rf /wordpress/wp-content
ln -s /wp-content /wordpress/wp-content
