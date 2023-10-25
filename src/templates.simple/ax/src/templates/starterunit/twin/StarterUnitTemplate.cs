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
        private StarterUnitTemplate.ProcessDataManager UnitData { get; } = 
            Entry.Plc.Context.StarterUnitTemplateProcessData.CreateBuilder<StarterUnitTemplate.ProcessDataManager>();
        
        private ContextService _contextService { get; }
        

        public static StarterUnitTemplateServices Create(ContextService contextService)
        {
            return new StarterUnitTemplateServices(contextService);
        }

        public void SetUnitsData(IRepository<Pocos.axosimple.StarterUnitTemplate.ProcessData> repository)
        {
            UnitData.Shared.InitializeRemoteDataExchange(_contextService.SharedProcessDataRepository);
            _contextService.ProcessData.StarterUnitTemplate.InitializeRemoteDataExchange(repository);
            
            UnitData.DataManger.InitializeRemoteDataExchange(repository);

            UnitData.InitializeRemoteDataExchange();
        }
    }
}
