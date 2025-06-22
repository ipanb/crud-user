#!/bin/bash

# Docker Build Selector Script
# Allows choosing between different Dockerfile configurations

echo "🐳 Docker Build Configuration Selector"
echo "======================================"

echo "Available Docker configurations:"
echo "1. Standard (Alpine + PHP 8.2) - Recommended"
echo "2. Alternative (Official PHP image) - Fallback if Alpine fails"
echo "3. Custom build"

read -p "Select configuration (1-3) [1]: " CHOICE
CHOICE=${CHOICE:-1}

case $CHOICE in
    1)
        echo "🔧 Using standard Alpine configuration..."
        DOCKERFILE="Dockerfile"
        ;;
    2)
        echo "🔧 Using alternative PHP official image..."
        DOCKERFILE="Dockerfile.alternative"
        ;;
    3)
        echo "🔧 Enter custom Dockerfile name:"
        read -p "Dockerfile name: " DOCKERFILE
        if [ ! -f "$DOCKERFILE" ]; then
            echo "❌ File $DOCKERFILE not found!"
            exit 1
        fi
        ;;
    *)
        echo "❌ Invalid choice. Using default configuration."
        DOCKERFILE="Dockerfile"
        ;;
esac

echo "📋 Selected: $DOCKERFILE"

# Function to detect docker compose command
detect_docker_compose() {
    if command -v docker-compose > /dev/null 2>&1; then
        echo "docker-compose"
    elif docker compose version > /dev/null 2>&1; then
        echo "docker compose"
    else
        return 1
    fi
}

DOCKER_COMPOSE=$(detect_docker_compose)
if [ $? -ne 0 ]; then
    echo "❌ Docker Compose not found!"
    exit 1
fi

# Create .env if not exists
if [ ! -f .env ]; then
    echo "📝 Creating .env file..."
    cp .env.example .env
fi

# Build with selected Dockerfile
echo "🔨 Building with $DOCKERFILE..."

# Update docker-compose.yml to use selected Dockerfile
if [ "$DOCKERFILE" != "Dockerfile" ]; then
    # Create temporary docker-compose file
    sed "s|build: \.|build:\n      context: .\n      dockerfile: $DOCKERFILE|" docker-compose.yml > docker-compose.temp.yml
    echo "🔄 Using temporary docker-compose configuration..."
    $DOCKER_COMPOSE -f docker-compose.temp.yml down > /dev/null 2>&1
    $DOCKER_COMPOSE -f docker-compose.temp.yml up --build -d
    rm docker-compose.temp.yml
else
    $DOCKER_COMPOSE down > /dev/null 2>&1
    $DOCKER_COMPOSE up --build -d
fi

if [ $? -eq 0 ]; then
    echo "✅ Build successful!"
    echo ""
    echo "🌐 Access your application:"
    echo "   - Main App: http://localhost:8080"
    echo ""
    echo "🔧 Management commands:"
    echo "   - View logs: $DOCKER_COMPOSE logs -f"
    echo "   - Stop: $DOCKER_COMPOSE down"
else
    echo "❌ Build failed!"
    echo ""
    echo "💡 Troubleshooting tips:"
    echo "   1. Try alternative configuration: ./build-selector.sh"
    echo "   2. Check Docker logs: $DOCKER_COMPOSE logs"
    echo "   3. Verify Docker is running: docker info"
fi
