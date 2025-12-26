USE QuanLyTapHoa_Nhom1;
GO

-- 2.1. Thêm mới Sản phẩm (Tự động sinh mã SP00000001)
CREATE OR ALTER PROC SanPham_Insert
(
    @TenSP NVARCHAR(50),
    @GiaBan DECIMAL(18,2),
    @MaTT CHAR(3),
    @MaLoai VARCHAR(10)
)
AS
BEGIN
    SET NOCOUNT ON;
    IF EXISTS (SELECT 1 FROM SanPham WHERE TenSP = @TenSP)
    BEGIN
        RAISERROR(N'Tên sản phẩm đã tồn tại.', 16, 1);
        RETURN;
    END;

    DECLARE @MaSP VARCHAR(10);
    DECLARE @MaxID INT;

    SELECT @MaxID = ISNULL(MAX(CAST(SUBSTRING(MaSP, 3, 8) AS INT)), 0) FROM SanPham;
    SET @MaSP = 'SP' + RIGHT('00000000' + CAST(@MaxID + 1 AS VARCHAR(8)), 8);

    INSERT INTO SanPham (MaSP, TenSP, GiaBan, MaTT, MaLoai)
    VALUES (@MaSP, @TenSP, @GiaBan, @MaTT, @MaLoai);

    SELECT @MaSP AS NewMaSP;
END;
GO

-- 2.2. Cập nhật Sản phẩm
CREATE OR ALTER PROC SanPham_Update
(
    @MaSP VARCHAR(10),
    @TenSP NVARCHAR(50),
    @GiaBan DECIMAL(18,2),
    @MaTT CHAR(3),
    @MaLoai VARCHAR(10)
)
AS
BEGIN
    SET NOCOUNT ON;
    IF EXISTS (SELECT 1 FROM SanPham WHERE TenSP = @TenSP AND MaSP <> @MaSP)
    BEGIN
        RAISERROR(N'Tên sản phẩm đã tồn tại.', 16, 1);
        RETURN;
    END;

    UPDATE SanPham
    SET TenSP = @TenSP, GiaBan = @GiaBan, MaTT = @MaTT, MaLoai = @MaLoai
    WHERE MaSP = @MaSP;
END;
GO

-- 2.3. Lấy tất cả Sản phẩm (Kèm tồn kho)
CREATE OR ALTER PROC SanPham_GetAll
AS
BEGIN
    SELECT 
        S.MaSP, S.TenSP, S.GiaBan, S.MaTT, S.MaLoai,
        L.TenLoai, TT.TenTT,
        (ISNULL((SELECT SUM(SLM) FROM CTMH WHERE MaSP = S.MaSP), 0) - 
         ISNULL((SELECT SUM(SLB) FROM CTBH WHERE MaSP = S.MaSP), 0)) AS SoLuongTon
    FROM SanPham S
    JOIN LoaiSP L ON L.MaLoai = S.MaLoai
    JOIN TrangThai TT ON TT.MaTT = S.MaTT
    ORDER BY S.MaSP DESC;
END;
GO

-- 2.4. Tìm kiếm Sản phẩm
CREATE OR ALTER PROC SanPham_Search
(
    @Search NVARCHAR(100) = NULL,
    @MaLoai VARCHAR(10) = NULL
)
AS
BEGIN
    SELECT 
        S.*, L.TenLoai, TT.TenTT,
        (ISNULL((SELECT SUM(SLM) FROM CTMH WHERE MaSP = S.MaSP), 0) - 
         ISNULL((SELECT SUM(SLB) FROM CTBH WHERE MaSP = S.MaSP), 0)) AS SoLuongTon
    FROM SanPham S
    JOIN LoaiSP L ON L.MaLoai = S.MaLoai
    JOIN TrangThai TT ON TT.MaTT = S.MaTT
    WHERE (@Search IS NULL OR S.TenSP LIKE N'%' + @Search + '%')
      AND (@MaLoai IS NULL OR S.MaLoai = @MaLoai)
END;
GO