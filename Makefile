SECRETS_DIR = ./secrets
SRC_DIR = ./srcs

ENV_FILE = $(SRC_DIR)/.env
ENV_CHECKER = $(SRC_DIR)/requirements/tools/env_check.sh

DOCKER_COMPOSE = docker-compose -f srcs/docker-compose.yml -p inception

BOLD		=	\033[1;39m
BG			=	\033[4;39m
DEF			=	\033[0;39m
NO_COLOR	=	\033[0m
GRAY		=	\033[0;90m
RED			=	\033[0;91m
GREEN		=	\033[0;92m
YELLOW		=	\033[0;93m
BLUE		=	\033[0;94m
MAGENTA		=	\033[0;95m
CYAN		=	\033[0;96m
WHITE		=	\033[0;97m

all: build up

build: check-docker
	@if [ -z "$$(docker ps -q)" ]; then \
        echo "$(BOLD)$(YELLOW)Building containers...$(DEF)"; \
        $(DOCKER_COMPOSE) build; \
    else \
        echo "$(BOLD)$(GREEN)Containers are already built. Skipping build step.$(DEF)"; \
    fi

up: check-docker
	@$(DOCKER_COMPOSE) up -d

down: stop
	@$(DOCKER_COMPOSE) down

stop:
	@docker stop -t 0 nginx && echo " - $(BG)$(GREEN)stopped$(DEF)" || true
	@docker stop -t 0 mariadb && echo " - $(BG)$(GREEN)stopped$(DEF)" || true
	@docker stop -t 0 wordpress && echo " - $(BG)$(GREEN)stopped$(DEF)" || true
	@docker stop -t 0 adminer && echo " - $(BG)$(GREEN)stopped$(DEF)" || true
	@docker stop -t 0 redis && echo " - $(BG)$(GREEN)stopped$(DEF)" || true
	@docker stop -t 0 ftp_serv && echo " - $(BG)$(GREEN)stopped$(DEF)" || true

clean: stop
	@$(DOCKER_COMPOSE) down -v --remove-orphans
	docker builder prune --force
	docker volume prune --force
	docker network prune --force

check-docker:
	@docker info > /dev/null 2>&1 || { \
		echo "$(BOLD)$(RED)Docker is not running. Please start Docker Desktop.$(DEF)"; \
		exit 1; \
	}
	@bash $(ENV_CHECKER) $(ENV_FILE) || { \
		echo "$(BOLD)$(RED)Environment variables are not set correctly.$(DEF)"; \
		exit 1; \
	}
	@echo ""

re: down build check-docker up

reconstruct: clean build check-docker up

help:
	@echo "Usage: make [target]"
	@echo ""
	@echo "Targets:"
	@echo "  $(BOLD)all       $(DEF)- Run up"
	@echo "  $(BOLD)build     $(DEF)- Build the containers"
	@echo "  $(BOLD)up        $(DEF)- Run up"
	@echo "  $(BOLD)down      $(DEF)- Run down"
	@echo "  $(BOLD)stop      $(DEF)- Stop the containers"
	@echo "  $(BOLD)re        $(DEF)- Rebuild the containers"
	@echo "  $(BOLD)reconstruct$(DEF)- Fully rebuild the containers and volumes"
	@echo "  $(BOLD)clean     $(DEF)- Clean up the containers and volumes"
	@echo "  $(BOLD)help      $(DEF)- Show this help"

.PHONY: all build up down stop re clean help