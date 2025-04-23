using System;
using System.Collections.Generic;
using System.Linq.Expressions;
using System.Reflection;

namespace AXOpen.Base
{
    public static class PropertyHelper
    {
        public static object? GetPropertyValue(object obj, string propertyPath)
        {
            if (obj == null)
                throw new ArgumentNullException(nameof(obj));

            if (string.IsNullOrEmpty(propertyPath))
                throw new ArgumentNullException(nameof(propertyPath));

            string[] properties = propertyPath.Split('.');
            foreach (string property in properties)
            {
                if (obj == null) return null;

                PropertyInfo propertyInfo = obj.GetType().GetProperty(property);
                if (propertyInfo == null)
                    throw new ArgumentException($"Property '{property}' not found on '{obj.GetType().Name}'");

                obj = propertyInfo.GetValue(obj, null);
            }

            return obj;
        }

        public static MemberExpression GetMemberExpression(string memberPath, Type TargetType)
        {
            if (string.IsNullOrWhiteSpace(memberPath))
                throw new ArgumentException("Member path cannot be null or empty.", nameof(memberPath));

            ParameterExpression param = Expression.Parameter(TargetType, "x");

            string[] members = memberPath.Split('.');

            Expression expression = param;
            foreach (string member in members)
            {
                MemberInfo memberInfo = expression.Type.GetProperty(member) ?? (MemberInfo)expression.Type.GetField(member);

                if (memberInfo == null)
                    throw new ArgumentException($"Member '{member}' not found in type '{expression.Type.Name}'.");

                expression = Expression.MakeMemberAccess(expression, memberInfo);
            }

            return (MemberExpression)expression;
        }

        public static MemberExpression GetMemberExpression(Expression expression)
        {
            if (expression is MemberExpression memberExpression)
            {
                return memberExpression;
            }

            if (expression is UnaryExpression unaryExpression && unaryExpression.Operand is MemberExpression operandExpression)
            {
                return operandExpression;
            }

            return null;
        }

        public static Expression GetNestedPropertyExpression(Expression parameter, string propertyName)
        {
            Expression property = parameter;
            foreach (var part in propertyName.Split('.'))
            {
                property = Expression.Property(property, part);
            }
            return property;
        }

        public static string GetPropertyPath(LambdaExpression expression)
        {
            if (expression == null)
                throw new ArgumentNullException(nameof(expression));

            var memberExpression = GetMemberExpression(expression.Body);
            if (memberExpression == null)
                throw new InvalidOperationException("Invalid expression. Could not extract member.");

            var memberNames = new List<string>();
            while (memberExpression != null)
            {
                memberNames.Insert(0, memberExpression.Member.Name);
                memberExpression = memberExpression.Expression as MemberExpression;
            }

            return string.Join(".", memberNames);
        }


        public static string GetMemberName<T>(Expression<Func<T, object>> expression)
        {
            var memberExpression = GetMemberExpression(expression.Body);

            if (memberExpression == null)
                throw new InvalidOperationException("Invalid expression");

            var memberNames = new List<string>();
            while (memberExpression != null)
            {
                memberNames.Insert(0, memberExpression.Member.Name);
                memberExpression = memberExpression.Expression as MemberExpression;
            }

            return string.Join(".", memberNames);
        }

       
    }
}
