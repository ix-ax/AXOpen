using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Xml;

namespace AxOpen.Security.Models
{
    public class ManageUserModel : IValidatableObject
    {
        [Required]
        public string Username { get; set; }

        [DataType(DataType.Password)]
        public string OldPassword { get; set; }

        [DataType(DataType.Password)]
        public string Password { get; set; }

        [Compare("Password", ErrorMessage = "Confirm password doesn't match. Type again!")]
        public string ConfirmPassword { get; set; }

        public bool CanUserChangePassword { get; set; }
        public bool EnableAutoLogOut { get; set; }
        public int AutoLogOutTimeOutMinutes { get; set; }

        // This property will store the actual TimeSpan
        public TimeSpan AutoLogOutTimeOut
        {
            get => TimeSpan.FromSeconds(AutoLogOutTimeOutMinutes);
            set => AutoLogOutTimeOutMinutes = (int)value.TotalMinutes; // Set the minutes when TimeSpan changes
        }

        public string Email { get; set; }

        [Required]
        public string Group { get; set; }

        public IEnumerable<ValidationResult> Validate(ValidationContext validationContext)
        {
            if (!((OldPassword == "" || OldPassword == null) && (Password == "" || Password == null) && (ConfirmPassword == "" || ConfirmPassword == null)))
            {
                if (OldPassword == null || OldPassword == "")
                    yield return new ValidationResult($"Old Password is required.", new[] { nameof(OldPassword) });
                if (Password == null || Password == "")
                    yield return new ValidationResult($"Password is required.", new[] { nameof(Password) });
                if (ConfirmPassword == null || ConfirmPassword == "")
                    yield return new ValidationResult($"Confirm Password is required.", new[] { nameof(ConfirmPassword) });
            }

            if (EnableAutoLogOut)
            {
                if (AutoLogOutTimeOutMinutes < 1 || AutoLogOutTimeOutMinutes > 1440)
                {
                    yield return new ValidationResult(
                        "Timeout must be a whole number between 1 and 1440.",
                        new[] { nameof(AutoLogOutTimeOutMinutes) }
                    );
                }
            }
        }
    }
}