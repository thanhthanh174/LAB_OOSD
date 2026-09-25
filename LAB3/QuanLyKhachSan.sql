-- Create Database
IF DB_ID(N'QuanLyKhachSan') IS NULL 
    CREATE DATABASE QuanLyKhachSan;
GO

USE QuanLyKhachSan;
GO

-- 1. BANG KHU VUC
CREATE TABLE KhuVuc (
    MaKhuVuc VARCHAR(20) NOT NULL PRIMARY KEY,
    TenKhuVuc NVARCHAR(100) NULL
);

-- 2. BANG LOAI TIEN NGHI
CREATE TABLE LoaiTienNghi (
    MaLoaiTN VARCHAR(20) NOT NULL PRIMARY KEY,
    TenLoaiTN NVARCHAR(100) NULL
);

-- 3. BANG QUY DINH DEN BU
CREATE TABLE QuyDinhDenBu (
    MaQuyDinh VARCHAR(30) NOT NULL PRIMARY KEY,
    MaLoaiTN VARCHAR(20) NOT NULL,
    MucDoThietHai NVARCHAR(80) NULL,
    MucDenBu DECIMAL(18,2) NULL,
    CONSTRAINT FK_QuyDinhDenBu_LoaiTienNghi FOREIGN KEY (MaLoaiTN) REFERENCES LoaiTienNghi(MaLoaiTN)
);

-- 4. BANG PHONG
CREATE TABLE Phong (
    SoPhong VARCHAR(20) NOT NULL PRIMARY KEY,
    MaKhuVuc VARCHAR(20) NOT NULL,
    SoNguoiToiDa INT NULL,
    DonGiaNgay DECIMAL(18,2) NULL,
    TrangThai NVARCHAR(30) NULL,
    CONSTRAINT FK_Phong_KhuVuc FOREIGN KEY (MaKhuVuc) REFERENCES KhuVuc(MaKhuVuc)
);

-- 5. BANG TIEN NGHI
CREATE TABLE TienNghi (
    MaTienNghi VARCHAR(30) NOT NULL PRIMARY KEY,
    MaLoaiTN VARCHAR(20) NOT NULL,
    SoThuTu INT NULL,
    TinhTrangHienTai NVARCHAR(100) NULL,
    CONSTRAINT FK_TienNghi_LoaiTienNghi FOREIGN KEY (MaLoaiTN) REFERENCES LoaiTienNghi(MaLoaiTN)
);

-- 6. BANG NHAN VIEN
CREATE TABLE NhanVien (
    MaNV VARCHAR(20) NOT NULL PRIMARY KEY,
    HoTen NVARCHAR(120) NULL,
    VaiTro NVARCHAR(50) NULL,
    SoDienThoai VARCHAR(20) NULL
);

-- 7. BANG PHIEU LAP DAT
CREATE TABLE PhieuLapDat (
    SoPhieuLapDat VARCHAR(30) NOT NULL PRIMARY KEY,
    MaTienNghi VARCHAR(30) NOT NULL,
    SoPhong VARCHAR(20) NOT NULL,
    NgayLap DATE NULL,
    TinhTrang NVARCHAR(100) NULL,
    MaNV VARCHAR(20) NOT NULL,
    GhiChu NVARCHAR(250) NULL,
    CONSTRAINT FK_PhieuLapDat_TienNghi FOREIGN KEY (MaTienNghi) REFERENCES TienNghi(MaTienNghi),
    CONSTRAINT FK_PhieuLapDat_Phong FOREIGN KEY (SoPhong) REFERENCES Phong(SoPhong),
    CONSTRAINT FK_PhieuLapDat_NhanVien FOREIGN KEY (MaNV) REFERENCES NhanVien(MaNV)
);

-- 8. BANG KHACH HANG
CREATE TABLE KhachHang (
    MaKhach VARCHAR(20) NOT NULL PRIMARY KEY,
    HoTen NVARCHAR(120) NULL,
    SoCMND VARCHAR(30) NULL,
    QuocTich NVARCHAR(80) NULL,
    SoDienThoai VARCHAR(20) NULL
);

