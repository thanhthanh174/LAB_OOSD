using System;
using System.Data;
using System.Windows.Forms;
using QuanLyThuVien.Services;

namespace QuanLyThuVien.Forms
{
    public partial class FrmDocGia : Form
    {
        private readonly DocGiaService service =
            new DocGiaService();

        public FrmDocGia()
        {
            InitializeComponent();
        }

        private void FrmDocGia_Load(
            object sender,
            EventArgs e)
        {
            // ComboBox phái
            cboPhai.Items.Clear();
            cboPhai.Items.Add("Nam");
            cboPhai.Items.Add("Nữ");
            cboPhai.Items.Add("Khác");

            if (cboPhai.Items.Count > 0)
                cboPhai.SelectedIndex = 0;

            // Ngày cấp và hạn thẻ
            dtNgayCap.Value = DateTime.Today;
            dtHanSuDung.Value =
                DateTime.Today.AddYears(1);

            // Cấu hình bảng
            dgvDocGia.ReadOnly = true;
            dgvDocGia.AllowUserToAddRows = false;
            dgvDocGia.AllowUserToDeleteRows = false;
            dgvDocGia.SelectionMode =
                DataGridViewSelectionMode.FullRowSelect;
            dgvDocGia.MultiSelect = false;
            dgvDocGia.AutoGenerateColumns = true;

            TaiDuLieu();
            LamMoi();
        }

        private void TaiDuLieu()
        {
            try
            {
                dgvDocGia.DataSource =
                    service.LayDanhSach();

                dgvDocGia.AutoSizeColumnsMode =
                    DataGridViewAutoSizeColumnsMode.DisplayedCells;
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

        private DocGia LayForm()
        {
            return new DocGia
            {
                MaDocGia = txtMaDocGia.Text.Trim(),

                Ho = txtHo.Text.Trim(),

                Ten = txtTen.Text.Trim(),

                NgaySinh = dtNgaySinh.Value.Date,

                Phai = Convert.ToString(
                    cboPhai.SelectedItem),

                SoDienThoai =
                    txtSoDienThoai.Text.Trim(),

                DiaChi =
                    txtDiaChi.Text.Trim(),

                Email =
                    txtEmail.Text.Trim(),

                Anh3x4 =
                    txtAnh3x4.Text.Trim()
            };
        }

        private void HienKetQua(
            KetQuaXuLy kq)
        {
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
                TaiDuLieu();
                LamMoi();
            }
        }

        private void btnThem_Click(
            object sender,
            EventArgs e)
        {
            HienKetQua(
                service.Luu(
                    LayForm(),
                    false));
        }

        private void btnCapNhat_Click(
            object sender,
            EventArgs e)
        {
            HienKetQua(
                service.Luu(
                    LayForm(),
                    true));
        }

        private void btnCapThe_Click(
            object sender,
            EventArgs e)
        {
            if (string.IsNullOrWhiteSpace(
                txtMaDocGia.Text))
            {
                MessageBox.Show(
                    "Vui lòng chọn độc giả.",
                    "Thông báo",
                    MessageBoxButtons.OK,
                    MessageBoxIcon.Warning);

                return;
            }

            HienKetQua(
                service.CapThe(
                    txtMaDocGia.Text.Trim(),
                    dtNgayCap.Value,
                    dtHanSuDung.Value,
                    chkDaDongLePhi.Checked));
        }

        private void btnGiaHan_Click(
            object sender,
            EventArgs e)
        {
            if (string.IsNullOrWhiteSpace(
                txtMaDocGia.Text))
            {
                MessageBox.Show(
                    "Vui lòng chọn độc giả.",
                    "Thông báo",
                    MessageBoxButtons.OK,
                    MessageBoxIcon.Warning);

                return;
            }

            HienKetQua(
                service.GiaHanThe(
                    txtMaDocGia.Text.Trim(),
                    dtHanSuDung.Value,
                    chkDaDongLePhi.Checked));
        }

        private void dgvDocGia_SelectionChanged(
            object sender,
            EventArgs e)
        {
            if (dgvDocGia.CurrentRow == null)
                return;

            if (dgvDocGia.CurrentRow.DataBoundItem == null)
                return;

            DataRowView r =
                dgvDocGia.CurrentRow.DataBoundItem
                as DataRowView;

            if (r == null)
                return;

            txtMaDocGia.Text =
                Convert.ToString(
                    r["MaDocGia"]);

            txtHo.Text =
                Convert.ToString(
                    r["Ho"]);

            txtTen.Text =
                Convert.ToString(
                    r["Ten"]);

            if (r["NgaySinh"] != DBNull.Value)
            {
                dtNgaySinh.Value =
                    Convert.ToDateTime(
                        r["NgaySinh"]);
            }

            string phai =
                Convert.ToString(r["Phai"]);

            if (!string.IsNullOrWhiteSpace(phai))
            {
                cboPhai.SelectedItem = phai;
            }

            txtSoDienThoai.Text =
                Convert.ToString(
                    r["SoDienThoai"]);

            txtDiaChi.Text =
                Convert.ToString(
                    r["DiaChi"]);

            txtEmail.Text =
                Convert.ToString(
                    r["Email"]);

            txtAnh3x4.Text =
                Convert.ToString(
                    r["Anh3x4"]);

            if (r["NgayCap"] != DBNull.Value)
            {
                dtNgayCap.Value =
                    Convert.ToDateTime(
                        r["NgayCap"]);
            }

            if (r["HanSuDung"] != DBNull.Value)
            {
                dtHanSuDung.Value =
                    Convert.ToDateTime(
                        r["HanSuDung"]);
            }

            chkDaDongLePhi.Checked =
                r["DaDongLePhi"] != DBNull.Value
                &&
                Convert.ToBoolean(
                    r["DaDongLePhi"]);
        }

        private void LamMoi()
        {
            txtMaDocGia.Clear();
            txtHo.Clear();
            txtTen.Clear();
            txtSoDienThoai.Clear();
            txtDiaChi.Clear();
            txtEmail.Clear();
            txtAnh3x4.Clear();

            dtNgaySinh.Value =
                DateTime.Today.AddYears(-18);

            dtNgayCap.Value =
                DateTime.Today;

            dtHanSuDung.Value =
                DateTime.Today.AddYears(1);

            chkDaDongLePhi.Checked = true;

            if (cboPhai.Items.Count > 0)
                cboPhai.SelectedIndex = 0;

            txtMaDocGia.ReadOnly = false;

            btnThem.Enabled = true;
            btnCapNhat.Enabled = false;

            dgvDocGia.ClearSelection();

            txtMaDocGia.Focus();
        }

        private void btnLamMoi_Click(
            object sender,
            EventArgs e)
        {
            LamMoi();
        }

        private void btnDong_Click(
            object sender,
            EventArgs e)
        {
            Close();
        }
    }
}