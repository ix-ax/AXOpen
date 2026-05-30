namespace AXOpen.Dev.Validation;

/// <summary>
/// Rejects passwords containing shell-problematic characters or whitespace. Port of
/// <c>validate_password_safe_chars</c> in <c>all_first.sh</c> (kept for parity; less necessary in
/// C# since arguments are not passed through a shell, but the first-setup flow enforces it).
/// </summary>
public static class PasswordValidator
{
    private const string Problematic = "$`\\\"'&|;<>()*?[]{}";

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
