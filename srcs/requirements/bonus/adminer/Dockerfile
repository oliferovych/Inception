FROM debian:bullseye

RUN apt-get update && apt-get install -y \
	curl \
	php \
	php-mysql \
	&& rm -rf /var/lib/apt/lists/*

RUN mkdir -p /var/www/html
RUN curl -L -o /var/www/html/index.php https://github.com/vrana/adminer/releases/download/v5.1.1/adminer-5.1.1.php
RUN chmod 644 /var/www/html/index.php

EXPOSE 8080

CMD ["php", "-S", "0.0.0.0:8080", "-t", "/var/www/html/"]