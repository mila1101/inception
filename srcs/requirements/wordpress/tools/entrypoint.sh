#!/usr/bin/env bash
set -euo pipefail

DB_PASS=$(cat /run/secrets/db_password)
ADMIN_PASS=$(cat /run/secrets/wp_admin_password)
USER_PASS=$(cat /run/secrets/wp_user_password)

DB_NAME=${WORDPRESS_DB_NAME}
DB_USER=${WORDPRESS_DB_USER}
DB_HOST=${WORDPRESS_DB_HOST}
SITE_TITLE=${TITLE:-INCEPTION}
DOMAIN_NAME=${DOMAIN_NAME:-localhost}

echo "(>‿◠) waiting for MariaDB at $DB_HOST..."
until mysqladmin ping -h"$DB_HOST" -u"$DB_USER" -p"$DB_PASS" --silent; do
	sleep 2
done
echo "(^_^) MariaDB is up."

if [ ! -f /var/www/html/wp-config.php ]; then
	if [ ! -f /var/www/html/wp-settings.php ]; then
		echo "(^‿^) downloading WordPress..."
		wp core download --allow-root --path=/var/www/html
	fi

	echo "(^‿^) creating wp-config.php..."
	wp config create --allow-root \
		--dbname="$DB_NAME" \
		--dbuser="$DB_USER" \
		--dbpass="$DB_PASS" \
		--dbhost="$DB_HOST" \
		--path=/var/www/html --force

	echo "(^‿^) installing WordPress..."
	wp core install --allow-root \
		--url="http://$DOMAIN_NAME" \
		--title="$SITE_TITLE" \
		--admin_user="siteowner" \
		--admin_password="$ADMIN_PASS" \
		--admin_email="admin@example.com" \
		--path=/var/www/html

	echo "(^‿^) creating second user..."
	wp user create --allow-root writer writer@example.com \
		--user_pass="$USER_PASS" \
		--role=author \
		--path=/var/www/html
fi

chown -R www-data:www-data /var/www/html

exec /usr/sbin/php-fpm7.4 -F
