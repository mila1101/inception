#!/usr/bin/env bash
set -euo pipefail

: "${DB_NAME:?missing}"; : "${DB_USER:?missing}"
: "${MYSQL_ROOT_PASSWORD_FILE:?missing}"; : "${MYSQL_PASSWORD_FILE:?missing}"

DB_ROOT_PASSWORD=$(cat "$MYSQL_ROOT_PASSWORD_FILE")
DB_PASSWORD=$(cat "$MYSQL_PASSWORD_FILE")

if [ ! -d /var/lib/mysql/mysql ]; then
install -o mysql -g mysql -d /run/mysqld /var/lib/mysql
mariadb-install-db --user=mysql --datadir=/var/lib/mysql >/dev/null

mysqld --skip-networking --socket=/run/mysqld/mysqld.sock --datadir=/var/lib/mysql --user=mysql &
pid=$!
for i in {1..40}; do
	mariadb-admin --socket=/run/mysqld/mysqld.sock ping >/dev/null 2>&1 && break
	sleep 1
done

mariadb --socket=/run/mysqld/mysqld.sock <<SQL
ALTER USER 'root'@'localhost' IDENTIFIED BY '${DB_ROOT_PASSWORD}';
CREATE DATABASE IF NOT EXISTS \`${DB_NAME}\` CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;
CREATE USER IF NOT EXISTS '${DB_USER}'@'%' IDENTIFIED BY '${DB_PASSWORD}';
GRANT ALL PRIVILEGES ON \`${DB_NAME}\`.* TO '${DB_USER}'@'%';
FLUSH PRIVILEGES;
SQL

mariadb-admin --socket=/run/mysqld/mysqld.sock shutdown
wait $pid
fi

exec mysqld --user=mysql --datadir=/var/lib/mysql --bind-address=0.0.0.0
