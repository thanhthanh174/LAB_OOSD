/*
    BAI LAB 2 - HE THONG QUAN LY CUA HANG NUOC GIAI KHAT
    SQL Server script: tao database, bang va du lieu mau.

    Cach chay:
    1. Mo SQL Server Management Studio (SSMS).
    2. Mo file nay va nhan Execute (F5).
    3. Database QuanLyCuaHangNGK se duoc tao neu chua ton tai.

    Luu y:
    - Script khong xoa database cu.
    - Cac bang va du lieu mau chi duoc tao/chen neu chua ton tai.
*/

IF DB_ID(N'QuanLyCuaHangNGK') IS NULL
    CREATE DATABASE QuanLyCuaHangNGK;
GO

USE QuanLyCuaHangNGK;
GO

/* 1. Nhan hieu */
IF OBJECT_ID(N'dbo.NhanHieu', N'U') IS NULL
BEGIN
    CREATE TABLE dbo.NhanHieu
    (
        MaNhanHieu VARCHAR(10) NOT NULL PRIMARY KEY,
        TenNhanHieu NVARCHAR(100) NOT NULL
    );
END
GO

/* 2. Nha cung ung */
IF OBJECT_ID(N'dbo.NhaCungUng', N'U') IS NULL
BEGIN
    CREATE TABLE dbo.NhaCungUng
    (
        MaNCC VARCHAR(10) NOT NULL PRIMARY KEY,
        TenNCC NVARCHAR(150) NOT NULL,
        DiaChi NVARCHAR(250) NULL,
        SoDienThoai VARCHAR(20) NULL
    );
END
GO

/* 3. Nhan vien */
IF OBJECT_ID(N'dbo.NhanVien', N'U') IS NULL
BEGIN
    CREATE TABLE dbo.NhanVien
    (
        MaNV VARCHAR(10) NOT NULL PRIMARY KEY,
        HoTen NVARCHAR(100) NOT NULL,
        SoDienThoai VARCHAR(20) NULL,
        DiaChi NVARCHAR(250) NULL
    );
END
GO

/* 4. Nuoc giai khat */
IF OBJECT_ID(N'dbo.NuocGiaiKhat', N'U') IS NULL
BEGIN
    CREATE TABLE dbo.NuocGiaiKhat
    (
        MaNGK VARCHAR(10) NOT NULL PRIMARY KEY,
        TenNGK NVARCHAR(150) NOT NULL,
        MaNhanHieu VARCHAR(10) NOT NULL,
        DonViTinh NVARCHAR(30) NOT NULL,
        MaNCC VARCHAR(10) NOT NULL,
        SoLuongTon INT NOT NULL CONSTRAINT DF_NGK_SoLuongTon DEFAULT (0),
        DonGia DECIMAL(18,0) NOT NULL,
        CONSTRAINT CK_NGK_SoLuongTon CHECK (SoLuongTon >= 0),
        CONSTRAINT CK_NGK_DonGia CHECK (DonGia > 0),
        CONSTRAINT FK_NGK_NhanHieu FOREIGN KEY (MaNhanHieu)
            REFERENCES dbo.NhanHieu(MaNhanHieu),
        CONSTRAINT FK_NGK_NhaCungUng FOREIGN KEY (MaNCC)
            REFERENCES dbo.NhaCungUng(MaNCC)
    );
END
GO

/* 5. Don dat hang */
IF OBJECT_ID(N'dbo.DonDatHang', N'U') IS NULL
BEGIN
    CREATE TABLE dbo.DonDatHang
    (
        MaDDH VARCHAR(10) NOT NULL PRIMARY KEY,
        MaNCC VARCHAR(10) NOT NULL,
        MaNV VARCHAR(10) NOT NULL,
        NgayDat DATE NOT NULL,
        NgayNhanDuKien DATE NULL,
        TrangThai NVARCHAR(30) NOT NULL DEFAULT N'ChoGiao',
        CONSTRAINT FK_DDH_NCC FOREIGN KEY (MaNCC) REFERENCES dbo.NhaCungUng(MaNCC),
        CONSTRAINT FK_DDH_NV FOREIGN KEY (MaNV) REFERENCES dbo.NhanVien(MaNV)
    );
END
GO

