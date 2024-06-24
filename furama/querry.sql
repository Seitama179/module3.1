USE furama;

-- 2.	Hiển thị thông tin của tất cả nhân viên có trong hệ thống có tên bắt đầu là một trong các ký tự “H”, “T” hoặc “K” và có tối đa 15 kí tự.
SELECT nv.ma_nhan_vien, nv.ho_ten, nv.ngay_sinh, nv.so_cccd, nv.so_dien_thoai, nv.email, nv.dia_chi, nv.ma_vi_tri, nv.ma_trinh_do, nv.ma_bo_phan
FROM nhan_vien nv
WHERE nv.ho_ten LIKE 'H%' or nv.ho_ten LIKE 'T%' or nv.ho_ten LIKE 'K%'
AND length(nv.ho_ten) <= 15;

-- 3.	Hiển thị thông tin của tất cả khách hàng có độ tuổi từ 18 đến 50 tuổi và có địa chỉ ở “Đà Nẵng” hoặc “Quảng Trị”.
SELECT *, 
TIMESTAMPDIFF(YEAR, kh.ngay_sinh, CURDATE()) as tuoi
FROM khach_hang kh
WHERE TIMESTAMPDIFF(YEAR, kh.ngay_sinh, CURDATE()) BETWEEN 18 AND 50
AND (kh.dia_chi LIKE '%Đà Nẵng%' OR kh.dia_chi LIKE '%Quảng Trị%');

-- 4.	Đếm xem tương ứng với mỗi khách hàng đã từng đặt phòng bao nhiêu lần. 
-- Kết quả hiển thị được sắp xếp tăng dần theo số lần đặt phòng của khách hàng. 
-- Chỉ đếm những khách hàng nào có Tên loại khách hàng là “Diamond”.
SELECT kh.ho_ten, COUNT(hd.ma_dich_vu) AS so_lan_dat_phong
FROM khach_hang kh
JOIN loai_khach lk ON kh.ma_loai_khach = lk.ma_loai_khach
JOIN hop_dong hd ON kh.ma_khach_hang = hd.ma_khach_hang
WHERE lk.ten_loai_khach = 'Diamond'
GROUP BY kh.ma_khach_hang, kh.ho_ten
ORDER BY so_lan_dat_phong ASC;

/* 5.	Hiển thị ma_khach_hang, ho_ten, ten_loai_khach, ma_hop_dong, ten_dich_vu, ngay_lam_hop_dong, ngay_ket_thuc, tong_tien 
(Với tổng tiền được tính theo công thức như sau: Chi Phí Thuê + Số Lượng * Giá, với Số Lượng và Giá là từ bảng dich_vu_di_kem, hop_dong_chi_tiet)
cho tất cả các khách hàng đã từng đặt phòng. (những khách hàng nào chưa từng đặt phòng cũng phải hiển thị ra).
*/
-- SELECT kh.ma_khach_hang,
--        kh.ho_ten,
--        lk.ten_loai_khach,
--        hd.ma_hop_dong,
--        dv.ten_dich_vu,
--        hd.ngay_lam_hop_dong,
--        hd.ngay_ket_thuc,
--        IFNULL(dv.chi_phi_thue, 0) + IFNULL(hdct.so_luong * dvdk.gia, 0) AS tong_tien
-- FROM khach_hang kh
-- LEFT JOIN loai_khach lk ON kh.ma_loai_khach = lk.ma_loai_khach
-- LEFT JOIN hop_dong hd ON kh.ma_khach_hang = hd.ma_khach_hang
-- LEFT JOIN dich_vu dv ON hd.ma_dich_vu = dv.ma_dich_vu
-- LEFT JOIN hop_dong_chi_tiet hdct ON hd.ma_hop_dong = hdct.ma_hop_dong
-- LEFT JOIN dich_vu_di_kem dvdk ON hdct.ma_dich_vu_di_kem = dvdk.ma_dich_vu_di_kem;
       
