using Microsoft.AspNetCore.Mvc;
using QuanLyBanHang.Filters;
using QuanLyBanHang.Models;
using QuanLyBanHang.Services;

namespace QuanLyBanHang.Controllers
{
    [Authorize]
    public class BaoCaoController : Controller
    {
        private readonly BaoCaoService _baoCaoService;

        public BaoCaoController(BaoCaoService baoCaoService)
        {
            _baoCaoService = baoCaoService;
        }

        public async Task<IActionResult> Index(int? month, int? year)
        {
            int currentYear = year ?? DateTime.Now.Year;
            int? currentMonth = month;

            var model = new BaoCaoViewModel();
            model.DoanhThuTheoThoiGian = await _baoCaoService.GetDoanhThu(currentMonth, currentYear);
            model.TopSanPhamBanChay = await _baoCaoService.GetSanPhamBanChay(5);
            model.SanPhamTonKhoNhieu = await _baoCaoService.GetSanPhamTonKho(5);

            // Doanh thu theo tháng trong năm (cho biểu đồ)
            var stats = await _baoCaoService.GetDoanhThuTheoThang(currentYear);
            
            // Khởi tạo label cho 12 tháng
            for (int i = 1; i <= 12; i++)
            {
                model.LabelsDoanhThu.Add($"T{i}");
                var monthStat = stats.FirstOrDefault(s => s.Thang == i);
                model.ValuesDoanhThu.Add(monthStat?.DoanhThu ?? 0);
            }

            ViewBag.Month = currentMonth;
            ViewBag.Year = currentYear;

            return View(model);
        }

        public async Task<IActionResult> ExportDoanhThu(int? month, int? year)
        {
            var data = await _baoCaoService.GetChiTietHoaDon(month, year);
            
            var builder = new System.Text.StringBuilder();
                       
            // Header đầy đủ Tiếng Việt có dấu
            builder.AppendLine("Mã Đơn Hàng,Ngày Bán,Khách Hàng,Địa Chỉ,Mã Sản Phẩm,Tên Sản Phẩm,Số Lượng,Đơn Giá,Thành Tiền");
            
            foreach (var item in data)
            {
                // Escape các trường có thể chứa dấu phẩy
                string maDBH = (item.MaDBH ?? "").Replace("\"", "\"\"");
                string tenKH = (item.TenKH ?? "").Replace("\"", "\"\"");
                string diaChi = (item.DiaChi ?? "").Replace("\"", "\"\"");
                string tenSP = (item.TenSP ?? "").Replace("\"", "\"\"");

                // Xuất dòng dữ liệu, sử dụng định dạng số máy tính (không có dấu phân cách hàng ngàn để tránh nhầm lẫn)
                builder.AppendLine($"\"{maDBH}\",\"{item.NgayBH:dd/MM/yyyy}\",\"{tenKH}\",\"{diaChi}\",\"{item.MaSP}\",\"{tenSP}\",{item.SoLuong},{item.DonGia:F0},{item.ThanhTien:F0}");
            }

            var fileName = $"BaoCao_ChiTiet_BanHang_{(month.HasValue ? $"Thang{month}_" : "")}Nam{year}.csv";
            
            // Trả về file với UTF-8 + BOM để Excel hiển thị đúng Tiếng Việt
            return File(System.Text.Encoding.UTF8.GetPreamble().Concat(System.Text.Encoding.UTF8.GetBytes(builder.ToString())).ToArray(), 
                "text/csv; charset=utf-8", fileName);
        }
    }
}
