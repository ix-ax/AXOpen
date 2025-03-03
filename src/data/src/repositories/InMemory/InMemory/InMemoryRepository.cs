using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Linq.Expressions;
using AXOpen.Base;
using AXOpen.Base.Data;
using AXOpen.Base.Data.Query;

namespace AXOpen.Data.InMemory
{
    /// <summary>
    /// Provides in memory data repository.
    /// <note type="important">
    /// The data in this repository persist only during the run of the application.
    /// </note>
    /// </summary>
    /// <typeparam name="T">POCO twin type</typeparam>
    public class InMemoryRepository<T> : RepositoryBase<T> where T : IBrowsableDataObject
    {
        /// <summary>
        /// Creates new instance of <see cref="InMemoryRepository{T}"/>
        /// </summary>
        /// <param name="parameters">Repository settings</param>
        public InMemoryRepository(InMemoryRepositorySettings<T> parameters)
        {
        }

        /// <summary>
        /// Creates new instance of <see cref="InMemoryRepository{T}"/>
        /// </summary>
        public InMemoryRepository()
        {
        }

        private readonly Dictionary<string, T> _repository = new Dictionary<string, T>();

        internal Dictionary<string, T> Records
        {
            get { return this._repository; }
        }
        public override long LastFragmentQueryCount { get; protected set; }

        protected override void CreateNvi(string identifier, T data)
        {
            try
            {
                if (_repository.Any(p => p.Value.Equals(data)))
                {
                    throw new SameObjectReferenceException($"InMemory repository cannot contain two object with the same reference. You must create as new instance of '{nameof(T)}'");
                }

                _repository.Add(identifier, data);
            }
            catch (ArgumentException argumentException)
            {
                throw new DuplicateIdException($"Record with ID '{identifier}' already exists in this collection.", argumentException);
            }
        }

        protected override T ReadNvi(string identifier)
        {
            try
            {
                return this._repository[identifier];
            }
            catch (Exception ex)
            {
                throw new UnableToLocateRecordId($"Unable to locate record with ID: {identifier} in {this.GetType()}.", ex);
            }
        }

        protected override void UpdateNvi(string identifier, T data)
        {
            try
            {
                if (data == null)
                {
                    throw new Exception("Data object cannot be 'null'");
                }

                var record = _repository.First(p => p.Key == identifier);
                this._repository[identifier] = data;
            }
            catch (Exception ex)
            {
                throw new UnableToUpdateRecord($"Unable to update record ID:{identifier} in {this.GetType()}.", ex);
            }
        }

        protected override void DeleteNvi(string identifier)
        {
            this._repository.Remove(identifier);
        }

        protected override long CountNvi
        {
            get { return this._repository.Count; }
        }

        protected override IEnumerable<T> GetRecordsNvi(string identifier, int limit, int skip, eSearchMode searchMode, string sortExpresion, bool sortAscending)
        {
            IEnumerable<KeyValuePair<string, T>> enumerable;

            if (string.IsNullOrEmpty(identifier) || string.IsNullOrWhiteSpace(identifier) || identifier == "*")
            {
                enumerable = this.Records;
            }
            else
            {
                switch (searchMode)
                {
                    case eSearchMode.StartsWith:
                        enumerable = this.Records.Where(p => p.Key.StartsWith(identifier));
                        break;

                    case eSearchMode.Contains:
                        enumerable = this.Records.Where(p => p.Key.Contains(identifier));
                        break;

                    case eSearchMode.Exact:
                    default:
                        enumerable = this.Records.Where(p => p.Key == identifier);
                        break;
                }
            }

            if (sortExpresion == null || string.IsNullOrWhiteSpace(sortExpresion) || sortExpresion.Equals("Default"))
            {
                if (!sortAscending)
                    enumerable = enumerable.Reverse();
            }
            else
            {
                if (sortAscending)
                    enumerable = enumerable.OrderBy(x => PropertyHelper.GetPropertyValue(x, sortExpresion));
                else
                    enumerable = enumerable.OrderByDescending(x => PropertyHelper.GetPropertyValue(x, sortExpresion));
            }

            return enumerable.Skip(skip).Take(limit).Select(x => x.Value);
        }

        protected override long FilteredCountNvi(string id, eSearchMode searchMode)
        {
            if (string.IsNullOrEmpty(id) || string.IsNullOrWhiteSpace(id) || id == "*")
            {
                return this.Records.Select(p => true).Count();
            }
            else
            {
                switch (searchMode)
                {
                    case eSearchMode.StartsWith:
                        return this.Records.Where(p => p.Key.StartsWith(id)).LongCount();

                    case eSearchMode.Contains:
                        return this.Records.Where(p => p.Key.Contains(id)).LongCount();

                    case eSearchMode.Exact:
                    default:
                        return this.Records.Where(p => p.Key == id).LongCount();
                }
            }
        }

        protected override bool ExistsNvi(string identifier)
        {
            return this.Records.Any(p => p.Key == identifier);
        }

        public override IQueryable<T> Queryable
        { get { return this._repository.AsQueryable().Select(p => p.Value); } }


        protected override IEnumerable<T> GetRecordsNvi(IEnumerable<string> ids)
        {
            if (ids == null || !ids.Any())
                return Enumerable.Empty<T>();

            return _repository.Where(p => ids.Contains(p.Key)).Select(p => p.Value);
        }
        protected override IEnumerable<T> GetRecordsNvi(PredicateContainer predicates, int limit, int skip)
        {
            var query = _repository.Values.AsQueryable();

            if (predicates != null && predicates.ContainsType<T>())
            {
                foreach (var predicate in predicates.GetPredicates<T>())
                {
                    query = query.Where(predicate);
                }
            }

            return query.Skip(skip).Take(limit).ToList();
        }


        protected override long FilteredCountNvi(PredicateContainer predicates)
        {
            var query = _repository.Values.AsQueryable();

            if (predicates != null && predicates.ContainsType<T>())
            {
                foreach (var predicate in predicates.GetPredicates<T>())
                {
                    query = query.Where(predicate);
                }
            }

            return query.LongCount();
        }

        protected override IEnumerable<string> GetEntityIdsNvi(PredicateContainer predicates)
        {
            var query = _repository.AsQueryable();

            if (predicates != null && predicates.ContainsType<T>())
            {
                foreach (var predicate in predicates.GetPredicates<T>())
                {
                    query = query.Where(p => predicate.Compile().Invoke(p.Value));
                }
            }

            return query.Select(p => p.Key).ToList();
        }


    }
}