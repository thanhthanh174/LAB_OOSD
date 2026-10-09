IF DB_ID(N'QuanLyDuLich') IS NULL
    CREATE DATABASE QuanLyDuLich;
GO
USE QuanLyDuLich;
GO

/* ---------- 1. NHOM TOUR ---------- */
CREATE TABLE Tour (
    maTour   VARCHAR(10)   NOT NULL PRIMARY KEY,
    tenTour  NVARCHAR(100) NOT NULL,
    soNgay   INT           NOT NULL CHECK (soNgay > 0),
    soDem    INT           NOT NULL CHECK (soDem >= 0),
    donGia   DECIMAL(18,0) NOT NULL CHECK (donGia > 0)
);

CREATE TABLE PhuongTien (
    maPhuongTien  VARCHAR(10)  NOT NULL PRIMARY KEY,
    tenPhuongTien NVARCHAR(50) NOT NULL
);

CREATE TABLE DiemThamQuan (
    maDiem   VARCHAR(10)   NOT NULL PRIMARY KEY,
    tenDiem  NVARCHAR(100) NOT NULL,
    diaDiem  NVARCHAR(100) NOT NULL,
    noiDung  NVARCHAR(500) NULL,
    yNghia   NVARCHAR(500) NULL
);

-- Quan he nhieu-nhieu Tour <-> DiemThamQuan
CREATE TABLE TourDiemThamQuan (
    maTour VARCHAR(10) NOT NULL REFERENCES Tour(maTour),
    maDiem VARCHAR(10) NOT NULL REFERENCES DiemThamQuan(maDiem),
    PRIMARY KEY (maTour, maDiem)
);

-- Noi dung chan thuoc Tour (composition), di toi bang 1 phuong tien
CREATE TABLE NoiDungChan (
    maNoiDung     VARCHAR(10)  NOT NULL PRIMARY KEY,
    maTour        VARCHAR(10)  NOT NULL REFERENCES Tour(maTour) ON DELETE CASCADE,
    maPhuongTien  VARCHAR(10)  NOT NULL REFERENCES PhuongTien(maPhuongTien),
    tenNoiDen     NVARCHAR(100) NOT NULL,
    thuTu         INT          NOT NULL CHECK (thuTu > 0),
    doiPhuongTien BIT          NOT NULL DEFAULT 0,
    coAn          BIT          NOT NULL DEFAULT 0,
    coKhachSan    BIT          NOT NULL DEFAULT 0,
    loaiKhachSan  INT          NULL CHECK (loaiKhachSan IN (2,3,4,5)),
    CONSTRAINT UQ_NoiDungChan_ThuTu UNIQUE (maTour, thuTu),
    -- co khach san thi phai co loai sao, khong co thi khong co loai
    CONSTRAINT CK_NoiDungChan_KhachSan CHECK (
        (coKhachSan = 1 AND loaiKhachSan IS NOT NULL) OR
        (coKhachSan = 0 AND loaiKhachSan IS NULL))
);

CREATE TABLE Chuyen (
    maChuyen   VARCHAR(10)  NOT NULL PRIMARY KEY,
    maTour     VARCHAR(10)  NOT NULL REFERENCES Tour(maTour),
    ngayDi     DATE         NOT NULL,
    ngayVe     DATE         NOT NULL,
    diaDiemDon NVARCHAR(200) NOT NULL,
    trangThai  NVARCHAR(30) NOT NULL DEFAULT N'Chưa khởi hành'
        CHECK (trangThai IN (N'Chưa khởi hành', N'Đang thực hiện', N'Đã kết thúc', N'Hủy')),
    CONSTRAINT CK_Chuyen_Ngay CHECK (ngayVe >= ngayDi)
);

/* ---------- 2. NHOM KHACH HANG & DANG KY ---------- */
CREATE TABLE KhachDoan (
    maKhachDoan  VARCHAR(10)   NOT NULL PRIMARY KEY,
    tenCoQuan    NVARCHAR(150) NOT NULL,
    diaChi       NVARCHAR(200) NOT NULL,
    dienThoai    VARCHAR(15)   NOT NULL,
    nguoiDaiDien NVARCHAR(100) NOT NULL
);

