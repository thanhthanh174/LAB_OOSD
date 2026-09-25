using System;
using System.Windows.Forms;
using QuanLyThuVien.Services;

namespace QuanLyThuVien.Forms
{
    public partial class FrmThongKe : Form
    {
        private readonly ThongKeService service =
            new ThongKeService();

        public FrmThongKe()
        {
            InitializeComponent();
        }

        private void FrmThongKe_Load(
            object sender,
            EventArgs e)
        {
            // Từ ngày đầu tháng hiện tại
            dtTu.Value =
                new DateTime(
                    DateTime.Today.Year,
                    DateTime.Today.Month,
                    1);

            // Đến ngày hôm nay
            dtDen.Value = DateTime.Today;

            TaiDuLieu();
        }

        private void TaiDuLieu()
        {
            try
            {
                ThongKeTongHop t =
                    service.LayTongHop(
                        dtTu.Value,
                        dtDen.Value);

                lblMuon.Text =
                    "Lượt sách mượn: " +
                    t.LuotSachMuon;

                lblQuaHan.Text =
                    "Sách quá hạn: " +
                    t.SachQuaHan;

                lblMat.Text =
                    "Sách mất: " +
                    t.SachMat;

                lblHuHong.Text =
                    "Sách hư hỏng: " +
                    t.SachHuHong;

                lblPhiPhat.Text =
                    "Tổng phí phạt: " +
                    t.TongPhiPhat.ToString("N0") +
                    " đ";

                dgvPhat.DataSource =
                    service.LayChiTietPhat(
                        dtTu.Value,
                        dtDen.Value);

                dgvPhat.AutoSizeColumnsMode =
                    DataGridViewAutoSizeColumnsMode.Fill;

                dgvPhat.ReadOnly = true;

                dgvPhat.AllowUserToAddRows = false;

                dgvPhat.AllowUserToDeleteRows = false;

                dgvPhat.SelectionMode =
                    DataGridViewSelectionMode.FullRowSelect;

                dgvPhat.MultiSelect = false;
            }
            catch (Exception ex)
            {
                MessageBox.Show(
                    "Không thể tải dữ liệu thống kê.\n\n" +
                    ex.Message,
                    "Lỗi",
                    MessageBoxButtons.OK,
                    MessageBoxIcon.Error);
            }
        }

        private void btnThongKe_Click(
            object sender,
            EventArgs e)
        {
            TaiDuLieu();
        }
    }
}