#!/bin/sh

set -e

echo "Launching WordPress setup..."

DB_PASSWORD=$(cat /run/secrets/db_password)
WP_ADMIN_PASSWORD=$(cat /run/secrets/wp_admin_password)
WP_USER_PASSWORD=$(cat /run/secrets/wp_user_password)

echo "Secrets loaded."

mkdir -p /run/php

echo "Waiting for MariaDB..."

i=0
while [ "$i" -lt 20 ]; do
    if mariadb-admin ping \
        -h "$MYSQL_HOST" \
        -u "$MYSQL_USER" \
        -p"$DB_PASSWORD" \
        --silent >/dev/null 2>&1
    then
        echo "MariaDB is ready."
        break
    fi

    i=$((i + 1))
    sleep 1
done

if [ "$i" -eq 20 ]; then
    echo "MariaDB did not become ready."
    exit 1
fi

if [ ! -f /usr/local/bin/wp ]; then
    echo "Installing WP-CLI..."
    curl -o /usr/local/bin/wp \
        https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
    chmod +x /usr/local/bin/wp
fi


exec php-fpm84 -F