FROM debian:bullseye

RUN apt-get update && apt-get install -y \
    nginx \
    openssl \
    gettext-base \
    && rm -rf /var/lib/apt/lists/*

COPY config/config.conf /etc/nginx/nginx.conf

COPY entry.sh entry.sh
RUN chmod +x entry.sh

EXPOSE 443

ENTRYPOINT [ "/entry.sh" ]
# CMD ["nginx", "-g", "daemon off;"]
#this is for nginx to run in the foreground