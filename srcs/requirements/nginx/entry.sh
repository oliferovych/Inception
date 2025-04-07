#!/bin/bash

set -e

REQUIRED_SECRETS=(
	"/run/secrets/nginx_db_password"
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
export DB_PASSWORD=$(cat /run/secrets/nginx_db_password)

echo ${DOMAIN}
echo ${DB_HOST}
echo ${DB_NAME}
echo ${DB_USER}
echo ${DB_PASSWORD}


# echo "Checking database connection..."
# while ! mysqladmin ping -h"$DB_HOST" --silent; do
# 	echo "Waiting for database..."
# 	sleep 2
# done
# echo "Database is reachable!"

envsubst '${DOMAIN}' < /etc/nginx/nginx.conf > /etc/nginx.tmp
mv /etc/nginx.tmp /etc/nginx/nginx.conf
cp /etc/nginx/nginx.conf /etc/nginx/sites-available/nginx.conf

# cat /etc/nginx/nginx.conf

openssl req \
			-x509 \
			-nodes \
			-days 365 \
			-newkey rsa:2048 \
			-keyout /etc/ssl/private/nginx-selfsigned.key \
			-out /etc/ssl/certs/nginx-selfsigned.crt \
			-subj "/C=DE/ST=BW/O=42HN/CN=$DOMAIN"

nginx -t

chmod -R 755 /usr/share/nginx/html
chown -R $(whoami):$(whoami) /usr/share/nginx/html

echo "Starting Nginx..."
exec nginx -g 'daemon off;'


