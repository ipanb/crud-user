# 🐳 Docker Deployment Guide

## Prerequisites
1. **Install Docker Desktop** dari https://www.docker.com/products/docker-desktop
2. **Start Docker Desktop** dan pastikan status "Engine running"

## Quick Deployment

### Windows
```cmd
# Jalankan script deployment
deploy.bat
```

### Linux/Mac
```bash
# Set permission dan jalankan script
chmod +x deploy.sh
./deploy.sh
```

## Manual Deployment

### 1. Setup Environment
```bash
# Copy environment file
cp .env.example .env

# Edit .env jika diperlukan (optional)
# nano .env
```

### 2. Build dan Start Containers
```bash
# Build dan jalankan semua services
docker-compose up --build -d

# Cek status containers
docker-compose ps

# Lihat logs
docker-compose logs -f
```

### 3. Akses Aplikasi
- **Main App**: http://localhost:8080
- **phpMyAdmin**: http://localhost:8081
  - Server: db
  - Username: root
  - Password: rootpassword

## Management Commands

### Container Management
```bash
# Stop all containers
docker-compose down

# Restart containers
docker-compose restart

# Rebuild containers
docker-compose up --build -d

# Remove all containers and volumes
docker-compose down -v
```

### Debugging
```bash
# Lihat logs aplikasi
docker-compose logs app

# Lihat logs database
docker-compose logs db

# Masuk ke container app
docker-compose exec app bash

# Masuk ke container database
docker-compose exec db mysql -u root -p
```

### Database Management
```bash
# Backup database
docker-compose exec db mysqldump -u root -prootpassword crud_user > backup.sql

# Restore database
docker-compose exec -T db mysql -u root -prootpassword crud_user < backup.sql
```

## Troubleshooting

### Docker tidak terinstall di VPS
```
Error: docker: command not found
```
**Solusi**: 
```bash
# Jalankan script instalasi Docker
chmod +x install-docker.sh
./install-docker.sh

# Atau install manual
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh
```

### Docker Compose tidak ditemukan
```
Error: docker-compose: command not found
```
**Solusi**: Script `deploy.sh` akan otomatis detect dan install Docker Compose, atau:
```bash
# Untuk Docker Compose plugin (recommended)
sudo apt-get install docker-compose-plugin

# Untuk Docker Compose standalone
sudo curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
```

### Permission denied di VPS
```
Error: permission denied while trying to connect to Docker daemon
```
**Solusi**:
```bash
# Tambah user ke docker group
sudo usermod -aG docker $USER

# Logout dan login kembali, atau:
newgrp docker

# Atau gunakan sudo
sudo docker-compose up -d
```

### Docker service tidak berjalan
```
Error: Cannot connect to the Docker daemon
```
**Solusi**:
```bash
# Start Docker service
sudo systemctl start docker

# Enable auto-start
sudo systemctl enable docker

# Check status
sudo systemctl status docker
```

### Port sudah digunakan
```
Error: bind: address already in use
```
**Solusi**: 
1. Ubah port di `docker-compose.yml`
2. Atau stop aplikasi yang menggunakan port tersebut

### Database connection error
```
Error: SQLSTATE[HY000] [2002] Connection refused
```
**Solusi**:
1. Tunggu beberapa saat sampai MySQL container ready
2. Restart containers: `docker-compose restart`

## Production Deployment

### Environment Variables
Edit `.env` untuk production:
```env
DB_HOST=db
DB_NAME=crud_user
DB_USER=cruduser
DB_PASS=your_secure_password

APP_ENV=production
APP_DEBUG=false
```

### Security Considerations
1. Ubah default passwords
2. Gunakan environment variables untuk semua credentials
3. Setup SSL/TLS untuk production
4. Configure firewall untuk container ports

## Custom Configuration

### Nginx Configuration
Edit `docker/nginx/default.conf` untuk custom Nginx settings

### PHP Configuration
Tambahkan custom PHP settings di `Dockerfile`:
```dockerfile
RUN echo "upload_max_filesize = 100M" >> /usr/local/etc/php/php.ini
RUN echo "post_max_size = 100M" >> /usr/local/etc/php/php.ini
```

### MySQL Configuration
Tambahkan custom MySQL config di `docker-compose.yml`:
```yaml
db:
  image: mysql:8.0
  command: --default-authentication-plugin=mysql_native_password
  # ... other config
```
