using System.Collections.Concurrent;
using System.Net.Sockets;
using System.Text;
using System.Text.Json;
using System.Threading.Channels;

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

    /// <summary>Maximum time allowed for establishing the TCP connection.</summary>
    public TimeSpan ConnectTimeout { get; init; } = TimeSpan.FromSeconds(5);

    /// <summary>How long to wait for a TriggerAccepted / TriggerRejected after sending TriggerRequest.</summary>
    public TimeSpan TriggerAcceptTimeout { get; init; }

    /// <summary>How long to wait for InspectionCompleted after sending InspectionResultRequest.</summary>
    public TimeSpan InspectionResultTimeout { get; init; }

    /// <summary>How long to wait for SendSpecificDataCompleted after sending SendSpecificDataRequest.</summary>
    public TimeSpan SendSpecificDataTimeout { get; init; }

    /// <summary>How long to wait for ReceiveSpecificDataCompleted after sending ReceiveSpecificDataRequest.</summary>
    public TimeSpan ReceiveSpecificDataTimeout { get; init; }

    /// <summary>How long to wait for SetRecipeCompleted after sending SetRecipeRequest.</summary>
    public TimeSpan SetRecipeTimeout { get; init; }

    /// <summary>How long to wait for a TriggerWithSpecificData response after sending TriggerWithSpecificDataRequest.</summary>
    public TimeSpan TriggerWithSpecificDataAcceptTimeout { get; init; }

    /// <summary>How long to attempt reconnecting before giving up one cycle.</summary>
    public TimeSpan ReconnectDelay { get; init; } = TimeSpan.FromSeconds(2);

    /// <summary>
    /// Creates a new <see cref="VisionTcpClientOptions"/> instance. The provided
    /// <paramref name="taskTimeoutMs"/> value is applied to every per-task timeout.
    /// Defaults to 5000 ms.
    /// </summary>
    /// <param name="taskTimeoutMs">Timeout (ms) applied to all per-task response waits.</param>
    public VisionTcpClientOptions(int taskTimeoutMs = 5000)
    {
        var timeout = TimeSpan.FromMilliseconds(taskTimeoutMs);

        TriggerAcceptTimeout                 = timeout;
        InspectionResultTimeout              = timeout;
        SendSpecificDataTimeout              = timeout;
        ReceiveSpecificDataTimeout           = timeout;
        SetRecipeTimeout                     = timeout;
        TriggerWithSpecificDataAcceptTimeout = timeout;
    }
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
/// per-request channels keyed by the outgoing <c>MessageId</c>.
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

    // Pending awaits: key = MessageId we sent, value = channel with one or more correlated responses.
    private readonly ConcurrentDictionary<string, Channel<VisionEnvelope>> _pending = new();
    private string? _lastInboundSummary;

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
        using var connectTimeoutCts = CancellationTokenSource.CreateLinkedTokenSource(ct);
        if (_options.ConnectTimeout > TimeSpan.Zero)
            connectTimeoutCts.CancelAfter(_options.ConnectTimeout);

        try
        {
            await _tcp.ConnectAsync(_options.Host, _options.Port, connectTimeoutCts.Token);
        }
        catch (OperationCanceledException) when (!ct.IsCancellationRequested)
        {
            throw new TimeoutException(
                $"TCP connect timed out after {_options.ConnectTimeout.TotalMilliseconds:0} ms to {_options.Host}:{_options.Port}.");
        }

        var stream = _tcp.GetStream();
        _writer = new StreamWriter(stream, Encoding.UTF8) { AutoFlush = true, NewLine = "\n" };
        _reader = new StreamReader(stream, Encoding.UTF8);

        _receiveLoop = Task.Run(() => ReceiveLoopAsync(_cts.Token), CancellationToken.None);
    }

    // ──────────────────────────────────────────────────────────
    // Trigger flow  (step 1)
    // ──────────────────────────────────────────────────────────

    /// <summary>
    /// Sends a <c>TriggerRequest</c> and awaits one of the supported trigger responses
    /// from Vision PC.
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

        // Register a response queue keyed by our own MessageId.
        // Vision echoes MessageId back as CorrelationId in its responses.
        Channel<VisionEnvelope> responseChannel = RegisterPending(envelope.MessageId);

        try
        {
            await SendAsync(envelope, ct);

            VisionEnvelope response = await ReadPendingAsync(
                responseChannel.Reader,
                _options.TriggerAcceptTimeout,
                ct);

            return response.MessageType switch
            {
                VisionEnvelope.MessageTypes.TriggerAccepted =>
                    await AwaitTriggerCompletionAfterAcceptedAsync(
                        acceptedResponse: response,
                        responseReader: responseChannel.Reader,
                        ct),

                VisionEnvelope.MessageTypes.TriggerRejected =>
                    ToTriggerRejectedResult(response),

                // Some Vision implementations send the inspection result directly
                // as a completion of the trigger request.
                VisionEnvelope.MessageTypes.InspectionCompleted =>
                    ToTriggerResultFromInspectionCompleted(response),

                VisionEnvelope.MessageTypes.InspectionFault =>
                    ToTriggerFaultResult(response),

                _ => TriggerResult.Fail(
                        $"Unexpected message type: {response.MessageType}")
            };
        }
        catch (OperationCanceledException) when (!ct.IsCancellationRequested)
        {
            // Timeout path (inner token fired, outer token is still valid)
            return TriggerResult.Fail(
                BuildTimeoutReason("TriggerAccepted/TriggerRejected/InspectionCompleted/InspectionFault", envelope.MessageId),
                -2);
        }
        finally
        {
            _pending.TryRemove(envelope.MessageId, out _);

            if (disconnectAfterRequest)
                await DisconnectInternalAsync();
        }
    }

    // ──────────────────────────────────────────────────────────
    // TriggerWithSpecificData flow
    // ──────────────────────────────────────────────────────────

    /// <summary>
    /// Sends a <c>TriggerWithSpecificDataRequest</c> and awaits one of the supported
    /// trigger responses from Vision PC. Mirrors <see cref="TriggerAsync"/> but uses
    /// the dedicated TriggerWithSpecificData message type so the Vision PC can
    /// distinguish a plain trigger from a trigger that carries specific payload data.
    /// </summary>
    /// <param name="payload">Data to forward from PLC.</param>
    /// <param name="ct">Cancellation token from the RemoteTask handler.</param>
    /// <returns>
    /// <see cref="TriggerResult.Accepted"/> is true when Vision accepted the trigger.
    /// </returns>
    public async Task<TriggerResult> TriggerWithSpecificDataAsync(
        TriggerRequestPayload payload,
        CancellationToken ct = default)
    {
        bool disconnectAfterRequest = _options.ConnectionMode == VisionConnectionMode.PerRequest;

        await ConnectAsync(ct);

        VisionEnvelope envelope = BuildEnvelope(
            VisionEnvelope.MessageTypes.TriggerWithSpecificDataRequest,
            payload,
            ackRequired: true);

        // Register a response queue keyed by our own MessageId.
        // Vision echoes MessageId back as CorrelationId in its responses.
        Channel<VisionEnvelope> responseChannel = RegisterPending(envelope.MessageId);

        try
        {
            await SendAsync(envelope, ct);

            VisionEnvelope response = await ReadPendingAsync(
                responseChannel.Reader,
                _options.TriggerWithSpecificDataAcceptTimeout,
                ct);

            return response.MessageType switch
            {
                VisionEnvelope.MessageTypes.TriggerAccepted =>
                    await AwaitTriggerCompletionAfterAcceptedAsync(
                        acceptedResponse: response,
                        responseReader: responseChannel.Reader,
                        ct),

                VisionEnvelope.MessageTypes.TriggerRejected =>
                    ToTriggerRejectedResult(response),

                // Vision may complete the trigger directly with the dedicated
                // TriggerWithSpecificDataCompleted message instead of going through
                // the InspectionCompleted path.
                VisionEnvelope.MessageTypes.TriggerWithSpecificDataCompleted =>
                    ToTriggerResultFromInspectionCompleted(response),

                // Some Vision implementations send the inspection result directly
                // as a completion of the trigger request.
                VisionEnvelope.MessageTypes.InspectionCompleted =>
                    ToTriggerResultFromInspectionCompleted(response),

                VisionEnvelope.MessageTypes.InspectionFault =>
                    ToTriggerFaultResult(response),

                _ => TriggerResult.Fail(
                        $"Unexpected message type: {response.MessageType}")
            };
        }
        catch (OperationCanceledException) when (!ct.IsCancellationRequested)
        {
            // Timeout path (inner token fired, outer token is still valid)
            return TriggerResult.Fail(
                BuildTimeoutReason("TriggerAccepted/TriggerRejected/TriggerWithSpecificDataCompleted/InspectionCompleted/InspectionFault", envelope.MessageId),
                -2);
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

        Channel<VisionEnvelope> responseChannel = RegisterPending(envelope.MessageId);

        try
        {
            await SendAsync(envelope, ct);

            VisionEnvelope response = await ReadPendingAsync(
                responseChannel.Reader,
                _options.InspectionResultTimeout,
                ct);

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
            return VisionRequestResult.Fail(
                BuildTimeoutReason("InspectionCompleted", envelope.MessageId),
                -2);
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
        return await SendSpecificDataCoreAsync(
            payload,
            VisionEnvelope.MessageTypes.SendSpecificDataRequest,
            VisionEnvelope.MessageTypes.SendSpecificDataCompleted,
            ct);
    }

    public async Task<VisionRequestResult> SendSpecificDataTypesAsync(
        SendSpecificDataRequestPayload payload,
        CancellationToken ct = default)
    {
        return await SendSpecificDataCoreAsync(
            payload,
            VisionEnvelope.MessageTypes.SendSpecificDataTypesRequest,
            VisionEnvelope.MessageTypes.SendSpecificDataTypesCompleted,
            ct);
    }

    private async Task<VisionRequestResult> SendSpecificDataCoreAsync(
        SendSpecificDataRequestPayload payload,
        string requestMessageType,
        string completedMessageType,
        CancellationToken ct = default)
    {
        bool disconnectAfterRequest = _options.ConnectionMode == VisionConnectionMode.PerRequest;

        await ConnectAsync(ct);

        VisionEnvelope envelope = BuildEnvelope(
            requestMessageType,
            payload,
            ackRequired: true);

        Channel<VisionEnvelope> responseChannel = RegisterPending(envelope.MessageId);

        try
        {
            await SendAsync(envelope, ct);

            VisionEnvelope response = await ReadPendingAsync(
                responseChannel.Reader,
                _options.SendSpecificDataTimeout,
                ct);

            return response.MessageType switch
            {
                _ when response.MessageType == completedMessageType =>
                    ToVisionRequestResult(response),

                _ => VisionRequestResult.Fail(
                        $"Unexpected message type: {response.MessageType}")
            };
        }
        catch (OperationCanceledException) when (!ct.IsCancellationRequested)
        {
            return VisionRequestResult.Fail(
                BuildTimeoutReason(completedMessageType, envelope.MessageId),
                -2);
        }
        finally
        {
            _pending.TryRemove(envelope.MessageId, out _);

            if (disconnectAfterRequest)
                await DisconnectInternalAsync();
        }
    }

    // ──────────────────────────────────────────────────────────
    // ReceiveSpecificData flow
    // ──────────────────────────────────────────────────────────

    public async Task<VisionRequestResult> ReceiveSpecificDataAsync(
        ReceiveSpecificDataRequestPayload payload,
        CancellationToken ct = default)
    {
        bool disconnectAfterRequest = _options.ConnectionMode == VisionConnectionMode.PerRequest;

        await ConnectAsync(ct);

        VisionEnvelope envelope = BuildEnvelope(
            VisionEnvelope.MessageTypes.ReceiveSpecificDataRequest,
            payload,
            ackRequired: true);

        Channel<VisionEnvelope> responseChannel = RegisterPending(envelope.MessageId);

        try
        {
            await SendAsync(envelope, ct);

            VisionEnvelope response = await ReadPendingAsync(
                responseChannel.Reader,
                _options.ReceiveSpecificDataTimeout,
                ct);

            return response.MessageType switch
            {
                VisionEnvelope.MessageTypes.ReceiveSpecificDataCompleted =>
                    ToVisionRequestResult(response),

                _ => VisionRequestResult.Fail(
                        $"Unexpected message type: {response.MessageType}")
            };
        }
        catch (OperationCanceledException) when (!ct.IsCancellationRequested)
        {
            return VisionRequestResult.Fail(
                BuildTimeoutReason("ReceiveSpecificDataCompleted", envelope.MessageId),
                -2);
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

        Channel<VisionEnvelope> responseChannel = RegisterPending(envelope.MessageId);

        try
        {
            await SendAsync(envelope, ct);

            VisionEnvelope response = await ReadPendingAsync(
                responseChannel.Reader,
                _options.SetRecipeTimeout,
                ct);

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
            return VisionRequestResult.Fail(
                BuildTimeoutReason("SetRecipeCompleted", envelope.MessageId),
                -2);
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

    private Channel<VisionEnvelope> RegisterPending(string messageId)
    {
        var channel = Channel.CreateUnbounded<VisionEnvelope>(new UnboundedChannelOptions
        {
            SingleReader = true,
            SingleWriter = false
        });

        _pending[messageId] = channel;
        return channel;
    }

    private static async Task<VisionEnvelope> ReadPendingAsync(
        ChannelReader<VisionEnvelope> responseReader,
        TimeSpan timeout,
        CancellationToken ct)
    {
        using var timeoutCts = CancellationTokenSource.CreateLinkedTokenSource(ct);
        timeoutCts.CancelAfter(timeout);
        return await responseReader.ReadAsync(timeoutCts.Token);
    }

    private async Task<TriggerResult> AwaitTriggerCompletionAfterAcceptedAsync(
        VisionEnvelope acceptedResponse,
        ChannelReader<VisionEnvelope> responseReader,
        CancellationToken ct)
    {
        TriggerResult accepted = ToTriggerResult(acceptedResponse);
        if (!accepted.Accepted)
            return accepted;

        // If inspection completion follows TriggerAccepted on the same correlation,
        // consume it here so one TriggerAsync call handles both messages.
        try
        {
            VisionEnvelope followUp = await ReadPendingAsync(
                responseReader,
                _options.InspectionResultTimeout,
                ct);

            return followUp.MessageType switch
            {
                VisionEnvelope.MessageTypes.InspectionCompleted =>
                    ToTriggerResultFromInspectionCompleted(followUp),

                VisionEnvelope.MessageTypes.InspectionFault =>
                    ToTriggerFaultResult(followUp),

                // Duplicate or out-of-order ack. Keep the accepted result.
                VisionEnvelope.MessageTypes.TriggerAccepted => accepted,

                VisionEnvelope.MessageTypes.TriggerRejected =>
                    ToTriggerRejectedResult(followUp),

                _ => TriggerResult.Fail(
                        $"Unexpected follow-up message type: {followUp.MessageType}")
            };
        }
        catch (OperationCanceledException) when (!ct.IsCancellationRequested)
        {
            // Keep backward compatibility: accepted trigger is still considered success
            // when no follow-up frame arrives within completion timeout.
            return accepted;
        }
    }

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
                {
                    _lastInboundSummary =
                        $"type={envelope.MessageType}, corr={envelope.CorrelationId ?? "<null>"}, msg={envelope.MessageId}";
                    Dispatch(envelope);
                }
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
        // Primary path: Vision echoes request MessageId as CorrelationId.
        if (!string.IsNullOrWhiteSpace(envelope.CorrelationId) &&
            _pending.TryGetValue(envelope.CorrelationId, out var responseChannel))
        {
            responseChannel.Writer.TryWrite(envelope);
            return;
        }

        // Compatibility fallback: some servers mirror the request id in MessageId
        // and omit CorrelationId entirely.
        if (!string.IsNullOrWhiteSpace(envelope.MessageId) &&
            _pending.TryGetValue(envelope.MessageId, out responseChannel))
        {
            responseChannel.Writer.TryWrite(envelope);
            return;
        }

        // Last-resort compatibility: if there is exactly one pending request,
        // complete it with the inbound response even if IDs are not correlated.
        // This helps interop with simple servers that omit correlation metadata.
        if (_pending.Count == 1)
        {
            foreach (var pending in _pending)
            {
                pending.Value.Writer.TryWrite(envelope);
                return;
            }
        }

        // Unmatched responses are ignored by design (unsolicited messages/events).
        // Future: route unsolicited messages (InspectionFault, etc.) to an event.
    }

    private string BuildTimeoutReason(string expectedResponseType, string requestMessageId)
    {
        return $"{expectedResponseType} not received within timeout. requestMessageId={requestMessageId}, pending={_pending.Count}, lastInbound={_lastInboundSummary ?? "<none>"}";
    }

    // ──────────────────────────────────────────────────────────
    // Response converters
    // ──────────────────────────────────────────────────────────

    private static TriggerResult ToTriggerResult(VisionEnvelope envelope)
    {
        var payload = envelope.GetPayload<TriggerAcceptedPayload>();
        return payload?.Accepted == true
            ? TriggerResult.Ok(payload?.TriggerId ?? 0)
            : TriggerResult.Fail("Vision responded Accepted=false");
    }

    private static TriggerResult ToTriggerRejectedResult(VisionEnvelope envelope)
    {
        var payload = envelope.GetPayload<TriggerRejectedPayload>();
        return TriggerResult.Fail(
            payload?.Reason ?? "TriggerRejected",
            payload?.ErrorCode ?? -1,
            payload?.TriggerId ?? 0);
    }

    private static TriggerResult ToTriggerResultFromInspectionCompleted(VisionEnvelope envelope)
    {
        var payload = envelope.GetPayload<InspectionResultCompletedPayload>();

        // Treat completion without explicit success flag as successful completion.
        if (payload.Success)
            return TriggerResult.Ok(payload.TriggerId,payload.Data);

        return TriggerResult.Fail("InspectionCompleted with Success=false");
    }

    private static TriggerResult ToTriggerFaultResult(VisionEnvelope envelope)
    {
        var payload = envelope.GetPayload<InspectionFaultPayload>();
        return TriggerResult.Fail(
            payload?.Reason ?? "InspectionFault",
            payload?.ErrorCode ?? -1,
            payload?.TriggerId ?? 0);
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
