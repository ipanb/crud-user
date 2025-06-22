<?php
require_once 'functions.php';

// Ambil semua data user
$users = getAllUsers($pdo);

require_once 'header.php';
?>

<div class="row">
    <div class="col-12">
        <div class="card">
            <div class="card-header bg-primary text-white">
                <div class="row align-items-center">
                    <div class="col">
                        <h5 class="mb-0">
                            <i class="fas fa-users me-2"></i>Data User
                        </h5>
                    </div>
                    <div class="col-auto">
                        <a href="create.php" class="btn btn-light btn-sm">
                            <i class="fas fa-plus me-1"></i>Tambah User
                        </a>
                    </div>
                </div>
            </div>
            <div class="card-body">
                <?php if (empty($users)): ?>
                    <div class="text-center py-5">
                        <i class="fas fa-users fa-3x text-muted mb-3"></i>
                        <h5 class="text-muted">Belum ada data user</h5>
                        <p class="text-muted">Silakan tambah user baru untuk memulai</p>
                        <a href="create.php" class="btn btn-primary">
                            <i class="fas fa-plus me-1"></i>Tambah User Pertama
                        </a>
                    </div>
                <?php else: ?>
                    <div class="table-responsive">
                        <table class="table table-striped table-hover mb-0">
                            <thead>
                                <tr>
                                    <th style="width: 60px;">ID</th>
                                    <th>Nama</th>
                                    <th>No. Telepon</th>
                                    <th>Email</th>
                                    <th>Alamat</th>
                                    <th style="width: 120px;" class="text-center">Aksi</th>
                                </tr>
                            </thead>
                            <tbody>
                                <?php foreach ($users as $user): ?>
                                    <tr>
                                        <td><span class="badge bg-secondary"><?= $user['id'] ?></span></td>
                                        <td>
                                            <strong><?= htmlspecialchars($user['nama']) ?></strong>
                                        </td>
                                        <td>
                                            <i class="fas fa-phone text-muted me-1"></i>
                                            <?= htmlspecialchars($user['no_telepon']) ?>
                                        </td>
                                        <td>
                                            <i class="fas fa-envelope text-muted me-1"></i>
                                            <?= htmlspecialchars($user['email']) ?>
                                        </td>
                                        <td>
                                            <i class="fas fa-map-marker-alt text-muted me-1"></i>
                                            <?= htmlspecialchars($user['alamat']) ?>
                                        </td>
                                        <td class="text-center">
                                            <div class="btn-group" role="group">
                                                <a href="edit.php?id=<?= $user['id'] ?>" 
                                                   class="btn btn-warning btn-action" 
                                                   title="Edit">
                                                    <i class="fas fa-edit"></i>
                                                </a>
                                                <button onclick="confirmDelete(<?= $user['id'] ?>, '<?= htmlspecialchars($user['nama']) ?>')" 
                                                        class="btn btn-danger btn-action" 
                                                        title="Hapus">
                                                    <i class="fas fa-trash"></i>
                                                </button>
                                            </div>
                                        </td>
                                    </tr>
                                <?php endforeach; ?>
                            </tbody>
                        </table>
                    </div>
                    
                    <div class="card-footer bg-light">
                        <small class="text-muted">
                            <i class="fas fa-info-circle me-1"></i>
                            Total: <?= count($users) ?> user
                        </small>
                    </div>
                <?php endif; ?>
            </div>
        </div>
    </div>
</div>

<?php require_once 'footer.php'; ?>
