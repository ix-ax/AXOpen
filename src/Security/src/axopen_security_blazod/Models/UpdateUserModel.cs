
using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace AxOpen.Security.Models
{
    public class UpdateUserModel : IValidatableObject
    {
        [Required]
        public string Username { get; set; }

        [DataType(DataType.Password)]
        public string Password { get; set; }

        [Compare("Password", ErrorMessage = "Confirm password doesn't match. Type again!")]
        public string ConfirmPassword { get; set; }

        [Required]
        public bool CanUserChangePassword { get; set; }

        public string Email { get; set; }

        public string Group { get; set; }

        public IEnumerable<ValidationResult> Validate(ValidationContext validationContext)
        {
            if (!((Password == "" || Password == null) && (ConfirmPassword == "" || ConfirmPassword == null)))
            {
                if (Password == null || Password == "")
                    yield return new ValidationResult($"Password is required.", new[] { nameof(Password) });
                if (ConfirmPassword == null || ConfirmPassword == "")
                    yield return new ValidationResult($"Confirm Password is required.", new[] { nameof(ConfirmPassword) });
            }
        }
    }
}
