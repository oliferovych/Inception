FROM debian:bullseye

RUN apt-get update && apt-get install -y \
    wordpress \
    php-fpm \
    && rm -rf /var/lib/apt/lists/*

EXPOSE 9000