using System;
using System.Data;
using System.Windows.Forms;
using QuanLyThuVien.Services;

namespace QuanLyThuVien.Forms
{
    public partial class FrmDanhMuc : Form
    {
        private NhanVienService service = new NhanVienService();

        public FrmDanhMuc()
        {
            InitializeComponent();

            // Gắn sự kiện bằng code
            this.Load += FrmDanhMuc_Load;

            btnThem.Click += btnNVThem_Click;
            btnCapNhat.Click += btnNVCapNhat_Click;
            btnXoa.Click += btnNVXoa_Click;
            btnMoi.Click += btnNVMoi_Click;

            dgvNV.CellClick += dgvNV_CellClick;
        }

        private void FrmDanhMuc_Load(object sender, EventArgs e)
        {
            // Combobox phái
            cboNVPhai.Items.Clear();
            cboNVPhai.Items.Add("Nam");
            cboNVPhai.Items.Add("Nữ");

            cboNVPhai.SelectedIndex = -1;

            // Cấu hình DataGridView
            dgvNV.ReadOnly = true;
            dgvNV.AllowUserToAddRows = false;
            dgvNV.AllowUserToDeleteRows = false;
            dgvNV.SelectionMode = DataGridViewSelectionMode.FullRowSelect;
            dgvNV.MultiSelect = false;
            dgvNV.AutoGenerateColumns = true;

            LoadNhanVien();
        }

        private void LoadNhanVien()
        {
            try
            {
                dgvNV.DataSource = service.LayDanhSach();

                if (dgvNV.Columns["MaNhanVien"] != null)
                    dgvNV.Columns["MaNhanVien"].HeaderText = "Mã nhân viên";

                if (dgvNV.Columns["Ho"] != null)
                    dgvNV.Columns["Ho"].HeaderText = "Họ";

                if (dgvNV.Columns["Ten"] != null)
                    dgvNV.Columns["Ten"].HeaderText = "Tên";

                if (dgvNV.Columns["Phai"] != null)
                    dgvNV.Columns["Phai"].HeaderText = "Phái";

                if (dgvNV.Columns["NgaySinh"] != null)
                    dgvNV.Columns["NgaySinh"].HeaderText = "Ngày sinh";

                if (dgvNV.Columns["ChucVu"] != null)
                    dgvNV.Columns["ChucVu"].HeaderText = "Chức vụ";

                if (dgvNV.Columns["SoDienThoai"] != null)
                    dgvNV.Columns["SoDienThoai"].HeaderText = "Số điện thoại";
            }
            catch (Exception ex)
            {
                MessageBox.Show(
                    "Không thể tải danh sách nhân viên.\n\n" + ex.Message,
                    "Lỗi",
                    MessageBoxButtons.OK,
                    MessageBoxIcon.Error);
            }
        }

        private void btnNVThem_Click(object sender, EventArgs e)
        {
            try
            {
                NhanVien nv = LayDuLieuTuForm();

                KetQuaXuLy kq = service.Them(nv);

                MessageBox.Show(
                    kq.ThongBao,
                    kq.ThanhCong ? "Thông báo" : "Lỗi",
                    MessageBoxButtons.OK,
                    kq.ThanhCong
                        ? MessageBoxIcon.Information
                        : MessageBoxIcon.Warning);

                if (kq.ThanhCong)
                {
                    LoadNhanVien();
                    XoaTrangNhanVien();
                }
            }
            catch (Exception ex)
            {
                MessageBox.Show(
                    "Có lỗi xảy ra:\n\n" + ex.Message,
                    "Lỗi",
                    MessageBoxButtons.OK,
                    MessageBoxIcon.Error);
            }
        }

        private void btnNVCapNhat_Click(object sender, EventArgs e)
        {
            try
            {
                NhanVien nv = LayDuLieuTuForm();

                KetQuaXuLy kq = service.CapNhat(nv);

                MessageBox.Show(
                    kq.ThongBao,
                    kq.ThanhCong ? "Thông báo" : "Lỗi",
                    MessageBoxButtons.OK,
                    kq.ThanhCong
                        ? MessageBoxIcon.Information
                        : MessageBoxIcon.Warning);

                if (kq.ThanhCong)
                {
                    LoadNhanVien();
                    XoaTrangNhanVien();
                }
            }
            catch (Exception ex)
            {
                MessageBox.Show(
                    "Có lỗi xảy ra:\n\n" + ex.Message,
                    "Lỗi",
                    MessageBoxButtons.OK,
                    MessageBoxIcon.Error);
            }
        }

