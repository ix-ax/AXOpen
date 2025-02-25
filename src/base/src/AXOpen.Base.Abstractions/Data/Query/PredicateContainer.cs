namespace AXOpen.Base.Data.Query
{
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using System.Linq.Expressions;
    using System.Reflection.Metadata.Ecma335;

    public class PredicateContainer
    {
        private readonly Dictionary<Type, List<LambdaExpression>> _predicates = new();

        private readonly Dictionary<Type, List<SortSettings>> _sorting = new();

        public void AddSortMember<T>(MemberExpression sortingMember, bool isAscending)
        {
            var type = typeof(T);

            var settings = new SortSettings()
            {
                MemberName = sortingMember.Member.Name,
                IsAscending = isAscending
            };

            if (!_sorting.ContainsKey(type))
            {
                _sorting[type] = new List<SortSettings>() { settings };
            }

            _sorting[type].Add(settings);
        }

        public void AddSortMember<T>(MemberExpression sortingMember, bool isAscending, T pocoType)
        {
            var type = typeof(T);

            var settings = new SortSettings()
            {
                MemberName = sortingMember.Member.Name,
                IsAscending = isAscending
            };

            if (!_sorting.ContainsKey(type))
            {
                _sorting[type] = new List<SortSettings>() { settings };
            }

            _sorting[type].Add(settings);
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
                    memberExpression = SortExtension.GetMemberExpression(settings.MemberName, pocoType);
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

        public int ContainsTypeCount()
        {
            return this._predicates.Count;
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

        public List<SortSettings>? GetSorting<T>(T pocoType)
        {
            if (!_sorting.ContainsKey(typeof(T)))
            {
                return null;
            }

            return _sorting[typeof(T)].ToList();
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