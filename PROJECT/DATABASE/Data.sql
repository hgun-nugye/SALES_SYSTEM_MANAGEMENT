USE QuanLyTapHoa_Nhom1;
GO

-- 1. Nhập bảng Tinh (Đúng schema: MaTinh, TenTinh)
INSERT INTO Tinh (MaTinh, TenTinh) VALUES
(1, N'Hà Nội'),
(2, N'Hồ Chí Minh'),
(3, N'Đà Nẵng');
GO

-- 2. Nhập bảng Xa (Đúng schema: MaXa, TenXa, MaTinh)
INSERT INTO Xa (MaXa, TenXa, MaTinh) VALUES
(101, N'Phường Hoàn Kiếm', 1),
(102, N'Phường Ba Đình', 1),
(201, N'Phường Bến Nghé', 2),
(202, N'Phường Tân Định', 2),
(301, N'Phường Hải Châu', 3);
GO

-- 3. Nhập bảng NhaCC (Đúng schema: MaNCC, TenNCC, DienThoaiNCC, EmailNCC, DiaChiNCC, MaXa)
INSERT INTO NhaCC (MaNCC, TenNCC, DienThoaiNCC, EmailNCC, DiaChiNCC, MaXa) VALUES
('NCC001', N'Guardian Vietnam', '02873007300', 'cskh@guardian.com.vn', N'20 Tràng Tiền', 101),
('NCC002', N'Hasaki', '18006324', 'support@hasaki.vn', N'25 Nguyễn Huệ', 201);
GO

-- 4. Nhập bảng KhachHang (Đúng schema: MaKH, TenKH, AnhKH, GioiTinh, EmailKH, DienThoaiKH, DiaChiKH, MaXa)
INSERT INTO KhachHang (MaKH, TenKH, AnhKH, GioiTinh, EmailKH, DienThoaiKH, DiaChiKH, MaXa) VALUES
('KH001', N'Nguyễn Thị Lan', NULL, 0, 'lan@gmail.com', '0901111222', N'10 Tràng Tiền', 101),
('KH002', N'Trần Mỹ Anh', NULL, 0, 'anh@gmail.com', '0902222333', N'15 Nguyễn Huệ', 202),
('KH003', N'Lê Hoàng', NULL, 1, 'hoang@gmail.com', '0903333444', N'88 Hải Châu', 301);
GO

-- 5. Nhập bảng TaiKhoan (Đúng schema: MaTK, TenDN, MatKhau, VaiTro)
-- VaiTro: 1 (Admin/Quản lý), 0 (Nhân viên)
INSERT INTO TaiKhoan (MaTK, TenDN, MatKhau, VaiTro) VALUES
('TK001', 'admin', '123456', 1),
('TK002', 'nhanvien01', '123456', 0);
GO

-- 6. Nhập bảng NhomSP (Đúng schema: MaNhom, TenNhom)
INSERT INTO NhomSP (MaNhom, TenNhom) VALUES
('CSDA', N'Mỹ phẩm chăm sóc da'),
('CSTOC', N'Sản phẩm chăm sóc tóc');
GO

-- 7. Nhập bảng LoaiSP (Đúng schema: MaLoai, TenLoai, MaNhom)
INSERT INTO LoaiSP (MaLoai, TenLoai, MaNhom) VALUES
('SRM', N'Sữa rửa mặt', 'CSDA'),
('TONER', N'Toner', 'CSDA'),
('SERUM', N'Serum', 'CSDA');
GO

-- 8. Nhập bảng TrangThai (Đúng schema: MaTT, TenTT)
INSERT INTO TrangThai (MaTT, TenTT) VALUES
('TT1', N'Còn hàng'),
('TT2', N'Cháy hàng'),
('TT3', N'Hết hàng');
GO

-- 9. Nhập bảng SanPham (Đúng schema: MaSP, TenSP, GiaBan, MaTT, MaLoai)
-- Đã lược bỏ các cột dư thừa như mô tả, thành phần... không có trong CREATE TABLE
INSERT INTO SanPham (MaSP, TenSP, GiaBan, MaTT, MaLoai) VALUES
('SP001', N'Sữa rửa mặt Innisfree', 120000, 'TT1', 'SRM'),
('SP002', N'Toner Some By Mi', 180000, 'TT1', 'TONER'),
('SP003', N'Serum La Roche-Posay', 850000, 'TT2', 'SERUM');
GO

-- 10. Nhập bảng DonMuaHang (Đúng schema: MaDMH, NgayMH, MaNCC)
INSERT INTO DonMuaHang (MaDMH, NgayMH, MaNCC) VALUES
('M2511010001', '2025-11-01', 'NCC001'),
('M2511010002', '2025-11-05', 'NCC002');
GO

-- 11. Nhập bảng DonBanHang (Đúng schema: MaDBH, NgayBH, MaKH)
INSERT INTO DonBanHang (MaDBH, NgayBH, MaKH) VALUES
('B2512010001', '2025-12-01', 'KH001'),
('B2512010002', '2025-12-02', 'KH002');
GO

-- 12. Nhập bảng CTMH (Đúng schema: MaDMH, MaSP, SLM, DGM)
INSERT INTO CTMH (MaDMH, MaSP, SLM, DGM) VALUES
('M2511010001', 'SP001', 100, 90000),
('M2511010001', 'SP002', 80, 140000);
GO

-- 13. Nhập bảng CTBH (Đúng schema: MaDBH, MaSP, SLB, DGB)
INSERT INTO CTBH (MaDBH, MaSP, SLB, DGB) VALUES
('B2512010001', 'SP001', 2, 120000),
('B2512010001', 'SP003', 1, 850000);
GO