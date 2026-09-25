using System;
using System.Data;
using System.Data.SqlClient;
using QuanLyThuVien.Data;

namespace QuanLyThuVien.Services
{
    public class ThongKeService
    {
        public ThongKeTongHop LayThongKeTongHop(DateTime tuNgay, DateTime denNgay)
        {
            ThongKeTongHop tk = new ThongKeTongHop();
            try
            {
                object oMuon = Db.Scalar("SELECT COUNT(*) FROM ChiTietPhieuMuon ct JOIN PhieuMuon pm ON pm.MaPhieuMuon=ct.MaPhieuMuon WHERE pm.NgayMuon BETWEEN @Tu AND @Den",
                    new SqlParameter("@Tu", tuNgay.Date), new SqlParameter("@Den", denNgay.Date));
                tk.LuotSachMuon = oMuon != null ? Convert.ToInt32(oMuon) : 0;

                object oQuaHan = Db.Scalar("SELECT COUNT(*) FROM ChiTietPhieuMuon ct JOIN PhieuMuon pm ON pm.MaPhieuMuon=ct.MaPhieuMuon WHERE ct.NgayTraThucTe IS NULL AND pm.NgayHenTra < CAST(GETDATE() AS date)");
                tk.SachQuaHan = oQuaHan != null ? Convert.ToInt32(oQuaHan) : 0;

                object oMat = Db.Scalar("SELECT COUNT(*) FROM ChiTietPhieuMuon WHERE TinhTrangTra LIKE N'%Mất%' OR TinhTrangTra LIKE N'%Mat%'");
                tk.SachMat = oMat != null ? Convert.ToInt32(oMat) : 0;

                object oHu = Db.Scalar("SELECT COUNT(*) FROM ChiTietPhieuMuon WHERE TinhTrangTra LIKE N'%Rách%' OR TinhTrangTra LIKE N'%Hư%' OR TinhTrangTra LIKE N'%Hu%'");
                tk.SachHuHong = oHu != null ? Convert.ToInt32(oHu) : 0;

                object oPhi = Db.Scalar("SELECT SUM(PhiPhat) FROM PhieuPhat WHERE NgayPhat BETWEEN @Tu AND @Den",
                    new SqlParameter("@Tu", tuNgay.Date), new SqlParameter("@Den", denNgay.Date));
                tk.TongPhiPhat = (oPhi != null && oPhi != DBNull.Value) ? Convert.ToDecimal(oPhi) : 0m;
            }
            catch
            {
            }
            return tk;
        }

        public DataTable LayDanhSachQuaHan()
        {
            return Db.Query(@"SELECT pm.MaPhieuMuon, dg.MaDocGia, (dg.Ho + ' ' + dg.Ten) AS HoTenDocGia, 
                                     dg.SoDienThoai, s.MaDauSach, s.TenSach, pm.NgayMuon, pm.NgayHenTra
                              FROM PhieuMuon pm
                              JOIN ChiTietPhieuMuon ct ON ct.MaPhieuMuon = pm.MaPhieuMuon
                              JOIN DocGia dg ON dg.MaDocGia = pm.MaDocGia
                              JOIN DauSach s ON s.MaDauSach = ct.MaDauSach
                              WHERE ct.NgayTraThucTe IS NULL AND pm.NgayHenTra < CAST(GETDATE() AS date)
                              ORDER BY pm.NgayHenTra");
        }
    }
}