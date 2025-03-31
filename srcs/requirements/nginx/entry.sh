#!/bin/bash

set -e

REQUIRED_SECRETS=(
	"/run/secrets/nginx_db_name"
	"/run/secrets/nginx_db_user"
	"/run/secrets/nginx_db_password"
	"/run/secrets/nginx_db_host"
	"/run/secrets/nginx_domain"
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
export DB_HOST=$(cat /run/secrets/nginx_db_host)
export DB_NAME=$(cat /run/secrets/nginx_db_name)
export DB_USER=$(cat /run/secrets/nginx_db_user)
export DB_PASSWORD=$(cat /run/secrets/nginx_db_password)
export DOMAIN=$(cat /run/secrets/nginx_domain)

echo ${DOMAIN}
echo ${DB_HOST}
echo ${DB_NAME}
echo ${DB_USER}
echo ${DB_PASSWORD}

whoami

# echo "Checking database connection..."
# while ! mysqladmin ping -h"$DB_HOST" --silent; do
# 	echo "Waiting for database..."
# 	sleep 2
# done
# echo "Database is reachable!"

envsubst '${DOMAIN}' < /etc/nginx/nginx.conf > /etc/nginx/sites-available/nginx.conf
# mv /etc/nginx/sites-available/default.tmp /etc/nginx/sites-available/default

openssl req \
			-x509 \
			-nodes \
			-days 365 \
			-newkey rsa:2048 \
			-keyout /etc/ssl/private/nginx-selfsigned.key \
			-out /etc/ssl/certs/nginx-selfsigned.crt \
			-subj "/C=DE/ST=BW/O=42HN/CN=$DOMAIN"

nginx -t

echo "Starting Nginx..."
exec nginx -g 'daemon off;'


