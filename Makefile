SECRETS_DIR = secrets
SRC_DIR = ./srcs

all: build up

build: check-docker
	@cd $(SRC_DIR)/requirements && docker-compose build

up: check-docker
	@cd $(SRC_DIR)/requirements && docker-compose up -d

down:
	@cd $(SRC_DIR)/requirements && docker-compose down

kill:
	docker stop -t 0 nginx
	docker stop -t 0 mariadb
	docker stop -t 0 wordpress
	$(MAKE) down

re: check-docker kill build up

clean: check-docker
	docker builder prune --force
	@cd $(SRC_DIR)/requirements && docker-compose down --rmi all

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

.PHONY: all up down re help