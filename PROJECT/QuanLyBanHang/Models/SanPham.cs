using Microsoft.AspNetCore.Http;
using Microsoft.EntityFrameworkCore;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace QuanLyBanHang.Models
{
	[Table("SanPham")]
	public class SanPham
	{
		[Key]
		[Display(Name = "Mã sản phẩm")]
		[Required(ErrorMessage = "Mã sản phẩm không được để trống")]
		[StringLength(10, ErrorMessage = "Mã sản phẩm tối đa 10 ký tự")]
		public string MaSP { get; set; } = string.Empty;

		[Display(Name = "Tên sản phẩm")]
		[Required(ErrorMessage = "Tên sản phẩm không được để trống")]
		[StringLength(50, ErrorMessage = "Tên sản phẩm tối đa 50 ký tự")]
		public string TenSP { get; set; } = string.Empty;

		[DataType(DataType.Currency)]
		[Display(Name = "Giá bán")]
		[Required(ErrorMessage = "Giá bán không được để trống")]
		[Range(0, double.MaxValue, ErrorMessage = "Giá bán phải >= 0")]
		[Column(TypeName = "decimal(18,2)")]
		public decimal GiaBan { get; set; }
		[Display(Name = "Mã Trạng Thái")]
		[Required(ErrorMessage = "Mã trạng thái không được để trống")]
		[StringLength(3, ErrorMessage = "Mã trạng thái tối đa 3 ký tự")]
		public string MaTT { get; set; } = string.Empty;

		[Display(Name = "Mã loại")]
		[Required(ErrorMessage = "Mã loại không được để trống")]
		public string MaLoai { get; set; } = string.Empty;

		[NotMapped]
		[Display(Name = "Tên loại sản phẩm")]
		public string? TenLoai { get; set; }

		[NotMapped]
		[Display(Name = "Tên trạng thái")]
		public string? TenTT { get; set; }

		[NotMapped]
		[Display(Name = "Upload ảnh")]
		public IFormFile? AnhFile { get; set; }
	}

	[Keyless]
	public class SanPhamDto
	{
		[Display(Name = "Mã sản phẩm")]
		public string? MaSP { get; set; }

		[Display(Name = "Tên sản phẩm")]
		public string? TenSP { get; set; }

		[DataType(DataType.Currency)]
		[Display(Name = "Giá bán")]
		[Column(TypeName = "decimal(18,2)")]
		public decimal? GiaBan { get; set; }

		[Display(Name = "Mã Trạng Thái")]
		public string? MaTT { get; set; }

		[Display(Name = "Mã loại")]
		public string? MaLoai { get; set; }

		[Display(Name = "Tên loại sản phẩm")]
		public string? TenLoai { get; set; }

		[Display(Name = "Tên trạng thái")]
		public string? TenTT { get; set; }

		[Display(Name = "Số lượng tồn")]
		public int? SoLuongTon { get; set; }
	}
}
