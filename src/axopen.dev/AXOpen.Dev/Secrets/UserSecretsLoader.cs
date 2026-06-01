using System.Text.Json;
using System.Text.RegularExpressions;

namespace AXOpen.Dev.Secrets;

/// <summary>
/// Loads dotnet user-secrets into the process environment so PLC verbs can resolve
/// credentials (AX_TARGET_PWD, AX_USERNAME, …) without a prior <c>source load-secrets.sh</c>.
///
/// Replaces the template's <c>load-secrets.sh</c>: that script ran
/// <c>dotnet user-secrets list</c> in the twin project and exported every key. This reads the
/// same store directly — it locates the twin project's <c>&lt;UserSecretsId&gt;</c> and parses
/// <c>%APPDATA%/Microsoft/UserSecrets/&lt;id&gt;/secrets.json</c> (Windows) or
/// <c>~/.microsoft/usersecrets/&lt;id&gt;/secrets.json</c> (Unix).
///
/// Precedence matches the bash flow: an already-set environment variable always wins, so an
/// explicit <c>AX_TARGET_PWD</c> (or apax variable) is never overwritten. Missing project /
/// missing store / unreadable JSON are silent no-ops — axdev still runs and the per-command
/// argument guards report any genuinely missing credential.
/// </summary>
public static class UserSecretsLoader
{
    /// <summary>Project locations probed (in order) for a <c>&lt;UserSecretsId&gt;</c>, relative to the
    /// current directory. axdev runs in the app (<c>ax/</c>) dir; the secrets live in the twin.</summary>
    public static readonly string[] DefaultProjectProbePaths =
    {
        Path.Combine("..", "axpansion", "twin"),
        ".",
    };

    private static readonly Regex UserSecretsIdRegex =
        new("<UserSecretsId>\\s*(?<id>[^<\\s]+)\\s*</UserSecretsId>", RegexOptions.IgnoreCase | RegexOptions.Compiled);

    /// <summary>
    /// Production entry point: probes from the current directory, reads the real user-secrets
    /// root, and applies values to the process environment. Never throws.
    /// </summary>
    /// <returns>The keys that were applied (i.e. set because no env var already existed).</returns>
    public static IReadOnlyList<string> Load()
    {
        try
        {
            return LoadInto(
                Directory.GetCurrentDirectory(),
                DefaultUserSecretsRoot(),
                Environment.GetEnvironmentVariable,
                (k, v) => Environment.SetEnvironmentVariable(k, v));
        }
        catch
        {
            // Secret loading is best-effort; never let it break a command.
            return Array.Empty<string>();
        }
    }

    /// <summary>
    /// Testable core. Resolves the secrets project, reads its <c>secrets.json</c>, and applies
    /// each flattened key to <paramref name="setEnv"/> unless <paramref name="getEnv"/> already
    /// returns a non-empty value for it.
    /// </summary>
    /// <param name="startDir">Directory to probe from (the app/working dir).</param>
    /// <param name="userSecretsRoot">Root holding <c>&lt;id&gt;/secrets.json</c> folders.</param>
    /// <param name="getEnv">Reads an environment variable (existing value wins).</param>
    /// <param name="setEnv">Sets an environment variable.</param>
    /// <returns>The keys that were applied.</returns>
    public static IReadOnlyList<string> LoadInto(
        string startDir,
        string userSecretsRoot,
        Func<string, string?> getEnv,
        Action<string, string> setEnv)
    {
        var id = ResolveUserSecretsId(startDir, getEnv);
        if (string.IsNullOrEmpty(id)) return Array.Empty<string>();

        var secretsPath = Path.Combine(userSecretsRoot, id, "secrets.json");
        if (!File.Exists(secretsPath)) return Array.Empty<string>();

        Dictionary<string, string> values;
        try
        {
            using var doc = JsonDocument.Parse(File.ReadAllText(secretsPath));
            values = new Dictionary<string, string>(StringComparer.Ordinal);
            Flatten(doc.RootElement, prefix: null, values);
        }
        catch (JsonException)
        {
            return Array.Empty<string>();
        }

        var applied = new List<string>();
        foreach (var (key, value) in values)
        {
            if (!string.IsNullOrEmpty(getEnv(key))) continue; // existing env wins
            setEnv(key, value);
            applied.Add(key);
        }
        return applied;
    }

