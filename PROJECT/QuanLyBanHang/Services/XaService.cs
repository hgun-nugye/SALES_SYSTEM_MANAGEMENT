using Microsoft.Data.SqlClient;
using Microsoft.EntityFrameworkCore;
using QuanLyBanHang.Models;
using System.Data;

namespace QuanLyBanHang.Services
{
	public class XaService
	{
		private readonly AppDbContext _context;

		public XaService(AppDbContext context)
		{
			_context = context;
		}

		// 1. Tìm kiếm Xã (Trả về DTO)
		public async Task<List<XaDTO>> Search(string? search, short? maTinh)
		{
			var parameters = new[]
			{
				new SqlParameter("@Search", (object?)search ?? DBNull.Value),
				new SqlParameter("@MaTinh", (object?)maTinh ?? DBNull.Value)
			};

			// Lưu ý: XaDTO phải được cấu hình HasNoKey() trong AppDbContext
			return await _context.XaDTO
				.FromSqlRaw("EXEC Xa_Search @Search, @MaTinh", parameters)
				.ToListAsync();
		}

		// 2. Lấy tất cả Xã
		public async Task<List<Xa>> GetAll()
		{
			return await _context.Xa
				.FromSqlRaw("EXEC Xa_GetAll")
				.ToListAsync();
		}

		// 3. Lấy danh sách Xã kèm thông tin Tỉnh
		public async Task<List<Xa>> GetAllWithTinh()
		{
			return await _context.Xa
				.FromSqlRaw("EXEC Xa_GetAllWithTinh")
				.ToListAsync();
		}

		// 4. Xem chi tiết 1 Xã bằng ID (Đã sửa kiểu dữ liệu sang int)
		public async Task<Xa?> GetByIDWithTinh(int maXa)
		{			
			var xa = (await _context.Xa.FromSqlInterpolated($"EXEC Xa_GetByIDWithTinh @MaXa = {maXa}")
				.ToListAsync())
				.FirstOrDefault();

			// Populate TenTinh thủ công vì property này là [NotMapped]
			if (xa != null && xa.MaTinh != 0)
			{
				var tinh = await _context.Tinh.FindAsync(xa.MaTinh);
				xa.TenTinh = tinh?.TenTinh;
			}

			return xa;
		}

		// 5. Thêm mới Xã
		public async Task Create(Xa model)
		{
			await _context.Database.ExecuteSqlInterpolatedAsync($@"
                EXEC Xa_Insert 
                    @TenXa = {model.TenXa},
                    @MaTinh = {model.MaTinh}");
		}

		// 6. Cập nhật Xã
		public async Task Update(Xa model)
		{
			await _context.Database.ExecuteSqlInterpolatedAsync($@"
                EXEC Xa_Update
                    @MaXa = {model.MaXa}, 
                    @TenXa = {model.TenXa},
                    @MaTinh = {model.MaTinh}");
		}

		// 7. Xóa Xã
		public async Task Delete(int id)
		{
			var exists = await GetByIDWithTinh(id);
			if (exists == null)
				throw new KeyNotFoundException("Xã không tồn tại!");

			await _context.Database.ExecuteSqlInterpolatedAsync($"EXEC Xa_Delete @MaXa = {id}");
		}

		// 8. Lấy danh sách Xã theo mã Tỉnh
		public async Task<List<Xa>> GetByMaTinh(short maTinh)
		{
			return await _context.Xa
				.FromSqlInterpolated($"EXEC Xa_GetByIDTinh @MaTinh = {maTinh}")
				.ToListAsync();
		}

		// Alias cho backward compatibility với code cũ
		public async Task<List<Xa>> GetByIDTinh(short maTinh)
		{
			return await GetByMaTinh(maTinh);
		}

		// 9. Lấy MaTinh từ MaXa (Dùng cho trường hợp cần load lại DropdownList Tỉnh khi Edit)
		public async Task<short> GetMaTinhByMaXa(int maXa)
		{
			var xa = await GetByIDWithTinh(maXa);
			return xa?.MaTinh ?? 0;
		}
	}
}