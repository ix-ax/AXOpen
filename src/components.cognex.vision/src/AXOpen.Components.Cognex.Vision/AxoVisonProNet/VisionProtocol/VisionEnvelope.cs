using System.Text.Json;
using System.Text.Json.Serialization;

namespace AXOpen.Components.Cognex.Vision.VisionProtocol;

/// <summary>
/// Common JSON envelope for every runtime message exchanged between
/// the PLC PC Gateway (client) and the Vision PC (server).
/// </summary>
public sealed class VisionEnvelope
{
    [JsonPropertyName("protocolVersion")]
    public int ProtocolVersion { get; set; } = 1;

    [JsonPropertyName("schemaVersion")]
    public string SchemaVersion { get; set; } = "1.0.0";

    [JsonPropertyName("messageType")]
    public string MessageType { get; set; } = string.Empty;

    [JsonPropertyName("messageId")]
    public string MessageId { get; set; } = Guid.NewGuid().ToString();

    [JsonPropertyName("correlationId")]
    public string? CorrelationId { get; set; }

    /// <summary>
    /// Full twin symbol of the AxoVisionProNet component instance (e.g. "Ctx.VisionStation1.Inspection1").
    /// Used by the Vision PC server to route the message to the correct handler.
    /// </summary>
    [JsonPropertyName("componentSymbol")]
    public string ComponentSymbol { get; set; } = string.Empty;

    [JsonPropertyName("sequenceNumber")]
    public long SequenceNumber { get; set; }

    [JsonPropertyName("timestampUtc")]
    public DateTime TimestampUtc { get; set; } = DateTime.UtcNow;

    [JsonPropertyName("ackRequired")]
    public bool AckRequired { get; set; }

    /// <summary>
    /// Raw JSON payload — deserialized on demand into a typed payload class.
    /// </summary>
    [JsonPropertyName("payload")]
    public JsonElement? Payload { get; set; }

    /// <summary>
    /// Deserializes the payload into a strongly-typed object.
    /// </summary>
    public T? GetPayload<T>() =>
        Payload.HasValue
            ? Payload.Value.Deserialize<T>(VisionJsonOptions.Default)
            : default;

    /// <summary>
    /// Well-known message type name constants.
    /// </summary>
    public static class MessageTypes
    {
        public const string TriggerRequest         = "TriggerRequest";
        public const string TriggerAccepted        = "TriggerAccepted";
        public const string TriggerRejected        = "TriggerRejected";
        public const string InspectionResultRequest= "InspectionResultRequest";
        public const string InspectionCompleted         = "InspectionCompleted";
        public const string InspectionFault             = "InspectionFault";
        public const string SendSpecificDataRequest     = "SendSpecificDataRequest";
        public const string SendSpecificDataCompleted   = "SendSpecificDataCompleted";
        public const string SendSpecificDataTypesRequest   = "SendSpecificDataTypesRequest";
        public const string SendSpecificDataTypesCompleted = "SendSpecificDataTypesCompleted";
        public const string ReceiveSpecificDataRequest  = "ReceiveSpecificDataRequest";
        public const string ReceiveSpecificDataCompleted= "ReceiveSpecificDataCompleted";
        public const string SetRecipeRequest           = "SetRecipeRequest";
        public const string SetRecipeCompleted         = "SetRecipeCompleted";
        public const string TriggerWithSpecificDataRequest   = "TriggerWithSpecificDataRequest";
        public const string TriggerWithSpecificDataCompleted = "TriggerWithSpecificDataCompleted";
      
    }
}

/// <summary>
/// Shared JSON serializer options used across all protocol serialization.
/// </summary>
public static class VisionJsonOptions
{
    public static readonly JsonSerializerOptions Default = new()
    {
        PropertyNamingPolicy         = JsonNamingPolicy.CamelCase,
        WriteIndented                = false,
        DefaultIgnoreCondition       = JsonIgnoreCondition.WhenWritingNull,
        Converters =
        {
            new ByteArrayAsNumberArrayConverter()
        }
    };
}

internal sealed class ByteArrayAsNumberArrayConverter : JsonConverter<byte[]>
{
    public override byte[]? Read(ref Utf8JsonReader reader, Type typeToConvert, JsonSerializerOptions options)
    {
        if (reader.TokenType == JsonTokenType.Null)
        {
            return null;
        }

        if (reader.TokenType == JsonTokenType.String)
        {
            string? base64 = reader.GetString();
            return string.IsNullOrEmpty(base64) ? Array.Empty<byte>() : Convert.FromBase64String(base64);
        }

        if (reader.TokenType != JsonTokenType.StartArray)
        {
            throw new JsonException("Expected byte array as JSON array or Base64 string.");
        }

        var bytes = new List<byte>();
        while (reader.Read())
        {
            if (reader.TokenType == JsonTokenType.EndArray)
            {
                return bytes.ToArray();
            }

            if (reader.TokenType != JsonTokenType.Number || !reader.TryGetByte(out byte value))
            {
                throw new JsonException("Byte array item must be a number in range 0-255.");
            }

            bytes.Add(value);
        }

        throw new JsonException("Unexpected end while reading byte array.");
    }

    public override void Write(Utf8JsonWriter writer, byte[] value, JsonSerializerOptions options)
    {
        writer.WriteStartArray();

        foreach (byte item in value)
        {
            writer.WriteNumberValue(item);
        }

        writer.WriteEndArray();
    }
}
