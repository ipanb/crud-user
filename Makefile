# Makefile for CRUD User Docker Management

.PHONY: help build up down restart logs clean

# Default target
help: ## Show this help message
	@echo "CRUD User Docker Management"
	@echo "=========================="
	@echo "Available commands:"
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {printf "  %-12s %s\n", $$1, $$2}' $(MAKEFILE_LIST)

build: ## Build and start containers
	@echo "🔨 Building and starting containers..."
	@docker-compose up --build -d
	@echo "✅ Containers started successfully!"

up: ## Start containers (without build)
	@echo "🚀 Starting containers..."
	@docker-compose up -d
	@echo "✅ Containers started!"

down: ## Stop and remove containers
	@echo "⏹️ Stopping containers..."
	@docker-compose down
	@echo "✅ Containers stopped!"

restart: ## Restart containers
	@echo "🔄 Restarting containers..."
	@docker-compose restart
	@echo "✅ Containers restarted!"

logs: ## Show container logs
	@docker-compose logs -f

logs-app: ## Show app container logs
	@docker-compose logs -f app

logs-db: ## Show database container logs
	@docker-compose logs -f db

status: ## Show container status
	@docker-compose ps

shell-app: ## Access app container shell
	@docker-compose exec app sh

shell-db: ## Access database shell
	@docker-compose exec db mysql -u root -prootpassword crud_user

clean: ## Stop containers and remove volumes
	@echo "🧹 Cleaning up containers and volumes..."
	@docker-compose down -v
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
	@echo "   - phpMyAdmin: http://localhost:8081"

deploy: setup ## Full deployment (alias for setup)

dev: ## Start development environment
	@echo "🛠️ Starting development environment..."
	@docker-compose -f docker-compose.yml -f docker-compose.override.yml up --build -d
	@echo "✅ Development environment ready!"
