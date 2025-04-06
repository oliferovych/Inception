FROM debian:bullseye

RUN apt-get update && apt-get upgrade -y && apt-get install -y \
    mariadb-server \
    gettext-base \
    && rm -rf /var/lib/apt/lists/*

COPY config/config.cnf /etc/mysql/mariadb.conf.d/50-server.cnf
RUN chmod 664 /etc/mysql/mariadb.conf.d/50-server.cnf

RUN mkdir /run/mysqld

COPY tools/init_db.sql /etc/mysql/init_db.sql
COPY tools/entry.sh entry.sh
RUN chmod +x entry.sh

ENTRYPOINT [ "/entry.sh" ]