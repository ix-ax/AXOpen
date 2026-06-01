using AXOpen.Dev.Secrets;

namespace AXOpen.Dev.Tests.Secrets;

public sealed class UserSecretsLoaderTests : IDisposable
{
    private readonly string _root = Path.Combine(Path.GetTempPath(), "axdev-secrets-tests", Guid.NewGuid().ToString("N"));

    public void Dispose()
    {
        try { if (Directory.Exists(_root)) Directory.Delete(_root, recursive: true); } catch { /* best effort */ }
    }

    private string MakeProject(string dirName, string? userSecretsId)
    {
        var dir = Path.Combine(_root, dirName);
        Directory.CreateDirectory(dir);
        var idLine = userSecretsId is null ? string.Empty : $"    <UserSecretsId>{userSecretsId}</UserSecretsId>\n";
        File.WriteAllText(Path.Combine(dir, "twin.csproj"),
            $"<Project Sdk=\"Microsoft.NET.Sdk\">\n  <PropertyGroup>\n{idLine}  </PropertyGroup>\n</Project>\n");
        return dir;
    }

    private string MakeSecretsStore(string secretsRoot, string id, string json)
    {
        var dir = Path.Combine(secretsRoot, id);
        Directory.CreateDirectory(dir);
        var path = Path.Combine(dir, "secrets.json");
        File.WriteAllText(path, json);
        return path;
    }

    private static (Func<string, string?> get, Action<string, string> set, Dictionary<string, string> store)
        FakeEnv(IDictionary<string, string>? seed = null)
    {
        var store = seed is null
            ? new Dictionary<string, string>(StringComparer.Ordinal)
            : new Dictionary<string, string>(seed, StringComparer.Ordinal);
        Func<string, string?> get = k => store.TryGetValue(k, out var v) ? v : null;
        Action<string, string> set = (k, v) => store[k] = v;
        return (get, set, store);
    }

    [Fact]
    public void Applies_secrets_from_twin_project_store()
    {
        // app dir is the working dir; twin lives at ../axpansion/twin
        var appDir = Path.Combine(_root, "app", "ax");
        Directory.CreateDirectory(appDir);
        MakeProject(Path.Combine("app", "axpansion", "twin"), "id-applies");
        var secretsRoot = Path.Combine(_root, "usersecrets");
        MakeSecretsStore(secretsRoot, "id-applies", "{\"AX_TARGET_PWD\":\"Pwd123456789+\",\"AX_USERNAME\":\"admin\"}");

        var (get, set, store) = FakeEnv();
        var applied = UserSecretsLoader.LoadInto(appDir, secretsRoot, get, set);

        Assert.Contains("AX_TARGET_PWD", applied);
        Assert.Contains("AX_USERNAME", applied);
        Assert.Equal("Pwd123456789+", store["AX_TARGET_PWD"]);
        Assert.Equal("admin", store["AX_USERNAME"]);
    }

    [Fact]
    public void Existing_environment_value_wins()
    {
        var appDir = Path.Combine(_root, "app", "ax");
        Directory.CreateDirectory(appDir);
        MakeProject(Path.Combine("app", "axpansion", "twin"), "id-precedence");
        var secretsRoot = Path.Combine(_root, "usersecrets");
        MakeSecretsStore(secretsRoot, "id-precedence", "{\"AX_TARGET_PWD\":\"from-store\"}");

        var (get, set, store) = FakeEnv(new Dictionary<string, string> { ["AX_TARGET_PWD"] = "from-env" });
        var applied = UserSecretsLoader.LoadInto(appDir, secretsRoot, get, set);

        Assert.DoesNotContain("AX_TARGET_PWD", applied);
        Assert.Equal("from-env", store["AX_TARGET_PWD"]);
    }

    [Fact]
    public void Missing_project_is_noop()
    {
        var appDir = Path.Combine(_root, "lonely");
        Directory.CreateDirectory(appDir);
        var secretsRoot = Path.Combine(_root, "usersecrets");

        var (get, set, store) = FakeEnv();
        var applied = UserSecretsLoader.LoadInto(appDir, secretsRoot, get, set);

        Assert.Empty(applied);
        Assert.Empty(store);
    }

    [Fact]
    public void Missing_store_is_noop()
    {
        var appDir = Path.Combine(_root, "app", "ax");
        Directory.CreateDirectory(appDir);
        MakeProject(Path.Combine("app", "axpansion", "twin"), "id-no-store");
        var secretsRoot = Path.Combine(_root, "usersecrets"); // no secrets.json written

        var (get, set, store) = FakeEnv();
        var applied = UserSecretsLoader.LoadInto(appDir, secretsRoot, get, set);

        Assert.Empty(applied);
        Assert.Empty(store);
    }

    [Fact]
    public void Malformed_json_is_noop()
    {
        var appDir = Path.Combine(_root, "app", "ax");
        Directory.CreateDirectory(appDir);
        MakeProject(Path.Combine("app", "axpansion", "twin"), "id-bad-json");
        var secretsRoot = Path.Combine(_root, "usersecrets");
        MakeSecretsStore(secretsRoot, "id-bad-json", "{ not valid json ");

        var (get, set, store) = FakeEnv();
        var applied = UserSecretsLoader.LoadInto(appDir, secretsRoot, get, set);

        Assert.Empty(applied);
        Assert.Empty(store);
    }

    [Fact]
    public void Project_without_user_secrets_id_is_noop()
    {
        var appDir = Path.Combine(_root, "app", "ax");
        Directory.CreateDirectory(appDir);
        MakeProject(Path.Combine("app", "axpansion", "twin"), userSecretsId: null);
        var secretsRoot = Path.Combine(_root, "usersecrets");

        var (get, set, store) = FakeEnv();
        var applied = UserSecretsLoader.LoadInto(appDir, secretsRoot, get, set);

        Assert.Empty(applied);
        Assert.Empty(store);
    }

    [Fact]
    public void Ax_secrets_project_override_takes_precedence()
    {
        var appDir = Path.Combine(_root, "app", "ax");
        Directory.CreateDirectory(appDir);
        // No twin at the default probe path; the override points elsewhere.
        var customDir = MakeProject("custom", "id-override");
        var secretsRoot = Path.Combine(_root, "usersecrets");
        MakeSecretsStore(secretsRoot, "id-override", "{\"AX_TARGET_PWD\":\"override-pwd\"}");

        var (get, set, store) = FakeEnv(new Dictionary<string, string> { ["AX_SECRETS_PROJECT"] = customDir });
        var applied = UserSecretsLoader.LoadInto(appDir, secretsRoot, get, set);

        Assert.Contains("AX_TARGET_PWD", applied);
        Assert.Equal("override-pwd", store["AX_TARGET_PWD"]);
    }

    [Fact]
    public void Nested_json_flattens_with_colon()
    {
        var appDir = Path.Combine(_root, "app", "ax");
        Directory.CreateDirectory(appDir);
        MakeProject(Path.Combine("app", "axpansion", "twin"), "id-nested");
        var secretsRoot = Path.Combine(_root, "usersecrets");
        MakeSecretsStore(secretsRoot, "id-nested", "{\"Plc\":{\"Password\":\"deep\"}}");

        var (get, set, store) = FakeEnv();
        var applied = UserSecretsLoader.LoadInto(appDir, secretsRoot, get, set);

        Assert.Contains("Plc:Password", applied);
        Assert.Equal("deep", store["Plc:Password"]);
    }
}
