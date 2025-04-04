#!bin/bash

set -e

REQUIRED_SECRETS=(
    "/run/secrets/wp_db_password"
    "/run/secrets/wp_admin_password"
    "/run/secrets/wp_user_password"
)

#check for secrets
for secret in ${REQUIRED_SECRETS[@]}; do
	if [ ! -f $secret ]; then
		echo "Secret $secret is missing!"
		exit 1
	elif [ ! -s "$secret" ]; then
        echo "Error: Secret file $secret is empty."
        exit 1
    fi
done

# set env vars from secrets
export WORDPRESS_DB_PASSWORD=$(cat /run/secrets/wp_db_password)
export WORDPRESS_ADMIN_PASSWORD=$(cat /run/secrets/wp_admin_password)
export WORDPRESS_USER_PASSWORD=$(cat /run/secrets/wp_user_password)

echo ${DOMAIN}
echo ${WORDPRESS_DB_HOST}
echo ${WORDPRESS_DB_USER}
echo ${WORDPRESS_DB_PASSWORD}
echo ${WORDPRESS_DB_NAME}
echo ${WORDPRESS_ADMIN_USER}
echo ${WORDPRESS_ADMIN_PASSWORD}
echo ${WORDPRESS_USER}
echo ${WORDPRESS_USER_PASSWORD}

cd /var/www/html


if [ -f /var/www/html/wp-config.php ]; then
    echo "Wordpress already downloaded!"
else
    wp core download \
        --allow-root \
        --quiet
    echo "Configuring Wordpress..."
    wp config create \
        --dbname=$WORDPRESS_DB_NAME \
        --dbuser=$WORDPRESS_DB_USER \
        --dbpass=$WORDPRESS_DB_PASSWORD \
        --dbhost=$WORDPRESS_DB_HOST \
        --allow-root \
        --quiet

    echo "Config completed!"

    wp core install \
        --url=$DOMAIN \
        --title="Inception" \
        --admin_user=$WORDPRESS_ADMIN_USER \
        --admin_password=$WORDPRESS_ADMIN_PASSWORD \
        --admin_email=$WORDPRESS_ADMIN_EMAIL \
        --skip-email \
        --allow-root \
        --quiet

    echo "Wordpress core installed, admin created!"
fi

wp user create \
    $WORDPRESS_USER \
    $WORDPRESS_USER_EMAIL \
    --role=author \
    --user_pass=$WORDPRESS_USER_PASSWORD \
    --allow-root \
    --quiet

echo "User $WORDPRESS_USER created!"

if [ -f /var/www/html/index.html ]; then
    echo "Removing default index.html..."
    rm /var/www/html/index.html
fi

# echo "Checking database connection..."
# while ! wp_dbadmin ping -h"$WORDPRESS_WP_DB_HOST" --silent; do
#     echo "Waiting for database..."
#     sleep 2
# done
# echo "Database is reachable!"

chown -R www-data:www-data /var/www/html
chmod -R 755 /var/www/html

echo "Starting PHP-FPM..."
exec php-fpm7.4 -F