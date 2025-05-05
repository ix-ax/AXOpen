namespace AXOpen.Data
{
    using AXOpen.Data.Blazor;
    using System;
    using System.Linq.Expressions;
    using System.Collections.Generic;
    using AXOpen.Base;
    using AXOpen.Base.Data;

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
            bool clickEnabled,
            Type templateType)
        {
            var memberName = PropertyHelper.GetMemberName<T>(bindingValuePath);
            _config.Collumns.Add(new ColumnDataContent
            {
                ColumnName = columnName,
                BindingValuePath = memberName,
                ClickEnabled = clickEnabled,
                TemplateType = templateType
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
            var memberName = PropertyHelper.GetMemberName<T>(sortingExpression);
            _config.SortingExpressions.Add(memberName);
            return this;
        }

        public AxoDataExchangeColumnConfigurator<T> AddSorting(string memberExpression)
        {
            _config.SortingExpressions.Add(memberExpression);
            return this;
        }
    }
}