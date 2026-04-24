using AXOpen.Components.Cognex.Vision.VisionProtocol;
using AXSharp.Connector;
using System.Text.Json;

namespace AXOpen.Components.Cognex.Vision;

/// <summary>
/// Partial class — TCP client integration for AxoVisionProNet.
/// This file owns the <see cref="VisionTcpClient"/> instance and the
/// async implementations that back each <see cref="AXOpen.Core.AxoRemoteTask"/>.
/// </summary>
public partial class AxoVisionProNet
{
    private VisionTcpClient? _visionClient;

    /// <summary>
    /// Configures and connects the Vision PC TCP client.
    /// The component's own <see cref="AXSharp.Connector.ITwinObject.Symbol"/> is used
    /// automatically as <c>ComponentSymbol</c> in every message envelope.
    /// </summary>
    /// <param name="host">Hostname or IP of the Vision PC TCP server.</param>
    /// <param name="port">TCP port (default 8500).</param>
    /// <param name="connectionMode">Persistent keeps socket open, PerRequest opens/closes per call.</param>
    /// <param name="ct">Optional cancellation token.</param>
    public async Task InitializeVisionClientAsync(
        string host,
        int port = 8500,
        VisionConnectionMode connectionMode = VisionConnectionMode.Persistent,
        CancellationToken ct = default)
    {
        if (_visionClient is not null)
            await _visionClient.DisposeAsync();

        var options = new VisionTcpClientOptions
        {
            Host            = host,
            Port            = port,
            ConnectionMode  = connectionMode,
            ComponentSymbol = this.Symbol   // full twin symbol, e.g. "Ctx.VisionStation1"
        };

        _visionClient = new VisionTcpClient(options);

        if (connectionMode == VisionConnectionMode.Persistent)
            await _visionClient.ConnectAsync(ct);
    }

    // ──────────────────────────────────────────────────────────────
    // RemoteTask handlers
    // ──────────────────────────────────────────────────────────────

    /// <summary>
    /// Executed by <see cref="TriggerTask"/> when PLC invokes the remote call.
    /// </summary>
    private async Task Trigger()
    {
        if (_visionClient is null)
            throw new InvalidOperationException(
                "VisionTcpClient is not initialized. Call InitializeVisionClientAsync first.");

        var container = SpecificDataContainer;
        if (container == null) return;

        var plainData = (await GetDataAsync(eAccessPriority.Normal))?.Plain;
        if (plainData == null) return;

        var payload = new TriggerRequestPayload
        {
            Data = JsonSerializer.SerializeToElement(plainData, plainData.GetType(), VisionJsonOptions.Default)
        };

        var result = await _visionClient.TriggerAsync(payload);

        if (!result.Accepted)
            throw new InvalidOperationException(
                $"TriggerRequest rejected by Vision PC: [{result.ErrorCode}] {result.RejectReason}");

        //await PlainToOnlineAsync(plainData, eAccessPriority.Normal);
    }

    /// <summary>
    /// Executed by <see cref="InspectionResultTask"/> when PLC invokes the remote call.
    /// </summary>
    private async Task InspectionResult()
    {
        if (_visionClient is null)
            throw new InvalidOperationException(
                "VisionTcpClient is not initialized. Call InitializeVisionClientAsync first.");

        var container = SpecificDataContainer;
        if (container == null) return;

        var plainData = (await GetDataAsync(eAccessPriority.Normal))?.Plain;
        if (plainData == null) return;

        var payload = new InspectionResultRequestPayload
        {
            Data = JsonSerializer.SerializeToElement(plainData, plainData.GetType(), VisionJsonOptions.Default)
        };

        var result = await _visionClient.InspectionResultAsync(payload);

        if (!result.Success)
            throw new InvalidOperationException(
                $"InspectionResultRequest failed: [{result.ErrorCode}] {result.Reason}");

        await PlainToOnlineAsync(plainData, eAccessPriority.Normal);
    }

    /// <summary>
    /// Executed by <see cref="SendSpecificDataTask"/> when PLC invokes the remote call.
    /// </summary>
    private async Task SendSpecificData()
    {
        if (_visionClient is null)
            throw new InvalidOperationException(
                "VisionTcpClient is not initialized. Call InitializeVisionClientAsync first.");

        var container = SpecificDataContainer;
        if (container == null) return;

        var plainData = (await GetDataAsync(eAccessPriority.Normal))?.Plain;
        if (plainData == null) return;

        var payload = new SendSpecificDataRequestPayload
        {
            Data = JsonSerializer.SerializeToElement(plainData, plainData.GetType(), VisionJsonOptions.Default)
        };

        var result = await _visionClient.SendSpecificDataAsync(payload);

        if (!result.Success)
            throw new InvalidOperationException(
                $"SendSpecificDataRequest failed: [{result.ErrorCode}] {result.Reason}");

        //await PlainToOnlineAsync(plainData, eAccessPriority.Normal);
    }

    /// <summary>
    /// Executed by <see cref="SetRecipeTask"/> when PLC invokes the remote call.
    /// </summary>
    private async Task SetRecipe()
    {
        if (_visionClient is null)
            throw new InvalidOperationException(
                "VisionTcpClient is not initialized. Call InitializeVisionClientAsync first.");

        var container = SpecificDataContainer;
        if (container == null) return;

        var plainData = (await GetDataAsync(eAccessPriority.Normal))?.Plain;
        if (plainData == null) return;

        var payload = new SetRecipeRequestPayload
        {
            Data = JsonSerializer.SerializeToElement(plainData, plainData.GetType(), VisionJsonOptions.Default)
        };

        var result = await _visionClient.SetRecipeAsync(payload);

        if (!result.Success)
            throw new InvalidOperationException(
                $"SetRecipeRequest failed: [{result.ErrorCode}] {result.Reason}");

        //await PlainToOnlineAsync(plainData, eAccessPriority.Normal);
    }
}
