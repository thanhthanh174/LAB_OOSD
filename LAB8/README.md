# LAB 8 – Hệ thống quản lý cửa hàng nước giải khát

**Môn:** Thực hành Phương pháp phát triển phần mềm hướng đối tượng
**Trường:** Đại học Tài nguyên và Môi trường TPHCM
**Sinh viên:** Đoàn Ngọc Phương Thanh – **MSSV:** 1250080174 – **Lớp:** 12_ĐH_CNPM2

---

## 1. Giới thiệu

Bài thực hành mô hình hóa nghiệp vụ mua bán của một cửa hàng nước giải khát (nhập hàng từ nhà cung ứng, bán hàng cho khách vãng lai và khách quen, hẹn giao hàng nhiều đợt, ghi nợ).

Repo/thư mục này chứa phần **Câu 4, 5, 6** của Bài 2, được vẽ bằng **draw.io (diagrams.net)**. Tên class, actor và use case được lấy thống nhất theo bài Lab 1 (Câu 1 – 3).

## 2. Cấu trúc file

| File | Mô tả |
|---|---|
| `LAB8_Cau4_5_6.drawio` | File draw.io gồm 3 tab (trang), mỗi tab là một sơ đồ |
| `README.md` | Tài liệu mô tả này |

## 3. Cách mở file

1. Vào <https://app.diagrams.net> → **File → Open from → Device** → chọn `LAB8_Cau4_5_6.drawio`.
   (Hoặc dùng draw.io Desktop, hoặc extension *Draw.io Integration* trong VS Code.)
2. Chuyển giữa các sơ đồ bằng các tab ở cuối cửa sổ.
3. Xuất hình để chèn vào Word: **File → Export as → PNG** (nên chọn *Border width* 10 và *Zoom* 200%).

## 4. Nội dung các sơ đồ

### Câu 4 – Use Case Diagram phân rã
Chi tiết hoạt động từ lúc khách đặt mua đến khi cửa hàng giao đủ hàng.

- **Actor:** Khách hàng (gồm Khách vãng lai, Khách quen), Nhân viên.
- **Use case chính:** Đặt mua nước giải khát, Kiểm tra tồn kho, Lập hóa đơn, Thanh toán hóa đơn, Giao hàng, Cập nhật tồn kho.
- **Quan hệ `«include»`:** Đặt mua → Kiểm tra tồn kho / Lập hóa đơn / Giao hàng; Lập hóa đơn → Thanh toán; Giao hàng → Cập nhật tồn kho.
- **Quan hệ `«extend»`:**
  - Lập phiếu ghi nợ → Thanh toán (khách quen trả chậm)
  - Lập phiếu hẹn giao hàng → Lập hóa đơn (không đủ hàng, khách quen)
  - Giao hàng nhiều đợt theo phiếu hẹn → Giao hàng (có phiếu hẹn)

### Câu 5 – Activity Diagram (cho Câu 4)
Sơ đồ hoạt động chia 3 swimlane: **Khách hàng – Nhân viên – Hệ thống**.

- Rẽ nhánh **Đủ hàng?**
  - Đủ: lập hóa đơn → (khách quen trả chậm thì lập phiếu ghi nợ, ngược lại thanh toán ngay) → giao đủ hàng.
  - Không đủ: khách vãng lai thì thông báo không đủ hàng và kết thúc; khách quen thì lập hóa đơn kèm phiếu hẹn giao hàng.
- Vòng lặp giao hàng từng đợt theo ngày hẹn, cập nhật tồn kho và phiếu hẹn, lặp đến khi **Đã giao đủ**.
- Cuối cùng cập nhật tồn kho, lưu hóa đơn/phiếu rồi kết thúc.

### Câu 6 – Sequence Diagram “Lập phiếu ghi nợ”
- **Lifeline:** Nhân viên, `:FormLapPhieuGhiNo`, `:QuanLyGhiNo`, `:KhachHang`, `:HoaDon`, `:PhieuGhiNo`.
- Khung **alt** theo loại khách:
  - `[loaiKhach = "Khách quen"]`: kiểm tra khách → nhập thông tin nợ → lấy tổng tiền hóa đơn → tạo `PhieuGhiNo` → cập nhật trạng thái hóa đơn → hiển thị phiếu ghi nợ.
  - `[loaiKhach = "Khách vãng lai"]`: từ chối và thông báo không cho ghi nợ.
- Thông tin trên phiếu theo đề: ngày lập, thông tin khách, số tiền nợ, ngày dự kiến trả, lý do nợ, nhân viên lập phiếu.

## 5. Giả định khi thiết kế

- Chỉ **khách quen** mới được hẹn giao nhiều đợt và ghi nợ; khách vãng lai thanh toán và nhận hàng ngay.
- Phiếu ghi nợ gắn với một hóa đơn của khách quen.
- Việc kiểm tra tồn kho do hệ thống thực hiện khi nhân viên tiếp nhận yêu cầu.

## 6. Công cụ

- draw.io (diagrams.net)
- Đề bài: *Bài 2 – Hệ thống quản lý cửa hàng nước giải khát*
