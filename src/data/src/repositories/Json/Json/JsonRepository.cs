using System;
using System.Collections.Generic;
using System.Data.Common;
using System.IO;
using System.Linq;
using System.Linq.Expressions;
using System.Reflection;
using AXOpen.Base;
using AXOpen.Base.Data;
using AXOpen.Base.Data.Query;
using AXOpen.Data;

namespace AXOpen.Data.Json
{
    /// <summary>
    /// Provides repository for storing data in files with `Json` format.
    /// <note type="warning">
    /// This repository type is not suitable for large data collections.
    /// Use this repository for settings, recipes or data persistence with limited number of records.
    /// </note>
    /// </summary>
    /// <typeparam name="T">POCO twin type</typeparam>
    public class JsonRepository<T> : RepositoryBase<T> where T : IBrowsableDataObject
    {
        /// <summary>
        /// Creates new instance of <see cref="JsonRepository{T}"/>
        /// </summary>
        /// <param name="parameters">Repository parameters</param>
        public JsonRepository(JsonRepositorySettings<T> parameters)
        {
            Location = parameters.Location;

            if (!Directory.Exists(Location))
            {
                try
                {
                    Directory.CreateDirectory(Location);
                }
                catch (Exception)
                {
                    throw;
                }
            }
        }

        /// <summary>
        /// Get the location (directory) where the entries of this repository are placed.
        /// </summary>
        public string Location { get; private set; }
        public override long LastFragmentQueryCount { get; protected set; }

