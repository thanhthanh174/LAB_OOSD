using System;
using System.Data;
using System.Data.SqlClient;
using QuanLyThuVien.Data;

namespace QuanLyThuVien.Services
{
    public class SachService
    {
        // Lấy danh sách đầu sách
        public DataTable LayDanhSach(string tuKhoa)
        {
            string sql = @"
                SELECT
                    s.MaDauSach,
                    s.TenSach,
                    s.NamXuatBan,
                    s.SoLuongHienCo,
                    s.MaTheLoai,
                    tl.TenTheLoai,
                    s.MaNhaXuatBan,
                    nxb.DiaChi AS DiaChiNXB,
                    nxb.SoDienThoai AS SDTNXB
                FROM DauSach s
                INNER JOIN TheLoai tl
                    ON s.MaTheLoai = tl.MaTheLoai
                INNER JOIN NhaXuatBan nxb
                    ON s.MaNhaXuatBan = nxb.MaNhaXuatBan
                WHERE
                    @TuKhoa = ''
                    OR s.MaDauSach LIKE @Like
                    OR s.TenSach LIKE @Like
                ORDER BY s.MaDauSach";

            string key = (tuKhoa ?? "").Trim();

            return Db.Query(
                sql,
                new SqlParameter("@TuKhoa", key),
                new SqlParameter("@Like", "%" + key + "%")
            );
        }

        // Lấy danh sách thể loại cho ComboBox
        public DataTable LayTheLoai()
        {
            return Db.Query(@"
                SELECT
                    MaTheLoai,
                    TenTheLoai
                FROM TheLoai
                ORDER BY TenTheLoai");
        }

        // Lấy danh sách nhà xuất bản cho ComboBox
        public DataTable LayNhaXuatBan()
        {
            return Db.Query(@"
                SELECT
                    MaNhaXuatBan,
                    DiaChi
                FROM NhaXuatBan
                ORDER BY MaNhaXuatBan");
        }

        // Thêm hoặc cập nhật đầu sách
        public KetQuaXuLy Luu(
            DauSach s,
            bool capNhat)
        {
            if (s == null)
            {
                return KetQuaXuLy.Loi(
                    "Thông tin đầu sách không hợp lệ.");
            }

            if (string.IsNullOrWhiteSpace(s.MaDauSach) ||
                string.IsNullOrWhiteSpace(s.TenSach) ||
                string.IsNullOrWhiteSpace(s.MaTheLoai) ||
                string.IsNullOrWhiteSpace(s.MaNhaXuatBan))
            {
                return KetQuaXuLy.Loi(
                    "Vui lòng nhập đầy đủ thông tin đầu sách.");
            }

            if (s.NamXuatBan < 1000 ||
                s.NamXuatBan > DateTime.Today.Year + 1)
            {
                return KetQuaXuLy.Loi(
                    "Năm xuất bản không hợp lệ.");
            }

            if (s.SoLuongHienCo < 0)
            {
                return KetQuaXuLy.Loi(
                    "Số lượng không được âm.");
            }

            try
            {
                string sql;

                if (capNhat)
                {
                    sql = @"
                        UPDATE DauSach
                        SET
                            TenSach = @Ten,
                            NamXuatBan = @Nam,
                            SoLuongHienCo = @SL,
                            MaTheLoai = @TL,
                            MaNhaXuatBan = @NXB
                        WHERE MaDauSach = @Ma";
                }
                else
                {
                    sql = @"
                        INSERT INTO DauSach
                        (
                            MaDauSach,
                            TenSach,
                            NamXuatBan,
                            SoLuongHienCo,
                            MaTheLoai,
                            MaNhaXuatBan
                        )
                        VALUES
                        (
                            @Ma,
                            @Ten,
                            @Nam,
                            @SL,
                            @TL,
                            @NXB
                        ";
                }

                int n = Db.Execute(
                    sql,
                    new SqlParameter(
                        "@Ma",
                        s.MaDauSach.Trim()),

                    new SqlParameter(
                        "@Ten",
                        s.TenSach.Trim()),

                    new SqlParameter(
                        "@Nam",
                        s.NamXuatBan),

                    new SqlParameter(
                        "@SL",
                        s.SoLuongHienCo),

                    new SqlParameter(
                        "@TL",
                        s.MaTheLoai),

                    new SqlParameter(
                        "@NXB",
                        s.MaNhaXuatBan)
                );

                if (n > 0)
                {
                    return KetQuaXuLy.Ok(
                        capNhat
                            ? "Cập nhật đầu sách thành công."
                            : "Thêm đầu sách thành công.");
                }

                return KetQuaXuLy.Loi(
                    "Không có dữ liệu được thay đổi.");
            }
            catch (SqlException ex)
            {
                if (ex.Number == 2627 ||
                    ex.Number == 2601)
                {
                    return KetQuaXuLy.Loi(
                        "Mã đầu sách đã tồn tại.");
                }

                if (ex.Number == 547)
                {
                    return KetQuaXuLy.Loi(
                        "Thể loại hoặc nhà xuất bản không hợp lệ.");
                }

                return KetQuaXuLy.Loi(
                    "Lỗi cơ sở dữ liệu: " + ex.Message);
            }
        }

        // Xóa đầu sách
        public KetQuaXuLy Xoa(string ma)
        {
            if (string.IsNullOrWhiteSpace(ma))
            {
                return KetQuaXuLy.Loi(
                    "Mã đầu sách không được để trống.");
            }

            try
            {
                int n = Db.Execute(
                    "DELETE FROM DauSach WHERE MaDauSach = @Ma",
                    new SqlParameter("@Ma", ma.Trim())
                );

                if (n > 0)
                {
                    return KetQuaXuLy.Ok(
                        "Xóa đầu sách thành công.");
                }

                return KetQuaXuLy.Loi(
                    "Không tìm thấy đầu sách.");
            }
            catch (SqlException ex)
            {
                if (ex.Number == 547)
                {
                    return KetQuaXuLy.Loi(
                        "Không thể xóa đầu sách đã phát sinh giao dịch.");
                }

                return KetQuaXuLy.Loi(
                    "Lỗi cơ sở dữ liệu: " + ex.Message);
            }
        }
    }
}