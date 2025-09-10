FROM debian:bullseye

RUN apt-get update && apt-get install -y mariadb-server \
&& rm -rf /var/lib/apt/lists/*

COPY tools/entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

VOLUME ["/var/lib/mysql"]
EXPOSE 3306
CMD ["/entrypoint.sh"]
