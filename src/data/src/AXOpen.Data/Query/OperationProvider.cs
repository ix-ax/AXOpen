namespace AXOpen.Data.Query
{
    using System;
    using System.Collections.Generic;

    public static class OperationProvider
    {
        public static Dictionary<Type, List<string>> SupportedOperations = new()
        {
            { typeof(byte), new List<string> { "==", "!=", ">", "<", ">=", "<=", "InRange", "OutOfRange" } },
            { typeof(ushort), new List<string> { "==", "!=", ">", "<", ">=", "<=", "InRange", "OutOfRange" } },
            { typeof(short), new List<string> { "==", "!=", ">", "<", ">=", "<=", "InRange", "OutOfRange" } },
            { typeof(uint), new List<string> { "==", "!=", ">", "<", ">=", "<=", "InRange", "OutOfRange" } },
            { typeof(int), new List<string> { "==", "!=", ">", "<", ">=", "<=", "InRange", "OutOfRange" } },
            { typeof(ulong), new List<string> { "==", "!=", ">", "<", ">=", "<=", "InRange", "OutOfRange" } },
            { typeof(long), new List<string> { "==", "!=", ">", "<", ">=", "<=", "InRange", "OutOfRange" } },
            { typeof(float), new List<string> { "==", "!=", ">", "<", ">=", "<=", "InRange", "OutOfRange" } },
            { typeof(double), new List<string> { "==", "!=", ">", "<", ">=", "<=", "InRange", "OutOfRange" } },
            { typeof(bool), new List<string> { "==", "!=" } },
            { typeof(string), new List<string> { "==", "!=", "Contains", "StartsWith", "EndsWith" } },
            { typeof(DateTime), new List<string> { "==", "!=", ">", "<", ">=", "<=", "InRange", "OutOfRange" } },
            { typeof(TimeSpan), new List<string> { "==", "!=", ">", "<", ">=", "<=", "InRange", "OutOfRange" } }
        };

        public static Dictionary<Type, (object Min, object Max)> TypeRanges = new()
    {
        { typeof(byte), (byte.MinValue, byte.MaxValue) },
        { typeof(ushort), (ushort.MinValue, ushort.MaxValue) },
        { typeof(short), (short.MinValue, short.MaxValue) },
        { typeof(uint), (uint.MinValue, uint.MaxValue) },
        { typeof(int), (int.MinValue, int.MaxValue) },
        { typeof(ulong), (ulong.MinValue, ulong.MaxValue) },
        { typeof(long), (long.MinValue, long.MaxValue) },
        { typeof(float), (float.MinValue, float.MaxValue) },
        { typeof(double), (double.MinValue, double.MaxValue) },
        { typeof(DateTime), (DateTime.MinValue, DateTime.MaxValue) },
        { typeof(TimeSpan), (TimeSpan.MinValue, TimeSpan.MaxValue) },
        { typeof(string), ("", "") }

    };

        public static List<string> GetOperationsForType(Type type)
        {
            return SupportedOperations.ContainsKey(type) ? SupportedOperations[type] : new List<string>();
        }

        public static (object Min, object Max)? GetRangeForType(Type type)
        {
            return TypeRanges.ContainsKey(type) ? TypeRanges[type] : null;
        }

        public static object? GetMinForType(Type type)
        {
            return TypeRanges.TryGetValue(type, out var range) ? range.Min : null;
        }

        public static object? GetMaxForType(Type type)
        {
            return TypeRanges.TryGetValue(type, out var range) ? range.Max : null;
        }

    }

}