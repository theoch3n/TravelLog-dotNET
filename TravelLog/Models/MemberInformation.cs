using System;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace TravelLog.Models
{
    [Table("MemberInformation")] // 對應資料表名稱
    public partial class MemberInformation
    {
        [Key]
        [Column("MI_MemberID")]
        public int MemberId { get; set; }

        [Required]
        [Column("MI_AccountName")]
        [StringLength(50)]
        public string AccountName { get; set; }

        [Required]
        [Column("MI_Email")]
        [StringLength(100)]
        public string Email { get; set; }

        [Required]
        [Column("MI_PasswordHash")]
        [StringLength(255)]
        public string PasswordHash { get; set; }

        [Column("MI_RegistrationDate", TypeName = "datetime")]
        public DateTime RegistrationDate { get; set; }

        [Column("MI_IsActive")]
        public bool IsActive { get; set; }
    }
}