using AXOpen.Base.Data;
using axosimple;

namespace axosimple.server.Units
{
    public class UnitTemplateServices    
    {
        private UnitTemplateServices(ContextService contextService)
        {
            _contextService = contextService;
        }

        private UnitTemplate.Unit Unit { get; } = Entry.Plc.Context.UnitTemplate;

        // Technology Data manager of unit
        private UnitTemplate.TechnologyDataManager UnitTechnologyDataManager { get; } = 
        Entry.Plc.Context.UnitTechnologyData.CreateBuilder<UnitTemplate.TechnologyDataManager>();

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
            return retVal;
        }

        public void SetUnitsData(
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
            UnitTechnologyDataManager.Common.InitializeRemoteDataExchange(_contextService.TechnologyCommonRepository);
            UnitTechnologyDataManager.DataManger.InitializeRemoteDataExchange(TechnologySettingsRepository);
            UnitTechnologyDataManager.InitializeRemoteDataExchange();
            
        }
    }
}
