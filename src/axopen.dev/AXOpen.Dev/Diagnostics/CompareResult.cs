namespace AXOpen.Dev.Diagnostics;

/// <summary>Classification of an <c>apax sld compare --mode all</c> run.</summary>
public enum CompareOutcome
{
    Identical,
    CodeBlocksDiffer,
    DataBlocksDiffer,
    CodeAndDataBlocksDiffer,
    Unspecified,
}

/// <summary>
/// Maps the apax compare exit codes to an outcome and a process exit code.
/// Ports <c>compare_all.sh</c>: 0 identical, 9 code differ, 10 data differ, 11 both differ.
/// Unlike the bash (which swallowed 9/10/11 and exited 0), the known codes are propagated
/// as the process exit code so callers can react; unknown codes fail with 1.
/// </summary>
public sealed record CompareResult(CompareOutcome Outcome, int ProcessExitCode, string Message)
{
    public bool IsIdentical => Outcome == CompareOutcome.Identical;

    public static CompareResult FromApaxExitCode(int apaxExitCode) => apaxExitCode switch
    {
        0 => new(CompareOutcome.Identical, 0,
            "The compiled software and loaded one are identical."),
        9 => new(CompareOutcome.CodeBlocksDiffer, 9,
            "At least one code block is different between the compiled software and loaded one."),
        10 => new(CompareOutcome.DataBlocksDiffer, 10,
            "At least one data block is different between the compiled software and loaded one."),
        11 => new(CompareOutcome.CodeAndDataBlocksDiffer, 11,
            "At least one code block and one data block are different between the compiled software and loaded one."),
        _ => new(CompareOutcome.Unspecified, 1,
            "Unspecified return code during comparing! Please check the details above."),
    };
}
