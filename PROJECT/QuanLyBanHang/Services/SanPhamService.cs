using Microsoft.Data.SqlClient;
using Microsoft.EntityFrameworkCore;
using QuanLyBanHang.Models;
using System.Data;

namespace QuanLyBanHang.Services
{
	public class SanPhamService
	{
		private readonly AppDbContext _context;

		public SanPhamService(AppDbContext context)
		{
			_context = context;
		}

		public async Task<List<SanPhamDto>> GetAll()
		{
			return await _context.SanPhamDto
				.FromSqlRaw("EXEC SanPham_GetAll")
				.AsNoTracking()
				.ToListAsync();
		}

		public async Task<List<SanPhamDto>> Search(string? search, string? maTT, string? maLoai)
		{
			var parameters = new[]
			{
				new SqlParameter("@Search", SqlDbType.NVarChar, 100) { Value = string.IsNullOrEmpty(search) ? DBNull.Value : search },
				new SqlParameter("@MaTT", SqlDbType.Char, 3) { Value = string.IsNullOrEmpty(maTT) ? DBNull.Value : maTT },
				new SqlParameter("@MaLoai", SqlDbType.VarChar, 10) { Value = string.IsNullOrEmpty(maLoai) ? DBNull.Value : maLoai }
			};

			return await _context.SanPhamDto
				.FromSqlRaw("EXEC SanPham_Search @Search, @MaTT, @MaLoai", parameters)
				.AsNoTracking()
				.ToListAsync();
		}

		public async Task<SanPhamDto?> GetById(string id)
		{
			return (await _context.SanPhamDto
				.FromSqlRaw("EXEC SanPham_GetByID @MaSP", new SqlParameter("@MaSP", id))
				.ToListAsync())
				.FirstOrDefault();
		}

		public async Task Create(SanPham sp, string? filePath)
		{
			await _context.Database.ExecuteSqlRawAsync(
				"EXEC SanPham_Insert @TenSP, @GiaBan, @MaTT, @MaLoai",
				new SqlParameter("@TenSP", sp.TenSP),
				new SqlParameter("@GiaBan", sp.GiaBan),
				new SqlParameter("@MaTT", sp.MaTT),
				new SqlParameter("@MaLoai", sp.MaLoai)
			);
		}

		// Cập nhật sản phẩm
		public async Task Update(SanPham sp)
		{
			await _context.Database.ExecuteSqlRawAsync(
				"EXEC SanPham_Update @MaSP, @TenSP, @GiaBan,@MaTT, @MaLoai",
				new SqlParameter("@MaSP", sp.MaSP),
				new SqlParameter("@TenSP", sp.TenSP),
				new SqlParameter("@GiaBan", sp.GiaBan),
				new SqlParameter("@MaTT", sp.MaTT),
				new SqlParameter("@MaLoai", sp.MaLoai)
			);
		}

		// Xóa sản phẩm
		public async Task Delete(string id)
		{
			await _context.Database.ExecuteSqlRawAsync(
				"EXEC SanPham_Delete @MaSP",
				new SqlParameter("@MaSP", id)
			);
		}
	}
}
