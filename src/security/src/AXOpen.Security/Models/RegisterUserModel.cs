using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;

namespace AxOpen.Security
{
    public class RegisterUserModel
    {
        [Required]
        public string Username { get; set; }

        [Required]
        [DataType(DataType.Password)]
        public string Password { get; set; }

        [Required]
        [Compare("Password", ErrorMessage = "Confirm password doesn't match. Type again!")]
        public string ConfirmPassword { get; set; }

        public bool CanUserChangePassword { get; set; }

        public string Email { get; set; }

        public string Group { get; set; }
    }
}
