namespace AXOpen.Dev.Requisites;

/// <summary>
/// Faithful port of the token/username masking in the @inxton registry section of
/// <c>scripts/check_requisites.ps1</c>. Used only for display.
/// </summary>
public static class SecretMasking
{
    /// <summary>first 5 + stars + last 1 when longer than 6 chars; otherwise all stars.</summary>
    public static string MaskToken(string token)
    {
        token ??= string.Empty;
        return token.Length > 6
            ? token[..5] + new string('*', token.Length - 6) + token[^1]
            : new string('*', token.Length);
    }

    /// <summary>first 1 + stars + last 1 when longer than 2 chars; otherwise all stars.</summary>
    public static string MaskUserName(string userName)
    {
        userName ??= string.Empty;
        return userName.Length > 2
            ? userName[..1] + new string('*', userName.Length - 2) + userName[^1]
            : new string('*', userName.Length);
    }
}
