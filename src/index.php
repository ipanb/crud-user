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
                        <h5 class="mb-0">Data User</h5>
                    </div>
                    <div class="col-auto">
                        <a href="create.php" class="btn btn-light btn-sm">
                            Tambah User
                        </a>
                    </div>
                </div>
            </div>
            <div class="card-body">
                <?php if (empty($users)): ?>
                    <div class="text-center py-5">
                        <h5 class="text-muted">Belum ada data user</h5>
                        <p class="text-muted">Silakan tambah user baru untuk memulai</p>
                        <a href="create.php" class="btn btn-primary">
                            Tambah User Pertama
                        </a>
                    </div>
                <?php else: ?>
                    <div class="table-responsive">
                        <table id="dataTable" class="table table-striped table-hover mb-0">
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
                                <?php while ($user = $users->fetch()): ?>
                                    <tr>
                                        <td><span class="badge bg-secondary"><?= $user['id'] ?></span></td>
                                        <td>
                                            <strong><?= htmlspecialchars($user['nama']) ?></strong>
                                        </td>
                                        <td>
                                            <?= htmlspecialchars($user['no_telepon']) ?>
                                        </td>
                                        <td>
                                            <?= htmlspecialchars($user['email']) ?>
                                        </td>
                                        <td>
                                            <?= htmlspecialchars($user['alamat']) ?>
                                        </td>
                                        <td class="text-center">
                                            <div class="btn-group" role="group">
                                                <a href="edit.php?id=<?= $user['id'] ?>" 
                                                   class="btn btn-warning btn-action" 
                                                   title="Edit">
                                                    Edit
                                                </a>
                                                <button onclick="confirmDelete(<?= $user['id'] ?>, '<?= htmlspecialchars($user['nama']) ?>')" 
                                                        class="btn btn-danger btn-action" 
                                                        title="Hapus">
                                                    Hapus
                                                </button>
                                            </div>
                                        </td>
                                    </tr>
                                <?php endwhile; ?>
                            </tbody>
                        </table>
                    </div>
                <?php endif; ?>
            </div>
        </div>
    </div>
</div>

<?php require_once 'footer.php'; ?>
