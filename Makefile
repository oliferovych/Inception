SECRETS_DIR = secrets
SRC_DIR = ./srcs

all: up

up:
	cd srcs/requirements && docker-compose up -d

down:
	cd srcs/requirements && docker-compose down

re:
	cd srcs/requirements && docker-compose down
	cd srcs/requirements && docker-compose up -d

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