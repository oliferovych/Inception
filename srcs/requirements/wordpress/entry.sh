#!bin/bash

# set -e

REQUIRED_SECRETS=(
    "/run/secrets/wp_db_host"
    "/run/secrets/wp_db_user"
    "/run/secrets/wp_db_password"
    "/run/secrets/wp_db_name"
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
export DB_HOST=$(cat /run/secrets/wp_db_host)
export DB_USER=$(cat /run/secrets/wp_db_user)
export DB_PASSWORD=$(cat /run/secrets/wp_db_password)
export DB_NAME=$(cat /run/secrets/wp_db_name)

echo ${DB_HOST}
echo ${DB_USER}
echo ${DB_PASSWORD}
echo ${DB_NAME}

# chown -R www-data:www-data /usr/share/wordpress
# chmod -R 755 /usr/share/wordpress
# chown -R www-data:www-data /var/www/html
# cp -r /usr/share/wordpress/* /var/www/html/

cd /var/www/html

wp core download \
    --allow-root \
    --quiet

if [ -f /var/www/html/wp-config.php ]; then
    echo "removing standard wp-config.php"
    rm /var/www/html/wp-config.php
else
    echo "Creating wp-config.php..."
fi

wp config create \
	--dbname=$DB_NAME \
	--dbuser=$DB_USER \
    --dbpass=$DB_PASSWORD \
	--dbhost=$DB_HOST \
	--allow-root \
	--quiet \
	# --prompt=dbpass < /run/secrets/wp_db_password

if [ -f /var/www/html/index.html ]; then
    echo "Removing default index.html..."
    rm /var/www/html/index.html
fi

# echo "Checking database connection..."
# while ! wp_dbadmin ping -h"$WORDPRESS_DB_HOST" --silent; do
#     echo "Waiting for database..."
#     sleep 2
# done
# echo "Database is reachable!"

# cat > /var/www/html/wp-config.php <<EOL
# <?php
# define('DB_NAME', getenv('DB_NAME') ?: '$DB_NAME');
# define('DB_USER', getenv('DB_USER') ?: '$DB_USER');
# define('DB_PASSWORD', getenv('DB_PASSWORD') ?: '$DB_PASSWORD');
# define('DB_HOST', getenv('DB_HOST') ?: '$DB_HOST');

# define('WP_DEBUG', getenv('WP_DEBUG') ?: false);

# if (!defined('ABSPATH'))
#     define('ABSPATH', __DIR__ . '/');

# require_once ABSPATH . 'wp-settings.php';
# ?>
# EOL

chown -R www-data:www-data /var/www/html
chmod -R 755 /var/www/html

echo "Starting PHP-FPM..."
exec php-fpm7.4 -F