/* 6. Chi tiet don dat hang */
IF OBJECT_ID(N'dbo.ChiTietDonDatHang', N'U') IS NULL
BEGIN
    CREATE TABLE dbo.ChiTietDonDatHang
    (
        MaDDH VARCHAR(10) NOT NULL,
        MaNGK VARCHAR(10) NOT NULL,
        SoLuongDat INT NOT NULL,
        DonGiaNhap DECIMAL(18,0) NOT NULL,
        PRIMARY KEY (MaDDH, MaNGK),
        CONSTRAINT CK_CTDH_SoLuong CHECK (SoLuongDat > 0),
        CONSTRAINT CK_CTDH_DonGia CHECK (DonGiaNhap > 0),
        CONSTRAINT FK_CTDH_DDH FOREIGN KEY (MaDDH) REFERENCES dbo.DonDatHang(MaDDH),
        CONSTRAINT FK_CTDH_NGK FOREIGN KEY (MaNGK) REFERENCES dbo.NuocGiaiKhat(MaNGK)
    );
END
GO

/* 7. Phieu giao hang: moi don dat hang toi da 3 dot giao */
IF OBJECT_ID(N'dbo.PhieuGiaoHang', N'U') IS NULL
BEGIN
    CREATE TABLE dbo.PhieuGiaoHang
    (
        MaPGH VARCHAR(10) NOT NULL PRIMARY KEY,
        MaDDH VARCHAR(10) NOT NULL,
        DotGiao TINYINT NOT NULL,
        NgayGiao DATE NOT NULL,
        SoTienPhaiTra DECIMAL(18,0) NOT NULL,
        CONSTRAINT UQ_PGH_DDH_Dot UNIQUE (MaDDH, DotGiao),
        CONSTRAINT CK_PGH_Dot CHECK (DotGiao BETWEEN 1 AND 3),
        CONSTRAINT CK_PGH_SoTien CHECK (SoTienPhaiTra >= 0),
        CONSTRAINT FK_PGH_DDH FOREIGN KEY (MaDDH) REFERENCES dbo.DonDatHang(MaDDH)
    );
END
GO

/* 8. Chi tiet phieu giao hang */
IF OBJECT_ID(N'dbo.ChiTietPhieuGiaoHang', N'U') IS NULL
BEGIN
    CREATE TABLE dbo.ChiTietPhieuGiaoHang
    (
        MaPGH VARCHAR(10) NOT NULL,
        MaNGK VARCHAR(10) NOT NULL,
        SoLuongGiao INT NOT NULL,
        DonGiaNhap DECIMAL(18,0) NOT NULL,
        PRIMARY KEY (MaPGH, MaNGK),
        CONSTRAINT CK_CTPGH_SoLuong CHECK (SoLuongGiao > 0),
        CONSTRAINT CK_CTPGH_DonGia CHECK (DonGiaNhap > 0),
        CONSTRAINT FK_CTPGH_PGH FOREIGN KEY (MaPGH) REFERENCES dbo.PhieuGiaoHang(MaPGH),
        CONSTRAINT FK_CTPGH_NGK FOREIGN KEY (MaNGK) REFERENCES dbo.NuocGiaiKhat(MaNGK)
    );
END
GO

/* 9. Khach hang */
IF OBJECT_ID(N'dbo.KhachHang', N'U') IS NULL
BEGIN
    CREATE TABLE dbo.KhachHang
    (
        MaKH VARCHAR(10) NOT NULL PRIMARY KEY,
        HoTen NVARCHAR(100) NOT NULL,
        SoDienThoai VARCHAR(20) NULL,
        DiaChi NVARCHAR(250) NULL,
        LoaiKhach NVARCHAR(20) NOT NULL DEFAULT N'VangLai',
        CONSTRAINT CK_KH_Loai CHECK (LoaiKhach IN (N'VangLai', N'KhachQuen'))
    );
END
GO

/* 10. Hoa don */
IF OBJECT_ID(N'dbo.HoaDon', N'U') IS NULL
BEGIN
    CREATE TABLE dbo.HoaDon
    (
        MaHD VARCHAR(10) NOT NULL PRIMARY KEY,
        MaKH VARCHAR(10) NULL,
        MaNV VARCHAR(10) NOT NULL,
        NgayLap DATE NOT NULL,
        TongTien DECIMAL(18,0) NOT NULL DEFAULT (0),
        TrangThai NVARCHAR(30) NOT NULL DEFAULT N'ChuaThanhToan',
        CONSTRAINT FK_HD_KH FOREIGN KEY (MaKH) REFERENCES dbo.KhachHang(MaKH),
        CONSTRAINT FK_HD_NV FOREIGN KEY (MaNV) REFERENCES dbo.NhanVien(MaNV),
        CONSTRAINT CK_HD_TongTien CHECK (TongTien >= 0)
    );
