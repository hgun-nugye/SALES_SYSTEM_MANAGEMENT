using Microsoft.EntityFrameworkCore;
using QuanLyBanHang.Models;

namespace QuanLyBanHang.Services
{
    public class BaoCaoService
    {
        private readonly AppDbContext _context;

        public BaoCaoService(AppDbContext context)
        {
            _context = context;
        }

        public async Task<List<ChiTietHoaDonDto>> GetChiTietHoaDon(int? month, int? year)
        {
            var query = _context.DonBanHang.AsQueryable();

            if (month.HasValue && month > 0)
                query = query.Where(x => x.NgayBH.Month == month.Value);
            
            if (year.HasValue && year > 0)
                query = query.Where(x => x.NgayBH.Year == year.Value);

            var result = await query
                .Join(_context.KhachHang, dbh => dbh.MaKH, kh => kh.MaKH, (dbh, kh) => new { dbh, kh })
                .Join(_context.Xa, x => x.kh.MaXa, xa => xa.MaXa, (x, xa) => new { x.dbh, x.kh, xa })
                .Join(_context.Tinh, x => x.xa.MaTinh, tinh => tinh.MaTinh, (x, tinh) => new { x.dbh, x.kh, x.xa, tinh })
                .Join(_context.CTBH, x => x.dbh.MaDBH, ct => ct.MaDBH, (x, ct) => new { x.dbh, x.kh, x.xa, x.tinh, ct })
                .Join(_context.SanPham, x => x.ct.MaSP, sp => sp.MaSP, (x, sp) => new ChiTietHoaDonDto
                {
                    MaDBH = x.dbh.MaDBH ?? "",
                    NgayBH = x.dbh.NgayBH,
                    TenKH = x.kh.TenKH ?? "",
                    DiaChi = x.xa.TenXa + ", " + x.tinh.TenTinh,
                    MaSP = sp.MaSP,
                    TenSP = sp.TenSP ?? "",
                    SoLuong = x.ct.SLB ?? 0,
                    DonGia = x.ct.DGB ?? 0
                })
                .OrderByDescending(x => x.NgayBH)
                .ToListAsync();

            return result;
        }

        public async Task<List<DoanhThuDto>> GetDoanhThu(int? month, int? year)
        {
            var query = _context.DonBanHang.AsQueryable();

            if (month.HasValue && month > 0)
                query = query.Where(x => x.NgayBH.Month == month.Value);
            
            if (year.HasValue && year > 0)
                query = query.Where(x => x.NgayBH.Year == year.Value);

            var result = await query
                .Join(_context.KhachHang, dbh => dbh.MaKH, kh => kh.MaKH, (dbh, kh) => new { dbh, kh })
                .Select(x => new DoanhThuDto
                {
                    MaDBH = x.dbh.MaDBH ?? "",
                    NgayBH = x.dbh.NgayBH,
                    TenKH = x.kh.TenKH ?? "",
                    TongTien = _context.CTBH.Where(ct => ct.MaDBH == x.dbh.MaDBH).Sum(ct => (ct.SLB ?? 0) * (ct.DGB ?? 0))
                })
                .OrderByDescending(x => x.NgayBH)
                .ToListAsync();

            return result;
        }

        public async Task<List<SanPhamBanChayDto>> GetSanPhamBanChay(int top = 5)
        {
            var result = await _context.CTBH
                .GroupBy(x => x.MaSP)
                .Select(g => new SanPhamBanChayDto
                {
                    MaSP = g.Key ?? "",
                    TenSP = _context.SanPham.Where(s => s.MaSP == g.Key).Select(s => s.TenSP).FirstOrDefault() ?? "",
                    SoLuongBan = g.Sum(x => x.SLB ?? 0),
                    DoanhThu = g.Sum(x => (x.SLB ?? 0) * (x.DGB ?? 0))
                })
                .OrderByDescending(x => x.SoLuongBan)
                .Take(top)
                .ToListAsync();

            return result;
        }

		public async Task<List<SanPhamTonKhoDto>> GetSanPhamTonKho(int top = 10)
		{
			// Bước 1: Lấy dữ liệu từ Store Procedure về bộ nhớ (Client-side)
			var data = await _context.SanPhamDto
				.FromSqlRaw("EXEC SanPham_GetAll")
				.ToListAsync();

			// Bước 2: Thực hiện các lệnh lọc/sắp xếp trên bộ nhớ (LINQ to Objects)
			var result = data
				.Select(s => new SanPhamTonKhoDto
				{
					MaSP = s.MaSP ?? "",
					TenSP = s.TenSP ?? "",
					SoLuongTon = s.SoLuongTon,
					GiaBan = s.GiaBan
				})
				.OrderByDescending(x => x.SoLuongTon)
				.Take(top)
				.ToList();

			return result;
		}

		public async Task<List<DoanhThuTheoThangDto>> GetDoanhThuTheoThang(int year)
        {
            var result = await _context.DonBanHang
                .Where(x => x.NgayBH.Year == year)
                .Join(_context.CTBH, dbh => dbh.MaDBH, ct => ct.MaDBH, (dbh, ct) => new { dbh, ct })
                .GroupBy(x => x.dbh.NgayBH.Month)
                .Select(g => new DoanhThuTheoThangDto
                {
                    Thang = g.Key,
                    DoanhThu = g.Sum(x => (x.ct.SLB ?? 0) * (x.ct.DGB ?? 0))
                })
                .OrderBy(x => x.Thang)
                .ToListAsync();

            return result;
        }
    }

    public class DoanhThuTheoThangDto
    {
        public int Thang { get; set; }
        public decimal DoanhThu { get; set; }
    }
}
