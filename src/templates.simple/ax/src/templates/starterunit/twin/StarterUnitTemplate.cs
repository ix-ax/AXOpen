using AXOpen.Base.Data;
using AXOpen.Data.MongoDb;
using AXOpen.Messaging.Static;
using axosimple.server.Units;
using AXSharp.Connector;


namespace axosimple.StarterUnitTemplate
{
    public partial class Unit
    {
        public UnitServices Services { get; } 
    }
    
    public class UnitServices : IUnitServices
    {
        private UnitServices(ContextService contextService)
        {
            _contextService = contextService;
        }
        
        public AXOpen.Data.AxoDataEntity? Data { get; } = Entry.Plc.Context.StarterUnitTemplateProcessData.DataManger.Payload;

        public AXOpen.Data.AxoDataEntity? DataHeader { get; } = Entry.Plc.Context.StarterUnitTemplateProcessData.Shared.Entity;

        public AXOpen.Data.AxoDataExchangeBase? DataManger { get; } = Entry.Plc.Context.StarterUnitTemplateProcessData;

        public AXOpen.Data.AxoDataEntity? TechnologySettings { get; } =
            Entry.Plc.Context.StarterUnitTemplateTechnologySettings.Shared.Entity;

        public AXOpen.Data.AxoDataEntity? SharedTechnologySettings { get; } =
            Entry.Plc.Context.StarterUnitTemplateTechnologySettings.DataManger.Payload;

        public AxoObject? UnitComponents => Entry.Plc.Context.StarterUnitTemplateComponents;
        
        public ITwinObject[] Associates => new ITwinObject[]
        {
            SharedTechnologySettings,
            TechnologySettings,
            DataManger,
            Data,
            DataHeader,
            UnitComponents,
            Entry.Plc.Context.Safety.Zone_1, 
            Entry.Plc.Context.Safety.Zone_2
        };

        private AxoMessageProvider _messageProvider;
        
        public AxoMessageProvider MessageProvider
        {
            get
            {
                if (_messageProvider == null)
                {
                    _messageProvider = AxoMessageProvider.Create(Associates);
                }

                return _messageProvider;
            }
        }

        public axosimple.BaseUnit.UnitBase Unit { get; } = Entry.Plc.Context.StarterUnitTemplate;

        // Technology Data manager of unit
        private StarterUnitTemplate.TechnologyDataManager StarterUnitTechnologyDataManager { get; } = 
        Entry.Plc.Context.StarterUnitTemplateTechnologySettings.CreateBuilder<StarterUnitTemplate.TechnologyDataManager>();

        // Process Data manager of unit
        private StarterUnitTemplate.ProcessDataManager StarterUnitProcessDataManager { get; } = 
        Entry.Plc.Context.StarterUnitTemplateProcessData.CreateBuilder<StarterUnitTemplate.ProcessDataManager>();
        
        private ContextService _contextService { get; }

        /// <summary>
        /// repository - settings connected with technology not with procuction process
        /// </summary>
        public IRepository<Pocos.axosimple.StarterUnitTemplate.TechnologyData> TechnologySettingsRepository { get; } 
            = AXOpen.Data.MongoDb.Repository.Factory<Pocos.axosimple.StarterUnitTemplate.TechnologyData>(
                new MongoDbRepositorySettings<Pocos.axosimple.StarterUnitTemplate.TechnologyData>(
                    ContextService.DataBaseConnectionString, ContextService.DataBaseName, "StarterUnitTemplate_TechnologySettings"));

        /// <summary>
        /// repository - settings connected with specific recepie
        /// </summary>
        public IRepository<Pocos.axosimple.StarterUnitTemplate.ProcessData> ProcessSettingsRepository { get; } 
            = AXOpen.Data.MongoDb.Repository.Factory<Pocos.axosimple.StarterUnitTemplate.ProcessData>(
                new MongoDbRepositorySettings<Pocos.axosimple.StarterUnitTemplate.ProcessData>(ContextService.DataBaseConnectionString, ContextService.DataBaseName, "StarterUnitTemplate_ProcessSettings"));

