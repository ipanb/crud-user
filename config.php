<?php
// Konfigurasi database
$host = getenv('DB_HOST') ?: 'db';
$dbname = getenv('DB_NAME') ?: 'crud_user';
$username = getenv('DB_USER') ?: 'root';
$password = getenv('DB_PASS') ?: 'rootpassword';

try {
    $pdo = new PDO("mysql:host=$host;dbname=$dbname", $username, $password);
    $pdo->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
    $pdo->setAttribute(PDO::ATTR_DEFAULT_FETCH_MODE, PDO::FETCH_ASSOC);
} catch(PDOException $e) {
    die("Koneksi database gagal: " . $e->getMessage());
}
?>
