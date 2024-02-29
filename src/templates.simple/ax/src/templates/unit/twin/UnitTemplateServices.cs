using AXOpen.Base.Data;
using AXOpen.Messaging.Static;
using axosimple;
using axosimple.server.Units;
using axosimple.StarterUnitTemplate;
using AXSharp.Connector;

namespace axosimple.UnitTemplate
{
    public partial class Unit
    {
        public UnitTemplateServices Services { get; set; } 
    }
    
    public class UnitTemplateServices : IUnitServices     
    {
        private UnitTemplateServices(ContextService contextService)
        {
            _contextService = contextService;
        }

        public AXOpen.Data.AxoDataEntity? Data { get; } = Entry.Plc.Context.UnitTemplateProcessData.DataManger.Payload;

        public AXOpen.Data.AxoDataEntity? DataHeader { get; } = Entry.Plc.Context.UnitTemplateProcessData.Shared.Entity;

        public AXOpen.Data.AxoDataExchangeBase? DataManger { get; } = Entry.Plc.Context.UnitTemplateProcessData;

        public AXOpen.Data.AxoDataEntity? TechnologySettings { get; } =
            Entry.Plc.Context.UnitTemplateTechnologySettings.Shared.Entity;

        public AXOpen.Data.AxoDataEntity? SharedTechnologySettings { get; } =
            Entry.Plc.Context.UnitTemplateTechnologySettings.DataManger.Payload;

        public AxoObject? UnitComponents => Entry.Plc.Context.UnitTemplateComponents;
        
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

        
        public axosimple.BaseUnit.UnitBase Unit { get; } = Entry.Plc.Context.UnitTemplate;

        // Technology Data manager of unit
        private UnitTemplate.TechnologyDataManager UnitTechnologyDataManager { get; } = 
        Entry.Plc.Context.UnitTemplateTechnologySettings.CreateBuilder<UnitTemplate.TechnologyDataManager>();

        // Process Data manager of unit
        private UnitTemplate.ProcessDataManager UnitProcessDataManager { get; } = 
        Entry.Plc.Context.UnitTemplateProcessData.CreateBuilder<UnitTemplate.ProcessDataManager>();
        
        private ContextService _contextService { get; }

          /// <summary>
        /// repository - settings connected with technology not with procuction process
        /// </summary>
        public IRepository<Pocos.axosimple.UnitTemplate.TechnologyData> TechnologySettingsRepository { get; private set; }

        /// <summary>
        /// repository - settings connected with specific recepie
        /// </summary>
        public IRepository<Pocos.axosimple.UnitTemplate.ProcessData> ProcessSettingsRepository { get; private set; }

        /// <summary>
        /// repository - data connected with specific part or piece in production/technology
        /// </summary>
        public IRepository<Pocos.axosimple.UnitTemplate.ProcessData> ProcessDataRepository { get; private set; }


        public static UnitTemplateServices Create(ContextService contextService)
        {
            var retVal = new UnitTemplateServices(contextService);
            retVal.Unit.UnitServices = retVal;
            return retVal;
        }

        public UnitTemplateServices SetUnitsData(
            IRepository<Pocos.axosimple.UnitTemplate.TechnologyData> technologySettingsRepository,
            IRepository<Pocos.axosimple.UnitTemplate.ProcessData> processSettingsRepository,
            IRepository<Pocos.axosimple.UnitTemplate.ProcessData> processDataRepository
            )
        {
            TechnologySettingsRepository    = technologySettingsRepository;
            ProcessSettingsRepository       = processSettingsRepository;
            ProcessDataRepository           = processDataRepository;

            // initialize partial repositories in global context
            _contextService.TechnologySettings.UnitTemplate.InitializeRemoteDataExchange(TechnologySettingsRepository);
            _contextService.ProcessSettings.UnitTemplate.InitializeRemoteDataExchange(ProcessSettingsRepository);
            _contextService.ProcessData.UnitTemplate.InitializeRemoteDataExchange(ProcessDataRepository);
            
            // initialize unit process data manager
            UnitProcessDataManager.Shared.InitializeRemoteDataExchange(_contextService.EntityDataRepository);
            UnitProcessDataManager.DataManger.InitializeRemoteDataExchange(ProcessDataRepository);
            UnitProcessDataManager.InitializeRemoteDataExchange();
            
            // initialize unit technology data manager
            UnitTechnologyDataManager.Shared.InitializeRemoteDataExchange(_contextService.TechnologyCommonRepository);
            UnitTechnologyDataManager.DataManger.InitializeRemoteDataExchange(TechnologySettingsRepository);
            UnitTechnologyDataManager.InitializeRemoteDataExchange();

            return this;
        }
        
        public string Link => "Context/Units/UnitTemplate";
        
        public string ImageLink => "logo-axopen-no-background.svg";
    }
}
