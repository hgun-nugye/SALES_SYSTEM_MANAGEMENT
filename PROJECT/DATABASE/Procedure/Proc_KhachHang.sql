USE QuanLyTapHoa_Nhom1;
GO

-- 1. Thêm khách hàng (Tự động sinh mã KH00000001)
CREATE OR ALTER PROC KhachHang_Insert
(
    @TenKH NVARCHAR(100),
    @AnhKH NVARCHAR(255),
    @GioiTinh BIT,
    @DienThoaiKH VARCHAR(10), -- Sửa lại 10 số theo DB
    @EmailKH NVARCHAR(255),
    @DiaChiKH NVARCHAR(255),
    @MaXa INT
)
AS
BEGIN
    SET NOCOUNT ON;

    -- Kiểm tra trùng Số điện thoại
    IF EXISTS (SELECT 1 FROM KhachHang WHERE DienThoaiKH = @DienThoaiKH)
    BEGIN
        RAISERROR(N'Số điện thoại đã tồn tại.', 16, 1);
        RETURN;
    END;

    -- Kiểm tra trùng Email
    IF EXISTS (SELECT 1 FROM KhachHang WHERE EmailKH = @EmailKH AND @EmailKH IS NOT NULL)
    BEGIN
        RAISERROR(N'Email đã tồn tại.', 16, 1);
        RETURN;
    END;

    DECLARE @MaKH VARCHAR(10);
    DECLARE @MaxID INT;

    -- Lấy số lớn nhất từ MaKH
    SELECT @MaxID = ISNULL(MAX(CAST(SUBSTRING(MaKH, 3, 8) AS INT)), 0)
    FROM KhachHang;

    SET @MaKH = 'KH' + RIGHT('00000000' + CAST(@MaxID + 1 AS VARCHAR(8)), 8);

    INSERT INTO KhachHang (MaKH, TenKH, AnhKH, GioiTinh, EmailKH, DienThoaiKH, DiaChiKH, MaXa)
    VALUES (@MaKH, @TenKH, @AnhKH, @GioiTinh, @EmailKH, @DienThoaiKH, @DiaChiKH, @MaXa);

    PRINT N'Thêm khách hàng thành công! Mã: ' + @MaKH;
END;
GO

-- 2. Cập nhật khách hàng
CREATE OR ALTER PROC KhachHang_Update
(
    @MaKH VARCHAR(10),
    @TenKH NVARCHAR(100),
    @AnhKH NVARCHAR(255),
    @GioiTinh BIT,
    @DienThoaiKH VARCHAR(10),
    @EmailKH NVARCHAR(255),
    @DiaChiKH NVARCHAR(255),
    @MaXa INT
)
AS
BEGIN
    SET NOCOUNT ON;

    IF NOT EXISTS (SELECT 1 FROM KhachHang WHERE MaKH = @MaKH)
    BEGIN
        RAISERROR(N'Không tìm thấy khách hàng.', 16, 1);
        RETURN;
    END;

    -- Kiểm tra trùng SDT với người khác
    IF EXISTS (SELECT 1 FROM KhachHang WHERE DienThoaiKH = @DienThoaiKH AND MaKH <> @MaKH)
    BEGIN
        RAISERROR(N'Số điện thoại đã được sử dụng.', 16, 1);
        RETURN;
    END;

    UPDATE KhachHang
    SET TenKH = @TenKH,
        AnhKH = @AnhKH,
        GioiTinh = @GioiTinh,
        DienThoaiKH = @DienThoaiKH,
        EmailKH = @EmailKH,
        DiaChiKH = @DiaChiKH,
        MaXa = @MaXa
    WHERE MaKH = @MaKH;

    PRINT N'Cập nhật khách hàng thành công!';
END;
GO

-- 3. Xóa khách hàng (Có kiểm tra đơn hàng)
CREATE OR ALTER PROC KhachHang_Delete
(
    @MaKH VARCHAR(10)
)
AS
BEGIN
    SET NOCOUNT ON;

    -- Kiểm tra xem khách hàng có đơn hàng nào không
    IF EXISTS (SELECT 1 FROM DonBanHang WHERE MaKH = @MaKH)
    BEGIN
        RAISERROR(N'Khách hàng đã có lịch sử mua hàng, không thể xóa!', 16, 1);
        RETURN;
    END;

    DELETE FROM KhachHang WHERE MaKH = @MaKH;
    PRINT N'Xóa khách hàng thành công!';
END;
GO

-- 4. Tìm kiếm khách hàng nâng cao
CREATE OR ALTER PROC KhachHang_Search
(
    @Search NVARCHAR(200) = NULL,
    @MaTinh SMALLINT = NULL,
    @GioiTinh BIT = NULL
)
AS
BEGIN
    SET NOCOUNT ON;
    SELECT 
        KH.MaKH, KH.TenKH, KH.AnhKH, KH.GioiTinh, 
        KH.DienThoaiKH, KH.EmailKH, KH.DiaChiKH,
        X.TenXa, T.TenTinh
    FROM KhachHang KH
    LEFT JOIN Xa X ON KH.MaXa = X.MaXa
    LEFT JOIN Tinh T ON X.MaTinh = T.MaTinh
    WHERE
        (
            @Search IS NULL OR @Search = '' OR
            KH.TenKH LIKE N'%' + @Search + '%' OR
            KH.EmailKH LIKE N'%' + @Search + '%' OR
            KH.DienThoaiKH LIKE N'%' + @Search + '%'
        )
        AND (@MaTinh IS NULL OR T.MaTinh = @MaTinh)
        AND (@GioiTinh IS NULL OR KH.GioiTinh = @GioiTinh)
    ORDER BY KH.MaKH DESC;
END;
GO

-- 5. Lấy khách hàng theo ID kèm thông tin Tỉnh/Xã
CREATE OR ALTER PROC KhachHang_GetByID
(
    @MaKH VARCHAR(10)
)
AS
BEGIN
    SELECT 
        KH.*, X.TenXa, T.TenTinh
    FROM KhachHang KH
    LEFT JOIN Xa X ON KH.MaXa = X.MaXa
    LEFT JOIN Tinh T ON X.MaTinh = T.MaTinh
    WHERE KH.MaKH = @MaKH;
END;
GO