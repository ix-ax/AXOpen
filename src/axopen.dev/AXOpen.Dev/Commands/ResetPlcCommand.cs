using AXOpen.Dev.Apax;
using AXOpen.Dev.Observability;
using AXOpen.Dev.Validation;

namespace AXOpen.Dev.Commands;

/// <summary>
/// Resets a PLC. <see cref="ResetScope.KeepOnlyIp"/> ports <c>clean_plc.sh</c>;
/// <see cref="ResetScope.All"/> ports <c>reset_plc.sh</c>.
/// </summary>
public sealed class ResetPlcCommand(ApaxClient apax)
{
    public async Task<int> ExecuteAsync(ResetScope scope, string ipAddress, string username, string password, CancellationToken ct = default)
    {
        if (!IpValidator.IsValidIp(ipAddress))
        {
            Output.Error($"The PLC_IP_ADDRESS '{ipAddress}' is not a valid IP address.");
            return 1;
        }

        try
        {
            ArgumentGuards.EnsureNotEmpty("USERNAME", username);
            ArgumentGuards.EnsureNotEmpty("PASSWORD", password);
        }
        catch (ArgumentValidationException ex)
        {
            Output.Error(ex.Message);
            return 1;
        }

        var result = await apax.ResetAsync(scope, ipAddress, username, password, ct);
        if (!result.Success)
        {
            Output.Error("Unable to reset the PLC! Please check the details above.");
            return 1;
        }

        Output.Success("PLC was reset successfully.");
        return 0;
    }
}