END
GO

/* 11. Chi tiet hoa don */
IF OBJECT_ID(N'dbo.ChiTietHoaDon', N'U') IS NULL
BEGIN
    CREATE TABLE dbo.ChiTietHoaDon
    (
        MaHD VARCHAR(10) NOT NULL,
        MaNGK VARCHAR(10) NOT NULL,
        SoLuong INT NOT NULL,
        DonGia DECIMAL(18,0) NOT NULL,
        PRIMARY KEY (MaHD, MaNGK),
        CONSTRAINT CK_CTHD_SoLuong CHECK (SoLuong > 0),
        CONSTRAINT CK_CTHD_DonGia CHECK (DonGia > 0),
        CONSTRAINT FK_CTHD_HD FOREIGN KEY (MaHD) REFERENCES dbo.HoaDon(MaHD),
        CONSTRAINT FK_CTHD_NGK FOREIGN KEY (MaNGK) REFERENCES dbo.NuocGiaiKhat(MaNGK)
    );
END
GO

/* 12. Phieu hen giao hang cho khach quen */
IF OBJECT_ID(N'dbo.PhieuHenGiaoHang', N'U') IS NULL
BEGIN
    CREATE TABLE dbo.PhieuHenGiaoHang
    (
        MaPhieuHen VARCHAR(10) NOT NULL PRIMARY KEY,
        MaHD VARCHAR(10) NOT NULL,
        NgayHen DATE NOT NULL,
        TrangThai NVARCHAR(30) NOT NULL DEFAULT N'ChoGiao',
        GhiChu NVARCHAR(250) NULL,
        CONSTRAINT FK_PHG_HD FOREIGN KEY (MaHD) REFERENCES dbo.HoaDon(MaHD)
    );
END
GO

/* 13. Chi tiet phieu hen giao hang */
IF OBJECT_ID(N'dbo.ChiTietPhieuHenGiaoHang', N'U') IS NULL
BEGIN
    CREATE TABLE dbo.ChiTietPhieuHenGiaoHang
    (
        MaPhieuHen VARCHAR(10) NOT NULL,
        MaNGK VARCHAR(10) NOT NULL,
        SoLuongHen INT NOT NULL,
        PRIMARY KEY (MaPhieuHen, MaNGK),
        CONSTRAINT CK_CTPH_SoLuong CHECK (SoLuongHen > 0),
        CONSTRAINT FK_CTPH_PH FOREIGN KEY (MaPhieuHen) REFERENCES dbo.PhieuHenGiaoHang(MaPhieuHen),
        CONSTRAINT FK_CTPH_NGK FOREIGN KEY (MaNGK) REFERENCES dbo.NuocGiaiKhat(MaNGK)
    );
END
GO

/* 14. Phieu ghi no cho khach quen */
IF OBJECT_ID(N'dbo.PhieuGhiNo', N'U') IS NULL
BEGIN
    CREATE TABLE dbo.PhieuGhiNo
    (
        MaPhieuNo VARCHAR(10) NOT NULL PRIMARY KEY,
        MaHD VARCHAR(10) NOT NULL,
        MaKH VARCHAR(10) NOT NULL,
        MaNV VARCHAR(10) NOT NULL,
        NgayLap DATE NOT NULL,
        SoTienNo DECIMAL(18,0) NOT NULL,
        NgayDuKienTra DATE NULL,
        LyDo NVARCHAR(250) NULL,
        TrangThai NVARCHAR(30) NOT NULL DEFAULT N'ChuaTra',
        CONSTRAINT CK_PGN_SoTien CHECK (SoTienNo > 0),
        CONSTRAINT FK_PGN_HD FOREIGN KEY (MaHD) REFERENCES dbo.HoaDon(MaHD),
        CONSTRAINT FK_PGN_KH FOREIGN KEY (MaKH) REFERENCES dbo.KhachHang(MaKH),
        CONSTRAINT FK_PGN_NV FOREIGN KEY (MaNV) REFERENCES dbo.NhanVien(MaNV)
    );
