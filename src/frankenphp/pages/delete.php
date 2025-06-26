<?php
// Cek apakah ID ada
if (!isset($_GET['id']) || empty($_GET['id'])) {
    setMessage('danger', 'ID user tidak valid');
    header('Location: index.php');
    exit;
}

$id = (int)$_GET['id'];
$user = getUserById($pdo, $id);

// Cek apakah user ditemukan
if (!$user) {
    setMessage('danger', 'User tidak ditemukan');
    header('Location: index.php');
    exit;
}

// Hapus user
if (deleteUser($pdo, $id)) {
    setMessage('success', "User '{$user['nama']}' berhasil dihapus!");
} else {
    setMessage('danger', 'Terjadi kesalahan saat menghapus user');
}

header('Location: index.php');
exit;
?>
