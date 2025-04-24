namespace AXOpen.Base.Data.Query
{
    using System;
    using System.Collections.Generic;
    using System.Linq;

    public class QueryMetricContainer
    {
        private readonly Dictionary<Type, List<QueryMetric>> _metric = new();

        public void Add<T>(QueryMetric metric)
        {
            if (!this._metric.ContainsKey(typeof(T)))
            {
                this._metric[typeof(T)] = new List<QueryMetric>();
            }

            this._metric[typeof(T)].Add(metric);
        }

        public bool ContainsType<T>()
        {
            return this._metric.ContainsKey(typeof(T));
        }

        public int Count()
        {
            return this._metric.Count;
        }

        public bool ContainsType(Type targetType)
        {
            return this._metric.ContainsKey(targetType);
        }

        public List<QueryMetric>? GetMetric<T>()
        {
            if (!_metric.ContainsKey(typeof(T)))
            {
                return null;
            }

            return _metric[typeof(T)]
                .Select(p => p)
                .ToList();
        }
    }
}