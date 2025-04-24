using AXOpen.Base.Data.Query;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Linq.Expressions;
using System.Threading.Tasks;

namespace AXOpen.Base.Data
{
    public delegate void OnCreateDelegate<T>(string id, T data);

    public delegate void OnReadDelegate(string id);

    public delegate void OnUpdateDelegate<T>(string id, T data);

    public delegate void OnDeleteDelegate(string id);

    public delegate void OnCreateDoneDelegate<T>(string id, T data);

    public delegate void OnReadDoneDelegate<T>(string id, T data);

    public delegate void OnUpdateDoneDelegate<T>(string id, T data);

    public delegate void OnDeleteDoneDelegate(string id);

    public delegate void OnCreateFailedDelegate<T>(string id, T data, Exception ex);

    public delegate void OnReadFailedDelegate(string id, Exception ex);

    public delegate void OnUpdateFailedDelegate<T>(string id, T data, Exception ex);

    public delegate void OnDeleteFailedDelegate(string id, Exception ex);

    public delegate IEnumerable<DataItemValidation> ValidateDataDelegate<T>(T data);

    public interface IRepository
    {
        long Count { get; } // whole in repository
        long LastFragmentQueryCount { get; } // last count for fragment qeuery

        void Create(string identifier, object data);

        void Delete(string identifier);

        bool Exists(string identifier);

        long FilteredCount(string id, eSearchMode searchMode = eSearchMode.Exact);

        long FilteredCount(PredicateContainer predicates);

        dynamic Read(string identifier);

        void Update(string identifier, object data);
    }

    public interface IRepository<T> where T : IBrowsableDataObject
    {
        long Count { get; }
        IQueryable<T> Queryable { get; }

        void Create(string identifier, T data);

        void Delete(string identifier);

        bool Exists(string identifier);

        long FilteredCount(string id, eSearchMode searchMode = eSearchMode.Exact);

        long FilteredCount(PredicateContainer predicates);

        IEnumerable<T> GetRecords(
            string identifier = "*",
            int limit = 100,
            int skip = 0,
            eSearchMode searchMode = eSearchMode.Exact,
            string sortExpresion = "Default",
            bool sortAscending = false);

        IEnumerable<T> GetRecords(PredicateContainer predicates, int limit, int skip);

        IEnumerable<string> GetEntityIds(PredicateContainer predicates, List<string> Ids = null);

        IEnumerable<T> GetRecords(PredicateContainer predicates);

        IEnumerable<T> GetRecords(IEnumerable<string> identifiers, PredicateContainer sortingPredicates = null);

        T Read(string identifier);

        void Update(string identifier, T data);

        IEnumerable<TResult> CountMetric<TResult>( PredicateContainer predicates, QueryMetricContainer metric);

        OnCreateDelegate<T> OnCreate { get; set; }
        OnReadDelegate OnRead { get; set; }
        OnUpdateDelegate<T> OnUpdate { get; set; }
        OnDeleteDelegate OnDelete { get; set; }
        OnCreateDoneDelegate<T> OnCreateDone { get; set; }
        OnReadDoneDelegate<T> OnReadDone { get; set; }
        OnUpdateDoneDelegate<T> OnUpdateDone { get; set; }
        OnDeleteDoneDelegate OnDeleteDone { get; set; }
        OnCreateFailedDelegate<T> OnCreateFailed { get; set; }
        OnReadFailedDelegate OnReadFailed { get; set; }
        OnUpdateFailedDelegate<T> OnUpdateFailed { get; set; }
        OnDeleteFailedDelegate OnDeleteFailed { get; set; }
        ValidateDataDelegate<T> OnRecordUpdateValidation { get; set; }
    }
}