        private void btnNVXoa_Click(object sender, EventArgs e)
        {
            string ma = txtNVMa.Text.Trim();

            if (string.IsNullOrWhiteSpace(ma))
            {
                MessageBox.Show(
                    "Vui lòng chọn nhân viên cần xóa.",
                    "Thông báo",
                    MessageBoxButtons.OK,
                    MessageBoxIcon.Warning);
                return;
            }

            DialogResult hoi = MessageBox.Show(
                "Bạn có chắc muốn xóa nhân viên " + ma + " không?",
                "Xác nhận xóa",
                MessageBoxButtons.YesNo,
                MessageBoxIcon.Question);

            if (hoi != DialogResult.Yes)
                return;

            try
            {
                KetQuaXuLy kq = service.Xoa(ma);

                MessageBox.Show(
                    kq.ThongBao,
                    kq.ThanhCong ? "Thông báo" : "Lỗi",
                    MessageBoxButtons.OK,
                    kq.ThanhCong
                        ? MessageBoxIcon.Information
                        : MessageBoxIcon.Warning);

                if (kq.ThanhCong)
                {
                    LoadNhanVien();
                    XoaTrangNhanVien();
                }
            }
            catch (Exception ex)
            {
                MessageBox.Show(
                    "Có lỗi xảy ra:\n\n" + ex.Message,
                    "Lỗi",
                    MessageBoxButtons.OK,
                    MessageBoxIcon.Error);
            }
        }

        private void btnNVMoi_Click(object sender, EventArgs e)
        {
            XoaTrangNhanVien();
        }

        private NhanVien LayDuLieuTuForm()
        {
            DateTime ngaySinh = dtNVNgaySinh.Value.Date;

            return new NhanVien
            {
                MaNhanVien = txtNVMa.Text.Trim(),
                Ho = txtNVHo.Text.Trim(),
                Ten = txtNVTen.Text.Trim(),
                Phai = cboNVPhai.Text.Trim(),
                NgaySinh = ngaySinh,
                ChucVu = txtNVChucVu.Text.Trim(),
                SoDienThoai = txtNVSDT.Text.Trim()
            };
        }

        private void XoaTrangNhanVien()
        {
            txtNVMa.Clear();
            txtNVHo.Clear();
            txtNVTen.Clear();
            txtNVChucVu.Clear();
            txtNVSDT.Clear();

            cboNVPhai.SelectedIndex = -1;

            dtNVNgaySinh.Value = DateTime.Today;

            txtNVMa.Focus();

            dgvNV.ClearSelection();
        }

        private void dgvNV_CellClick(
            object sender,
            DataGridViewCellEventArgs e)
        {
            if (e.RowIndex < 0)
                return;

            DataGridViewRow row = dgvNV.Rows[e.RowIndex];

            txtNVMa.Text =
                Convert.ToString(row.Cells["MaNhanVien"].Value);

            txtNVHo.Text =
                Convert.ToString(row.Cells["Ho"].Value);

            txtNVTen.Text =
                Convert.ToString(row.Cells["Ten"].Value);

            cboNVPhai.Text =
                Convert.ToString(row.Cells["Phai"].Value);

            if (row.Cells["NgaySinh"].Value != null &&
                row.Cells["NgaySinh"].Value != DBNull.Value)
            {
                dtNVNgaySinh.Value =
                    Convert.ToDateTime(
                        row.Cells["NgaySinh"].Value);
            }

            txtNVChucVu.Text =
                Convert.ToString(row.Cells["ChucVu"].Value);

            txtNVSDT.Text =
                Convert.ToString(row.Cells["SoDienThoai"].Value);
        }

        // Các event Visual Studio đã tạo sẵn
        private void tabPage1_Click(object sender, EventArgs e)
        {
        }

        private void label3_Click(object sender, EventArgs e)
        {
        }

        private void dgvNV_CellContentClick(
            object sender,
            DataGridViewCellEventArgs e)
        {
        }

        private void label14_Click(object sender, EventArgs e)
        {

        }

        private void tabPage2_Click(object sender, EventArgs e)
        {

        }
    }
}