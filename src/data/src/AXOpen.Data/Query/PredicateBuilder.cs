using AXOpen.Base;
using System.Linq.Expressions;

namespace AXOpen.Data.Query
{
    public static class PredicateBuilder
    {
        public static LambdaExpression BuildLambdaPredicate(Type targetType, string propertyName, string operation, object minOrValue, object max)
        {
            // Parameter Expression (p => ...)
            var parameter = Expression.Parameter(targetType, "p");

            // Get Property Expression, supporting nested properties
            var property = PropertyHelper.GetNestedPropertyExpression(parameter, propertyName);

            if (property == null)
                throw new ArgumentException($"Property '{propertyName}' not found on type '{targetType.Name}'.");

            var underlyingType = Nullable.GetUnderlyingType(property.Type);
            var valueType = underlyingType ?? property.Type;

            // Convert value to the correct type
            var convertedMinOrValue = Convert.ChangeType(minOrValue, valueType);
            var constant = Expression.Constant(convertedMinOrValue, property.Type);

            // Create Binary Expression (p.PropertyName [operator] value)
            Expression body = operation switch
            {
                "==" => Expression.Equal(property, constant),
                "!=" => Expression.NotEqual(property, constant),
                ">" => Expression.GreaterThan(property, constant),
                ">=" => Expression.GreaterThanOrEqual(property, constant),
                "<" => Expression.LessThan(property, constant),
                "<=" => Expression.LessThanOrEqual(property, constant),
                "Contains" => Expression.Call(property, typeof(string).GetMethod("Contains", new[] { typeof(string) })!, constant),
                "StartsWith" => Expression.Call(property, typeof(string).GetMethod("StartsWith", new[] { typeof(string) })!, constant),
                "EndsWith" => Expression.Call(property, typeof(string).GetMethod("EndsWith", new[] { typeof(string) })!, constant),
                "InRange" => BuildRangeExpression(property, convertedMinOrValue, Convert.ChangeType(max, valueType)),
                "OutOfRange" => BuildOutOfRangeExpression(property, convertedMinOrValue, Convert.ChangeType(max, valueType)),
                _ => throw new NotSupportedException($"Operation '{operation}' is not supported.")
            };

            Type funcType = typeof(Func<,>).MakeGenericType(targetType, typeof(bool));
            return Expression.Lambda(funcType, body, parameter);
        }

        public static Expression BuildRangeExpression(Expression property, object min, object max)
        {
            Expression minCheck = Expression.GreaterThanOrEqual(property, Expression.Constant(min, property.Type));
            Expression maxCheck = Expression.LessThanOrEqual(property, Expression.Constant(max, property.Type));

            return Expression.AndAlso(minCheck, maxCheck);
        }

        public static Expression BuildOutOfRangeExpression(Expression property, object min, object max)
        {
            Expression minCheck = Expression.LessThanOrEqual(property, Expression.Constant(min, property.Type));
            Expression maxCheck = Expression.GreaterThanOrEqual(property, Expression.Constant(max, property.Type));

            return Expression.OrElse(minCheck, maxCheck);
        }
    }
}
