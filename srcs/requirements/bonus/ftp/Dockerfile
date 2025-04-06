FROM debian:bullseye

RUN apt-get update && apt-get install -y \
	vsftpd \
	&& rm -rf /var/lib/apt/lists/*

COPY config/vsftpd.conf /etc/vsftpd/vsftpd.conf
COPY entry.sh entry.sh
RUN chmod +x entry.sh

ENTRYPOINT [ "/entry.sh" ]
