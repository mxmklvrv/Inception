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

cd /var/www/html

if ! wp core is-installed --allow-root >/dev/null 2>&1; then
    echo "Downloading WordPress..."
    wp core download --allow-root

    echo "WP creation of wp-config.php..."
    wp config create \
    --dbname="$MYSQL_DATABASE" \
    --dbuser="$MYSQL_USER" \
    --dbpass="$DB_PASSWORD" \
    --dbhost="${MYSQL_HOST}:3306" \
    --allow-root
    echo "WP installing core"
    wp core install \
    --url="$URL" \
    --title="$WP_TITLE" \
    --admin_user="$WP_ADMIN_USER" \
    --admin_password="$WP_ADMIN_PASSWORD" \
    --admin_email="$WP_ADMIN_EMAIL" \
    --allow-root
    wp user create \
    "$WP_USER" \
    "$WP_USER_EMAIL" \
    --user_pass="$WP_USER_PASSWORD" \
    --role=editor \
    --allow-root

fi

chown -R nobody:nobody /var/www/html

echo "Starting PHP-FPM..."
exec php-fpm84 -F