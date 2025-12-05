CREATE DATABASE QuanLyTapHoa_nhom
GO
USE QuanLyTapHoa_nhom
GO

/*==============================================================*/
/* 1. BẢNG KHÁCH HÀNG                                           */
/*==============================================================*/
CREATE TABLE KhachHang (
   MaKH                 char(10)             not null,
   TenKH                nvarchar(50)         not null,
   SDT                  char(10)             null,
   DiemTichLuy          int                  null default 0,
   CONSTRAINT PK_KHACHHANG PRIMARY KEY (MaKH)
)
GO

/*==============================================================*/
/* 2. BẢNG NHÂN VIÊN                                            */
/*==============================================================*/
CREATE TABLE NhanVien (
   MaNV                 char(10)             not null,
   HoTen                nvarchar(50)         null,
   TaiKhoan             varchar(20)          null,
   MatKhau              varchar(50)          null,
   QuyenHan             tinyint              not null,
   SDT                  char(10)             null,
   CONSTRAINT PK_NHANVIEN PRIMARY KEY (MaNV)
)
GO

/*==============================================================*/
/* 3. BẢNG LOẠI SẢN PHẨM                                        */
/*==============================================================*/
CREATE TABLE LoaiSanPham (
   MaLoai               char(10)             not null,
   TenLoai              nvarchar(50)         null,
   CONSTRAINT PK_LOAISANPHAM PRIMARY KEY (MaLoai)
)
GO

/*==============================================================*/
/* 4. BẢNG NHÀ CUNG CẤP                                         */
/*==============================================================*/
CREATE TABLE NhaCungCap (
   MaNCC                char(10)             not null,
   TenNCC               nvarchar(100)        null,
   DiaChi               nvarchar(200)        null,
   SDT                  char(10)             null,
   CONSTRAINT PK_NHACUNGCAP PRIMARY KEY (MaNCC)
)
GO

/*==============================================================*/
/* 5. BẢNG SẢN PHẨM                                             */
/*==============================================================*/
CREATE TABLE SanPham (
   MaSP                 char(10)             not null,
   MaLoai               char(10)             null,
   TenSP                nvarchar(100)        null,
   DonViTinh            nvarchar(20)         null,
   GiaBan               decimal(18,0)        null,
   SoLuongTon           int                  null,
   CONSTRAINT PK_SANPHAM PRIMARY KEY (MaSP)
)
GO

/*==============================================================*/
/* 6. BẢNG HÓA ĐƠN                                              */
/*==============================================================*/
CREATE TABLE HoaDon (
   MaHD                 char(10)             not null,
   MaNV                 char(10)             null,
   MaKH                 char(10)             null,
   NgayLap              datetime             null default getdate(),
   TongTienHang         decimal(18,0)        null, -- Đã sửa tên cột bị lỗi
   GiamGia              decimal(18,0)        null,
   ThanhTien            decimal(18,0)        null,
   CONSTRAINT PK_HOADON PRIMARY KEY (MaHD)
)
GO

/*==============================================================*/
/* 7. BẢNG PHIẾU NHẬP HÀNG                                      */
/*==============================================================*/
CREATE TABLE PhieuNhapHang (
   MaPN                 char(20)             not null,
   MaNCC                char(10)             null,
   MaNV                 char(10)             null,
   NgayNhap             datetime             null default getdate(),
   CONSTRAINT PK_PHIEUNHAPHANG PRIMARY KEY (MaPN)
)
GO

/*==============================================================*/
/* 8. BẢNG CHI TIẾT HÓA ĐƠN                                     */
/*==============================================================*/
CREATE TABLE ChiTietHoaDon (
   MaHD                 char(10)             not null,
   MaSP                 char(10)             not null,
   SoLuong              int                  null,
   DonGia               decimal(18,0)        null,
   ThanhTien            decimal(18,0)        null,
   CONSTRAINT PK_CHITIETHOADON PRIMARY KEY (MaHD, MaSP)
)
GO

/*==============================================================*/
/* 9. BẢNG CHI TIẾT PHIẾU NHẬP                                  */
/*==============================================================*/
CREATE TABLE ChiTietPhieuNhap (
   MaPN                 char(20)             not null,
   MaSP                 char(10)             not null,
   SoLuong              int                  null,
   GiaNhap              decimal(18,0)        null,
   CONSTRAINT PK_CHITIETPHIEUNHAP PRIMARY KEY (MaPN, MaSP)
)
GO

/*==============================================================*/
/* TẠO CÁC KHÓA NGOẠI (FOREIGN KEYS)                            */
/*==============================================================*/

-- Khóa ngoại cho Sản Phẩm (Nối với Loại)
ALTER TABLE SanPham
   ADD CONSTRAINT FK_SANPHAM_LOAISANPHAM FOREIGN KEY (MaLoai)
      REFERENCES LoaiSanPham (MaLoai)
GO

-- Khóa ngoại cho Hóa Đơn (Nối với NV và KH)
ALTER TABLE HoaDon
   ADD CONSTRAINT FK_HOADON_NHANVIEN FOREIGN KEY (MaNV)
      REFERENCES NhanVien (MaNV)
GO

ALTER TABLE HoaDon
   ADD CONSTRAINT FK_HOADON_KHACHHANG FOREIGN KEY (MaKH)
      REFERENCES KhachHang (MaKH)
GO

-- Khóa ngoại cho Phiếu Nhập (Nối với NCC và NV)
ALTER TABLE PhieuNhapHang
   ADD CONSTRAINT FK_PHIEUNHAP_NHACUNGCAP FOREIGN KEY (MaNCC)
      REFERENCES NhaCungCap (MaNCC)
GO

ALTER TABLE PhieuNhapHang
   ADD CONSTRAINT FK_PHIEUNHAP_NHANVIEN FOREIGN KEY (MaNV)
      REFERENCES NhanVien (MaNV)
GO

-- Khóa ngoại cho Chi Tiết Hóa Đơn
ALTER TABLE ChiTietHoaDon
   ADD CONSTRAINT FK_CHITIET_HOADON FOREIGN KEY (MaHD)
      REFERENCES HoaDon (MaHD)
GO

ALTER TABLE ChiTietHoaDon
   ADD CONSTRAINT FK_CHITIET_SANPHAM_HD FOREIGN KEY (MaSP)
      REFERENCES SanPham (MaSP)
GO

-- Khóa ngoại cho Chi Tiết Phiếu Nhập
ALTER TABLE ChiTietPhieuNhap
   ADD CONSTRAINT FK_CHITIET_PHIEUNHAP FOREIGN KEY (MaPN)
      REFERENCES PhieuNhapHang (MaPN)
GO

ALTER TABLE ChiTietPhieuNhap
   ADD CONSTRAINT FK_CHITIET_SANPHAM_PN FOREIGN KEY (MaSP)
      REFERENCES SanPham (MaSP)
GO