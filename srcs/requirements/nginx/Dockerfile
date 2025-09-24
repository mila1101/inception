FROM debian:bookworm

RUN apt-get update && apt-get install -y nginx openssl curl \
	&& rm -rf /var/lib/apt/lists/*

RUN mkdir -p /etc/nginx/ssl

RUN openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
	-keyout /etc/nginx/ssl/msoklova.42.fr.key \
	-out /etc/nginx/ssl/msoklova.42.fr.crt \
	-subj "/C=DE/ST=BW/L=Heilbronn/O=42/CN=msoklova.42.fr"

COPY tools/default.config /etc/nginx/sites-available/default

EXPOSE 443

CMD ["nginx", "-g", "daemon off;"]