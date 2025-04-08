#!/bin/bash

set -e

REQUIRED_SECRETS=(
    "/run/secrets/ftp_password"
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

export FTP_PASSWORD=$(cat /run/secrets/ftp_password)

echo ${FTP_USER}
echo ${FTP_PASSWORD}
echo ${DOMAIN}

if id "$FTP_USER" &>/dev/null; then
    echo "User $FTP_USER already exists."
else
    echo "Creating user $FTP_USER..."
    useradd -m -d /home/$FTP_USER $FTP_USER
    echo "$FTP_USER:$FTP_PASSWORD" | chpasswd
    chown -R $FTP_USER:$FTP_USER /home/$FTP_USER
    chown -R $FTP_USER:$FTP_USER /var/www/html
fi

mkdir -p /var/run/vsftpd/empty
chmod 755 /var/run/vsftpd/empty

mkdir -p /var/log/vsftpd
touch /var/log/vsftpd/vsftpd.log
chmod 755 /var/log/vsftpd /var/log/vsftpd/vsftpd.log

echo "pasv_address=${DOMAIN}" >> /etc/vsftpd/vsftpd.conf

echo "Starting vsftpd server..."
vsftpd /etc/vsftpd/vsftpd.conf