FROM debian:bullseye

RUN apt-get update && apt-get install -y \
	vsftpd \
	&& rm -rf /var/lib/apt/lists/*

COPY config/vsftpd.conf /etc/vsftpd/vsftpd.conf
COPY entry.sh entry.sh
RUN chmod +x entry.sh

RUN mkdir -p /var/run/vsftpd/empty
RUN chmod 777 /var/run/vsftpd/empty

ENTRYPOINT [ "/entry.sh" ]
