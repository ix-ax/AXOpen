namespace AXOpen.Dev.Validation;

/// <summary>Thrown when a workflow argument fails validation.</summary>
public sealed class ArgumentValidationException(string message) : Exception(message);

/// <summary>
/// Input guards ported from the bash scripts (e.g. <c>all.sh</c>). The source scripts only
/// require non-empty values (no special-character password filtering exists), validate
/// <c>USE_PLC_SIM_ADVANCED</c> as a case-insensitive true/false, and treat <c>FORCE</c> as a
/// case-sensitive exact "true".
/// </summary>
public static class ArgumentGuards
{
    public static void EnsureNotEmpty(string name, string? value)
    {
        if (string.IsNullOrWhiteSpace(value))
        {
            throw new ArgumentValidationException($"The {name} could not be an empty string.");
        }
    }

    public static bool ParsePlcSim(string? value)
    {
        return (value?.Trim().ToLowerInvariant()) switch
        {
            "true" => true,
            "false" => false,
            _ => throw new ArgumentValidationException(
                $"USE_PLC_SIM_ADVANCED has an invalid or undefined value: '{value}'."),
        };
    }

    public static bool ParseForce(string? value) => value == "true";
}
