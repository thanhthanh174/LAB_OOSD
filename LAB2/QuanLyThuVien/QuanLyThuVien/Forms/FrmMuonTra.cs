using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Windows.Forms;
using QuanLyThuVien.Data;
using QuanLyThuVien.Services;

namespace QuanLyThuVien.Forms
{
    public partial class FrmMuonTra : Form
    {
        private readonly MuonTraService service =
            new MuonTraService();

        // Danh sách mã đầu sách đã chọn
        private readonly List<string> sachDaChon =
            new List<string>();

        public FrmMuonTra()
        {
            InitializeComponent();
        }

        // =====================================================
        // LOAD FORM
        // =====================================================

        private void FrmMuonTra_Load(object sender, EventArgs e)
        {
            CauHinhForm();

            TaiDocGia();
            TaiNhanVien();
            TaiSachCon();

            dtNgayMuon.Value = DateTime.Today;
            dtHenTra.Value = DateTime.Today.AddDays(14);

            lblTrangThai.Text =
                "Chưa kiểm tra điều kiện mượn.";
        }

        // =====================================================
        // CẤU HÌNH
        // =====================================================

        private void CauHinhForm()
        {
            cboDocGia.DropDownStyle =
                ComboBoxStyle.DropDownList;

            cboNhanVienMuon.DropDownStyle =
                ComboBoxStyle.DropDownList;

            dgvSachCon.ReadOnly = true;
            dgvSachCon.AllowUserToAddRows = false;
            dgvSachCon.AllowUserToDeleteRows = false;
            dgvSachCon.SelectionMode =
                DataGridViewSelectionMode.FullRowSelect;
            dgvSachCon.MultiSelect = false;
            dgvSachCon.AutoGenerateColumns = true;

            dgvSachChon.ReadOnly = true;
            dgvSachChon.AllowUserToAddRows = false;
            dgvSachChon.AllowUserToDeleteRows = false;
            dgvSachChon.SelectionMode =
                DataGridViewSelectionMode.FullRowSelect;
            dgvSachChon.MultiSelect = false;
            dgvSachChon.AutoGenerateColumns = true;
        }

        // =====================================================
        // TẢI ĐỘC GIẢ
        // =====================================================

