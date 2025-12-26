using Microsoft.EntityFrameworkCore;
using QuanLyBanHang.Models;

namespace QuanLyBanHang.Services
{
	public class AppDbContext : DbContext
	{
		public AppDbContext(DbContextOptions<AppDbContext> options)
			: base(options)
		{
		}

		protected override void OnConfiguring(DbContextOptionsBuilder optionsBuilder)
		{
			base.OnConfiguring(optionsBuilder);
		}

		// ========== TABLES (ENTITY thật) ==========
		public DbSet<Tinh> Tinh { get; set; } = null!;
		public DbSet<Xa> Xa { get; set; } = null!;
		public DbSet<NhaCC> NhaCC { get; set; } = null!;
		public DbSet<KhachHang> KhachHang { get; set; } = null!;
		public DbSet<NhomSP> NhomSP { get; set; } = null!;
		public DbSet<LoaiSP> LoaiSP { get; set; } = null!;
		public DbSet<TrangThai> TrangThai { get; set; } = null!;
		public DbSet<SanPham> SanPham { get; set; } = null!;
		public DbSet<DonMuaHang> DonMuaHang { get; set; } = null!;
		public DbSet<DonMuaHangDetail> DonMuaHangDetail { get; set; } = null!;
		public DbSet<CTMH> CTMH { get; set; } = null!;
		public DbSet<DonBanHang> DonBanHang { get; set; } = null!;
		public DbSet<DonBanHangDetail> DonBanHangDetail { get; set; } = null!;
		public DbSet<CTBH> CTBH { get; set; } = null!;
		public DbSet<NhomSPDto> NhomSPDto { get; set; } = null!;
		public DbSet<LoaiSPDto> LoaiSPDtos { get; set; } = null!;
		public DbSet<SanPhamDto> SanPhamDto { get; set; } = null!;
		public DbSet<CTMHDetailDto> CTMHDetailDtos { get; set; } = null!;
		public DbSet<CTBHDetailDto> CTBHDetailDtos { get; set; } = null!;
		public DbSet<XaDTO> XaDTO { get; set; } = null!;


		// ========== SQL VIEW ==========
		public DbSet<NhaCCDetailView> NhaCCDetailView { get; set; } = null!;
		public DbSet<KhachHangDetailView> KhachHangDetailView { get; set; } = null!;

		protected override void OnModelCreating(ModelBuilder modelBuilder)
		{
			base.OnModelCreating(modelBuilder);

			// ====== Cấu hình khóa chính phức hợp ======
			modelBuilder.Entity<CTMH>()
				.HasKey(ct => new { ct.MaDMH, ct.MaSP });

			modelBuilder.Entity<CTBH>()
				.HasKey(ct => new { ct.MaDBH, ct.MaSP });

			// ====== DTOs: Keyless entities (cho stored procedures) ======
			modelBuilder.Entity<NhomSPDto>().HasNoKey();
			modelBuilder.Entity<LoaiSPDto>().HasNoKey();
			modelBuilder.Entity<SanPhamDto>().HasNoKey();
			modelBuilder.Entity<CTMHDetailDto>().HasNoKey();
			modelBuilder.Entity<CTBHDetailDto>().HasNoKey();
					}
	}
}
