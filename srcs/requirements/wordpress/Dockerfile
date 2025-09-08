FROM debian:bullseye

RUN apt-get update && apt-get install -y \
    php-fpm php-cli php-mysql \
 && rm -rf /var/lib/apt/lists/*

RUN sed -i 's|^listen = .*|listen = 0.0.0.0:9000|' /etc/php/7.4/fpm/pool.d/www.conf \
 && mkdir -p /run/php /var/www/html

WORKDIR /var/www/html
EXPOSE 9000

CMD ["/usr/sbin/php-fpm7.4","-F"]
