# 🚀 VPS Quick Deployment Guide

## Method 1: One-Line Deployment (Recommended)

```bash
# Download and run VPS deployment script
curl -fsSL https://raw.githubusercontent.com/your-repo/crud-user/main/vps-deploy.sh | bash
```

## Method 2: Manual Step-by-Step

### 1. Install Docker
```bash
# Run Docker installation script
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh
sudo usermod -aG docker $USER

# Install Docker Compose
sudo apt-get install docker-compose-plugin -y

# Start Docker
sudo systemctl start docker
sudo systemctl enable docker
```

### 2. Upload Application Files
```bash
# Option A: Using git (if you have a repository)
git clone https://github.com/your-repo/crud-user.git
cd crud-user

# Option B: Using scp to upload files
scp -r crud-user/ user@your-server-ip:/home/user/

# Option C: Using wget/curl (if files are hosted)
wget -O crud-user.zip https://your-domain.com/crud-user.zip
unzip crud-user.zip
cd crud-user
```

### 3. Deploy Application
```bash
# Make scripts executable
chmod +x deploy.sh install-docker.sh vps-deploy.sh

# Run deployment
./deploy.sh

# Or use make
make setup
```

## Method 3: Docker Installation Only

If you just need to install Docker on your VPS:

```bash
# Download and run Docker installation script
curl -fsSL https://raw.githubusercontent.com/your-repo/crud-user/main/install-docker.sh | bash

# Logout and login again to use Docker without sudo
exit
# SSH back to your server
```

## Common VPS Commands

### After Deployment
```bash
# Check application status
docker compose ps

# View logs
docker compose logs -f

# Stop application
docker compose down

# Restart application
docker compose restart

# Update application
git pull  # if using git
docker compose up --build -d
```

### System Management
```bash
# Check system resources
htop
df -h
free -m

# Check Docker status
sudo systemctl status docker

# Check open ports
sudo netstat -tlnp
```

### Firewall Configuration
```bash
# Enable firewall
sudo ufw enable

# Allow necessary ports
sudo ufw allow ssh
sudo ufw allow 80/tcp
sudo ufw allow 443/tcp
sudo ufw allow 8080/tcp

# Check firewall status
sudo ufw status
```

## Troubleshooting VPS Issues

### 1. "docker-compose not found"
```bash
# Install Docker Compose plugin
sudo apt-get install docker-compose-plugin

# Or install standalone version
sudo curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
```

### 2. "Permission denied" errors
```bash
# Add user to docker group
sudo usermod -aG docker $USER

# Logout and login again, or:
newgrp docker
```

### 3. "Port already in use"
```bash
# Check what's using the port
sudo netstat -tlnp | grep :8080

# Kill the process or change port in docker-compose.yml
```

### 4. "Cannot connect to Docker daemon"
```bash
# Start Docker service
sudo systemctl start docker

# Check Docker status
sudo systemctl status docker
```

### 5. Low disk space
```bash
# Clean up Docker images and containers
docker system prune -a

# Remove unused volumes
docker volume prune
```

## Production Considerations

### Security
- Change default passwords in `.env`
- Setup SSL certificate (Let's Encrypt)
- Configure proper firewall rules
- Regular security updates
- Use non-root user for deployment

### Performance
- Monitor resource usage
- Setup log rotation
- Regular database backups
- Consider using Docker swarm for scaling

### Backup
```bash
# Backup database
docker compose exec db mysqldump -u root -p crud_user > backup_$(date +%Y%m%d).sql

# Backup application files
tar -czf crud-user-backup-$(date +%Y%m%d).tar.gz crud-user/
```

### SSL Setup with Let's Encrypt
```bash
# Install certbot
sudo apt-get install certbot python3-certbot-nginx

# Get SSL certificate
sudo certbot --nginx -d your-domain.com

# Auto-renewal
sudo crontab -e
# Add line: 0 12 * * * /usr/bin/certbot renew --quiet
```
