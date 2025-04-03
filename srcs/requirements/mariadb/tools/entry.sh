#!/bin/bash

set -e

REQUIRED_SECRETS=(
    "/run/secrets/mysql_root_password"
    "/run/secrets/mysql_password"
)

for secret in ${REQUIRED_SECRETS[@]}; do
	if [ ! -f $secret ]; then
		echo "Secret $secret is missing!"
		exit 1
	elif [ ! -s "$secret" ]; then
        echo "Error: Secret file $secret is empty."
        exit 1
    fi
done

export MYSQL_PASSWORD=$(cat /run/secrets/mysql_password)
export MYSQL_ROOT_PASSWORD=$(cat /run/secrets/mysql_root_password)

echo ${MYSQL_DATABASE}
echo ${MYSQL_USER}
echo ${MYSQL_PASSWORD}
echo ${MYSQL_ROOT_PASSWORD}

envsubst < /etc/mysql/init_db.sql > /etc/mysql/tmp.sql
mv /etc/mysql/tmp.sql /etc/mysql/init_db.sql

mysqld