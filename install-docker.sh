#!/bin/bash

# Docker Installation Script for VPS
# Supports Ubuntu, Debian, CentOS, and RHEL

echo "🐳 Docker Installation Script for VPS"
echo "====================================="

# Function to detect OS
detect_os() {
    if [ -f /etc/os-release ]; then
        . /etc/os-release
        OS=$NAME
        VER=$VERSION_ID
    else
        echo "❌ Cannot detect OS version"
        exit 1
    fi
}

# Detect operating system
detect_os
echo "📋 Detected OS: $OS $VER"

# Install Docker based on OS
install_docker() {
    case "$OS" in
        "Ubuntu"*)
            echo "🔧 Installing Docker on Ubuntu..."
            sudo apt-get update
            sudo apt-get install -y apt-transport-https ca-certificates curl gnupg lsb-release
            
            # Add Docker's official GPG key
            curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
            
            # Add Docker repository
            echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
            
            # Install Docker
            sudo apt-get update
            sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin
            ;;
            
        "Debian"*)
            echo "🔧 Installing Docker on Debian..."
            sudo apt-get update
            sudo apt-get install -y apt-transport-https ca-certificates curl gnupg lsb-release
            
            # Add Docker's official GPG key
            curl -fsSL https://download.docker.com/linux/debian/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
            
            # Add Docker repository
            echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/debian $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
            
            # Install Docker
            sudo apt-get update
            sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin
            ;;
            
        "CentOS"*|"Red Hat"*)
            echo "🔧 Installing Docker on CentOS/RHEL..."
            sudo yum install -y yum-utils
            sudo yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
            sudo yum install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin
            ;;
            
        *)
            echo "❌ Unsupported OS: $OS"
            echo "Please install Docker manually: https://docs.docker.com/engine/install/"
            exit 1
            ;;
    esac
}

# Check if Docker is already installed
if command -v docker > /dev/null 2>&1; then
    echo "✅ Docker is already installed"
    docker --version
else
    echo "📦 Docker not found. Installing..."
    install_docker
fi

# Start and enable Docker service
echo "🚀 Starting Docker service..."
sudo systemctl start docker
sudo systemctl enable docker

# Add current user to docker group
echo "👤 Adding user to docker group..."
sudo usermod -aG docker $USER

# Verify installation
echo "🔍 Verifying Docker installation..."
sudo docker run hello-world

# Check Docker Compose
echo "🔍 Checking Docker Compose..."
if docker compose version > /dev/null 2>&1; then
    echo "✅ Docker Compose (plugin) is available"
    docker compose version
elif command -v docker-compose > /dev/null 2>&1; then
    echo "✅ Docker Compose (standalone) is available"
    docker-compose --version
else
    echo "📦 Installing Docker Compose standalone..."
    DOCKER_COMPOSE_VERSION=$(curl -s https://api.github.com/repos/docker/compose/releases/latest | grep 'tag_name' | cut -d\" -f4)
    sudo curl -L "https://github.com/docker/compose/releases/download/${DOCKER_COMPOSE_VERSION}/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
    sudo chmod +x /usr/local/bin/docker-compose
    docker-compose --version
fi

echo ""
echo "✅ Docker installation completed!"
echo ""
echo "⚠️  IMPORTANT: Please logout and login again to use Docker without sudo"
echo "   Or run: newgrp docker"
echo ""
echo "🚀 You can now run: ./deploy.sh"
