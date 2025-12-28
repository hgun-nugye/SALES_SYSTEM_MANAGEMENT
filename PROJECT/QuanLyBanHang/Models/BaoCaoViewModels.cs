using System.ComponentModel.DataAnnotations;

namespace QuanLyBanHang.Models
{
    public class DoanhThuDto
    {
        public string MaDBH { get; set; } = string.Empty;
        public DateTime NgayBH { get; set; }
        public string TenKH { get; set; } = string.Empty;
        public decimal TongTien { get; set; }
    }

    public class ChiTietHoaDonDto
    {
        public string MaDBH { get; set; } = string.Empty;
        public DateTime NgayBH { get; set; }
        public string TenKH { get; set; } = string.Empty;
        public string? DiaChi { get; set; }
        public string MaSP { get; set; } = string.Empty;
        public string TenSP { get; set; } = string.Empty;
        public int SoLuong { get; set; }
        public decimal DonGia { get; set; }
        public decimal ThanhTien => SoLuong * DonGia;
    }

    public class SanPhamBanChayDto
    {
        public string MaSP { get; set; } = string.Empty;
        public string TenSP { get; set; } = string.Empty;
        public int SoLuongBan { get; set; }
        public decimal DoanhThu { get; set; }
    }

    public class SanPhamTonKhoDto
    {
        public string MaSP { get; set; } = string.Empty;
        public string TenSP { get; set; } = string.Empty;
        public int? SoLuongTon { get; set; }
        public decimal? GiaBan { get; set; }
    }

    public class BaoCaoViewModel
    {
        public List<DoanhThuDto> DoanhThuTheoThoiGian { get; set; } = new();
        public List<SanPhamBanChayDto> TopSanPhamBanChay { get; set; } = new();
        public List<SanPhamTonKhoDto> SanPhamTonKhoNhieu { get; set; } = new();
        
        public decimal TongDoanhThu => DoanhThuTheoThoiGian.Sum(x => x.TongTien);
        public int TongDonHang => DoanhThuTheoThoiGian.Count;

        // Cho biểu đồ
        public List<string> LabelsDoanhThu { get; set; } = new();
        public List<decimal> ValuesDoanhThu { get; set; } = new();
    }
}
