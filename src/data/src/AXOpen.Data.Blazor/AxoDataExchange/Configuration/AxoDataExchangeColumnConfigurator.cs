namespace AXOpen.Data
{
    using AXOpen.Data.Blazor;
    using System;
    using System.Linq.Expressions;
    using System.Collections.Generic;

    public class AxoDataExchangeColumnConfigurator<T>
    {
        private readonly AxoDataExchangeConfiguration _config;

        public AxoDataExchangeColumnConfigurator(AxoDataExchangeConfiguration config)
        {
            _config = config;
        }

        public AxoDataExchangeColumnConfigurator<T> AddColumn(
            string columnName,
            Expression<Func<T, object>> bindingValuePath,
            bool clickEnabled = false)
        {
            var memberName = GetMemberName(bindingValuePath);
            _config.Collumns.Add(new ColumnDataContent
            {
                ColumnName = columnName,
                BindingValuePath = memberName,
                ClickEnabled = clickEnabled
            });

            return this;
        }

        public AxoDataExchangeColumnConfigurator<T> EnableSorting()
        {
            _config.EnableSorting = true;
            return this;
        }

        public AxoDataExchangeColumnConfigurator<T> AddSorting(Expression<Func<T, object>> sortingExpression)
        {
            var memberName = GetMemberName(sortingExpression);
            _config.SortingExpressions.Add(memberName);
            return this;
        }

        public AxoDataExchangeColumnConfigurator<T> AddSorting(string memberExpression)
        {
            _config.SortingExpressions.Add(memberExpression);
            return this;
        }

        private string GetMemberName(Expression<Func<T, object>> expression)
        {
            var memberExpression = this.GetMemberExpression(expression.Body);

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

        private MemberExpression GetMemberExpression(Expression expression)
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
    }
}
