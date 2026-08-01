#!/bin/sh

set -e

echo "Launching Wordpress setup..."



DB_PASSWORD=$(cat /run/secrets/db_password)
WP_ADMIN_PASSWORD=$(cat /run/secrets/wp_admin_password)
WP_USER_PASSWORD=$(cat /run/secrets/wp_user_password)

echo "Secrets loaded."

exec php-fpm84 -F