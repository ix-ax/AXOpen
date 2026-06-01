namespace AXOpen.Dev.Validation;

/// <summary>
/// Rejects passwords containing shell-problematic characters or whitespace. Port of
/// <c>validate_password_safe_chars</c> in <c>all_first.sh</c> (kept for parity; less necessary in
/// C# since arguments are not passed through a shell, but the first-setup flow enforces it).
///
/// The blocklist is aligned with the complexity policy enforced when secrets are set
/// (<c>configure-secrets.sh</c>: special chars <c>!@#$%^&amp;*()_+-=</c> are required/allowed).
/// The characters that policy endorses — <c>$ &amp; ( ) *</c> — are therefore NOT blocked here, so a
/// password that satisfies the set-time complexity rule is not rejected at use time.
/// </summary>
public static class PasswordValidator
{
    // Note: $ & ( ) * are intentionally absent — they are endorsed by the configure-secrets
    // complexity set. Arguments reach apax/openssl via CliWrap (no shell), so these are safe.
    private const string Problematic = "`\\\"'|;<>?[]{}";

    public static bool IsSafe(string? password)
    {
        if (string.IsNullOrEmpty(password))
        {
            return false;
        }

        foreach (var c in password)
        {
            if (char.IsWhiteSpace(c) || Problematic.IndexOf(c) >= 0)
            {
                return false;
            }
        }

        return true;
    }
}
