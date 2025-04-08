FROM debian:bullseye

RUN apt-get update && apt-get install -y \
	redis-server \
	&& rm -rf /var/lib/apt/lists/*

COPY redis.conf /etc/redis/redis.conf

RUN mkdir -p /data/log && chown redis:redis /data/log
RUN chmod 755 /data

CMD ["redis-server", "/etc/redis/redis.conf" , "--protected-mode", "no"]