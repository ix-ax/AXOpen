namespace AXOpen.Data
{
    using System;
    using System.Linq;
    using System.Linq.Expressions;

    public class PredicateContainer
    {
        private readonly Dictionary<Type, List<LambdaExpression>> _predicates = new();

        public void AddPredicates<T>(Expression<Func<T, bool>> predicate)
        {
            if (!this._predicates.ContainsKey(typeof(T)))
            {
                this._predicates[typeof(T)] = new List<LambdaExpression>();
            }

            this._predicates[typeof(T)].Add(predicate);
        }

        public void AddPredicates<T>(IEnumerable<Expression<Func<T, bool>>> predicates)
        {
            if (!this._predicates.ContainsKey(typeof(T)))
            {
                this._predicates[typeof(T)] = new List<LambdaExpression>();
            }

            this._predicates[typeof(T)].AddRange(predicates);
        }

        public bool ContainAnyOfType<T>(T targetObject)
        {
            if (!this._predicates.ContainsKey(typeof(T)))
            {
                return true;
            }

            return false;
        }


        public List<Expression<Func<T, bool>>> GetPredicates<T>()
        {
            if (!_predicates.ContainsKey(typeof(T)))
            {
                return null;
            }

            return _predicates[typeof(T)]
                .Select(p => (Expression<Func<T, bool>>)p)
                .ToList();
        }

        public List<Expression<Func<T, bool>>> GetPredicates<T>(T pocoType)
        {
            if (!_predicates.ContainsKey(typeof(T)))
            {
                return null;
            }

            return _predicates[typeof(T)]
                .Select(p => (Expression<Func<T, bool>>)p)
                .ToList();
        }
    }
}