        /// <summary>
        /// repository - data connected with specific part or piece in production/technology
        /// </summary>
        public IRepository<Pocos.axosimple.StarterUnitTemplate.ProcessData> ProcessDataRepository { get; } 
            = AXOpen.Data.MongoDb.Repository.Factory<Pocos.axosimple.StarterUnitTemplate.ProcessData>(new MongoDbRepositorySettings<Pocos.axosimple.StarterUnitTemplate.ProcessData>(ContextService.DataBaseConnectionString, ContextService.DataBaseName, "StarterUnitTemplate_ProcessData"));


        public static UnitServices Create(ContextService contextService)
        {
            var retVal = new UnitServices(contextService);
            retVal.Unit.UnitServices = retVal;
            retVal.SetUnitsData();
            return retVal;
        }

        // public StarterUnitTemplateServices SetUnitsData(
        //     IRepository<Pocos.axosimple.StarterUnitTemplate.TechnologyData> technologySettingsRepository,
        //     IRepository<Pocos.axosimple.StarterUnitTemplate.ProcessData> processSettingsRepository,
        //     IRepository<Pocos.axosimple.StarterUnitTemplate.ProcessData> processDataRepository
        //     )
        // {
        //     TechnologySettingsRepository    = technologySettingsRepository;
        //     ProcessSettingsRepository       = processSettingsRepository;
        //     ProcessDataRepository           = processDataRepository;
        //
        //     // initialize partial repositories in global context
        //     _contextService.TechnologySettings.StarterUnitTemplate.InitializeRemoteDataExchange(TechnologySettingsRepository);
        //     _contextService.ProcessSettings.StarterUnitTemplate.InitializeRemoteDataExchange(ProcessSettingsRepository);
        //     _contextService.ProcessData.StarterUnitTemplate.InitializeRemoteDataExchange(ProcessDataRepository);
        //     
        //     // initialize unit process data manager
        //     StarterUnitProcessDataManager.Shared.InitializeRemoteDataExchange(_contextService.EntityDataRepository);
        //     StarterUnitProcessDataManager.DataManger.InitializeRemoteDataExchange(ProcessDataRepository);
        //     StarterUnitProcessDataManager.InitializeRemoteDataExchange();
        //     
        //     // initialize unit technology data manager
        //     StarterUnitTechnologyDataManager.Shared.InitializeRemoteDataExchange(_contextService.TechnologyCommonRepository);
        //     StarterUnitTechnologyDataManager.DataManger.InitializeRemoteDataExchange(TechnologySettingsRepository);
        //     StarterUnitTechnologyDataManager.InitializeRemoteDataExchange();
        //
        //     return this;
        //
        // }

        private UnitServices SetUnitsData()
        {
            // initialize partial repositories in global context
            _contextService.TechnologySettings.StarterUnitTemplate.InitializeRemoteDataExchange(TechnologySettingsRepository);
            _contextService.ProcessSettings.StarterUnitTemplate.InitializeRemoteDataExchange(ProcessSettingsRepository);
            _contextService.ProcessData.StarterUnitTemplate.InitializeRemoteDataExchange(ProcessDataRepository);
            
            // initialize unit process data manager
            StarterUnitProcessDataManager.Shared.InitializeRemoteDataExchange(_contextService.EntityDataRepository);
            StarterUnitProcessDataManager.DataManger.InitializeRemoteDataExchange(ProcessDataRepository);
            StarterUnitProcessDataManager.InitializeRemoteDataExchange();
            
            // initialize unit technology data manager
            StarterUnitTechnologyDataManager.Shared.InitializeRemoteDataExchange(_contextService.TechnologyCommonRepository);
            StarterUnitTechnologyDataManager.DataManger.InitializeRemoteDataExchange(TechnologySettingsRepository);
            StarterUnitTechnologyDataManager.InitializeRemoteDataExchange();

            return this;

        }
        
        public string Link => "Context/StarterUnitTemplate";

        public string ImageLink => "logo-header.svg";
    }
}
