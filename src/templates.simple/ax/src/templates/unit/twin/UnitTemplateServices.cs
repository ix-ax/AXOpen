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

        // Data manager of unit
        private UnitTemplate.ProcessDataManager UnitData { get; } = 
        Entry.Plc.Context.UnitTemplateProcessData.CreateBuilder<UnitTemplate.ProcessDataManager>();
        
        // Settings data manager for whole technology 
        private UnitTemplate.FragmentProcessDataManger UnitProcessSettings { get; } = 
        Entry.Plc.Context.ProcessSettings.UnitTemplate;
        
        // Production data manager for whole technology 
        private UnitTemplate.FragmentProcessDataManger UnitProcessData { get; } = 
        Entry.Plc.Context.ProcessData.UnitTemplate;
        


        private ContextService _contextService { get; }

          /// <summary>
        /// repository - settings connected with technology
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

            UnitProcessSettings.InitializeRemoteDataExchange(ProcessSettingsRepository); // initialize unit data as a parial part of entire Settings data
            UnitProcessData.InitializeRemoteDataExchange(ProcessDataRepository); // initialize unit data as a parial part of entire production data
            
            UnitData.Shared.InitializeRemoteDataExchange(_contextService.EntityDataRepository);
            _contextService.ProcessData.UnitTemplate.InitializeRemoteDataExchange(ProcessDataRepository);
            
            UnitData.DataManger.InitializeRemoteDataExchange(ProcessDataRepository);
            UnitData.InitializeRemoteDataExchange();
            
        }
    }
}
