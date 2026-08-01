#!/bin/sh

set -e

echo "Launching MariaDB setup..."

# Load passwords from Docker secrets 
MYSQL_ROOT_PASSWORD=$(cat /run/secrets/db_root_password)
MYSQL_PASSWORD=$(cat /run/secrets/db_password)

# Make sure required variables exist
: "${MYSQL_ROOT_PASSWORD:?Missing root password}"
: "${MYSQL_DATABASE:?Missing database name}"
: "${MYSQL_USER:?Missing user name}"
: "${MYSQL_PASSWORD:?Missing user password}"

mkdir -p /run/mysqld
mkdir -p /var/lib/mysql

chown -R mysql:mysql /run/mysqld /var/lib/mysql

if [ ! -d "/var/lib/mysql/mysql" ]; then
    echo "Initializing MariaDB..."

    mariadb-install-db \
        --user=mysql \
        --datadir=/var/lib/mysql

    echo "Starting temporary MariaDB..."

    mariadbd \
        --user=mysql \
        --datadir=/var/lib/mysql \
        --socket=/run/mysqld/mysqld.sock \
        --skip-networking &

    DB_PID=$!

    i=0
    while [ "$i" -lt 30 ]; do
        if mariadb-admin \
            --socket=/run/mysqld/mysqld.sock \
            ping --silent
        then
            echo "MariaDB is ready."
            break
        fi

        i=$((i + 1))
        sleep 1
    done

    if [ "$i" -eq 30 ]; then
        echo "MariaDB failed to start."
        exit 1
    fi

    echo "Running bootstrap SQL..."

    mariadb \
        --protocol=SOCKET \
        --socket=/run/mysqld/mysqld.sock \
        -u root <<EOF

ALTER USER 'root'@'localhost'
IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}';

CREATE DATABASE IF NOT EXISTS \`${MYSQL_DATABASE}\`;

CREATE USER IF NOT EXISTS '${MYSQL_USER}'@'%'
IDENTIFIED BY '${MYSQL_PASSWORD}';

GRANT ALL PRIVILEGES
ON \`${MYSQL_DATABASE}\`.*
TO '${MYSQL_USER}'@'%';

FLUSH PRIVILEGES;

EOF

    echo "Bootstrap finished."

    mariadb-admin \
        --protocol=SOCKET \
        --socket=/run/mysqld/mysqld.sock \
        -u root \
        -p"${MYSQL_ROOT_PASSWORD}" \
        shutdown

    wait "$DB_PID"

    echo "Temporary server stopped."
else
    echo "Database already initialized."
fi

echo "Starting MariaDB..."

exec mariadbd \
    --user=mysql \
    --datadir=/var/lib/mysql \
    --console