    /// <summary>Resolves the twin project's UserSecretsId, honouring the AX_SECRETS_PROJECT override.</summary>
    private static string? ResolveUserSecretsId(string startDir, Func<string, string?> getEnv)
    {
        // Explicit override: a .csproj file or a directory containing one.
        var overridePath = getEnv("AX_SECRETS_PROJECT");
        if (!string.IsNullOrWhiteSpace(overridePath))
        {
            var resolved = Path.IsPathRooted(overridePath) ? overridePath : Path.Combine(startDir, overridePath);
            var id = ReadUserSecretsIdFromPath(resolved);
            if (!string.IsNullOrEmpty(id)) return id;
        }

        foreach (var probe in DefaultProjectProbePaths)
        {
            var id = ReadUserSecretsIdFromPath(Path.Combine(startDir, probe));
            if (!string.IsNullOrEmpty(id)) return id;
        }
        return null;
    }

    /// <summary>Reads UserSecretsId from a csproj file path, or from the first csproj in a directory.</summary>
    private static string? ReadUserSecretsIdFromPath(string path)
    {
        if (File.Exists(path)) return ReadUserSecretsIdFromCsproj(path);
        if (!Directory.Exists(path)) return null;

        foreach (var csproj in Directory.EnumerateFiles(path, "*.csproj", SearchOption.TopDirectoryOnly))
        {
            var id = ReadUserSecretsIdFromCsproj(csproj);
            if (!string.IsNullOrEmpty(id)) return id;
        }
        return null;
    }

    private static string? ReadUserSecretsIdFromCsproj(string csprojPath)
    {
        try
        {
            var match = UserSecretsIdRegex.Match(File.ReadAllText(csprojPath));
            return match.Success ? match.Groups["id"].Value : null;
        }
        catch (IOException)
        {
            return null;
        }
    }

    /// <summary>The OS-default user-secrets root, matching the .NET Secret Manager layout.</summary>
    public static string DefaultUserSecretsRoot()
    {
        // Windows: %APPDATA%\Microsoft\UserSecrets ; Unix: ~/.microsoft/usersecrets
        var appData = Environment.GetEnvironmentVariable("APPDATA");
        if (!string.IsNullOrEmpty(appData))
            return Path.Combine(appData, "Microsoft", "UserSecrets");

        var home = Environment.GetEnvironmentVariable("HOME") ?? string.Empty;
        return Path.Combine(home, ".microsoft", "usersecrets");
    }

    /// <summary>Flattens nested JSON to <c>key:subkey</c> form (the Secret Manager convention),
    /// keeping flat keys (e.g. <c>AX_TARGET_PWD</c>) exact.</summary>
    private static void Flatten(JsonElement element, string? prefix, IDictionary<string, string> into)
    {
        switch (element.ValueKind)
        {
            case JsonValueKind.Object:
                foreach (var prop in element.EnumerateObject())
                {
                    var key = prefix is null ? prop.Name : $"{prefix}:{prop.Name}";
                    Flatten(prop.Value, key, into);
                }
                break;
            case JsonValueKind.String:
                if (prefix is not null) into[prefix] = element.GetString() ?? string.Empty;
                break;
            case JsonValueKind.Number:
            case JsonValueKind.True:
            case JsonValueKind.False:
                if (prefix is not null) into[prefix] = element.GetRawText();
                break;
            // Arrays / null: not used by the secrets convention here — skip.
        }
    }
}
