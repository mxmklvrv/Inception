#!/bin/sh

set -e

echo "Launching MariaDB setup..."


mkdir -p /run/mysqld
chown mysql:mysql /run/mysqld

if [ ! -d "/var/lib/mysql/mysql" ]; then
    echo "Initializing MariaDB..."

    mariadb-install-db --user=mysql --datadir=/var/lib/mysql

    # Start temporary server
    mariadbd \
        --user=mysql \
        --datadir=/var/lib/mysql \
        --skip-networking &

    i=0
    while [ "$i" -lt 20 ]; do
        if mariadb-admin --socket=/run/mysqld/mysqld.sock ping --silent; then
            echo "MariaDB is ready"
            break
        fi
        i=$((i + 1))
        sleep 1
    done
    if [ "$i" -eq 20 ]; then
        echo "Failed setting up MariaDB"
        exit 1
    fi


    # SQL comes here

    # Shutdown comes here
fi

exec mariadbd \
    --user=mysql \
    --datadir=/var/lib/mysql