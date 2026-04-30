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
    /// <param name="withSpecificData">If true, includes specific data in the trigger request.</param>
    private async Task Trigger()
    {
        if (_visionClient is null)
            throw new InvalidOperationException(
                "VisionTcpClient is not initialized. Call InitializeVisionClientAsync first.");

        var control = await Control.OnlineToPlainAsync(eAccessPriority.High);

        JsonElement? dataElement = null;
       

        var payload = new TriggerRequestPayload
        {
            TriggerId = control.TriggerId,
            PartId = control.PartId,
            Variant = control.VariantId,
            Data = dataElement
        };

        var result = await _visionClient.TriggerAsync(payload);

        if (!result.Accepted)
            throw new InvalidOperationException(
                $"TriggerRequest rejected by Vision PC: [{result.ErrorCode}] {result.RejectReason}");

        var status = Status.CreateEmptyPoco();
        status.Accepted = result.Accepted;
        status.TriggerId = result.TriggerId;
        status.ErrorCode = result.ErrorCode;
        status.RejectReason = result.RejectReason;
        await Status.PlainToOnline(status, priority: eAccessPriority.High);

    }

    /// <summary>
    /// Executed by <see cref="SetRecipeTask"/> when PLC invokes the remote call.
    /// </summary>
    private async Task SetRecipe()
    {
        if (_visionClient is null)
            throw new InvalidOperationException(
                "VisionTcpClient is not initialized. Call InitializeVisionClientAsync first.");



        JsonElement? dataElement = null;
        var control = await Control.OnlineToPlainAsync(eAccessPriority.High);

        var payload = new SetRecipeRequestPayload
        {
            Variant = control.VariantId,
            Data = dataElement
        };

        var result = await _visionClient.SetRecipeAsync(payload);

        if (!result.Success)
            throw new InvalidOperationException(
                $"SetRecipeRequest failed: [{result.ErrorCode}] {result.Reason}");

        var status = Status.CreateEmptyPoco();
        status.Accepted = result.Success;
        status.TriggerId = 0;
        status.ErrorCode = result.ErrorCode;
        status.RejectReason = result.Reason;
        await Status.PlainToOnline(status, priority: eAccessPriority.High);
    }


    /// <summary>
    /// Executed by <see cref="SendSpecificDataTask"/> when PLC invokes the remote call.
    /// </summary>
    private async Task SendSpecificData()
    {
        await SendSpecificDataCore(includeTypes: false);
    }

    /// <summary>
    /// Executed by <see cref="SendSpecificDataAndTypesTask"/> when PLC invokes the remote call.
    /// </summary>
    private async Task SendSpecificDataTypes()
    {
        await SendSpecificDataCore(includeTypes: true);
    }

    private async Task SendSpecificDataCore(bool includeTypes)
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
            Data = includeTypes
                ? VisionTypedPayloadSerializer.SerializeToElement(plainData)
                : JsonSerializer.SerializeToElement(plainData, plainData.GetType(), VisionJsonOptions.Default)
        };

        var result = includeTypes
            ? await _visionClient.SendSpecificDataTypesAsync(payload)
            : await _visionClient.SendSpecificDataAsync(payload);

        if (!result.Success)
            throw new InvalidOperationException(
                $"{(includeTypes ? VisionEnvelope.MessageTypes.SendSpecificDataTypesRequest : VisionEnvelope.MessageTypes.SendSpecificDataRequest)} failed: [{result.ErrorCode}] {result.Reason}");

        var status = Status.CreateEmptyPoco();
        status.Accepted = result.Success;
        status.TriggerId = 0;
        status.ErrorCode = result.ErrorCode;
        status.RejectReason = result.Reason;
        await Status.PlainToOnline(status, priority: eAccessPriority.High);
    }


    /// <summary>
    /// Executed by <see cref="ReceiveSpecificDataTask"/> when PLC invokes the remote call.
    /// </summary>
    private async Task ReceiveSpecificData()
    {
        if (_visionClient is null)
            throw new InvalidOperationException(
                "VisionTcpClient is not initialized. Call InitializeVisionClientAsync first.");



        var plainData = (await GetDataAsync(eAccessPriority.Normal))?.Plain;
        

        if (plainData == null) return;

        var payload = new ReceiveSpecificDataRequestPayload
        {
            Data = JsonSerializer.SerializeToElement(plainData, plainData.GetType(), VisionJsonOptions.Default)
        };

        var result = await _visionClient.ReceiveSpecificDataAsync(payload);

        if (!result.Success)
            throw new InvalidOperationException(
                $"ReceiveSpecificDataRequest failed: [{result.ErrorCode}] {result.Reason}");


        var status = Status.CreateEmptyPoco();
        status.Accepted = result.Success;
        status.TriggerId = 0;
        status.ErrorCode = result.ErrorCode;
        status.RejectReason = result.Reason;

        await Status.PlainToOnline(status, priority: eAccessPriority.High);
        if (!result.Data.HasValue)
            return;

        var data = result.Data.Value.Deserialize(plainData.GetType(), VisionJsonOptions.Default);
        if (data == null)
            return;

        await PlainToOnlineAsync(data, eAccessPriority.Normal);
    }


    private async Task TriggerWithSpecificData()
    {
        if (_visionClient is null)
            throw new InvalidOperationException(
                "VisionTcpClient is not initialized. Call InitializeVisionClientAsync first.");

        var control = await Control.OnlineToPlainAsync(eAccessPriority.High);
        var container = SpecificDataContainer;
        if (container == null) return;

        var plainData = (await GetDataAsync(eAccessPriority.Normal))?.Plain;
        if (plainData == null) return;


        var payload = new TriggerRequestPayload
        {
            TriggerId = control.TriggerId,
            PartId = control.PartId,
            Variant = control.VariantId,
            Data = JsonSerializer.SerializeToElement(plainData, plainData.GetType(), VisionJsonOptions.Default)
        };



        var result = await _visionClient.TriggerWithSpecificDataAsync(payload);

        if (!result.Accepted)
            throw new InvalidOperationException(
                $"TriggerWithSpecificDataRequest rejected by Vision PC: [{result.ErrorCode}] {result.RejectReason}");

        var status = Status.CreateEmptyPoco();
        status.Accepted = result.Accepted;
        status.TriggerId = result.TriggerId;
        status.ErrorCode = result.ErrorCode;
        status.RejectReason = result.RejectReason;
        await Status.PlainToOnline(status, priority: eAccessPriority.High);

        if (!result.Data.HasValue)
            return;

        var data = result.Data.Value.Deserialize(plainData.GetType(), VisionJsonOptions.Default);
        if (data == null)
            return;

        await PlainToOnlineAsync(data, eAccessPriority.Normal);
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
            Data = VisionTypedPayloadSerializer.SerializeToElement(plainData)
        };

        var result = await _visionClient.InspectionResultAsync(payload);

        if (!result.Success)
            throw new InvalidOperationException(
                $"InspectionResultRequest failed: [{result.ErrorCode}] {result.Reason}");

        await PlainToOnlineAsync(plainData, eAccessPriority.Normal);
    }

   

   

    
}
