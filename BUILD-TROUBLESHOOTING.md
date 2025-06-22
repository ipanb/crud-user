# 🔧 Docker Build Troubleshooting Guide

## Common Build Issues and Solutions

### 1. PHP Package Not Found in Alpine

**Error:**
```
RUN apk add --no-cache php81-xxx:
fetch https://dl-cdn.alpinelinux.org/alpine/v3.21/main/x86_64/APKINDEX.tar.gz
ERROR: unable to select packages: php81-xxx (no such package)
```

**Solutions:**

#### Option A: Use Updated Package Names
```dockerfile
# Use PHP 8.2 instead of 8.1
RUN apk add --no-cache \
    php82 \
    php82-fpm \
    php82-pdo \
    php82-pdo_mysql \
    # ... other packages
```

#### Option B: Use Alternative Dockerfile
```bash
# Use the alternative PHP official image
./build-selector.sh
# Select option 2
```

#### Option C: Check Available Packages
```bash
# Search for available PHP packages
docker run --rm alpine:latest apk search php82
```

### 2. Package Version Conflicts

**Error:**
```
ERROR: conflicts with package-name-version
```

**Solutions:**

#### Update Package Lists
```dockerfile
# Add package list update
RUN apk update && apk add --no-cache \
    php82 \
    # ... other packages
```

#### Use Specific Versions
```dockerfile
RUN apk add --no-cache \
    php82=8.2.x-rx \
    php82-fpm=8.2.x-rx
```

### 3. Permission Issues

**Error:**
```
permission denied while trying to connect to Docker daemon
```

**Solutions:**
```bash
# Add user to docker group
sudo usermod -aG docker $USER

# Logout and login again, or:
newgrp docker

# Or use sudo
sudo docker-compose up --build -d
```

### 4. Disk Space Issues

**Error:**
```
no space left on device
```

**Solutions:**
```bash
# Clean up Docker
docker system prune -a

# Remove unused volumes
docker volume prune

# Check disk space
df -h
```

### 5. Network Issues

**Error:**
```
failed to fetch package from repository
```

**Solutions:**
```bash
# Check internet connection
ping google.com

# Try different DNS
echo "nameserver 8.8.8.8" | sudo tee /etc/resolv.conf

# Use different mirror
docker run --rm alpine:latest sh -c "echo 'http://dl-cdn.alpinelinux.org/alpine/v3.21/main' > /etc/apk/repositories"
```

## Build Configuration Options

### 1. Standard Alpine Configuration
```bash
# Use default Dockerfile
docker-compose up --build -d
```

### 2. Alternative PHP Official Image
```bash
# Use alternative Dockerfile
docker-compose up --build -d -f docker-compose.yml --build-arg DOCKERFILE=Dockerfile.alternative
```

### 3. Interactive Build Selector
```bash
# Use build selector script
chmod +x build-selector.sh
./build-selector.sh
```

### 4. Manual Dockerfile Selection
```bash
# Build with specific Dockerfile
docker build -f Dockerfile.alternative -t crud-user-app .
```

## Package Compatibility Matrix

| Alpine Version | PHP Version | Available Packages |
|----------------|-------------|-------------------|
| 3.21 | 8.2 | php82, php82-fpm, php82-pdo, etc. |
| 3.20 | 8.2 | php82, php82-fpm, php82-pdo, etc. |
| 3.19 | 8.1 | php81, php81-fpm, php81-pdo, etc. |

## Debugging Commands

### Check Package Availability
```bash
# List available PHP packages
docker run --rm alpine:latest apk search php

# Check specific package
docker run --rm alpine:latest apk info php82-pdo
```

### Test Build Steps
```bash
# Test individual RUN commands
docker run --rm -it alpine:latest sh
apk add --no-cache php82

# Check PHP installation
php -v
php -m
```

### View Build Logs
```bash
# Build with verbose output
docker-compose up --build --no-deps app

# View detailed build logs
docker build --no-cache --progress=plain .
```

## Alternative Solutions

### 1. Use Multi-Stage Build
```dockerfile
FROM php:8.2-fpm-alpine as php-base
RUN docker-php-ext-install pdo_mysql

FROM nginx:alpine
COPY --from=php-base /usr/local/bin/php /usr/local/bin/
COPY --from=php-base /usr/local/lib/php /usr/local/lib/
```

### 2. Use Docker Hub Pre-built Images
```dockerfile
FROM webdevops/php-nginx:8.2-alpine
COPY . /app
```

### 3. Use Ubuntu Base Instead of Alpine
```dockerfile
FROM ubuntu:22.04
RUN apt-get update && apt-get install -y \
    nginx \
    php8.2 \
    php8.2-fpm \
    php8.2-mysql
```

## Getting Help

If none of these solutions work:

1. **Check Docker Community**: https://forums.docker.com/
2. **Alpine Package Database**: https://pkgs.alpinelinux.org/
3. **PHP Docker Images**: https://hub.docker.com/_/php
4. **Report Issue**: Create issue with full error log

## Quick Fix Commands

```bash
# Emergency fallback - use simple setup
docker run -d -p 8080:80 -v $(pwd):/var/www/html php:8.2-apache

# Or use existing LAMP stack
docker run -d -p 8080:80 -p 3306:3306 -v $(pwd):/var/www/html mattrayner/lamp:latest
```
