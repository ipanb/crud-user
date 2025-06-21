# CRUD User Management System

Aplikasi CRUD (Create, Read, Update, Delete) untuk manajemen user menggunakan PHP dan Bootstrap dengan support Docker.

## Fitur
- Tambah user baru
- Lihat daftar user
- Edit data user
- Hapus user
- Validasi form
- Responsive design dengan Bootstrap
- Notifikasi dengan SweetAlert2
- Docker support dengan Nginx

## Field User
- ID (Auto increment)
- Nama Lengkap
- Nomor Telepon
- Email (unique)
- Alamat

## 🐳 Instalasi dengan Docker (Recommended)

### Prerequisites
- Docker Desktop
- Docker Compose

### Quick Start
1. **Clone atau download project ini**
2. **Jalankan deployment script:**
   
   **Windows:**
   ```cmd
   deploy.bat
   ```
   
   **Linux/Mac:**
   ```bash
   chmod +x deploy.sh
   ./deploy.sh
   ```

3. **Akses aplikasi:**
   - Main App: http://localhost:8080
   - phpMyAdmin: http://localhost:8081

📖 **Dokumentasi Docker lengkap**: [DOCKER.md](DOCKER.md)

### Manual Docker Setup
```bash
# Build dan jalankan containers
docker-compose up --build -d

# Lihat logs
docker-compose logs -f

# Stop containers
docker-compose down
```

## 📝 Instalasi Manual (Tanpa Docker)

1. **Setup Database**
   - Buat database MySQL dengan nama `crud_user`
   - Import file `database.sql` untuk membuat tabel dan data contoh

2. **Konfigurasi Database**
   - Edit file `config.php` sesuai dengan setting database Anda:
   ```php
   $host = 'localhost';
   $dbname = 'crud_user';
   $username = 'root';
   $password = '';
   ```

3. **Struktur File**
   ```
   crud-user/
   ├── bootstrap/              # Bootstrap CSS & JS
   ├── docker/                 # Docker configuration
   │   └── nginx/
   │       └── default.conf    # Nginx configuration
   ├── config.php              # Konfigurasi database
   ├── functions.php           # Fungsi-fungsi PHP
   ├── header.php              # Header template
   ├── footer.php              # Footer template
   ├── index.php               # Halaman utama (daftar user)
   ├── create.php              # Form tambah user
   ├── edit.php                # Form edit user
   ├── delete.php              # Proses hapus user
   ├── database.sql            # Schema database
   ├── Dockerfile              # Docker configuration
   ├── docker-compose.yml      # Docker Compose configuration
   ├── deploy.sh               # Deployment script (Linux/Mac)
   ├── deploy.bat              # Deployment script (Windows)
   ├── .env.example            # Environment variables example
   └── README.md               # Dokumentasi
   ```

## 🐳 Docker Services

- **app**: PHP 8.2-FPM + Nginx web server
- **db**: MySQL 8.0 database
- **phpmyadmin**: Database management interface

## Cara Menggunakan

1. Akses aplikasi di `http://localhost:8080`
2. Gunakan tombol "Tambah User" untuk menambah user baru
3. Klik icon edit (kuning) untuk mengubah data user
4. Klik icon hapus (merah) untuk menghapus user
5. Akses phpMyAdmin di `http://localhost:8081` untuk manajemen database

## Teknologi yang Digunakan

- **Backend**: PHP 8.2-FPM
- **Web Server**: Nginx
- **Database**: MySQL 8.0
- **Frontend**: Bootstrap 5.3
- **Icons**: Font Awesome 6
- **JavaScript**: SweetAlert2 untuk notifikasi
- **Containerization**: Docker & Docker Compose

## 🔧 Docker Configuration

### Services Configuration
- **App Container**: Port 8080 (Nginx + PHP-FPM)
- **Database Container**: Port 3307 (MySQL)
- **phpMyAdmin Container**: Port 8081

### Environment Variables
Buat file `.env` dari `.env.example` dan sesuaikan:
```env
DB_HOST=db
DB_NAME=crud_user
DB_USER=root
DB_PASS=rootpassword
```

## Fitur Keamanan

- Validasi input di sisi server
- Sanitasi data dengan `htmlspecialchars()`
- Prepared statements untuk mencegah SQL injection
- Validasi email dan nomor telepon

## Screenshots

### Halaman Utama
Menampilkan daftar semua user dalam bentuk tabel yang responsive.

### Form Tambah/Edit User
Form yang user-friendly dengan validasi real-time.

### Konfirmasi Hapus
Dialog konfirmasi dengan SweetAlert2 sebelum menghapus data.

## Kontribusi

Silakan buat pull request atau laporkan bug melalui issues.

## Lisensi

MIT License