END
GO

/* DU LIEU MAU */
IF NOT EXISTS (SELECT 1 FROM dbo.NhanHieu WHERE MaNhanHieu = 'NH001')
    INSERT dbo.NhanHieu (MaNhanHieu, TenNhanHieu) VALUES ('NH001', N'Pepsi');
IF NOT EXISTS (SELECT 1 FROM dbo.NhanHieu WHERE MaNhanHieu = 'NH002')
    INSERT dbo.NhanHieu (MaNhanHieu, TenNhanHieu) VALUES ('NH002', N'Coca Cola');
IF NOT EXISTS (SELECT 1 FROM dbo.NhanHieu WHERE MaNhanHieu = 'NH003')
    INSERT dbo.NhanHieu (MaNhanHieu, TenNhanHieu) VALUES ('NH003', N'Sting');
GO

IF NOT EXISTS (SELECT 1 FROM dbo.NhaCungUng WHERE MaNCC = 'NCC001')
    INSERT dbo.NhaCungUng (MaNCC, TenNCC, DiaChi, SoDienThoai)
    VALUES ('NCC001', N'Công ty TNHH Minh Phát', N'TP. Hồ Chí Minh', '0909000001');
IF NOT EXISTS (SELECT 1 FROM dbo.NhaCungUng WHERE MaNCC = 'NCC002')
    INSERT dbo.NhaCungUng (MaNCC, TenNCC, DiaChi, SoDienThoai)
    VALUES ('NCC002', N'Công ty TNHH Phân phối An Phú', N'TP. Hồ Chí Minh', '0909000002');
GO

IF NOT EXISTS (SELECT 1 FROM dbo.NhanVien WHERE MaNV = 'NV001')
    INSERT dbo.NhanVien (MaNV, HoTen, SoDienThoai, DiaChi)
    VALUES ('NV001', N'Nguyễn Văn An', '0911000001', N'TP. Hồ Chí Minh');
IF NOT EXISTS (SELECT 1 FROM dbo.NhanVien WHERE MaNV = 'NV002')
    INSERT dbo.NhanVien (MaNV, HoTen, SoDienThoai, DiaChi)
    VALUES ('NV002', N'Trần Thị Bình', '0911000002', N'TP. Hồ Chí Minh');
GO

IF NOT EXISTS (SELECT 1 FROM dbo.NuocGiaiKhat WHERE MaNGK = 'NGK001')
    INSERT dbo.NuocGiaiKhat (MaNGK, TenNGK, MaNhanHieu, DonViTinh, MaNCC, SoLuongTon, DonGia)
    VALUES ('NGK001', N'Pepsi Cola', 'NH001', N'Lon', 'NCC001', 120, 10000);
IF NOT EXISTS (SELECT 1 FROM dbo.NuocGiaiKhat WHERE MaNGK = 'NGK002')
    INSERT dbo.NuocGiaiKhat (MaNGK, TenNGK, MaNhanHieu, DonViTinh, MaNCC, SoLuongTon, DonGia)
    VALUES ('NGK002', N'Coca Cola', 'NH002', N'Lon', 'NCC002', 80, 12000);
IF NOT EXISTS (SELECT 1 FROM dbo.NuocGiaiKhat WHERE MaNGK = 'NGK003')
    INSERT dbo.NuocGiaiKhat (MaNGK, TenNGK, MaNhanHieu, DonViTinh, MaNCC, SoLuongTon, DonGia)
    VALUES ('NGK003', N'Sting', 'NH003', N'Lon', 'NCC001', 60, 9000);
GO

IF NOT EXISTS (SELECT 1 FROM dbo.KhachHang WHERE MaKH = 'KH001')
    INSERT dbo.KhachHang (MaKH, HoTen, SoDienThoai, DiaChi, LoaiKhach)
    VALUES ('KH001', N'Nguyễn Minh Anh', '0933000001', N'TP. Hồ Chí Minh', N'KhachQuen');
IF NOT EXISTS (SELECT 1 FROM dbo.KhachHang WHERE MaKH = 'KH002')
    INSERT dbo.KhachHang (MaKH, HoTen, SoDienThoai, DiaChi, LoaiKhach)
    VALUES ('KH002', N'Trần Quốc Bảo', '0933000002', N'TP. Hồ Chí Minh', N'KhachQuen');
