# CRUD User Management System

Aplikasi CRUD (Create, Read, Update, Delete) untuk manajemen user menggunakan PHP dan Bootstrap.

## Fitur
- Tambah user baru
- Lihat daftar user
- Edit data user
- Hapus user
- Validasi form
- Responsive design dengan Bootstrap
- Notifikasi dengan SweetAlert2

## Field User
- ID (Auto increment)
- Nama Lengkap
- Nomor Telepon
- Email (unique)
- Alamat

## Instalasi

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
   ├── bootstrap/          # Bootstrap CSS & JS
   ├── config.php          # Konfigurasi database
   ├── functions.php       # Fungsi-fungsi PHP
   ├── header.php          # Header template
   ├── footer.php          # Footer template
   ├── index.php           # Halaman utama (daftar user)
   ├── create.php          # Form tambah user
   ├── edit.php            # Form edit user
   ├── delete.php          # Proses hapus user
   ├── database.sql        # Schema database
   └── README.md           # Dokumentasi
   ```

## Cara Menggunakan

1. Akses `http://localhost/crud-user/` di browser
2. Gunakan tombol "Tambah User" untuk menambah user baru
3. Klik icon edit (kuning) untuk mengubah data user
4. Klik icon hapus (merah) untuk menghapus user

## Teknologi yang Digunakan

- **Backend**: PHP 7.4+
- **Database**: MySQL
- **Frontend**: Bootstrap 5.3
- **Icons**: Font Awesome 6
- **JavaScript**: SweetAlert2 untuk notifikasi

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
