USE QuanLyTapHoa_Nhom1;
GO

CREATE TYPE dbo.CTBH_List AS TABLE
(
    MaSP VARCHAR(10),
    SLB INT,
    DGB DECIMAL(18,2)
);
GO
CREATE OR ALTER PROC DonBanHang_Insert
(
    @NgayBH DATE,
    @MaKH VARCHAR(10),
    @ChiTiet CTBH_List READONLY
)
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    BEGIN TRY
        BEGIN TRAN;

        DECLARE @MaDBH CHAR(11);
        DECLARE @MaxNum INT;
        DECLARE @Prefix CHAR(7);

        -- B + YYMMDD + xxxx
        SET @Prefix = 'B'
            + RIGHT(CAST(YEAR(@NgayBH) AS CHAR(4)),2)
            + RIGHT('0' + CAST(MONTH(@NgayBH) AS VARCHAR),2)
            + RIGHT('0' + CAST(DAY(@NgayBH) AS VARCHAR),2);

        SELECT @MaxNum = ISNULL(MAX(CAST(RIGHT(MaDBH,4) AS INT)),0)
        FROM DonBanHang
        WHERE NgayBH = @NgayBH;

        SET @MaDBH = @Prefix + RIGHT('0000' + CAST(@MaxNum + 1 AS VARCHAR),4);

        INSERT INTO DonBanHang(MaDBH, NgayBH, MaKH)
        VALUES (@MaDBH, @NgayBH, @MaKH);

        INSERT INTO CTBH(MaDBH, MaSP, SLB, DGB)
        SELECT @MaDBH, MaSP, SLB, DGB
        FROM @ChiTiet;

        COMMIT;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 ROLLBACK;
        THROW;
    END CATCH
END;
GO

CREATE OR ALTER PROC DonBanHang_Update
(
    @MaDBH CHAR(11),
    @NgayBH DATE,
    @MaKH VARCHAR(10),
    @ChiTiet CTBH_List READONLY
)
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    BEGIN TRY
        BEGIN TRAN;

        IF NOT EXISTS (SELECT 1 FROM DonBanHang WHERE MaDBH = @MaDBH)
        BEGIN
            RAISERROR (N'Đơn bán hàng không tồn tại!',16,1);
            ROLLBACK;
            RETURN;
        END;

        UPDATE DonBanHang
        SET NgayBH = @NgayBH,
            MaKH = @MaKH
        WHERE MaDBH = @MaDBH;

        DELETE FROM CTBH WHERE MaDBH = @MaDBH;

        INSERT INTO CTBH(MaDBH, MaSP, SLB, DGB)
        SELECT @MaDBH, MaSP, SLB, DGB
        FROM @ChiTiet;

        COMMIT;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 ROLLBACK;
        THROW;
    END CATCH
END;
GO

CREATE OR ALTER PROC DonBanHang_Delete
(
    @MaDBH CHAR(11)
)
AS
BEGIN
    SET NOCOUNT ON;

    IF NOT EXISTS (SELECT 1 FROM DonBanHang WHERE MaDBH = @MaDBH)
    BEGIN
        RAISERROR (N'Đơn bán hàng không tồn tại!',16,1);
        RETURN;
    END;

    DELETE FROM DonBanHang WHERE MaDBH = @MaDBH;
END;
GO

CREATE OR ALTER PROC DonBanHang_GetAll
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
        D.MaDBH,
        D.NgayBH,
        D.MaKH,
        K.TenKH,
        STRING_AGG(S.TenSP, N', ') AS TenSP,
        SUM(C.SLB * C.DGB) AS TongTien
    FROM DonBanHang D
    JOIN KhachHang K ON K.MaKH = D.MaKH
    LEFT JOIN CTBH C ON C.MaDBH = D.MaDBH
    LEFT JOIN SanPham S ON S.MaSP = C.MaSP
    GROUP BY D.MaDBH, D.NgayBH, D.MaKH, K.TenKH
    ORDER BY D.NgayBH DESC;
END;
GO

CREATE OR ALTER PROC DonBanHang_GetByID
(
    @MaDBH CHAR(11)
)
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
        D.MaDBH,
        D.NgayBH,
        D.MaKH,
        K.TenKH,
        C.MaSP,
        S.TenSP,
        C.SLB,
        C.DGB,
        C.SLB * C.DGB AS ThanhTien
    FROM DonBanHang D
    JOIN KhachHang K ON K.MaKH = D.MaKH
    JOIN CTBH C ON C.MaDBH = D.MaDBH
    JOIN SanPham S ON S.MaSP = C.MaSP
    WHERE D.MaDBH = @MaDBH;
END;
GO

CREATE OR ALTER PROC DonBanHang_Search
(
    @Search NVARCHAR(100) = NULL,
    @Month INT = NULL,
    @Year INT = NULL
)
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
        D.MaDBH,
        D.NgayBH,
        D.MaKH,
        K.TenKH,
        STRING_AGG(S.TenSP, N', ') AS TenSP,
        SUM(C.SLB * C.DGB) AS TongTien
    FROM DonBanHang D
    JOIN KhachHang K ON K.MaKH = D.MaKH
    LEFT JOIN CTBH C ON C.MaDBH = D.MaDBH
    LEFT JOIN SanPham S ON S.MaSP = C.MaSP
    WHERE
        (@Search IS NULL OR
         D.MaDBH LIKE '%' + @Search + '%' OR
         K.TenKH LIKE N'%' + @Search + '%')
        AND (@Month IS NULL OR MONTH(D.NgayBH) = @Month)
        AND (@Year IS NULL OR YEAR(D.NgayBH) = @Year)
    GROUP BY D.MaDBH, D.NgayBH, D.MaKH, K.TenKH
    ORDER BY D.NgayBH DESC;
END;
GO

