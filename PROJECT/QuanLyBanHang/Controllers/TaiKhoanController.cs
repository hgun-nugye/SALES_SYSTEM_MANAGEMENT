using Microsoft.AspNetCore.Mvc;
using QuanLyBanHang.Filters;
using QuanLyBanHang.Models;
using QuanLyBanHang.Services;

namespace QuanLyBanHang.Controllers
{
	[AdminOnly]
	public class TaiKhoanController : Controller
	{
		private readonly TaiKhoanService _taiKhoanService;

		public TaiKhoanController(TaiKhoanService taiKhoanService)
		{
			_taiKhoanService = taiKhoanService;
		}

		// GET: TaiKhoan
		public async Task<IActionResult> Index()
		{
			var taiKhoans = await _taiKhoanService.GetAll();
			return View(taiKhoans);
		}

		// GET: TaiKhoan/Details/5
		public async Task<IActionResult> Details(string id)
		{
			if (string.IsNullOrEmpty(id))
				return NotFound();

			var taiKhoan = await _taiKhoanService.GetByID(id);
			if (taiKhoan == null)
				return NotFound();

			return View(taiKhoan);
		}

		// GET: TaiKhoan/Create
		public IActionResult Create()
		{
			return View();
		}

		// POST: TaiKhoan/Create
		[HttpPost]
		[ValidateAntiForgeryToken]
		public async Task<IActionResult> Create(TaiKhoan model)
		{
			try
			{
				// Tự động tạo mã tài khoản
				model.MaTK = await _taiKhoanService.GenerateNewMaTK();

				// Kiểm tra tên đăng nhập đã tồn tại
				if (await _taiKhoanService.UsernameExists(model.TenDN))
				{
					ModelState.AddModelError("TenDN", "Tên đăng nhập đã tồn tại.");
					return View(model);
				}

				if (ModelState.IsValid)
				{
					await _taiKhoanService.Create(model);
					TempData["SuccessMessage"] = "Thêm tài khoản thành công!";
					return RedirectToAction(nameof(Index));
				}
			}
			catch (Exception ex)
			{
				TempData["ErrorMessage"] = "Lỗi khi thêm tài khoản: " + ex.Message;
			}

			return View(model);
		}

		// GET: TaiKhoan/Edit/5
		public async Task<IActionResult> Edit(string id)
		{
			if (string.IsNullOrEmpty(id))
				return NotFound();

			var taiKhoan = await _taiKhoanService.GetByID(id);
			if (taiKhoan == null)
				return NotFound();

			return View(taiKhoan);
		}

		// POST: TaiKhoan/Edit/5
		[HttpPost]
		[ValidateAntiForgeryToken]
		public async Task<IActionResult> Edit(string id, TaiKhoan model)
		{
			ModelState.Remove("MaTK");
			ModelState.Remove("MatKhau");

			if (id != model.MaTK)
				return NotFound();

			try
			{
				// Kiểm tra tên đăng nhập đã tồn tại (trừ tài khoản hiện tại)
				if (await _taiKhoanService.UsernameExists(model.TenDN, model.MaTK))
				{
					ModelState.AddModelError("TenDN", "Tên đăng nhập đã tồn tại.");
					return View(model);
				}

				if (ModelState.IsValid)
				{
					await _taiKhoanService.Update(model);
					TempData["SuccessMessage"] = "Cập nhật tài khoản thành công!";
					return RedirectToAction(nameof(Index));
				}
			}
			catch (Exception ex)
			{
				TempData["ErrorMessage"] = "Lỗi khi cập nhật tài khoản: " + ex.Message;
			}

			return View(model);
		}

		// GET: TaiKhoan/Delete/5
		public async Task<IActionResult> Delete(string id)
		{
			if (string.IsNullOrEmpty(id))
				return NotFound();

			var taiKhoan = await _taiKhoanService.GetByID(id);
			if (taiKhoan == null)
				return NotFound();

			return View(taiKhoan);
		}

		// POST: TaiKhoan/Delete/5
		[HttpPost, ActionName("Delete")]
		[ValidateAntiForgeryToken]
		public async Task<IActionResult> DeleteConfirmed(string id)
		{
			try
			{
				await _taiKhoanService.Delete(id);
				TempData["SuccessMessage"] = "Xóa tài khoản thành công!";
			}
			catch (Exception ex)
			{
				TempData["ErrorMessage"] = "Lỗi khi xóa tài khoản: " + ex.Message;
			}

			return RedirectToAction(nameof(Index));
		}
	}
}
