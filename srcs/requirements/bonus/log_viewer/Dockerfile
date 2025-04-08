FROM debian:bullseye

RUN apt-get update && apt-get install -y \
	ccze \
	&& rm -rf /var/lib/apt/lists/*

CMD ["sh", "-c", "tail -f /var/log/nginx/error.log /var/log/nginx/access.log /var/lib/mysql/database.log /data/log/redis-server.log /var/log/vsftpd/vsftpd.log | ccze -A"]