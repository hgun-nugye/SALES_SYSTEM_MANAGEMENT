USE QuanLyTapHoa_Nhom1;
GO

-- 1. Tinh
INSERT INTO Tinh (MaTinh, TenTinh) VALUES
(1, N'Hà Nội'), (2, N'Hồ Chí Minh'), (3, N'Đà Nẵng');
GO

-- 2. Xa
INSERT INTO Xa (MaXa, TenXa, MaTinh) VALUES
(101, N'Phường Hoàn Kiếm', 1), (102, N'Phường Ba Đình', 1),
(201, N'Phường Bến Nghé', 2), (202, N'Phường Tân Định', 2),
(301, N'Phường Hải Châu', 3);
GO

-- Thêm Tỉnh (Tiếp nối mã 1, 2, 3)
INSERT INTO Tinh (MaTinh, TenTinh) VALUES
(4, N'Cần Thơ'),
(5, N'Hải Phòng'),
(6, N'Khánh Hòa');
GO

-- Thêm Xã/Phường tương ứng
INSERT INTO Xa (MaXa, TenXa, MaTinh) VALUES
(401, N'Phường Ninh Kiều', 4),
(402, N'Phường Cái Răng', 4),
(501, N'Phường Hồng Bàng', 5),
(502, N'Phường Lê Chân', 5),
(601, N'Phường Lộc Thọ', 6),
(602, N'Phường Vĩnh Hải', 6);
GO

-- 3. NhaCC
INSERT INTO NhaCC (MaNCC, TenNCC, DienThoaiNCC, EmailNCC, DiaChiNCC, MaXa) VALUES
('NCC0000001', N'Công ty Unilerver', '02873007300', 'cskh@unilever.com', N'20 Tràng Tiền', 101),
('NCC0000002', N'Mì Acecook Việt Nam', '18006324', 'support@acecook.vn', N'25 Nguyễn Huệ', 201);
GO
INSERT INTO NhaCC (MaNCC, TenNCC, DienThoaiNCC, EmailNCC, DiaChiNCC, MaXa) VALUES
('NCC0000003', N'Vinamilk Việt Nam', '0283524111', 'vnm@vinamilk.com.vn', N'10 Tân Trào', 201),
('NCC0000004', N'Masan Consumer', '0286255566', 'info@masangroup.com', N'Nguyễn Huệ', 202),
('NCC0000005', N'Suntory PepsiCo', '0283821945', 'contact@suntorypepsi.vn', N'Lê Duẩn', 201),
('NCC0000006', N'P&G Vietnam', '0283827302', 'cskh.pg@pg.com', N'Phú Mỹ Hưng', 202),
('NCC0000007', N'Tân Hiệp Phát', '0274375541', 'cskh@thp.com.vn', N'Đại lộ Bình Dương', 102);
GO

-- 4. KhachHang
INSERT INTO KhachHang (MaKH, TenKH, AnhKH, GioiTinh, EmailKH, DienThoaiKH, DiaChiKH, MaXa) VALUES
('KH00000001', N'Nguyễn Thị Lan', NULL, 0, 'lan@gmail.com', '0901111222', N'10 Tràng Tiền', 101),
('KH00000002', N'Trần Mỹ Anh', NULL, 0, 'anh@gmail.com', '0902222333', N'15 Nguyễn Huệ', 202);
GO

INSERT INTO KhachHang (MaKH, TenKH, AnhKH, GioiTinh, EmailKH, DienThoaiKH, DiaChiKH, MaXa) VALUES
('KH00000003', N'Lê Văn Hoàng', NULL, 1, 'hoang.le@gmail.com', '0912345678', N'88 Hải Châu', 301),
('KH00000004', N'Phạm Minh Tuấn', NULL, 1, 'tuanpham@yahoo.com', '0988777666', N'12 Ninh Kiều', 401),
('KH00000005', N'Hoàng Thu Thủy', NULL, 0, 'thuy.hoang@outlook.com', '0933444555', N'45 Lê Chân', 502),
('KH00000006', N'Đặng Gia Bảo', NULL, 1, 'baodang@gmail.com', '0707123456', N'Trần Phú', 601),
('KH00000007', N'Vũ Phương Thảo', NULL, 0, 'thaovu@gmail.com', '0911222333', N'Vĩnh Hải', 602);
GO