SELECT kh.ma_khach_hang,
       kh.ho_ten,
       lk.ten_loai_khach,
       hd.ma_hop_dong,
       dv.ten_dich_vu,
       hd.ngay_lam_hop_dong,
       hd.ngay_ket_thuc,
       IFNULL(dv.chi_phi_thue, 0) + IFNULL(SUM(hdct.so_luong * dvdk.gia), 0) AS tong_tien
FROM khach_hang kh
LEFT JOIN loai_khach lk ON kh.ma_loai_khach = lk.ma_loai_khach
LEFT JOIN hop_dong hd ON kh.ma_khach_hang = hd.ma_khach_hang
LEFT JOIN dich_vu dv ON hd.ma_dich_vu = dv.ma_dich_vu
LEFT JOIN hop_dong_chi_tiet hdct ON hd.ma_hop_dong = hdct.ma_hop_dong
LEFT JOIN dich_vu_di_kem dvdk ON hdct.ma_dich_vu_di_kem = dvdk.ma_dich_vu_di_kem
GROUP BY kh.ma_khach_hang, kh.ho_ten, lk.ten_loai_khach, hd.ma_hop_dong, dv.ten_dich_vu, hd.ngay_lam_hop_dong, hd.ngay_ket_thuc 
ORDER BY kh.ma_khach_hang;

-- 6.	Hiển thị ma_dich_vu, ten_dich_vu, dien_tich, chi_phi_thue, ten_loai_dich_vu 
-- của tất cả các loại dịch vụ chưa từng được khách hàng thực hiện đặt từ quý 1 của năm 2021 
-- (Quý 1 là tháng 1, 2, 3).
SELECT DISTINCT dv.ma_dich_vu,
                dv.ten_dich_vu,
                dv.dien_tich,
                dv.chi_phi_thue,
                ldv.ten_loai_dich_vu
FROM dich_vu dv
JOIN loai_dich_vu ldv ON dv.ma_loai_dich_vu = ldv.ma_loai_dich_vu
WHERE NOT EXISTS (
    SELECT 1
    FROM hop_dong hd
    WHERE dv.ma_dich_vu = hd.ma_dich_vu
    AND hd.ngay_lam_hop_dong BETWEEN '2021-01-01' AND '2021-03-31'
);

-- 7.	Hiển thị thông tin ma_dich_vu, ten_dich_vu, dien_tich, so_nguoi_toi_da, chi_phi_thue, ten_loai_dich_vu 
-- của tất cả các loại dịch vụ đã từng được khách hàng đặt phòng trong năm 2020 nhưng chưa từng được khách hàng đặt phòng trong năm 2021
SELECT DISTINCT dv.ma_dich_vu,
			    dv.ten_dich_vu,
			    dv.dien_tich,
			    dv.so_nguoi_toi_da,
			    dv.chi_phi_thue,
			    ldv.ten_loai_dich_vu
FROM dich_vu dv
JOIN loai_dich_vu ldv ON dv.ma_loai_dich_vu = ldv.ma_loai_dich_vu
JOIN hop_dong hd_2020 ON dv.ma_dich_vu = hd_2020.ma_dich_vu
LEFT JOIN hop_dong hd_2021 ON dv.ma_dich_vu = hd_2021.ma_dich_vu
    AND hd_2021.ngay_lam_hop_dong BETWEEN '2021-01-01' AND '2021-12-31'
WHERE hd_2020.ngay_lam_hop_dong BETWEEN '2020-01-01' AND '2020-12-31'
  AND hd_2021.ma_hop_dong IS NULL;
  
-- 8.	Hiển thị thông tin ho_ten khách hàng có trong hệ thống, với yêu cầu ho_ten không trùng nhau.
-- Học viên sử dụng theo 3 cách khác nhau để thực hiện yêu cầu trên.
SELECT ho_ten
FROM khach_hang
GROUP BY ho_ten;

SELECT DISTINCT ho_ten
FROM khach_hang;

