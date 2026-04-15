using System;
using System.Security.Cryptography;
using System.Text;

namespace AXOpen.Security.Services
{
    public static class TokenHasher
    {
        /// <summary>
        /// Hashes a token using SHA512 with ASCII encoding
        /// </summary>
        /// <param name="token">The plain text token to hash</param>
        /// <returns>ASCII string representation of the SHA512 hash</returns>
        public static string HashToken(string token)
        {
            if (string.IsNullOrEmpty(token))
            {
                throw new ArgumentNullException(nameof(token));
            }

            var trimmedToken = token.Trim();
            var tokenBytes = Encoding.ASCII.GetBytes(trimmedToken);
            var hashBytes = SHA512.HashData(tokenBytes);
            return Encoding.ASCII.GetString(hashBytes);
        }

        /// <summary>
        /// Verifies if a plain text token matches a hashed token
        /// </summary>
        /// <param name="plainToken">The plain text token</param>
        /// <param name="hashedToken">The hashed token to compare against</param>
        /// <returns>True if they match, false otherwise</returns>
        public static bool VerifyToken(string plainToken, string hashedToken)
        {
            if (string.IsNullOrEmpty(plainToken) || string.IsNullOrEmpty(hashedToken))
            {
                return false;
            }

            var hashOfInput = HashToken(plainToken);
            return hashOfInput.Equals(hashedToken, StringComparison.Ordinal);
        }
    }
}
