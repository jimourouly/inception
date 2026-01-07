COMPOSE_FILE = srcs/Docker-compose.yml
DATA_PATH = /home/jroulet/data

all:build up
 
build:
	@echo "Building Docker images..."
	docker-compose -f $(COMPOSE_FILE) build

up:
	@echo "Starting containers..."
	@mkdir -p $(DATA_PATH)/mariadb
	@mdkir -p $(DATA_PATH)/wordpress
	docker-compose -f $(COMPOSE_FILE) up -d

down:
	@echo "Stopping containers..."
	docker-compose -f $(COMPOSE_FILE) down

start:
	@echo "Starting containers..."
	docker-compose -f $(COMPOSE_FILE) start

stop:
	@echo "Stopping containers..."
	dockcer-compose -f $(COMPOSE_FILE) stop

restart: stop start

logs: docker-compose -f $(COMPOSE_FILE) logs -f

ps: docker-compose -f $(COMPOSE_FILE) ps

clean: down
	@echo "cleanning containers and images..."
	docker system prune -af

fclean: clean
	@echo "removung volumes..."
	docker volume rm srcs_mariadb_data srcs_wordpress_data 2>/dev/null || true
	@sudo rm -rf $(DATA_PATH)/mariadb/*
	@sudo rm -rf $(DATA_PATH)/wordpress/*

re: fclean all

.PHONY: all build up down start stop restart logs ps clean fclean re
