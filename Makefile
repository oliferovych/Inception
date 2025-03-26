SECRETS_DIR = secrets
SRC_DIR = ./srcs

all: build up

build: check-docker
	@cd srcs/requirements && docker-compose build

up: check-docker
	@cd srcs/requirements && docker-compose up -d

down: check-docker
	@cd srcs/requirements && docker-compose down

re: check-docker down up

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