CREATE TABLE KhachLe (
    maKhachLe VARCHAR(10)   NOT NULL PRIMARY KEY,
    hoTen     NVARCHAR(100) NOT NULL,
    dienThoai VARCHAR(15)   NOT NULL,
    diaChi    NVARCHAR(200) NULL
);

CREATE TABLE DiemBanVe (
    maDiemBan  VARCHAR(10)   NOT NULL PRIMARY KEY,
    tenDiemBan NVARCHAR(100) NOT NULL,
    diaChi     NVARCHAR(200) NOT NULL,
    dienThoai  VARCHAR(15)   NULL
);

-- Gia dinh: tren 12 nguoi la khach theo doan
CREATE TABLE PhieuDangKyDoan (
    maPhieu       VARCHAR(10)   NOT NULL PRIMARY KEY,
    maKhachDoan   VARCHAR(10)   NOT NULL REFERENCES KhachDoan(maKhachDoan),
    maTour        VARCHAR(10)   NOT NULL REFERENCES Tour(maTour),
    ngayLap       DATE          NOT NULL,
    ngayDi        DATE          NOT NULL,
    soNguoi       INT           NOT NULL CHECK (soNguoi > 12),
    diaDiemDon    NVARCHAR(200) NOT NULL,
    tienDatCoc    DECIMAL(18,0) NOT NULL CHECK (tienDatCoc >= 0),
    coMuaBaoHiem  BIT           NOT NULL DEFAULT 0,
    tongKinhPhi   DECIMAL(18,0) NOT NULL CHECK (tongKinhPhi >= 0),
    ngayThanhToan DATE          NULL,
    trangThai     NVARCHAR(30)  NOT NULL DEFAULT N'Đã đặt cọc'
        CHECK (trangThai IN (N'Đã đặt cọc', N'Đã kết thúc', N'Đã thanh toán', N'Mất cọc')),
    CONSTRAINT CK_PhieuDoan_Ngay CHECK (ngayDi >= ngayLap)
);

CREATE TABLE NguoiDiCung (
    maNguoi  VARCHAR(10)   NOT NULL PRIMARY KEY,
    maPhieu  VARCHAR(10)   NOT NULL REFERENCES PhieuDangKyDoan(maPhieu) ON DELETE CASCADE,
    hoTen    NVARCHAR(100) NOT NULL,
    ngaySinh DATE          NULL,
    gioiTinh NVARCHAR(10)  NULL CHECK (gioiTinh IN (N'Nam', N'Nữ'))
);

-- Gia dinh: khach le dang ky toi da 12 nguoi / ve
CREATE TABLE VeChuyen (
    maVe         VARCHAR(10)   NOT NULL PRIMARY KEY,
    maKhachLe    VARCHAR(10)   NOT NULL REFERENCES KhachLe(maKhachLe),
    maChuyen     VARCHAR(10)   NOT NULL REFERENCES Chuyen(maChuyen),
    maDiemBan    VARCHAR(10)   NOT NULL REFERENCES DiemBanVe(maDiemBan),
    ngayDangKy   DATE          NOT NULL,
    soLuong      INT           NOT NULL CHECK (soLuong BETWEEN 1 AND 12),
    thanhTien    DECIMAL(18,0) NOT NULL CHECK (thanhTien >= 0),
    daThanhToan  BIT           NOT NULL DEFAULT 0
);

/* ---------- 3. NHOM NHAN VIEN & KHAO SAT ---------- */
CREATE TABLE NhanVien (
    maNV        VARCHAR(10)   NOT NULL PRIMARY KEY,
    hoTen       NVARCHAR(100) NOT NULL,
    ngaySinh    DATE          NULL,
    dienThoai   VARCHAR(15)   NULL,
    diaChi      NVARCHAR(200) NULL,
    luongCanBan DECIMAL(18,0) NOT NULL CHECK (luongCanBan >= 0)
);

