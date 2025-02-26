namespace AXOpen.Data.Query
{
    using System;
    using System.Collections.Generic;

    public static class OperationProvider
    {
        public static Dictionary<Type, List<string>> SupportedOperations = new()
        {
            { typeof(bool), new List<string> { "==", "!=" } },
            { typeof(byte), new List<string> { "==", "!=", ">", "<", ">=", "<=", "InRange", "OutOfRange" } },
            { typeof(sbyte), new List<string> { "==", "!=", ">", "<", ">=", "<=", "InRange", "OutOfRange" } },
            { typeof(ushort), new List<string> { "==", "!=", ">", "<", ">=", "<=", "InRange", "OutOfRange" } },
            { typeof(uint), new List<string> { "==", "!=", ">", "<", ">=", "<=", "InRange", "OutOfRange" } },
            { typeof(ulong), new List<string> { "==", "!=", ">", "<", ">=", "<=", "InRange", "OutOfRange" } },
            { typeof(short), new List<string> { "==", "!=", ">", "<", ">=", "<=", "InRange", "OutOfRange" } },
            { typeof(int), new List<string> { "==", "!=", ">", "<", ">=", "<=", "InRange", "OutOfRange" } },
            { typeof(long), new List<string> { "==", "!=", ">", "<", ">=", "<=", "InRange", "OutOfRange" } },
            { typeof(float), new List<string> { "==", "!=", ">", "<", ">=", "<=", "InRange", "OutOfRange" } },
            { typeof(double), new List<string> { "==", "!=", ">", "<", ">=", "<=", "InRange", "OutOfRange" } },
            { typeof(TimeSpan), new List<string> { "==", "!=", ">", "<", ">=", "<=", "InRange", "OutOfRange" } },
            { typeof(DateTime), new List<string> { "==", "!=", ">", "<", ">=", "<=", "InRange", "OutOfRange" } },
            { typeof(DateOnly), new List<string> { "==", "!=", ">", "<", ">=", "<=", "InRange", "OutOfRange" } },
            { typeof(char), new List<string> { "!=", "==",  "Contains" } },
            { typeof(string), new List<string> {  "!=", "==", "Contains", "StartsWith", "EndsWith" } }
        };

        public static Dictionary<Type, (object Min, object Max)> TypeRanges = new()
        {
            { typeof(bool), (false, true) },
            { typeof(byte), (byte.MinValue, byte.MaxValue) },
            { typeof(sbyte), (sbyte.MinValue, sbyte.MaxValue) },
            { typeof(ushort), (ushort.MinValue, ushort.MaxValue) },
            { typeof(uint), (uint.MinValue, uint.MaxValue) },
            { typeof(ulong), (ulong.MinValue, ulong.MaxValue) },
            { typeof(short), (short.MinValue, short.MaxValue) },
            { typeof(int), (int.MinValue, int.MaxValue) },
            { typeof(long), (long.MinValue, long.MaxValue) },
            { typeof(float), (float.MinValue, float.MaxValue) },
            { typeof(double), (double.MinValue, double.MaxValue) },
            { typeof(TimeSpan), (TimeSpan.MinValue, TimeSpan.MaxValue) },
            { typeof(DateTime), (DateTime.MinValue, DateTime.MaxValue) },
            { typeof(DateOnly), (DateOnly.MinValue, DateOnly.MaxValue) },
            { typeof(char), (char.MinValue, char.MaxValue) },
            { typeof(string), ("", "") }
        };

        public static List<string> GetOperationsForType(Type type) =>
            SupportedOperations.TryGetValue(type, out var operations) ? operations : new List<string>();

        public static (object Min, object Max)? GetRangeForType(Type type) =>
            TypeRanges.TryGetValue(type, out var range) ? range : null;

        public static object? GetMinForType(Type type) =>
            TypeRanges.TryGetValue(type, out var range) ? range.Min : null;

        public static object? GetMaxForType(Type type) =>
            TypeRanges.TryGetValue(type, out var range) ? range.Max : null;
    }
}