-- 9. BANG PHIEU DAT PHONG
CREATE TABLE PhieuDatPhong (
    SoPhieuDat VARCHAR(30) NOT NULL PRIMARY KEY,
    MaKhach VARCHAR(20) NOT NULL,
    MaNVLeTan VARCHAR(20) NOT NULL,
    NgayLap DATETIME NULL,
    NgayNhan DATE NULL,
    NgayTraDuKiem DATE NULL,
    TienCoc DECIMAL(18,2) NULL,
    KenhDat NVARCHAR(20) NULL,
    TrangThai NVARCHAR(30) NULL,
    NgayNhanThucTe DATETIME NULL,
    NgayTraThucTe DATETIME NULL,
    CONSTRAINT FK_PhieuDatPhong_KhachHang FOREIGN KEY (MaKhach) REFERENCES KhachHang(MaKhach),
    CONSTRAINT FK_PhieuDatPhong_NhanVien FOREIGN KEY (MaNVLeTan) REFERENCES NhanVien(MaNV)
);

-- 10. BANG CHI TIET DAT PHONG
CREATE TABLE ChiTietDatPhong (
    SoPhieuDat VARCHAR(30) NOT NULL,
    SoPhong VARCHAR(20) NOT NULL,
    SoNguoi INT NULL,
    PRIMARY KEY (SoPhieuDat, SoPhong),
    CONSTRAINT FK_ChiTietDatPhong_PhieuDatPhong FOREIGN KEY (SoPhieuDat) REFERENCES PhieuDatPhong(SoPhieuDat),
    CONSTRAINT FK_ChiTietDatPhong_Phong FOREIGN KEY (SoPhong) REFERENCES Phong(SoPhong)
);

-- 11. BANG NGUOI LUU TRU
CREATE TABLE NguoiLuuTru (
    MaNguoiLT INT NOT NULL PRIMARY KEY IDENTITY(1,1),
    SoPhieuDat VARCHAR(30) NOT NULL,
    SoPhong VARCHAR(20) NOT NULL,
    HoTen NVARCHAR(120) NULL,
    SoCMND VARCHAR(30) NULL,
    QuocTich NVARCHAR(80) NULL,
    CONSTRAINT FK_NguoiLuuTru_ChiTietDatPhong FOREIGN KEY (SoPhieuDat, SoPhong) REFERENCES ChiTietDatPhong(SoPhieuDat, SoPhong)
);

-- 12. BANG DICH VU
CREATE TABLE DichVu (
    MaDV VARCHAR(20) NOT NULL PRIMARY KEY,
    TenDV NVARCHAR(120) NULL,
    DonViTinh NVARCHAR(40) NULL,
    DonGia DECIMAL(18,2) NULL
);

-- 13. BANG PHIEU SU DUNG DICH VU
CREATE TABLE PhieuSuDungDV (
    SoPhieuSDDV VARCHAR(30) NOT NULL PRIMARY KEY,
    SoPhieuDat VARCHAR(30) NOT NULL,
    SoPhong VARCHAR(20) NOT NULL,
    NgaySuDung DATE NULL,
    MaNV VARCHAR(20) NOT NULL,
    CONSTRAINT FK_PhieuSuDungDV_PhieuDatPhong FOREIGN KEY (SoPhieuDat) REFERENCES PhieuDatPhong(SoPhieuDat),
    CONSTRAINT FK_PhieuSuDungDV_Phong FOREIGN KEY (SoPhong) REFERENCES Phong(SoPhong),
    CONSTRAINT FK_PhieuSuDungDV_NhanVien FOREIGN KEY (MaNV) REFERENCES NhanVien(MaNV)
);

-- 14. BANG CHI TIET PHIEU SU DUNG DICH VU
CREATE TABLE ChiTietPhieuSuDungDV (
    SoPhieuSDDV VARCHAR(30) NOT NULL,
    MaDV VARCHAR(20) NOT NULL,
    SoLuong INT NULL,
    DonGia DECIMAL(18,2) NULL,
    ThanhTien DECIMAL(18,2) NULL,
    PRIMARY KEY (SoPhieuSDDV, MaDV),
    CONSTRAINT FK_ChiTietPhieuSDDV_PhieuSuDungDV FOREIGN KEY (SoPhieuSDDV) REFERENCES PhieuSuDungDV(SoPhieuSDDV),
    CONSTRAINT FK_ChiTietPhieuSDDV_DichVu FOREIGN KEY (MaDV) REFERENCES DichVu(MaDV)
);