-- 5. TaiKhoan
INSERT INTO TaiKhoan (MaTK, TenDN, MatKhau, VaiTro) VALUES
('TK001', 'admin', '123456', 1),
('TK002', 'nhanvien01', '123456', 0);
GO

-- 6. NhomSP
INSERT INTO NhomSP (MaNhom, TenNhom) VALUES
('NGK',     N'Nước giải khát'),
('TPK',     N'Thực phẩm khô'),
('SUA',     N'Sữa và Chế phẩm sữa'),
('HMP',     N'Hóa mỹ phẩm cá nhân');
GO

INSERT INTO NhomSP (MaNhom, TenNhom) VALUES
('BANHKEO', N'Bánh kẹo & Đồ ăn vặt'),
('GIAVI',   N'Gia vị & Đồ đóng hộp');
GO

-- 7. LoaiSP (Bổ sung NUOCNGOT và MIGOI để không lỗi SanPham)
INSERT INTO LoaiSP (MaLoai, TenLoai, MaNhom) VALUES
('NUOCNGOT', N'Nước ngọt các loại', 'NGK'),
('MIGOI',    N'Mì ăn liền', 'TPK'),
('SUATUOI',  N'Sữa tươi', 'SUA'),
('DAUGOI',   N'Dầu gội', 'HMP'),
('SNACK',   N'Snack & Đồ ăn vặt', 'BANHKEO'),
('KEMDR',   N'Kem đánh răng',      'HMP'),
('NUOCMAM', N'Nước mắm & Tương',   'GIAVI'),
('DAUAN',   N'Dầu ăn & Gia vị',    'TPK'),
('SUACHUA', N'Sữa chua',           'SUA');
GO

-- 8. TrangThai
INSERT INTO TrangThai (MaTT, TenTT) VALUES
('TT1', N'Còn hàng'),
('TT2', N'Hết hàng');
GO

-- 9. SanPham (Đã sửa MaSP đồng nhất 10 ký tự)
INSERT INTO SanPham (MaSP, TenSP, GiaBan, MaTT, MaLoai) VALUES
('SP00000001', N'Nước ngọt Coca-Cola', 10000, 'TT1', 'NUOCNGOT'),
('SP00000002', N'Mì Hảo Hảo Tôm Chua Cay', 4500, 'TT1', 'MIGOI'),
('SP00000003', N'Sữa tươi Vinamilk 180ml', 8000, 'TT1', 'SUATUOI'),
('SP00000004', N'Dầu gội Sunsilk 650g', 145000, 'TT1', 'DAUGOI'),
('SP00000005', N'Bia Tiger Lon 330ml', 18500, 'TT1', 'NUOCNGOT');
GO

-- Thêm sản phẩm vào bảng SanPham
INSERT INTO SanPham (MaSP, TenSP, GiaBan, MaTT, MaLoai) VALUES
-- Nhóm Bánh kẹo & Snack
('SP00000006', N'Bánh Oreo vị Vanilla 133g', 15000, 'TT1', 'SNACK'),
('SP00000007', N'Snack Khoai tây Lay vị Tự nhiên', 12000, 'TT1', 'SNACK'),
('SP00000008', N'Kẹo mút Chupa Chups (Cây)', 2000, 'TT1', 'SNACK'),

-- Nhóm Hóa mỹ phẩm
('SP00000009', N'Kem đánh răng P/S Bảo vệ 123', 35000, 'TT1', 'KEMDR'),
('SP00000010', N'Bàn chải đánh răng Colgate', 15000, 'TT1', 'KEMDR'),
('SP00000011', N'Sữa tắm Lifebuoy 800g', 165000, 'TT1', 'DAUGOI'),

-- Nhóm Gia vị & Thực phẩm
('SP00000012', N'Nước mắm Nam Ngư 750ml', 45000, 'TT1', 'NUOCMAM'),
('SP00000013', N'Tương ớt Cholimex 270g', 12000, 'TT1', 'NUOCMAM'),
('SP00000014', N'Dầu ăn Tường An 1L', 52000, 'TT1', 'DAUAN'),
('SP00000015', N'Hạt nêm Knorr 400g', 38000, 'TT1', 'DAUAN'),

