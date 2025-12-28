using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.Rendering;
using Microsoft.EntityFrameworkCore;
using QuanLyBanHang.Models;
using QuanLyBanHang.Services;
using QuanLyBanHang.Filters;
namespace QuanLyBanHang.Controllers
{
	[Authorize]
	public class SanPhamController : Controller
	{
		private readonly SanPhamService _spService;
		private readonly LoaiSPService _loaiSPService;
		private readonly AppDbContext _context;
		private readonly IWebHostEnvironment _environment;
		public SanPhamController(
			AppDbContext context,
			SanPhamService spService,
			SanPhamService service,
			LoaiSPService loaiSPService,
			IWebHostEnvironment environment)
		{
			_spService = service;
			_loaiSPService = loaiSPService;
			_environment = environment;
			_context = context;
		}

		public async Task<IActionResult> Index(string? search, string? maTT, string? maLoai)
		{
			ViewBag.Search = search;
			ViewBag.MaTT = maTT;
			ViewBag.MaLoai = maLoai;

			// Load dropdown
			await LoadDropdownsAsync(maLoai, maTT);

			var data = await _spService.Search(search, maTT, maLoai);
			return View(data);
		}

		public async Task<IActionResult> Details(string id)
		{
			if (string.IsNullOrEmpty(id)) return NotFound();

			var sp = await _spService.GetById(id);
			if (sp == null) return NotFound();

			return View(sp);
		}

		public async Task<IActionResult> Create()
		{
			await LoadDropdownsAsync();
			return View();
		}


		[HttpPost]
		[ValidateAntiForgeryToken]
		public async Task<IActionResult> Create(SanPham sp, IFormFile? AnhFile)
		{
			// Bỏ qua validation cho MaSP vì nó được tự động generate trong stored procedure
			ModelState.Remove("MaSP");
			
			try
			{
				TempData["SuccessMessage"] = "Thêm sản phẩm thành công!";
				return RedirectToAction(nameof(Index));
			}
			catch (Exception ex)
			{				
				ModelState.AddModelError("", "Lỗi khi thêm sản phẩm: " + ex.Message);
				await LoadDropdownsAsync(sp.MaLoai, sp.MaTT);
				return View(sp);
			}
		}

		public async Task<IActionResult> Edit(string id)
		{
			if (string.IsNullOrEmpty(id)) return NotFound();

			var sp = await _spService.GetById(id);
			if (sp == null) return NotFound();

			// Chuyển đổi thủ công sang Dto
			var spDto = new SanPhamDto
			{
				MaSP = sp.MaSP,
				TenSP = sp.TenSP,
				GiaBan = sp.GiaBan
			};

			await LoadDropdownsAsync(sp.MaLoai, sp.MaTT);
			return View(spDto); // Truyền Dto vào View
		}

		[HttpPost]
		[ValidateAntiForgeryToken]
		public async Task<IActionResult> Edit(string id, SanPham sp)
		{
			if (id != sp.MaSP) return NotFound();

			if (!ModelState.IsValid)
			{
				await LoadDropdownsAsync(sp.MaLoai, sp.MaTT);
				return View(sp);
			}
						
			await _spService.Update(sp);
			TempData["SuccessMessage"] = "Cập nhật sản phẩm thành công!";
			return RedirectToAction(nameof(Index));
		}

		[HttpGet]
		[NoDeleteForStaff]
		public async Task<IActionResult> Delete(string id)
		{
			if (string.IsNullOrEmpty(id)) return NotFound();

			var sp = await _spService.GetById(id);
			if (sp == null) return NotFound();

			return View(sp);
		}

		[HttpPost, ActionName("Delete")]
		[ValidateAntiForgeryToken]
		[NoDeleteForStaff]
		public async Task<IActionResult> DeleteConfirmed(string id)
		{
			try
			{
				await _spService.Delete(id);
				TempData["SuccessMessage"] = "Xóa sản phẩm thành công!";
			}
			catch
			{
				TempData["ErrorMessage"] = "Không thể xóa sản phẩm này!";
			}
			return RedirectToAction(nameof(Index));
		}

		// Load dropdowns
		private async Task LoadDropdownsAsync(string? selectedLoai = null, string? selectedMaTT = null, string? selectedHang = null)
		{
			var loaiList = await _loaiSPService.GetAll();
			ViewBag.LoaiSP = new SelectList(loaiList, "MaLoai", "TenLoai", selectedLoai);

			// Load TrangThai from database
			var trangThaiList = await _context.TrangThai.ToListAsync();
			ViewBag.MaTT = new SelectList(trangThaiList, "MaTT", "TenTT", selectedMaTT);
		}

		[HttpGet]
		public async Task<IActionResult> GetGia(string id)
		{
			var sp = await _context.SanPham.FindAsync(id);
			return Json(new { gia = sp?.GiaBan ?? 0 });
		}
	}
}
