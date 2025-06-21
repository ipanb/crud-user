#!/bin/bash

# CRUD User Docker Deployment Script

echo "🚀 Starting CRUD User Application Deployment..."

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

# Check if Docker is running
echo "📋 Checking Docker status..."
if ! docker info > /dev/null 2>&1; then
    echo "❌ Docker is not running. Please start Docker first."
    echo "💡 On VPS, try: sudo systemctl start docker"
    exit 1
fi
echo "✅ Docker is running"

# Detect Docker Compose
echo "📋 Detecting Docker Compose..."
DOCKER_COMPOSE=$(detect_docker_compose)
if [ $? -ne 0 ]; then
    echo "❌ Docker Compose not found!"
    echo "💡 Installing Docker Compose..."
    
    # Try to install Docker Compose
    if command -v apt-get > /dev/null 2>&1; then
        # Ubuntu/Debian
        sudo apt-get update
        sudo apt-get install -y docker-compose-plugin
        DOCKER_COMPOSE="docker compose"
    elif command -v yum > /dev/null 2>&1; then
        # CentOS/RHEL
        sudo yum install -y docker-compose
        DOCKER_COMPOSE="docker-compose"
    else
        echo "❌ Cannot auto-install Docker Compose."
        echo "Please install Docker Compose manually:"
        echo "  https://docs.docker.com/compose/install/"
        exit 1
    fi
fi
echo "✅ Using: $DOCKER_COMPOSE"

# Create .env file if not exists
if [ ! -f .env ]; then
    echo "📝 Creating .env file..."
    cp .env.example .env
    echo "✅ .env file created"
else
    echo "✅ .env file already exists"
fi

# Build and start containers
echo "🔨 Building and starting containers..."
echo "This may take a few minutes on first run..."
$DOCKER_COMPOSE down > /dev/null 2>&1
$DOCKER_COMPOSE up --build -d

# Check if deployment was successful
if [ $? -eq 0 ]; then
    echo "✅ Containers started successfully!"
else
    echo "❌ Failed to start containers!"
    echo "💡 Try checking logs: $DOCKER_COMPOSE logs"
    exit 1
fi

# Wait for MySQL to be ready
echo "⏳ Waiting for MySQL to be ready..."
sleep 30

# Check container status
echo "📊 Checking container status..."
$DOCKER_COMPOSE ps

echo ""
echo "✅ Deployment completed!"
echo ""
echo "🌐 Access your application:"
echo "   - Main App: http://localhost:8080"
echo "   - phpMyAdmin: http://localhost:8081"
echo ""
echo "📊 Database Information:"
echo "   - Host: localhost:3307"
echo "   - Database: crud_user"
echo "   - Username: root"
echo "   - Password: rootpassword"
echo ""
echo "🐳 Docker commands:"
echo "   - View logs: $DOCKER_COMPOSE logs -f"
echo "   - Stop: $DOCKER_COMPOSE down"
echo "   - Restart: $DOCKER_COMPOSE restart"