-- 9.	Thực hiện thống kê doanh thu theo tháng, nghĩa là tương ứng với mỗi tháng trong năm 2021 thì sẽ có bao nhiêu khách hàng thực hiện đặt phòng.
SELECT 
    DATE_FORMAT(hd.ngay_lam_hop_dong, '%Y-%m') AS thang,
    COUNT(DISTINCT hd.ma_khach_hang) AS so_khach_hang
FROM 
    hop_dong hd
WHERE 
    YEAR(hd.ngay_lam_hop_dong) = 2021
GROUP BY 
    DATE_FORMAT(hd.ngay_lam_hop_dong, '%Y-%m')
ORDER BY 
    thang;
    
-- 10.	Hiển thị thông tin tương ứng với từng hợp đồng thì đã sử dụng bao nhiêu dịch vụ đi kèm. 
-- Kết quả hiển thị bao gồm ma_hop_dong, ngay_lam_hop_dong, ngay_ket_thuc, tien_dat_coc, so_luong_dich_vu_di_kem 
-- (được tính dựa trên việc sum so_luong ở dich_vu_di_kem).
SELECT hd.ma_hop_dong,
       hd.ngay_lam_hop_dong,
       hd.ngay_ket_thuc,
       hd.tien_dat_coc,
       SUM(hdct.so_luong) AS so_luong_dich_vu_di_kem
FROM hop_dong hd
LEFT JOIN hop_dong_chi_tiet hdct ON hd.ma_hop_dong = hdct.ma_hop_dong
GROUP BY hd.ma_hop_dong, hd.ngay_lam_hop_dong, hd.ngay_ket_thuc, hd.tien_dat_coc;

-- 11.	Hiển thị thông tin các dịch vụ đi kèm đã được sử dụng bởi những khách hàng có ten_loai_khach là “Diamond” 
-- và có dia_chi ở “Vinh” hoặc “Quảng Ngãi”.
SELECT dvdk.ma_dich_vu_di_kem,
       dvdk.ten_dich_vu_di_kem,
       dvdk.gia,
       dvdk.don_vi,
       dvdk.trang_thai
FROM dich_vu_di_kem dvdk
JOIN hop_dong_chi_tiet hdct ON dvdk.ma_dich_vu_di_kem = hdct.ma_dich_vu_di_kem
JOIN hop_dong hd ON hdct.ma_hop_dong = hd.ma_hop_dong
JOIN khach_hang kh ON hd.ma_khach_hang = kh.ma_khach_hang
JOIN loai_khach lk ON kh.ma_loai_khach = lk.ma_loai_khach
WHERE lk.ma_loai_khach = '1'
AND (kh.dia_chi LIKE '%Vinh%' OR kh.dia_chi LIKE '%Quảng Ngãi%');

-- 12.	Hiển thị thông tin ma_hop_dong, ho_ten (nhân viên), ho_ten (khách hàng), so_dien_thoai (khách hàng), ten_dich_vu, 
-- so_luong_dich_vu_di_kem (được tính dựa trên việc sum so_luong ở dich_vu_di_kem), 
-- tien_dat_coc của tất cả các dịch vụ đã từng được khách hàng đặt vào 3 tháng cuối năm 2020 nhưng chưa từng được khách hàng đặt vào 6 tháng đầu năm 2021.
SELECT 
    hd.ma_hop_dong,
    nv.ho_ten AS nhan_vien,
    kh.ho_ten AS khach_hang,
    kh.so_dien_thoai,
    dv.ten_dich_vu,
    SUM(hdct.so_luong) AS so_luong_dich_vu_di_kem,
    hd.tien_dat_coc
FROM hop_dong hd
JOIN nhan_vien nv ON hd.ma_nhan_vien = nv.ma_nhan_vien
JOIN khach_hang kh ON hd.ma_khach_hang = kh.ma_khach_hang
JOIN dich_vu dv ON hd.ma_dich_vu = dv.ma_dich_vu
LEFT JOIN hop_dong_chi_tiet hdct ON hd.ma_hop_dong = hdct.ma_hop_dong
WHERE 
    hd.ngay_lam_hop_dong BETWEEN '2020-10-01' AND '2020-12-31'
    AND NOT EXISTS (
        SELECT 1
        FROM hop_dong hd_sub
        WHERE hd_sub.ma_khach_hang = hd.ma_khach_hang
        AND hd_sub.ma_dich_vu = hd.ma_dich_vu
        AND hd_sub.ngay_lam_hop_dong BETWEEN '2021-01-01' AND '2021-06-30'
    )
