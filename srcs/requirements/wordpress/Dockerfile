FROM debian:bullseye

RUN apt-get update && apt-get install -y \
	php-fpm php-cli php-mysql curl \
	default-mysql-client \
&& rm -rf /var/lib/apt/lists/*

RUN sed -i 's|^listen = .*|listen = 0.0.0.0:9000|' /etc/php/7.4/fpm/pool.d/www.conf \
&& mkdir -p /run/php /var/www/html

RUN curl -fsSL https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar \
	-o /usr/local/bin/wp && chmod +x /usr/local/bin/wp

COPY tools/entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

WORKDIR /var/www/html
EXPOSE 9000
ENTRYPOINT ["/entrypoint.sh"]
