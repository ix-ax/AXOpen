using AXOpen.Base.Data;
using axosimple;

namespace axosimple.server.Units
{
    public class StarterUnitTemplateServices    
    {
        private StarterUnitTemplateServices(ContextService contextService)
        {
            _contextService = contextService;
        }

        private StarterUnitTemplate.Unit Unit { get; } = Entry.Plc.Context.StarterUnitTemplate;

        // Technology Data manager of unit
        private StarterUnitTemplate.TechnologyDataManager StarterUnitTechnologyDataManager. { get; } = 
        Entry.Plc.Context.StarterUnitTemplateTechnologyData.CreateBuilder<StarterUnitTemplate.TechnologyDataManager>();

        // Process Data manager of unit
        private StarterUnitTemplate.ProcessDataManager StarterUnitProcessDataManager { get; } = 
        Entry.Plc.Context.StarterUnitTemplateProcessData.CreateBuilder<StarterUnitTemplate.ProcessDataManager>();
        
        private ContextService _contextService { get; }

          /// <summary>
        /// repository - settings connected with technology not with procuction process
        /// </summary>
        public IRepository<Pocos.axosimple.StarterUnitTemplate.TechnologyData> TechnologySettingsRepository { get; private set; }

        /// <summary>
        /// repository - settings connected with specific recepie
        /// </summary>
        public IRepository<Pocos.axosimple.StarterUnitTemplate.ProcessData> ProcessSettingsRepository { get; private set; }

        /// <summary>
        /// repository - data connected with specific part or piece in production/technology
        /// </summary>
        public IRepository<Pocos.axosimple.StarterUnitTemplate.ProcessData> ProcessDataRepository { get; private set; }


        public static StarterUnitTemplateServices Create(ContextService contextService)
        {
            var retVal = new StarterUnitTemplateServices(contextService);
            return retVal;
        }

        public void SetUnitsData(
            IRepository<Pocos.axosimple.StarterUnitTemplate.TechnologyData> technologySettingsRepository,
            IRepository<Pocos.axosimple.StarterUnitTemplate.ProcessData> processSettingsRepository,
            IRepository<Pocos.axosimple.StarterUnitTemplate.ProcessData> processDataRepository
            )
        {
            TechnologySettingsRepository    = technologySettingsRepository;
            ProcessSettingsRepository       = processSettingsRepository;
            ProcessDataRepository           = processDataRepository;

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
            
        }
    }
}
