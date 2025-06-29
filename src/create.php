<?php
require_once 'functions.php';

$errors = [];

if ($_SERVER['REQUEST_METHOD'] == 'POST') {
    // Ambil dan bersihkan input
    $nama = sanitizeInput($_POST['nama']);
    $no_telepon = sanitizeInput($_POST['no_telepon']);
    $email = sanitizeInput($_POST['email']);
    $alamat = sanitizeInput($_POST['alamat']);
    
    // Validasi
    if (empty($nama)) {
        $errors[] = "Nama tidak boleh kosong";
    }
    
    if (empty($alamat)) {
        $errors[] = "Alamat tidak boleh kosong";
    }
    
    // Jika tidak ada error, simpan data
    if (empty($errors)) {
        $data = [
            'nama' => $nama,
            'no_telepon' => $no_telepon,
            'email' => $email,
            'alamat' => $alamat
        ];
        
        if (createUser($pdo, $data)) {
            setMessage('success', 'User berhasil ditambahkan!');
            header('Location: index.php');
            exit;
        } else {
            $errors[] = "Terjadi kesalahan saat menyimpan data";
        }
    }
}

require_once 'header.php';
?>

<div class="row justify-content-center">
    <div class="col-md-8">
        <div class="card">
            <div class="card-header bg-success text-white">
                <h5 class="mb-0">
                    <i class="fas fa-user-plus me-2"></i>Tambah User Baru
                </h5>
            </div>
            <div class="card-body">
                <?php if (!empty($errors)): ?>
                    <div class="alert alert-danger">
                        <i class="fas fa-exclamation-triangle me-2"></i>
                        <strong>Terjadi kesalahan:</strong>
                        <ul class="mb-0 mt-2">
                            <?php foreach ($errors as $error): ?>
                                <li><?= $error ?></li>
                            <?php endforeach; ?>
                        </ul>
                    </div>
                <?php endif; ?>
                
                <form method="POST" novalidate>
                    <div class="row">
                        <div class="col-md-6">
                            <div class="mb-3">
                                <label for="nama" class="form-label">
                                    <i class="fas fa-user me-1"></i>Nama Lengkap
                                </label>
                                <input type="text" 
                                       class="form-control <?= in_array('Nama tidak boleh kosong', $errors) ? 'is-invalid' : '' ?>" 
                                       id="nama" 
                                       name="nama" 
                                       value="<?= isset($_POST['nama']) ? htmlspecialchars($_POST['nama']) : '' ?>" 
                                       placeholder="Masukkan nama lengkap"
                                       required>
                            </div>
                        </div>
                        <div class="col-md-6">
                            <div class="mb-3">
                                <label for="no_telepon" class="form-label">
                                    <i class="fas fa-phone me-1"></i>Nomor Telepon
                                </label>
                                <input type="tel" 
                                       class="form-control <?= in_array('Nomor telepon tidak boleh kosong', $errors) || in_array('Format nomor telepon tidak valid', $errors) ? 'is-invalid' : '' ?>" 
                                       id="no_telepon" 
                                       name="no_telepon" 
                                       value="<?= isset($_POST['no_telepon']) ? htmlspecialchars($_POST['no_telepon']) : '' ?>" 
                                       placeholder="Contoh: 08123456789"
                                       required>
                            </div>
                        </div>
                    </div>
                    
                    <div class="mb-3">
                        <label for="email" class="form-label">
                            <i class="fas fa-envelope me-1"></i>Email
                        </label>
                        <input type="email" 
                               class="form-control <?= in_array('Email tidak boleh kosong', $errors) || in_array('Format email tidak valid', $errors) || in_array('Email sudah digunakan', $errors) ? 'is-invalid' : '' ?>" 
                               id="email" 
                               name="email" 
                               value="<?= isset($_POST['email']) ? htmlspecialchars($_POST['email']) : '' ?>" 
                               placeholder="Contoh: user@example.com"
                               required>
                    </div>
                    
                    <div class="mb-3">
                        <label for="alamat" class="form-label">
                            <i class="fas fa-map-marker-alt me-1"></i>Alamat
                        </label>
                        <textarea class="form-control <?= in_array('Alamat tidak boleh kosong', $errors) ? 'is-invalid' : '' ?>" 
                                  id="alamat" 
                                  name="alamat" 
                                  rows="3" 
                                  placeholder="Masukkan alamat lengkap"
                                  required><?= isset($_POST['alamat']) ? htmlspecialchars($_POST['alamat']) : '' ?></textarea>
                    </div>
                    
                    <div class="d-flex justify-content-between">
                        <a href="index.php" class="btn btn-secondary">
                            <i class="fas fa-arrow-left me-1"></i>Kembali
                        </a>
                        <button type="submit" class="btn btn-success">
                            <i class="fas fa-save me-1"></i>Simpan User
                        </button>
                    </div>
                </form>
            </div>
        </div>
    </div>
</div>

<?php require_once 'footer.php'; ?>