-- 15. BANG PHIEU DEN BU
CREATE TABLE PhieuDenBu (
    SoPhieuDenBu VARCHAR(30) NOT NULL PRIMARY KEY,
    SoPhieuDat VARCHAR(30) NOT NULL,
    SoPhong VARCHAR(20) NOT NULL,
    NgayLap DATETIME NULL,
    MaNV VARCHAR(20) NOT NULL,
    TongTien DECIMAL(18,2) NULL,
    CONSTRAINT FK_PhieuDenBu_PhieuDatPhong FOREIGN KEY (SoPhieuDat) REFERENCES PhieuDatPhong(SoPhieuDat),
    CONSTRAINT FK_PhieuDenBu_Phong FOREIGN KEY (SoPhong) REFERENCES Phong(SoPhong),
    CONSTRAINT FK_PhieuDenBu_NhanVien FOREIGN KEY (MaNV) REFERENCES NhanVien(MaNV)
);

-- 16. BANG CHI TIET PHIEU DEN BU
CREATE TABLE ChiTietPhieuDenBu (
    SoPhieuDenBu VARCHAR(30) NOT NULL,
    MaTienNghi VARCHAR(30) NOT NULL,
    MucDoThietHai NVARCHAR(80) NULL,
    SoTien DECIMAL(18,2) NULL,
    PRIMARY KEY (SoPhieuDenBu, MaTienNghi),
    CONSTRAINT FK_ChiTietPhieuDenBu_PhieuDenBu FOREIGN KEY (SoPhieuDenBu) REFERENCES PhieuDenBu(SoPhieuDenBu),
    CONSTRAINT FK_ChiTietPhieuDenBu_TienNghi FOREIGN KEY (MaTienNghi) REFERENCES TienNghi(MaTienNghi)
);

-- 17. BANG HOA DON
CREATE TABLE HoaDon (
    SoHoaDon VARCHAR(30) NOT NULL PRIMARY KEY,
    SoPhieuDat VARCHAR(30) NOT NULL,
    NgayLap DATETIME NULL,
    MaNV VARCHAR(20) NOT NULL,
    SoNgayTinhTien INT NULL,
    TienPhong DECIMAL(18,2) NULL,
    TienDichVu DECIMAL(18,2) NULL,
    TongTien DECIMAL(18,2) NULL,
    TrangThai NVARCHAR(30) NULL,
    CONSTRAINT FK_HoaDon_PhieuDatPhong FOREIGN KEY (SoPhieuDat) REFERENCES PhieuDatPhong(SoPhieuDat),
    CONSTRAINT FK_HoaDon_NhanVien FOREIGN KEY (MaNV) REFERENCES NhanVien(MaNV)
);

-- 18. BANG THANH TOAN
CREATE TABLE ThanhToan (
    MaThanhToan VARCHAR(30) NOT NULL PRIMARY KEY,
    SoHoaDon VARCHAR(30) NOT NULL,
    NgayThanhToan DATETIME NULL,
    HinhThuc NVARCHAR(30) NULL,
    SoTien DECIMAL(18,2) NULL,
    CONSTRAINT FK_ThanhToan_HoaDon FOREIGN KEY (SoHoaDon) REFERENCES HoaDon(SoHoaDon)
);
GO

-------------------INSERT DỮ LIỆU---------------------------
-- 1. BANG KHU VUC (5 dong)
INSERT INTO KhuVuc (MaKhuVuc, TenKhuVuc) 
VALUES	('KV-A', N'Khu A - Tòa nhà VIP Hướng Biển'),
		('KV-B', N'Khu B - Tòa nhà Standard'),
		('KV-C', N'Khu C - Bungalow Sân Vườn'),
		('KV-D', N'Khu D - Biệt thự Penthouse'),
		('KV-E', N'Khu E - Căn hộ Family');

-- 2. BANG LOAI TIEN NGHI (5 dong)
INSERT INTO LoaiTienNghi (MaLoaiTN, TenLoaiTN) 
VALUES	('LTN-TV', N'Tivi thông minh'),
		('LTN-TL', N'Tủ lạnh mini / Minibar'),
		('LTN-ML', N'Máy điều hòa nhiệt độ'),
		('LTN-MNS', N'Máy nước nóng'),
		('LTN-KT', N'Két sắt an toàn');

