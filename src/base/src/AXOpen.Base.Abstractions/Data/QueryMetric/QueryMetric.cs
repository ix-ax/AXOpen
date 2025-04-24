namespace AXOpen.Base.Data.Query
{
    using System.Linq;
    using System;
    using System.Linq.Expressions;
    using System.Runtime.InteropServices;

    public class QueryMetric
    {
        public Type TypeSource { get; private set; }
        public Type TypeGroupKey { get; private set; }
        public Type TypeResult { get; private set; }

        public LambdaExpression GroupExpression { get; private set; }
        public LambdaExpression SelectorExpression { get; private set; }

        public void AddAggregation<TSource, TGroupKey, TResult>(
             Expression<Func<TSource, TGroupKey>> groupBy,
             Expression<Func<IGrouping<TGroupKey, TSource>, TResult>> resultSelector)
        {
            TypeSource = typeof(TSource);
            TypeGroupKey = typeof(TGroupKey);
            TypeResult = typeof(TResult);

            GroupExpression = groupBy;
            SelectorExpression = resultSelector;
        }
    }

}