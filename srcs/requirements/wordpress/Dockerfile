FROM debian:bullseye

RUN apt-get update && apt-get install -y \
    wordpress \
    php7.4-fpm \
    php7.4-mysql \
    && rm -rf /var/lib/apt/lists/*

RUN mkdir /run/php

COPY www.conf /etc/php/7.4/fpm/pool.d/www.conf

EXPOSE 9000

CMD [ "php-fpm7.4", "-F" ]