using System;
using System.Windows.Forms;

namespace QuanLyThuVien.Forms
{
    public partial class MainForm : Form
    {
        public MainForm()
        {
            InitializeComponent();
        }

        private void nhanVienToolStripMenuItem_Click(
            object sender, EventArgs e)
        {
            MessageBox.Show(
                "Chức năng quản lý Nhân viên đang được kết nối.",
                "Thông báo",
                MessageBoxButtons.OK,
                MessageBoxIcon.Information);
        }

        private void dauSachToolStripMenuItem_Click(
            object sender, EventArgs e)
        {
            MessageBox.Show(
                "Chức năng Quản lý Sách đang được kết nối.",
                "Thông báo",
                MessageBoxButtons.OK,
                MessageBoxIcon.Information);
        }

        private void docGiaTheToolStripMenuItem_Click(
            object sender, EventArgs e)
        {
            MessageBox.Show(
                "Chức năng Độc giả & Thẻ đang được kết nối.",
                "Thông báo",
                MessageBoxButtons.OK,
                MessageBoxIcon.Information);
        }

        private void muonTraToolStripMenuItem_Click(
            object sender, EventArgs e)
        {
            MessageBox.Show(
                "Chức năng Mượn trả sách đang được kết nối.",
                "Thông báo",
                MessageBoxButtons.OK,
                MessageBoxIcon.Information);
        }

        private void thongKeToolStripMenuItem_Click(
            object sender, EventArgs e)
        {
            MessageBox.Show(
                "Chức năng Thống kê báo cáo đang được kết nối.",
                "Thông báo",
                MessageBoxButtons.OK,
                MessageBoxIcon.Information);
        }

        private void danhMụcToolStripMenuItem_Click(
            object sender, EventArgs e)
        {
            MessageBox.Show(
                "Chức năng Danh mục đang được kết nối.",
                "Thông báo",
                MessageBoxButtons.OK,
                MessageBoxIcon.Information);
        }

        private void MainForm_Load(
            object sender, EventArgs e)
        {
            TestKetNoi();
        }

        private void label1_Click(
            object sender, EventArgs e)
        {
        }

        private void button1_Click(
            object sender, EventArgs e)
        {
            FrmDanhMuc frm = new FrmDanhMuc();
            frm.ShowDialog();
        }

        private void button2_Click(
            object sender, EventArgs e)
        {
            FrmDocGia frm = new FrmDocGia();
            frm.ShowDialog();
        }

        private void btnSach_Click(
            object sender, EventArgs e)
        {
            FrmSach frm = new FrmSach();
            frm.ShowDialog();
        }

        private void btnMuonTra_Click(
            object sender, EventArgs e)
        {
            FrmMuonTra frm = new FrmMuonTra();
            frm.ShowDialog();
        }

        private void btnThongKe_Click(
            object sender, EventArgs e)
        {
            FrmThongKe frm = new FrmThongKe();
            frm.ShowDialog();
        }

        private void btnThoat_Click(
            object sender, EventArgs e)
        {
            Application.Exit();
        }

        private void TestKetNoi()
        {
            try
            {
                using (var cn =
                    QuanLyThuVien.Data.Db.OpenConnection())
                {
                    MessageBox.Show(
                        "Kết nối SQL Server thành công!",
                        "Thông báo",
                        MessageBoxButtons.OK,
                        MessageBoxIcon.Information);
                }
            }
            catch (Exception ex)
            {
                MessageBox.Show(
                    "Kết nối thất bại!\n\n" + ex.Message,
                    "Lỗi kết nối",
                    MessageBoxButtons.OK,
                    MessageBoxIcon.Error);
            }
        }
    }
}