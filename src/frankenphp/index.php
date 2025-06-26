<?php

// worker.php

// 1. BOOTSTRAP APLIKASI ANDA (Dijalankan sekali saja)
// ===================================================
// Muat semua file konfigurasi, fungsi, atau autoloader yang diperlukan.
// Ini akan tetap ada di memori untuk semua permintaan berikutnya.
require_once __DIR__ . '/config.php';
require_once __DIR__ . '/functions.php';
// Jika Anda menggunakan Composer, baris di bawah ini sangat penting:
// require_once __DIR__ . '/vendor/autoload.php';

echo "PHP Worker siap menerima permintaan...\n";


// 2. MASUK KE DALAM REQUEST LOOP (Dijalankan untuk setiap permintaan)
// =================================================================
// Fungsi \FrankenPhp\loop() akan menangani permintaan HTTP yang masuk.
do {
	$running = frankenphp_handle_request(
        function() {
            // Dapatkan path dari permintaan, contoh: '/', '/create.php', '/edit.php?id=1'
            $requestUri = $_SERVER['REQUEST_URI'];
            $path = parse_url($requestUri, PHP_URL_PATH);
        
            // Routing Sederhana berdasarkan struktur file Anda
            // Ini akan menjalankan file yang sesuai dengan URL yang diakses.
            switch ($path) {
                case '/':
                case '/index.php':
                    require __DIR__ . '/index.php';
                    break;
        
                case '/create.php':
                    require __DIR__ . '/create.php';
                    break;
                    
                case '/edit.php':
                    require __DIR__ . '/edit.php';
                    break;
        
                case '/delete.php':
                    require __DIR__ . '/delete.php';
                    break;
                
                // Tambahkan case lain jika ada file lain yang perlu diakses langsung
                // ...
        
                default:
                    // Jika file tidak ditemukan, kirim respons 404
                    http_response_code(404);
                    echo '<h1>404 Not Found</h1>';
                    echo 'Halaman yang diminta tidak ditemukan.';
                    break;
        }
    // Di dalam loop, kita perlu mensimulasikan lingkungan PHP yang "bersih"
    // seolah-olah ini adalah permintaan baru.

    }
	);
} while ($running);

// Kode setelah loop ini tidak akan pernah dijalankan