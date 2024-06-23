CREATE DATABASE furama;
USE furama;

CREATE TABLE vi_tri(
ma_vi_tri INT UNIQUE PRIMARY KEY,
ten_vi_tri VARCHAR(50)
);

CREATE TABLE trinh_do(
ma_trinh_do INT UNIQUE PRIMARY KEY,
ten_trinh_do VARCHAR(50)
);

CREATE TABLE bo_phan(
ma_bo_phan INT UNIQUE PRIMARY KEY,
ten_bo_phan VARCHAR(50)
);

CREATE TABLE nhan_vien(
ma_nhan_vien INT UNIQUE PRIMARY KEY,
ho_ten VARCHAR(50),
ngay_sinh DATE,
so_cccd VARCHAR(12),
luong DOUBLE,
so_dien_thoai VARCHAR(10),
email VARCHAR(50),
dia_chi VARCHAR(255),
ma_vi_tri INT,
ma_trinh_do INT,
ma_bo_phan INT,
foreign key (ma_vi_tri) references vi_tri (ma_vi_tri),
foreign key (ma_trinh_do) references trinh_do (ma_trinh_do),
foreign key (ma_bo_phan) references bo_phan (ma_bo_phan)
);

CREATE TABLE loai_khach (
ma_loai_khach INT PRIMARY KEY,
ten_loai_khach VARCHAR(50)
);

CREATE TABLE khach_hang(
ma_khach_hang INT PRIMARY KEY,
ho_ten VARCHAR(50),
ngay_sinh DATE,
gioi_tinh BIT,
so_cccd VARCHAR(12),
so_dien_thoai VARCHAR(10),
email VARCHAR(50),
dia_chi VARCHAR(255),
ma_loai_khach INT,
FOREIGN KEY (ma_loai_khach) REFERENCES loai_khach (ma_loai_khach)
);

CREATE TABLE kieu_thue(
ma_kieu_thue INT PRIMARY KEY,
ten_kieu_thue VARCHAR(50)
);

CREATE TABLE loai_dich_vu(
ma_loai_dich_vu INT PRIMARY KEY,
ten_loai_dich_vu VARCHAR(50)
);

CREATE TABLE dich_vu(
ma_dich_vu INT PRIMARY KEY,
ten_dich_vu VARCHAR(50),
dien_tich INT,
chi_phi_thue DOUBLE,
so_nguoi_toi_da INT,
tieu_chuan_phong VARCHAR(10),
mo_ta_tien_nghi_khac VARCHAR(100),
dien_tich_ho_boi INT,
so_tang INT,
ma_kieu_thue INT,
ma_loai_dich_vu INT,
FOREIGN KEY (ma_kieu_thue) REFERENCES kieu_thue(ma_kieu_thue),
FOREIGN KEY (ma_loai_dich_vu) REFERENCES loai_dich_vu(ma_loai_dich_vu)
);

CREATE TABLE dich_vu_di_kem(
ma_dich_vu_di_kem INT PRIMARY KEY,
ten_dich_vu_di_kem VARCHAR(50),
gia DOUBLE,
don_vi VARCHAR(20),
trang_thai VARCHAR(50)
);

CREATE TABLE hop_dong(
ma_hop_dong INT PRIMARY KEY,
ngay_lam_hop_dong DATE,
ngay_ket_thuc DATE,
tien_dat_coc DOUBLE,
ma_nhan_vien INT,
ma_khach_hang INT,
ma_dich_vu INT,
FOREIGN KEY (ma_nhan_vien) REFERENCES nhan_vien (ma_nhan_vien),
FOREIGN KEY (ma_khach_hang) REFERENCES khach_hang (ma_khach_hang),
FOREIGN KEY (ma_dich_vu) REFERENCES dich_vu (ma_dich_vu)
);

CREATE TABLE hop_dong_chi_tiet(
ma_hop_dong_chi_tiet INT PRIMARY KEY,
so_luong INT,
ma_hop_dong INT,
ma_dich_vu_di_kem INT,
FOREIGN KEY (ma_hop_dong) REFERENCES hop_dong(ma_hop_dong),
FOREIGN KEY (ma_dich_vu_di_kem) REFERENCES dich_vu_di_kem(ma_dich_vu_di_kem)
);






