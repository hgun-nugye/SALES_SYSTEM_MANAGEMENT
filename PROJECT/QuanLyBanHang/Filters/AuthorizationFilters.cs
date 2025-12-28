using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.Filters;

namespace QuanLyBanHang.Filters
{
	/// <summary>
	/// Attribute yêu cầu đăng nhập (Admin hoặc Nhân viên)
	/// Tránh trường hợp nhập trực tiếp URL khi chưa đăng nhập
	/// </summary>
	public class AuthorizeAttribute : ActionFilterAttribute
	{
		public override void OnActionExecuting(ActionExecutingContext context)
		{
			var isLoggedIn = context.HttpContext.Session.GetString("IsLoggedIn");
			
			if (isLoggedIn != "true")
			{
				context.Result = new RedirectToActionResult("Login", "Home", null);
			}
		}
	}

	/// <summary>
	/// Quyền Admin tuyệt đối (Thêm/Sửa/Xóa/Quản lý tài khoản)
	/// </summary>
	public class AdminOnlyAttribute : ActionFilterAttribute
	{
		public override void OnActionExecuting(ActionExecutingContext context)
		{
			var isLoggedIn = context.HttpContext.Session.GetString("IsLoggedIn");
			var isAdmin = context.HttpContext.Session.GetString("IsAdmin");

			if (isLoggedIn != "true")
			{
				context.Result = new RedirectToActionResult("Login", "Home", null);
				return;
			}

			if (isAdmin != "true")
			{
				// Nhân viên không có quyền truy cập
				context.Result = new RedirectToActionResult("AccessDenied", "Home", null);
			}
		}
	}

	/// <summary>
	/// Nhân viên chỉ được xem và thêm, không được xóa
	/// Dùng cho các action Delete
	/// </summary>
	public class NoDeleteForStaffAttribute : ActionFilterAttribute
	{
		public override void OnActionExecuting(ActionExecutingContext context)
		{
			var isLoggedIn = context.HttpContext.Session.GetString("IsLoggedIn");
			var isAdmin = context.HttpContext.Session.GetString("IsAdmin");

			if (isLoggedIn != "true")
			{
				context.Result = new RedirectToActionResult("Login", "Home", null);
				return;
			}

			if (isAdmin != "true")
			{
				// Nhân viên cố tình vào link xóa
				context.Result = new RedirectToActionResult("AccessDenied", "Home", null);
			}
		}
	}
}