-- Nhóm Sữa & Nước giải khát
('SP00000016', N'Sữa chua Vinamilk có đường', 6000, 'TT1', 'SUACHUA'),
('SP00000017', N'Sữa Milo lốc 4 hộp 180ml', 28000, 'TT1', 'SUATUOI'),
('SP00000018', N'Nước khoáng Lavie 500ml', 5000, 'TT1', 'NUOCNGOT'),
('SP00000019', N'Bia Tiger Bạc Lon 330ml', 19000, 'TT1', 'NUOCNGOT'),
('SP00000020', N'Nước tăng lực Sting Dâu', 10000, 'TT2', 'NUOCNGOT'); -- Giả sử Sting đang hết hàng (TT2)
GO

-- 10. DonMuaHang
INSERT INTO DonMuaHang (MaDMH, NgayMH, MaNCC) VALUES
('M2511010001', '2025-11-01', 'NCC0000001'),
('M2511010002', '2025-11-05', 'NCC0000002');
GO

-- 11. DonBanHang
INSERT INTO DonBanHang (MaDBH, NgayBH, MaKH) VALUES
('B2512010001', '2025-12-01', 'KH00000001'),
('B2512010002', '2025-12-02', 'KH00000002');
GO

-- 12. CTMH (Đã sửa MaSP thành 10 ký tự khớp với bảng SanPham)
INSERT INTO CTMH (MaDMH, MaSP, SLM, DGM) VALUES
('M2511010001', 'SP00000001', 100, 8000),
('M2511010001', 'SP00000002', 200, 3500);
GO

-- 13. CTBH (Đã sửa MaSP thành 10 ký tự khớp với bảng SanPham)
INSERT INTO CTBH (MaDBH, MaSP, SLB, DGB) VALUES
('B2512010001', 'SP00000001', 5, 10000),
('B2512010001', 'SP00000002', 10, 4500);
GO

-- 10. Bổ sung 1 Đơn Mua Hàng tổng hợp cho tất cả sản phẩm
INSERT INTO DonMuaHang (MaDMH, NgayMH, MaNCC) VALUES
('M251228001', '2025-12-28', 'NCC0000001');
GO

-- 12. Chi tiết nhập hàng (CTMH) cho toàn bộ 20 sản phẩm
-- Số lượng nhập (SLM) trung bình từ 50-100, Đơn giá nhập (DGM) thấp hơn giá bán
INSERT INTO CTMH (MaDMH, MaSP, SLM, DGM) VALUES
('M251228001', 'SP00000001', 100, 8000),   -- Coca
('M251228001', 'SP00000002', 200, 3500),   -- Hảo Hảo
('M251228001', 'SP00000003', 150, 6500),   -- Sữa tươi Vinamilk
('M251228001', 'SP00000004', 50, 120000),  -- Sunsilk
('M251228001', 'SP00000005', 80, 15000),   -- Tiger
('M251228001', 'SP00000006', 100, 12000),  -- Oreo
('M251228001', 'SP00000007', 100, 9500),   -- Lay
('M251228001', 'SP00000008', 500, 1500),   -- Chupa Chups
('M251228001', 'SP00000009', 100, 28000),  -- P/S
('M251228001', 'SP00000010', 100, 11000),  -- Colgate
('M251228001', 'SP00000011', 40, 135000),  -- Lifebuoy
('M251228001', 'SP00000012', 60, 38000),   -- Nam Ngư
('M251228001', 'SP00000013', 100, 9500),   -- Tương ớt
('M251228001', 'SP00000014', 50, 42000),   -- Dầu ăn
('M251228001', 'SP00000015', 70, 31000),   -- Knorr
('M251228001', 'SP00000016', 120, 5000),   -- Sữa chua
('M251228001', 'SP00000017', 80, 23000),   -- Milo
('M251228001', 'SP00000018', 200, 3500),   -- Lavie
('M251228001', 'SP00000019', 100, 16000),  -- Tiger Bạc
('M251228001', 'SP00000020', 100, 8000);   -- Sting
GO