FROM debian:bullseye

RUN apt-get update && apt-get install -y nginx && rm -rf /var/lib/apt/lists/*

COPY tools/default.config /etc/nginx/sites-available/default
RUN ln -sf /etc/nginx/sites-available/default /etc/nginx/sites-enabled/default

EXPOSE 80
CMD ["nginx","-g","daemon off;"]