-- 3. BANG QUY DINH DEN BU (5 dong)
INSERT INTO QuyDinhDenBu (MaQuyDinh, MaLoaiTN, MucDoThietHai, MucDenBu) 
VALUES	('QDB-01', 'LTN-TV', N'Vỡ màn hình / Hỏng hoàn toàn', 8000000.00),
		('QDB-02', 'LTN-TV', N'Mất hoặc hỏng điều khiển Remote', 300000.00),
		('QDB-03', 'LTN-TL', N'Móp méo / Hỏng lốc máy', 3500000.00),
		('QDB-04', 'LTN-ML', N'Hỏng điều khiển máy lạnh', 250000.00),
		('QDB-05', 'LTN-KT', N'Mất chìa khóa / Quên mã đổi két', 500000.00);

-- 4. BANG PHONG (5 dong)
INSERT INTO Phong (SoPhong, MaKhuVuc, SoNguoiToiDa, DonGiaNgay, TrangThai) 
VALUES	('P101', 'KV-A', 2, 1200000.00, N'Đang ở'),
		('P102', 'KV-A', 2, 1200000.00, N'Đã đặt'),
		('P201', 'KV-B', 4, 850000.00, N'Trống'),
		('P202', 'KV-B', 2, 650000.00, N'Trống'),
		('P301', 'KV-C', 2, 1500000.00, N'Đang ở');

-- 5. BANG TIEN NGHI (5 dong)
INSERT INTO TienNghi (MaTienNghi, MaLoaiTN, SoThuTu, TinhTrangHienTai) 
VALUES	('TN-TV-01', 'LTN-TV', 1, N'Hoạt động tốt'),
		('TN-TV-02', 'LTN-TV', 2, N'Hoạt động tốt'),
		('TN-TL-01', 'LTN-TL', 1, N'Hoạt động tốt'),
		('TN-TL-02', 'LTN-TL', 2, N'Hoạt động tốt'),
		('TN-KT-01', 'LTN-KT', 1, N'Hoạt động tốt');

-- 6. BANG NHAN VIEN (5 dong)
INSERT INTO NhanVien (MaNV, HoTen, VaiTro, SoDienThoai) 
VALUES	('NV01', N'Trần Thị Mai', N'Lễ tân', '0905123456'),
		('NV02', N'Lê Văn Tấn', N'Phục vụ phòng', '0914987654'),
		('NV03', N'Nguyễn Thu Hương', N'Thu ngân', '0988112233'),
		('NV04', N'Phạm Quốc Bảo', N'Lễ tân', '0935445566'),
		('NV05', N'Hoàng Trọng Nghĩa', N'Quản lý', '0909000111');

-- 7. BANG PHIEU LAP DAT (5 dong)
INSERT INTO PhieuLapDat (SoPhieuLapDat, MaTienNghi, SoPhong, NgayLap, TinhTrang, MaNV, GhiChu) 
VALUES	('PLD-2026-001', 'TN-TV-01', 'P101', '2026-01-10', N'Mới', 'NV02', N'Trang bị ban đầu P101'),
		('PLD-2026-002', 'TN-TL-01', 'P101', '2026-01-10', N'Mới', 'NV02', N'Trang bị ban đầu P101'),
		('PLD-2026-003', 'TN-TV-02', 'P102', '2026-01-10', N'Mới', 'NV02', N'Trang bị ban đầu P102'),
		('PLD-2026-004', 'TN-TL-02', 'P201', '2026-01-11', N'Mới', 'NV02', N'Trang bị ban đầu P201'),
		('PLD-2026-005', 'TN-KT-01', 'P301', '2026-01-12', N'Mới', 'NV02', N'Trang bị ban đầu P301');

-- 8. BANG KHACH HANG (5 dong)
INSERT INTO KhachHang (MaKhach, HoTen, SoCMND, QuocTich, SoDienThoai) 
VALUES	('KH01', N'Nguyễn Văn An', '079198001234', N'Việt Nam', '0903111222'),
		('KH02', N'John Smith', 'C987654321', N'Mỹ', '0912333444'),
		('KH03', N'Phạm Minh Tuấn', '036095005678', N'Việt Nam', '0977888999'),
		('KH04', N'Tanaka Hiroshi', 'JP12345678', N'Nhật Bản', '0981222333'),
		('KH05', N'Lê Thị Hoàng Yến', '048200009988', N'Việt Nam', '0945666777');

