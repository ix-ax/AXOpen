using System.Collections;
using System.Reflection;
using System.Text.Json;

namespace AXOpen.Components.Cognex.Vision.VisionProtocol;

internal static class VisionTypedPayloadSerializer
{
    public static JsonElement SerializeToElement(object value) =>
        JsonSerializer.SerializeToElement(ToTypedNode(value, value.GetType()), VisionJsonOptions.Default);

    private static object? ToTypedNode(object? value, Type declaredType)
    {
        Type effectiveType = Nullable.GetUnderlyingType(declaredType) ?? declaredType;

        if (value is null)
        {
            return new Dictionary<string, object?>
            {
                ["type"] = GetTypeName(effectiveType),
                ["value"] = null
            };
        }

        Type runtimeType = value.GetType();

        if (IsScalar(runtimeType))
        {
            return new Dictionary<string, object?>
            {
                ["type"] = GetTypeName(runtimeType),
                ["value"] = value
            };
        }

        if (value is IEnumerable enumerable && value is not string)
        {
            var items = new List<object?>();
            foreach (var item in enumerable)
            {
                items.Add(ToTypedNode(item, item?.GetType() ?? typeof(object)));
            }

            return new Dictionary<string, object?>
            {
                ["type"] = GetTypeName(runtimeType),
                ["items"] = items
            };
        }

        var properties = runtimeType
            .GetProperties(BindingFlags.Instance | BindingFlags.Public)
            .Where(property => property.CanRead && property.GetIndexParameters().Length == 0);

        var result = new Dictionary<string, object?>
        {
            ["type"] = GetTypeName(runtimeType)
        };

        foreach (var property in properties)
        {
            object? propertyValue = property.GetValue(value);
            result[ToCamelCase(property.Name)] = ToTypedNode(propertyValue, property.PropertyType);
        }

        return result;
    }

    private static bool IsScalar(Type type)
    {
        Type effectiveType = Nullable.GetUnderlyingType(type) ?? type;

        return effectiveType.IsPrimitive
            || effectiveType.IsEnum
            || effectiveType == typeof(string)
            || effectiveType == typeof(decimal)
            || effectiveType == typeof(DateTime)
            || effectiveType == typeof(DateTimeOffset)
            || effectiveType == typeof(Guid)
            || effectiveType == typeof(TimeSpan);
    }

    private static string GetTypeName(Type type)
    {
        Type effectiveType = Nullable.GetUnderlyingType(type) ?? type;

        if (effectiveType.IsArray)
            return $"array<{GetTypeName(effectiveType.GetElementType()!)}>";

        if (effectiveType == typeof(bool))
            return "bool";
        if (effectiveType == typeof(byte))
            return "byte";
        if (effectiveType == typeof(short))
            return "int";
        if (effectiveType == typeof(ushort))
            return "uint";
        if (effectiveType == typeof(int))
            return "dint";
        if (effectiveType == typeof(uint))
            return "udint";
        if (effectiveType == typeof(long))
            return "lint";
        if (effectiveType == typeof(ulong))
            return "ulint";
        if (effectiveType == typeof(float))
            return "real";
        if (effectiveType == typeof(double))
            return "lreal";
        if (effectiveType == typeof(decimal))
            return "decimal";
        if (effectiveType == typeof(string))
            return "string";
        if (effectiveType == typeof(DateTime))
            return "datetime";
        if (effectiveType == typeof(DateTimeOffset))
            return "datetimeoffset";
        if (effectiveType == typeof(Guid))
            return "guid";
        if (effectiveType == typeof(TimeSpan))
            return "timespan";
        if (typeof(IEnumerable).IsAssignableFrom(effectiveType) && effectiveType != typeof(string))
            return "array";

        return effectiveType.Name;
    }

    private static string ToCamelCase(string value)
    {
        if (string.IsNullOrEmpty(value) || char.IsLower(value[0]))
            return value;

        if (value.Length == 1)
            return char.ToLowerInvariant(value[0]).ToString();

        return char.ToLowerInvariant(value[0]) + value[1..];
    }
}