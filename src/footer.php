        </div>
        </div>

        <footer class="footer bg-dark text-light text-center py-3">
            <div class="container">
                <p class="mb-0">&copy; 2025 CRUD User Management. All rights reserved.</p>
            </div>
        </footer>

        <script src="bootstrap/js/bootstrap.bundle.min.js"></script>
        <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
            <script src="https://cdn.jsdelivr.net/npm/simple-datatables@latest" type="text/javascript"></script>
        <script>
            document.addEventListener('DOMContentLoaded', function() {
     
            });
            const dataTable = new simpleDatatables.DataTable("#dataTable", {
                // Opsi tambahan bisa diletakkan di sini
                // Contoh: menonaktifkan pencarian
                // search: false
            });
        </script>
        <script>
            // Konfirmasi hapus
            function confirmDelete(id, nama) {
                Swal.fire({
                    title: 'Apakah Anda yakin?',
                    text: `Anda akan menghapus user "${nama}"`,
                    icon: 'warning',
                    showCancelButton: true,
                    confirmButtonColor: '#d33',
                    cancelButtonColor: '#3085d6',
                    confirmButtonText: 'Ya, Hapus!',
                    cancelButtonText: 'Batal'
                }).then((result) => {
                    if (result.isConfirmed) {
                        window.location.href = `delete.php?id=${id}`;
                    }
                });
            }

            // Auto hide alerts
            setTimeout(() => {
                const alerts = document.querySelectorAll('.alert');
                alerts.forEach(alert => {
                    const bsAlert = new bootstrap.Alert(alert);
                    bsAlert.close();
                });
            }, 5000);
        </script>
        </body>

        </html>