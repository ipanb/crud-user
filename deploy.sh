#!/bin/bash

# Script untuk deploy aplikasi PHP dengan Docker
# Pastikan script ini executable: chmod +x deploy.sh

echo "🚀 Starting deployment process..."

# Warna untuk output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Function untuk print dengan warna
print_status() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Cek apakah Docker sudah terinstall
if ! command -v docker &> /dev/null; then
    print_error "Docker belum terinstall. Silakan install Docker terlebih dahulu."
    exit 1
fi

# Cek apakah Docker Compose sudah terinstall
if ! command -v docker-compose &> /dev/null; then
    print_error "Docker Compose belum terinstall. Silakan install Docker Compose terlebih dahulu."
    exit 1
fi

# Membuat direktori yang diperlukan
print_status "Membuat direktori yang diperlukan..."
mkdir -p nginx mysql php ssl src

# Cek apakah file aplikasi ada di direktori src
if [ ! -f "src/index.php" ]; then
    print_warning "File aplikasi tidak ditemukan di direktori src/"
    print_warning "Pastikan untuk memindahkan file aplikasi PHP Anda ke direktori src/"
    
    # Membuat file index.php contoh
    cat > src/index.php << 'EOF'
<?php
echo "<h1>Hello World!</h1>";
echo "<p>PHP Version: " . phpversion() . "</p>";

// Test database connection
$host = 'mysql';
$dbname = 'app_database';
$username = 'app_user';
$password = 'app_password_123';

try {
    $pdo = new PDO("mysql:host=$host;dbname=$dbname", $username, $password);
    echo "<p style='color: green;'>Database connection: SUCCESS</p>";
} catch(PDOException $e) {
    echo "<p style='color: red;'>Database connection: FAILED - " . $e->getMessage() . "</p>";
}
?>
EOF
    print_status "File index.php contoh telah dibuat di src/"
fi

# Cek apakah ada file .env atau config database
if [ -f "src/.env" ] || [ -f "src/config.php" ]; then
    print_warning "Jangan lupa update konfigurasi database di aplikasi Anda:"
    print_warning "Host: mysql (nama container)"
    print_warning "Database: app_database"
    print_warning "Username: app_user"
    print_warning "Password: app_password_123"
fi

# Stop container yang sedang berjalan (jika ada)
print_status "Menghentikan container yang sedang berjalan..."
docker-compose down

# Build dan start container
print_status "Building dan starting containers..."
docker-compose up -d --build

# Cek status container
print_status "Checking container status..."
sleep 10
docker-compose ps

# Cek apakah container berjalan dengan baik
if [ "$(docker-compose ps -q | wc -l)" -eq 4 ]; then
    print_status "✅ Semua container berhasil dijalankan!"
    echo ""
    echo "🌐 Aplikasi dapat diakses di:"
    echo "   - Website: http://localhost atau http://your-server-ip"
    echo "   - phpMyAdmin: http://localhost:8080 atau http://your-server-ip:8080"
    echo ""
    echo "📋 Informasi Database:"
    echo "   - Host: mysql"
    echo "   - Database: app_database"
    echo "   - Username: app_user"
    echo "   - Password: app_password_123"
    echo ""
    echo "🔧 Useful commands:"
    echo "   - Lihat logs: docker-compose logs -f"
    echo "   - Stop semua: docker-compose down"
    echo "   - Restart: docker-compose restart"
    echo "   - Update: docker-compose up -d --build"
else
    print_error "❌ Beberapa container gagal dijalankan. Cek logs dengan: docker-compose logs"
fi

# Menampilkan resource usage
print_status "Container resource usage:"
docker stats --no-stream --format "table {{.Container}}\t{{.CPUPerc}}\t{{.MemUsage}}"