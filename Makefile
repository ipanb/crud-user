# Makefile for CRUD User Docker Management

# Detect docker compose command
DOCKER_COMPOSE := $(shell which docker-compose 2>/dev/null)
ifndef DOCKER_COMPOSE
	DOCKER_COMPOSE := docker compose
endif

.PHONY: help build up down restart logs clean

# Default target
help: ## Show this help message
	@echo "CRUD User Docker Management"
	@echo "=========================="
	@echo "Using: $(DOCKER_COMPOSE)"
	@echo "Available commands:"
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {printf "  %-12s %s\n", $$1, $$2}' $(MAKEFILE_LIST)

build: ## Build and start containers
	@echo "🔨 Building and starting containers..."
	@$(DOCKER_COMPOSE) up --build -d
	@echo "✅ Containers started successfully!"

up: ## Start containers (without build)
	@echo "🚀 Starting containers..."
	@$(DOCKER_COMPOSE) up -d
	@echo "✅ Containers started!"

down: ## Stop and remove containers
	@echo "⏹️ Stopping containers..."
	@$(DOCKER_COMPOSE) down
	@echo "✅ Containers stopped!"

restart: ## Restart containers
	@echo "🔄 Restarting containers..."
	@$(DOCKER_COMPOSE) restart
	@echo "✅ Containers restarted!"

logs: ## Show container logs
	@$(DOCKER_COMPOSE) logs -f

logs-app: ## Show app container logs
	@$(DOCKER_COMPOSE) logs -f app

logs-db: ## Show database container logs
	@$(DOCKER_COMPOSE) logs -f db

status: ## Show container status
	@$(DOCKER_COMPOSE) ps

shell-app: ## Access app container shell
	@$(DOCKER_COMPOSE) exec app sh

shell-db: ## Access database shell
	@$(DOCKER_COMPOSE) exec db mysql -u root -prootpassword crud_user

clean: ## Stop containers and remove volumes
	@echo "🧹 Cleaning up containers and volumes..."
	@$(DOCKER_COMPOSE) down -v
	@docker system prune -f
	@echo "✅ Cleanup completed!"

setup: ## Initial setup (copy .env and build)
	@echo "📝 Setting up project..."
	@cp -n .env.example .env 2>/dev/null || true
	@make build
	@echo "✅ Setup completed!"
	@echo ""
	@echo "🌐 Access your application:"
	@echo "   - Main App: http://localhost:8080"
	@echo ""
	@echo "🗄️ Database access:"
	@echo "   - Command: make shell-db"

deploy: setup ## Full deployment (alias for setup)

dev: ## Start development environment
	@echo "🛠️ Starting development environment..."
	@$(DOCKER_COMPOSE) -f docker-compose.yml -f docker-compose.override.yml up --build -d
	@echo "✅ Development environment ready!"
