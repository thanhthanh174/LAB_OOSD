# 🏥 Quản lý hồ sơ bệnh án

Bài thực hành số 5 – Phân tích thiết kế hướng đối tượng (HUTECH).
Ứng dụng **C# Windows Forms + SQL Server** quản lý hồ sơ bệnh án: đăng ký bệnh nhân, cấp hồ sơ, khám bệnh, xét nghiệm, lập toa thuốc và thanh toán viện phí.

## ✨ Chức năng

| Form | Chức năng |
|---|---|
| `FormMain` | Menu chính |
| `FormLapToa` | Lập toa thuốc |

## 🛠 Công nghệ

C# (.NET Framework) · Windows Forms · SQL Server · ADO.NET · StarUML

## 🚀 Cài đặt

1. Chạy `QuanLyBenhAn.sql` trong SSMS để tạo CSDL (tùy chọn: chạy thêm `DuLieuMau_LapToa.sql` để có dữ liệu thử).
2. Mở project bằng Visual Studio, thêm reference `System.Configuration`.
3. Sửa chuỗi kết nối trong `App.config` cho đúng tên server:

```xml
<connectionStrings>
  <add name="QuanLyBenhAn"
       connectionString="Server=.\SQLEXPRESS;Database=QuanLyBenhAn;Integrated Security=True;TrustServerCertificate=True;"
       providerName="System.Data.SqlClient" />
</connectionStrings>
```

4. Nhấn **F5** để chạy.

## 👤 Thông tin

- Họ tên: Đoàn Ngọc Phương Thanh
- MSSV: 1250080174
- Lớp: 12_ĐH_CNPM2
