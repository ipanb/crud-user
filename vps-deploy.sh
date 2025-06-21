#!/bin/bash

# VPS Deployment Script for CRUD User Application
# This script handles complete setup from scratch on a fresh VPS

echo "🚀 VPS Deployment Script for CRUD User"
echo "======================================="

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${GREEN}✅ $1${NC}"
}

print_info() {
    echo -e "${BLUE}ℹ️  $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}⚠️  $1${NC}"
}

print_error() {
    echo -e "${RED}❌ $1${NC}"
}

# Check if running as root
if [ "$EUID" -eq 0 ]; then
    print_warning "Running as root. This script will create a new user for Docker."
    
    # Create new user for Docker
    read -p "Enter username for Docker user (default: dockeruser): " USERNAME
    USERNAME=${USERNAME:-dockeruser}
    
    if id "$USERNAME" &>/dev/null; then
        print_info "User $USERNAME already exists"
    else
        useradd -m -s /bin/bash $USERNAME
        usermod -aG sudo $USERNAME
        print_status "Created user: $USERNAME"
    fi
    
    # Copy this script to user home and continue as that user
    cp "$0" /home/$USERNAME/
    chown $USERNAME:$USERNAME /home/$USERNAME/$(basename "$0")
    print_info "Switching to user $USERNAME..."
    exec sudo -u $USERNAME /home/$USERNAME/$(basename "$0")
fi

# Update system
print_info "Updating system packages..."
sudo apt-get update -y

# Install Docker if not present
if ! command -v docker > /dev/null 2>&1; then
    print_info "Installing Docker..."
    curl -fsSL https://get.docker.com -o get-docker.sh
    sudo sh get-docker.sh
    sudo usermod -aG docker $USER
    print_status "Docker installed successfully"
else
    print_status "Docker is already installed"
fi

# Install Docker Compose if not present
if ! docker compose version > /dev/null 2>&1 && ! command -v docker-compose > /dev/null 2>&1; then
    print_info "Installing Docker Compose..."
    sudo apt-get install docker-compose-plugin -y
    print_status "Docker Compose installed successfully"
else
    print_status "Docker Compose is already available"
fi

# Start Docker service
print_info "Starting Docker service..."
sudo systemctl start docker
sudo systemctl enable docker

# Install Git if not present
if ! command -v git > /dev/null 2>&1; then
    print_info "Installing Git..."
    sudo apt-get install git -y
    print_status "Git installed successfully"
fi

# Install other useful tools
print_info "Installing additional tools..."
sudo apt-get install -y curl wget unzip htop

# Setup firewall (if ufw is available)
if command -v ufw > /dev/null 2>&1; then
    print_info "Configuring firewall..."
    sudo ufw allow ssh
    sudo ufw allow 80/tcp
    sudo ufw allow 443/tcp
    sudo ufw allow 8080/tcp
    sudo ufw --force enable
    print_status "Firewall configured"
fi

# Clone or setup application
APP_DIR="$HOME/crud-user"
if [ ! -d "$APP_DIR" ]; then
    print_info "Setting up application directory..."
    mkdir -p $APP_DIR
    
    # If this script is part of the application, copy everything
    if [ -f "docker-compose.yml" ]; then
        cp -r . $APP_DIR/
        print_status "Application files copied"
    else
        print_warning "Please upload your application files to $APP_DIR"
        exit 1
    fi
else
    print_info "Application directory already exists"
fi

cd $APP_DIR

# Setup environment file
if [ ! -f .env ]; then
    print_info "Creating .env file..."
    cp .env.example .env
    
    # Generate random password for production
    RANDOM_PASS=$(openssl rand -base64 32)
    sed -i "s/DB_PASS=rootpassword/DB_PASS=$RANDOM_PASS/" .env
    print_status ".env file created with secure password"
fi

# Deploy application
print_info "Deploying application..."
chmod +x deploy.sh
./deploy.sh

# Setup reverse proxy (optional)
setup_nginx_proxy() {
    print_info "Setting up Nginx reverse proxy..."
    
    # Install Nginx
    sudo apt-get install nginx -y
    
    # Create Nginx config
    sudo tee /etc/nginx/sites-available/crud-user > /dev/null <<EOF
server {
    listen 80;
    server_name _;
    
    location / {
        proxy_pass http://localhost:8080;
        proxy_set_header Host \$host;
        proxy_set_header X-Real-IP \$remote_addr;
        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto \$scheme;
    }
}
EOF
    
    # Enable site
    sudo ln -sf /etc/nginx/sites-available/crud-user /etc/nginx/sites-enabled/
    sudo rm -f /etc/nginx/sites-enabled/default
    
    # Test and restart Nginx
    sudo nginx -t && sudo systemctl restart nginx
    sudo systemctl enable nginx
    
    print_status "Nginx reverse proxy configured"
}

# Ask if user wants reverse proxy
read -p "Setup Nginx reverse proxy for port 80? (y/N): " SETUP_PROXY
if [[ $SETUP_PROXY =~ ^[Yy]$ ]]; then
    setup_nginx_proxy
fi

# Display final information
print_status "VPS Deployment completed successfully!"
echo ""
echo "================================================"
echo "           🎉 Deployment Summary"
echo "================================================"

# Get server IP
SERVER_IP=$(curl -s ifconfig.me 2>/dev/null || curl -s ipinfo.io/ip 2>/dev/null || echo "YOUR_SERVER_IP")

echo "🌐 Access URLs:"
if [[ $SETUP_PROXY =~ ^[Yy]$ ]]; then
    echo "   - Main App: http://$SERVER_IP"
    echo "   - Direct:   http://$SERVER_IP:8080"
else
    echo "   - Main App: http://$SERVER_IP:8080"
fi
echo "   - phpMyAdmin: http://$SERVER_IP:8081"
echo ""
echo "📊 Database Info:"
echo "   - Host: $SERVER_IP:3307"
echo "   - Database: crud_user"
echo "   - Username: root"
echo "   - Password: (check .env file)"
echo ""
echo "🔧 Management Commands:"
echo "   - View logs: docker compose logs -f"
echo "   - Stop app:  docker compose down"
echo "   - Restart:   docker compose restart"
echo ""
print_warning "Make sure to secure your server and change default passwords!"
print_info "Application is now running on your VPS!"
