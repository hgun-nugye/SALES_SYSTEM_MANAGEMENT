using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace QuanLyBanHang.Models
{
	[Table("TaiKhoan")]
	public class TaiKhoan
	{
		[Key]
		[Required(ErrorMessage = "Mã tài khoản không được để trống")]
		[StringLength(5, ErrorMessage = "Mã tài khoản tối đa 5 ký tự")]
		[Display(Name = "Mã Tài Khoản")]
		public string MaTK { get; set; } = string.Empty;

		[Required(ErrorMessage = "Tên đăng nhập không được để trống")]
		[StringLength(50, ErrorMessage = "Tên đăng nhập tối đa 50 ký tự")]
		[Display(Name = "Tên Đăng Nhập")]
		public string TenDN { get; set; } = string.Empty;

		[Required(ErrorMessage = "Mật khẩu không được để trống")]
		[StringLength(20, ErrorMessage = "Mật khẩu tối đa 20 ký tự")]
		[Display(Name = "Mật Khẩu")]
		[DataType(DataType.Password)]
		public string MatKhau { get; set; } = string.Empty;

		[Required(ErrorMessage = "Vai trò không được để trống")]
		[Display(Name = "Vai Trò")]
		public bool VaiTro { get; set; }

		[NotMapped]
		[Display(Name = "Tên Vai Trò")]
		public string? TenVaiTro => VaiTro ? "Quản lý" : "Nhân viên";
	}
}
