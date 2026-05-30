using AXOpen.Dev.Apax;
using AXOpen.Dev.Observability;
using AXOpen.Dev.Validation;

namespace AXOpen.Dev.Commands;

/// <summary>apax dcp-utility discover → ./dcp_export/devices.json. Port of <c>dcp_utility_discover.sh</c>.</summary>
public sealed class DcpDiscoverCommand(ApaxClient apax)
{
    public async Task<int> ExecuteAsync(string sourceMac, CancellationToken ct = default)
    {
        if (!MacValidator.IsValid(sourceMac))
        {
            Output.Error($"The {sourceMac} is not a valid MAC address.");
            return 1;
        }

        Directory.CreateDirectory("./dcp_export");
        var exportFile = Path.Combine("dcp_export", "devices.json");
        if (File.Exists(exportFile))
        {
            File.Delete(exportFile);
        }

        var result = await apax.DcpDiscoverAsync(sourceMac, ct);
        await File.WriteAllTextAsync(exportFile, result.StandardOutput, ct);
        return result.ExitCode;
    }
}

/// <summary>apax dcp-utility list-interfaces → ./dcp_export/interfaces.json. Port of <c>dcp_utility_list_interfaces.sh</c>.</summary>
public sealed class DcpListInterfacesCommand(ApaxClient apax)
{
    public async Task<int> ExecuteAsync(CancellationToken ct = default)
    {
        Directory.CreateDirectory("./dcp_export");
        var exportFile = Path.Combine("dcp_export", "interfaces.json");
        if (File.Exists(exportFile))
        {
            File.Delete(exportFile);
        }

        var result = await apax.DcpListInterfacesAsync(ct);
        await File.WriteAllTextAsync(exportFile, result.StandardOutput, ct);
        return result.ExitCode;
    }
}