-- 9. BANG PHIEU DAT PHONG (5 dong)
INSERT INTO PhieuDatPhong (SoPhieuDat, MaKhach, MaNVLeTan, NgayLap, NgayNhan, NgayTraDuKiem, TienCoc, KenhDat, TrangThai, NgayNhanThucTe, NgayTraThucTe) 
VALUES	('PDP-2026-001', 'KH01', 'NV01', '2026-03-20 08:30:00', '2026-03-22', '2026-03-25', 500000.00, N'Trực tiếp', N'Đang ở', '2026-03-22 14:00:00', NULL),
		('PDP-2026-002', 'KH02', 'NV01', '2026-03-21 10:15:00', '2026-03-26', '2026-03-28', 1000000.00, N'Website', N'Đã đặt', NULL, NULL),
		('PDP-2026-003', 'KH03', 'NV04', '2026-03-22 09:00:00', '2026-03-23', '2026-03-25', 800000.00, N'Điện thoại', N'Đang ở', '2026-03-23 13:30:00', NULL),
		('PDP-2026-004', 'KH04', 'NV04', '2026-03-15 14:00:00', '2026-03-18', '2026-03-20', 1200000.00, N'Website', N'Đã trả', '2026-03-18 12:00:00', '2026-03-20 11:00:00'),
		('PDP-2026-005', 'KH05', 'NV01', '2026-03-10 16:20:00', '2026-03-12', '2026-03-14', 500000.00, N'Trực tiếp', N'Đã trả', '2026-03-12 14:00:00', '2026-03-14 12:00:00');

-- 10. BANG CHI TIET DAT PHONG (5 dong)
INSERT INTO ChiTietDatPhong (SoPhieuDat, SoPhong, SoNguoi) 
VALUES	('PDP-2026-001', 'P101', 2),
		('PDP-2026-002', 'P102', 2),
		('PDP-2026-003', 'P301', 2),
		('PDP-2026-004', 'P201', 3),
		('PDP-2026-005', 'P202', 1);

-- 11. BANG NGUOI LUU TRU (5 dong)
INSERT INTO NguoiLuuTru (SoPhieuDat, SoPhong, HoTen, SoCMND, QuocTich) 
VALUES	('PDP-2026-001', 'P101', N'Nguyễn Văn An', '079198001234', N'Việt Nam'),
		('PDP-2026-001', 'P101', N'Lê Thị Bình', '079198005678', N'Việt Nam'),
		('PDP-2026-003', 'P301', N'Phạm Minh Tuấn', '036095005678', N'Việt Nam'),
		('PDP-2026-004', 'P201', N'Tanaka Hiroshi', 'JP12345678', N'Nhật Bản'),
		('PDP-2026-005', 'P202', N'Lê Thị Hoàng Yến', '048200009988', N'Việt Nam');

-- 12. BANG DICH VU (5 dong)
INSERT INTO DichVu (MaDV, TenDV, DonViTinh, DonGia) 
VALUES	('DV-GIAT', N'Giặt ủi quần áo', N'Kg', 30000.00),
		('DV-COCA', N'Nước ngọt Coca Cola', N'Lon', 20000.00),
		('DV-BIER', N'Bia Heineken', N'Lon', 35000.00),
		('DV-MASS', N'Massage toàn thân', N'Suất', 350000.00),
		('DV-ANS', N'Ăn sáng buffet', N'Suất', 150000.00);

-- 13. BANG PHIEU SU DUNG DICH VU (5 dong)
INSERT INTO PhieuSuDungDV (SoPhieuSDDV, SoPhieuDat, SoPhong, NgaySuDung, MaNV) 
VALUES	('PSD-001', 'PDP-2026-001', 'P101', '2026-03-23', 'NV02'),
		('PSD-002', 'PDP-2026-001', 'P101', '2026-03-24', 'NV02'),
		('PSD-003', 'PDP-2026-003', 'P301', '2026-03-24', 'NV02'),
		('PSD-004', 'PDP-2026-004', 'P201', '2026-03-19', 'NV02'),
		('PSD-005', 'PDP-2026-005', 'P202', '2026-03-13', 'NV02');