        private void TaiDocGia()
        {
            try
            {
                DataTable dt = Db.Query(@"
                    SELECT
                        MaDocGia,
                        Ho + ' ' + Ten AS HoTen
                    FROM DocGia
                    ORDER BY Ho, Ten");

                cboDocGia.DataSource = dt;
                cboDocGia.DisplayMember = "HoTen";
                cboDocGia.ValueMember = "MaDocGia";
                cboDocGia.SelectedIndex = -1;
            }
            catch (Exception ex)
            {
                MessageBox.Show(
                    "Không thể tải danh sách độc giả.\n\n" +
                    ex.Message,
                    "Lỗi",
                    MessageBoxButtons.OK,
                    MessageBoxIcon.Error);
            }
        }

        // =====================================================
        // TẢI NHÂN VIÊN
        // =====================================================

        private void TaiNhanVien()
        {
            try
            {
                DataTable dt = Db.Query(@"
                    SELECT
                        MaNhanVien,
                        Ho + ' ' + Ten AS HoTen
                    FROM NhanVien
                    ORDER BY Ho, Ten");

                cboNhanVienMuon.DataSource = dt;
                cboNhanVienMuon.DisplayMember = "HoTen";
                cboNhanVienMuon.ValueMember = "MaNhanVien";
                cboNhanVienMuon.SelectedIndex = -1;
            }
            catch (Exception ex)
            {
                MessageBox.Show(
                    "Không thể tải danh sách nhân viên.\n\n" +
                    ex.Message,
                    "Lỗi",
                    MessageBoxButtons.OK,
                    MessageBoxIcon.Error);
            }
        }

        // =====================================================
        // TẢI SÁCH CÒN TRONG KHO
        // =====================================================

        private void TaiSachCon()
        {
            try
            {
                dgvSachCon.DataSource = Db.Query(@"
                    SELECT
                        MaDauSach,
                        TenSach,
                        NamXuatBan,
                        SoLuongHienCo
                    FROM DauSach
                    WHERE SoLuongHienCo > 0
                    ORDER BY TenSach");

                dgvSachCon.AutoSizeColumnsMode =
                    DataGridViewAutoSizeColumnsMode.DisplayedCells;
            }
            catch (Exception ex)
            {
                MessageBox.Show(
                    "Không thể tải danh sách sách.\n\n" +
                    ex.Message,
                    "Lỗi",
                    MessageBoxButtons.OK,
                    MessageBoxIcon.Error);
            }
        }

        // =====================================================
        // KIỂM TRA ĐIỀU KIỆN MƯỢN
        // =====================================================

        private void btnKiemTra_Click(
            object sender,
            EventArgs e)
        {
            if (cboDocGia.SelectedValue == null)
            {
                MessageBox.Show(
                    "Vui lòng chọn độc giả.",
                    "Thông báo",
                    MessageBoxButtons.OK,
                    MessageBoxIcon.Warning);

                return;
            }

            KetQuaXuLy kq =
                service.KiemTraDieuKienMuon(
                    cboDocGia.SelectedValue.ToString(),
                    sachDaChon.Count);

            lblTrangThai.Text = kq.ThongBao;

            MessageBox.Show(
                kq.ThongBao,
                kq.ThanhCong
                    ? "Thông báo"
                    : "Không đủ điều kiện",
                MessageBoxButtons.OK,
                kq.ThanhCong
                    ? MessageBoxIcon.Information
                    : MessageBoxIcon.Warning);
        }

        // =====================================================
        // THÊM SÁCH
        // =====================================================

        private void btnThemSach_Click(
            object sender,
            EventArgs e)
        {
            if (dgvSachCon.CurrentRow == null)
            {
                MessageBox.Show(
                    "Vui lòng chọn đầu sách cần mượn.",
                    "Thông báo",
                    MessageBoxButtons.OK,
                    MessageBoxIcon.Warning);

                return;
            }

            string maSach =
                Convert.ToString(
                    dgvSachCon.CurrentRow
                        .Cells["MaDauSach"].Value);

            if (string.IsNullOrWhiteSpace(maSach))
                return;

            if (sachDaChon.Contains(maSach))
            {
                MessageBox.Show(
                    "Đầu sách này đã được chọn.",
                    "Thông báo",
                    MessageBoxButtons.OK,
                    MessageBoxIcon.Warning);

                return;
            }

            if (sachDaChon.Count >= 3)
            {
                MessageBox.Show(
                    "Mỗi phiếu chỉ được mượn tối đa 3 đầu sách.",
                    "Thông báo",
                    MessageBoxButtons.OK,
                    MessageBoxIcon.Warning);

                return;
            }

            sachDaChon.Add(maSach);

            HienThiSachDaChon();
        }

        // =====================================================
        // HIỂN THỊ SÁCH ĐÃ CHỌN
        // =====================================================

        private void HienThiSachDaChon()
        {
            DataTable dt =
                new DataTable();

            dt.Columns.Add("MaDauSach");
            dt.Columns.Add("TenSach");
            dt.Columns.Add("NamXuatBan");
            dt.Columns.Add("SoLuongHienCo");

            foreach (string maSach in sachDaChon)
            {
                DataTable temp =
                    Db.Query(@"
                        SELECT
                            MaDauSach,
                            TenSach,
                            NamXuatBan,
                            SoLuongHienCo
                        FROM DauSach
                        WHERE MaDauSach = @Ma",
                        new SqlParameter(
                            "@Ma",
                            maSach));

                if (temp.Rows.Count > 0)
                {
                    dt.ImportRow(temp.Rows[0]);
                }
            }

            dgvSachChon.DataSource = dt;

            dgvSachChon.AutoSizeColumnsMode =
                DataGridViewAutoSizeColumnsMode.DisplayedCells;
        }

        // =====================================================
        // BỎ SÁCH
        // =====================================================

        private void btnBoSach_Click(
            object sender,
            EventArgs e)
        {
            if (dgvSachChon.CurrentRow == null)
            {
                MessageBox.Show(
                    "Vui lòng chọn sách cần bỏ.",
                    "Thông báo",
                    MessageBoxButtons.OK,
                    MessageBoxIcon.Warning);

                return;
            }

            string maSach =
                Convert.ToString(
                    dgvSachChon.CurrentRow
                        .Cells["MaDauSach"].Value);

            if (!string.IsNullOrWhiteSpace(maSach))
            {
                sachDaChon.Remove(maSach);
            }

            HienThiSachDaChon();
        }

        // =====================================================
        // LẬP PHIẾU MƯỢN
        // =====================================================

        private void btnLapPhieu_Click(
            object sender,
            EventArgs e)
        {
            if (cboDocGia.SelectedValue == null)
            {
                MessageBox.Show(
                    "Vui lòng chọn độc giả.",
                    "Thông báo",
                    MessageBoxButtons.OK,
                    MessageBoxIcon.Warning);

                return;
            }

            if (cboNhanVienMuon.SelectedValue == null)
            {
                MessageBox.Show(
                    "Vui lòng chọn nhân viên lập phiếu.",
                    "Thông báo",
                    MessageBoxButtons.OK,
                    MessageBoxIcon.Warning);

                return;
            }

            if (sachDaChon.Count == 0)
            {
                MessageBox.Show(
                    "Vui lòng chọn ít nhất 1 đầu sách.",
                    "Thông báo",
                    MessageBoxButtons.OK,
                    MessageBoxIcon.Warning);

                return;
            }

            KetQuaXuLy kq =
                service.LapPhieuMuon(
                    cboDocGia.SelectedValue.ToString(),
                    cboNhanVienMuon.SelectedValue.ToString(),
                    sachDaChon,
                    dtNgayMuon.Value,
                    dtHenTra.Value);

            MessageBox.Show(
                kq.ThongBao,
                kq.ThanhCong
                    ? "Thông báo"
                    : "Lỗi",
                MessageBoxButtons.OK,
                kq.ThanhCong
                    ? MessageBoxIcon.Information
                    : MessageBoxIcon.Warning);

            if (kq.ThanhCong)
            {
                sachDaChon.Clear();

                dgvSachChon.DataSource = null;

                TaiSachCon();

                lblTrangThai.Text =
                    "Đã lập phiếu mượn thành công.";
            }
        }

        // =====================================================
        // NÚT ĐÓNG
        // =====================================================

        private void btnDong_Click(
            object sender,
            EventArgs e)
        {
            Close();
        }

        private void label7_Click(object sender, EventArgs e)
        {
        }
    }
}