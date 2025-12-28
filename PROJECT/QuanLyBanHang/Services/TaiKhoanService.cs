using Microsoft.Data.SqlClient;
using Microsoft.EntityFrameworkCore;
using QuanLyBanHang.Models;

namespace QuanLyBanHang.Services
{
	public class TaiKhoanService
	{
		private readonly AppDbContext _context;

		public TaiKhoanService(AppDbContext context)
		{
			_context = context;
		}

		// Lấy tất cả tài khoản
		public async Task<List<TaiKhoan>> GetAll()
		{
			return await _context.TaiKhoan
				.FromSqlRaw("SELECT * FROM TaiKhoan")
				.ToListAsync();
		}

		// Lấy tài khoản theo ID
		public async Task<TaiKhoan?> GetByID(string id)
		{
			var param = new SqlParameter("@MaTK", id);
			return await _context.TaiKhoan
				.FromSqlRaw("SELECT * FROM TaiKhoan WHERE MaTK = @MaTK", param)
				.FirstOrDefaultAsync();
		}

		// Tìm tài khoản theo tên đăng nhập
		public async Task<TaiKhoan?> GetByUsername(string username)
		{
			var param = new SqlParameter("@TenDN", username);
			return await _context.TaiKhoan
				.FromSqlRaw("SELECT * FROM TaiKhoan WHERE TenDN = @TenDN", param)
				.FirstOrDefaultAsync();
		}

		// Xác thực đăng nhập (không hash)
		public async Task<TaiKhoan?> Authenticate(string username, string password)
		{
			var parameters = new[]
			{
				new SqlParameter("@TenDN", username),
				new SqlParameter("@MatKhau", password)
			};

			return await _context.TaiKhoan
				.FromSqlRaw("SELECT * FROM TaiKhoan WHERE TenDN = @TenDN AND MatKhau = @MatKhau", parameters)
				.FirstOrDefaultAsync();
		}

		// Tạo tài khoản mới
		public async Task Create(TaiKhoan model)
		{
			var parameters = new[]
			{
				new SqlParameter("@MaTK", model.MaTK),
				new SqlParameter("@TenDN", model.TenDN),
				new SqlParameter("@MatKhau", model.MatKhau),
				new SqlParameter("@VaiTro", model.VaiTro)
			};

			await _context.Database.ExecuteSqlRawAsync(
				"INSERT INTO TaiKhoan (MaTK, TenDN, MatKhau, VaiTro) VALUES (@MaTK, @TenDN, @MatKhau, @VaiTro)",
				parameters
			);
		}

		// Cập nhật tài khoản
		public async Task Update(TaiKhoan model)
		{
			var parameters = new[]
			{
				new SqlParameter("@MaTK", model.MaTK),
				new SqlParameter("@TenDN", model.TenDN),
				new SqlParameter("@MatKhau", model.MatKhau),
				new SqlParameter("@VaiTro", model.VaiTro)
			};

			await _context.Database.ExecuteSqlRawAsync(
				"UPDATE TaiKhoan SET TenDN = @TenDN, MatKhau = @MatKhau, VaiTro = @VaiTro WHERE MaTK = @MaTK",
				parameters
			);
		}

		// Xóa tài khoản
		public async Task Delete(string id)
		{
			var param = new SqlParameter("@MaTK", id);
			await _context.Database.ExecuteSqlRawAsync(
				"DELETE FROM TaiKhoan WHERE MaTK = @MaTK",
				param
			);
		}

		// Kiểm tra tên đăng nhập đã tồn tại
		public async Task<bool> UsernameExists(string username, string? excludeMaTK = null)
		{
			if (string.IsNullOrEmpty(excludeMaTK))
			{
				var param = new SqlParameter("@TenDN", username);
				var count = await _context.TaiKhoan
					.FromSqlRaw("SELECT * FROM TaiKhoan WHERE TenDN = @TenDN", param)
					.CountAsync();
				return count > 0;
			}
			else
			{
				var parameters = new[]
				{
					new SqlParameter("@TenDN", username),
					new SqlParameter("@MaTK", excludeMaTK)
				};
				var count = await _context.TaiKhoan
					.FromSqlRaw("SELECT * FROM TaiKhoan WHERE TenDN = @TenDN AND MaTK != @MaTK", parameters)
					.CountAsync();
				return count > 0;
			}
		}

		// Tạo mã tài khoản tự động
		public async Task<string> GenerateNewMaTK()
		{
			var lastTK = await _context.TaiKhoan
				.FromSqlRaw("SELECT TOP 1 * FROM TaiKhoan ORDER BY MaTK DESC")
				.FirstOrDefaultAsync();

			if (lastTK == null)
			{
				return "TK001";
			}

			var lastNumber = int.Parse(lastTK.MaTK.Substring(2));
			var newNumber = lastNumber + 1;
			return $"TK{newNumber:D3}";
		}
	}
}
