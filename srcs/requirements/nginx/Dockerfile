FROM debian:bullseye

RUN apt-get update && apt-get install -y nginx openssl \
&& rm -rf /var/lib/apt/lists/*

RUN mkdir -p /etc/nginx/ssl
RUN openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
	-keyout /etc/nginx/ssl/msoklova.42.fr.key \
	-out /etc/nginx/ssl/msoklova.42.fr.crt \
	-subj "/C=DE/ST=Baden-Württemberg/L=Heilbronn/O=42Heilbronn/OU=Heilb/CN=msoklova.42.fr"

COPY tools/default.config /etc/nginx/sites-available/default
RUN ln -sf /etc/nginx/sites-available/default /etc/nginx/sites-enabled/default

EXPOSE 443
CMD ["nginx", "-g", "daemon off;"]
