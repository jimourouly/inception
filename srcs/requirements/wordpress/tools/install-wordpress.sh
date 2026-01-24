#!/bin/bash

WP_ADMIN_USER=$(grep WORDPRESS_ADMIN_USER /run/secrets/credentials | cut -d'=' -f2)
WP_ADMIN_PASSWORD=$(grep WORDPRESS_ADMIN_PASSWORD /run/secrets/credentials | cut -d'=' -f2)
WP_ADMIN_EMAIL=$(grep WORDPRESS_ADMIN_EMAIL /run/secrets/credentials | cut -d'=' -f2)
DB_PASSWORD=$(cat /run/secrets/db_password)

#waiaintig for maridb
echo "Waiting for MariaDB to be ready..."
until mysql -h"${WORDPRESS_DB_HOST%:*}" -u"${WORDPRESS_DB_USER}" -p"${DB_PASSWORD}" -e "SELECT 1" &>/dev/null; do
	sleep 2
done
echo "MariaDB is ready!!"

cd /var/www/html

#if wordpress missing install it
if [ ! -f wp-config.php ]; then
	echo "Installing Wordpress..."

	wp core download --allow-root

	wp config create \
		--dbname="${WORDPRESS_DB_NAME}" \
		--dbuser="${WORDPRESS_DB_USER}" \
		--dbpass="${DB_PASSWORD}" \
		--dbhost="${WORDPRESS_DB_HOST}" \
		--allow-root

	wp core install \
		--url="https://${DOMAIN_NAME}" \
		--title="Inception Wordpress" \
		--admin_user="${WP_ADMIN_USER}" \
		--admin_password="${WP_ADMIN_PASSWORD}" \
		--admin_email="${WP_ADMIN_EMAIL}" \
		--allow-root

	wp user create wpuser2 user2@student.42.fr \
		--role=author \
		--user_pass="User2Pass123." \
		--allow-root

	echo "Wordpress installed successfully!"
fi

chown -R www-data:www-data /var/www/html

exec /usr/sbin/php-fpm8.2 -F
