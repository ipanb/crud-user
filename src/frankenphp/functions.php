<?php
session_start();
function connectDatabase()
{
    global $pdo;
    if (isset($pdo)) {
        return $pdo; // Jika sudah ada koneksi, kembalikan yang sudah ada
    }
    $host = 'mysql';  // Nama container MySQL
    $dbname = 'app_database';
    $username = 'app_user';
    $password = 'app_password_123';

    try {
        $pdo = new PDO("mysql:host=$host;dbname=$dbname", $username, $password);
        $pdo->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
        $pdo->setAttribute(PDO::ATTR_DEFAULT_FETCH_MODE, PDO::FETCH_ASSOC);
    } catch (PDOException $e) {
        die("Koneksi database gagal: " . $e->getMessage());
    }
}


// Fungsi untuk mengambil semua user
function getAllUsers()
{
    global $pdo;
    if (!isset($pdo)) {
        connectDatabase();
    }
    $stmt = $pdo->query("SELECT * FROM users ORDER BY id DESC LIMIT 5000");
    return $stmt;
}

// Fungsi untuk mengambil user berdasarkan ID
function getUserById($id)
{
    global $pdo;
    if (!isset($pdo)) {
        connectDatabase();
    }
    $stmt = $pdo->prepare("SELECT * FROM users WHERE id = ?");
    $stmt->execute([$id]);
    return $stmt->fetch();
}

// Fungsi untuk menambah user baru
function createUser($data)
{
    global $pdo;
    if (!isset($pdo)) {
        connectDatabase();
    }
    $stmt = $pdo->prepare("INSERT INTO users (nama, no_telepon, email, alamat) VALUES (?, ?, ?, ?)");
    return $stmt->execute([$data['nama'], $data['no_telepon'], $data['email'], $data['alamat']]);
}

// Fungsi untuk mengupdate user
function updateUser($id, $data)
{
    global $pdo;
    if (!isset($pdo)) {
        connectDatabase();
    }
    $stmt = $pdo->prepare("UPDATE users SET nama = ?, no_telepon = ?, email = ?, alamat = ? WHERE id = ?");
    return $stmt->execute([$data['nama'], $data['no_telepon'], $data['email'], $data['alamat'], $id]);
}

// Fungsi untuk menghapus user
function deleteUser($id)
{
    global $pdo;
    if (!isset($pdo)) {
        connectDatabase();
    }
    $stmt = $pdo->prepare("DELETE FROM users WHERE id = ?");
    return $stmt->execute([$id]);
}


// Fungsi untuk validasi nomor telepon
function isValidPhone($phone)
{
    return preg_match('/^[0-9+\-\s]+$/', $phone) && strlen(trim($phone)) >= 10;
}

// Fungsi untuk membersihkan input
function sanitizeInput($input)
{
    return htmlspecialchars(trim($input), ENT_QUOTES, 'UTF-8');
}

// Fungsi untuk set pesan session
function setMessage($type, $text)
{
    $_SESSION['message'] = [
        'type' => $type,
        'text' => $text
    ];
}
