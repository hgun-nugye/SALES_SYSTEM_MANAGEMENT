USE QuanLyTapHoa_Nhom1;
GO

CREATE TYPE CTMH_List AS TABLE
(
    MaSP VARCHAR(10),
    SLM INT,
    DGM DECIMAL(18,2)
);
GO


CREATE OR ALTER PROC DonMuaHang_Insert
(
    @NgayMH DATE,
    @MaNCC VARCHAR(10),
    @ChiTiet CTMH_List READONLY
)
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    BEGIN TRY
        BEGIN TRAN;

        DECLARE @MaDMH CHAR(11);
        DECLARE @MaxNum INT;
        DECLARE @Prefix CHAR(7);

        -- Mã: MYYMMDDxxxx (11 ký tự)
        SET @Prefix = 'M'
            + RIGHT(CAST(YEAR(@NgayMH) AS CHAR(4)),2)
            + RIGHT('0' + CAST(MONTH(@NgayMH) AS VARCHAR),2)
            + RIGHT('0' + CAST(DAY(@NgayMH) AS VARCHAR),2);

        SELECT @MaxNum = ISNULL(MAX(CAST(RIGHT(MaDMH,4) AS INT)),0)
        FROM DonMuaHang
        WHERE NgayMH = @NgayMH;

        SET @MaDMH = @Prefix + RIGHT('0000' + CAST(@MaxNum + 1 AS VARCHAR),4);

        INSERT INTO DonMuaHang(MaDMH, NgayMH, MaNCC)
        VALUES (@MaDMH, @NgayMH, @MaNCC);

        INSERT INTO CTMH(MaDMH, MaSP, SLM, DGM)
        SELECT @MaDMH, MaSP, SLM, DGM
        FROM @ChiTiet;

        COMMIT TRAN;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 ROLLBACK;
        THROW;
    END CATCH
END;
GO

CREATE OR ALTER PROC DonMuaHang_Update
(
    @MaDMH CHAR(11),
    @NgayMH DATE,
    @MaNCC VARCHAR(10),
    @ChiTiet CTMH_List READONLY
)
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    BEGIN TRY
        BEGIN TRAN;

        IF NOT EXISTS (SELECT 1 FROM DonMuaHang WHERE MaDMH = @MaDMH)
        BEGIN
            RAISERROR (N'Đơn mua hàng không tồn tại!', 16, 1);
            ROLLBACK;
            RETURN;
        END;

        UPDATE DonMuaHang
        SET NgayMH = @NgayMH,
            MaNCC = @MaNCC
        WHERE MaDMH = @MaDMH;

        DELETE FROM CTMH WHERE MaDMH = @MaDMH;

        INSERT INTO CTMH(MaDMH, MaSP, SLM, DGM)
        SELECT @MaDMH, MaSP, SLM, DGM
        FROM @ChiTiet;

        COMMIT TRAN;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 ROLLBACK;
        THROW;
    END CATCH
END;
GO

CREATE OR ALTER PROC DonMuaHang_Delete
(
    @MaDMH CHAR(11)
)
AS
BEGIN
    SET NOCOUNT ON;

    IF NOT EXISTS (SELECT 1 FROM DonMuaHang WHERE MaDMH = @MaDMH)
    BEGIN
        RAISERROR (N'Đơn mua hàng không tồn tại!', 16, 1);
        RETURN;
    END;

    DELETE FROM DonMuaHang WHERE MaDMH = @MaDMH;
END;
GO

CREATE OR ALTER PROC DonMuaHang_GetAll
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
        D.MaDMH,
        D.NgayMH,
        D.MaNCC,
        N.TenNCC,
        STRING_AGG(S.TenSP, N', ') AS TenSP,
        SUM(C.SLM * C.DGM) AS TongTien
    FROM DonMuaHang D
    JOIN NhaCC N ON N.MaNCC = D.MaNCC
    LEFT JOIN CTMH C ON C.MaDMH = D.MaDMH
    LEFT JOIN SanPham S ON S.MaSP = C.MaSP
    GROUP BY D.MaDMH, D.NgayMH, D.MaNCC, N.TenNCC
    ORDER BY D.NgayMH DESC;
END;
GO

CREATE OR ALTER PROC DonMuaHang_GetByID
(
    @MaDMH CHAR(11)
)
AS
BEGIN
    SELECT
        D.MaDMH,
        D.NgayMH,
        D.MaNCC,
        N.TenNCC,
        C.MaSP,
        S.TenSP,
        C.SLM,
        C.DGM,
        C.SLM * C.DGM AS ThanhTien
    FROM DonMuaHang D
    JOIN NhaCC N ON N.MaNCC = D.MaNCC
    LEFT JOIN CTMH C ON C.MaDMH = D.MaDMH
    LEFT JOIN SanPham S ON S.MaSP = C.MaSP
    WHERE D.MaDMH = @MaDMH;
END;
GO


CREATE OR ALTER PROC DonMuaHang_Search
(
    @Search NVARCHAR(100) = NULL,
    @Month INT = NULL,
    @Year INT = NULL,
	 @MaTTMH CHAR(3) = NULL
)
AS
BEGIN
    SET NOCOUNT ON;

    SELECT 
        D.MaDMH,
        D.NgayMH,
        D.MaNCC,
        N.TenNCC,
		
        -- Gộp tên sản phẩm
        STRING_AGG(C.MaSP, ', ') AS MaSP, 
        STRING_AGG(S.TenSP, N', ') AS TenSP,

        -- Tổng tiền
        1 AS SLM, 
        ISNULL(SUM(C.SLM * C.DGM), 0) AS DGM

    FROM DonMuaHang D
    JOIN NhaCC N ON N.MaNCC = D.MaNCC
    LEFT JOIN CTMH C ON C.MaDMH = D.MaDMH
    LEFT JOIN SanPham S ON S.MaSP = C.MaSP

    WHERE
        (
            @Search IS NULL OR @Search = '' OR
            D.MaDMH LIKE '%' + @Search + '%' OR
            N.TenNCC LIKE N'%' + @Search + '%' OR
            D.MaNCC LIKE '%' + @Search + '%' 
        )
        AND (@Month IS NULL OR MONTH(D.NgayMH) = @Month)
        AND (@Year IS NULL OR YEAR(D.NgayMH) = @Year)
    
    GROUP BY D.MaDMH, D.NgayMH, D.MaNCC, N.TenNCC
END;
GO
