#!/usr/bin/env bash
set -euo pipefail

DB_PASS=$(cat /run/secrets/db_password)
ADMIN_PASS=$(cat /run/secrets/wp_admin_password)
USER_PASS=$(cat /run/secrets/wp_user_password)

DB_NAME=${WORDPRESS_DB_NAME}
DB_USER=${WORDPRESS_DB_USER}
DB_HOST=${WORDPRESS_DB_HOST}
WP_TITLE=${WP_TITLE:-INCEPTION}
WP_URL=${WP_URL:-https://msoklova.42.fr}
WP_ADMIN_USER=${WP_ADMIN_USER:-msoklova}
WP_ADMIN_EMAIL=${WP_ADMIN_EMAIL:-admin@example.com}
WP_USER=${WP_USER:-editor_user}
WP_USER_EMAIL=${WP_USER_EMAIL:-user@example.com}

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
		--url="$WP_URL" \
		--title="$WP_TITLE" \
		--admin_user="$WP_ADMIN_USER" \
		--admin_password="$ADMIN_PASS" \
		--admin_email="$WP_ADMIN_EMAIL" \
		--path=/var/www/html

	echo "(^‿^) creating second user..."
	wp user create --allow-root "$WP_USER" "$WP_USER_EMAIL" \
		--user_pass="$USER_PASS" \
		--role=editor \
		--path=/var/www/html

	echo "(^‿^) setting WordPress URL to domain only..."
	wp option update --allow-root home "$WP_URL" --path=/var/www/html
	wp option update --allow-root siteurl "$WP_URL" --path=/var/www/html
fi

echo "(^‿^) setting proper permissions..."
chown -R www-data:www-data /var/www/html
chmod -R 755 /var/www/html

echo "(^‿^) starting PHP-FPM..."
exec /usr/sbin/php-fpm8.2 -F