-- Moi dong phan cong thuoc CHUYEN LE hoac DOAN (khong the ca hai)
CREATE TABLE PhanCong (
    maPhanCong  VARCHAR(10)   NOT NULL PRIMARY KEY,
    maNV        VARCHAR(10)   NOT NULL REFERENCES NhanVien(maNV),
    maChuyen    VARCHAR(10)   NULL REFERENCES Chuyen(maChuyen),
    maPhieu     VARCHAR(10)   NULL REFERENCES PhieuDangKyDoan(maPhieu),
    ngayBatDau  DATE          NOT NULL,
    ngayKetThuc DATE          NOT NULL,
    luongTour   DECIMAL(18,0) NOT NULL CHECK (luongTour >= 0),
    CONSTRAINT CK_PhanCong_Ngay CHECK (ngayKetThuc >= ngayBatDau),
    CONSTRAINT CK_PhanCong_Xor CHECK (
        (maChuyen IS NOT NULL AND maPhieu IS NULL) OR
        (maChuyen IS NULL AND maPhieu IS NOT NULL))
);
-- Moi chuyen le chi co DUNG 1 huong dan vien (doan thi nhieu)
CREATE UNIQUE INDEX UX_PhanCong_Chuyen ON PhanCong(maChuyen) WHERE maChuyen IS NOT NULL;

-- Khao sat gui cho doan HOAC khach le
CREATE TABLE PhieuKhaoSat (
    maKhaoSat    VARCHAR(10)  NOT NULL PRIMARY KEY,
    maPhieu      VARCHAR(10)  NULL REFERENCES PhieuDangKyDoan(maPhieu),
    maVe         VARCHAR(10)  NULL REFERENCES VeChuyen(maVe),
    ngayGui      DATE         NOT NULL,
    mucDoHaiLong INT          NULL CHECK (mucDoHaiLong BETWEEN 1 AND 5),
    gopY         NVARCHAR(500) NULL,
    CONSTRAINT CK_KhaoSat_Xor CHECK (
        (maPhieu IS NOT NULL AND maVe IS NULL) OR
        (maPhieu IS NULL AND maVe IS NOT NULL))
);
GO

/* ---------- 4. TRIGGER: khong phan cong chong cheo lich ---------- */
CREATE TRIGGER trg_PhanCong_KiemTraTrungLich
ON PhanCong AFTER INSERT, UPDATE
AS
BEGIN
    IF EXISTS (
        SELECT 1
        FROM inserted i
        JOIN PhanCong p
          ON p.maNV = i.maNV
         AND p.maPhanCong <> i.maPhanCong
         AND i.ngayBatDau <= p.ngayKetThuc
         AND i.ngayKetThuc >= p.ngayBatDau)
    BEGIN
        RAISERROR (N'Nhân viên đã có lịch phân công trùng thời gian.', 16, 1);
        ROLLBACK TRANSACTION;
    END
END;
GO

/* ---------- 5. HAM: luong thang = luong can ban + tong luong tour ---------- */
CREATE FUNCTION dbo.fn_TinhLuongThang (@maNV VARCHAR(10), @thang INT, @nam INT)
RETURNS DECIMAL(18,0)
AS
BEGIN
    DECLARE @kq DECIMAL(18,0);
    SELECT @kq = nv.luongCanBan + ISNULL((
            SELECT SUM(pc.luongTour)
            FROM PhanCong pc
            WHERE pc.maNV = nv.maNV
              AND MONTH(pc.ngayKetThuc) = @thang
              AND YEAR(pc.ngayKetThuc)  = @nam), 0)
    FROM NhanVien nv
    WHERE nv.maNV = @maNV;
    RETURN @kq;
END;
GO

/* ---------- 6. DU LIEU MAU (dung cho kiem thu) ---------- */
INSERT INTO PhuongTien VALUES ('PT01', N'Máy bay'), ('PT02', N'Xe đò'), ('PT03', N'Tàu hỏa');

INSERT INTO Tour VALUES
 ('T01', N'Hà Nội - Hạ Long', 4, 3, 8500000),
 ('T02', N'Đà Lạt - Thung lũng Tình Yêu', 3, 2, 3200000);

INSERT INTO NoiDungChan VALUES
 ('ND01','T01','PT01',N'Hà Nội',  1,1,1,1,4),
 ('ND02','T01','PT02',N'Hạ Long', 2,1,1,1,3),
 ('ND03','T02','PT02',N'Đà Lạt',  1,0,1,1,3);

