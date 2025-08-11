<?php
// Cek apakah ID ada
// Ambil semua data user
if (!isset($_GET['id']) || empty($_GET['id'])) {
    setMessage('danger', 'ID user tidak valid');
    header('Location: index');
    exit;
}

$id = (int)$_GET['id'];
$user = getUserById($id);

// Cek apakah user ditemukan
if (!$user) {
    setMessage('danger', 'User tidak ditemukan');
    header('Location: index');
    exit;
}

// Hapus user
if (deleteUser($id)) {
    setMessage('success', "User '{$user['nama']}' berhasil dihapus!");
} else {
    setMessage('danger', 'Terjadi kesalahan saat menghapus user');
}
require_once 'header.php';
?>
<div class="row justify-content-center">
        <div>
            <a href="index.php" class="btn btn-primary">Kembali ke Daftar User</a>
        </div>
</div>

<?php require_once 'footer.php'; ?>
