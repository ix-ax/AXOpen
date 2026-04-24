using System.Collections.Concurrent;
using System.Net.Sockets;
using System.Text;
using System.Text.Json;

namespace AXOpen.Components.Cognex.Vision.VisionProtocol;

/// <summary>
/// Determines when the TCP socket is opened and closed.
/// </summary>
public enum VisionConnectionMode
{
    /// <summary>
    /// Keep one socket open and reuse it for all requests.
    /// </summary>
    Persistent,

    /// <summary>
    /// Open a socket for each request and close it after response.
    /// </summary>
    PerRequest
}

// ──────────────────────────────────────────────────────────────
// Connection options
// ──────────────────────────────────────────────────────────────

/// <summary>
/// Configuration for a <see cref="VisionTcpClient"/> instance.
/// </summary>
public sealed class VisionTcpClientOptions
{
    /// <summary>Hostname or IP address of the Vision PC TCP server.</summary>
    public required string Host { get; init; }

    /// <summary>TCP port the Vision PC server listens on.</summary>
    public int Port { get; init; } = 8500;

    /// <summary>
    /// Full twin symbol of the AxoVisionProNet component instance.
    /// Set automatically from <c>AxoVisionProNet.Symbol</c> when calling
    /// <see cref="AxoVisionProNet.InitializeVisionClientAsync"/>.
    /// </summary>
    public required string ComponentSymbol { get; init; }

    /// <summary>
    /// Selects if the client stays connected all the time or reconnects per request.
    /// </summary>
    public VisionConnectionMode ConnectionMode { get; init; } = VisionConnectionMode.Persistent;

    /// <summary>How long to wait for a TriggerAccepted / TriggerRejected after sending TriggerRequest.</summary>
    public TimeSpan TriggerAcceptTimeout { get; init; } = TimeSpan.FromMilliseconds(500);

    /// <summary>How long to wait for InspectionCompleted after sending InspectionResultRequest.</summary>
    public TimeSpan InspectionResultTimeout { get; init; } = TimeSpan.FromMilliseconds(500);

    /// <summary>How long to wait for SendSpecificDataCompleted after sending SendSpecificDataRequest.</summary>
    public TimeSpan SendSpecificDataTimeout { get; init; } = TimeSpan.FromMilliseconds(500);

    /// <summary>How long to wait for SetRecipeCompleted after sending SetRecipeRequest.</summary>
    public TimeSpan SetRecipeTimeout { get; init; } = TimeSpan.FromMilliseconds(500);

    /// <summary>How long to attempt reconnecting before giving up one cycle.</summary>
    public TimeSpan ReconnectDelay { get; init; } = TimeSpan.FromSeconds(2);
}

// ──────────────────────────────────────────────────────────────
// TCP client
// ──────────────────────────────────────────────────────────────

/// <summary>
/// Persistent TCP client that handles the PLC ↔ Vision PC runtime channel.
/// <para>
/// Transport: newline-delimited JSON  (one JSON object per line, UTF-8).
/// Framing is simple, human-readable, and easy to capture with Wireshark or netcat.
/// </para>
/// <para>
/// Concurrency: a single background receive loop dispatches responses using
/// <see cref="TaskCompletionSource{T}"/> keyed by the outgoing <c>MessageId</c>.
/// The Vision PC echoes that ID back in <c>CorrelationId</c>.
/// </para>
/// </summary>
public sealed class VisionTcpClient : IAsyncDisposable
{
    private readonly VisionTcpClientOptions _options;

    private TcpClient?     _tcp;
    private StreamWriter?  _writer;
    private StreamReader?  _reader;
    private CancellationTokenSource? _cts;
    private Task?          _receiveLoop;

    private long _sequenceNumber;

    // Pending awaits: key = MessageId we sent, value = completion source waiting for Vision response.
    private readonly ConcurrentDictionary<string, TaskCompletionSource<VisionEnvelope>> _pending = new();

    public bool IsConnected => _tcp?.Connected ?? false;

    public VisionTcpClient(VisionTcpClientOptions options)
    {
        _options = options;
    }

    // ──────────────────────────────────────────────────────────
    // Connect / disconnect
    // ──────────────────────────────────────────────────────────