INSERT INTO DiemThamQuan VALUES
 ('DQ01', N'Vịnh Hạ Long', N'Quảng Ninh', N'Di sản thiên nhiên thế giới', N'Danh lam thắng cảnh nổi tiếng'),
 ('DQ02', N'Lăng Chủ tịch Hồ Chí Minh', N'Hà Nội', N'Nơi an nghỉ của Chủ tịch Hồ Chí Minh', N'Di tích lịch sử'),
 ('DQ03', N'Thung lũng Tình Yêu', N'Đà Lạt', N'Khu du lịch sinh thái', N'Danh lam thắng cảnh');

INSERT INTO TourDiemThamQuan VALUES ('T01','DQ01'), ('T01','DQ02'), ('T02','DQ03');

INSERT INTO DiemBanVe VALUES
 ('DB01', N'Điểm bán vé Quận 1',    N'12 Lê Lợi, Quận 1, TP.HCM',     '02838000001'),
 ('DB02', N'Điểm bán vé Thủ Đức',   N'45 Võ Văn Ngân, TP. Thủ Đức',   '02838000002');

INSERT INTO KhachLe VALUES
 ('KL01', N'Nguyễn Văn An',  '0901000001', N'Quận 3, TP.HCM'),
 ('KL02', N'Trần Thị Bình',  '0901000002', N'Quận Bình Thạnh, TP.HCM');

INSERT INTO KhachDoan VALUES
 ('KD01', N'Công ty TNHH ABC', N'88 Nguyễn Huệ, Quận 1, TP.HCM', '02839000001', N'Lê Minh Châu');

INSERT INTO NhanVien VALUES
 ('NV01', N'Phạm Quốc Dũng', '1990-05-12', '0912000001', N'Quận 7, TP.HCM', 8000000),
 ('NV02', N'Hoàng Thị Em',   '1993-09-30', '0912000002', N'Quận 10, TP.HCM', 8000000),
 ('NV03', N'Võ Thanh Phong', '1988-01-20', '0912000003', N'Quận Gò Vấp, TP.HCM', 9000000);

INSERT INTO Chuyen VALUES
 ('C01','T01','2026-11-10','2026-11-13', N'Bến Thành, Quận 1', N'Chưa khởi hành'),
 ('C02','T02','2026-11-12','2026-11-14', N'Công viên 23/9, Quận 1', N'Chưa khởi hành');

INSERT INTO VeChuyen VALUES
 ('V01','KL01','C01','DB01','2026-10-01', 2, 17000000, 1),
 ('V02','KL02','C02','DB02','2026-10-03', 3,  9600000, 0);

INSERT INTO PhieuDangKyDoan VALUES
 ('P01','KD01','T01','2026-10-05','2026-11-20', 15, N'88 Nguyễn Huệ, Quận 1',
  30000000, 1, 127500000, NULL, N'Đã đặt cọc');

INSERT INTO NguoiDiCung VALUES
 ('N01','P01', N'Lê Minh Châu',  '1985-03-15', N'Nam'),
 ('N02','P01', N'Đỗ Thu Hà',     '1990-07-22', N'Nữ'),
 ('N03','P01', N'Bùi Quang Huy', '1992-12-01', N'Nam');

INSERT INTO PhanCong VALUES
 ('PC01','NV01','C01',NULL,'2026-11-10','2026-11-13', 1500000),
 ('PC02','NV02','C02',NULL,'2026-11-12','2026-11-14', 1000000),
 ('PC03','NV03',NULL,'P01','2026-11-20','2026-11-23', 1800000);

INSERT INTO PhieuKhaoSat VALUES
 ('KS01', NULL, 'V01', '2026-11-14', NULL, NULL);
GO

/* ---------- 7. KIEM TRA NHANH ---------- */
-- Luong thang 11/2026 cua NV01 = 8.000.000 + 1.500.000 = 9.500.000
SELECT dbo.fn_TinhLuongThang('NV01', 11, 2026) AS LuongNV01_T11;
