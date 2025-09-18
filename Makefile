NAME = inception
DC = docker-compose -f srcs/docker-compose.yml

all: up

up:
	mkdir -p /home/msoklova/data/db
	mkdir -p /home/msoklova/data/wp
	$(DC) up -d --build

down:
	$(DC) down

clean:
	$(DC) down -v

fclean: clean
	docker system prune -af --volumes

re: fclean up

.PHONY: all up down clean fclean re
