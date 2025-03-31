SECRETS_DIR = secrets
SRC_DIR = ./srcs

all: up

build: check-docker
	@cd $(SRC_DIR)/requirements && docker-compose build

up: check-docker
	@cd $(SRC_DIR)/requirements && docker-compose up -d

down: stop
	@cd $(SRC_DIR)/requirements && docker-compose down

stop:
	docker stop -t 0 nginx
	docker stop -t 0 mariadb
	docker stop -t 0 wordpress

re: check-docker down build up

clean: check-docker stop
	$(MAKE) down
	docker builder prune --force
	docker volume prune --force
	docker network prune --force

check-docker:
	@docker info > /dev/null 2>&1 || { \
		echo "Docker is not running. Please start Docker Desktop."; \
		exit 1; \
	}

help:
	@echo "Usage: make [target]"
	@echo ""
	@echo "Targets:"
	@echo "  all       - Run up"
	@echo "  up        - Run up"
	@echo "  down      - Run down"
	@echo "  re        - Run down and up"
	@echo "  help      - Show this help"

.PHONY: all up down stop re help