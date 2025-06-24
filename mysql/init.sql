-- Buat database
CREATE DATABASE IF NOT EXISTS crud_user;
USE crud_user;

-- Buat tabel users
CREATE TABLE IF NOT EXISTS users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nama VARCHAR(100) NOT NULL,
    no_telepon VARCHAR(20) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    alamat TEXT NOT NULL,
);

-- Insert data contoh
INSERT INTO users (nama, no_telepon, email, alamat) VALUES
('John Doe', '08123456789', 'john@example.com', 'Jl. Merdeka No. 123, Jakarta'),
('Jane Smith', '08987654321', 'jane@example.com', 'Jl. Sudirman No. 456, Bandung'),
('Ahmad Rahman', '08555111222', 'ahmad@example.com', 'Jl. Diponegoro No. 789, Surabaya');
