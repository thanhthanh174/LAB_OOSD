using System;
using System.Data;
using System.Windows.Forms;
using QuanLyThuVien.Services;

namespace QuanLyThuVien.Forms
{
    public partial class FrmSach : Form
    {
        private SachService service = new SachService();

        public FrmSach()
        {
            InitializeComponent();
        }

        private void FrmSach_Load(object sender, EventArgs e)
        {
            dgvSach.ReadOnly = true;
            dgvSach.AllowUserToAddRows = false;
            dgvSach.AllowUserToDeleteRows = false;
            dgvSach.SelectionMode =
                DataGridViewSelectionMode.FullRowSelect;
            dgvSach.MultiSelect = false;
            dgvSach.AutoGenerateColumns = true;

            numNamXB.Minimum = 1000;
            numNamXB.Maximum = DateTime.Today.Year + 1;
            numNamXB.Value = DateTime.Today.Year;

            numSoLuong.Minimum = 0;
            numSoLuong.Maximum = 10000;
            numSoLuong.Value = 0;

            cboTheLoai.DropDownStyle =
                ComboBoxStyle.DropDownList;

            cboNXB.DropDownStyle =
                ComboBoxStyle.DropDownList;

            LoadTheLoai();
            LoadNXB();
            LoadSach();
        }

        private void LoadSach()
        {
            try
            {
                dgvSach.DataSource =
                    service.LayDanhSach(
                        txtTuKhoa.Text.Trim());
            }
            catch (Exception ex)
            {
                MessageBox.Show(
                    "Không thể tải danh sách đầu sách.\n\n" +
                    ex.Message,
                    "Lỗi",
                    MessageBoxButtons.OK,
                    MessageBoxIcon.Error);
            }
        }

        private void LoadTheLoai()
        {
            try
            {
                DataTable dt =
                    service.LayTheLoai();

                cboTheLoai.DataSource = dt;
                cboTheLoai.DisplayMember = "TenTheLoai";
                cboTheLoai.ValueMember = "MaTheLoai";
                cboTheLoai.SelectedIndex = -1;
            }
            catch (Exception ex)
            {
                MessageBox.Show(
                    "Không thể tải thể loại.\n\n" +
                    ex.Message,
                    "Lỗi",
                    MessageBoxButtons.OK,
                    MessageBoxIcon.Error);
            }
        }

        private void LoadNXB()
        {
            try
            {
                DataTable dt =
                    service.LayNhaXuatBan();

                cboNXB.DataSource = dt;
                cboNXB.DisplayMember = "DiaChi";
                cboNXB.ValueMember = "MaNhaXuatBan";
                cboNXB.SelectedIndex = -1;
            }
            catch (Exception ex)
            {
                MessageBox.Show(
                    "Không thể tải nhà xuất bản.\n\n" +
                    ex.Message,
                    "Lỗi",
                    MessageBoxButtons.OK,
                    MessageBoxIcon.Error);
            }
        }

        private void btnTimKiem_Click(
            object sender,
            EventArgs e)
        {
            LoadSach();
        }

        private void btnMoi_Click(
            object sender,
            EventArgs e)
        {
            txtMaSach.Clear();
            txtTenSach.Clear();
            txtTuKhoa.Clear();

            numNamXB.Value =
                DateTime.Today.Year;

            numSoLuong.Value = 0;

            cboTheLoai.SelectedIndex = -1;
            cboNXB.SelectedIndex = -1;

            dgvSach.ClearSelection();

            LoadSach();
        }

        private void btnThem_Click(
            object sender,
            EventArgs e)
        {
            MessageBox.Show(
                "Chức năng thêm đầu sách.",
                "Thông báo",
                MessageBoxButtons.OK,
                MessageBoxIcon.Information);
        }

        private void btnCapNhat_Click(
            object sender,
            EventArgs e)
        {
            MessageBox.Show(
                "Chức năng cập nhật đầu sách.",
                "Thông báo",
                MessageBoxButtons.OK,
                MessageBoxIcon.Information);
        }

        private void btnXoa_Click(
            object sender,
            EventArgs e)
        {
            MessageBox.Show(
                "Chức năng xóa đầu sách.",
                "Thông báo",
                MessageBoxButtons.OK,
                MessageBoxIcon.Information);
        }

        private void dgvSach_CellClick(
            object sender,
            DataGridViewCellEventArgs e)
        {
            if (e.RowIndex < 0)
                return;

            DataGridViewRow row =
                dgvSach.Rows[e.RowIndex];

            if (row.Cells["MaDauSach"] != null)
            {
                txtMaSach.Text =
                    Convert.ToString(
                        row.Cells["MaDauSach"].Value);
            }

            if (row.Cells["TenSach"] != null)
            {
                txtTenSach.Text =
                    Convert.ToString(
                        row.Cells["TenSach"].Value);
            }

            if (row.Cells["NamXuatBan"] != null &&
                row.Cells["NamXuatBan"].Value != null &&
                row.Cells["NamXuatBan"].Value != DBNull.Value)
            {
                decimal nam =
                    Convert.ToDecimal(
                        row.Cells["NamXuatBan"].Value);

                if (nam >= numNamXB.Minimum &&
                    nam <= numNamXB.Maximum)
                {
                    numNamXB.Value = nam;
                }
            }

            if (row.Cells["SoLuongHienCo"] != null &&
                row.Cells["SoLuongHienCo"].Value != null &&
                row.Cells["SoLuongHienCo"].Value != DBNull.Value)
            {
                decimal soLuong =
                    Convert.ToDecimal(
                        row.Cells["SoLuongHienCo"].Value);

                if (soLuong >= numSoLuong.Minimum &&
                    soLuong <= numSoLuong.Maximum)
                {
                    numSoLuong.Value = soLuong;
                }
            }

            if (row.Cells["MaTheLoai"] != null &&
                row.Cells["MaTheLoai"].Value != null &&
                row.Cells["MaTheLoai"].Value != DBNull.Value)
            {
                cboTheLoai.SelectedValue =
                    row.Cells["MaTheLoai"].Value.ToString();
            }

            if (row.Cells["MaNhaXuatBan"] != null &&
                row.Cells["MaNhaXuatBan"].Value != null &&
                row.Cells["MaNhaXuatBan"].Value != DBNull.Value)
            {
                cboNXB.SelectedValue =
                    row.Cells["MaNhaXuatBan"].Value.ToString();
            }
        }

        // Các hàm này được giữ lại vì FrmSach.Designer.cs
        // đang gắn sự kiện Click của Label vào chúng.

        private void label1_Click(
            object sender,
            EventArgs e)
        {
        }

        private void label7_Click(
            object sender,
            EventArgs e)
        {
        }
    }
}