using System;
using System.Linq;
using System.Reflection;
using System.Reflection.Metadata.Ecma335;
using AXOpen.Data;
using AXSharp.Connector;
using AXOpen.Base.Data;


namespace AXOpen.Data
{
    public partial class AxoDataExchange
    {
        /// <summary>An interaface which grants access to certain operations in DataExchange viewmodel, like searching by id, invoking search or filling the searchbox</summary>
        public IDataExchangeOperations DataExchangeOperations { get; set; }

        private dynamic _onliner;

        public T GetData<T>() where T : class 
        {
            return (T)this.Onliner;
        }

        public ITwinObject Data
        {
            get { return (ITwinObject)this.Onliner; }
        }


        public PropertyInfo? GetDataSetPropertyInfo()
        {
            var properties = this.GetType().GetProperties();
            PropertyInfo? DataPropertyInfo = null;

            // iterate properties and look for AxoDataEntityAttribute
            foreach (var prop in properties)
            {
                var attr = prop.GetCustomAttribute<AxoDataEntityAttribute>();
                if (attr != null)
                {
                    //if already set, that means multiple dataatributtes are present, we want to throw error
                    if (DataPropertyInfo != null)
                    {
                        throw new MultipleDataEntityAttributeException($"{this.GetType().ToString()} contains multiple {nameof(AxoDataEntityAttribute)}s! Make sure it contains only one.");
                    }
                    DataPropertyInfo = prop;
                    break;
                }
            }

            if (DataPropertyInfo == null)
            {
                throw new Exception($"There is no member annotated with '{nameof(AxoDataEntityAttribute)}' in '{this.Symbol}'.");
            }

            return DataPropertyInfo;
        }

        public ICrudDataObject? GetDataSetProperty()
        {
            var dataObjectPropertyInfo = this.GetDataSetPropertyInfo();
            var dataObject = dataObjectPropertyInfo?.GetValue(this) as AXOpen.Data.AxoDataEntity;
            if (dataObject == null)
            {
                throw new Exception($"Data member annotated with '{nameof(AxoDataEntityAttribute)}' in '{this.Symbol}'  does not inherit from '{nameof(AxoDataEntity)}'");
            }

            return dataObject;
        }

        protected ICrudDataObject Onliner
        {
            get
            {
                if (this._onliner == null)
                {
                    this._onliner = GetDataSetProperty();
                }

                return this._onliner;
            }
        }

        private IRepository _repository;

        public IRepository<T> GetRepository<T>() where T : IBrowsableDataObject
            => _repository as IRepository<T>;

        public IRepository GetRepository() => _repository ??
            throw new RepositoryNotInitializedException($"Repository '{Symbol}' is not initialized. You must initialize repository by calling " +
                $"'{nameof(InitializeRepository)}' method with respective parameters.");

        public void InitializeRepository(IRepository repository) 
            => _repository = repository;

        public void InitializeRepository<T>(IRepository<T> repository) where T : IBrowsableDataObject
            => _repository = repository as IRepository;


        public void InitializeRemoteDataExchange()
        {
            CreateTask.InitializeExclusively(Create);
            ReadTask.InitializeExclusively(Read);
            UpdateTask.InitializeExclusively(Update);
            DeleteTask.InitializeExclusively(Delete);
            this.WriteAsync().Wait();
            //_idExistsTask.InitializeExclusively(Exists);
            //_createOrUpdateTask.Initialize(CreateOrUpdate);
        }

        public void DeInitializeRemoteDataExchange()
        {
            CreateTask.DeInitialize();
            ReadTask.DeInitialize();
            UpdateTask.DeInitialize();
            DeleteTask.DeInitialize();
            this.WriteAsync().Wait();
            //_idExistsTask.InitializeExclusively(Exists);
            //_createOrUpdateTask.Initialize(CreateOrUpdate);
        }

        public void InitializeRemoteDataExchange<T>(IRepository<T> repository) where T : IBrowsableDataObject
        {
            this.InitializeRepository(repository);
            this.InitializeRemoteDataExchange();
        }

        private bool Create()
        {
            CreateTask.ReadAsync().Wait();
            Onliner.DataEntityId.SetAsync(CreateTask.DataEntityIdentifier.LastValue).Wait();
            var cloned = this.Onliner.OnlineToPlainAsync().Result;

            try
            {
                _repository.Create(CreateTask.DataEntityIdentifier.LastValue, cloned);
                return true;
            }
            catch (Exception exception)
            {
                throw exception;
            }
        }

        private bool CreateOrUpdate()
        {
            //_createOrUpdateTask.Read();
            //var id = _createOrUpdateTask._identifier.LastValue;
            //Onliner._EntityId.Synchron = id;
            //if (!this._repository.Exists(id))
            //{                
            //    var cloned = this.Onliner.CreatePlainerType();
            //    this.Onliner.FlushOnlineToPlain(cloned);
            //    try
            //    {
            //        _repository.Create(id, cloned);
            //        return true;
            //    }
            //    catch (Exception exception)
            //    {
            //        throw exception;
            //    }
            //}
            //else
            //{
            //    var cloned = this.Onliner.CreatePlainerType();
            //    this.Onliner.FlushOnlineToPlain(cloned);
            //    _repository.Update(id, cloned);
            //    return true;
            //}
            //
            return true;
        }


        private bool Read()
        {
            ReadTask.ReadAsync().Wait();

            try
            {
                object record = _repository.Read(ReadTask.DataEntityIdentifier.LastValue);
                Onliner.PlainToOnlineAsync(record).Wait();
                return true;
            }
            catch (Exception exception)
            {
                throw exception;
            }
        }
        private bool Update()
        {
            UpdateTask.ReadAsync().Wait();
            Onliner.DataEntityId.SetAsync(UpdateTask.DataEntityIdentifier.LastValue).Wait();
            var cloned = this.Onliner.OnlineToPlainAsync().Result;
            try
            {
                _repository.Update(UpdateTask.DataEntityIdentifier.Cyclic, cloned);
                return true;
            }
            catch (Exception exception)
            {
                throw exception;
            }
        }

        private bool Delete()
        {
            DeleteTask.ReadAsync().Wait();
            try
            {
                _repository.Delete(DeleteTask.DataEntityIdentifier.LastValue);
                return true;
            }
            catch (Exception exception)
            {
                throw exception;
            }
        }

        private bool Exists()
        {
            //_idExistsTask.Read();
            //try
            //{
            //    _idExistsTask._exists.Synchron = _repository.Exists(_idExistsTask._identifier.Cyclic);                
            //    return true;
            //}
            //catch (Exception exception)
            //{
            //    throw exception;
            //}
            return true;
        }

        //private ITwinObject _onlinerVortex;
        //protected ITwinObject OnlinerVortex
        //{
        //    get
        //    {
        //        if (_onlinerVortex == null)
        //        {
        //            _onlinerVortex = (ITwinObject)Onliner;
        //        }

        //        return _onlinerVortex;
        //    }
        //}


    }
}
