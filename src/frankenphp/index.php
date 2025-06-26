<?php

// worker.php

// 1. BOOTSTRAP APLIKASI ANDA (Dijalankan sekali saja)
// ===================================================
// Muat semua file konfigurasi, fungsi, atau autoloader yang diperlukan.
// Ini akan tetap ada di memori untuk semua permintaan berikutnya.
// Jika Anda menggunakan Composer, baris di bawah ini sangat penting:
// require_once __DIR__ . '/vendor/autoload.php';

echo "PHP Worker siap menerima permintaan...\n";


// 2. MASUK KE DALAM REQUEST LOOP (Dijalankan untuk setiap permintaan)
// =================================================================
// Fungsi \FrankenPhp\loop() akan menangani permintaan HTTP yang masuk.
do {
    $running = frankenphp_handle_request(
        function() {
            require __DIR__ . '/config.php';
            require __DIR__ . '/functions.php';
            // Dapatkan path dari permintaan, contoh: '/', '/create.php', '/edit.php?id=1'
            $requestUri = $_SERVER['REQUEST_URI'];
            $path = parse_url($requestUri, PHP_URL_PATH);
            $pathSegments = explode('/', trim($path, '/'));
            $path = '/' . (end($pathSegments) ?: '');
            
            switch ($path) {
                case '':
                case '/':
                case '/index':
                    require __DIR__ . '/pages/index.php';
                    break;
        
                case '/create':
                    require __DIR__ . '/pages/create.php';
                    break;
                    
                case '/edit':
                    require __DIR__ . '/pages/edit.php';
                    break;
        
                case '/delet':
                    require __DIR__ . '/pages/delete.php';
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