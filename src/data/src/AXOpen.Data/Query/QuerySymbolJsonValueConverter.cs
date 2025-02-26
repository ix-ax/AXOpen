namespace AXOpen.Data.Query
{
    using System;
    using System.Text.Json;
    using System.Text.Json.Serialization;

    public class QuerySymbolJsonValueConverter : JsonConverter<object>
    {
        public override object Read(ref Utf8JsonReader reader, Type typeToConvert, JsonSerializerOptions options)
        {
            switch (reader.TokenType)
            {
                case JsonTokenType.Number:
                    if (reader.TryGetInt64(out long longValue)) return longValue;
                    if (reader.TryGetDouble(out double doubleValue)) return doubleValue;
                    if (reader.TryGetDecimal(out decimal decimalValue)) return decimalValue;
                    break;

                case JsonTokenType.String:
                    string stringValue = reader.GetString();

                    // Try parsing DateTime
                    if (DateTime.TryParse(stringValue, out DateTime dateTimeValue)) return dateTimeValue;

                    // Try parsing DateOnly
                    if (DateOnly.TryParse(stringValue, out DateOnly dateOnlyValue)) return dateOnlyValue;

                    // Try parsing TimeOnly
                    if (TimeOnly.TryParse(stringValue, out TimeOnly timeOnlyValue)) return timeOnlyValue;

                    // Try parsing TimeSpan
                    if (TimeSpan.TryParse(stringValue, out TimeSpan timeSpanValue)) return timeSpanValue;

                    // Try parsing char
                    if (stringValue.Length == 1) return stringValue[0];

                    return stringValue;

                case JsonTokenType.True:
                case JsonTokenType.False:
                    return reader.GetBoolean();
            }

            return JsonSerializer.Deserialize<object>(ref reader, options);
        }

        public override void Write(Utf8JsonWriter writer, object value, JsonSerializerOptions options)
        {
            switch (value)
            {
                case byte byteValue:
                    writer.WriteNumberValue(byteValue);
                    break;
                case sbyte sbyteValue:
                    writer.WriteNumberValue(sbyteValue);
                    break;
                case short shortValue:
                    writer.WriteNumberValue(shortValue);
                    break;
                case ushort ushortValue:
                    writer.WriteNumberValue(ushortValue);
                    break;
                case int intValue:
                    writer.WriteNumberValue(intValue);
                    break;
                case uint uintValue:
                    writer.WriteNumberValue(uintValue);
                    break;
                case long longValue:
                    writer.WriteNumberValue(longValue);
                    break;
                case ulong ulongValue:
                    writer.WriteNumberValue((long)ulongValue); // JSON doesn't support unsigned 64-bit, casting to long
                    break;
                case float floatValue:
                    writer.WriteNumberValue(floatValue);
                    break;
                case double doubleValue:
                    writer.WriteNumberValue(doubleValue);
                    break;
                case decimal decimalValue:
                    writer.WriteNumberValue(decimalValue);
                    break;
                case bool boolValue:
                    writer.WriteBooleanValue(boolValue);
                    break;
                case string stringValue:
                    writer.WriteStringValue(stringValue);
                    break;
                case char charValue:
                    writer.WriteStringValue(charValue.ToString());
                    break;
                case DateTime dateTimeValue:
                    writer.WriteStringValue(dateTimeValue.ToString("o")); // ISO 8601 format
                    break;
                case DateOnly dateOnlyValue:
                    writer.WriteStringValue(dateOnlyValue.ToString("yyyy-MM-dd"));
                    break;
                case TimeOnly timeOnlyValue:
                    writer.WriteStringValue(timeOnlyValue.ToString("HH:mm:ss.fffffff"));
                    break;
                case TimeSpan timeSpanValue:
                    writer.WriteStringValue(timeSpanValue.ToString("c")); // Standard TimeSpan format
                    break;
                default:
                    JsonSerializer.Serialize(writer, value, options);
                    break;
            }
        }
    }
}