    /// <summary>
    /// Opens the TCP connection to Vision PC and starts the receive loop.
    /// Safe to call repeatedly; it will only connect when disconnected.
    /// </summary>
    public async Task ConnectAsync(CancellationToken ct = default)
    {
        if (IsConnected)
            return;

        await DisconnectInternalAsync();

        _cts = CancellationTokenSource.CreateLinkedTokenSource(ct);

        _tcp = new TcpClient();
        await _tcp.ConnectAsync(_options.Host, _options.Port, ct);

        var stream = _tcp.GetStream();
        _writer = new StreamWriter(stream, Encoding.UTF8) { AutoFlush = true, NewLine = "\n" };
        _reader = new StreamReader(stream, Encoding.UTF8);

        _receiveLoop = Task.Run(() => ReceiveLoopAsync(_cts.Token), CancellationToken.None);
    }

    // ──────────────────────────────────────────────────────────
    // Trigger flow  (step 1)
    // ──────────────────────────────────────────────────────────

    /// <summary>
    /// Sends a <c>TriggerRequest</c> and awaits a <c>TriggerAccepted</c> or
    /// <c>TriggerRejected</c> response from Vision PC.
    /// </summary>
    /// <param name="payload">Data to forward from PLC.</param>
    /// <param name="ct">Cancellation token from the RemoteTask handler.</param>
    /// <returns>
    /// <see cref="TriggerResult.Accepted"/> is true when Vision accepted the trigger.
    /// </returns>
    public async Task<TriggerResult> TriggerAsync(
        TriggerRequestPayload payload,
        CancellationToken ct = default)
    {
        bool disconnectAfterRequest = _options.ConnectionMode == VisionConnectionMode.PerRequest;

        await ConnectAsync(ct);

        VisionEnvelope envelope = BuildEnvelope(
            VisionEnvelope.MessageTypes.TriggerRequest,
            payload,
            ackRequired: true);

        // Register a completion source keyed by our own MessageId.
        // Vision echoes MessageId back as CorrelationId in its response.
        var tcs = new TaskCompletionSource<VisionEnvelope>(
            TaskCreationOptions.RunContinuationsAsynchronously);

        _pending[envelope.MessageId] = tcs;

        try
        {
            await SendAsync(envelope, ct);

            // Wait for TriggerAccepted / TriggerRejected with the configured timeout.
            using var timeoutCts = CancellationTokenSource.CreateLinkedTokenSource(ct);
            timeoutCts.CancelAfter(_options.TriggerAcceptTimeout);

            VisionEnvelope response = await tcs.Task.WaitAsync(timeoutCts.Token);

            return response.MessageType switch
            {
                VisionEnvelope.MessageTypes.TriggerAccepted =>
                    ToTriggerResult(response),

                VisionEnvelope.MessageTypes.TriggerRejected =>
                    ToTriggerRejectedResult(response),

                _ => TriggerResult.Fail(
                        $"Unexpected message type: {response.MessageType}")
            };
        }
        catch (OperationCanceledException) when (!ct.IsCancellationRequested)
        {
            // Timeout path (inner token fired, outer token is still valid)
            return TriggerResult.Fail("TriggerAccepted not received within timeout.", -2);
        }
        finally
        {
            _pending.TryRemove(envelope.MessageId, out _);

            if (disconnectAfterRequest)
                await DisconnectInternalAsync();
        }
    }

    // ──────────────────────────────────────────────────────────
    // InspectionResult flow
    // ──────────────────────────────────────────────────────────

    public async Task<VisionRequestResult> InspectionResultAsync(
        InspectionResultRequestPayload payload,
        CancellationToken ct = default)
    {
        bool disconnectAfterRequest = _options.ConnectionMode == VisionConnectionMode.PerRequest;

        await ConnectAsync(ct);

        VisionEnvelope envelope = BuildEnvelope(
            VisionEnvelope.MessageTypes.InspectionResultRequest,
            payload,
            ackRequired: true);

        var tcs = new TaskCompletionSource<VisionEnvelope>(
            TaskCreationOptions.RunContinuationsAsynchronously);

        _pending[envelope.MessageId] = tcs;

        try
        {
            await SendAsync(envelope, ct);

            using var timeoutCts = CancellationTokenSource.CreateLinkedTokenSource(ct);
            timeoutCts.CancelAfter(_options.InspectionResultTimeout);

            VisionEnvelope response = await tcs.Task.WaitAsync(timeoutCts.Token);

            return response.MessageType switch
            {
                VisionEnvelope.MessageTypes.InspectionCompleted =>
                    ToVisionRequestResult(response),

                _ => VisionRequestResult.Fail(
                        $"Unexpected message type: {response.MessageType}")
            };
        }
        catch (OperationCanceledException) when (!ct.IsCancellationRequested)
        {
            return VisionRequestResult.Fail("InspectionCompleted not received within timeout.", -2);
        }
        finally
        {
            _pending.TryRemove(envelope.MessageId, out _);

            if (disconnectAfterRequest)
                await DisconnectInternalAsync();
        }
    }

