<?php
session_start();
function connectDatabase()
{
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
    return $pdo;
}


// Fungsi untuk mengambil semua user
function getAllUsers($pdo)
{
    $stmt = $pdo->query("SELECT * FROM users ORDER BY id DESC LIMIT 5000");
    return $stmt;
}

// Fungsi untuk mengambil user berdasarkan ID
function getUserById($pdo, $id)
{
    $stmt = $pdo->prepare("SELECT * FROM users WHERE id = ?");
    $stmt->execute([$id]);
    return $stmt->fetch();
}

// Fungsi untuk menambah user baru
function createUser($pdo, $data)
{
    $stmt = $pdo->prepare("INSERT INTO users (nama, no_telepon, email, alamat) VALUES (?, ?, ?, ?)");
    return $stmt->execute([$data['nama'], $data['no_telepon'], $data['email'], $data['alamat']]);
}

// Fungsi untuk mengupdate user
function updateUser($pdo, $id, $data)
{
    $stmt = $pdo->prepare("UPDATE users SET nama = ?, no_telepon = ?, email = ?, alamat = ? WHERE id = ?");
    return $stmt->execute([$data['nama'], $data['no_telepon'], $data['email'], $data['alamat'], $id]);
}

// Fungsi untuk menghapus user
function deleteUser($pdo, $id)
{
    $stmt = $pdo->prepare("DELETE FROM users WHERE id = ?");
    return $stmt->execute([$id]);
}

// Fungsi untuk validasi email
function isValidEmail($email)
{
    return filter_var($email, FILTER_VALIDATE_EMAIL);
}

// Fungsi untuk mengecek apakah email sudah ada (kecuali untuk user yang sedang diedit)
function isEmailExists($pdo, $email, $excludeId = null)
{
    if ($excludeId) {
        $stmt = $pdo->prepare("SELECT COUNT(*) FROM users WHERE email = ? AND id != ?");
        $stmt->execute([$email, $excludeId]);
    } else {
        $stmt = $pdo->prepare("SELECT COUNT(*) FROM users WHERE email = ?");
        $stmt->execute([$email]);
    }
    return $stmt->fetchColumn() > 0;
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
