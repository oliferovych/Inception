FROM debian:bullseye

RUN apt-get update && apt-get install -y nginx && \
    rm -rf /var/lib/apt/lists/*

COPY config/config.conf /etc/nginx/nginx.conf

COPY config/index.html /etc/nginx/html/index.html

COPY certs/fullchain.pem /etc/nginx/ssl/fullchain.pem
COPY certs/privkey.pem /etc/nginx/ssl/privkey.pem

RUN chmod 600 /etc/nginx/ssl/privkey.pem

EXPOSE 443

CMD ["nginx", "-g", "daemon off;"]