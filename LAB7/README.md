# Quản lý nhân sự - Công ty sơn Đông Á

Bài thực hành số 7 - Môn Phương pháp phát triển phần mềm hướng đối tượng

- **Sinh viên:** Đoàn Ngọc Phương Thanh
- **MSSV:** 1250080174
- **Lớp:** 12_ĐH_CNPM2

## 1. Giới thiệu

Ứng dụng Windows Forms (C#) hỗ trợ tin học hóa việc quản lý nhân sự tại công ty sơn Đông Á,
kết nối cơ sở dữ liệu SQL Server.

## 2. Chức năng đã làm

| Form | Chức năng |
|---|---|
| MainForm | Menu chính, mở các form chức năng |
| FormNhanVien | Xem, thêm, sửa, xóa nhân viên |
| FormKhenThuong | Lập quyết định khen thưởng cho cá nhân hoặc tập thể phòng ban; sửa, xóa, duyệt, từ chối quyết định |

Quy tắc nghiệp vụ chính:
- Quyết định khen thưởng mới luôn ở trạng thái "Chờ duyệt".
- Chỉ sửa và xóa được quyết định đang "Chờ duyệt".
- Quyết định chỉ gắn với một nhân viên (cá nhân) hoặc một phòng ban (tập thể), không gắn cả hai.
- Không xóa được nhân viên hoặc quyết định đang được dùng ở bảng khác.

## 3. Công nghệ

- C# Windows Forms, .NET Framework [4.x - xem trong Project → Properties]
- SQL Server [2012 trở lên], SQL Server Management Studio
- Visual Studio [2022]

## 4. Cơ sở dữ liệu

Các bảng: `PhongBan`, `NhanVien`, `QuyetDinhKhenThuong`, `PhieuChiKhenThuong`.

## 5. Hướng dẫn cài đặt và chạy

1. Mở SQL Server Management Studio, mở file `[tên file].sql`, bấm **Execute** (F5)
   để tạo CSDL `QuanLyNhanSu_DongA` và dữ liệu mẫu.
   *(Script sẽ xóa CSDL cùng tên nếu đã có.)*
2. Mở file `QuanLyNhanSu.sln` bằng Visual Studio.
3. Mở `App.config`, sửa chuỗi kết nối cho đúng tên server của máy:
   ```xml
   <connectionStrings>
     <add name="QuanLyNhanSu_DongA"
          connectionString="Server=[TÊN-MÁY]\SQLEXPRESS;Database=QuanLyNhanSu_DongA;Integrated Security=True;"
          providerName="System.Data.SqlClient" />
   </connectionStrings>
   ```
4. Bấm **Build → Rebuild Solution**, sau đó bấm **F5** để chạy.

## 6. Hướng dẫn sử dụng

- **Nhân viên:** Menu *Danh mục → Nhân viên*. Chọn một dòng để xem hoặc sửa; bấm *Mới* để nhập nhân viên mới.
- **Khen thưởng:** Menu *Khen thưởng*. Chọn *Cá nhân* hoặc *Tập thể*, nhập loại thưởng, nội dung, số tiền rồi bấm *Thêm*.
  Chọn quyết định đang chờ duyệt rồi bấm *Duyệt* hoặc *Từ chối*.
