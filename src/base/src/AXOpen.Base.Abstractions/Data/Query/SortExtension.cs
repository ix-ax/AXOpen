namespace AXOpen.Base.Data.Query
{
    using System;
    using System.Linq.Expressions;
    using System.Reflection;

    public static class SortExtension
    {
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
    }
}