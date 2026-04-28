using System.Text.Json;
using System.Text.Json.Serialization;

namespace AXOpen.Components.Cognex.Vision.VisionProtocol;

// ──────────────────────────────────────────────────────────────
// TriggerRequest  (Gateway → Vision)
// ──────────────────────────────────────────────────────────────

/// <summary>
/// Payload attached to a <c>TriggerRequest</c> message.
/// Extend with fields that match the PlcToPc data contract.
/// </summary>
public sealed class TriggerRequestPayload
{
    [JsonPropertyName("triggerid")]
    /// <summary>Trigger identification forwarded from PLC.</summary>
    public short TriggerId { get; set; }

    /// <summary>Part identification forwarded from PLC.</summary>
    [JsonPropertyName("partId")]
    public string? PartId { get; set; }

    /// <summary>Variant / recipe selector.</summary>
    [JsonPropertyName("variant")]
    public string? Variant { get; set; }

    /// <summary>Serialized specific data from the PLC twin.</summary>
    [JsonPropertyName("data")]
    public JsonElement? Data { get; set; }
}

// ──────────────────────────────────────────────────────────────
// TriggerAccepted / TriggerRejected  (Vision → Gateway)
// ──────────────────────────────────────────────────────────────

/// <summary>
/// Payload attached to a <c>TriggerAccepted</c> message.
/// </summary>
public sealed class TriggerAcceptedPayload
{
    [JsonPropertyName("accepted")]
    public bool Accepted { get; set; }

    [JsonPropertyName("triggerId")]
    public short TriggerId { get; set; }
}

/// <summary>
/// Payload attached to a <c>TriggerRejected</c> message.
/// </summary>
public sealed class TriggerRejectedPayload
{
    [JsonPropertyName("triggerId")]
    public short TriggerId { get; set; }

    [JsonPropertyName("reason")]
    public string? Reason { get; set; }

    [JsonPropertyName("errorCode")]
    public short ErrorCode { get; set; }
}

// ──────────────────────────────────────────────────────────────
// Result returned to the RemoteTask handler
// ──────────────────────────────────────────────────────────────

/// <summary>
/// Result of a <see cref="VisionTcpClient.TriggerAsync"/> call.
/// </summary>
public sealed class TriggerResult
{
    public bool     Accepted    { get; init; }
    public short    TriggerId   { get; init; }
    public short    ErrorCode   { get; init; }
    public string?  RejectReason { get; init; }

    public static TriggerResult Ok(short triggerId = 0) =>
        new() { Accepted = true, TriggerId = triggerId };

    public static TriggerResult Fail(string reason, short code = -1, short triggerId = 0) =>
        new() { Accepted = false, RejectReason = reason, ErrorCode = code, TriggerId = triggerId };
}

// ──────────────────────────────────────────────────────────────
// InspectionResult  (Gateway → Vision)
// ──────────────────────────────────────────────────────────────

public sealed class InspectionResultRequestPayload
{
    [JsonPropertyName("data")]
    public JsonElement? Data { get; set; }
}

public sealed class InspectionResultCompletedPayload
{
    [JsonPropertyName("success")]
    public bool Success { get; set; }

    [JsonPropertyName("data")]
    public JsonElement? Data { get; set; }
}

public sealed class InspectionFaultPayload
{
    [JsonPropertyName("triggerId")]
    public short TriggerId { get; set; }

    [JsonPropertyName("reason")]
    public string? Reason { get; set; }

    [JsonPropertyName("errorCode")]
    public short ErrorCode { get; set; }
}

public sealed class VisionRequestResult
{
    public bool    Success     { get; init; }
    public short     ErrorCode   { get; init; }
    public string? Reason      { get; init; }
    public JsonElement? Data   { get; init; }

    public static VisionRequestResult Ok(JsonElement? data = null) =>
        new() { Success = true, Data = data };

    public static VisionRequestResult Fail(string reason, short code = -1) =>
        new() { Success = false, Reason = reason, ErrorCode = code };
}

// ──────────────────────────────────────────────────────────────
// SendSpecificData  (Gateway → Vision)
// ──────────────────────────────────────────────────────────────

public sealed class SendSpecificDataRequestPayload
{

    [JsonPropertyName("data")]
    public JsonElement? Data { get; set; }
}

public sealed class SendSpecificDataCompletedPayload
{
    [JsonPropertyName("success")]
    public bool Success { get; set; }
}

// ──────────────────────────────────────────────────────────────
// ReceiveSpecificData  (Gateway → Vision)
// ──────────────────────────────────────────────────────────────

public sealed class ReceiveSpecificDataRequestPayload
{


    [JsonPropertyName("data")]
    public JsonElement? Data { get; set; }
}

public sealed class ReceiveSpecificDataCompletedPayload
{
    [JsonPropertyName("success")]
    public bool Success { get; set; }

    [JsonPropertyName("data")]
    public JsonElement? Data { get; set; }
}

// ──────────────────────────────────────────────────────────────
// SetRecipe  (Gateway → Vision)
// ──────────────────────────────────────────────────────────────

public sealed class SetRecipeRequestPayload
{
    /// <summary>Variant / recipe selector.</summary>
    [JsonPropertyName("variant")]
    public string? Variant { get; set; }

    [JsonPropertyName("data")]
    public JsonElement? Data { get; set; }
}

public sealed class SetRecipeCompletedPayload
{
    [JsonPropertyName("success")]
    public bool Success { get; set; }
}
