using AXOpen.Base.Data;
using AXOpen.Data;
using AXOpen.Data.MongoDb;
using axosimple.server.Units;
using axosimple.StarterUnitTemplate;

namespace axosimple
{
    public class ContextService
    {
        
        private static readonly Lazy<ContextService> lazy = new(() => new ContextService());

        public static ContextService Instance => lazy.Value;
        
        private ContextService()
        {
            SetContextData();
            Entry.Plc.Context.PersistentData.InitializeRemoteDataExchange(Entry.Plc.Context, Repository.Factory<AXOpen.Data.PersistentRecord>(new MongoDbRepositorySettings<PersistentRecord>(DataBaseConnectionString, DataBaseName, "Persistent_Data")));
        }

        private axosimple.Context Context { get; } = Entry.Plc.Context;
        
        public axosimple.ProcessData ProcessData { get; } = Entry.Plc.Context.ProcessData.CreateBuilder<axosimple.ProcessData>();
        public axosimple.ProcessData ProcessSettings { get; } = Entry.Plc.Context.ProcessSettings.CreateBuilder<axosimple.ProcessData>();
        public axosimple.TechnologyData TechnologySettings { get; } = Entry.Plc.Context.TechnologySettings.CreateBuilder<axosimple.TechnologyData>();

        public static string DataBaseConnectionString { get; } = "mongodb://localhost:27017";
        public static string DataBaseName { get; } = "axosimple";


        /// <summary>
        /// repository - settings connected with specific recepie
        /// </summary>
        public IRepository<Pocos.axosimple.TechnologyCommonData> TechnologyCommonRepository { get; } 
            = AXOpen.Data.MongoDb.Repository.Factory<Pocos.axosimple.TechnologyCommonData>(new MongoDbRepositorySettings<Pocos.axosimple.TechnologyCommonData>(DataBaseConnectionString, DataBaseName, "TechnologyCommon_Settings"));

        /// <summary>
        /// repository - settings connected with specific recepie
        /// </summary>
        public IRepository<Pocos.axosimple.EntityData> EntitySettingsRepository { get; } 
            = AXOpen.Data.MongoDb.Repository.Factory<Pocos.axosimple.EntityData>( new MongoDbRepositorySettings<Pocos.axosimple.EntityData>(DataBaseConnectionString, DataBaseName, "Entity_Settings"));

        /// <summary>
        /// repository - data connected with specific part or piece in production/technology
        /// </summary>
        public IRepository<Pocos.axosimple.EntityData> EntityDataRepository { get; } =
            AXOpen.Data.MongoDb.Repository.Factory<Pocos.axosimple.EntityData>(new MongoDbRepositorySettings<Pocos.axosimple.EntityData>(DataBaseConnectionString, DataBaseName, "Entity_Data"));

        public ContextService SetContextData()
        {
           
            ProcessSettings.Entity.InitializeRemoteDataExchange(this.EntitySettingsRepository);
            ProcessSettings.InitializeRemoteDataExchange();

           
            ProcessData.Entity.InitializeRemoteDataExchange(this.EntityDataRepository);
            ProcessData.InitializeRemoteDataExchange();

           
            TechnologySettings.Common.InitializeRemoteDataExchange(this.TechnologyCommonRepository);
            TechnologySettings.InitializeRemoteDataExchange();

            return this;
        }
    }
}