    // ──────────────────────────────────────────────────────────
    // SendSpecificData flow
    // ──────────────────────────────────────────────────────────

    public async Task<VisionRequestResult> SendSpecificDataAsync(
        SendSpecificDataRequestPayload payload,
        CancellationToken ct = default)
    {
        bool disconnectAfterRequest = _options.ConnectionMode == VisionConnectionMode.PerRequest;

        await ConnectAsync(ct);

        VisionEnvelope envelope = BuildEnvelope(
            VisionEnvelope.MessageTypes.SendSpecificDataRequest,
            payload,
            ackRequired: true);

        var tcs = new TaskCompletionSource<VisionEnvelope>(
            TaskCreationOptions.RunContinuationsAsynchronously);

        _pending[envelope.MessageId] = tcs;

        try
        {
            await SendAsync(envelope, ct);

            using var timeoutCts = CancellationTokenSource.CreateLinkedTokenSource(ct);
            timeoutCts.CancelAfter(_options.SendSpecificDataTimeout);

            VisionEnvelope response = await tcs.Task.WaitAsync(timeoutCts.Token);

            return response.MessageType switch
            {
                VisionEnvelope.MessageTypes.SendSpecificDataCompleted =>
                    ToVisionRequestResult(response),

                _ => VisionRequestResult.Fail(
                        $"Unexpected message type: {response.MessageType}")
            };
        }
        catch (OperationCanceledException) when (!ct.IsCancellationRequested)
        {
            return VisionRequestResult.Fail("SendSpecificDataCompleted not received within timeout.", -2);
        }
        finally
        {
            _pending.TryRemove(envelope.MessageId, out _);

            if (disconnectAfterRequest)
                await DisconnectInternalAsync();
        }
    }

    // ──────────────────────────────────────────────────────────
    // SetRecipe flow
    // ──────────────────────────────────────────────────────────

    public async Task<VisionRequestResult> SetRecipeAsync(
        SetRecipeRequestPayload payload,
        CancellationToken ct = default)
    {
        bool disconnectAfterRequest = _options.ConnectionMode == VisionConnectionMode.PerRequest;

        await ConnectAsync(ct);

        VisionEnvelope envelope = BuildEnvelope(
            VisionEnvelope.MessageTypes.SetRecipeRequest,
            payload,
            ackRequired: true);

        var tcs = new TaskCompletionSource<VisionEnvelope>(
            TaskCreationOptions.RunContinuationsAsynchronously);

        _pending[envelope.MessageId] = tcs;

        try
        {
            await SendAsync(envelope, ct);

            using var timeoutCts = CancellationTokenSource.CreateLinkedTokenSource(ct);
            timeoutCts.CancelAfter(_options.SetRecipeTimeout);

            VisionEnvelope response = await tcs.Task.WaitAsync(timeoutCts.Token);

            return response.MessageType switch
            {
                VisionEnvelope.MessageTypes.SetRecipeCompleted =>
                    ToVisionRequestResult(response),

                _ => VisionRequestResult.Fail(
                        $"Unexpected message type: {response.MessageType}")
            };
        }
        catch (OperationCanceledException) when (!ct.IsCancellationRequested)
        {
            return VisionRequestResult.Fail("SetRecipeCompleted not received within timeout.", -2);
        }
        finally
        {
            _pending.TryRemove(envelope.MessageId, out _);

            if (disconnectAfterRequest)
                await DisconnectInternalAsync();
        }
    }

