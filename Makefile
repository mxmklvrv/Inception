NAME = inception

COMPOSE = docker compose -f srcs/docker-compose.yml

DATA_DIR = $(HOME)/data
DB_DATA = $(DATA_DIR)/mariadb
WP_DATA = $(DATA_DIR)/wordpress

.PHONY: all prep build up down logs ps clean fclean re

all: prep
	$(COMPOSE) up -d --build

prep:
	mkdir -p $(DB_DATA)
	mkdir -p $(WP_DATA)

build:
	$(COMPOSE) build

up:
	$(COMPOSE) up -d

down:
	$(COMPOSE) down

logs:
	$(COMPOSE) logs -f

ps:
	$(COMPOSE) ps

clean:
	$(COMPOSE) down -v --rmi local --remove-orphans

fclean: clean
	sudo rm -rf $(DB_DATA)
	sudo rm -rf $(WP_DATA)

re: fclean all