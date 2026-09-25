using System;
using System.Data;
using System.Data.SqlClient;
using QuanLyThuVien.Data;

namespace QuanLyThuVien.Services
{
    public class NhanVienService
    {
        // Lấy danh sách nhân viên
        public DataTable LayDanhSach()
        {
            string sql = @"
                SELECT
                    MaNhanVien,
                    Ho,
                    Ten,
                    Phai,
                    NgaySinh,
                    ChucVu,
                    SoDienThoai
                FROM NhanVien
                ORDER BY MaNhanVien";

            return Db.Query(sql);
        }

        // Thêm nhân viên
        public KetQuaXuLy Them(NhanVien nv)
        {
            if (nv == null)
            {
                return KetQuaXuLy.Loi(
                    "Thông tin nhân viên không hợp lệ.");
            }

            if (string.IsNullOrWhiteSpace(nv.MaNhanVien) ||
                string.IsNullOrWhiteSpace(nv.Ho) ||
                string.IsNullOrWhiteSpace(nv.Ten) ||
                string.IsNullOrWhiteSpace(nv.Phai) ||
                string.IsNullOrWhiteSpace(nv.ChucVu))
            {
                return KetQuaXuLy.Loi(
                    "Vui lòng nhập đầy đủ thông tin nhân viên.");
            }

            try
            {
                string sql = @"
                    INSERT INTO NhanVien
                    (
                        MaNhanVien,
                        Ho,
                        Ten,
                        Phai,
                        NgaySinh,
                        ChucVu,
                        SoDienThoai
                    )
                    VALUES
                    (
                        @Ma,
                        @Ho,
                        @Ten,
                        @Phai,
                        @NgaySinh,
                        @ChucVu,
                        @SDT
                    )";

                int n = Db.Execute(
                    sql,
                    new SqlParameter("@Ma", nv.MaNhanVien.Trim()),
                    new SqlParameter("@Ho", nv.Ho.Trim()),
                    new SqlParameter("@Ten", nv.Ten.Trim()),
                    new SqlParameter("@Phai", nv.Phai.Trim()),
                    new SqlParameter("@NgaySinh", nv.NgaySinh.Date),
                    new SqlParameter("@ChucVu", nv.ChucVu.Trim()),
                    new SqlParameter(
                        "@SDT",
                        (object)(nv.SoDienThoai ?? string.Empty))
                );

                if (n > 0)
                {
                    return KetQuaXuLy.Ok(
                        "Thêm nhân viên thành công.");
                }

                return KetQuaXuLy.Loi(
                    "Không có dữ liệu được thêm.");
            }
            catch (SqlException ex)
            {
                if (ex.Number == 2627 || ex.Number == 2601)
                {
                    return KetQuaXuLy.Loi(
                        "Mã nhân viên đã tồn tại.");
                }

                return KetQuaXuLy.Loi(
                    "Lỗi cơ sở dữ liệu: " + ex.Message);
            }
        }

        // Cập nhật nhân viên
        public KetQuaXuLy CapNhat(NhanVien nv)
        {
            if (nv == null)
            {
                return KetQuaXuLy.Loi(
                    "Thông tin nhân viên không hợp lệ.");
            }

            if (string.IsNullOrWhiteSpace(nv.MaNhanVien) ||
                string.IsNullOrWhiteSpace(nv.Ho) ||
                string.IsNullOrWhiteSpace(nv.Ten) ||
                string.IsNullOrWhiteSpace(nv.Phai) ||
                string.IsNullOrWhiteSpace(nv.ChucVu))
            {
                return KetQuaXuLy.Loi(
                    "Vui lòng nhập đầy đủ thông tin nhân viên.");
            }

            try
            {
                string sql = @"
                    UPDATE NhanVien
                    SET
                        Ho = @Ho,
                        Ten = @Ten,
                        Phai = @Phai,
                        NgaySinh = @NgaySinh,
                        ChucVu = @ChucVu,
                        SoDienThoai = @SDT
                    WHERE MaNhanVien = @Ma";

                int n = Db.Execute(
                    sql,
                    new SqlParameter("@Ma", nv.MaNhanVien.Trim()),
                    new SqlParameter("@Ho", nv.Ho.Trim()),
                    new SqlParameter("@Ten", nv.Ten.Trim()),
                    new SqlParameter("@Phai", nv.Phai.Trim()),
                    new SqlParameter("@NgaySinh", nv.NgaySinh.Date),
                    new SqlParameter("@ChucVu", nv.ChucVu.Trim()),
                    new SqlParameter(
                        "@SDT",
                        (object)(nv.SoDienThoai ?? string.Empty))
                );

                if (n > 0)
                {
                    return KetQuaXuLy.Ok(
                        "Cập nhật nhân viên thành công.");
                }

                return KetQuaXuLy.Loi(
                    "Không tìm thấy nhân viên cần cập nhật.");
            }
            catch (SqlException ex)
            {
                return KetQuaXuLy.Loi(
                    "Lỗi cơ sở dữ liệu: " + ex.Message);
            }
        }

        // Xóa nhân viên
        public KetQuaXuLy Xoa(string maNhanVien)
        {
            if (string.IsNullOrWhiteSpace(maNhanVien))
            {
                return KetQuaXuLy.Loi(
                    "Mã nhân viên không được để trống.");
            }

            try
            {
                int n = Db.Execute(
                    @"DELETE FROM NhanVien
                      WHERE MaNhanVien = @Ma",
                    new SqlParameter("@Ma", maNhanVien.Trim())
                );

                if (n > 0)
                {
                    return KetQuaXuLy.Ok(
                        "Xóa nhân viên thành công.");
                }

                return KetQuaXuLy.Loi(
                    "Không tìm thấy nhân viên.");
            }
            catch (SqlException ex)
            {
                if (ex.Number == 547)
                {
                    return KetQuaXuLy.Loi(
                        "Không thể xóa nhân viên vì nhân viên này đã phát sinh phiếu mượn hoặc phiếu phạt.");
                }

                return KetQuaXuLy.Loi(
                    "Lỗi cơ sở dữ liệu: " + ex.Message);
            }
        }
    }
}