GROUP BY hd.ma_hop_dong, nv.ho_ten, kh.ho_ten, kh.so_dien_thoai, dv.ten_dich_vu, hd.tien_dat_coc;

-- 13.	Hiển thị thông tin các Dịch vụ đi kèm được sử dụng nhiều nhất bởi các Khách hàng đã đặt phòng. 
-- (Lưu ý là có thể có nhiều dịch vụ có số lần sử dụng nhiều như nhau).
WITH service_usage AS (
    SELECT 
        dvdk.ma_dich_vu_di_kem,
        dvdk.ten_dich_vu_di_kem,
        SUM(hdct.so_luong) AS total_usage
    FROM dich_vu_di_kem dvdk
    JOIN hop_dong_chi_tiet hdct ON dvdk.ma_dich_vu_di_kem = hdct.ma_dich_vu_di_kem
    JOIN hop_dong hd ON hdct.ma_hop_dong = hd.ma_hop_dong
    GROUP BY dvdk.ma_dich_vu_di_kem, dvdk.ten_dich_vu_di_kem
),
max_usage AS (
    SELECT MAX(total_usage) AS max_total_usage
    FROM service_usage
)
SELECT 
    su.ma_dich_vu_di_kem,
    su.ten_dich_vu_di_kem,
    su.total_usage
FROM 
    service_usage su,
    max_usage mu
WHERE su.total_usage = mu.max_total_usage;

-- 14.	Hiển thị thông tin tất cả các Dịch vụ đi kèm chỉ mới được sử dụng một lần duy nhất. 
-- Thông tin hiển thị bao gồm ma_hop_dong, ten_loai_dich_vu, ten_dich_vu_di_kem, so_lan_su_dung 
-- (được tính dựa trên việc count các ma_dich_vu_di_kem).
select      
    hd.ma_hop_dong as IDHopDong,
    ldv.ten_loai_dich_vu as TenLoaiDichVu,
    dvdk.ten_dich_vu_di_kem as TenDichVuDiKem,
    hdct.so_luong as SoLanSuDung 
from hop_dong hd 
join dich_vu dv on hd.ma_dich_vu = dv.ma_dich_vu 
join hop_dong_chi_tiet hdct on hd.ma_hop_dong = hdct.ma_hop_dong 
join dich_vu_di_kem dvdk on hdct.ma_dich_vu_di_kem = dvdk.ma_dich_vu_di_kem 
join loai_dich_vu ldv on dv.ma_loai_dich_vu = ldv.ma_loai_dich_vu 
where hdct.so_luong = 1 
order by hd.ma_hop_dong;

-- 15.	Hiển thi thông tin của tất cả nhân viên bao gồm ma_nhan_vien, ho_ten, ten_trinh_do, ten_bo_phan, so_dien_thoai, dia_chi 
-- mới chỉ lập được tối đa 3 hợp đồng từ năm 2020 đến 2021.
SELECT 
    nv.ma_nhan_vien,
    nv.ho_ten,
    td.ten_trinh_do,
    bp.ten_bo_phan,
    nv.so_dien_thoai,
    nv.dia_chi
FROM nhan_vien nv
JOIN trinh_do td ON nv.ma_trinh_do = td.ma_trinh_do
JOIN bo_phan bp ON nv.ma_bo_phan = bp.ma_bo_phan
JOIN hop_dong hd ON hd.ma_nhan_vien = nv.ma_nhan_vien
		  AND hd.ngay_lam_hop_dong BETWEEN '2020-01-01' AND '2021-12-31'