-- 14. BANG CHI TIET PHIEU SU DUNG DICH VU (5 dong)
INSERT INTO ChiTietPhieuSuDungDV (SoPhieuSDDV, MaDV, SoLuong, DonGia, ThanhTien) 
VALUES	('PSD-001', 'DV-COCA', 3, 20000.00, 60000.00),
		('PSD-001', 'DV-BIER', 2, 35000.00, 70000.00),
		('PSD-002', 'DV-GIAT', 4, 30000.00, 120000.00),
		('PSD-003', 'DV-MASS', 2, 350000.00, 700000.00),
		('PSD-004', 'DV-ANS', 3, 150000.00, 450000.00);

-- 15. BANG PHIEU DEN BU (5 dong)
INSERT INTO PhieuDenBu (SoPhieuDenBu, SoPhieuDat, SoPhong, NgayLap, MaNV, TongTien) 
VALUES	('PDB-001', 'PDP-2026-001', 'P101', '2026-03-25 09:00:00', 'NV02', 300000.00),
		('PDB-002', 'PDP-2026-004', 'P201', '2026-03-20 10:30:00', 'NV02', 250000.00),
		('PDB-003', 'PDP-2026-005', 'P202', '2026-03-14 11:30:00', 'NV02', 0.00),
		('PDB-004', 'PDP-2026-003', 'P301', '2026-03-25 08:00:00', 'NV02', 500000.00),
		('PDB-005', 'PDP-2026-002', 'P102', '2026-03-28 12:00:00', 'NV02', 0.00);

-- 16. BANG CHI TIET PHIEU DEN BU (5 dong)
INSERT INTO ChiTietPhieuDenBu (SoPhieuDenBu, MaTienNghi, MucDoThietHai, SoTien) 
VALUES	('PDB-001', 'TN-TV-01', N'Mất điều khiển Remote Tivi', 300000.00),
		('PDB-002', 'TN-TL-02', N'Hỏng điều khiển máy lạnh', 250000.00),
		('PDB-004', 'TN-KT-01', N'Quên mã két phải đổi ổ', 500000.00),
		('PDB-003', 'TN-TV-02', N'Không hư hỏng', 0.00),
		('PDB-005', 'TN-TL-01', N'Không hư hỏng', 0.00);

-- 17. BANG HOA DON (5 dong)
INSERT INTO HoaDon (SoHoaDon, SoPhieuDat, NgayLap, MaNV, SoNgayTinhTien, TienPhong, TienDichVu, TongTien, TrangThai) 
VALUES	('HD-2026-001', 'PDP-2026-001', '2026-03-25 10:00:00', 'NV03', 3, 3600000.00, 250000.00, 3850000.00, N'Đã thanh toán'),
		('HD-2026-002', 'PDP-2026-003', '2026-03-25 10:30:00', 'NV03', 2, 3000000.00, 700000.00, 3700000.00, N'Chờ thanh toán'),
		('HD-2026-003', 'PDP-2026-004', '2026-03-20 11:00:00', 'NV03', 2, 1700000.00, 450000.00, 2150000.00, N'Đã thanh toán'),
		('HD-2026-004', 'PDP-2026-005', '2026-03-14 12:00:00', 'NV03', 2, 1300000.00, 0.00, 1300000.00, N'Đã thanh toán'),
		('HD-2026-005', 'PDP-2026-002', '2026-03-28 11:30:00', 'NV03', 2, 2400000.00, 0.00, 2400000.00, N'Chờ thanh toán');

-- 18. BANG THANH TOAN (5 dong)
INSERT INTO ThanhToan (MaThanhToan, SoHoaDon, NgayThanhToan, HinhThuc, SoTien) 
VALUES	('TT-001', 'HD-2026-001', '2026-03-20 08:30:00', N'Tiền mặt', 500000.00),    
		('TT-002', 'HD-2026-001', '2026-03-25 10:05:00', N'Chuyển khoản', 3350000.00),
		('TT-003', 'HD-2026-003', '2026-03-15 14:00:00', N'Thẻ', 1200000.00),       
		('TT-004', 'HD-2026-003', '2026-03-20 11:05:00', N'Tiền mặt', 950000.00),     
		('TT-005', 'HD-2026-004', '2026-03-14 12:05:00', N'Ví điện tử', 800000.00);   
GO