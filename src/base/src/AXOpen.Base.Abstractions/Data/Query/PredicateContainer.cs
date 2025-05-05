namespace AXOpen.Base.Data.Query
{
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using System.Linq.Expressions;

    public class PredicateContainer
    {
        private readonly Dictionary<Type, List<LambdaExpression>> _predicates = new();

        private readonly Dictionary<Type, List<SortSettings>> _sorting = new();

        public void AddPredicatesFrom(PredicateContainer newPredicates)
        {
            foreach (var predicatelist in newPredicates._predicates)
            {
                if (!this._predicates.ContainsKey(predicatelist.Key))
                {
                    this._predicates[predicatelist.Key] = new List<LambdaExpression>();
                }

                this._predicates[predicatelist.Key].AddRange(predicatelist.Value);
            }

            foreach (var sortList in newPredicates._sorting)
            {
                if (!this._sorting.ContainsKey(sortList.Key))
                {
                    this._sorting[sortList.Key] = new List<SortSettings>();
                }

                this._sorting[sortList.Key].AddRange(sortList.Value);
            }
        }

        public void AddSortMember<T>(Expression<Func<T, object>> sortingMember, bool isAscending)
        {
            var type = typeof(T);

            // Extract property name from expression
            if (sortingMember.Body is MemberExpression memberExpression)
            {
                var settings = new SortSettings
                {
                    MemberName = memberExpression.Member.Name,
                    IsAscending = isAscending
                };

                if (!_sorting.ContainsKey(type))
                {
                    _sorting[type] = new List<SortSettings>();
                }

                _sorting[type].Add(settings);
            }
            else
            {
                throw new ArgumentException("Invalid sorting member expression.");
            }
        }

        public void AddSortMember<T>(Expression<Func<T, object>> sortingMember, bool isAscending, T pocoInstance)
        {
            var type = typeof(T);

            if (sortingMember.Body is MemberExpression memberExpression)
            {
                var settings = new SortSettings()
                {
                    MemberName = memberExpression.Member.Name,
                    IsAscending = isAscending
                };

                if (!_sorting.ContainsKey(type))
                {
                    _sorting[type] = new List<SortSettings>() { settings };
                }

                _sorting[type].Add(settings);
            }
            else
            {
                throw new ArgumentException("Invalid sorting member expression.");
            }
        }

        public void AddSortMember(SortSettings settings, Type pocoType)
        {
            if (string.IsNullOrEmpty(settings.MemberName))
            {
                settings.MemberName = ""; // natural sorting
            }
            else
            { // case of any member
                MemberExpression memberExpression = null;

                try
                {
                    memberExpression = PropertyHelper.GetMemberExpression(settings.MemberName, pocoType);
                }
                catch (Exception ex)
                {
                    //skip invalid member
                }

                if (memberExpression == null) { return; }
            }

            if (!_sorting.ContainsKey(pocoType))
            {
                _sorting[pocoType] = new List<SortSettings>();
            }

            _sorting[pocoType].Add(settings);
        }

        public void AddPredicates<T>(Expression<Func<T, bool>> predicate)
        {
            if (!this._predicates.ContainsKey(typeof(T)))
            {
                this._predicates[typeof(T)] = new List<LambdaExpression>();
            }

            this._predicates[typeof(T)].Add(predicate);
        }

        public void AddPredicates(Type type, LambdaExpression predicate)
        {
            if (!this._predicates.ContainsKey(type))
            {
                this._predicates[type] = new List<LambdaExpression>();
            }

            this._predicates[type].Add(predicate);
        }

        public void AddPredicates<T>(IEnumerable<Expression<Func<T, bool>>> predicates)
        {
            if (!this._predicates.ContainsKey(typeof(T)))
            {
                this._predicates[typeof(T)] = new List<LambdaExpression>();
            }

            this._predicates[typeof(T)].AddRange(predicates);
        }

        public bool ContainsType<T>()
        {
            return this._predicates.ContainsKey(typeof(T));
        }

        public int PredicatesCount()
        {
            return this._predicates.Count;
        }

        public int SortingCount()
        {
            return this._sorting.Count;
        }

        public bool ContainsType(Type targetType)
        {
            return this._predicates.ContainsKey(targetType);
        }

        public List<SortSettings>? GetSorting<T>()
        {
            if (!_sorting.ContainsKey(typeof(T)))
            {
                return null;
            }

            return _sorting[typeof(T)].ToList();
        }

        public List<SortSettings>? GetSorting(Type pocoType)
        {
            if (!_sorting.ContainsKey(pocoType))
            {
                return null;
            }

            return _sorting[pocoType].ToList();
        }

        public List<SortSettings>? GetSorting<T>(T pocoInstance)
        {
            if (!_sorting.ContainsKey(typeof(T)))
            {
                return null;
            }

            return _sorting[typeof(T)].ToList();
        }

        public List<Expression<Func<T, bool>>>? GetPredicates<T>()
        {
            if (!_predicates.ContainsKey(typeof(T)))
            {
                return null;
            }

            return _predicates[typeof(T)]
                .Select(p => (Expression<Func<T, bool>>)p)
                .ToList();
        }

        public List<LambdaExpression>? GetPredicates(Type pocoType)
        {
            if (!_predicates.ContainsKey(pocoType))
            {
                return null;
            }

            return _predicates[pocoType].ToList();
        }
    }
}