GROUP BY nv.ma_nhan_vien, nv.ho_ten, td.ten_trinh_do, bp.ten_bo_phan, nv.so_dien_thoai, nv.dia_chi
HAVING COUNT(hd.ma_nhan_vien) <= 3;

-- 16.	Xóa những Nhân viên chưa từng lập được hợp đồng nào từ năm 2019 đến năm 2021.
 DELETE
 FROM nhan_vien
WHERE ma_nhan_vien NOT IN (
    SELECT DISTINCT hd.ma_nhan_vien
    FROM hop_dong hd
    WHERE hd.ngay_lam_hop_dong BETWEEN '2019-01-01' AND '2021-12-31'
);

-- 17.	Cập nhật thông tin những khách hàng có ten_loai_khach từ Platinum lên Diamond, 
-- chỉ cập nhật những khách hàng đã từng đặt phòng với Tổng Tiền thanh toán trong năm 2021 là lớn hơn 10.000.000 VNĐ.
UPDATE khach_hang kh
JOIN (
    SELECT hd.ma_khach_hang, 
           SUM(hd.tien_dat_coc + IFNULL(hdct.so_luong * dvdk.gia, 0)) AS tong_tien
    FROM hop_dong hd
    LEFT JOIN hop_dong_chi_tiet hdct ON hd.ma_hop_dong = hdct.ma_hop_dong
    LEFT JOIN dich_vu_di_kem dvdk ON hdct.ma_dich_vu_di_kem = dvdk.ma_dich_vu_di_kem
    WHERE YEAR(hd.ngay_lam_hop_dong) = 2021
    GROUP BY hd.ma_khach_hang
    HAVING tong_tien > 10000000
) AS khach_hang_rich ON kh.ma_khach_hang = khach_hang_rich.ma_khach_hang
SET kh.ma_loai_khach = '1'
WHERE kh.ma_loai_khach = '2';

-- 18.	Xóa những khách hàng có hợp đồng trước năm 2016 (chú ý ràng buộc giữa các bảng).
DELETE kh
FROM khach_hang kh
JOIN hop_dong hd ON kh.ma_khach_hang = hd.ma_khach_hang
WHERE year(hd.ngay_lam_hop_dong) < 2016;

-- 19.	Cập nhật giá cho các Dịch vụ đi kèm được sử dụng trên 10 lần trong năm 2019 lên gấp đôi.
SET SQL_SAFE_UPDATES = 0;
SELECT hdct.ma_dich_vu_di_kem
FROM hop_dong_chi_tiet hdct
JOIN hop_dong hd ON hdct.ma_hop_dong = hd.ma_hop_dong
where year(hd.ngay_lam_hop_dong) = 2021
group by hdct.ma_dich_vu_di_kem
having count(*) > 10;
update dich_vu_di_kem dvdk
join (
    select hdct.ma_dich_vu_di_kem
    from hop_dong_chi_tiet hdct
    join hop_dong hd on hdct.ma_hop_dong = hd.ma_hop_dong
    where year(hd.ngay_lam_hop_dong) = 2021
    group by hdct.ma_dich_vu_di_kem
    having COUNT(*) > 10
) as dvdk_update on dvdk.ma_dich_vu_di_kem = dvdk_update.ma_dich_vu_di_kem
set dvdk.gia = dvdk.gia * 2;
SET SQL_SAFE_UPDATES = 0;

-- 20.	Hiển thị thông tin của tất cả các nhân viên và khách hàng có trong hệ thống, 
-- thông tin hiển thị bao gồm id (ma_nhan_vien, ma_khach_hang), ho_ten, email, so_dien_thoai, ngay_sinh, dia_chi.
SELECT 
    ma_nhan_vien AS id,
    ho_ten,
    email,
    so_dien_thoai,
    ngay_sinh,
    dia_chi
FROM nhan_vien

UNION

SELECT 
    ma_khach_hang AS id,
    ho_ten,
    email,
    so_dien_thoai,
    ngay_sinh,
    dia_chi
FROM khach_hang;

