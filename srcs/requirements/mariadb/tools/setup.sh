#!/bin/sh

set -e

echo "Launching MariaDB setup..."

if [ ! -d "/var/lib/mysql/mysql" ]; then
    echo "Initializing MariaDB..."

    mariadb-install-db --user=mysql --datadir=/var/lib/mysql

    # Start temporary server

    i=0
    while [ "$i" -lt 20 ]; do
        if mariadb-admin ping --silent; then
            break
        fi

        i=$((i + 1))
        sleep 1
    done

    # SQL comes here

    # Shutdown comes here
fi

# Start real server