        protected override void CreateNvi(string identifier, T data)
        {
            try
            {
                if (RecordExists(identifier))
                {
                    throw new DuplicateIdException($"Record with ID '{identifier}' already exists in this collection.", null);
                }

                Save(identifier, data);
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        protected override T ReadNvi(string identifier)
        {
            try
            {
                if (!RecordExists(identifier))
                {
                    throw new UnableToLocateRecordId($"Unable to locate record with ID: '{identifier}' in '{Location}'.", null);
                }

                return this.Load(identifier, typeof(T));
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        protected override void UpdateNvi(string identifier, T data)
        {
            try
            {
                if (!RecordExists(identifier))
                {
                    throw new UnableToLocateRecordId($"Unable to locate record with ID: '{identifier}' in '{Location}'.", null);
                }

                Save(identifier.ToString(), data);
            }
            catch (Exception ex)
            {
                throw new UnableToUpdateRecord($"Unable to update record ID:{identifier} in {Location}.", ex);
            }
        }

        protected override void DeleteNvi(string identifier)
        {
            if (this.RecordExists(identifier))
            {
                File.Delete(Path.Combine(this.Location, identifier));
            }
        }

        protected override long CountNvi
        {
            get { return Directory.EnumerateFiles(Location).Count(); }
        }

        protected override IEnumerable<T> GetRecordsNvi(string identifier, int limit, int skip, eSearchMode searchMode, string sortExpresion, bool sortAscending)
        {
            IEnumerable<string> enumerable;

            if (string.IsNullOrEmpty(identifier) || string.IsNullOrWhiteSpace(identifier) || identifier == "*")
            {
                enumerable = Directory.EnumerateFiles(this.Location);
            }
            else
            {
                switch (searchMode)
                {
                    case eSearchMode.StartsWith:
                        enumerable = Directory.EnumerateFiles(this.Location).Where(p => new FileInfo(p).Name.StartsWith(identifier));
                        break;

                    case eSearchMode.Contains:
                        enumerable = Directory.EnumerateFiles(this.Location).Where(p => new FileInfo(p).Name.Contains(identifier));
                        break;

                    case eSearchMode.Exact:
                    default:
                        enumerable = Directory.EnumerateFiles(this.Location).Select(p => new FileInfo(p)).Where(p => p.Name == identifier).Select(p => p.FullName);
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

            return enumerable.Skip(skip).Take(limit).Select(x => this.Load(new FileInfo(x).Name, typeof(T)));
        }
        protected override long FilteredCountNvi(string id, eSearchMode searchMode)
        {
            if (string.IsNullOrEmpty(id) || string.IsNullOrWhiteSpace(id) || id == "*")
            {
                return Directory.EnumerateFiles(this.Location).Count();
            }
            else
            {
                switch (searchMode)
                {
                    case eSearchMode.StartsWith:
                        return Directory.EnumerateFiles(this.Location).Where(p => new FileInfo(p).Name.StartsWith(id)).Count();

                    case eSearchMode.Contains:
                        return Directory.EnumerateFiles(this.Location).Where(p => new FileInfo(p).Name.Contains(id)).Count();

                    case eSearchMode.Exact:
                    default:
                        return Directory.EnumerateFiles(this.Location).Select(p => new FileInfo(p)).Where(p => p.Name == id).Select(p => p.FullName).Count();
                }
            }
        }

        private bool RecordExists(string identifier)
        {
            if (string.IsNullOrEmpty(identifier)) return false;
            return File.Exists(Path.Combine(this.Location, identifier));
        }

        private string MakeValidFileName(string fileName)
        {
            var validName = fileName;
            foreach (char c in System.IO.Path.GetInvalidFileNameChars())
            {
                validName = validName.Replace(c, '_');
            }

            return validName;
        }

        internal void Save(string identifier, T obj)
        {
            obj.DataEntityId = MakeValidFileName(identifier);
            var path = Path.Combine(this.Location, obj.DataEntityId);

            using (var jw = new Newtonsoft.Json.JsonTextWriter(new System.IO.StreamWriter(path)))
            {
                var serializer = Newtonsoft.Json.JsonSerializer.Create(new Newtonsoft.Json.JsonSerializerSettings() { Formatting = Newtonsoft.Json.Formatting.Indented });
                serializer.Serialize(jw, obj, obj.GetType());
            }
        }

        internal T Load(string identifier, Type objtype)
        {
            var path = Path.Combine(this.Location, identifier);

            using (var jw = new Newtonsoft.Json.JsonTextReader(new System.IO.StreamReader(path)))
            {
                var serializer = Newtonsoft.Json.JsonSerializer.Create();
                return (T)serializer.Deserialize(jw, objtype);
            }
        }

        protected override bool ExistsNvi(string identifier)
        {
            return RecordExists(identifier);
        }
        public override IQueryable<T> Queryable
        {
            get { return this.GetRecords("*", int.MaxValue, 0, eSearchMode.Exact).AsQueryable(); }
        }
        protected override IEnumerable<T> GetRecordsNvi(PredicateContainer predicates, int limit, int skip)
        {
            var query = Directory.EnumerateFiles(Location)
                                 .Select(file => Load(new FileInfo(file).Name, typeof(T)))
                                 .AsQueryable();

            if (predicates != null && predicates.ContainsType<T>())
            {
                foreach (var predicate in predicates.GetPredicates<T>())
                {
                    query = query.Where(predicate);
                }
            }

            return query.Skip(skip).Take(limit).ToList();
        }

        protected override IEnumerable<T> GetRecordsNvi(IEnumerable<string> ids)
        {
            if (ids == null || !ids.Any())
                return Enumerable.Empty<T>();

            return ids.Where(RecordExists).Select(id => Load(id, typeof(T)));
        }

        protected override long FilteredCountNvi(PredicateContainer predicates)
        {
            var query = Directory.EnumerateFiles(Location)
                                 .Select(file => Load(new FileInfo(file).Name, typeof(T)))
                                 .AsQueryable();

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
            var query = Directory.EnumerateFiles(Location)
                                 .Select(file => new FileInfo(file).Name);

            if (predicates != null && predicates.ContainsType<T>())
            {
                var records = query.Select(id => new { Id = id, Data = Load(id, typeof(T)) }).ToList();
                foreach (var predicate in predicates.GetPredicates<T>())
                {
                    records = records.Where(record => predicate.Compile().Invoke(record.Data)).ToList();
                }
                return records.Select(record => record.Id);
            }

            return query;
        }


    }
}