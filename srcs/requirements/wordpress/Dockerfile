FROM debian:bullseye

RUN apt-get update && apt-get install -y \
    php7.4-fpm \
    php7.4-mysql \
    php7.4-phar \
    curl \
    && rm -rf /var/lib/apt/lists/*

RUN mkdir /run/php

RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar && \
    chmod +x wp-cli.phar && \
    mv wp-cli.phar /usr/local/bin/wp

COPY www.conf /etc/php/7.4/fpm/pool.d/www.conf
COPY entry.sh entry.sh
RUN chmod +x entry.sh

ENTRYPOINT [ "/entry.sh" ]