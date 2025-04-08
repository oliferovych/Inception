FROM debian:bullseye

RUN apt-get update && apt-get install -y \
	busybox \
	&& rm -rf /var/lib/apt/lists/*

COPY /config /var/www/html

EXPOSE 8081

CMD ["busybox", "httpd", "-f", "-v", "-p", "8081", "-h", "/var/www/html"]