    // ──────────────────────────────────────────────────────────
    // Internal helpers
    // ──────────────────────────────────────────────────────────

    private VisionEnvelope BuildEnvelope<T>(string messageType, T payload, bool ackRequired = false)
    {
        return new VisionEnvelope
        {
            MessageType     = messageType,
            MessageId       = Guid.NewGuid().ToString(),
            ComponentSymbol = _options.ComponentSymbol,
            SequenceNumber  = Interlocked.Increment(ref _sequenceNumber),
            TimestampUtc    = DateTime.UtcNow,
            AckRequired     = ackRequired,
            Payload         = JsonSerializer.SerializeToElement(payload, VisionJsonOptions.Default)
        };
    }

    private async Task SendAsync(VisionEnvelope envelope, CancellationToken ct)
    {
        if (_writer is null)
            throw new InvalidOperationException("Not connected — call ConnectAsync first.");

        string json = JsonSerializer.Serialize(envelope, VisionJsonOptions.Default);
        await _writer.WriteLineAsync(json.AsMemory(), ct);
    }

    /// <summary>
    /// Background loop — reads newline-delimited frames and dispatches them.
    /// </summary>
    private async Task ReceiveLoopAsync(CancellationToken ct)
    {
        if (_reader is null) return;

        try
        {
            while (!ct.IsCancellationRequested)
            {
                string? line = await _reader.ReadLineAsync(ct);

                if (line is null)
                    break; // Server closed the connection.

                if (string.IsNullOrWhiteSpace(line))
                    continue;

                VisionEnvelope? envelope;
                try
                {
                    envelope = JsonSerializer.Deserialize<VisionEnvelope>(
                        line, VisionJsonOptions.Default);
                }
                catch (JsonException)
                {
                    // Malformed frame — skip, do not crash the loop.
                    continue;
                }

                if (envelope is not null)
                    Dispatch(envelope);
            }
        }
        catch (OperationCanceledException) { /* intentional shutdown */ }
        catch (IOException)               { /* connection dropped    */ }
    }

    /// <summary>
    /// Routes an inbound envelope to the matching pending awaiter using
    /// <c>CorrelationId</c> → <c>MessageId</c> lookup.
    /// </summary>
    private void Dispatch(VisionEnvelope envelope)
    {
        if (envelope.CorrelationId is not null &&
            _pending.TryGetValue(envelope.CorrelationId, out var tcs))
        {
            tcs.TrySetResult(envelope);
        }
        // Future: route unsolicited messages (InspectionFault, etc.) to an event.
    }

    // ──────────────────────────────────────────────────────────
    // Response converters
    // ──────────────────────────────────────────────────────────

    private static TriggerResult ToTriggerResult(VisionEnvelope envelope)
    {
        var payload = envelope.GetPayload<TriggerAcceptedPayload>();
        return payload?.Accepted == true
            ? TriggerResult.Ok()
            : TriggerResult.Fail("Vision responded Accepted=false");
    }

    private static TriggerResult ToTriggerRejectedResult(VisionEnvelope envelope)
    {
        var payload = envelope.GetPayload<TriggerRejectedPayload>();
        return TriggerResult.Fail(
            payload?.Reason ?? "TriggerRejected",
            payload?.ErrorCode ?? -1);
    }

    private static VisionRequestResult ToVisionRequestResult(VisionEnvelope envelope)
    {
        var payload = envelope.GetPayload<InspectionResultCompletedPayload>();
        return payload?.Success == true
            ? VisionRequestResult.Ok(payload.Data)
            : VisionRequestResult.Fail("Vision responded Success=false");
    }

    // ──────────────────────────────────────────────────────────
    // Dispose
    // ──────────────────────────────────────────────────────────

    public async ValueTask DisposeAsync()
    {
        await DisconnectInternalAsync();
    }

    private async Task DisconnectInternalAsync()
    {
        if (_cts is not null)
        {
            await _cts.CancelAsync();
            _cts.Dispose();
        }

        if (_receiveLoop is not null)
        {
            try { await _receiveLoop; }
            catch { /* already cancelled */ }
        }

        _writer?.Dispose();
        _reader?.Dispose();
        _tcp?.Dispose();

        _writer = null;
        _reader = null;
        _tcp = null;
        _cts = null;
        _receiveLoop = null;
    }
}
