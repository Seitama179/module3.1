CREATE DATABASE furama;
USE furama;

CREATE TABLE nhan_vien(
ma_nhan_vien INT PRIMARY KEY,
ho_ten VARCHAR(50),
ngay_sinh DATE,
so_cccd VARCHAR(12),
luong LONG,
so_dien_thoai VARCHAR(10),
email VARCHAR(50),
dia_chi VARCHAR(255),
ma_vi_tri INT,
ma_trinh_do INT,
ma_bo_phan INT
);

CREATE TABLE vi_tri(
ma_vi_tri INT AUTO_INCREMENT PRIMARY KEY,
ten_vi_tri VARCHAR(50)
);

CREATE TABLE trinh_do(
ma_trinh_do INT AUTO_INCREMENT PRIMARY KEY,
ten_trinh_do VARCHAR(50)
);

CREATE TABLE bo_phan(
ma_bo_phan INT AUTO_INCREMENT PRIMARY KEY,
ten_bo_phan VARCHAR(50)
);