IF NOT EXISTS (SELECT 1 FROM dbo.KhachHang WHERE MaKH = 'KH003')
    INSERT dbo.KhachHang (MaKH, HoTen, SoDienThoai, DiaChi, LoaiKhach)
    VALUES ('KH003', N'Lê Thu Hà', '0933000003', N'TP. Hồ Chí Minh', N'VangLai');
GO

IF NOT EXISTS (SELECT 1 FROM dbo.DonDatHang WHERE MaDDH = 'DDH001')
BEGIN
    INSERT dbo.DonDatHang (MaDDH, MaNCC, MaNV, NgayDat, NgayNhanDuKien, TrangThai)
    VALUES ('DDH001', 'NCC001', 'NV001', '20261001', '20261003', N'DaDat');
    INSERT dbo.ChiTietDonDatHang (MaDDH, MaNGK, SoLuongDat, DonGiaNhap)
    VALUES ('DDH001', 'NGK001', 100, 8000),
           ('DDH001', 'NGK003', 50, 7000);
END
GO

IF NOT EXISTS (SELECT 1 FROM dbo.PhieuGiaoHang WHERE MaPGH = 'PGH001')
BEGIN
    INSERT dbo.PhieuGiaoHang (MaPGH, MaDDH, DotGiao, NgayGiao, SoTienPhaiTra)
    VALUES ('PGH001', 'DDH001', 1, '20261003', 1150000);
    INSERT dbo.ChiTietPhieuGiaoHang (MaPGH, MaNGK, SoLuongGiao, DonGiaNhap)
    VALUES ('PGH001', 'NGK001', 100, 8000),
           ('PGH001', 'NGK003', 50, 7000);
END
GO

IF NOT EXISTS (SELECT 1 FROM dbo.HoaDon WHERE MaHD = 'HD001')
BEGIN
    INSERT dbo.HoaDon (MaHD, MaKH, MaNV, NgayLap, TongTien, TrangThai)
    VALUES ('HD001', 'KH001', 'NV001', '20261025', 30000, N'DaThanhToan');
    INSERT dbo.ChiTietHoaDon (MaHD, MaNGK, SoLuong, DonGia)
    VALUES ('HD001', 'NGK001', 3, 10000);
END
GO

IF NOT EXISTS (SELECT 1 FROM dbo.HoaDon WHERE MaHD = 'HD002')
BEGIN
    INSERT dbo.HoaDon (MaHD, MaKH, MaNV, NgayLap, TongTien, TrangThai)
    VALUES ('HD002', 'KH002', 'NV002', '20261027', 48000, N'DaThanhToan');
    INSERT dbo.ChiTietHoaDon (MaHD, MaNGK, SoLuong, DonGia)
    VALUES ('HD002', 'NGK002', 4, 12000);
END
GO

IF NOT EXISTS (SELECT 1 FROM dbo.HoaDon WHERE MaHD = 'HD003')
BEGIN
    INSERT dbo.HoaDon (MaHD, MaKH, MaNV, NgayLap, TongTien, TrangThai)
    VALUES ('HD003', 'KH003', 'NV001', '20261028', 20000, N'DaThanhToan');
    INSERT dbo.ChiTietHoaDon (MaHD, MaNGK, SoLuong, DonGia)
    VALUES ('HD003', 'NGK003', 2, 10000);
END
GO

/* Truy van kiem tra nhanh */
SELECT 'NhanHieu' AS Bang, COUNT(*) AS SoDong FROM dbo.NhanHieu
UNION ALL SELECT 'NhaCungUng', COUNT(*) FROM dbo.NhaCungUng
UNION ALL SELECT 'NhanVien', COUNT(*) FROM dbo.NhanVien
UNION ALL SELECT 'NuocGiaiKhat', COUNT(*) FROM dbo.NuocGiaiKhat
UNION ALL SELECT 'DonDatHang', COUNT(*) FROM dbo.DonDatHang
UNION ALL SELECT 'PhieuGiaoHang', COUNT(*) FROM dbo.PhieuGiaoHang
UNION ALL SELECT 'KhachHang', COUNT(*) FROM dbo.KhachHang
UNION ALL SELECT 'HoaDon', COUNT(*) FROM dbo.HoaDon;
GO
