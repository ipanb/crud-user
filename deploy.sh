#!/bin/bash

# CRUD User Docker Deployment Script

echo "🚀 Starting CRUD User Application Deployment..."

# Check if Docker is running
if ! docker info > /dev/null 2>&1; then
    echo "❌ Docker is not running. Please start Docker first."
    exit 1
fi

# Create .env file if not exists
if [ ! -f .env ]; then
    echo "📝 Creating .env file..."
    cp .env.example .env
fi

# Build and start containers
echo "🔨 Building and starting containers..."
docker-compose up --build -d

# Wait for MySQL to be ready
echo "⏳ Waiting for MySQL to be ready..."
sleep 30

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
echo "   - View logs: docker-compose logs -f"
echo "   - Stop: docker-compose down"
echo "   - Restart: docker-compose restart"
