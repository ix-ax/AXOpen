using System;
using System.Collections.Generic;
using System.Linq;
using System.Security.Cryptography;
using System.Text;
using System.Threading.Tasks;

namespace Security
{
    public static class Hasher
    {
        public static void VerifyHash(IEnumerable<string> clearText, string hashText, string salt)
        {
            bool matches = false;
            if (hashText != null)
            {
                matches = hashText.Equals(CalculateHash(clearText, salt));
            }

            if (!matches)
            {
                throw new UnauthorizedAccessException("AccessDeniedPermissions");
            }
        }

        public static String CalculateHash(IEnumerable<string> clearText, string salt)
        {
            return CalculateHash(String.Join(",", clearText.OrderByDescending(x => x).ToList()), salt);
        }

        public static string CalculateHash(string clearText, string salt)
        {
            // Convert the salted password to a byte array
            byte[] saltedHashBytes = Encoding.UTF8.GetBytes(clearText + salt);
            // Use the hash algorithm to calculate the hash
            HashAlgorithm algorithm = new SHA256Managed();
            byte[] hash = algorithm.ComputeHash(saltedHashBytes);
            // Return the hash as a base64 encoded string to be compared to the stored password
            return Convert.ToBase64String(hash);
        }
    }
}
