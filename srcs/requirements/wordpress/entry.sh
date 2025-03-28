#!bin/bash

set -e

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
export WORDPRESS_DB_HOST=$(cat /run/secrets/wp_db_host)
export WORDPRESS_DB_USER=$(cat /run/secrets/wp_db_user)
export WORDPRESS_DB_PASSWORD=$(cat /run/secrets/wp_db_password)
export WORDPRESS_DB_NAME=$(cat /run/secrets/wp_db_name)

echo ${WORDPRESS_DB_HOST}
echo ${WORDPRESS_DB_USER}
echo ${WORDPRESS_DB_PASSWORD}
echo ${WORDPRESS_DB_NAME}

# echo "Checking database connection..."
# while ! wp_dbadmin ping -h"$WORDPRESS_DB_HOST" --silent; do
#     echo "Waiting for database..."
#     sleep 2
# done
# echo "Database is reachable!"


echo "Starting PHP-FPM..."
exec php-fpm7.4 -F