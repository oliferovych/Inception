FROM debian:bullseye

RUN apt-get update && apt-get install -y \
    mariadb-server \
    && rm -rf /var/lib/apt/lists/*

# ENV MYSQL_ROOT_PASSWORD=Jesuis42
# ENV MYSQL_DATABASE=wordpress
# ENV MYSQL_USER=wp_user
# ENV MYSQL_PASSWORD=Jesuis42

EXPOSE 3306