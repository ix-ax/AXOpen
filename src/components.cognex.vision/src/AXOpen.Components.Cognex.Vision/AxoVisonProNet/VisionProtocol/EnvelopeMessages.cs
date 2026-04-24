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
    /// <summary>Part identification forwarded from PLC.</summary>
    [JsonPropertyName("partId")]
    public string? PartId { get; set; }

    /// <summary>Variant / recipe selector.</summary>
    [JsonPropertyName("variant")]
    public ushort Variant { get; set; }

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
}

/// <summary>
/// Payload attached to a <c>TriggerRejected</c> message.
/// </summary>
public sealed class TriggerRejectedPayload
{
    [JsonPropertyName("reason")]
    public string? Reason { get; set; }

    [JsonPropertyName("errorCode")]
    public int ErrorCode { get; set; }
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
    public int      ErrorCode   { get; init; }
    public string?  RejectReason { get; init; }

    public static TriggerResult Ok() =>
        new() { Accepted = true };

    public static TriggerResult Fail(string reason, int code = -1) =>
        new() { Accepted = false, RejectReason = reason, ErrorCode = code };
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

public sealed class VisionRequestResult
{
    public bool    Success     { get; init; }
    public int     ErrorCode   { get; init; }
    public string? Reason      { get; init; }
    public JsonElement? Data   { get; init; }

    public static VisionRequestResult Ok(JsonElement? data = null) =>
        new() { Success = true, Data = data };

    public static VisionRequestResult Fail(string reason, int code = -1) =>
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
// SetRecipe  (Gateway → Vision)
// ──────────────────────────────────────────────────────────────

public sealed class SetRecipeRequestPayload
{
    [JsonPropertyName("data")]
    public JsonElement? Data { get; set; }
}

public sealed class SetRecipeCompletedPayload
{
    [JsonPropertyName("success")]
    public bool Success { get; set; }
}
