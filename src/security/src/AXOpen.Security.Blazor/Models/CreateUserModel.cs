using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace AxOpen.Security.Models
{
    public class CreateUserModel
    {
        [Required]
        public string Username { get; set; }

        [Required]
        [DataType(DataType.Password)]
        public string Password { get; set; }

        [Required]
        [Compare("Password", ErrorMessage = "Confirm password doesn't match. Type again!")]
        public string ConfirmPassword { get; set; }

        [Required]
        public bool CanUserChangePassword { get; set; }

        public string Email { get; set; }

        [Required]
        public string Group { get; set; }

        public bool EnableAutoLogOut { get; set; } = true;
        public uint AutoLogOutTimeOutMinutes { get; set; } = 30;

        // This property will store the actual TimeSpan
        public TimeSpan AutoLogOutTimeOut
        {
            get => TimeSpan.FromSeconds(AutoLogOutTimeOutMinutes);
            set => AutoLogOutTimeOutMinutes = (uint)value.TotalMinutes; // Set the minutes when TimeSpan changes
        }
    }
}